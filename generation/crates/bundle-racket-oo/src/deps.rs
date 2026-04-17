//! Walk a `(require ...)` tree to find every `.rkt` file an entry script
//! transitively pulls in.
//!
//! Racket modules use literal string paths inside `(require ...)` for
//! filesystem-relative imports. Symbol forms (`ffi/unsafe`,
//! `racket/contract`, `(rename-in racket/contract ...)`) are collection
//! references and don't translate to file paths — those are skipped.
//!
//! The walker is intentionally tiny: it scans for string literals matching
//! `"...\.rkt"` anywhere in the source. In a normal racket-oo file that
//! pattern only ever appears inside a `require` form, so a full s-expr
//! parser would be over-engineering. Strings that contain `.rkt` for
//! reasons other than file imports would be a false positive — the
//! racket-oo emitter doesn't produce any.

use std::collections::HashSet;
use std::fs;
use std::path::{Path, PathBuf};

use crate::bundle::BundleError;

/// Transitive set of `.rkt` files reachable from `entry`, all resolved as
/// canonical absolute paths under `source_root`.
///
/// `source_root` is the directory the generated bundle's `racket-app/`
/// will mirror — for racket-oo that's `generation/targets/racket-oo/`.
/// Any discovered file that escapes that root is rejected as a
/// bundle-layout error.
pub fn collect_dependencies(
    entry: &Path,
    source_root: &Path,
) -> Result<HashSet<PathBuf>, BundleError> {
    let canonical_root = source_root
        .canonicalize()
        .map_err(|e| BundleError::ResolveSourceRoot(source_root.to_path_buf(), e))?;
    let canonical_entry = entry
        .canonicalize()
        .map_err(|e| BundleError::ResolveEntry(entry.to_path_buf(), e))?;

    if !canonical_entry.starts_with(&canonical_root) {
        return Err(BundleError::EntryOutsideRoot {
            entry: canonical_entry,
            root: canonical_root,
        });
    }

    let mut visited: HashSet<PathBuf> = HashSet::new();
    let mut queue: Vec<PathBuf> = vec![canonical_entry];

    while let Some(file) = queue.pop() {
        if !visited.insert(file.clone()) {
            continue;
        }

        let content =
            fs::read_to_string(&file).map_err(|e| BundleError::ReadSource(file.clone(), e))?;
        let parent = file.parent().expect("source file has parent");

        for raw in scan_rkt_string_literals(&content) {
            let candidate = parent.join(raw);
            let resolved = candidate
                .canonicalize()
                .map_err(|e| BundleError::ResolveRequire {
                    referrer: file.clone(),
                    target: raw.to_string(),
                    source: e,
                })?;

            if !resolved.starts_with(&canonical_root) {
                return Err(BundleError::RequireOutsideRoot {
                    referrer: file.clone(),
                    target: resolved,
                    root: canonical_root.clone(),
                });
            }

            queue.push(resolved);
        }
    }

    Ok(visited)
}

