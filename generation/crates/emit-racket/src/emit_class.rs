//! Racket class file code generation.
//!
//! Produces a single `.rkt` file for an ObjC class, including:
//! - Module header (requires, framework loading)
//! - Shared typed objc_msgSend bindings
//! - Constructor wrappers (init methods)
//! - Property accessors (getters + setters)
//! - Method wrappers (instance + class methods)

use apianyware_macos_emit::code_writer::CodeWriter;
use apianyware_macos_emit::ffi_type_mapping::{FfiTypeMapper, RacketFfiTypeMapper};
use apianyware_macos_emit::naming::camel_to_kebab;
use apianyware_macos_emit::write_line;
use apianyware_macos_types::ir::{Class, Method, Param, Property};
use apianyware_macos_types::type_ref::TypeRefKind;

use crate::method_filter::{
    all_params_are_object_type, dispatch_strategy, is_supported_method, returns_object_type,
    returns_void, DispatchStrategy,
};
use crate::naming::{
    make_method_name, make_property_getter_name, make_property_setter_name,
    make_unique_constructor_name,
};
use crate::shared_signatures::{
    block_ffi_types, class_has_blocks, collect_class_signatures, SignatureMap,
};

/// Generate a complete Racket class binding file.
pub fn generate_class_file(cls: &Class, framework: &str) -> String {
    let mapper = RacketFfiTypeMapper;
    let mut w = CodeWriter::new();

    let methods = effective_methods(cls);
    let properties = effective_properties(cls);

    // Build property name set for collision detection
    let property_names = build_property_name_set(cls, &properties);

    // Separate method categories
    let init_methods: Vec<&Method> = methods.iter().filter(|m| m.init_method).copied().collect();
    let class_methods: Vec<&Method> = methods
        .iter()
        .filter(|m| {
            m.class_method
                && !m.init_method
                && !method_collides_with_property(&cls.name, m, &property_names)
        })
        .copied()
        .collect();
    let instance_methods: Vec<&Method> = methods
        .iter()
        .filter(|m| {
            !m.class_method
                && !m.init_method
                && !method_collides_with_property(&cls.name, m, &property_names)
        })
        .copied()
        .collect();

    let needs_blocks = class_has_blocks(cls);
    let sig_map = collect_class_signatures(cls, &mapper);

    // Header
    emit_header(&mut w, &cls.name, framework, needs_blocks);

    // Provide (excluding internal names)
    emit_provide(&mut w, &sig_map);

    // Class reference
    w.line(";; --- Class reference ---");
    write_line!(w, "(import-class {})", cls.name);

    // Shared msgSend bindings
    emit_shared_msg_bindings(&mut w, &sig_map);

    // Constructors
    if !init_methods.is_empty() {
        w.line(";; --- Constructors ---");
        for m in &init_methods {
            emit_constructor(&mut w, &cls.name, m, &sig_map, &mapper);
        }
        w.blank_line();
    }

    // Properties
    if !properties.is_empty() {
        w.line(";; --- Properties ---");
        for p in &properties {
            emit_property(&mut w, &cls.name, p, &sig_map, &mapper);
        }
        w.blank_line();
    }

    // Instance methods
    if !instance_methods.is_empty() {
        w.line(";; --- Instance methods ---");
        for m in &instance_methods {
            emit_method(&mut w, &cls.name, m, false, &sig_map, &mapper);
        }
    }

    // Class methods
    if !class_methods.is_empty() {
        w.blank_line();
        w.line(";; --- Class methods ---");
        for m in &class_methods {
            emit_method(&mut w, &cls.name, m, true, &sig_map, &mapper);
        }
    }

    w.finish()
}

/// Determine if a method returns a retained (+1) object per Cocoa naming conventions.
fn method_returns_retained(method: &Method) -> bool {
    // Use the IR's computed value if available (from resolve step)
    if let Some(retained) = method.returns_retained {
        return retained;
    }
    // Fall back to naming convention heuristic
    let sel = &method.selector;
    let is_cm = method.class_method;

    if !is_cm && is_family_match(sel, "init") {
        return true;
    }
    if is_cm && is_family_match(sel, "new") {
        return true;
    }
    is_family_match(sel, "copy") || is_family_match(sel, "mutableCopy")
}

