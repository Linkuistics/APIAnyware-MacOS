//! Runtime load verification — exercises the *acceptance* contract that
//! snapshot tests cannot: that emitted files actually load in Racket.
//!
//! Two complementary patterns:
//!  - **Libraries** via `racket -e '(dynamic-require ... #f)'`: class wrappers,
//!    protocol files, `functions.rkt`, `constants.rkt` across multiple
//!    frameworks. Library files have no side-effectful top-level so
//!    `dynamic-require` is the right signal.
//!  - **Apps** via `raco make`: app top-levels call `nsapplication-run`, so
//!    `dynamic-require` would block on a window. `raco make` compiles the
//!    full require graph without instantiating the body — exactly "do the
//!    imports resolve and the imported modules compile?".
//!
//! Motivation, from memory.md: the `provide/contract` migration landed green
//! with every text-level snapshot passing while *no emitted file actually
//! loaded in Racket* — six load-time failures slipped through in sequence
//! (`->` require conflict, `exact-nonneg-integer?` typo, missing cstruct
//! provides, missing `type-mapping.rkt` require in functions/constants,
//! missing `ffi/unsafe/objc` require, preprocessor-macros-as-symbols leak).
//! This harness closes that gap, and additionally validates the recent core
//! filter fixes (internal-linkage in extract-objc, `s:` and `c:@macro@` USR
//! families in extract-swift) by loading the symbol surfaces those filters
//! cleaned up: Foundation/CoreGraphics functions+constants and CoreText
//! constants.
//!
//! Skip behavior:
//!  - SKIPPED if `racket` or `raco` is not on PATH
//!  - SKIPPED if enriched IR is missing for a required framework
//!  - SKIPPED unless `RUNTIME_LOAD_TEST=1` (slow test gated out of default
//!    `cargo test` runs; same opt-in pattern as `UPDATE_GOLDEN=1`).

use std::path::{Path, PathBuf};
use std::process::Command;

use apianyware_macos_emit::binding_style::{BindingStyle, LanguageEmitter};
use apianyware_macos_emit_racket_oo::emit_framework::RacketEmitter;
use apianyware_macos_types::ir::Framework;

const RUNTIME_FILES: &[&str] = &[
    "app-menu.rkt",
    "ax-helpers.rkt",
    "block.rkt",
    "cf-bridge.rkt",
    "cgevent-helpers.rkt",
    "coerce.rkt",
    "delegate.rkt",
    "dynamic-class.rkt",
    "main-thread.rkt",
    "nsevent-helpers.rkt",
    "nsview-helpers.rkt",
    "objc-base.rkt",
    "objc-interop.rkt",
    "spi-helpers.rkt",
    "swift-helpers.rkt",
    "type-mapping.rkt",
    "variadic-helpers.rkt",
];

const REQUIRED_FRAMEWORKS: &[&str] = &[
    "Foundation",
    "AppKit",
    "AudioToolbox",
    "CoreGraphics",
    "CoreSpotlight",
    "CoreText",
    "ApplicationServices",
    "libdispatch",
    "Network",
    "NetworkExtension",
    "PDFKit",
    "SceneKit",
    "WebKit",
];

const APPS: &[&str] = &[
    "hello-window",
    "counter",
    "ui-controls-gallery",
    "file-lister",
    "drawing-canvas",
    "pdfkit-viewer",
    "scenekit-viewer",
    "mini-browser",
];

