//! Integration tests for the enrichment Datalog program.
//!
//! Tests derive enrichment relations from synthetic and real framework data.

use apianyware_macos_types::annotation::{
    AnnotationSource, BlockInvocationStyle, BlockParamAnnotation, ClassAnnotations, ErrorPattern,
    MethodAnnotation, PatternStereotype, ThreadingConstraint,
};
use apianyware_macos_types::enrichment::EnrichmentData;
use apianyware_macos_types::ir::{Class, Method, Param, Property, Protocol};
use apianyware_macos_types::type_ref::{TypeRef, TypeRefKind};
use apianyware_macos_types::Framework;

fn make_method(selector: &str, params: Vec<Param>, return_kind: TypeRefKind) -> Method {
    Method {
        selector: selector.to_string(),
        class_method: false,
        init_method: selector.starts_with("init"),
        params,
        return_type: TypeRef {
            nullable: false,
            kind: return_kind,
        },
        deprecated: false,
        variadic: false,
        source: None,
        provenance: None,
        doc_refs: None,
        origin: None,
        category: None,
        overrides: None,
        returns_retained: None,
        satisfies_protocol: None,
    }
}

fn block_param(name: &str) -> Param {
    Param {
        name: name.to_string(),
        param_type: TypeRef {
            nullable: false,
            kind: TypeRefKind::Block {
                params: vec![],
                return_type: Box::new(TypeRef::void()),
            },
        },
    }
}

fn empty_framework() -> Framework {
    Framework {
        format_version: "1.0".to_string(),
        checkpoint: "annotated".to_string(),
        name: "TestKit".to_string(),
        sdk_version: None,
        collected_at: None,
        depends_on: vec![],
        skipped_symbols: vec![],
        classes: vec![],
        protocols: vec![],
        enums: vec![],
        structs: vec![],
        functions: vec![],
        constants: vec![],
        class_annotations: vec![],
        api_patterns: vec![],
        enrichment: None,
        verification: None,
        ir_level: None,
    }
}

fn enrich(
    fw: &Framework,
) -> (
    EnrichmentData,
    apianyware_macos_types::enrichment::VerificationReport,
) {
    let enriched = apianyware_macos_enrich::enrich_loaded_frameworks(&[fw.clone()]).unwrap();
    let e = enriched[0].enrichment.clone().unwrap();
    let v = enriched[0].verification.clone().unwrap();
    (e, v)
}

// -----------------------------------------------------------------------
// Block classification tests
// -----------------------------------------------------------------------

#[test]
fn sync_block_method_derived() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSArray".to_string(),
        superclass: "NSObject".to_string(),
        protocols: vec![],
        properties: vec![],
        methods: vec![make_method(
            "enumerateObjectsUsingBlock:",
            vec![block_param("block")],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.class_annotations = vec![ClassAnnotations {
        class_name: "NSArray".to_string(),
        methods: vec![MethodAnnotation {
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
        }],
    }];

    let (e, v) = enrich(&fw);
    assert_eq!(e.sync_block_methods.len(), 1);
    assert_eq!(
        e.sync_block_methods[0].selector,
        "enumerateObjectsUsingBlock:"
    );
    assert!(v.passed);
}

#[test]
fn async_and_stored_block_methods() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSOperation".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![],
        methods: vec![
            make_method(
                "setCompletionBlock:",
                vec![block_param("block")],
                TypeRefKind::Primitive {
                    name: "void".to_string(),
                },
            ),
            make_method(
                "addObserver:",
                vec![block_param("observer")],
                TypeRefKind::Primitive {
                    name: "void".to_string(),
                },
            ),
        ],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.class_annotations = vec![ClassAnnotations {
        class_name: "NSOperation".to_string(),
        methods: vec![
            MethodAnnotation {
                selector: "setCompletionBlock:".to_string(),
                is_instance: true,
                parameter_ownership: vec![],
                block_parameters: vec![BlockParamAnnotation {
                    param_index: 0,
                    invocation: BlockInvocationStyle::AsyncCopied,
                }],
                threading: None,
                error_pattern: None,
                source: AnnotationSource::Heuristic,
            },
            MethodAnnotation {
                selector: "addObserver:".to_string(),
                is_instance: true,
                parameter_ownership: vec![],
                block_parameters: vec![BlockParamAnnotation {
                    param_index: 0,
                    invocation: BlockInvocationStyle::Stored,
                }],
                threading: None,
                error_pattern: None,
                source: AnnotationSource::Heuristic,
            },
        ],
    }];

    let (e, _) = enrich(&fw);
    assert_eq!(e.async_block_methods.len(), 1);
    assert_eq!(e.stored_block_methods.len(), 1);
    assert_eq!(e.async_block_methods[0].selector, "setCompletionBlock:");
    assert_eq!(e.stored_block_methods[0].selector, "addObserver:");
}

