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
        matches!(&type_ref.kind, TypeRefKind::Primitive { name } if name == "void")
    }

    /// Check if a type is a struct passed by value.
    fn is_struct_type(&self, type_ref: &TypeRef) -> bool {
        matches!(type_ref.kind, TypeRefKind::Struct { .. })
    }
}

/// Racket FFI type mapper.
///
/// Maps IR types to Racket FFI type expressions (`_id`, `_uint64`, `_NSRect`, etc.).
pub struct RacketFfiTypeMapper;

impl FfiTypeMapper for RacketFfiTypeMapper {
    fn map_type(&self, type_ref: &TypeRef, is_return_type: bool) -> String {
        match &type_ref.kind {
            TypeRefKind::Primitive { name } => match name.as_str() {
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
            },
            TypeRefKind::Class { .. } | TypeRefKind::Id | TypeRefKind::Instancetype => {
                "_id".to_string()
            }
            TypeRefKind::Selector => "_pointer".to_string(),
            TypeRefKind::ClassRef => "_pointer".to_string(),
            TypeRefKind::Block { .. } => "_pointer".to_string(),
            TypeRefKind::Pointer => "_pointer".to_string(),
            TypeRefKind::Struct { name } => match name.as_str() {
                "NSRect" | "CGRect" => "_NSRect".to_string(),
                "NSPoint" | "CGPoint" => "_NSPoint".to_string(),
                "NSSize" | "CGSize" => "_NSSize".to_string(),
                "NSRange" => "_NSRange".to_string(),
                _ => "_pointer".to_string(),
            },
            TypeRefKind::Alias { name, .. } => {
                // Generic type params (ObjectType, KeyType) → _id
                // Framework-prefixed aliases (NSStringEncoding) → _uint64
                if name.ends_with("Type")
                    && !name.starts_with("NS")
                    && !name.starts_with("CG")
                    && !name.starts_with("CF")
                    && !name.starts_with("UI")
                    && !name.starts_with("AV")
                    && !name.starts_with("CK")
                    && !name.starts_with("MK")
                    && !name.starts_with("CL")
                    && !name.starts_with("WK")
                    && !name.starts_with("SC")
                    && !name.starts_with("MT")
                    && !name.starts_with("CA")
                {
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
    }
}
