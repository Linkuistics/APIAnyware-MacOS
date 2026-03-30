//! Mapping from libclang types to IR [`TypeRef`] values.
//!
//! Handles the full range of Objective-C types including id, instancetype,
//! class references, block types, pointers, primitives, structs, selectors,
//! and typedef aliases.

use clang::{Type, TypeKind};

use apianyware_macos_types::type_ref::{TypeRef, TypeRefKind};

/// Map a libclang `Type` to our IR `TypeRef`.
pub fn map_type(clang_type: &Type<'_>) -> TypeRef {
    let nullable = is_nullable(clang_type);
    let kind = map_type_kind(clang_type);
    TypeRef { nullable, kind }
}

/// Determine if a type has a `_Nullable` annotation.
fn is_nullable(clang_type: &Type<'_>) -> bool {
    matches!(
        clang_type.get_nullability(),
        Some(clang::Nullability::Nullable)
    )
}

/// Map the inner type kind.
fn map_type_kind(clang_type: &Type<'_>) -> TypeRefKind {
    match clang_type.get_kind() {
        // ObjC object pointer: could be id, instancetype, or a specific class
        TypeKind::ObjCObjectPointer => map_objc_object_pointer(clang_type),

        // ObjC id type (unqualified)
        TypeKind::ObjCId => TypeRefKind::Id,

        // instancetype
        TypeKind::ObjCTypeParam => {
            // Check if this is instancetype
            let spelling = clang_type.get_display_name();
            if spelling == "instancetype" {
                TypeRefKind::Instancetype
            } else {
                TypeRefKind::Id
            }
        }

        // ObjC Class type
        TypeKind::ObjCClass => TypeRefKind::ClassRef,

        // ObjC SEL type
        TypeKind::ObjCSel => TypeRefKind::Selector,

        // Block pointer
        TypeKind::BlockPointer => map_block_type(clang_type),

        // C pointer types
        TypeKind::Pointer => TypeRefKind::Pointer,

        // Typedef (alias)
        TypeKind::Typedef => map_typedef(clang_type),

        // Elaborated types (e.g., `struct NSPoint`)
        TypeKind::Elaborated => {
            if let Some(named) = clang_type.get_elaborated_type() {
                map_type_kind(&named)
            } else {
                TypeRefKind::Pointer
            }
        }

        // Record (struct)
        TypeKind::Record => {
            let name = clang_type.get_display_name();
            TypeRefKind::Struct { name }
        }

        // Enum
        TypeKind::Enum => {
            let name = clang_type.get_display_name();
            TypeRefKind::Alias {
                name,
                framework: None,
            }
        }

        // Primitive types
        TypeKind::Void => TypeRefKind::Primitive {
            name: "void".to_string(),
        },
        TypeKind::Bool
        | TypeKind::CharS
        | TypeKind::CharU
        | TypeKind::SChar
        | TypeKind::UChar
        | TypeKind::Short
        | TypeKind::UShort
        | TypeKind::Int
        | TypeKind::UInt
        | TypeKind::Long
        | TypeKind::ULong
        | TypeKind::LongLong
        | TypeKind::ULongLong
        | TypeKind::Float
        | TypeKind::Double
        | TypeKind::LongDouble => TypeRefKind::Primitive {
            name: map_primitive_name(clang_type),
        },

        // Incomplete array
        TypeKind::IncompleteArray => TypeRefKind::Pointer,

        // Constant array
        TypeKind::ConstantArray => TypeRefKind::Pointer,

        // Attributed type (e.g., with nullability attributes)
        TypeKind::Attributed => {
            if let Some(modified) = clang_type.get_modified_type() {
                map_type_kind(&modified)
            } else {
                TypeRefKind::Pointer
            }
        }

        // ObjC interface (the type of the class itself, not a pointer to it)
        TypeKind::ObjCInterface => {
            let name = clang_type.get_display_name();
            TypeRefKind::Class {
                name,
                framework: None,
                params: Vec::new(),
            }
        }

        // Fallback for unhandled types
        _other => {
            tracing::debug!(
                type_kind = ?_other,
                spelling = %clang_type.get_display_name(),
                "unhandled type kind, mapping to pointer"
            );
            TypeRefKind::Pointer
        }
    }
}

/// Map an ObjC object pointer to the appropriate IR type.
fn map_objc_object_pointer(clang_type: &Type<'_>) -> TypeRefKind {
    let pointee = match clang_type.get_pointee_type() {
        Some(p) => p,
        None => return TypeRefKind::Id,
    };

    match pointee.get_kind() {
        TypeKind::ObjCInterface => {
            let name = pointee.get_display_name();

            // Check for generic type arguments
            let type_args = clang_type.get_objc_type_arguments();
            let params: Vec<TypeRef> = type_args.iter().map(|t| map_type(t)).collect();

            TypeRefKind::Class {
                name,
                framework: None,
                params,
            }
        }
        TypeKind::ObjCId => TypeRefKind::Id,
        TypeKind::ObjCClass => TypeRefKind::ClassRef,
        _ => {
            // Check display name for common patterns
            let display = clang_type.get_display_name();
            if display == "id" || display.starts_with("id<") {
                TypeRefKind::Id
            } else if display == "instancetype" {
                TypeRefKind::Instancetype
            } else {
                TypeRefKind::Id
            }
        }
    }
}