/// Library files exercised via `dynamic-require`. Each entry is a path
/// under the harness tempdir root, chosen to cover one distinct dimension:
///
/// 1. Class wrapper — `../../../runtime/` relative path resolution.
/// 2. Protocol file — `../../../../runtime/` (one level deeper than classes).
/// 3. Foundation `constants.rkt` — exercises both extract-objc's
///    internal-linkage filter (NSHashTableCopyIn et al) and extract-swift's
///    `s:` USR-family filter (NSLocalizedString, NSNotFound).
/// 4. Foundation `functions.rkt` — same filters, different binding kind.
/// 5. CoreGraphics `functions.rkt` — geometry-struct require + the largest
///    single population of `s:`-prefix Swift-native filtered symbols (46).
/// 6. CoreText `constants.rkt` — the highest-population framework for the
///    `c:@macro@` filter (15 of the 30 macro symbols cleared by the
///    2026-04-13 core fix).
/// 7. AppKit `nsmenuitem.rkt` — canary for class-method (static) property
///    setters (`+[NSMenuItem usesUserKeyEquivalents]`/
///    `+[NSMenuItem setUsesUserKeyEquivalents:]`). A prior arity-mismatch
///    regression between the impl and its `provide/contract` entry was
///    invisible to snapshot tests because TestKit has no class-method
///    properties; this check makes the harness fail on any recurrence.
/// 11. `runtime/dynamic-class.rkt` — curated libobjc bridge for runtime
///     subclass construction. Hand-written runtime file, not generated;
///     listed here so its `get-ffi-obj` chain against libobjc is exercised
///     at harness time rather than only when a sample app subclasses an
///     ObjC class. Catches drift in libobjc symbol availability.
/// 12. `audiotoolbox/constants.rkt` — covers the platform-unavailable
///     extern leak surfaced by Modaliser-Racket and closed 2026-04-13. The
///     framework's constants surface was previously broken at load time
///     because dylib-unexported externs reached the IR; this check is the
///     long-term canary that the leak does not return.
/// 13. `networkextension/constants.rkt` and `network/constants.rkt` —
///     the canary frameworks for the anonymous-enum-as-constant filter
///     (`c:@Ea@…`); both broke load with `nw_browse_result_change_identical`
///     leakage before the filter landed earlier in 2026-04.
/// 14. `corespotlight/constants.rkt` — the canary for the skipped_symbols
///     "leak" that turned out to be stale downstream checkpoints
///     (CoreSpotlightAPIVersion canary), confirmed clean against fresh IR
///     2026-04-13.
const LIBRARY_LOAD_CHECKS: &[&str] = &[
    "generated/oo/foundation/nsstring.rkt",
    "generated/oo/foundation/protocols/nscopying.rkt",
    "generated/oo/foundation/constants.rkt",
    "generated/oo/foundation/functions.rkt",
    "generated/oo/coregraphics/functions.rkt",
    "generated/oo/coretext/constants.rkt",
    "generated/oo/appkit/nsmenuitem.rkt",
    "generated/oo/appkit/nsevent.rkt",
    "generated/oo/appkit/nsscreen.rkt",
    "generated/oo/webkit/wkwebview.rkt",
    "generated/oo/applicationservices/functions.rkt",
    "generated/oo/libdispatch/functions.rkt",
    "generated/oo/libdispatch/constants.rkt",
    "generated/oo/audiotoolbox/constants.rkt",
    "generated/oo/networkextension/constants.rkt",
    "generated/oo/network/constants.rkt",
    "generated/oo/corespotlight/constants.rkt",
    "runtime/dynamic-class.rkt",
    "runtime/nsevent-helpers.rkt",
    "runtime/nsview-helpers.rkt",
    "runtime/cf-bridge.rkt",
    "runtime/ax-helpers.rkt",
    "runtime/cgevent-helpers.rkt",
    "runtime/objc-interop.rkt",
    "runtime/spi-helpers.rkt",
];

fn crate_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

fn project_root() -> PathBuf {
    crate_root()
        .ancestors()
        .nth(3)
        .expect("project root above emit-racket-oo crate")
        .to_path_buf()
}

fn target_root() -> PathBuf {
    project_root()
        .join("generation")
        .join("targets")
        .join("racket-oo")
}

fn enriched_dir() -> PathBuf {
    project_root().join("analysis").join("ir").join("enriched")
}

