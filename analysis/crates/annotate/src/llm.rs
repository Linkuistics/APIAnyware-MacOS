//! LLM annotation support: extraction of interesting methods and loading of LLM results.
//!
//! Two main operations:
//! 1. **Extract** — filter a framework's methods to those needing LLM classification
//!    (block params, error out-params, delegate patterns) and write a compact summary
//!    for Claude Code subagents to analyze.
//! 2. **Load** — read `.llm.json` files produced by subagents and convert to
//!    `FrameworkAnnotations` for merge with heuristic results.

use std::path::Path;

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};

use apianyware_macos_types::annotation::FrameworkAnnotations;
use apianyware_macos_types::ir::Framework;
use apianyware_macos_types::type_ref::TypeRefKind;

/// Compact summary of a framework's methods needing LLM annotation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FrameworkSummary {
    /// Framework name.
    pub framework: String,
    /// Classes containing interesting methods.
    pub classes: Vec<ClassSummary>,
    /// Total number of methods across all classes.
    pub method_count: usize,
}

/// Compact class summary for LLM consumption.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ClassSummary {
    /// Class name.
    pub class_name: String,
    /// Methods needing LLM classification.
    pub methods: Vec<MethodSummary>,
}

/// Compact method summary for LLM consumption.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MethodSummary {
    /// Selector name (e.g., `"dataTaskWithURL:completionHandler:"`).
    pub selector: String,
    /// `true` for instance methods, `false` for class methods.
    pub is_instance: bool,
    /// Parameter summaries.
    pub params: Vec<ParamSummary>,
    /// Return type description.
    pub return_type: String,
    /// Why this method was flagged for LLM review.
    pub reasons: Vec<String>,
}

/// Compact parameter summary for LLM consumption.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParamSummary {
    /// Parameter name.
    pub name: String,
    /// Type kind description (e.g., `"block"`, `"id"`, `"pointer"`).
    pub type_kind: String,
}

/// Extract methods needing LLM classification from a resolved framework.
///
/// A method is "interesting" if it has:
/// - Block-typed parameters (invocation style may be ambiguous)
/// - A likely error out-param (last param named `error` with pointer type)
/// - A selector suggesting delegate/observer/target patterns
pub fn extract_interesting_methods(framework: &Framework) -> FrameworkSummary {
    let mut classes = Vec::new();
    let mut total_methods = 0;

    for class in &framework.classes {
        let mut methods = Vec::new();

        // Use effective methods if available, else direct methods
        let method_list = if class.all_methods.is_empty() {
            &class.methods
        } else {
            &class.all_methods
        };

        for method in method_list {
            let reasons = classify_interest(method);
            if reasons.is_empty() {
                continue;
            }

            methods.push(MethodSummary {
                selector: method.selector.clone(),
                is_instance: !method.class_method,
                params: method
                    .params
                    .iter()
                    .map(|p| ParamSummary {
                        name: p.name.clone(),
                        type_kind: describe_type_kind(&p.param_type.kind),
                    })
                    .collect(),
                return_type: describe_type_kind(&method.return_type.kind),
                reasons,
            });
        }

        // Also check category methods
        for category_group in &class.category_methods {
            for method in &category_group.methods {
                let reasons = classify_interest(method);
                if reasons.is_empty() {
                    continue;
                }

                methods.push(MethodSummary {
                    selector: method.selector.clone(),
                    is_instance: !method.class_method,
                    params: method
                        .params
                        .iter()
                        .map(|p| ParamSummary {
                            name: p.name.clone(),
                            type_kind: describe_type_kind(&p.param_type.kind),
                        })
                        .collect(),
                    return_type: describe_type_kind(&method.return_type.kind),
                    reasons,
                });
            }
        }

        if !methods.is_empty() {
            total_methods += methods.len();
            classes.push(ClassSummary {
                class_name: class.name.clone(),
                methods,
            });
        }
    }

    FrameworkSummary {
        framework: framework.name.clone(),
        classes,
        method_count: total_methods,
    }
}

