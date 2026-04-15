//! Integration test: bundle the real File Lister sample app and verify
//! the resulting `.app` is structurally complete.
//!
//! Skipped if `swiftc` isn't available (stub-launcher needs it). Also
//! skipped if the racket-oo source tree is missing — keeps the workspace
//! test run clean on stripped checkouts.

use std::fs;
use std::path::PathBuf;
use std::process::Command;

use apianyware_macos_bundle_racket_oo::{
    bundle_app, read_display_name_from_spec, AppSpec,
};

const SCRIPT_NAME: &str = "file-lister";

fn workspace_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("workspace root above bundle-racket-oo crate")
        .to_path_buf()
}

fn racket_oo_root() -> PathBuf {
    workspace_root()
        .join("generation")
        .join("targets")
        .join("racket-oo")
}

fn knowledge_apps_dir() -> PathBuf {
    workspace_root().join("knowledge").join("apps")
}

fn discover_app_scripts() -> Vec<String> {
    let apps = racket_oo_root().join("apps");
    let mut scripts: Vec<String> = Vec::new();
    let Ok(entries) = fs::read_dir(&apps) else {
        return scripts;
    };
    for e in entries.flatten() {
        if !e.file_type().map(|t| t.is_dir()).unwrap_or(false) {
            continue;
        }
        let name = e.file_name().to_string_lossy().into_owned();
        if e.path().join(format!("{name}.rkt")).is_file() {
            scripts.push(name);
        }
    }
    scripts.sort();
    scripts
}

