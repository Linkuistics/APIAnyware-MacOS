//! Integration test: extract ApplicationServices umbrella framework and
//! verify that declarations from real (non-symlinked) subframeworks like
//! HIServices are included. Symlinked subframeworks (CoreGraphics,
//! CoreText, etc.) must NOT appear here — libclang canonicalises their
//! paths to the top-level framework, and they get extracted there.

use std::sync::LazyLock;

use apianyware_macos_extract_objc::{create_index, extract_framework, init_clang, sdk};

static APPLICATION_SERVICES: LazyLock<apianyware_macos_types::ir::Framework> = LazyLock::new(|| {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    let frameworks = sdk::discover_frameworks(&sdk.path).expect("should discover frameworks");
    let fw = frameworks
        .iter()
        .find(|f| f.name == "ApplicationServices")
        .expect("ApplicationServices not found");

    let clang = init_clang().expect("should initialize clang");
    let index = create_index(&clang);
    extract_framework(&index, fw, &sdk).expect("should extract ApplicationServices")
});

fn application_services() -> &'static apianyware_macos_types::ir::Framework {
    &APPLICATION_SERVICES
}

#[test]
fn application_services_includes_hiservices_ax_functions() {
    let fw = application_services();
    let required = [
        "AXIsProcessTrusted",
        "AXIsProcessTrustedWithOptions",
        "AXUIElementCreateApplication",
        "AXUIElementCopyAttributeValue",
        "AXUIElementSetAttributeValue",
        "AXUIElementCopyAttributeNames",
        "AXUIElementGetPid",
        "AXValueCreate",
        "AXValueGetValue",
    ];
    let names: std::collections::HashSet<&str> =
        fw.functions.iter().map(|f| f.name.as_str()).collect();
    for req in required {
        assert!(
            names.contains(req),
            "required AX function {req} missing from ApplicationServices"
        );
    }
}

#[test]
fn application_services_excludes_symlinked_subframeworks() {
    // CoreGraphics, CoreText, ColorSync, ImageIO are symlinks inside
    // ApplicationServices.framework/Versions/A/Frameworks/ pointing to
    // the top-level frameworks. libclang should canonicalise their
    // paths so these symbols do not land here.
    let fw = application_services();
    let cg_funcs = fw
        .functions
        .iter()
        .filter(|f| f.name.starts_with("CGContext") || f.name.starts_with("CGEvent"))
        .count();
    assert_eq!(
        cg_funcs, 0,
        "CoreGraphics functions should not leak into ApplicationServices \
         via the symlinked subframework"
    );
    let ct_funcs = fw
        .functions
        .iter()
        .filter(|f| f.name.starts_with("CTFont") || f.name.starts_with("CTLine"))
        .count();
    assert_eq!(
        ct_funcs, 0,
        "CoreText functions should not leak into ApplicationServices"
    );
}
