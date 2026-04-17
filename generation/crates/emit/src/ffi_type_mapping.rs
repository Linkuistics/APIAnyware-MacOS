//! IR type → FFI type string mapping.
//!
//! Converts IR [`TypeRef`] values to FFI type expression strings for target languages.
//! Each language emitter provides its own [`FfiTypeMapper`] implementation.

use apianyware_macos_types::type_ref::{TypeRef, TypeRefKind};

/// Maps IR types to FFI type strings for a specific target language.
pub trait FfiTypeMapper {
    /// Convert a [`TypeRef`] to its FFI type string representation.
    ///
    /// `is_return_type` affects mapping for certain types (e.g., `void` as return
    /// maps to `_void` in Racket, but `void` as parameter maps to `_pointer`).
    fn map_type(&self, type_ref: &TypeRef, is_return_type: bool) -> String;

    /// Check if a type represents an object pointer (class, protocol, id, instancetype).
    fn is_object_type(&self, type_ref: &TypeRef) -> bool {
        matches!(
            type_ref.kind,
            TypeRefKind::Class { .. } | TypeRefKind::Id | TypeRefKind::Instancetype
        )
    }

    /// Check if a type is a block type.
    fn is_block_type(&self, type_ref: &TypeRef) -> bool {
        matches!(type_ref.kind, TypeRefKind::Block { .. })
    }

    /// Check if a type represents void.
    fn is_void(&self, type_ref: &TypeRef) -> bool {
        matches!(&type_ref.kind, TypeRefKind::Primitive { name } if normalize_primitive_name(name) == "void")
    }

    /// Check if a type is a struct passed by value.
    fn is_struct_type(&self, type_ref: &TypeRef) -> bool {
        match &type_ref.kind {
            TypeRefKind::Struct { .. } => true,
            TypeRefKind::Alias { name, .. } => is_known_geometry_struct(name),
            _ => false,
        }
    }
}

/// Strip framework-qualified prefix and normalize case for primitive name matching.
///
/// The Swift API digester produces qualified primitive names like `Swift.Void` or
/// `Swift.Bool`. This strips the prefix and lowercases to match the canonical
/// primitive names used by the ObjC extractor (`void`, `bool`, `uint64`, etc.).
fn normalize_primitive_name(name: &str) -> String {
    let unqualified = match name.rsplit_once('.') {
        Some((_, suffix)) => suffix,
        None => name,
    };
    unqualified.to_ascii_lowercase()
}

/// Known geometry struct names that may appear as aliases (typedefs) in the IR.
///
/// libclang classifies `NSRect`, `CGRect`, etc. as typedefs (aliases) rather than
/// struct types. The FFI mapper must recognize these and map them to their cstruct
/// representations rather than falling through to the `_uint64` default.
fn is_known_geometry_struct(name: &str) -> bool {
    matches!(
        name,
        "NSRect"
            | "CGRect"
            | "NSPoint"
            | "CGPoint"
            | "NSSize"
            | "CGSize"
            | "NSRange"
            | "NSEdgeInsets"
            | "NSDirectionalEdgeInsets"
            | "NSAffineTransformStruct"
            | "CGAffineTransform"
            | "CGVector"
    )
}

/// Map a known geometry struct alias name to its Racket FFI cstruct type.
fn map_geometry_struct_alias(name: &str) -> Option<&'static str> {
    match name {
        "NSRect" | "CGRect" => Some("_NSRect"),
        "NSPoint" | "CGPoint" => Some("_NSPoint"),
        "NSSize" | "CGSize" => Some("_NSSize"),
        "NSRange" => Some("_NSRange"),
        "NSEdgeInsets" => Some("_NSEdgeInsets"),
        "NSDirectionalEdgeInsets" => Some("_NSDirectionalEdgeInsets"),
        "NSAffineTransformStruct" => Some("_NSAffineTransformStruct"),
        "CGAffineTransform" => Some("_CGAffineTransform"),
        "CGVector" => Some("_CGVector"),
        _ => None,
    }
}

/// Detect ObjC generic type parameters (ObjectType, KeyType, ElementType, etc.)
/// vs framework-prefixed enum aliases (AXValueType, NSBezelType, etc.).
///
/// Generic type params start with a single uppercase letter followed by lowercase
/// (e.g., "ObjectType", "KeyType"). Framework-prefixed aliases start with 2+
/// uppercase letters (e.g., "NSType", "AXValueType", "CGColorRenderingIntent").
pub fn is_generic_type_param(name: &str) -> bool {
    let mut chars = name.chars();
    match (chars.next(), chars.next()) {
        (Some(a), Some(b)) => a.is_ascii_uppercase() && b.is_ascii_lowercase(),
        _ => false,
    }
}

/// Racket FFI type mapper.
///
/// Maps IR types to Racket FFI type expressions (`_id`, `_uint64`, `_NSRect`, etc.).
pub struct RacketFfiTypeMapper;

