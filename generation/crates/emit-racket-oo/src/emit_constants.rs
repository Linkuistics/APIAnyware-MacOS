//! Racket constants file code generation.
//!
//! Emits `get-ffi-obj` definitions for framework-level global constants
//! (e.g., NSString notification names, numeric defaults).
//!
//! Generated bindings include `provide/contract` forms that enforce value
//! types at module boundaries using Racket contracts mapped from IR TypeRef.

use apianyware_macos_emit::code_writer::CodeWriter;
use apianyware_macos_emit::ffi_type_mapping::{FfiTypeMapper, RacketFfiTypeMapper};
use apianyware_macos_emit::write_line;
use apianyware_macos_types::ir::Constant;

use crate::emit_functions::map_contract;
use crate::shared_signatures::any_struct_type;

/// Generate a Racket constants file for a framework.
pub fn generate_constants_file(constants: &[Constant], framework: &str) -> String {
    let mapper = RacketFfiTypeMapper;
    let needs_structs = any_struct_type(constants.iter().map(|c| &c.constant_type), &mapper);
    let mut w = CodeWriter::new();
    w.line("#lang racket/base");
    write_line!(w, ";; Generated constant definitions for {}", framework);
    w.blank_line();
    w.line("(require ffi/unsafe");
    w.line("         ffi/unsafe/objc");
    // Rename `racket/contract`'s `->` to `c->` to avoid colliding with
    // `ffi/unsafe`'s `->`. Constants don't use `->` themselves, but the
    // collision is at require-time regardless.
    if needs_structs {
        w.line("         (rename-in racket/contract [-> c->])");
        w.line("         \"../../../runtime/type-mapping.rkt\")");
    } else {
        w.line("         (rename-in racket/contract [-> c->]))");
    }
    w.blank_line();

    // Contract-based provide
    if constants.is_empty() {
        w.line("(provide)");
    } else {
        w.line("(provide/contract");
        for constant in constants {
            let contract = map_contract(&constant.constant_type, false);
            write_line!(w, "  [{} {}]", constant.name, contract);
        }
        w.line("  )");
    }
    w.blank_line();

    // Load framework dylib
    write_line!(
        w,
        "(define _fw-lib (ffi-lib \"/System/Library/Frameworks/{0}.framework/{0}\"))",
        framework
    );
    w.blank_line();

    for constant in constants {
        let ffi_type = mapper.map_type(&constant.constant_type, false);
        write_line!(
            w,
            "(define {} (get-ffi-obj '{} _fw-lib {}))",
            constant.name,
            constant.name,
            ffi_type
        );
    }

    w.finish()
}

#[cfg(test)]
mod tests {
    use super::*;
    use apianyware_macos_types::type_ref::{TypeRef, TypeRefKind};

    fn make_constant(name: &str, kind: TypeRefKind) -> Constant {
        Constant {
            name: name.to_string(),
            constant_type: TypeRef {
                nullable: false,
                kind,
            },
            source: None,
            provenance: None,
            doc_refs: None,
        }
    }

    fn make_nullable_constant(name: &str, kind: TypeRefKind) -> Constant {
        Constant {
            name: name.to_string(),
            constant_type: TypeRef {
                nullable: true,
                kind,
            },
            source: None,
            provenance: None,
            doc_refs: None,
        }
    }