fn swiftc_available() -> bool {
    Command::new("swiftc")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn entry_script_present() -> bool {
    racket_oo_root()
        .join("apps")
        .join(SCRIPT_NAME)
        .join(format!("{SCRIPT_NAME}.rkt"))
        .exists()
}

#[test]
fn bundles_file_lister_into_app_directory() {
    if !swiftc_available() {
        eprintln!("SKIPPED: swiftc not available");
        return;
    }
    if !entry_script_present() {
        eprintln!("SKIPPED: file-lister source not present");
        return;
    }

    let temp = tempfile::tempdir().expect("tempdir");
    let spec = AppSpec::from_script_name(SCRIPT_NAME);
    let app_path = bundle_app(&spec, &racket_oo_root(), temp.path()).expect("bundle");

    // Bundle skeleton from stub-launcher
    assert!(app_path.ends_with("File Lister.app"), "{app_path:?}");
    let contents = app_path.join("Contents");
    assert!(contents.join("Info.plist").is_file());
    assert!(contents.join("MacOS").join("File Lister").is_file());

    // Resource layout — entry script and sibling deps
    let racket_app = contents.join("Resources").join("racket-app");
    let entry = racket_app
        .join("apps")
        .join(SCRIPT_NAME)
        .join(format!("{SCRIPT_NAME}.rkt"));
    assert!(entry.is_file(), "entry script missing: {entry:?}");

    // Runtime modules
    assert!(racket_app.join("runtime").join("objc-base.rkt").is_file());
    assert!(racket_app.join("runtime").join("delegate.rkt").is_file());
    assert!(racket_app.join("runtime").join("type-mapping.rkt").is_file());

    // Generated bindings actually statically required by file-lister.
    // The shared `runtime/app-menu.rkt` helper uses raw objc_msgSend, so
    // nsmenu/nsmenuitem are NOT transitively required — and correctly
    // not copied. NSString conversions go through type-mapping.rkt,
    // which calls into objc dynamically, so nsstring.rkt isn't either.
    let oo = racket_app.join("generated").join("oo");
    assert!(oo.join("appkit").join("nstableview.rkt").is_file());
    assert!(oo.join("appkit").join("nstablecolumn.rkt").is_file());
    assert!(oo.join("appkit").join("nsopenpanel.rkt").is_file());
    assert!(oo.join("foundation").join("nsfilemanager.rkt").is_file());
    assert!(oo.join("foundation").join("nsarray.rkt").is_file());
    assert!(oo.join("foundation").join("nsurl.rkt").is_file());

    // Unrelated frameworks should NOT have been pulled in. CoreText /
    // WebKit are unreachable from file-lister's require tree and must
    // stay out of the bundle.
    assert!(
        !oo.join("coretext").exists(),
        "coretext leaked into the bundle"
    );
    assert!(
        !oo.join("webkit").exists(),
        "webkit leaked into the bundle"
    );

    // Files NOT statically required (sanity check on tree pruning).
    assert!(
        !oo.join("foundation").join("nsstring.rkt").exists(),
        "nsstring.rkt leaked: it isn't a static require of file-lister"
    );
    assert!(
        !oo.join("appkit").join("nsmenu.rkt").exists(),
        "nsmenu.rkt leaked: file-lister gets its menu via runtime/app-menu.rkt"
    );

    // Info.plist carries the derived bundle metadata
    let plist = std::fs::read_to_string(contents.join("Info.plist")).unwrap();
    assert!(plist.contains("<string>File Lister</string>"));
    assert!(plist.contains("<string>com.apianyware.FileLister</string>"));
}

#[test]
fn entry_script_resolves_under_racket_oo_root() {
    // Sanity: the workspace path computation matches what the example uses.
    let entry = racket_oo_root()
        .join("apps")
        .join(SCRIPT_NAME)
        .join(format!("{SCRIPT_NAME}.rkt"));
    assert!(
        entry.starts_with(workspace_root()),
        "{entry:?} must live under {:?}",
        workspace_root()
    );
}

#[test]
fn rejects_missing_app() {
    if !swiftc_available() {
        eprintln!("SKIPPED: swiftc not available");
        return;
    }
    let temp = tempfile::tempdir().expect("tempdir");
    let spec = AppSpec::from_script_name("definitely-not-an-app");
    let err = bundle_app(&spec, &racket_oo_root(), temp.path()).unwrap_err();
    assert!(
        matches!(
            err,
            apianyware_macos_bundle_racket_oo::BundleError::EntryMissing { .. }
        ),
        "expected EntryMissing, got {err:?}"
    );
}

/// Bundle every sample app under `apps/` and assert the structural
/// invariants each `.app` must satisfy. This is the safety net for the
/// "ensure all sample apps are bundleable" requirement — adding a new
/// app under `apps/<name>/<name>.rkt` automatically lights up coverage
/// here without test edits.
#[test]
fn bundles_every_sample_app() {
    if !swiftc_available() {
        eprintln!("SKIPPED: swiftc not available");
        return;
    }
    let scripts = discover_app_scripts();
    if scripts.is_empty() {
        eprintln!("SKIPPED: no sample apps discovered");
        return;
    }

    for script in &scripts {
        let temp = tempfile::tempdir().expect("tempdir");

        // Use the same spec-md → display name lookup that the CLI
        // example uses, so the test bundles match what real users get.
        let mut spec = AppSpec::from_script_name(script);
        let spec_md = knowledge_apps_dir().join(script).join("spec.md");
        if let Some(display) = read_display_name_from_spec(&spec_md) {
            spec.bundle_id = format!("com.apianyware.{}", display.replace(' ', ""));
            spec.app_name = display;
        }

        let app_path = bundle_app(&spec, &racket_oo_root(), temp.path())
            .unwrap_or_else(|e| panic!("bundle {script}: {e}"));

        // Every bundle ships with a CFBundleName-correct Info.plist
        // and a compiled stub binary.
        let contents = app_path.join("Contents");
        let plist = fs::read_to_string(contents.join("Info.plist"))
            .unwrap_or_else(|e| panic!("read Info.plist for {script}: {e}"));
        assert!(
            plist.contains(&format!("<string>{}</string>", spec.app_name)),
            "{script}: CFBundleName missing from Info.plist"
        );
        assert!(
            plist.contains(&format!("<string>{}</string>", spec.bundle_id)),
            "{script}: CFBundleIdentifier missing from Info.plist"
        );

        let exe = contents.join("MacOS").join(&spec.app_name);
        assert!(exe.is_file(), "{script}: stub binary missing at {exe:?}");

        // Resources/racket-app must contain the entry script and at
        // least the runtime modules every Racket OO app pulls in
        // transitively (objc-base, coerce, type-mapping).
        let racket_app = contents.join("Resources").join("racket-app");
        let entry = racket_app
            .join("apps")
            .join(script)
            .join(format!("{script}.rkt"));
        assert!(entry.is_file(), "{script}: entry script missing");

        let runtime = racket_app.join("runtime");
        for required in ["objc-base.rkt", "coerce.rkt", "type-mapping.rkt", "app-menu.rkt"] {
            assert!(
                runtime.join(required).is_file(),
                "{script}: runtime/{required} missing",
            );
        }
    }
}