fn binary_on_path(name: &str, probe_arg: &str) -> bool {
    Command::new(name)
        .arg(probe_arg)
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn load_framework(name: &str) -> Option<Framework> {
    let path = enriched_dir().join(format!("{name}.json"));
    let json = std::fs::read_to_string(&path).ok()?;
    serde_json::from_str(&json).ok()
}

fn load_required_frameworks() -> Result<Vec<Framework>, String> {
    let mut out = Vec::with_capacity(REQUIRED_FRAMEWORKS.len());
    for name in REQUIRED_FRAMEWORKS {
        match load_framework(name) {
            Some(fw) => out.push(fw),
            None => return Err((*name).to_string()),
        }
    }
    Ok(out)
}

fn copy_runtime(dest_runtime: &Path) -> std::io::Result<()> {
    let src = target_root().join("runtime");
    std::fs::create_dir_all(dest_runtime)?;
    for name in RUNTIME_FILES {
        std::fs::copy(src.join(name), dest_runtime.join(name))?;
    }
    Ok(())
}

fn copy_lib(dest_lib: &Path) -> std::io::Result<()> {
    let src = target_root().join("lib").join("libAPIAnywareRacket.dylib");
    if !src.exists() {
        return Ok(());
    }
    std::fs::create_dir_all(dest_lib)?;
    std::fs::copy(src, dest_lib.join("libAPIAnywareRacket.dylib"))?;
    Ok(())
}

fn copy_app(dest_apps: &Path, name: &str) -> std::io::Result<()> {
    let src = target_root()
        .join("apps")
        .join(name)
        .join(format!("{name}.rkt"));
    let dest_app_dir = dest_apps.join(name);
    std::fs::create_dir_all(&dest_app_dir)?;
    std::fs::copy(src, dest_app_dir.join(format!("{name}.rkt")))?;
    Ok(())
}

fn emit_framework(emitter: &RacketEmitter, fw: &Framework, oo_dir: &Path) {
    emitter
        .emit_framework(fw, oo_dir, BindingStyle::ObjectOriented)
        .unwrap_or_else(|e| panic!("emit {} failed: {e}", fw.name));
}

/// Build a hermetic target tree under `root` containing runtime, lib,
/// generated framework output, and copies of the sample apps.
fn build_harness_tree(root: &Path, frameworks: &[Framework]) {
    copy_runtime(&root.join("runtime")).expect("copy runtime");
    copy_lib(&root.join("lib")).expect("copy lib");

    let oo_dir = root.join("generated").join("oo");
    std::fs::create_dir_all(&oo_dir).expect("create oo dir");
    let emitter = RacketEmitter;
    for fw in frameworks {
        emit_framework(&emitter, fw, &oo_dir);
    }

    let apps_dir = root.join("apps");
    std::fs::create_dir_all(&apps_dir).expect("create apps dir");
    for app in APPS {
        copy_app(&apps_dir, app).expect("copy app");
    }
}

fn skip_unless_enabled(test_name: &str) -> bool {
    if std::env::var_os("RUNTIME_LOAD_TEST").is_none() {
        eprintln!(
            "SKIPPED: {test_name} (set RUNTIME_LOAD_TEST=1 to enable; \
             this test regenerates 4 frameworks and shells out to racket/raco)"
        );
        return true;
    }
    if !binary_on_path("racket", "--version") {
        eprintln!("SKIPPED: {test_name} (racket not found on PATH)");
        return true;
    }
    // `raco` has no --version flag; `raco help` prints usage and exits 0.
    if !binary_on_path("raco", "help") {
        eprintln!("SKIPPED: {test_name} (raco not found on PATH)");
        return true;
    }
    false
}

#[test]
fn runtime_load_libraries_via_dynamic_require() {
    if skip_unless_enabled("runtime_load_libraries_via_dynamic_require") {
        return;
    }

    let frameworks = match load_required_frameworks() {
        Ok(fws) => fws,
        Err(missing) => {
            eprintln!(
                "SKIPPED: enriched IR not found for {missing}. \
                 Run the analysis pipeline first."
            );
            return;
        }
    };

    let temp = tempfile::tempdir().expect("tempdir");
    build_harness_tree(temp.path(), &frameworks);

    let abs_paths: Vec<String> = LIBRARY_LOAD_CHECKS
        .iter()
        .map(|p| temp.path().join(p).to_string_lossy().to_string())
        .collect();

    // Build a small racket script that dynamic-requires each path under an
    // exn:fail? handler, collects every failure rather than first-fail, and
    // prints a per-path report. Single racket startup amortises load cost
    // across all checks.
    let mut script =
        String::from("#lang racket/base\n(require racket/list)\n(define checks (list\n");
    for path in &abs_paths {
        script.push_str(&format!("  {}\n", racket_string_literal(path)));
    }
    script.push_str("))\n");
    script.push_str(
        "(define failures\n\
         \x20 (for/list ([p (in-list checks)])\n\
         \x20   (with-handlers ([exn:fail? (lambda (e) (cons p (exn-message e)))])\n\
         \x20     (dynamic-require `(file ,p) #f)\n\
         \x20     #f)))\n\
         (define real-failures (filter values failures))\n\
         (cond\n\
         \x20 [(null? real-failures)\n\
         \x20  (printf \"OK: ~a library load checks passed~n\" (length checks))]\n\
         \x20 [else\n\
         \x20  (printf \"FAIL: ~a of ~a library load checks failed~n\"\n\
         \x20    (length real-failures) (length checks))\n\
         \x20  (for ([f (in-list real-failures)])\n\
         \x20    (printf \"  - ~a:~n    ~a~n\" (car f) (cdr f)))\n\
         \x20  (exit 1)])\n",
    );

    let script_path = temp.path().join("__load_check.rkt");
    std::fs::write(&script_path, script).expect("write load script");

    let output = Command::new("racket")
        .arg(&script_path)
        .output()
        .expect("invoke racket");

    if !output.status.success() {
        panic!(
            "library dynamic-require checks failed.\n--- stdout ---\n{}\n--- stderr ---\n{}",
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr),
        );
    }

    eprintln!("{}", String::from_utf8_lossy(&output.stdout).trim_end());
}

