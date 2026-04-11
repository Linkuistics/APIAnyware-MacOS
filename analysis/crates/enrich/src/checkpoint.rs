//! Build and write enriched Framework checkpoints.
//!
//! Maps enrichment Datalog results back into the Framework IR struct,
//! populating the `enrichment` and `verification` fields. Also extracts
//! scoped resources and delegate protocols from `api_patterns`.

use std::collections::HashSet;
use std::path::Path;

use anyhow::{Context, Result};
use apianyware_macos_types::annotation::PatternStereotype;
use apianyware_macos_types::enrichment::{
    BlockMethodEntry, ClassSelectorEntry, EnrichmentData, ScopedResourceEntry, VerificationReport,
    Violation,
};
use apianyware_macos_types::ir::Framework;

use crate::program::EnrichmentProgram;

/// All Datalog-derived results filtered to a single framework.
///
/// Built once per framework from the global `EnrichmentProgram`, so that
/// downstream builders never need to filter by framework themselves.
struct FrameworkDerivedResults {
    sync_block_methods: Vec<BlockMethodEntry>,
    async_block_methods: Vec<BlockMethodEntry>,
    stored_block_methods: Vec<BlockMethodEntry>,
    delegate_protocols: Vec<String>,
    convenience_error_methods: Vec<ClassSelectorEntry>,
    collection_iterables: Vec<String>,
    main_thread_classes: Vec<String>,
    violations: Vec<Violation>,
}

/// Filter all Datalog results to a single framework's classes and protocols.
fn filter_results_for_framework(
    framework: &Framework,
    prog: &EnrichmentProgram,
) -> FrameworkDerivedResults {
    let framework_classes: HashSet<&str> = prog
        .class_decl
        .iter()
        .filter(|(_, _, fw)| fw == &framework.name)
        .map(|(class, _, _)| class.as_str())
        .collect();

    let framework_protocols: HashSet<&str> = framework
        .protocols
        .iter()
        .map(|p| p.name.as_str())
        .collect();

    // --- Enrichment relations ---

    let mut sync_block_methods: Vec<BlockMethodEntry> = prog
        .sync_block_method
        .iter()
        .filter(|(class, _, _)| framework_classes.contains(class.as_str()))
        .map(|(class, sel, idx)| BlockMethodEntry {
            class: class.clone(),
            selector: sel.clone(),
            param_index: *idx as usize,
        })
        .collect();
    sync_block_methods.sort_by(|a, b| a.class.cmp(&b.class).then(a.selector.cmp(&b.selector)));

    let mut async_block_methods: Vec<BlockMethodEntry> = prog
        .async_block_method
        .iter()
        .filter(|(class, _, _)| framework_classes.contains(class.as_str()))
        .map(|(class, sel, idx)| BlockMethodEntry {
            class: class.clone(),
            selector: sel.clone(),
            param_index: *idx as usize,
        })
        .collect();
    async_block_methods.sort_by(|a, b| a.class.cmp(&b.class).then(a.selector.cmp(&b.selector)));

    let mut stored_block_methods: Vec<BlockMethodEntry> = prog
        .stored_block_method
        .iter()
        .filter(|(class, _, _)| framework_classes.contains(class.as_str()))
        .map(|(class, sel, idx)| BlockMethodEntry {
            class: class.clone(),
            selector: sel.clone(),
            param_index: *idx as usize,
        })
        .collect();
    stored_block_methods.sort_by(|a, b| a.class.cmp(&b.class).then(a.selector.cmp(&b.selector)));

    let mut delegate_protocols: Vec<String> = prog
        .delegate_protocol
        .iter()
        .filter(|(p,)| framework_protocols.contains(p.as_str()))
        .map(|(p,)| p.clone())
        .collect();
    delegate_protocols.sort();
    delegate_protocols.dedup();

    let mut convenience_error_methods: Vec<ClassSelectorEntry> = prog
        .convenience_error_method
        .iter()
        .filter(|(class, _)| framework_classes.contains(class.as_str()))
        .map(|(class, sel)| ClassSelectorEntry {
            class: class.clone(),
            selector: sel.clone(),
        })
        .collect();
    convenience_error_methods
        .sort_by(|a, b| a.class.cmp(&b.class).then(a.selector.cmp(&b.selector)));

    let mut collection_iterables: Vec<String> = prog
        .collection_iterable
        .iter()
        .filter(|(class,)| framework_classes.contains(class.as_str()))
        .map(|(class,)| class.clone())
        .collect();
    collection_iterables.sort();
    collection_iterables.dedup();

    let mut main_thread_classes: Vec<String> = prog
        .main_thread_class
        .iter()
        .filter(|(class,)| framework_classes.contains(class.as_str()))
        .map(|(class,)| class.clone())
        .collect();
    main_thread_classes.sort();
    main_thread_classes.dedup();

    // --- Violations ---

    let mut violations = Vec::new();

    for (class, sel, idx) in &prog.violation_unclassified_block {
        if framework_classes.contains(class.as_str()) {
            violations.push(Violation {
                rule: "unclassified_block".to_string(),
                class: class.clone(),
                selector: sel.clone(),
                param_index: Some(*idx as usize),
                description: format!(
                    "block parameter {idx} of {class}.{sel} has no sync/async/stored classification"
                ),
            });
        }
    }

    for (class, sel) in &prog.violation_flag_mismatch {
        if framework_classes.contains(class.as_str()) {
            violations.push(Violation {
                rule: "flag_mismatch".to_string(),
                class: class.clone(),
                selector: sel.clone(),
                param_index: None,
                description: format!(
                    "returns_retained flag on {class}.{sel} disagrees with ownership naming convention"
                ),
            });
        }
    }

    violations.sort_by(|a, b| {
        a.rule
            .cmp(&b.rule)
            .then(a.class.cmp(&b.class))
            .then(a.selector.cmp(&b.selector))
    });

    FrameworkDerivedResults {
        sync_block_methods,
        async_block_methods,
        stored_block_methods,
        delegate_protocols,
        convenience_error_methods,
        collection_iterables,
        main_thread_classes,
        violations,
    }
}

