//! Assemble a `.app` bundle for a racket-oo sample app.

use std::fs;
use std::path::{Path, PathBuf};

use apianyware_macos_stub_launcher::{create_app_bundle, StubConfig, StubError};

use crate::deps::collect_dependencies;

/// Default Racket runtime path baked into stub binaries. Matches the
/// homebrew install location used everywhere else in the project (sample
/// apps, runtime-load harness, knowledge docs).
pub const DEFAULT_RACKET_PATH: &str = "/opt/homebrew/bin/racket";

/// What to bundle.
///
/// `script_name` is the kebab-case identifier used for both the source
/// directory (`apps/<script_name>/`) and the entry script
/// (`<script_name>.rkt`). `app_name` is the human-readable display name
/// that ends up as `CFBundleName` and the menu-bar app label. Use
/// [`AppSpec::from_script_name`] to derive both from the kebab form.
#[derive(Debug, Clone)]
pub struct AppSpec {
    /// Display name (`CFBundleName`, menu-bar bold name). Example: `"File Lister"`.
    pub app_name: String,
    /// Bundle identifier (`CFBundleIdentifier`). Example: `"com.apianyware.FileLister"`.
    pub bundle_id: String,
    /// Source directory + entry-script base name. Example: `"file-lister"`.
    pub script_name: String,
    /// Absolute path to the racket runtime binary baked into the stub.
    pub runtime_path: String,
}

impl AppSpec {
    /// Derive an [`AppSpec`] from a kebab-case script name.
    ///
    /// `"file-lister"` → display `"File Lister"`, bundle id
    /// `"com.apianyware.FileLister"`. The runtime path defaults to
    /// [`DEFAULT_RACKET_PATH`] and can be overridden afterwards.
    pub fn from_script_name(script_name: impl Into<String>) -> Self {
        let script_name = script_name.into();
        let app_name = title_case_kebab(&script_name);
        let bundle_id = format!("com.apianyware.{}", app_name.replace(' ', ""));
        Self {
            app_name,
            bundle_id,
            script_name,
            runtime_path: DEFAULT_RACKET_PATH.to_string(),
        }
    }
}

/// Errors from bundling.
#[derive(Debug, thiserror::Error)]
pub enum BundleError {
    #[error("could not resolve source root {0}: {1}")]
    ResolveSourceRoot(PathBuf, std::io::Error),

    #[error("could not resolve entry script {0}: {1}")]
    ResolveEntry(PathBuf, std::io::Error),

    #[error("entry script {entry} is outside source root {root}")]
    EntryOutsideRoot { entry: PathBuf, root: PathBuf },

    #[error("could not read source file {0}: {1}")]
    ReadSource(PathBuf, std::io::Error),

    #[error("require {target} from {referrer} could not be resolved: {source}")]
    ResolveRequire {
        referrer: PathBuf,
        target: String,
        source: std::io::Error,
    },

    #[error("require from {referrer} resolved to {target}, which is outside source root {root}")]
    RequireOutsideRoot {
        referrer: PathBuf,
        target: PathBuf,
        root: PathBuf,
    },

    #[error("entry script {entry} not found")]
    EntryMissing { entry: PathBuf },

    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),

    #[error("stub-launcher error: {0}")]
    Stub(#[from] StubError),
}

