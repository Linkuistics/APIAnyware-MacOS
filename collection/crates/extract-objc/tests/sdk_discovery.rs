//! Integration tests for SDK and framework discovery.

use apianyware_macos_extract_objc::sdk;

#[test]
fn discover_sdk_succeeds() {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    assert!(sdk.path.exists(), "SDK path should exist");
    assert!(!sdk.version.is_empty(), "SDK version should not be empty");
    // SDK version should look like a version number (e.g., "15.4")
    assert!(
        sdk.version.contains('.'),
        "SDK version should contain a dot: {}",
        sdk.version
    );
}

#[test]
fn discover_foundation_framework() {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    let frameworks = sdk::discover_frameworks(&sdk.path).expect("should discover frameworks");

    let foundation = frameworks
        .iter()
        .find(|f| f.name == "Foundation")
        .expect("Foundation framework should be discoverable");

    assert!(
        foundation.umbrella_header.exists(),
        "Foundation umbrella header should exist"
    );
    assert!(
        foundation
            .umbrella_header
            .to_string_lossy()
            .contains("Foundation.h"),
        "umbrella header should be Foundation.h"
    );
}

#[test]
fn discover_appkit_framework() {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    let frameworks = sdk::discover_frameworks(&sdk.path).expect("should discover frameworks");

    let appkit = frameworks
        .iter()
        .find(|f| f.name == "AppKit")
        .expect("AppKit framework should be discoverable");

    assert!(appkit.umbrella_header.exists());
}

#[test]
fn frameworks_are_sorted_by_name() {
    let sdk = sdk::discover_sdk().expect("should discover macOS SDK");
    let frameworks = sdk::discover_frameworks(&sdk.path).expect("should discover frameworks");

    assert!(frameworks.len() > 10, "should find many frameworks");

    let names: Vec<&str> = frameworks.iter().map(|f| f.name.as_str()).collect();
    let mut sorted = names.clone();
    sorted.sort();
    assert_eq!(names, sorted, "frameworks should be sorted by name");
}