#[test]
fn runtime_load_apps_via_raco_make() {
    if skip_unless_enabled("runtime_load_apps_via_raco_make") {
        return;
    }

    let frameworks = match load_required_frameworks() {
        Ok(fws) => fws,
        Err(missing) => {
            eprintln!(
                "SKIPPED: enriched IR not found for {missing}. \
                 Run the analysis pipeline first."
            );
            return;
        }
    };

    let temp = tempfile::tempdir().expect("tempdir");
    build_harness_tree(temp.path(), &frameworks);

    // Single raco make invocation for all apps — amortises racket startup
    // and exercises the full require graph (runtime/, generated/oo/, plus
    // any additional cross-framework imports the apps pull in).
    let mut cmd = Command::new("raco");
    cmd.arg("make");
    for app in APPS {
        let app_path = temp
            .path()
            .join("apps")
            .join(app)
            .join(format!("{app}.rkt"));
        cmd.arg(app_path);
    }

    let output = cmd.output().expect("invoke raco");

    if !output.status.success() {
        panic!(
            "raco make for sample apps failed.\n--- stdout ---\n{}\n--- stderr ---\n{}",
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr),
        );
    }

    eprintln!(
        "OK: raco make compiled {} sample apps ({})",
        APPS.len(),
        APPS.join(", ")
    );
}

#[test]
fn runtime_block_nil_guard() {
    if skip_unless_enabled("runtime_block_nil_guard") {
        return;
    }

    let temp = tempfile::tempdir().expect("tempdir");
    copy_runtime(&temp.path().join("runtime")).expect("copy runtime");
    copy_lib(&temp.path().join("lib")).expect("copy lib");

    let script = "\
#lang racket/base
(require ffi/unsafe \"runtime/block.rkt\")

;; Test 1: make-objc-block with #f returns (values #f #f) — no live block wrapper
(define-values (block-ptr block-id)
  (make-objc-block #f (list) _void))
(unless (and (not block-ptr) (not block-id))
  (eprintf \"FAIL: make-objc-block #f should return (values #f #f), got ~a ~a~n\" block-ptr block-id)
  (exit 1))

;; Test 2: the returned block-ptr must be usable as a NULL _pointer FFI arg.
;; A live wrapper would be a cpointer satisfying cpointer?; #f passes through
;; FFI as NULL. This verifies no block was constructed at all.
(unless (eq? block-ptr #f)
  (eprintf \"FAIL: block-ptr must be exactly #f (NULL), not a live wrapper; got ~a~n\" block-ptr)
  (exit 1))

;; Test 3: free-objc-block with #f is a no-op
(free-objc-block #f)

;; Test 4: call-with-objc-block with #f passes #f to body
(define-values (result cb-id)
  (call-with-objc-block #f (list) _void (lambda (bp) bp)))
(unless (and (not result) (not cb-id))
  (eprintf \"FAIL: call-with-objc-block #f should yield #f, got ~a ~a~n\" result cb-id)
  (exit 1))

;; Test 5: normal path still works — a real proc yields a live wrapper
(define invoked? #f)
(define-values (real-block real-id)
  (make-objc-block (lambda () (set! invoked? #t)) (list) _void))
(unless (cpointer? real-block)
  (eprintf \"FAIL: real block should be cpointer?, got ~a~n\" real-block)
  (exit 1))
(unless (exact-integer? real-id)
  (eprintf \"FAIL: real block-id should be integer, got ~a~n\" real-id)
  (exit 1))
(free-objc-block real-id)

(printf \"OK: make-objc-block nil guard — 5 checks passed~n\")
";

    let script_path = temp.path().join("__nil_guard_test.rkt");
    std::fs::write(&script_path, script).expect("write nil guard test script");

    let output = Command::new("racket")
        .arg(&script_path)
        .output()
        .expect("invoke racket");

    if !output.status.success() {
        panic!(
            "make-objc-block nil guard test failed.\n--- stdout ---\n{}\n--- stderr ---\n{}",
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr),
        );
    }

    eprintln!("{}", String::from_utf8_lossy(&output.stdout).trim_end());
}

/// Encode a Rust string as a Racket string literal, escaping `"` and `\`.
fn racket_string_literal(s: &str) -> String {
    let mut out = String::with_capacity(s.len() + 2);
    out.push('"');
    for c in s.chars() {
        match c {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            _ => out.push(c),
        }
    }
    out.push('"');
    out
}