// -----------------------------------------------------------------------
// Main thread class tests
// -----------------------------------------------------------------------

#[test]
fn main_thread_class_derived_from_threading_annotation() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSView".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![],
        methods: vec![make_method(
            "setNeedsDisplay:",
            vec![],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.class_annotations = vec![ClassAnnotations {
        class_name: "NSView".to_string(),
        methods: vec![MethodAnnotation {
            selector: "setNeedsDisplay:".to_string(),
            is_instance: true,
            parameter_ownership: vec![],
            block_parameters: vec![],
            threading: Some(ThreadingConstraint::MainThreadOnly),
            error_pattern: None,
            source: AnnotationSource::Heuristic,
        }],
    }];

    let (e, _) = enrich(&fw);
    assert_eq!(e.main_thread_classes, vec!["NSView".to_string()]);
}

// -----------------------------------------------------------------------
// Convenience error method tests
// -----------------------------------------------------------------------

#[test]
fn convenience_error_method_derived() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSFileManager".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![],
        methods: vec![make_method(
            "contentsOfDirectoryAtPath:error:",
            vec![],
            TypeRefKind::Id,
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.class_annotations = vec![ClassAnnotations {
        class_name: "NSFileManager".to_string(),
        methods: vec![MethodAnnotation {
            selector: "contentsOfDirectoryAtPath:error:".to_string(),
            is_instance: true,
            parameter_ownership: vec![],
            block_parameters: vec![],
            threading: None,
            error_pattern: Some(ErrorPattern::ErrorOutParam),
            source: AnnotationSource::Heuristic,
        }],
    }];

    let (e, _) = enrich(&fw);
    assert_eq!(e.convenience_error_methods.len(), 1);
    assert_eq!(
        e.convenience_error_methods[0].selector,
        "contentsOfDirectoryAtPath:error:"
    );
}

// -----------------------------------------------------------------------
// Collection iterable tests
// -----------------------------------------------------------------------

#[test]
fn collection_iterable_from_count_and_object_at_index() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSArray".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![Property {
            name: "count".to_string(),
            property_type: TypeRef {
                nullable: false,
                kind: TypeRefKind::Primitive {
                    name: "NSUInteger".to_string(),
                },
            },
            readonly: true,
            class_property: false,
            deprecated: false,
            source: None,
            provenance: None,
            doc_refs: None,
            origin: None,
        }],
        methods: vec![make_method("objectAtIndex:", vec![], TypeRefKind::Id)],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];

    let (e, _) = enrich(&fw);
    assert!(e.collection_iterables.contains(&"NSArray".to_string()));
}

#[test]
fn collection_iterable_from_fast_enumeration() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSSet".to_string(),
        superclass: String::new(),
        protocols: vec!["NSFastEnumeration".to_string()],
        properties: vec![],
        methods: vec![],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];

    let (e, _) = enrich(&fw);
    assert!(e.collection_iterables.contains(&"NSSet".to_string()));
}

// -----------------------------------------------------------------------
// Delegate protocol tests
// -----------------------------------------------------------------------

