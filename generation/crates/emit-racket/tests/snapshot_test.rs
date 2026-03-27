//! Snapshot (golden-file) regression tests for the Racket emitter.
//!
//! Two test suites:
//!   1. TestKit (synthetic) — full directory comparison, exercises all emitter code paths
//!   2. Foundation (real IR) — curated subset of ~18 representative files
//!
//! To update golden files after intentional changes:
//!   UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket --test snapshot_test

use std::path::PathBuf;

use apianyware_macos_emit::binding_style::{BindingStyle, LanguageEmitter};
use apianyware_macos_emit::snapshot_testing::GoldenTest;
use apianyware_macos_emit::test_fixtures::build_snapshot_test_framework;
use apianyware_macos_emit_racket::emit_framework::RacketEmitter;

/// Root of this crate (for locating golden files relative to source).
fn crate_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

/// Golden files directory for TestKit.
fn golden_dir() -> PathBuf {
    crate_root().join("tests").join("golden")
}

/// Golden files directory for Foundation subset.
fn golden_foundation_dir() -> PathBuf {
    crate_root().join("tests").join("golden-foundation")
}

/// Curated subset of Foundation files for golden comparison.
/// Covers: base class, string-heavy class, collection, data, URL,
/// notification center, error domain, file operations, user defaults,
/// formatter/builder, locking, timer, enums, constants, main re-export,
/// and representative protocols (NSCopying, NSCoding, NSLocking).
const FOUNDATION_GOLDEN_FILES: &[&str] = &[
    "main.rkt",
    "constants.rkt",
    "enums.rkt",
    "nsobject.rkt",
    "nsstring.rkt",
    "nsarray.rkt",
    "nsdata.rkt",
    "nsurl.rkt",
    "nsnotificationcenter.rkt",
    "nserror.rkt",
    "nsfilemanager.rkt",
    "nsuserdefaults.rkt",
    "nsdateformatter.rkt",
    "nslock.rkt",
    "nstimer.rkt",
    "protocols/nscopying.rkt",
    "protocols/nscoding.rkt",
    "protocols/nslocking.rkt",
];

#[test]
fn snapshot_racket_oo_testkit() {
    let framework = build_snapshot_test_framework();

    // Generate to a temp directory
    let temp_dir = tempfile::tempdir().unwrap();
    let emitter = RacketEmitter;
    let result = emitter
        .emit_framework(&framework, temp_dir.path(), BindingStyle::ObjectOriented)
        .expect("Racket emitter should succeed");

    assert!(
        result.files_written > 0,
        "Should generate at least one file"
    );
    assert_eq!(result.classes_emitted, 5);
    assert_eq!(result.protocols_emitted, 2);
    assert_eq!(result.enums_emitted, 1);
    assert_eq!(result.constants_emitted, 2);

    // The emitter writes to {output_dir}/{lowercase_framework_name}/
    let generated_framework_dir = temp_dir.path().join("testkit");
    assert!(
        generated_framework_dir.exists(),
        "Expected testkit/ directory in output"
    );

    // Compare against golden files
    let golden_test = GoldenTest::new(&golden_dir(), "racket", BindingStyle::ObjectOriented);
    if let Err(mismatch) = golden_test.assert_matches(&generated_framework_dir) {
        panic!(
            "Racket OO snapshot mismatch.\n\
             Run `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket --test snapshot_test` \
             to accept.\n\n{mismatch}"
        );
    }
}

/// Load the real Foundation enriched IR from the analysis pipeline output.
fn load_foundation_framework() -> Option<apianyware_macos_types::ir::Framework> {
    let enriched_dir = crate_root()
        .parent() // emit-racket → crates
        .and_then(|p| p.parent()) // crates → generation
        .and_then(|p| p.parent()) // generation → project root
        .map(|p| p.join("analysis").join("ir").join("enriched"))?;

    let foundation_path = enriched_dir.join("Foundation.json");
    if !foundation_path.exists() {
        return None;
    }

    let json = std::fs::read_to_string(&foundation_path).ok()?;
    serde_json::from_str(&json).ok()
}

#[test]
fn snapshot_racket_oo_foundation_subset() {
    let framework = match load_foundation_framework() {
        Some(fw) => fw,
        None => {
            eprintln!(
                "SKIPPED: Foundation enriched IR not found. \
                 Run the analysis pipeline first: \
                 cargo run --bin apianyware-macos-analyze"
            );
            return;
        }
    };

    // Generate Foundation to a temp directory
    let temp_dir = tempfile::tempdir().unwrap();
    let emitter = RacketEmitter;
    let result = emitter
        .emit_framework(&framework, temp_dir.path(), BindingStyle::ObjectOriented)
        .expect("Foundation emission should succeed");

    assert!(
        result.files_written > 100,
        "Foundation should generate many files"
    );
    assert!(
        result.classes_emitted >= 300,
        "Foundation should emit 300+ classes"
    );

    // Compare curated subset against golden files
    let generated_dir = temp_dir.path().join("foundation");
    assert!(generated_dir.exists(), "Expected foundation/ directory");

    let golden_test = GoldenTest::new(
        &golden_foundation_dir(),
        "racket",
        BindingStyle::ObjectOriented,
    );
    if let Err(mismatch) =
        golden_test.assert_subset_matches(&generated_dir, FOUNDATION_GOLDEN_FILES)
    {
        panic!(
            "Racket OO Foundation snapshot mismatch.\n\
             Run `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket --test snapshot_test` \
             to accept.\n\n{mismatch}"
        );
    }
}
