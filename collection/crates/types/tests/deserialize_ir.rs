//! Schema-evolution tests for `Framework` deserialization.
//!
//! These tests pin the serde defaults for fields added after the initial
//! checkpoint schema. A single synthetic JSON literal exercises every
//! default and round-trip guarantee in one pass — no on-disk SDK fixtures.

use apianyware_macos_types::ir::Framework;

/// Minimal modern document: the absolute-minimum set of fields a valid
/// checkpoint must carry, with every post-minimum field omitted so the
/// serde `default` attributes are exercised.
const MINIMAL_FRAMEWORK_JSON: &str = r#"{
    "format_version": "1.0",
    "name": "Foundation",
    "depends_on": ["CoreFoundation"],
    "classes": [],
    "protocols": [],
    "enums": [],
    "structs": [],
    "functions": [],
    "constants": []
}"#;

#[test]
fn format_version_deserializes() {
    let fw: Framework = serde_json::from_str(MINIMAL_FRAMEWORK_JSON).unwrap();
    assert_eq!(fw.format_version, "1.0");
}

#[test]
fn name_deserializes() {
    let fw: Framework = serde_json::from_str(MINIMAL_FRAMEWORK_JSON).unwrap();
    assert_eq!(fw.name, "Foundation");
}

#[test]
fn post_minimum_fields_default_when_missing() {
    let fw: Framework = serde_json::from_str(MINIMAL_FRAMEWORK_JSON).unwrap();
    assert!(fw.sdk_version.is_none());
    assert!(fw.collected_at.is_none());
    assert!(fw.checkpoint.is_empty());
    assert!(fw.skipped_symbols.is_empty());
    assert!(fw.class_annotations.is_empty());
    assert!(fw.api_patterns.is_empty());
    assert!(fw.enrichment.is_none());
    assert!(fw.verification.is_none());
}

#[test]
fn depends_on_round_trips() {
    let fw: Framework = serde_json::from_str(MINIMAL_FRAMEWORK_JSON).unwrap();
    assert_eq!(fw.depends_on, vec!["CoreFoundation".to_string()]);
}

/// Round-trip: deserialise → serialise → deserialise preserves semantics.
#[test]
fn minimal_round_trip_preserves_semantics() {
    let original: Framework = serde_json::from_str(MINIMAL_FRAMEWORK_JSON).unwrap();
    let reserialised = serde_json::to_string(&original).unwrap();
    let reparsed: Framework = serde_json::from_str(&reserialised).unwrap();

    assert_eq!(reparsed.format_version, original.format_version);
    assert_eq!(reparsed.name, original.name);
    assert_eq!(reparsed.depends_on, original.depends_on);
}