#[test]
fn delegate_protocol_detected_from_set_delegate() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "NSWindow".to_string(),
        superclass: String::new(),
        protocols: vec!["NSWindowDelegate".to_string()],
        properties: vec![],
        methods: vec![make_method(
            "setDelegate:",
            vec![],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.protocols = vec![Protocol {
        name: "NSWindowDelegate".to_string(),
        inherits: vec![],
        required_methods: vec![],
        optional_methods: vec![make_method(
            "windowDidResize:",
            vec![],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        properties: vec![],
        source: None,
        provenance: None,
        doc_refs: None,
    }];

    let (e, _) = enrich(&fw);
    assert!(e
        .delegate_protocols
        .contains(&"NSWindowDelegate".to_string()));
}

// -----------------------------------------------------------------------
// Verification tests
// -----------------------------------------------------------------------

#[test]
fn unclassified_block_violation() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "MyClass".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![],
        methods: vec![make_method(
            "doWork:",
            vec![block_param("handler")],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    // No annotations — block param is unclassified

    let (_, v) = enrich(&fw);
    assert!(!v.passed);
    assert_eq!(v.violations.len(), 1);
    assert_eq!(v.violations[0].rule, "unclassified_block");
    assert_eq!(v.violations[0].class, "MyClass");
    assert_eq!(v.violations[0].selector, "doWork:");
    assert_eq!(v.violations[0].param_index, Some(0));
}

#[test]
fn classified_block_no_violation() {
    let mut fw = empty_framework();
    fw.classes = vec![Class {
        name: "MyClass".to_string(),
        superclass: String::new(),
        protocols: vec![],
        properties: vec![],
        methods: vec![make_method(
            "doWork:",
            vec![block_param("handler")],
            TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        )],
        category_methods: vec![],
        ancestors: vec![],
        all_methods: vec![],
        all_properties: vec![],
    }];
    fw.class_annotations = vec![ClassAnnotations {
        class_name: "MyClass".to_string(),
        methods: vec![MethodAnnotation {
            selector: "doWork:".to_string(),
            is_instance: true,
            parameter_ownership: vec![],
            block_parameters: vec![BlockParamAnnotation {
                param_index: 0,
                invocation: BlockInvocationStyle::AsyncCopied,
            }],
            threading: None,
            error_pattern: None,
            source: AnnotationSource::Heuristic,
        }],
    }];

    let (_, v) = enrich(&fw);
    assert!(v.passed);
}

// -----------------------------------------------------------------------
// Scoped resource tests (from api_patterns)
// -----------------------------------------------------------------------

#[test]
fn scoped_resource_from_paired_state_pattern() {
    let mut fw = empty_framework();
    fw.api_patterns = vec![apianyware_macos_types::annotation::ApiPattern {
        stereotype: PatternStereotype::PairedState,
        name: "NSLock critical section".to_string(),
        participants: serde_json::json!({
            "lock": { "class": "NSLock", "selector": "lock" },
            "unlock": { "class": "NSLock", "selector": "unlock" }
        }),
        constraints: vec![],
        source: AnnotationSource::Heuristic,
        doc_ref: None,
    }];

    let (e, _) = enrich(&fw);
    assert_eq!(e.scoped_resources.len(), 1);
    assert_eq!(e.scoped_resources[0].class, "NSLock");
    assert_eq!(e.scoped_resources[0].open_selector, "lock");
    assert_eq!(e.scoped_resources[0].close_selector, "unlock");
}

// -----------------------------------------------------------------------
// Foundation integration test
// -----------------------------------------------------------------------

#[test]
fn foundation_enrichment_integration() {
    let annotated_dir = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("..")
        .join("..")
        .join("..")
        .join("analysis")
        .join("ir")
        .join("annotated");

    if !annotated_dir.join("Foundation.json").exists() {
        eprintln!(
            "skipping: no Foundation.json at {}",
            annotated_dir.display()
        );
        return;
    }

    let fw = apianyware_macos_datalog::loading::load_framework_from_file(
        &annotated_dir.join("Foundation.json"),
    )
    .unwrap();

    let enriched = apianyware_macos_enrich::enrich_loaded_frameworks(&[fw]).unwrap();
    assert_eq!(enriched.len(), 1);

    let e = enriched[0].enrichment.as_ref().unwrap();
    let v = enriched[0].verification.as_ref().unwrap();

    // Enrichment relations should be populated
    assert!(
        e.sync_block_methods.len() > 50,
        "expected >50 sync blocks, got {}",
        e.sync_block_methods.len()
    );
    assert!(
        e.async_block_methods.len() > 50,
        "expected >50 async blocks, got {}",
        e.async_block_methods.len()
    );
    assert!(
        e.convenience_error_methods.len() > 100,
        "expected >100 error methods, got {}",
        e.convenience_error_methods.len()
    );
    assert!(
        e.collection_iterables.len() >= 5,
        "expected >=5 iterables, got {}",
        e.collection_iterables.len()
    );
    assert!(
        e.scoped_resources.len() >= 3,
        "expected >=3 scoped resources, got {}",
        e.scoped_resources.len()
    );

    // Verification should pass
    assert!(
        v.passed,
        "verification should pass, violations: {:?}",
        v.violations
    );

    // Checkpoint should be enriched
    assert_eq!(enriched[0].checkpoint, "enriched");
}