/// Determine why a method is "interesting" for LLM annotation.
fn classify_interest(method: &apianyware_macos_types::ir::Method) -> Vec<String> {
    let mut reasons = Vec::new();
    let sel_lower = method.selector.to_lowercase();

    // Block parameters — invocation style may be ambiguous
    let has_block = method
        .params
        .iter()
        .any(|p| matches!(p.param_type.kind, TypeRefKind::Block { .. }));
    if has_block {
        reasons.push("has_block_params".to_string());
    }

    // Error out-param — last param named "error" with pointer type
    if let Some(last) = method.params.last() {
        let name_lower = last.name.to_lowercase();
        if (name_lower == "error" || name_lower.ends_with("error"))
            && matches!(last.param_type.kind, TypeRefKind::Pointer)
        {
            reasons.push("error_out_param".to_string());
        }
    }

    // Delegate/observer/target patterns in selector
    if sel_lower.contains("delegate")
        || sel_lower.contains("datasource")
        || sel_lower.contains("observer")
    {
        reasons.push("delegate_observer_pattern".to_string());
    }

    reasons
}

/// Produce a human-readable description of a type kind for LLM context.
fn describe_type_kind(kind: &TypeRefKind) -> String {
    match kind {
        TypeRefKind::Id => "id".to_string(),
        TypeRefKind::Class { name, .. } => format!("class:{name}"),
        TypeRefKind::ClassRef => "Class".to_string(),
        TypeRefKind::Selector => "SEL".to_string(),
        TypeRefKind::CString => "c_string".to_string(),
        TypeRefKind::Pointer => "pointer".to_string(),
        TypeRefKind::Primitive { name } => name.clone(),
        TypeRefKind::Struct { name } => format!("struct:{name}"),
        TypeRefKind::Alias { name, .. } => format!("alias:{name}"),
        TypeRefKind::Block { .. } => "block".to_string(),
        TypeRefKind::FunctionPointer { .. } => "function_pointer".to_string(),
        TypeRefKind::Instancetype => "instancetype".to_string(),
    }
}

/// Extract interesting methods from all resolved frameworks and write summaries.
///
/// Loads all frameworks from `input_dir`, extracts interesting methods, and
/// writes per-framework `.methods.json` files to `output_dir`. Frameworks
/// with no interesting methods are skipped.
pub fn extract_all_frameworks(
    input_dir: &Path,
    output_dir: &Path,
    only: Option<&[String]>,
) -> Result<Vec<FrameworkSummary>> {
    let frameworks = apianyware_macos_datalog::loading::load_all_frameworks(input_dir, only)?;
    if frameworks.is_empty() {
        anyhow::bail!("no frameworks found in {}", input_dir.display());
    }

    tracing::info!(
        count = frameworks.len(),
        "loaded frameworks for LLM extraction"
    );

    let mut summaries = Vec::new();

    for framework in &frameworks {
        let summary = extract_interesting_methods(framework);
        if summary.method_count == 0 {
            tracing::info!(framework = %framework.name, "no interesting methods, skipping");
            continue;
        }

        write_method_summary(&summary, output_dir)?;
        summaries.push(summary);
    }

    Ok(summaries)
}

/// Write a framework method summary to a JSON file.
pub fn write_method_summary(summary: &FrameworkSummary, output_dir: &Path) -> Result<()> {
    std::fs::create_dir_all(output_dir)
        .with_context(|| format!("failed to create {}", output_dir.display()))?;

    let path = output_dir.join(format!("{}.methods.json", summary.framework));
    let json = serde_json::to_string_pretty(summary)
        .with_context(|| format!("failed to serialize summary for {}", summary.framework))?;
    std::fs::write(&path, json).with_context(|| format!("failed to write {}", path.display()))?;

    tracing::info!(
        framework = %summary.framework,
        classes = summary.classes.len(),
        methods = summary.method_count,
        path = %path.display(),
        "wrote method summary"
    );

    Ok(())
}