/// Check if a selector belongs to a method family.
fn is_family_match(selector: &str, family: &str) -> bool {
    if selector == family {
        return true;
    }
    if selector.len() > family.len() && selector.starts_with(family) {
        let next = selector.as_bytes()[family.len()];
        return next.is_ascii_uppercase() || next == b':' || next == b'(';
    }
    false
}

fn effective_methods(cls: &Class) -> Vec<&Method> {
    if cls.all_methods.is_empty() {
        cls.methods.iter().collect()
    } else {
        cls.all_methods.iter().collect()
    }
}

fn effective_properties(cls: &Class) -> Vec<&Property> {
    if cls.all_properties.is_empty() {
        cls.properties.iter().collect()
    } else {
        cls.all_properties.iter().collect()
    }
}

fn build_property_name_set(
    cls: &Class,
    properties: &[&Property],
) -> std::collections::HashSet<String> {
    let mut names = std::collections::HashSet::new();
    for p in properties {
        names.insert(make_property_getter_name(&cls.name, &p.name));
        if !p.readonly {
            names.insert(make_property_setter_name(&cls.name, &p.name));
        }
    }
    names
}

fn method_collides_with_property(
    class_name: &str,
    method: &Method,
    property_names: &std::collections::HashSet<String>,
) -> bool {
    let fn_name = make_method_name(class_name, &method.selector);
    property_names.contains(&fn_name)
}

// --- Header ---

fn emit_header(w: &mut CodeWriter, class_name: &str, framework: &str, needs_blocks: bool) {
    w.line("#lang racket/base");
    write_line!(w, ";; Generated binding for {} ({})", class_name, framework);
    w.line(";; Do not edit — regenerate from enriched IR");
    w.blank_line();
    w.line("(require ffi/unsafe");
    w.raw("         ffi/unsafe/objc\n");
    w.raw("         \"../../runtime/objc-base.rkt\"\n");
    w.raw("         \"../../runtime/coerce.rkt\"");
    if needs_blocks {
        w.raw("\n         \"../../runtime/block.rkt\"");
    }
    w.raw_line(")");
    w.blank_line();
    w.line(";; Load framework and ObjC runtime");
    write_line!(
        w,
        "(define _fw-lib (ffi-lib \"/System/Library/Frameworks/{0}.framework/{0}\"))",
        framework
    );
    w.line("(define _objc-lib (ffi-lib \"libobjc\"))");
    w.blank_line();
}

// --- Provide ---

fn emit_provide(w: &mut CodeWriter, sig_map: &SignatureMap) {
    w.raw("(provide (except-out (all-defined-out) _fw-lib _objc-lib");
    for i in 0..sig_map.len() {
        w.raw(&format!(" _msg-{i}"));
    }
    w.raw_line("))");
    w.blank_line();
}

// --- Shared msgSend bindings ---

fn emit_shared_msg_bindings(w: &mut CodeWriter, sig_map: &SignatureMap) {
    if sig_map.is_empty() {
        w.blank_line();
        return;
    }

    w.blank_line();
    w.line(";; --- Shared typed objc_msgSend bindings ---");
    for (key, id) in sig_map.iter_sorted() {
        let (param_str, ret_str) = SignatureMap::parse_key(key);
        let param_types: Vec<&str> = if param_str.is_empty() {
            vec![]
        } else {
            param_str.split(' ').collect()
        };

        // Comment showing the signature
        let mut comment = format!("(define _msg-{id}  ; (_fun _pointer _pointer");
        for pt in &param_types {
            comment.push(' ');
            comment.push_str(pt);
        }
        comment.push_str(&format!(" -> {ret_str})"));
        w.line(&comment);

        // Binding definition
        let mut binding =
            String::from("  (get-ffi-obj \"objc_msgSend\" _objc-lib (_fun _pointer _pointer");
        for pt in &param_types {
            binding.push(' ');
            binding.push_str(pt);
        }
        binding.push_str(&format!(" -> {ret_str})))"));
        w.line(&binding);
    }
    w.blank_line();
}

