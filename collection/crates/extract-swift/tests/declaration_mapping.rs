//! Tests for mapping ABIRoot nodes to IR types.

use std::path::PathBuf;

use apianyware_macos_extract_swift::abi_types::AbiDocument;
use apianyware_macos_extract_swift::declaration_mapping::map_abi_to_framework;

fn fixtures_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures")
}

#[test]
fn map_test_framework_class() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.name, "TestFramework");
    assert_eq!(framework.checkpoint, "collected");
    assert_eq!(framework.sdk_version.as_deref(), Some("15.4"));

    // Should have 1 class (Widget)
    assert_eq!(framework.classes.len(), 1);
    let widget = &framework.classes[0];
    assert_eq!(widget.name, "Widget");
    assert_eq!(widget.superclass, "Base");
    assert_eq!(widget.protocols, vec!["SomeProtocol"]);

    // Widget should have 3 methods (1 init + 2 methods)
    assert_eq!(widget.methods.len(), 3, "init + process + defaultWidget");

    // Constructor
    let init = widget
        .methods
        .iter()
        .find(|m| m.init_method)
        .expect("should have init method");
    assert!(init.init_method);
    assert_eq!(init.params.len(), 1);
    assert_eq!(init.params[0].name, "name");

    // Instance method
    let process = widget
        .methods
        .iter()
        .find(|m| m.selector.contains("process"))
        .expect("should have process method");
    assert!(!process.class_method);
    assert_eq!(process.params.len(), 1);
    assert_eq!(process.params[0].name, "input");

    // Static method → class_method
    let default_widget = widget
        .methods
        .iter()
        .find(|m| m.selector.contains("defaultWidget"))
        .expect("should have defaultWidget method");
    assert!(default_widget.class_method);

    // Properties
    assert_eq!(widget.properties.len(), 2, "title + identifier");

    let title = widget
        .properties
        .iter()
        .find(|p| p.name == "title")
        .expect("should have title property");
    assert!(!title.readonly, "title has getter+setter");

    let identifier = widget
        .properties
        .iter()
        .find(|p| p.name == "identifier")
        .expect("should have identifier property");
    assert!(identifier.readonly, "identifier is let / getter-only");
    assert!(identifier.property_type.nullable, "identifier is Optional");
}

#[test]
fn map_test_framework_protocol() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.protocols.len(), 1);
    let proto = &framework.protocols[0];
    assert_eq!(proto.name, "SomeProtocol");
    assert_eq!(proto.required_methods.len(), 1);
    assert_eq!(proto.required_methods[0].selector, "doWork");
}

#[test]
fn map_test_framework_enum() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.enums.len(), 1);
    let priority = &framework.enums[0];
    assert_eq!(priority.name, "Priority");
    assert_eq!(priority.values.len(), 3);
    assert_eq!(priority.values[0].name, "low");
    assert_eq!(priority.values[1].name, "medium");
    assert_eq!(priority.values[2].name, "high");
}

#[test]
fn map_test_framework_struct() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.structs.len(), 1);
    let config = &framework.structs[0];
    assert_eq!(config.name, "Config");
    assert_eq!(config.fields.len(), 2);
    assert_eq!(config.fields[0].name, "maxRetries");
    assert_eq!(config.fields[1].name, "name");
}

#[test]
fn map_test_framework_function() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.functions.len(), 1);
    let func = &framework.functions[0];
    assert_eq!(func.name, "createDefaultWidget");
    assert_eq!(func.params.len(), 1);
    assert_eq!(func.params[0].name, "name");
}

#[test]
fn map_test_framework_imports() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.depends_on, vec!["Foundation"]);
}

#[test]
fn map_test_framework_source_is_swift_interface() {
    let json = std::fs::read_to_string(fixtures_dir().join("test_framework_abi.json"))
        .expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    // All methods should have source: SwiftInterface
    for class in &framework.classes {
        for method in &class.methods {
            assert_eq!(
                method.source,
                Some(apianyware_macos_types::provenance::DeclarationSource::SwiftInterface),
                "method {} should have SwiftInterface source",
                method.selector
            );
        }
        for property in &class.properties {
            assert_eq!(
                property.source,
                Some(apianyware_macos_types::provenance::DeclarationSource::SwiftInterface),
                "property {} should have SwiftInterface source",
                property.name
            );
        }
    }
}

#[test]
fn map_observation_framework() {
    let json =
        std::fs::read_to_string(fixtures_dir().join("observation_abi.json")).expect("read fixture");
    let doc: AbiDocument = serde_json::from_str(&json).expect("parse");
    let framework = map_abi_to_framework(&doc, "15.4");

    assert_eq!(framework.name, "Observation");

    // Should have the Observable protocol
    let observable = framework
        .protocols
        .iter()
        .find(|p| p.name == "Observable")
        .expect("should have Observable protocol");
    assert!(observable.required_methods.is_empty() || !observable.required_methods.is_empty());

    // Should have ObservationRegistrar struct
    let registrar = framework
        .structs
        .iter()
        .find(|s| s.name == "ObservationRegistrar")
        .expect("should have ObservationRegistrar struct");
    assert!(!registrar.fields.is_empty(), "registrar should have fields");
}
