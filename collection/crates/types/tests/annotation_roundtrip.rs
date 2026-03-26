//! Tests: round-trip serialization/deserialization of annotation types.

use apianyware_macos_types::annotation::{
    AnnotationOverride, AnnotationOverrides, AnnotationSource, BlockInvocationStyle,
    BlockParamAnnotation, ClassAnnotations, ErrorPattern, FrameworkAnnotations, MethodAnnotation,
    OwnershipKind, ParamOwnership, ThreadingConstraint,
};

#[test]
fn method_annotation_roundtrip() {
    let annotation = MethodAnnotation {
        selector: "enumerateObjectsUsingBlock:".to_string(),
        is_instance: true,
        parameter_ownership: vec![ParamOwnership {
            param_index: 0,
            ownership: OwnershipKind::Copy,
        }],
        block_parameters: vec![BlockParamAnnotation {
            param_index: 0,
            invocation: BlockInvocationStyle::Synchronous,
        }],
        threading: Some(ThreadingConstraint::AnyThread),
        error_pattern: None,
        source: AnnotationSource::Llm,
    };

    let json = serde_json::to_string_pretty(&annotation).unwrap();
    let deserialized: MethodAnnotation = serde_json::from_str(&json).unwrap();

    assert_eq!(deserialized.selector, "enumerateObjectsUsingBlock:");
    assert!(deserialized.is_instance);
    assert_eq!(deserialized.parameter_ownership.len(), 1);
    assert_eq!(
        deserialized.parameter_ownership[0].ownership,
        OwnershipKind::Copy
    );
    assert_eq!(deserialized.block_parameters.len(), 1);
    assert_eq!(
        deserialized.block_parameters[0].invocation,
        BlockInvocationStyle::Synchronous
    );
    assert_eq!(deserialized.threading, Some(ThreadingConstraint::AnyThread));
    assert_eq!(deserialized.error_pattern, None);
    assert_eq!(deserialized.source, AnnotationSource::Llm);
}

#[test]
fn framework_annotations_roundtrip() {
    let annotations = FrameworkAnnotations {
        framework: "Foundation".to_string(),
        classes: vec![ClassAnnotations {
            class_name: "NSArray".to_string(),
            methods: vec![
                MethodAnnotation {
                    selector: "enumerateObjectsUsingBlock:".to_string(),
                    is_instance: true,
                    parameter_ownership: vec![],
                    block_parameters: vec![BlockParamAnnotation {
                        param_index: 0,
                        invocation: BlockInvocationStyle::Synchronous,
                    }],
                    threading: None,
                    error_pattern: None,
                    source: AnnotationSource::Heuristic,
                },
                MethodAnnotation {
                    selector: "writeToURL:error:".to_string(),
                    is_instance: true,
                    parameter_ownership: vec![],
                    block_parameters: vec![],
                    threading: None,
                    error_pattern: Some(ErrorPattern::ErrorOutParam),
                    source: AnnotationSource::Llm,
                },
            ],
        }],
    };

    let json = serde_json::to_string_pretty(&annotations).unwrap();
    let deserialized: FrameworkAnnotations = serde_json::from_str(&json).unwrap();

    assert_eq!(deserialized.framework, "Foundation");
    assert_eq!(deserialized.classes.len(), 1);
    assert_eq!(deserialized.classes[0].methods.len(), 2);
    assert_eq!(
        deserialized.classes[0].methods[1].error_pattern,
        Some(ErrorPattern::ErrorOutParam)
    );
}

#[test]
fn annotation_overrides_roundtrip() {
    let overrides = AnnotationOverrides {
        framework: "AppKit".to_string(),
        overrides: vec![AnnotationOverride {
            class_name: "NSWindow".to_string(),
            selector: "setDelegate:".to_string(),
            field: "parameter_ownership".to_string(),
            value: serde_json::json!([{"param_index": 0, "ownership": "weak"}]),
            reason: "NSWindow delegates are always weak references".to_string(),
        }],
    };

    let json = serde_json::to_string_pretty(&overrides).unwrap();
    let deserialized: AnnotationOverrides = serde_json::from_str(&json).unwrap();

    assert_eq!(deserialized.framework, "AppKit");
    assert_eq!(deserialized.overrides.len(), 1);
    assert_eq!(deserialized.overrides[0].class_name, "NSWindow");
    assert_eq!(deserialized.overrides[0].selector, "setDelegate:");
}

#[test]
fn ownership_kind_serialization() {
    assert_eq!(
        serde_json::to_string(&OwnershipKind::Strong).unwrap(),
        "\"strong\""
    );
    assert_eq!(
        serde_json::to_string(&OwnershipKind::Weak).unwrap(),
        "\"weak\""
    );
    assert_eq!(
        serde_json::to_string(&OwnershipKind::Copy).unwrap(),
        "\"copy\""
    );
    assert_eq!(
        serde_json::to_string(&OwnershipKind::UnsafeUnretained).unwrap(),
        "\"unsafe_unretained\""
    );
}

#[test]
fn block_invocation_style_serialization() {
    assert_eq!(
        serde_json::to_string(&BlockInvocationStyle::Synchronous).unwrap(),
        "\"synchronous\""
    );
    assert_eq!(
        serde_json::to_string(&BlockInvocationStyle::AsyncCopied).unwrap(),
        "\"async_copied\""
    );
    assert_eq!(
        serde_json::to_string(&BlockInvocationStyle::Stored).unwrap(),
        "\"stored\""
    );
}

#[test]
fn annotation_source_serialization() {
    assert_eq!(
        serde_json::to_string(&AnnotationSource::Heuristic).unwrap(),
        "\"heuristic\""
    );
    assert_eq!(
        serde_json::to_string(&AnnotationSource::Llm).unwrap(),
        "\"llm\""
    );
    assert_eq!(
        serde_json::to_string(&AnnotationSource::HumanReviewed).unwrap(),
        "\"human_reviewed\""
    );
}

#[test]
fn empty_optional_fields_skipped_in_serialization() {
    let annotation = MethodAnnotation {
        selector: "init".to_string(),
        is_instance: true,
        parameter_ownership: vec![],
        block_parameters: vec![],
        threading: None,
        error_pattern: None,
        source: AnnotationSource::Heuristic,
    };

    let json = serde_json::to_string(&annotation).unwrap();
    // Empty vecs and None options should be skipped
    assert!(!json.contains("parameter_ownership"));
    assert!(!json.contains("block_parameters"));
    assert!(!json.contains("threading"));
    assert!(!json.contains("error_pattern"));
}