impl FfiTypeMapper for RacketFfiTypeMapper {
    fn map_type(&self, type_ref: &TypeRef, is_return_type: bool) -> String {
        match &type_ref.kind {
            TypeRefKind::Primitive { name } => {
                let normalized = normalize_primitive_name(name);
                match normalized.as_str() {
                    "void" => {
                        if is_return_type {
                            "_void".to_string()
                        } else {
                            "_pointer".to_string()
                        }
                    }
                    "bool" => "_bool".to_string(),
                    "int8" => "_int8".to_string(),
                    "uint8" => "_uint8".to_string(),
                    "int16" => "_int16".to_string(),
                    "uint16" => "_uint16".to_string(),
                    "int32" => "_int32".to_string(),
                    "uint32" => "_uint32".to_string(),
                    "int64" => "_int64".to_string(),
                    "uint64" => "_uint64".to_string(),
                    "float" => "_float".to_string(),
                    "double" => "_double".to_string(),
                    "pointer" => "_pointer".to_string(),
                    _ => "_pointer".to_string(),
                }
            }
            TypeRefKind::Class { .. } | TypeRefKind::Id | TypeRefKind::Instancetype => {
                "_id".to_string()
            }
            TypeRefKind::Selector => "_pointer".to_string(),
            TypeRefKind::ClassRef => "_pointer".to_string(),
            TypeRefKind::Block { .. } => "_pointer".to_string(),
            TypeRefKind::CString => "_string".to_string(),
            TypeRefKind::Pointer => "_pointer".to_string(),
            TypeRefKind::Struct { name } => map_geometry_struct_alias(name)
                .map(|s| s.to_string())
                .unwrap_or_else(|| "_pointer".to_string()),
            TypeRefKind::FunctionPointer { .. } => "_pointer".to_string(),
            TypeRefKind::Alias { name, .. } => {
                // Geometry struct typedefs (NSRect, CGPoint, etc.) → cstruct types
                if let Some(ffi_type) = map_geometry_struct_alias(name) {
                    return ffi_type.to_string();
                }
                // Generic ObjC type params (ObjectType, KeyType, ElementType)
                // start with a single uppercase letter followed by lowercase.
                // Framework-prefixed aliases (NSStringEncoding, AXValueType,
                // CGColorRenderingIntent) start with 2+ uppercase letters.
                if name.ends_with("Type") && is_generic_type_param(name) {
                    "_id".to_string()
                } else {
                    "_uint64".to_string()
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_type(kind: TypeRefKind) -> TypeRef {
        TypeRef {
            nullable: false,
            kind,
        }
    }

    #[test]
    fn test_racket_primitives() {
        let m = RacketFfiTypeMapper;
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "void".into()
                }),
                true
            ),
            "_void"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "void".into()
                }),
                false
            ),
            "_pointer"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "bool".into()
                }),
                false
            ),
            "_bool"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "uint64".into()
                }),
                false
            ),
            "_uint64"
        );
    }

    #[test]
    fn test_racket_object_types() {
        let m = RacketFfiTypeMapper;
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Class {
                    name: "NSString".into(),
                    framework: None,
                    params: vec![],
                }),
                false,
            ),
            "_id"
        );
        assert_eq!(m.map_type(&make_type(TypeRefKind::Id), false), "_id");
        assert_eq!(
            m.map_type(&make_type(TypeRefKind::Instancetype), true),
            "_id"
        );
    }

    #[test]
    fn test_racket_struct_types() {
        let m = RacketFfiTypeMapper;
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "NSRect".into()
                }),
                false
            ),
            "_NSRect"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "CGRect".into()
                }),
                false
            ),
            "_NSRect"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "NSRange".into()
                }),
                false
            ),
            "_NSRange"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "NSEdgeInsets".into()
                }),
                false
            ),
            "_NSEdgeInsets"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "CGAffineTransform".into()
                }),
                false
            ),
            "_CGAffineTransform"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "CGVector".into()
                }),
                false
            ),
            "_CGVector"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "NSDirectionalEdgeInsets".into()
                }),
                false
            ),
            "_NSDirectionalEdgeInsets"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "NSAffineTransformStruct".into()
                }),
                false
            ),
            "_NSAffineTransformStruct"
        );
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Struct {
                    name: "SomeOtherStruct".into()
                }),
                false
            ),
            "_pointer"
        );
    }

    #[test]
    fn test_racket_alias_types() {
        let m = RacketFfiTypeMapper;
        // Generic type param → _id
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "ObjectType".into(),
                    framework: None,
                }),
                false,
            ),
            "_id"
        );
        // Framework-prefixed alias → _uint64
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSStringEncoding".into(),
                    framework: None,
                }),
                false,
            ),
            "_uint64"
        );
    }

    #[test]
    fn test_racket_geometry_struct_aliases() {
        let m = RacketFfiTypeMapper;
        // NSRect alias → _NSRect (libclang emits these as Alias, not Struct)
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSRect".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSRect"
        );
        // CGRect alias → _NSRect
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "CGRect".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSRect"
        );
        // NSPoint alias → _NSPoint
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSPoint".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSPoint"
        );
        // NSSize alias → _NSSize
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSSize".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSSize"
        );
        // NSRange alias → _NSRange
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSRange".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSRange"
        );
        // NSEdgeInsets alias → _NSEdgeInsets
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSEdgeInsets".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSEdgeInsets"
        );
        // NSAffineTransformStruct alias → _NSAffineTransformStruct
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSAffineTransformStruct".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSAffineTransformStruct"
        );
        // CGAffineTransform alias → _CGAffineTransform
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "CGAffineTransform".into(),
                    framework: None,
                }),
                false,
            ),
            "_CGAffineTransform"
        );
        // CGVector alias → _CGVector
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "CGVector".into(),
                    framework: None,
                }),
                false,
            ),
            "_CGVector"
        );
        // NSDirectionalEdgeInsets alias → _NSDirectionalEdgeInsets
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "NSDirectionalEdgeInsets".into(),
                    framework: None,
                }),
                false,
            ),
            "_NSDirectionalEdgeInsets"
        );
    }

    #[test]
    fn test_qualified_primitive_names() {
        let m = RacketFfiTypeMapper;
        // Swift.Void as return type → _void
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "Swift.Void".into()
                }),
                true
            ),
            "_void"
        );
        // Swift.Void as parameter → _pointer (same as unqualified void)
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "Swift.Void".into()
                }),
                false
            ),
            "_pointer"
        );
        // Swift.Bool → _bool
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "Swift.Bool".into()
                }),
                false
            ),
            "_bool"
        );
        // Swift.Double → _double
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "Swift.Double".into()
                }),
                false
            ),
            "_double"
        );
        // Swift.Float → _float
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "Swift.Float".into()
                }),
                false
            ),
            "_float"
        );
        // Unqualified names still work
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "uint64".into()
                }),
                false
            ),
            "_uint64"
        );
        // Unknown qualified primitive → _pointer (collection-level issue, not mapper's job)
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Primitive {
                    name: "CoreFoundation.CFStringEncoding".into()
                }),
                false
            ),
            "_pointer"
        );
    }

    #[test]
    fn test_is_void_with_qualified_names() {
        let m = RacketFfiTypeMapper;
        assert!(m.is_void(&make_type(TypeRefKind::Primitive {
            name: "void".into()
        })));
        assert!(m.is_void(&make_type(TypeRefKind::Primitive {
            name: "Swift.Void".into()
        })));
        assert!(!m.is_void(&make_type(TypeRefKind::Primitive {
            name: "bool".into()
        })));
    }

    #[test]
    fn test_trait_helper_methods() {
        let m = RacketFfiTypeMapper;
        assert!(m.is_object_type(&make_type(TypeRefKind::Id)));
        assert!(m.is_object_type(&make_type(TypeRefKind::Class {
            name: "NSString".into(),
            framework: None,
            params: vec![],
        })));
        assert!(!m.is_object_type(&make_type(TypeRefKind::Primitive {
            name: "int32".into()
        })));
        assert!(m.is_block_type(&make_type(TypeRefKind::Block {
            params: vec![],
            return_type: Box::new(TypeRef::void()),
        })));
        assert!(m.is_void(&TypeRef::void()));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Struct {
            name: "NSRect".into()
        })));
        // Alias struct types recognized as structs
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "NSRect".into(),
            framework: None,
        })));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "CGPoint".into(),
            framework: None,
        })));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "NSEdgeInsets".into(),
            framework: None,
        })));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "CGAffineTransform".into(),
            framework: None,
        })));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "CGVector".into(),
            framework: None,
        })));
        assert!(m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "NSDirectionalEdgeInsets".into(),
            framework: None,
        })));
        assert!(!m.is_struct_type(&make_type(TypeRefKind::Alias {
            name: "NSStringEncoding".into(),
            framework: None,
        })));
    }

    #[test]
    fn test_generic_type_param_detection() {
        // Generic ObjC type params: single uppercase then lowercase
        assert!(is_generic_type_param("ObjectType"));
        assert!(is_generic_type_param("KeyType"));
        assert!(is_generic_type_param("ValueType"));
        assert!(is_generic_type_param("ElementType"));
        assert!(is_generic_type_param("ContentType"));
        assert!(is_generic_type_param("ResultType"));

        // Framework-prefixed: 2+ uppercase letters at start
        assert!(!is_generic_type_param("NSBezelType"));
        assert!(!is_generic_type_param("AXValueType"));
        assert!(!is_generic_type_param("CGColorRenderingIntent"));
        assert!(!is_generic_type_param("CFStringEncoding"));
        assert!(!is_generic_type_param("WKContentMode"));
        assert!(!is_generic_type_param("MTLResourceType"));
    }

    #[test]
    fn test_framework_prefixed_alias_maps_to_uint64() {
        let m = RacketFfiTypeMapper;
        // AXValueType is a framework-prefixed enum alias → _uint64
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "AXValueType".into(),
                    framework: None,
                }),
                false
            ),
            "_uint64"
        );
        // ObjectType is a generic type param → _id
        assert_eq!(
            m.map_type(
                &make_type(TypeRefKind::Alias {
                    name: "ObjectType".into(),
                    framework: None,
                }),
                false
            ),
            "_id"
        );
    }
}