/// Write an enriched framework checkpoint to `{output_dir}/{framework.name}.json`.
pub fn write_enriched_checkpoint(framework: &Framework, output_dir: &Path) -> Result<()> {
    let path = output_dir.join(format!("{}.json", framework.name));
    let json = serde_json::to_string_pretty(framework)
        .with_context(|| format!("failed to serialize {}", framework.name))?;
    std::fs::write(&path, json).with_context(|| format!("failed to write {}", path.display()))?;
    tracing::info!(
        framework = %framework.name,
        path = %path.display(),
        "wrote enriched checkpoint"
    );
    Ok(())
}

/// Build an enriched framework from annotated IR + Datalog results.
///
/// Clones the annotated framework and populates enrichment-phase fields:
/// - `checkpoint` → `"enriched"`
/// - `enrichment` — all annotation-derived relations
/// - `verification` — pass/fail + violations
pub fn build_enriched_framework(annotated: &Framework, prog: &EnrichmentProgram) -> Framework {
    let filtered = filter_results_for_framework(annotated, prog);
    let enrichment = build_enrichment_data(annotated, &filtered);
    let verification = VerificationReport {
        passed: filtered.violations.is_empty(),
        violations: filtered.violations,
    };

    let mut enriched = annotated.clone();
    enriched.checkpoint = "enriched".to_string();
    enriched.enrichment = Some(enrichment);
    enriched.verification = Some(verification);
    enriched
}

/// Build EnrichmentData from pre-filtered Datalog results + framework api_patterns.
fn build_enrichment_data(
    framework: &Framework,
    filtered: &FrameworkDerivedResults,
) -> EnrichmentData {
    // Merge delegate protocols from api_patterns (LLM-detected)
    let mut delegate_protocols = filtered.delegate_protocols.clone();
    for pattern in &framework.api_patterns {
        if pattern.stereotype == PatternStereotype::DelegateProtocol {
            if let Some(proto_name) = extract_delegate_protocol_name(&pattern.name) {
                if !delegate_protocols.contains(&proto_name) {
                    delegate_protocols.push(proto_name);
                }
            }
        }
    }
    delegate_protocols.sort();
    delegate_protocols.dedup();

    // Collect scoped resources from api_patterns (already per-framework)
    let mut scoped_resources = extract_scoped_resources(framework);
    scoped_resources.sort_by(|a, b| {
        a.class
            .cmp(&b.class)
            .then(a.open_selector.cmp(&b.open_selector))
    });

    EnrichmentData {
        sync_block_methods: filtered.sync_block_methods.clone(),
        async_block_methods: filtered.async_block_methods.clone(),
        stored_block_methods: filtered.stored_block_methods.clone(),
        delegate_protocols,
        convenience_error_methods: filtered.convenience_error_methods.clone(),
        collection_iterables: filtered.collection_iterables.clone(),
        scoped_resources,
        main_thread_classes: filtered.main_thread_classes.clone(),
    }
}

/// Extract scoped resources from api_patterns with PairedState or ResourceLifecycle stereotypes.
fn extract_scoped_resources(framework: &Framework) -> Vec<ScopedResourceEntry> {
    let mut resources = Vec::new();

    for pattern in &framework.api_patterns {
        match pattern.stereotype {
            PatternStereotype::PairedState | PatternStereotype::ResourceLifecycle => {
                if let Some(entry) = extract_scoped_resource_from_pattern(pattern) {
                    resources.push(entry);
                }
            }
            _ => {}
        }
    }

    resources
}