/// Find every double-quoted string literal in `content` ending in `.rkt`.
///
/// State machine over chars: tracks whether we're inside a `";`...`"` and
/// whether the previous char was `\` (escape). Returns the inner contents
/// of every literal whose tail is `.rkt`. Handles `\"` and `\\` escapes;
/// leaves the rest alone since Racket string literals don't carry
/// language-meaningful escapes inside file paths.
fn scan_rkt_string_literals(content: &str) -> Vec<&str> {
    let bytes = content.as_bytes();
    let mut out = Vec::new();
    let mut i = 0;
    let n = bytes.len();
    while i < n {
        if bytes[i] == b'"' {
            // Skip a comment-like ; line OR a #; literal — for our use the
            // commented lines won't trip us because they'd be syntactically
            // invalid Racket if they contained an unterminated string. Keep
            // it simple and start the literal scan immediately.
            let start = i + 1;
            let mut j = start;
            let mut escaped = false;
            while j < n {
                let c = bytes[j];
                if escaped {
                    escaped = false;
                } else if c == b'\\' {
                    escaped = true;
                } else if c == b'"' {
                    break;
                }
                j += 1;
            }
            if j < n {
                let lit = &content[start..j];
                if lit.ends_with(".rkt") {
                    out.push(lit);
                }
                i = j + 1;
                continue;
            }
        }
        i += 1;
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use tempfile::TempDir;

    fn write(dir: &Path, rel: &str, content: &str) -> PathBuf {
        let p = dir.join(rel);
        fs::create_dir_all(p.parent().unwrap()).unwrap();
        fs::write(&p, content).unwrap();
        p
    }

    #[test]
    fn scans_string_literals_ending_in_rkt() {
        let lits = scan_rkt_string_literals(
            r#"(require ffi/unsafe
                       "../runtime/objc-base.rkt"
                       "../runtime/coerce.rkt")"#,
        );
        assert_eq!(
            lits,
            vec!["../runtime/objc-base.rkt", "../runtime/coerce.rkt"]
        );
    }

    #[test]
    fn ignores_strings_without_rkt_extension() {
        let lits = scan_rkt_string_literals(r#"(displayln "hello world")"#);
        assert!(lits.is_empty());
    }

    #[test]
    fn ignores_collection_paths() {
        // ffi/unsafe is a symbol, not a string — never picked up.
        let lits = scan_rkt_string_literals("(require ffi/unsafe racket/format)");
        assert!(lits.is_empty());
    }

    #[test]
    fn handles_multiple_requires() {
        let lits = scan_rkt_string_literals(
            r#"(require "a.rkt")
               (require "b.rkt" "c.rkt")"#,
        );
        assert_eq!(lits, vec!["a.rkt", "b.rkt", "c.rkt"]);
    }

    #[test]
    fn handles_escaped_quotes() {
        // Path contains a literal escaped quote — not realistic, but we
        // shouldn't trip on it.
        let lits = scan_rkt_string_literals(r#"(require "weird\"name.rkt" "normal.rkt")"#);
        assert_eq!(lits, vec![r#"weird\"name.rkt"#, "normal.rkt"]);
    }

    #[test]
    fn collect_walks_transitively() {
        let dir = TempDir::new().unwrap();
        let root = dir.path();

        write(root, "apps/my/my.rkt", r#"(require "../../runtime/a.rkt")"#);
        write(
            root,
            "runtime/a.rkt",
            r#"(require "b.rkt" "../generated/c.rkt")"#,
        );
        write(root, "runtime/b.rkt", "");
        write(root, "generated/c.rkt", "");

        let entry = root.join("apps/my/my.rkt");
        let deps = collect_dependencies(&entry, root).unwrap();
        let canonical_root = root.canonicalize().unwrap();

        let mut names: Vec<String> = deps
            .iter()
            .map(|p| {
                p.strip_prefix(&canonical_root)
                    .unwrap()
                    .to_string_lossy()
                    .into_owned()
            })
            .collect();
        names.sort();
        assert_eq!(
            names,
            vec![
                "apps/my/my.rkt".to_string(),
                "generated/c.rkt".to_string(),
                "runtime/a.rkt".to_string(),
                "runtime/b.rkt".to_string(),
            ]
        );
    }

    #[test]
    fn collect_handles_cycles() {
        let dir = TempDir::new().unwrap();
        let root = dir.path();

        write(root, "a.rkt", r#"(require "b.rkt")"#);
        write(root, "b.rkt", r#"(require "a.rkt")"#);

        let deps = collect_dependencies(&root.join("a.rkt"), root).unwrap();
        assert_eq!(deps.len(), 2);
    }

    #[test]
    fn collect_rejects_requires_outside_root() {
        let dir = TempDir::new().unwrap();
        let root = dir.path().join("project");
        let outside = dir.path().join("other");
        fs::create_dir_all(&root).unwrap();
        fs::create_dir_all(&outside).unwrap();

        write(&outside, "x.rkt", "");
        write(&root, "entry.rkt", r#"(require "../other/x.rkt")"#);

        let err = collect_dependencies(&root.join("entry.rkt"), &root).unwrap_err();
        match err {
            BundleError::RequireOutsideRoot { .. } => {}
            other => panic!("expected RequireOutsideRoot, got {other:?}"),
        }
    }
}