// --- Constructors ---

fn emit_constructor(
    w: &mut CodeWriter,
    class_name: &str,
    method: &Method,
    sig_map: &SignatureMap,
    mapper: &dyn FfiTypeMapper,
) {
    if !is_supported_method(method) || method.selector == "init" {
        return;
    }

    let param_names: Vec<String> = method
        .params
        .iter()
        .map(|p| camel_to_kebab(&p.name))
        .collect();
    let fn_name = make_unique_constructor_name(class_name, &method.selector);

    // Function signature
    let mut sig = format!("(define ({fn_name}");
    for pn in &param_names {
        sig.push(' ');
        sig.push_str(pn);
    }
    sig.push(')');
    w.line(&sig);

    if all_params_are_object_type(&method.params, mapper) {
        // Tell path
        let tell_args = format_tell_args(&method.selector, &param_names, &method.params);
        w.line("  (wrap-objc-object");
        write_line!(w, "   (tell (tell {} alloc)", class_name);
        write_line!(w, "         {})", tell_args);
        w.line("   #:retained #t))");
    } else {
        // Typed objc_msgSend path
        emit_typed_constructor(w, class_name, method, &param_names, sig_map, mapper);
    }
    w.blank_line();
}

fn emit_typed_constructor(
    w: &mut CodeWriter,
    class_name: &str,
    method: &Method,
    param_names: &[String],
    sig_map: &SignatureMap,
    mapper: &dyn FfiTypeMapper,
) {
    let param_types: Vec<String> = method
        .params
        .iter()
        .map(|p| mapper.map_type(&p.param_type, false))
        .collect();

    let mut call_args: Vec<String> = param_names.to_vec();

    // Block wrapping
    emit_block_wrapping(w, &method.params, &mut call_args, mapper);

    // Coerce id-kind params
    coerce_id_params(&method.params, &mut call_args, mapper);

    let shared_name = sig_map.lookup(&param_types, "_id");
    match shared_name {
        Some(name) => {
            w.line("  (wrap-objc-object");
            write_line!(w, "   ({} (tell {} alloc)", name, class_name);
            w.raw(&format!(
                "       (sel_registerName \"{}\")",
                method.selector
            ));
            for arg in &call_args {
                w.raw(&format!("\n       {arg}"));
            }
            w.raw_line(")");
            w.line("   #:retained #t))");
        }
        None => {
            let inline_name = format!(
                "_msg-{}",
                apianyware_macos_emit::naming::selector_to_kebab_name(&method.selector)
                    .replace('-', "_")
            );
            write_line!(w, "  (let ([{}", inline_name);
            w.raw("         (get-ffi-obj \"objc_msgSend\" _objc-lib\n");
            w.raw("           (_fun _pointer _pointer");
            for pt in &param_types {
                w.raw(&format!(" {pt}"));
            }
            w.raw_line(" -> _id))]");
            w.line("    (wrap-objc-object");
            write_line!(w, "     ({} (tell {} alloc)", inline_name, class_name);
            w.raw(&format!(
                "         (sel_registerName \"{}\")",
                method.selector
            ));
            for arg in &call_args {
                w.raw(&format!("\n         {arg}"));
            }
            w.raw_line(")");
            w.line("     #:retained #t))))");
        }
    }
}

// --- Properties ---

