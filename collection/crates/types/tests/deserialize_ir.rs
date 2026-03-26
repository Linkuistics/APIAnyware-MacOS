//! Integration tests: deserialize real IR JSON files from the POC project
//! and spot-check their contents.

use std::fs;
use std::path::PathBuf;

use apianyware_macos_types::ir::Framework;
use apianyware_macos_types::type_ref::TypeRefKind;

/// Resolve a path relative to the POC project root.
fn poc_ir_path(relative: &str) -> PathBuf {
    let manifest_dir = env!("CARGO_MANIFEST_DIR");
    PathBuf::from(manifest_dir)
        .join("..")
        .join("..")
        .join("..")
        .join("..")
        .join("APIAnyware")
        .join(relative)
}

fn load_framework(relative: &str) -> Framework {
    let path = poc_ir_path(relative);
    let json = fs::read_to_string(&path)
        .unwrap_or_else(|e| panic!("failed to read {}: {e}", path.display()));
    serde_json::from_str(&json)
        .unwrap_or_else(|e| panic!("failed to parse {}: {e}", path.display()))
}

// ---------------------------------------------------------------------------
// Level 1 Foundation
// ---------------------------------------------------------------------------

#[test]
fn foundation_level1_deserializes() {
    let fw = load_framework("ir/level1/Foundation.json");
    assert_eq!(fw.name, "Foundation");
    // Legacy ir_version maps to format_version via serde alias
    assert_eq!(fw.format_version, "0.1.0");
}

#[test]
fn foundation_level1_entity_counts() {
    let fw = load_framework("ir/level1/Foundation.json");
    assert_eq!(fw.classes.len(), 262);
    assert_eq!(fw.protocols.len(), 41);
    assert_eq!(fw.enums.len(), 141);
    assert_eq!(fw.structs.len(), 13);
    assert_eq!(fw.functions.len(), 171);
    assert_eq!(fw.constants.len(), 826);
}

#[test]
fn foundation_nsstring_basics() {
    let fw = load_framework("ir/level1/Foundation.json");
    let nsstring = fw
        .classes
        .iter()
        .find(|c| c.name == "NSString")
        .expect("NSString not found");

    assert_eq!(nsstring.superclass, "NSObject");
    assert_eq!(nsstring.methods.len(), 150);
    assert!(!nsstring.properties.is_empty());
}

#[test]
fn foundation_nsstring_has_length_property() {
    let fw = load_framework("ir/level1/Foundation.json");
    let nsstring = fw.classes.iter().find(|c| c.name == "NSString").unwrap();
    let length = nsstring
        .properties
        .iter()
        .find(|p| p.name == "length")
        .expect("length property not found");

    assert!(length.readonly);
    assert!(!length.class_property);
    match &length.property_type.kind {
        TypeRefKind::Primitive { name } => assert_eq!(name, "uint64"),
        other => panic!("expected Primitive, got {other:?}"),
    }
}

#[test]
fn foundation_nsstring_init_method() {
    let fw = load_framework("ir/level1/Foundation.json");
    let nsstring = fw.classes.iter().find(|c| c.name == "NSString").unwrap();
    let init = nsstring
        .methods
        .iter()
        .find(|m| m.selector == "init")
        .expect("init method not found");

    assert!(init.init_method);
    assert!(!init.class_method);
    assert!(init.params.is_empty());
    assert!(matches!(init.return_type.kind, TypeRefKind::Instancetype));
}

#[test]
fn foundation_typeref_block_variant() {
    let fw = load_framework("ir/level1/Foundation.json");
    let has_block = fw.classes.iter().flat_map(|c| &c.methods).any(|m| {
        m.params
            .iter()
            .any(|p| matches!(p.param_type.kind, TypeRefKind::Block { .. }))
    });
    assert!(
        has_block,
        "expected at least one method with a block parameter"
    );
}

