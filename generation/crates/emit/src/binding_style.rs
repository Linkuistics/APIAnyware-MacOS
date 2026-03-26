//! Binding style abstraction for multi-paradigm code generation.
//!
//! Languages with multiple paradigms (OO + functional) produce separate binding
//! styles from the same enriched IR. Each emitter declares which styles it supports
//! and the CLI lets users select a specific style.
//!
//! For example, Common Lisp gets both CLOS class wrappers and a `defun`-based
//! procedural API; OCaml gets both a module-based functional API and an OO API.

use std::fmt;

/// A binding style that an emitter can produce.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BindingStyle {
    /// Object-oriented bindings using the target language's class/object system.
    /// Examples: Racket classes, CLOS, OCaml objects, Smalltalk messages.
    ObjectOriented,

    /// Functional bindings using plain functions and immutable data.
    /// Examples: Scheme procedures, Haskell monadic API, OCaml modules.
    Functional,

    /// Low-level procedural bindings with explicit memory management.
    /// Examples: Zig, C-level FFI.
    Procedural,
}

impl fmt::Display for BindingStyle {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::ObjectOriented => write!(f, "oo"),
            Self::Functional => write!(f, "functional"),
            Self::Procedural => write!(f, "procedural"),
        }
    }
}

impl BindingStyle {
    /// Parse a binding style from a CLI string.
    pub fn from_str_name(s: &str) -> Option<Self> {
        match s {
            "oo" | "object-oriented" => Some(Self::ObjectOriented),
            "functional" | "fn" => Some(Self::Functional),
            "procedural" | "proc" => Some(Self::Procedural),
            _ => None,
        }
    }
}

/// Metadata about a target language emitter.
pub struct LanguageInfo {
    /// Short identifier used in CLI (e.g., "racket", "haskell", "zig").
    pub id: &'static str,
    /// Human-readable name (e.g., "Racket", "Haskell", "Zig").
    pub display_name: &'static str,
    /// Binding styles this emitter supports.
    pub supported_styles: &'static [BindingStyle],
    /// Default binding style when none is specified.
    pub default_style: BindingStyle,
}

/// Result of emitting a single framework in one binding style.
#[derive(Debug, Default)]
pub struct EmitResult {
    /// Number of files written.
    pub files_written: usize,
    /// Number of classes emitted.
    pub classes_emitted: usize,
    /// Number of protocols emitted.
    pub protocols_emitted: usize,
    /// Number of enums emitted.
    pub enums_emitted: usize,
    /// Number of functions emitted.
    pub functions_emitted: usize,
    /// Number of constants emitted.
    pub constants_emitted: usize,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_binding_style_display() {
        assert_eq!(BindingStyle::ObjectOriented.to_string(), "oo");
        assert_eq!(BindingStyle::Functional.to_string(), "functional");
        assert_eq!(BindingStyle::Procedural.to_string(), "procedural");
    }

    #[test]
    fn test_binding_style_parse() {
        assert_eq!(
            BindingStyle::from_str_name("oo"),
            Some(BindingStyle::ObjectOriented)
        );
        assert_eq!(
            BindingStyle::from_str_name("object-oriented"),
            Some(BindingStyle::ObjectOriented)
        );
        assert_eq!(
            BindingStyle::from_str_name("functional"),
            Some(BindingStyle::Functional)
        );
        assert_eq!(
            BindingStyle::from_str_name("fn"),
            Some(BindingStyle::Functional)
        );
        assert_eq!(
            BindingStyle::from_str_name("procedural"),
            Some(BindingStyle::Procedural)
        );
        assert_eq!(BindingStyle::from_str_name("unknown"), None);
    }

    #[test]
    fn test_language_info() {
        let racket = LanguageInfo {
            id: "racket",
            display_name: "Racket",
            supported_styles: &[BindingStyle::ObjectOriented, BindingStyle::Functional],
            default_style: BindingStyle::ObjectOriented,
        };
        assert_eq!(racket.id, "racket");
        assert_eq!(racket.supported_styles.len(), 2);
    }
}