fn emit_property(
    w: &mut CodeWriter,
    class_name: &str,
    prop: &Property,
    sig_map: &SignatureMap,
    mapper: &dyn FfiTypeMapper,
) {
    let getter_name = make_property_getter_name(class_name, &prop.name);
    let ffi_type = mapper.map_type(&prop.property_type, false);

    // Getter
    // Property getters return autoreleased (+0) objects, so #:retained is #f (default).
    if prop.class_property && ffi_type == "_id" {
        write_line!(w, "(define ({})", getter_name);
        write_line!(w, "  (wrap-objc-object");
        write_line!(w, "   (tell {} {})))", class_name, prop.name);
    } else if ffi_type == "_id" {
        write_line!(w, "(define ({} self)", getter_name);
        write_line!(w, "  (wrap-objc-object");
        write_line!(w, "   (tell (coerce-arg self) {})))", prop.name);
    } else if prop.class_property {
        write_line!(w, "(define ({})", getter_name);
        write_line!(
            w,
            "  (tell #:type {} {} {}))",
            ffi_type,
            class_name,
            prop.name
        );
    } else {
        write_line!(w, "(define ({} self)", getter_name);
        write_line!(
            w,
            "  (tell #:type {} (coerce-arg self) {}))",
            ffi_type,
            prop.name
        );
    }

    // Setter (if not readonly)
    if !prop.readonly {
        let first_char = prop.name.chars().next().unwrap_or('x');
        let setter_sel = format!(
            "set{}{}:",
            first_char.to_uppercase(),
            &prop.name[first_char.len_utf8()..]
        );
        let setter_name = make_property_setter_name(class_name, &prop.name);

        if ffi_type == "_id" {
            write_line!(w, "(define ({} self value)", setter_name);
            write_line!(
                w,
                "  (tell (coerce-arg self) {} (coerce-arg value)))",
                setter_sel
            );
        } else {
            let shared_name = sig_map.lookup(&[ffi_type.clone()], "_void");
            match shared_name {
                Some(name) => {
                    write_line!(w, "(define ({} self value)", setter_name);
                    write_line!(
                        w,
                        "  ({} (coerce-arg self) (sel_registerName \"{}\") value))",
                        name,
                        setter_sel
                    );
                }
                None => {
                    write_line!(w, "(define ({} self value)", setter_name);
                    w.line("  (let ([msg (get-ffi-obj \"objc_msgSend\" _objc-lib");
                    write_line!(
                        w,
                        "              (_fun _pointer _pointer {} -> _void))])",
                        ffi_type
                    );
                    write_line!(
                        w,
                        "    (msg (coerce-arg self) (sel_registerName \"{}\") value)))",
                        setter_sel
                    );
                }
            }
        }
    }
}

// --- Methods ---