/// Map a block pointer type to a Block TypeRef.
fn map_block_type(clang_type: &Type<'_>) -> TypeRefKind {
    let pointee = match clang_type.get_pointee_type() {
        Some(p) => p,
        None => {
            return TypeRefKind::Block {
                params: Vec::new(),
                return_type: Box::new(TypeRef {
                    nullable: false,
                    kind: TypeRefKind::Primitive {
                        name: "void".to_string(),
                    },
                }),
            };
        }
    };

    let return_type = match pointee.get_result_type() {
        Some(rt) => Box::new(map_type(&rt)),
        None => Box::new(TypeRef {
            nullable: false,
            kind: TypeRefKind::Primitive {
                name: "void".to_string(),
            },
        }),
    };

    let arg_types = pointee.get_argument_types().unwrap_or_default();
    let params: Vec<TypeRef> = arg_types.iter().map(|t| map_type(t)).collect();

    TypeRefKind::Block {
        params,
        return_type,
    }
}

/// Map a typedef to either a known special type or an alias.
fn map_typedef(clang_type: &Type<'_>) -> TypeRefKind {
    let name = clang_type.get_display_name();

    // Check for well-known ObjC typedefs
    match name.as_str() {
        "instancetype" => return TypeRefKind::Instancetype,
        "id" => return TypeRefKind::Id,
        "Class" => return TypeRefKind::ClassRef,
        "SEL" => return TypeRefKind::Selector,
        "BOOL" => {
            return TypeRefKind::Primitive {
                name: "bool".to_string(),
            }
        }
        "NSInteger" => {
            return TypeRefKind::Primitive {
                name: "int64".to_string(),
            }
        }
        "NSUInteger" => {
            return TypeRefKind::Primitive {
                name: "uint64".to_string(),
            }
        }
        "CGFloat" => {
            return TypeRefKind::Primitive {
                name: "double".to_string(),
            }
        }
        "NSTimeInterval" => {
            return TypeRefKind::Primitive {
                name: "double".to_string(),
            }
        }
        _ => {}
    }

    // Resolve the canonical (underlying) type to determine the true FFI type.
    // This handles typedefs like NSImageName (typedef NSString *) which should
    // map to _id, not _uint64.
    let canonical = clang_type.get_canonical_type();
    match canonical.get_kind() {
        TypeKind::BlockPointer => map_block_type(&canonical),

        // Object pointer typedefs (NSImageName → NSString *, etc.) → resolve to id/class
        TypeKind::ObjCObjectPointer => map_objc_object_pointer(&canonical),

        // Pointer typedefs → resolve to pointer
        TypeKind::Pointer => TypeRefKind::Pointer,

        // Struct typedefs (NSRect → CGRect, etc.) → keep as Alias for geometry
        // struct matching in the FFI mapper
        TypeKind::Record => TypeRefKind::Alias {
            name,
            framework: None,
        },

        // Enum typedefs (NSBezelStyle, etc.) → keep as Alias so emitters can
        // use _uint64 for bitmask/enum values
        TypeKind::Enum => TypeRefKind::Alias {
            name,
            framework: None,
        },

        // Integer/float typedefs not caught by the well-known check above
        // (e.g., int64_t, uint32_t, FourCharCode) → resolve to primitive
        TypeKind::Bool
        | TypeKind::CharS
        | TypeKind::CharU
        | TypeKind::SChar
        | TypeKind::UChar
        | TypeKind::Short
        | TypeKind::UShort
        | TypeKind::Int
        | TypeKind::UInt
        | TypeKind::Long
        | TypeKind::ULong
        | TypeKind::LongLong
        | TypeKind::ULongLong
        | TypeKind::Float
        | TypeKind::Double
        | TypeKind::LongDouble => TypeRefKind::Primitive {
            name: map_primitive_name(&canonical),
        },

        // Everything else (uncommon typedefs) → keep as Alias
        _ => TypeRefKind::Alias {
            name,
            framework: None,
        },
    }
}

/// Map primitive C types to consistent Go-compatible names
/// to match the POC output format.
fn map_primitive_name(clang_type: &Type<'_>) -> String {
    match clang_type.get_kind() {
        TypeKind::Bool => "bool".to_string(),
        TypeKind::CharS | TypeKind::CharU | TypeKind::SChar => "int8".to_string(),
        TypeKind::UChar => "uint8".to_string(),
        TypeKind::Short => "int16".to_string(),
        TypeKind::UShort => "uint16".to_string(),
        TypeKind::Int => "int32".to_string(),
        TypeKind::UInt => "uint32".to_string(),
        // On macOS arm64: long is 64-bit
        TypeKind::Long => "int64".to_string(),
        TypeKind::ULong => "uint64".to_string(),
        TypeKind::LongLong => "int64".to_string(),
        TypeKind::ULongLong => "uint64".to_string(),
        TypeKind::Float => "float".to_string(),
        TypeKind::Double | TypeKind::LongDouble => "double".to_string(),
        _ => clang_type.get_display_name(),
    }
}
