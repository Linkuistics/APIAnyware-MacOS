//! AST traversal to extract ObjC/C declarations from a parsed translation unit.
//!
//! Walks the libclang AST and populates IR types for classes, protocols,
//! enums, structs, functions, and constants. Also captures provenance
//! (source location, availability) and documentation references.

use std::collections::{HashMap, HashSet};
use std::path::Path;

use clang::{Entity, EntityKind, EntityVisitResult};

use apianyware_macos_types::ir;
use apianyware_macos_types::provenance::{
    Availability, DeclarationSource, DocRefs, SourceProvenance,
};

use crate::type_mapping::map_type;

/// State accumulated during AST traversal for a single framework.
#[derive(Debug, Default)]
pub struct ExtractionResult {
    pub classes: Vec<ir::Class>,
    pub protocols: Vec<ir::Protocol>,
    pub enums: Vec<ir::Enum>,
    pub structs: Vec<ir::Struct>,
    pub functions: Vec<ir::Function>,
    pub constants: Vec<ir::Constant>,
    pub skipped_symbols: Vec<ir::SkippedSymbol>,
}

/// Extract all declarations from a translation unit's AST.
///
/// Only includes declarations from the specified framework (filters by
/// header path). Captures provenance and documentation for each declaration.
pub fn extract_from_translation_unit(
    translation_unit_entity: &Entity<'_>,
    framework_name: &str,
    sdk_path: &Path,
) -> ExtractionResult {
    let mut result = ExtractionResult::default();
    let mut seen_classes: HashSet<String> = HashSet::new();
    let mut seen_protocols: HashSet<String> = HashSet::new();
    let mut seen_enums: HashSet<String> = HashSet::new();
    let mut seen_structs: HashSet<String> = HashSet::new();
    let mut seen_functions: HashSet<String> = HashSet::new();
    let mut seen_constants: HashSet<String> = HashSet::new();
    // Collect category methods and properties to merge into classes later
    let mut category_methods: HashMap<String, Vec<ir::CategoryGroup>> = HashMap::new();
    let mut category_properties: HashMap<String, Vec<ir::Property>> = HashMap::new();

    translation_unit_entity.visit_children(|entity, _parent| {
        // Filter to only declarations from this framework
        if !is_from_framework(&entity, framework_name, sdk_path) {
            return EntityVisitResult::Continue;
        }

        match entity.get_kind() {
            EntityKind::ObjCInterfaceDecl => {
                if let Some(name) = entity.get_name() {
                    if seen_classes.insert(name.clone()) {
                        match extract_class(&entity, sdk_path) {
                            Some(class) => result.classes.push(class),
                            None => {
                                result.skipped_symbols.push(ir::SkippedSymbol {
                                    name,
                                    kind: "class".to_string(),
                                    reason: "extraction failed".to_string(),
                                });
                            }
                        }
                    }
                }
            }
            EntityKind::ObjCProtocolDecl => {
                if let Some(name) = entity.get_name() {
                    if seen_protocols.insert(name.clone()) {
                        if let Some(protocol) = extract_protocol(&entity, sdk_path) {
                            result.protocols.push(protocol);
                        }
                    }
                }
            }
            EntityKind::ObjCCategoryDecl => {
                extract_category(
                    &entity,
                    sdk_path,
                    framework_name,
                    &mut category_methods,
                    &mut category_properties,
                );
            }
            EntityKind::EnumDecl => {
                if let Some(name) = entity.get_name() {
                    if !name.is_empty() && seen_enums.insert(name.clone()) {
                        if let Some(en) = extract_enum(&entity, sdk_path) {
                            result.enums.push(en);
                        }
                    }
                }
            }
            EntityKind::StructDecl => {
                if let Some(name) = entity.get_name() {
                    if !name.is_empty() && seen_structs.insert(name.clone()) {
                        if let Some(st) = extract_struct(&entity, sdk_path) {
                            result.structs.push(st);
                        }
                    }
                }
            }
            EntityKind::FunctionDecl => {
                if let Some(name) = entity.get_name() {
                    if seen_functions.insert(name.clone()) {
                        if let Some(func) = extract_function(&entity, sdk_path) {
                            result.functions.push(func);
                        }
                    }
                }
            }
            EntityKind::VarDecl => {
                if let Some(name) = entity.get_name() {
                    if seen_constants.insert(name.clone()) {
                        if let Some(constant) = extract_constant(&entity, sdk_path) {
                            result.constants.push(constant);
                        }
                    }
                }
            }
            _ => {}
        }

        EntityVisitResult::Continue
    });

    // Merge category methods and properties into their classes
    for class in &mut result.classes {
        if let Some(categories) = category_methods.remove(&class.name) {
            class.category_methods = categories;
        }
        if let Some(props) = category_properties.remove(&class.name) {
            let existing_names: HashSet<String> =
                class.properties.iter().map(|p| p.name.clone()).collect();
            class.properties.extend(
                props
                    .into_iter()
                    .filter(|p| !existing_names.contains(&p.name)),
            );
        }
    }

    // Sort all declarations by name for deterministic output
    result.classes.sort_by(|a, b| a.name.cmp(&b.name));
    result.protocols.sort_by(|a, b| a.name.cmp(&b.name));
    result.enums.sort_by(|a, b| a.name.cmp(&b.name));
    result.structs.sort_by(|a, b| a.name.cmp(&b.name));
    result.functions.sort_by(|a, b| a.name.cmp(&b.name));
    result.constants.sort_by(|a, b| a.name.cmp(&b.name));

    result
}