fn emit_method(
    w: &mut CodeWriter,
    class_name: &str,
    method: &Method,
    is_class_method: bool,
    sig_map: &SignatureMap,
    mapper: &dyn FfiTypeMapper,
) {
    if !is_supported_method(method) {
        return;
    }

    let param_names: Vec<String> = method
        .params
        .iter()
        .map(|p| camel_to_kebab(&p.name))
        .collect();
    let fn_name = make_method_name(class_name, &method.selector);
    let ret_is_id = returns_object_type(method, mapper);
    let ret_is_void = returns_void(method, mapper);

    // Function signature
    let mut sig = format!("(define ({fn_name}");
    if !is_class_method {
        sig.push_str(" self");
    }
    for pn in &param_names {
        sig.push(' ');
        sig.push_str(pn);
    }
    sig.push(')');
    w.line(&sig);

    let retained = method_returns_retained(method);

    let strategy = dispatch_strategy(method, mapper);

    match strategy {
        DispatchStrategy::Tell => {
            let target = if is_class_method {
                class_name.to_string()
            } else {
                "(coerce-arg self)".to_string()
            };
            let tell_args = format_tell_args(&method.selector, &param_names, &method.params);
            if ret_is_id && !ret_is_void {
                w.line("  (wrap-objc-object");
                if retained {
                    write_line!(w, "   (tell {} {})", target, tell_args);
                    w.line("   #:retained #t))");
                } else {
                    write_line!(w, "   (tell {} {})))", target, tell_args);
                }
            } else {
                write_line!(w, "  (tell {} {}))", target, tell_args);
            }
        }
        DispatchStrategy::TypedMsgSend => {
            let param_types: Vec<String> = method
                .params
                .iter()
                .map(|p| mapper.map_type(&p.param_type, false))
                .collect();
            let ret_ffi_type = mapper.map_type(&method.return_type, true);
            let target_expr = if is_class_method {
                class_name.to_string()
            } else {
                "(coerce-arg self)".to_string()
            };

            let mut call_args: Vec<String> = param_names.clone();

            // Block wrapping
            emit_block_wrapping(w, &method.params, &mut call_args, mapper);

            // Coerce id-kind params
            coerce_id_params(&method.params, &mut call_args, mapper);

            let shared_name = sig_map.lookup(&param_types, &ret_ffi_type);
            match shared_name {
                Some(name) => {
                    if ret_is_id && !ret_is_void {
                        w.line("  (wrap-objc-object");
                        w.raw(&format!(
                            "   ({} {} (sel_registerName \"{}\")",
                            name, target_expr, method.selector
                        ));
                        for arg in &call_args {
                            w.raw(&format!(" {arg}"));
                        }
                        w.raw_line(")");
                        if retained {
                            w.line("   #:retained #t))");
                        } else {
                            w.raw_line("   ))");
                        }
                    } else {
                        w.raw(&format!(
                            "  ({} {} (sel_registerName \"{}\")",
                            name, target_expr, method.selector
                        ));
                        for arg in &call_args {
                            w.raw(&format!(" {arg}"));
                        }
                        w.raw_line("))");
                    }
                }
                None => {
                    w.line("  (let ([msg (get-ffi-obj \"objc_msgSend\" _objc-lib");
                    w.raw("              (_fun _pointer _pointer");
                    for pt in &param_types {
                        w.raw(&format!(" {pt}"));
                    }
                    w.raw(&format!(" -> {ret_ffi_type}))])\n"));
                    if ret_is_id && !ret_is_void {
                        w.line("    (wrap-objc-object");
                        w.raw(&format!(
                            "     (msg {} (sel_registerName \"{}\")",
                            target_expr, method.selector
                        ));
                        for arg in &call_args {
                            w.raw(&format!(" {arg}"));
                        }
                        w.raw_line(")");
                        if retained {
                            w.line("     #:retained #t))))");
                        } else {
                            w.raw_line("     ))))");
                        }
                    } else {
                        w.raw(&format!(
                            "    (msg {} (sel_registerName \"{}\")",
                            target_expr, method.selector
                        ));
                        for arg in &call_args {
                            w.raw(&format!(" {arg}"));
                        }
                        w.raw_line(")))");
                    }
                }
            }
        }
    }
}

// --- Helpers ---

/// Format tell arguments: "selector: (coerce-arg arg1) keyword: (coerce-arg arg2) ..."
fn format_tell_args(selector: &str, param_names: &[String], params: &[Param]) -> String {
    if param_names.is_empty() {
        return selector.to_string();
    }

    let keywords: Vec<&str> = selector.split(':').filter(|s| !s.is_empty()).collect();
    let mut parts = Vec::new();
    for (i, (kw, pn)) in keywords.iter().zip(param_names.iter()).enumerate() {
        let needs_coerce = i < params.len()
            && matches!(
                params[i].param_type.kind,
                TypeRefKind::Class { .. } | TypeRefKind::Id | TypeRefKind::Instancetype
            );
        if needs_coerce {
            parts.push(format!("{kw}: (coerce-arg {pn})"));
        } else {
            parts.push(format!("{kw}: {pn}"));
        }
    }
    parts.join(" ")
}

/// Emit block wrapping code for block-typed params.
fn emit_block_wrapping(
    w: &mut CodeWriter,
    params: &[Param],
    call_args: &mut Vec<String>,
    mapper: &dyn FfiTypeMapper,
) {
    for (i, p) in params.iter().enumerate() {
        if let TypeRefKind::Block {
            ref params,
            ref return_type,
        } = p.param_type.kind
        {
            let (bparam_strs, bret_str) = block_ffi_types(params, return_type, mapper);
            let blk_var = format!("_blk{i}");
            let blk_id_var = format!("_blk{i}-id");
            write_line!(w, "  (define-values ({} {})", blk_var, blk_id_var);
            write_line!(
                w,
                "    (make-objc-block {} (list {}) {}))",
                call_args[i],
                bparam_strs.join(" "),
                bret_str
            );
            call_args[i] = blk_var;
        }
    }
}