/// Try to extract a ScopedResourceEntry from a pattern's participants JSON.
///
/// Looks for `open`/`close`, `begin`/`end`, `lock`/`unlock`, or `enable`/`disable` keys.
fn extract_scoped_resource_from_pattern(
    pattern: &apianyware_macos_types::annotation::ApiPattern,
) -> Option<ScopedResourceEntry> {
    let participants = &pattern.participants;

    // Try various key pairs for open/close
    let open_close_pairs = [
        ("open", "close"),
        ("begin", "end"),
        ("lock", "unlock"),
        ("enable", "disable"),
    ];

    for (open_key, close_key) in &open_close_pairs {
        if let (Some(open_val), Some(close_val)) =
            (participants.get(open_key), participants.get(close_key))
        {
            let class = extract_class_from_participant(open_val)
                .or_else(|| extract_class_from_participant(close_val));
            let open_sel = extract_selector_from_participant(open_val)?;
            let close_sel = extract_selector_from_participant(close_val)?;

            return Some(ScopedResourceEntry {
                class: class.unwrap_or_else(|| pattern.name.clone()),
                open_selector: open_sel,
                close_selector: close_sel,
            });
        }
    }

    None
}

/// Extract a class name from a pattern participant JSON value.
fn extract_class_from_participant(value: &serde_json::Value) -> Option<String> {
    value
        .get("class")
        .and_then(|v| v.as_str())
        .map(|s| s.to_string())
}

/// Extract a selector from a pattern participant JSON value.
fn extract_selector_from_participant(value: &serde_json::Value) -> Option<String> {
    // Try "selector" first, then "function"
    value
        .get("selector")
        .or_else(|| value.get("function"))
        .and_then(|v| v.as_str())
        .map(|s| s.to_string())
}

/// Extract delegate protocol name from a pattern name like "NSWindow delegate (NSWindowDelegate)".
fn extract_delegate_protocol_name(pattern_name: &str) -> Option<String> {
    // Try to extract from parenthesized name
    if let Some(start) = pattern_name.rfind('(') {
        if let Some(end) = pattern_name.rfind(')') {
            if start < end {
                return Some(pattern_name[start + 1..end].to_string());
            }
        }
    }
    // If no parens, look for a protocol-like name
    let parts: Vec<&str> = pattern_name.split_whitespace().collect();
    parts
        .iter()
        .find(|p| p.ends_with("Delegate") || p.ends_with("DataSource"))
        .map(|p| p.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    use apianyware_macos_types::annotation::{
        AnnotationSource, ApiPattern, PatternConstraint, PatternStereotype,
    };

    #[test]
    fn extract_delegate_protocol_name_from_parens() {
        assert_eq!(
            extract_delegate_protocol_name("NSWindow delegate (NSWindowDelegate)"),
            Some("NSWindowDelegate".to_string())
        );
    }

    #[test]
    fn extract_delegate_protocol_name_from_word() {
        assert_eq!(
            extract_delegate_protocol_name("NSTableViewDelegate"),
            Some("NSTableViewDelegate".to_string())
        );
    }

    #[test]
    fn extract_scoped_resource_from_paired_state_pattern() {
        let pattern = ApiPattern {
            stereotype: PatternStereotype::PairedState,
            name: "NSLock critical section".to_string(),
            participants: serde_json::json!({
                "lock": { "class": "NSLock", "selector": "lock" },
                "unlock": { "class": "NSLock", "selector": "unlock" }
            }),
            constraints: vec![PatternConstraint {
                kind: "nesting".to_string(),
                description: "lock/unlock must be balanced".to_string(),
            }],
            source: AnnotationSource::Heuristic,
            doc_ref: None,
        };

        let entry = extract_scoped_resource_from_pattern(&pattern).unwrap();
        assert_eq!(entry.class, "NSLock");
        assert_eq!(entry.open_selector, "lock");
        assert_eq!(entry.close_selector, "unlock");
    }

    #[test]
    fn extract_scoped_resource_from_begin_end_pattern() {
        let pattern = ApiPattern {
            stereotype: PatternStereotype::PairedState,
            name: "NSUndoManager grouping".to_string(),
            participants: serde_json::json!({
                "begin": { "class": "NSUndoManager", "selector": "beginUndoGrouping" },
                "end": { "class": "NSUndoManager", "selector": "endUndoGrouping" }
            }),
            constraints: vec![],
            source: AnnotationSource::Heuristic,
            doc_ref: None,
        };

        let entry = extract_scoped_resource_from_pattern(&pattern).unwrap();
        assert_eq!(entry.class, "NSUndoManager");
        assert_eq!(entry.open_selector, "beginUndoGrouping");
        assert_eq!(entry.close_selector, "endUndoGrouping");
    }
}