/// Bundle a sample app at `source_root/apps/<script_name>/<script_name>.rkt`
/// into `output_dir/<App Name>.app`. Returns the path to the new bundle.
///
/// Resource layout: every `.rkt` file the entry script transitively
/// requires gets copied to `Resources/racket-app/<rel>` where `<rel>` is
/// the file's path relative to `source_root`. The `lib/` dylib directory
/// (if present in `source_root`) is copied verbatim to
/// `Resources/racket-app/lib/`.
///
/// The Swift stub is generated and compiled by `stub-launcher`. Its
/// `script_resource_dir` is set to `racket-app/apps/<script_name>` so
/// `Bundle.main.path(forResource:ofType:inDirectory:)` finds the entry
/// script inside the bundle at runtime.
pub fn bundle_app(
    spec: &AppSpec,
    source_root: &Path,
    output_dir: &Path,
) -> Result<PathBuf, BundleError> {
    let entry = source_root
        .join("apps")
        .join(&spec.script_name)
        .join(format!("{}.rkt", spec.script_name));

    if !entry.exists() {
        return Err(BundleError::EntryMissing { entry });
    }

    let canonical_root = source_root
        .canonicalize()
        .map_err(|e| BundleError::ResolveSourceRoot(source_root.to_path_buf(), e))?;

    // Discover everything the entry transitively requires, before we
    // touch the output directory — fail fast if a require is broken.
    let dependencies = collect_dependencies(&entry, &canonical_root)?;

    let stub_config = StubConfig {
        app_name: spec.app_name.clone(),
        runtime_path: spec.runtime_path.clone(),
        runtime_args: vec![],
        script_resource_name: spec.script_name.clone(),
        script_resource_type: "rkt".to_string(),
        script_resource_dir: format!("racket-app/apps/{}", spec.script_name),
        bundle_identifier: spec.bundle_id.clone(),
    };

    fs::create_dir_all(output_dir)?;
    let app_path = create_app_bundle(&stub_config, output_dir)?;

    let racket_app = app_path
        .join("Contents")
        .join("Resources")
        .join("racket-app");

    for src in &dependencies {
        let rel = src
            .strip_prefix(&canonical_root)
            .expect("dependency was validated to be under source root");
        let dst = racket_app.join(rel);
        fs::create_dir_all(dst.parent().expect("dst has parent"))?;
        fs::copy(src, &dst)?;
    }

    // Optional Swift helper dylib — referenced by runtime/swift-helpers.rkt
    // via `(ffi-lib (build-path this-dir 'up "lib" "libAPIAnywareRacket"))`.
    // Copy the lib/ directory if it exists in the source tree; the
    // runtime's exn:fail handler in swift-helpers.rkt makes the bundle
    // work in either mode.
    let lib_src = canonical_root.join("lib");
    if lib_src.is_dir() {
        let lib_dst = racket_app.join("lib");
        copy_dir_recursive(&lib_src, &lib_dst)?;
    }

    tracing::info!(
        app = %spec.app_name,
        path = %app_path.display(),
        files = dependencies.len(),
        "bundled racket-oo app"
    );

    Ok(app_path)
}

fn copy_dir_recursive(src: &Path, dst: &Path) -> std::io::Result<()> {
    fs::create_dir_all(dst)?;
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let from = entry.path();
        let to = dst.join(entry.file_name());
        let ftype = entry.file_type()?;
        if ftype.is_dir() {
            copy_dir_recursive(&from, &to)?;
        } else {
            fs::copy(&from, &to)?;
        }
    }
    Ok(())
}

/// `"file-lister"` → `"File Lister"`. Splits on `-`, capitalizes each
/// word's first ASCII char, joins with a single space.
fn title_case_kebab(kebab: &str) -> String {
    kebab
        .split('-')
        .map(|word| {
            let mut chars = word.chars();
            match chars.next() {
                Some(first) => first.to_ascii_uppercase().to_string() + chars.as_str(),
                None => String::new(),
            }
        })
        .collect::<Vec<_>>()
        .join(" ")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn title_case_single_word() {
        assert_eq!(title_case_kebab("counter"), "Counter");
    }

    #[test]
    fn title_case_two_words() {
        assert_eq!(title_case_kebab("file-lister"), "File Lister");
    }

    #[test]
    fn title_case_three_words() {
        assert_eq!(title_case_kebab("ui-controls-gallery"), "Ui Controls Gallery");
    }

    #[test]
    fn from_script_name_derives_display_and_bundle_id() {
        let spec = AppSpec::from_script_name("file-lister");
        assert_eq!(spec.app_name, "File Lister");
        assert_eq!(spec.bundle_id, "com.apianyware.FileLister");
        assert_eq!(spec.script_name, "file-lister");
        assert_eq!(spec.runtime_path, DEFAULT_RACKET_PATH);
    }

    #[test]
    fn from_script_name_handles_single_word() {
        let spec = AppSpec::from_script_name("counter");
        assert_eq!(spec.app_name, "Counter");
        assert_eq!(spec.bundle_id, "com.apianyware.Counter");
    }
}