/// Wrap id-kind params (that aren't blocks) with coerce-arg.
fn coerce_id_params(params: &[Param], call_args: &mut Vec<String>, mapper: &dyn FfiTypeMapper) {
    for (i, p) in params.iter().enumerate() {
        if mapper.is_object_type(&p.param_type) && !mapper.is_block_type(&p.param_type) {
            call_args[i] = format!("(coerce-arg {})", call_args[i]);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use apianyware_macos_types::ir::Param;
    use apianyware_macos_types::type_ref::{TypeRef, TypeRefKind};

    #[test]
    fn test_format_tell_args_no_params() {
        assert_eq!(format_tell_args("length", &[], &[]), "length");
    }

    #[test]
    fn test_format_tell_args_single_id_param() {
        let params = vec![Param {
            name: "object".into(),
            param_type: TypeRef {
                nullable: false,
                kind: TypeRefKind::Id,
            },
        }];
        assert_eq!(
            format_tell_args("addObject:", &["object".into()], &params),
            "addObject: (coerce-arg object)"
        );
    }

    #[test]
    fn test_format_tell_args_non_id_param() {
        let params = vec![Param {
            name: "index".into(),
            param_type: TypeRef {
                nullable: false,
                kind: TypeRefKind::Primitive {
                    name: "uint64".into(),
                },
            },
        }];
        assert_eq!(
            format_tell_args("objectAtIndex:", &["index".into()], &params),
            "objectAtIndex: index"
        );
    }

    #[test]
    fn test_is_family_match() {
        assert!(is_family_match("init", "init"));
        assert!(is_family_match("initWithString:", "init"));
        assert!(is_family_match("init(arrayLiteral:)", "init"));
        assert!(!is_family_match("initialize", "init"));
        assert!(is_family_match("copy", "copy"));
        assert!(is_family_match("copyWithZone:", "copy"));
        assert!(is_family_match("new", "new"));
        assert!(is_family_match("newValue", "new"));
    }

    #[test]
    fn test_method_returns_retained() {
        let make_method = |selector: &str, class_method: bool, retained: Option<bool>| Method {
            selector: selector.to_string(),
            class_method,
            init_method: !class_method && selector.starts_with("init"),
            params: vec![],
            return_type: TypeRef {
                nullable: false,
                kind: TypeRefKind::Id,
            },
            deprecated: false,
            variadic: false,
            source: None,
            provenance: None,
            doc_refs: None,
            origin: None,
            category: None,
            overrides: None,
            returns_retained: retained,
            satisfies_protocol: None,
        };

        // IR value takes precedence
        assert!(method_returns_retained(&make_method(
            "foo",
            false,
            Some(true)
        )));
        assert!(!method_returns_retained(&make_method(
            "init",
            false,
            Some(false)
        )));

        // Heuristic fallback
        assert!(method_returns_retained(&make_method(
            "initWithString:",
            false,
            None
        )));
        assert!(method_returns_retained(&make_method("new", true, None)));
        assert!(method_returns_retained(&make_method("copy", false, None)));
        assert!(method_returns_retained(&make_method(
            "mutableCopy",
            false,
            None
        )));
        assert!(!method_returns_retained(&make_method(
            "description",
            false,
            None
        )));
    }

    #[test]
    fn test_generate_class_file_basic() {
        let cls = Class {
            name: "NSObject".to_string(),
            superclass: String::new(),
            protocols: vec![],
            properties: vec![],
            methods: vec![Method {
                selector: "description".to_string(),
                class_method: false,
                init_method: false,
                params: vec![],
                return_type: TypeRef {
                    nullable: false,
                    kind: TypeRefKind::Id,
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
            }],
            category_methods: vec![],
            ancestors: vec![],
            all_methods: vec![],
            all_properties: vec![],
        };
        let output = generate_class_file(&cls, "Foundation");
        assert!(output.contains("#lang racket/base"));
        assert!(output.contains("(import-class NSObject)"));
        assert!(output.contains("(define (nsobject-description self)"));
        assert!(output.contains("wrap-objc-object"));
    }
}