    #[test]
    fn test_nsstring_constant() {
        let constants = vec![make_constant(
            "TKVersionString",
            TypeRefKind::Class {
                name: "NSString".into(),
                framework: None,
                params: vec![],
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(
            output.contains("(define TKVersionString (get-ffi-obj 'TKVersionString _fw-lib _id))")
        );
    }

    #[test]
    fn test_nsstring_constant_contract() {
        let constants = vec![make_constant(
            "TKVersionString",
            TypeRefKind::Class {
                name: "NSString".into(),
                framework: None,
                params: vec![],
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output.contains("(provide/contract"));
        assert!(output.contains("[TKVersionString cpointer?]"));
    }

    #[test]
    fn test_double_constant() {
        let constants = vec![make_constant(
            "TKDefaultTimeout",
            TypeRefKind::Primitive {
                name: "double".into(),
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output
            .contains("(define TKDefaultTimeout (get-ffi-obj 'TKDefaultTimeout _fw-lib _double))"));
    }

    #[test]
    fn test_double_constant_contract() {
        let constants = vec![make_constant(
            "TKDefaultTimeout",
            TypeRefKind::Primitive {
                name: "double".into(),
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output.contains("[TKDefaultTimeout real?]"));
    }

    #[test]
    fn test_alias_constant() {
        let constants = vec![make_constant(
            "TKDefaultOptions",
            TypeRefKind::Alias {
                name: "NSPointerFunctionsOptions".into(),
                framework: None,
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output
            .contains("(define TKDefaultOptions (get-ffi-obj 'TKDefaultOptions _fw-lib _uint64))"));
    }

    #[test]
    fn test_alias_constant_contract() {
        let constants = vec![make_constant(
            "TKDefaultOptions",
            TypeRefKind::Alias {
                name: "NSPointerFunctionsOptions".into(),
                framework: None,
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output.contains("[TKDefaultOptions exact-nonnegative-integer?]"));
    }

    #[test]
    fn test_nullable_object_constant_contract() {
        let constants = vec![make_nullable_constant(
            "TKOptionalRef",
            TypeRefKind::Class {
                name: "NSString".into(),
                framework: None,
                params: vec![],
            },
        )];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output.contains("[TKOptionalRef (or/c cpointer? #f)]"));
    }

    #[test]
    fn test_framework_lib_loading() {
        let output = generate_constants_file(&[], "Foundation");
        assert!(output.contains(
            "(define _fw-lib (ffi-lib \"/System/Library/Frameworks/Foundation.framework/Foundation\"))"
        ));
    }

    #[test]
    fn test_empty_constants_provide() {
        let output = generate_constants_file(&[], "TestKit");
        assert!(output.contains("(provide)"));
        assert!(!output.contains("provide/contract"));
    }

    #[test]
    fn test_requires_racket_contract() {
        let output = generate_constants_file(&[], "TestKit");
        assert!(output.contains("(rename-in racket/contract [-> c->])"));
    }

    #[test]
    fn test_multiple_constants_ordered() {
        let constants = vec![
            make_constant(
                "TKVersionString",
                TypeRefKind::Class {
                    name: "NSString".into(),
                    framework: None,
                    params: vec![],
                },
            ),
            make_constant(
                "TKDefaultTimeout",
                TypeRefKind::Primitive {
                    name: "double".into(),
                },
            ),
        ];
        let output = generate_constants_file(&constants, "TestKit");
        let ver_pos = output.find("TKVersionString").unwrap();
        let timeout_pos = output.find("TKDefaultTimeout").unwrap();
        assert!(ver_pos < timeout_pos, "Constants should preserve IR order");
    }

    #[test]
    fn test_multiple_constants_contracts() {
        let constants = vec![
            make_constant(
                "TKVersionString",
                TypeRefKind::Class {
                    name: "NSString".into(),
                    framework: None,
                    params: vec![],
                },
            ),
            make_constant(
                "TKDefaultTimeout",
                TypeRefKind::Primitive {
                    name: "double".into(),
                },
            ),
        ];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(output.contains("(provide/contract"));
        assert!(output.contains("[TKVersionString cpointer?]"));
        assert!(output.contains("[TKDefaultTimeout real?]"));
    }

    #[test]
    fn test_constants_with_struct_type_require_type_mapping() {
        // Foundation ships NSZeroPoint / NSZeroRect as module-level constants
        // of geometry struct type. The generated constants.rkt must require
        // type-mapping.rkt so `_NSPoint` etc. are in scope for `get-ffi-obj`.
        let constants = vec![make_constant(
            "NSZeroPoint",
            TypeRefKind::Alias {
                name: "NSPoint".into(),
                framework: None,
            },
        )];
        let output = generate_constants_file(&constants, "Foundation");
        assert!(
            output.contains("\"../../../runtime/type-mapping.rkt\""),
            "Expected type-mapping.rkt require for struct-typed constant. \
             Output was:\n{output}"
        );
    }

    #[test]
    fn test_constants_without_structs_omit_type_mapping() {
        // Primitive-only and object-only constant lists must not pull in
        // type-mapping.rkt.
        let constants = vec![
            make_constant(
                "TKDefaultTimeout",
                TypeRefKind::Primitive {
                    name: "double".into(),
                },
            ),
            make_constant(
                "TKVersionString",
                TypeRefKind::Class {
                    name: "NSString".into(),
                    framework: None,
                    params: vec![],
                },
            ),
        ];
        let output = generate_constants_file(&constants, "TestKit");
        assert!(
            !output.contains("type-mapping.rkt"),
            "Expected no type-mapping.rkt require when no struct types \
             are used. Output was:\n{output}"
        );
    }
}