/// Load LLM annotations from a `.llm.json` file.
///
/// Returns `None` if the file doesn't exist. Returns an error if the file
/// exists but is malformed.
pub fn load_llm_annotations(
    llm_dir: &Path,
    framework_name: &str,
) -> Result<Option<FrameworkAnnotations>> {
    let path = llm_dir.join(format!("{framework_name}.llm.json"));
    if !path.exists() {
        return Ok(None);
    }

    let content = std::fs::read_to_string(&path)
        .with_context(|| format!("failed to read {}", path.display()))?;

    let annotations: FrameworkAnnotations = serde_json::from_str(&content)
        .with_context(|| format!("failed to parse LLM annotations from {}", path.display()))?;

    let method_count: usize = annotations.classes.iter().map(|c| c.methods.len()).sum();
    tracing::info!(
        framework = framework_name,
        classes = annotations.classes.len(),
        methods = method_count,
        "loaded LLM annotations"
    );

    Ok(Some(annotations))
}

/// Scan an LLM annotations directory and return framework names that have `.llm.json` files.
pub fn discover_llm_annotations(llm_dir: &Path) -> Result<Vec<String>> {
    if !llm_dir.exists() {
        return Ok(Vec::new());
    }

    let mut frameworks = Vec::new();
    for entry in std::fs::read_dir(llm_dir)
        .with_context(|| format!("failed to read {}", llm_dir.display()))?
    {
        let entry = entry?;
        let name = entry.file_name();
        let name_str = name.to_string_lossy();
        if let Some(fw_name) = name_str.strip_suffix(".llm.json") {
            frameworks.push(fw_name.to_string());
        }
    }

    frameworks.sort();
    Ok(frameworks)
}

#[cfg(test)]
mod tests {
    use super::*;
    use apianyware_macos_types::annotation::ClassAnnotations;
    use apianyware_macos_types::ir::{CategoryGroup, Class, Method, Param};
    use apianyware_macos_types::type_ref::TypeRef;

    fn void_type() -> TypeRef {
        TypeRef {
            nullable: false,
            kind: TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        }
    }

    fn id_type() -> TypeRef {
        TypeRef {
            nullable: false,
            kind: TypeRefKind::Id,
        }
    }

    fn block_type() -> TypeRef {
        TypeRef {
            nullable: false,
            kind: TypeRefKind::Block {
                params: vec![],
                return_type: Box::new(void_type()),
            },
        }
    }

    fn pointer_type() -> TypeRef {
        TypeRef {
            nullable: false,
            kind: TypeRefKind::Pointer,
        }
    }