// ---------------------------------------------------------------------------
// Class extraction
// ---------------------------------------------------------------------------

fn extract_class(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Class> {
    let name = entity.get_name()?;

    let superclass = entity
        .get_children()
        .iter()
        .find(|c| c.get_kind() == EntityKind::ObjCSuperClassRef)
        .and_then(|c| c.get_name())
        .unwrap_or_default();

    let protocols: Vec<String> = entity
        .get_children()
        .iter()
        .filter(|c| c.get_kind() == EntityKind::ObjCProtocolRef)
        .filter_map(|c| c.get_name())
        .collect();

    let mut methods = Vec::new();
    let mut properties = Vec::new();

    entity.visit_children(|child, _parent| {
        match child.get_kind() {
            EntityKind::ObjCInstanceMethodDecl | EntityKind::ObjCClassMethodDecl => {
                if let Some(method) = extract_method(&child, sdk_path) {
                    methods.push(method);
                }
            }
            EntityKind::ObjCPropertyDecl => {
                if let Some(prop) = extract_property(&child, sdk_path) {
                    properties.push(prop);
                }
            }
            _ => {}
        }
        EntityVisitResult::Continue
    });

    Some(ir::Class {
        name,
        superclass,
        protocols,
        properties,
        methods,
        category_methods: Vec::new(),
        ancestors: Vec::new(),
        all_methods: Vec::new(),
        all_properties: Vec::new(),
    })
}

// ---------------------------------------------------------------------------
// Method extraction
// ---------------------------------------------------------------------------

fn extract_method(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Method> {
    let selector = entity.get_name()?;
    let class_method = entity.get_kind() == EntityKind::ObjCClassMethodDecl;

    let init_method = !class_method && (selector == "init" || selector.starts_with("initWith"));

    let result_type = entity.get_result_type()?;
    let return_type = map_type(&result_type);

    let params = extract_params(entity);

    let deprecated = matches!(entity.get_availability(), clang::Availability::Deprecated);

    let variadic = entity.is_variadic();

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Method {
        selector,
        class_method,
        init_method,
        params,
        return_type,
        deprecated,
        variadic,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
        origin: None,
        category: None,
        overrides: None,
        returns_retained: None,
        satisfies_protocol: None,
    })
}

fn extract_params(entity: &Entity<'_>) -> Vec<ir::Param> {
    entity
        .get_children()
        .iter()
        .filter(|c| c.get_kind() == EntityKind::ParmDecl)
        .filter_map(|c| {
            let name = c.get_name().unwrap_or_default();
            let param_type_clang = c.get_type()?;
            let param_type = map_type(&param_type_clang);
            Some(ir::Param { name, param_type })
        })
        .collect()
}

// ---------------------------------------------------------------------------
// Property extraction
// ---------------------------------------------------------------------------

fn extract_property(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Property> {
    let name = entity.get_name()?;
    let property_type_clang = entity.get_type()?;
    let property_type = map_type(&property_type_clang);

    let objc_attrs = entity.get_objc_attributes();
    let readonly = objc_attrs.map_or(false, |a| a.readonly);
    let class_property = objc_attrs.map_or(false, |a| a.class);

    let deprecated = matches!(entity.get_availability(), clang::Availability::Deprecated);

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Property {
        name,
        property_type,
        readonly,
        class_property,
        deprecated,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
        origin: None,
    })
}

// ---------------------------------------------------------------------------
// Protocol extraction
// ---------------------------------------------------------------------------

fn extract_protocol(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Protocol> {
    let name = entity.get_name()?;

    let inherits: Vec<String> = entity
        .get_children()
        .iter()
        .filter(|c| c.get_kind() == EntityKind::ObjCProtocolRef)
        .filter_map(|c| c.get_name())
        .collect();

    let mut required_methods = Vec::new();
    let mut optional_methods = Vec::new();
    let mut properties = Vec::new();

    entity.visit_children(|child, _parent| {
        match child.get_kind() {
            EntityKind::ObjCInstanceMethodDecl | EntityKind::ObjCClassMethodDecl => {
                if let Some(method) = extract_method(&child, sdk_path) {
                    if child.is_objc_optional() {
                        optional_methods.push(method);
                    } else {
                        required_methods.push(method);
                    }
                }
            }
            EntityKind::ObjCPropertyDecl => {
                if let Some(prop) = extract_property(&child, sdk_path) {
                    properties.push(prop);
                }
            }
            _ => {}
        }
        EntityVisitResult::Continue
    });

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Protocol {
        name,
        inherits,
        required_methods,
        optional_methods,
        properties,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
    })
}

// ---------------------------------------------------------------------------
// Category extraction
// ---------------------------------------------------------------------------

fn extract_category(
    entity: &Entity<'_>,
    sdk_path: &Path,
    framework_name: &str,
    category_methods: &mut HashMap<String, Vec<ir::CategoryGroup>>,
    category_properties: &mut HashMap<String, Vec<ir::Property>>,
) {
    // Get the class this category extends
    let class_name = entity
        .get_children()
        .iter()
        .find(|c| c.get_kind() == EntityKind::ObjCClassRef)
        .and_then(|c| c.get_name());

    let class_name = match class_name {
        Some(name) => name,
        None => return,
    };

    let category_name = entity.get_name().unwrap_or_default();

    let mut methods = Vec::new();
    let mut properties = Vec::new();
    entity.visit_children(|child, _parent| {
        match child.get_kind() {
            EntityKind::ObjCInstanceMethodDecl | EntityKind::ObjCClassMethodDecl => {
                if let Some(method) = extract_method(&child, sdk_path) {
                    methods.push(method);
                }
            }
            EntityKind::ObjCPropertyDecl => {
                if let Some(prop) = extract_property(&child, sdk_path) {
                    properties.push(prop);
                }
            }
            _ => {}
        }
        EntityVisitResult::Continue
    });

    if !methods.is_empty() {
        let group = ir::CategoryGroup {
            category: category_name,
            origin_framework: framework_name.to_string(),
            methods,
        };
        category_methods
            .entry(class_name.clone())
            .or_default()
            .push(group);
    }

    if !properties.is_empty() {
        category_properties
            .entry(class_name)
            .or_default()
            .extend(properties);
    }
}

// ---------------------------------------------------------------------------
// Enum extraction
// ---------------------------------------------------------------------------

fn extract_enum(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Enum> {
    let name = entity.get_name()?;

    let enum_clang_type = entity.get_enum_underlying_type()?;
    let enum_type = map_type(&enum_clang_type);

    let mut values = Vec::new();
    entity.visit_children(|child, _parent| {
        if child.get_kind() == EntityKind::EnumConstantDecl {
            if let Some(val_name) = child.get_name() {
                if let Some((value, _)) = child.get_enum_constant_value() {
                    values.push(ir::EnumValue {
                        name: val_name,
                        value,
                    });
                }
            }
        }
        EntityVisitResult::Continue
    });

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Enum {
        name,
        enum_type,
        values,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
    })
}

// ---------------------------------------------------------------------------
// Struct extraction
// ---------------------------------------------------------------------------

fn extract_struct(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Struct> {
    let name = entity.get_name()?;

    let mut fields = Vec::new();
    entity.visit_children(|child, _parent| {
        if child.get_kind() == EntityKind::FieldDecl {
            if let Some(field_name) = child.get_name() {
                if let Some(field_clang_type) = child.get_type() {
                    fields.push(ir::StructField {
                        name: field_name,
                        field_type: map_type(&field_clang_type),
                    });
                }
            }
        }
        EntityVisitResult::Continue
    });

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Struct {
        name,
        fields,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
    })
}

// ---------------------------------------------------------------------------
// Function extraction
// ---------------------------------------------------------------------------

fn extract_function(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Function> {
    let name = entity.get_name()?;

    // Skip compiler intrinsics and internal functions
    if name.starts_with("__") || name.starts_with("_Block_") {
        return None;
    }

    let result_type = entity.get_result_type()?;
    let return_type = map_type(&result_type);

    let params = extract_params(entity);
    let variadic = entity.is_variadic();

    // Check if the function is declared as inline
    let inline = entity.is_inline_function();

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Function {
        name,
        params,
        return_type,
        inline,
        variadic,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
    })
}

// ---------------------------------------------------------------------------
// Constant extraction
// ---------------------------------------------------------------------------

fn extract_constant(entity: &Entity<'_>, sdk_path: &Path) -> Option<ir::Constant> {
    let name = entity.get_name()?;

    // Skip internal/private constants
    if name.starts_with("__") {
        return None;
    }

    let constant_clang_type = entity.get_type()?;
    let constant_type = map_type(&constant_clang_type);

    let provenance = extract_provenance(entity, sdk_path);
    let doc_refs = extract_doc_refs(entity);

    Some(ir::Constant {
        name,
        constant_type,
        source: Some(DeclarationSource::ObjcHeader),
        provenance: Some(provenance),
        doc_refs: Some(doc_refs),
    })
}

// ---------------------------------------------------------------------------
// Provenance and documentation
// ---------------------------------------------------------------------------

/// Extract source provenance from a libclang cursor.
fn extract_provenance(entity: &Entity<'_>, sdk_path: &Path) -> SourceProvenance {
    let location = entity.get_location();
    let (header, line) = match location {
        Some(loc) => {
            let file_loc = loc.get_file_location();
            let header = file_loc.file.map(|f| {
                let path = f.get_path();
                // Make header path relative to SDK
                path.strip_prefix(sdk_path)
                    .unwrap_or(&path)
                    .to_string_lossy()
                    .to_string()
            });
            let line = Some(file_loc.line);
            (header, line)
        }
        None => (None, None),
    };

    let availability = extract_availability(entity);

    SourceProvenance {
        header,
        line,
        availability,
    }
}

/// Extract availability attributes from a declaration.
fn extract_availability(entity: &Entity<'_>) -> Option<Availability> {
    let platforms = entity.get_platform_availability()?;

    // Look for macOS platform availability
    for platform in &platforms {
        if platform.platform == "macos" || platform.platform == "macosx" {
            let format_version = |v: clang::Version| match v.y {
                Some(y) => format!("{}.{}", v.x, y),
                None => format!("{}", v.x),
            };
            return Some(Availability {
                introduced: platform.introduced.map(&format_version),
                deprecated: platform.deprecated.map(&format_version),
            });
        }
    }

    None
}

/// Extract documentation references from a declaration.
fn extract_doc_refs(entity: &Entity<'_>) -> DocRefs {
    let header_comment = entity.get_comment_brief();
    let usr = entity.get_usr().map(|u| u.0);
    let apple_doc_url = usr.as_ref().and_then(|u| construct_apple_doc_url(u));

    DocRefs {
        header_comment,
        apple_doc_url,
        usr,
    }
}

/// Construct an Apple developer documentation URL from a USR.
///
/// The USR format for ObjC is like: `c:objc(cs)NSString(im)initWithString:`
/// We map this to: `https://developer.apple.com/documentation/foundation/nsstring/1497402-initwithstring`
///
/// Note: We construct a best-effort URL. The actual URL may differ due to
/// Apple's documentation routing. The USR itself is the stable identifier.
fn construct_apple_doc_url(usr: &str) -> Option<String> {
    // For now, store USR as the primary identifier.
    // Apple doc URL construction requires knowledge of the documentation
    // slug mapping, which we can build incrementally.
    // A basic heuristic: class-level USRs like `c:objc(cs)NSString`
    if usr.starts_with("c:objc(cs)") {
        let rest = &usr["c:objc(cs)".len()..];
        // Extract class name
        if let Some(paren_pos) = rest.find('(') {
            let class_name = &rest[..paren_pos];
            return Some(format!(
                "https://developer.apple.com/documentation/foundation/{}",
                class_name.to_lowercase()
            ));
        } else {
            return Some(format!(
                "https://developer.apple.com/documentation/foundation/{}",
                rest.to_lowercase()
            ));
        }
    }
    None
}

// ---------------------------------------------------------------------------
// Framework filtering
// ---------------------------------------------------------------------------

/// Check if an entity originates from the target framework's headers.
fn is_from_framework(entity: &Entity<'_>, framework_name: &str, sdk_path: &Path) -> bool {
    let location = match entity.get_location() {
        Some(loc) => loc,
        None => return false,
    };

    let file_loc = location.get_file_location();
    let file = match file_loc.file {
        Some(f) => f,
        None => return false,
    };

    let path = file.get_path();
    let relative = path.strip_prefix(sdk_path).unwrap_or(&path);
    let path_str = relative.to_string_lossy();

    // Match declarations from this framework's headers
    // Pattern: System/Library/Frameworks/{Name}.framework/Headers/
    let expected_prefix = format!("System/Library/Frameworks/{framework_name}.framework/Headers/");
    path_str.starts_with(&expected_prefix)
}
