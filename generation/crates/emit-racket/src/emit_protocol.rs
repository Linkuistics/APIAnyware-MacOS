//! Racket protocol file code generation.
//!
//! Generates protocol definition files with `make-<protocol>` helper functions
//! for creating delegate instances.

use apianyware_macos_emit::code_writer::CodeWriter;
use apianyware_macos_emit::naming::camel_to_kebab;
use apianyware_macos_emit::write_line;
use apianyware_macos_types::ir::{Method, Protocol};
use apianyware_macos_types::type_ref::TypeRefKind;

/// Generate a Racket protocol definition file.
pub fn generate_protocol_file(proto: &Protocol, framework: &str) -> String {
    let mut w = CodeWriter::new();
    let name = &proto.name;
    let lower_name = name.to_ascii_lowercase();

    let req = &proto.required_methods;
    let opt = &proto.optional_methods;
    let all_methods: Vec<&Method> = req.iter().chain(opt.iter()).collect();

    let void_methods: Vec<&&Method> = all_methods
        .iter()
        .filter(|m| method_return_kind(m) == "void")
        .collect();
    let bool_methods: Vec<&&Method> = all_methods
        .iter()
        .filter(|m| method_return_kind(m) == "bool")
        .collect();
    let id_methods: Vec<&&Method> = all_methods
        .iter()
        .filter(|m| method_return_kind(m) == "id")
        .collect();

    let helper_name = format!("make-{lower_name}");

    // Header
    w.line("#lang racket/base");
    write_line!(
        w,
        ";; Generated protocol definition for {} ({})",
        name,
        framework
    );
    w.line(";; Do not edit — regenerate from enriched IR");
    w.line(";;");
    write_line!(w, ";; {} defines {} methods:", name, all_methods.len());

    if !void_methods.is_empty() {
        write_line!(w, ";;   void-returning ({}):", void_methods.len());
        for m in &void_methods {
            write_line!(w, ";;     {}  ({})", m.selector, format_method_params(m));
        }
    }
    if !bool_methods.is_empty() {
        write_line!(w, ";;   bool-returning ({}):", bool_methods.len());
        for m in &bool_methods {
            write_line!(w, ";;     {}  ({})", m.selector, format_method_params(m));
        }
    }
    if !id_methods.is_empty() {
        write_line!(w, ";;   id-returning ({}):", id_methods.len());
        for m in &id_methods {
            write_line!(w, ";;     {}  ({})", m.selector, format_method_params(m));
        }
    }

    w.blank_line();
    w.line("(require \"../../../../runtime/delegate.rkt\")");
    w.blank_line();
    write_line!(w, "(provide {}", helper_name);
    write_line!(w, "         {}-selectors)", lower_name);
    w.blank_line();

    // Selector list
    w.line(";; All selectors in this protocol");
    write_line!(w, "(define {}-selectors", lower_name);
    w.raw("  '(");
    for (i, m) in all_methods.iter().enumerate() {
        if i > 0 {
            w.raw("\n    ");
        }
        w.raw(&format!("\"{}\"", m.selector));
    }
    w.raw_line("))\n");

    // Convenience constructor
    write_line!(w, ";; Create a {} delegate.", name);
    w.line(";; Pass selector string → handler procedure pairs.");
    w.line(";; Example:");
    write_line!(w, ";;   ({}", helper_name);
    if let Some(m) = void_methods.first() {
        let param_strs = format_param_names(m);
        write_line!(w, ";;     \"{}\" (lambda ({}) ...)", m.selector, param_strs,);
    }
    if let Some(m) = bool_methods.first() {
        let param_strs = format_param_names(m);
        write_line!(
            w,
            ";;     \"{}\" (lambda ({}) ... #t)",
            m.selector,
            param_strs,
        );
    }
    w.line(";;   )");
    write_line!(w, "(define ({} . selector+handler-pairs)", helper_name);

    // Build return-types hash for non-void methods
    let non_void: Vec<(&str, &str)> = bool_methods
        .iter()
        .map(|m| (m.selector.as_str(), "bool"))
        .chain(id_methods.iter().map(|m| (m.selector.as_str(), "id")))
        .collect();

    if non_void.is_empty() {
        w.line("  (apply make-delegate selector+handler-pairs))");
    } else {
        w.line("  (apply make-delegate");
        w.line("    #:return-types");
        w.raw("    (hash");
        for (sel, kind) in &non_void {
            w.raw(&format!(" \"{sel}\" '{kind}"));
        }
        w.raw_line(")");
        w.line("    selector+handler-pairs))");
    }

    w.finish()
}

fn method_return_kind(method: &Method) -> &'static str {
    match &method.return_type.kind {
        TypeRefKind::Primitive { name } if name == "void" => "void",
        TypeRefKind::Primitive { name } if name == "bool" => "bool",
        TypeRefKind::Class { .. } | TypeRefKind::Id | TypeRefKind::Instancetype => "id",
        _ => "void", // default for unhandled types (structs/aliases)
    }
}

fn format_method_params(method: &Method) -> String {
    method
        .params
        .iter()
        .map(|p| {
            let type_desc = match &p.param_type.kind {
                TypeRefKind::Class { name, .. } => name.clone(),
                TypeRefKind::Id => "id".to_string(),
                TypeRefKind::Instancetype => "instancetype".to_string(),
                TypeRefKind::Struct { name } => name.clone(),
                TypeRefKind::Alias { name, .. } => name.clone(),
                TypeRefKind::Primitive { name } => name.clone(),
                TypeRefKind::Block { .. } => "block".to_string(),
                TypeRefKind::Selector => "selector".to_string(),
                TypeRefKind::ClassRef => "class_ref".to_string(),
                TypeRefKind::Pointer => "pointer".to_string(),
            };
            format!("{}:{}", p.name, type_desc)
        })
        .collect::<Vec<_>>()
        .join(", ")
}

fn format_param_names(method: &Method) -> String {
    let names: Vec<String> = method
        .params
        .iter()
        .map(|p| camel_to_kebab(&p.name))
        .collect();
    names.join(" ")
}