#[test]
fn foundation_typeref_class_with_generics() {
    let fw = load_framework("ir/level1/Foundation.json");
    let nsstring = fw.classes.iter().find(|c| c.name == "NSString").unwrap();
    let has_generic = nsstring.methods.iter().any(|m| {
        m.params.iter().any(|p| match &p.param_type.kind {
            TypeRefKind::Class { params, .. } => !params.is_empty(),
            _ => false,
        })
    });
    assert!(
        has_generic,
        "expected NSString to have a method with a generic class parameter"
    );
}

#[test]
fn foundation_enum_values() {
    let fw = load_framework("ir/level1/Foundation.json");
    let opts = fw
        .enums
        .iter()
        .find(|e| e.name == "NSActivityOptions")
        .expect("NSActivityOptions not found");

    match &opts.enum_type.kind {
        TypeRefKind::Primitive { name } => assert_eq!(name, "uint64"),
        other => panic!("expected Primitive, got {other:?}"),
    }

    let bg = opts
        .values
        .iter()
        .find(|v| v.name == "NSActivityBackground")
        .expect("NSActivityBackground not found");
    assert_eq!(bg.value, 255);

    let idle = opts
        .values
        .iter()
        .find(|v| v.name == "NSActivityIdleDisplaySleepDisabled")
        .expect("NSActivityIdleDisplaySleepDisabled not found");
    assert_eq!(idle.value, 1_099_511_627_776);
}

#[test]
fn foundation_struct_fields() {
    let fw = load_framework("ir/level1/Foundation.json");
    let affine = fw
        .structs
        .iter()
        .find(|s| s.name == "NSAffineTransformStruct")
        .expect("NSAffineTransformStruct not found");

    assert_eq!(affine.fields.len(), 6);
    let m11 = &affine.fields[0];
    assert_eq!(m11.name, "m11");
    assert!(matches!(
        m11.field_type.kind,
        TypeRefKind::Primitive { ref name } if name == "double"
    ));
}

#[test]
fn foundation_protocol_structure() {
    let fw = load_framework("ir/level1/Foundation.json");
    let cache_delegate = fw
        .protocols
        .iter()
        .find(|p| p.name == "NSCacheDelegate")
        .expect("NSCacheDelegate not found");

    assert_eq!(cache_delegate.required_methods.len(), 1);
    assert_eq!(
        cache_delegate.required_methods[0].selector,
        "cache:willEvictObject:"
    );
}

// ---------------------------------------------------------------------------
// Level 0 Foundation
// ---------------------------------------------------------------------------

#[test]
fn foundation_level0_deserializes() {
    let fw = load_framework("ir/level0/Foundation.json");
    assert_eq!(fw.name, "Foundation");
}

// ---------------------------------------------------------------------------
// Level 1 AppKit
// ---------------------------------------------------------------------------

#[test]
fn appkit_level1_deserializes() {
    let fw = load_framework("ir/level1/AppKit.json");
    assert_eq!(fw.name, "AppKit");
    assert!(!fw.classes.is_empty());
    assert!(!fw.enums.is_empty());
}

#[test]
fn appkit_depends_on_foundation() {
    let fw = load_framework("ir/level1/AppKit.json");
    assert!(fw.depends_on.is_empty() || fw.depends_on.contains(&"Foundation".to_string()));
}

// ---------------------------------------------------------------------------
// New fields have sensible defaults for POC JSON
// ---------------------------------------------------------------------------

#[test]
fn new_fields_default_for_legacy_json() {
    let fw = load_framework("ir/level1/Foundation.json");
    // New fields should have defaults when reading POC JSON
    assert!(fw.sdk_version.is_none());
    assert!(fw.collected_at.is_none());
    assert!(fw.checkpoint.is_empty());

    // Methods should have no provenance/doc_refs/source in POC data
    let nsstring = fw.classes.iter().find(|c| c.name == "NSString").unwrap();
    let init = nsstring
        .methods
        .iter()
        .find(|m| m.selector == "init")
        .unwrap();
    assert!(init.source.is_none());
    assert!(init.provenance.is_none());
    assert!(init.doc_refs.is_none());
}