    fn make_method(selector: &str, params: Vec<Param>, return_type: TypeRef) -> Method {
        Method {
            selector: selector.to_string(),
            class_method: false,
            init_method: false,
            params,
            return_type,
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

    fn make_class(name: &str, methods: Vec<Method>) -> Class {
        Class {
            name: name.to_string(),
            superclass: String::new(),
            protocols: vec![],
            properties: vec![],
            methods,
            category_methods: vec![],
            ancestors: vec![],
            all_methods: vec![],
            all_properties: vec![],
        }
    }

    fn make_framework(name: &str, classes: Vec<Class>) -> Framework {
        Framework {
            format_version: String::new(),
            checkpoint: "resolved".to_string(),
            name: name.to_string(),
            sdk_version: None,
            collected_at: None,
            depends_on: vec![],
            skipped_symbols: vec![],
            classes,
            protocols: vec![],
            enums: vec![],
            structs: vec![],
            functions: vec![],
            constants: vec![],
            class_annotations: vec![],
            api_patterns: vec![],
            enrichment: None,
            verification: None,
        }
    }

    #[test]
    fn extract_method_with_block_param() {
        let method = make_method(
            "performWithCompletion:",
            vec![Param {
                name: "handler".to_string(),
                param_type: block_type(),
            }],
            void_type(),
        );
        let fw = make_framework("TestKit", vec![make_class("TKFoo", vec![method])]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.framework, "TestKit");
        assert_eq!(summary.classes.len(), 1);
        assert_eq!(summary.classes[0].methods.len(), 1);
        assert_eq!(
            summary.classes[0].methods[0].selector,
            "performWithCompletion:"
        );
        assert!(summary.classes[0].methods[0]
            .reasons
            .contains(&"has_block_params".to_string()));
    }

    #[test]
    fn extract_method_with_error_outparam() {
        let method = make_method(
            "writeToURL:error:",
            vec![
                Param {
                    name: "url".to_string(),
                    param_type: id_type(),
                },
                Param {
                    name: "error".to_string(),
                    param_type: pointer_type(),
                },
            ],
            id_type(),
        );
        let fw = make_framework("TestKit", vec![make_class("TKWriter", vec![method])]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.classes.len(), 1);
        assert!(summary.classes[0].methods[0]
            .reasons
            .contains(&"error_out_param".to_string()));
    }

    #[test]
    fn extract_method_with_delegate_selector() {
        let method = make_method(
            "setDelegate:",
            vec![Param {
                name: "delegate".to_string(),
                param_type: id_type(),
            }],
            void_type(),
        );
        let fw = make_framework("TestKit", vec![make_class("TKView", vec![method])]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.classes.len(), 1);
        assert!(summary.classes[0].methods[0]
            .reasons
            .contains(&"delegate_observer_pattern".to_string()));
    }

    #[test]
    fn skip_boring_method() {
        let method = make_method(
            "count",
            vec![],
            TypeRef {
                nullable: false,
                kind: TypeRefKind::Primitive {
                    name: "NSUInteger".to_string(),
                },
            },
        );
        let fw = make_framework("TestKit", vec![make_class("TKArray", vec![method])]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.classes.len(), 0);
        assert_eq!(summary.method_count, 0);
    }

    #[test]
    fn multiple_reasons_on_same_method() {
        // A method with both a block param and delegate in the selector
        let method = make_method(
            "addObserverWithBlock:",
            vec![Param {
                name: "block".to_string(),
                param_type: block_type(),
            }],
            void_type(),
        );
        let fw = make_framework("TestKit", vec![make_class("TKCenter", vec![method])]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.classes[0].methods[0].reasons.len(), 2);
        assert!(summary.classes[0].methods[0]
            .reasons
            .contains(&"has_block_params".to_string()));
        assert!(summary.classes[0].methods[0]
            .reasons
            .contains(&"delegate_observer_pattern".to_string()));
    }

    #[test]
    fn method_count_tracks_total() {
        let methods = vec![
            make_method(
                "setDelegate:",
                vec![Param {
                    name: "d".to_string(),
                    param_type: id_type(),
                }],
                void_type(),
            ),
            make_method(
                "doBlock:",
                vec![Param {
                    name: "b".to_string(),
                    param_type: block_type(),
                }],
                void_type(),
            ),
        ];
        let fw = make_framework("TestKit", vec![make_class("TKFoo", methods)]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.method_count, 2);
    }

    #[test]
    fn category_methods_included() {
        let mut class = make_class("TKBase", vec![]);
        class.category_methods.push(CategoryGroup {
            category: "TKExtension".to_string(),
            origin_framework: "TestKit".to_string(),
            methods: vec![make_method(
                "performBlock:",
                vec![Param {
                    name: "block".to_string(),
                    param_type: block_type(),
                }],
                void_type(),
            )],
        });
        let fw = make_framework("TestKit", vec![class]);

        let summary = extract_interesting_methods(&fw);

        assert_eq!(summary.classes.len(), 1);
        assert_eq!(summary.classes[0].methods.len(), 1);
        assert_eq!(summary.classes[0].methods[0].selector, "performBlock:");
    }

    #[test]
    fn type_kind_descriptions() {
        assert_eq!(describe_type_kind(&TypeRefKind::Id), "id");
        assert_eq!(describe_type_kind(&TypeRefKind::Pointer), "pointer");
        assert_eq!(
            describe_type_kind(&TypeRefKind::Primitive {
                name: "BOOL".to_string()
            }),
            "BOOL"
        );
        assert_eq!(
            describe_type_kind(&TypeRefKind::Struct {
                name: "CGRect".to_string()
            }),
            "struct:CGRect"
        );
        assert_eq!(describe_type_kind(&block_type().kind), "block");
    }

    #[test]
    fn load_nonexistent_llm_file_returns_none() {
        let dir = std::env::temp_dir().join("test_llm_load_none");
        let _ = std::fs::create_dir_all(&dir);
        let result = load_llm_annotations(&dir, "Nonexistent").unwrap();
        assert!(result.is_none());
    }

    #[test]
    fn load_valid_llm_file() {
        let dir = std::env::temp_dir().join("test_llm_load_valid");
        let _ = std::fs::create_dir_all(&dir);

        let annotations = FrameworkAnnotations {
            framework: "TestKit".to_string(),
            classes: vec![ClassAnnotations {
                class_name: "TKFoo".to_string(),
                methods: vec![],
            }],
        };

        let path = dir.join("TestKit.llm.json");
        std::fs::write(&path, serde_json::to_string(&annotations).unwrap()).unwrap();

        let result = load_llm_annotations(&dir, "TestKit").unwrap();
        assert!(result.is_some());
        let fa = result.unwrap();
        assert_eq!(fa.framework, "TestKit");
        assert_eq!(fa.classes.len(), 1);

        // Cleanup
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn load_malformed_llm_file_returns_error() {
        let dir = std::env::temp_dir().join("test_llm_load_bad");
        let _ = std::fs::create_dir_all(&dir);

        let path = dir.join("BadKit.llm.json");
        std::fs::write(&path, "not valid json {{{").unwrap();

        let result = load_llm_annotations(&dir, "BadKit");
        assert!(result.is_err());

        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn discover_llm_annotations_finds_files() {
        let dir = std::env::temp_dir().join("test_llm_discover");
        let _ = std::fs::create_dir_all(&dir);

        std::fs::write(dir.join("Foundation.llm.json"), "{}").unwrap();
        std::fs::write(dir.join("AppKit.llm.json"), "{}").unwrap();
        std::fs::write(dir.join("other.json"), "{}").unwrap(); // not .llm.json

        let result = discover_llm_annotations(&dir).unwrap();
        assert_eq!(result, vec!["AppKit", "Foundation"]);

        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn discover_nonexistent_dir_returns_empty() {
        let dir = std::env::temp_dir().join("test_llm_discover_none_12345");
        let result = discover_llm_annotations(&dir).unwrap();
        assert!(result.is_empty());
    }

    #[test]
    fn write_and_read_summary_roundtrip() {
        let method = make_method(
            "doBlock:",
            vec![Param {
                name: "handler".to_string(),
                param_type: block_type(),
            }],
            void_type(),
        );
        let fw = make_framework("TestKit", vec![make_class("TKFoo", vec![method])]);
        let summary = extract_interesting_methods(&fw);

        let dir = std::env::temp_dir().join("test_llm_roundtrip");
        write_method_summary(&summary, &dir).unwrap();

        let path = dir.join("TestKit.methods.json");
        let content = std::fs::read_to_string(&path).unwrap();
        let loaded: FrameworkSummary = serde_json::from_str(&content).unwrap();

        assert_eq!(loaded.framework, "TestKit");
        assert_eq!(loaded.method_count, 1);
        assert_eq!(loaded.classes[0].methods[0].selector, "doBlock:");

        let _ = std::fs::remove_dir_all(&dir);
    }
}
