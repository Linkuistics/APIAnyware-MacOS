//! Integration test: extract CoreGraphics framework and verify C function pointer
//! typedef resolution.
//!
//! CoreGraphics contains `CGEventTapCallBack`, a function pointer typedef used
//! as a parameter in `CGEventTapCreate`. This test verifies the extractor
//! produces `FunctionPointer` TypeRefKind instead of a plain `Pointer` or `Alias`.

use std::sync::LazyLock;

use apianyware_macos_extract_objc::{create_index, extract_framework, init_clang, sdk};
use apianyware_macos_types::type_ref::TypeRefKind;

/// Shared extracted CoreGraphics framework.
static COREGRAPHICS: LazyLock<apianyware_macos_types::ir::Framework> = LazyLock::new(|| {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    let frameworks = sdk::discover_frameworks(&sdk.path).expect("should discover frameworks");
    let cg = frameworks
        .iter()
        .find(|f| f.name == "CoreGraphics")
        .expect("CoreGraphics not found");

    let clang = init_clang().expect("should initialize clang");
    let index = create_index(&clang);
    extract_framework(&index, cg, &sdk).expect("should extract CoreGraphics")
});

fn coregraphics() -> &'static apianyware_macos_types::ir::Framework {
    &COREGRAPHICS
}

#[test]
fn coregraphics_has_functions() {
    let fw = coregraphics();
    assert!(
        fw.functions.len() > 100,
        "expected >100 functions, got {}",
        fw.functions.len()
    );
}

#[test]
fn coregraphics_cgeventtapcreate_callback_param_is_function_pointer() {
    let fw = coregraphics();
    let func = fw
        .functions
        .iter()
        .find(|f| f.name == "CGEventTapCreate")
        .expect("CGEventTapCreate not found");

    // The 5th parameter (index 4) is `callback` of type CGEventTapCallBack
    let callback_param = func
        .params
        .iter()
        .find(|p| p.name == "callback")
        .expect("callback param not found in CGEventTapCreate");

    match &callback_param.param_type.kind {
        TypeRefKind::FunctionPointer {
            name,
            params,
            return_type,
        } => {
            assert_eq!(
                name.as_deref(),
                Some("CGEventTapCallBack"),
                "should preserve typedef name"
            );
            // CGEventTapCallBack has 4 params: proxy, type, event, userInfo
            assert_eq!(
                params.len(),
                4,
                "CGEventTapCallBack should have 4 parameters"
            );
            // Return type should be CGEventRef (an alias)
            assert!(
                !matches!(return_type.kind, TypeRefKind::Primitive { ref name } if name == "void"),
                "CGEventTapCallBack should not return void"
            );
        }
        other => {
            panic!(
                "expected FunctionPointer for CGEventTapCallBack, got {other:?}. \
                 The map_typedef function should resolve function pointer typedefs \
                 to FunctionPointer TypeRefKind."
            );
        }
    }
}

#[test]
fn coregraphics_has_no_spurious_function_pointer_loss() {
    // Verify that function pointer typedefs don't silently become Pointer or Alias
    let fw = coregraphics();

    // Collect all parameter types named *CallBack or *Callback across all functions
    let callback_params: Vec<_> = fw
        .functions
        .iter()
        .flat_map(|f| f.params.iter().map(move |p| (f.name.as_str(), p)))
        .filter(|(_, p)| {
            matches!(&p.param_type.kind,
                TypeRefKind::Alias { name, .. } if name.contains("allBack") || name.contains("allback")
            )
        })
        .collect();

    // After implementing FunctionPointer resolution, there should be zero
    // callback typedefs remaining as plain Alias
    assert!(
        callback_params.is_empty(),
        "found {} callback params still mapped as Alias instead of FunctionPointer: {:?}",
        callback_params.len(),
        callback_params
            .iter()
            .map(|(func, p)| format!("{}.{}: {:?}", func, p.name, p.param_type.kind))
            .collect::<Vec<_>>()
    );
}
