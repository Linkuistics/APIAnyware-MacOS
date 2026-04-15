//! Ascent Datalog program for resolution pass (pass 1).
//!
//! Defines base relations (loaded from collected IR) and derived relations
//! computed by fixed-point iteration:
//! - `ancestor` — transitive inheritance
//! - `effective_method` — flattened methods with override detection
//! - `effective_property` — flattened properties with override detection
//! - `returns_retained_method` — Cocoa ownership family detection
//! - `satisfies_protocol_method` — protocol conformance matching

// The `ascent!` macro expands rule bodies into code that clones Copy-typed
// relation fields and produces `()` tail expressions. Clippy cannot see past
// macro boundaries, so these lints fire on generated code we don't own.
#![allow(clippy::clone_on_copy, clippy::unused_unit)]

use ascent::ascent;

use apianyware_macos_datalog::ownership::is_returns_retained;

ascent! {
    pub struct ResolutionProgram;

    // === Base facts (loaded from IR) ===

    relation class_decl(String, String, String);
    relation inherits_from(String, String);
    relation conforms_to(String, String);
    relation method_decl(String, String, bool, bool, bool, bool);
    relation property_decl(String, String, bool, bool, bool);
    relation protocol_decl(String,);
    relation protocol_inherits(String, String);
    relation protocol_method(String, String, bool, bool);
    relation protocol_property(String, String, bool);
    relation enum_decl(String,);
    relation enum_value_decl(String, String, i64);
    relation struct_decl(String,);
    relation struct_field_decl(String, String, u32);
    relation function_decl(String,);
    relation constant_decl(String,);

    // === Derived: transitive ancestry ===

    relation ancestor(String, String);

    // Direct parent becomes ancestor
    ancestor(class.clone(), parent.clone()) <--
        inherits_from(class, parent);
    // Transitive: if class inherits from parent, and parent has ancestor,
    // then class has that ancestor
    ancestor(class.clone(), anc.clone()) <--
        inherits_from(class, parent),
        ancestor(parent, anc);

    // === Derived: effective methods (inheritance flattened) ===

    relation effective_method(String, String, bool, bool, bool, bool, String);

    // Own methods: origin is the declaring class
    effective_method(
        class.clone(), sel.clone(), *is_cm, *is_init, *is_dep, *is_var, class.clone()
    ) <--
        method_decl(class, sel, is_cm, is_init, is_dep, is_var);

    // Inherited methods: propagate from parent if not overridden in child.
    // Uses (class, selector, is_class_method) as the override key — instance and
    // class methods are in separate ObjC namespaces.
    effective_method(
        class.clone(), sel.clone(), *is_cm, *is_init, *is_dep, *is_var, origin.clone()
    ) <--
        inherits_from(class, parent),
        effective_method(parent, sel, is_cm, is_init, is_dep, is_var, origin),
        !method_decl(class, sel, is_cm, _, _, _);

    // === Derived: effective properties (inheritance flattened) ===

    relation effective_property(String, String, bool, bool, bool, String);

    // Own properties
    effective_property(
        class.clone(), name.clone(), *ro, *cp, *dep, class.clone()
    ) <--
        property_decl(class, name, ro, cp, dep);

    // Inherited properties
    effective_property(
        class.clone(), name.clone(), *ro, *cp, *dep, origin.clone()
    ) <--
        inherits_from(class, parent),
        effective_property(parent, name, ro, cp, dep, origin),
        !property_decl(class, name, _, _, _);

    // === Derived: returns retained (ownership detection) ===

    relation returns_retained_method(String, String, bool);

    returns_retained_method(class.clone(), sel.clone(), *is_cm) <--
        effective_method(class, sel, is_cm, _is_init, _is_dep, _is_var, _origin),
        if is_returns_retained(sel, *is_cm);

    // === Derived: protocol conformance ===

    relation satisfies_protocol_method(String, String, bool, String);

    satisfies_protocol_method(class.clone(), sel.clone(), *is_cm, proto.clone()) <--
        effective_method(class, sel, is_cm, _is_init, _is_dep, _is_var, _origin),
        conforms_to(class, proto),
        protocol_method(proto, sel, _is_req, is_cm);
}
