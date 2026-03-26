//! Shared naming utilities for code generation.
//!
//! Provides CamelCase parsing and conversion functions used by all language emitters.

/// Split a CamelCase identifier into its component words.
///
/// Handles acronym runs (e.g., "UTF8String" → ["UTF8", "String"]),
/// digit boundaries (e.g., "int32" → ["int32"]), and standard
/// camelCase transitions (e.g., "makeKeyAndOrderFront" → ["make", "Key", "And", "Order", "Front"]).
pub fn split_camel_case(input: &str) -> Vec<String> {
    let bytes = input.as_bytes();
    let len = bytes.len();
    let mut words = Vec::new();
    let mut start = 0;

    let mut i = 0;
    while i < len {
        let c = bytes[i];

        if i == start {
            i += 1;
            continue;
        }

        if c.is_ascii_uppercase() {
            let prev = bytes[i - 1];
            if prev.is_ascii_lowercase() {
                // lowercase → Upper: word boundary
                words.push(input[start..i].to_string());
                start = i;
            } else if prev.is_ascii_uppercase() || prev.is_ascii_digit() {
                // Acronym/digit run: split only if next char is lowercase
                // (e.g., "UTF8String" → split before S, but "3D" stays together)
                if i + 1 < len && bytes[i + 1].is_ascii_lowercase() {
                    words.push(input[start..i].to_string());
                    start = i;
                }
            }
        }

        i += 1;
    }

    if start < len {
        words.push(input[start..].to_string());
    }

    words
}

/// Convert a CamelCase identifier to kebab-case (lowercase, hyphen-separated).
///
/// Examples:
/// - "makeKeyAndOrderFront" → "make-key-and-order-front"
/// - "UTF8String" → "utf8-string"
/// - "URLWithString" → "url-with-string"
/// - "backgroundColor" → "background-color"
pub fn camel_to_kebab(input: &str) -> String {
    let words = split_camel_case(input);
    words
        .iter()
        .map(|w| w.to_ascii_lowercase())
        .collect::<Vec<_>>()
        .join("-")
}

/// Convert an ObjC selector to a kebab-case function name component.
///
/// Multi-keyword selectors have their colons stripped and keywords joined with hyphens.
/// Each keyword is individually converted from CamelCase to kebab-case.
///
/// Examples:
/// - "makeKeyAndOrderFront:" → "make-key-and-order-front"
/// - "initWithContentRect:styleMask:backing:defer:" → "init-with-content-rect-style-mask-backing-defer"
/// - "length" → "length"
pub fn selector_to_kebab_name(selector: &str) -> String {
    if selector.contains(':') {
        let keywords: Vec<&str> = selector.split(':').filter(|s| !s.is_empty()).collect();
        keywords
            .iter()
            .map(|kw| camel_to_kebab(kw))
            .collect::<Vec<_>>()
            .join("-")
    } else {
        camel_to_kebab(selector)
    }
}

/// Convert an ObjC class name to lowercase (e.g., "NSWindow" → "nswindow").
pub fn class_name_to_lowercase(name: &str) -> String {
    name.to_ascii_lowercase()
}

/// Determine if a selector represents a mutating operation.
///
/// Uses the first keyword of the selector to check against known mutating prefixes.
pub fn is_mutating_selector(selector: &str) -> bool {
    let first_keyword = if selector.contains(':') {
        selector.split(':').next().unwrap_or("")
    } else {
        selector
    };

    const MUTATING_PREFIXES: &[&str] = &[
        "set", "add", "remove", "insert", "replace", "move", "close", "center", "order", "display",
        "perform", "begin", "end", "toggle", "reset",
    ];

    MUTATING_PREFIXES
        .iter()
        .any(|prefix| first_keyword.starts_with(prefix))
}

/// Convert a CamelCase identifier to snake_case (lowercase, underscore-separated).
///
/// Useful for languages like Haskell, OCaml, Zig that use snake_case conventions.
///
/// Examples:
/// - "makeKeyAndOrderFront" → "make_key_and_order_front"
/// - "UTF8String" → "utf8_string"
/// - "NSWindow" → "ns_window"
pub fn camel_to_snake(input: &str) -> String {
    let words = split_camel_case(input);
    words
        .iter()
        .map(|w| w.to_ascii_lowercase())
        .collect::<Vec<_>>()
        .join("_")
}

/// Convert an ObjC selector to a snake_case function name component.
///
/// Examples:
/// - "initWithContentRect:styleMask:" → "init_with_content_rect_style_mask"
/// - "length" → "length"
pub fn selector_to_snake_name(selector: &str) -> String {
    if selector.contains(':') {
        let keywords: Vec<&str> = selector.split(':').filter(|s| !s.is_empty()).collect();
        keywords
            .iter()
            .map(|kw| camel_to_snake(kw))
            .collect::<Vec<_>>()
            .join("_")
    } else {
        camel_to_snake(selector)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_split_camel_case() {
        assert_eq!(
            split_camel_case("makeKeyAndOrderFront"),
            vec!["make", "Key", "And", "Order", "Front"]
        );
        assert_eq!(split_camel_case("UTF8String"), vec!["UTF8", "String"]);
        assert_eq!(
            split_camel_case("URLWithString"),
            vec!["URL", "With", "String"]
        );
        assert_eq!(
            split_camel_case("backgroundColor"),
            vec!["background", "Color"]
        );
        assert_eq!(split_camel_case("setTitle"), vec!["set", "Title"]);
        assert_eq!(split_camel_case("length"), vec!["length"]);
    }

    #[test]
    fn test_camel_to_kebab() {
        assert_eq!(
            camel_to_kebab("makeKeyAndOrderFront"),
            "make-key-and-order-front"
        );
        assert_eq!(camel_to_kebab("UTF8String"), "utf8-string");
        assert_eq!(camel_to_kebab("URLWithString"), "url-with-string");
        assert_eq!(camel_to_kebab("setTitle"), "set-title");
        assert_eq!(camel_to_kebab("backgroundColor"), "background-color");
        assert_eq!(camel_to_kebab("length"), "length");
        assert_eq!(camel_to_kebab("CATransform3DValue"), "ca-transform3d-value");
    }

    #[test]
    fn test_selector_to_kebab_name() {
        assert_eq!(
            selector_to_kebab_name("makeKeyAndOrderFront:"),
            "make-key-and-order-front"
        );
        assert_eq!(
            selector_to_kebab_name("initWithContentRect:styleMask:backing:defer:"),
            "init-with-content-rect-style-mask-backing-defer"
        );
        assert_eq!(selector_to_kebab_name("length"), "length");
    }

    #[test]
    fn test_class_name_to_lowercase() {
        assert_eq!(class_name_to_lowercase("NSWindow"), "nswindow");
        assert_eq!(class_name_to_lowercase("NSString"), "nsstring");
    }

    #[test]
    fn test_is_mutating_selector() {
        assert!(is_mutating_selector("setTitle:"));
        assert!(is_mutating_selector("addObject:"));
        assert!(is_mutating_selector("removeAllObjects"));
        assert!(is_mutating_selector("insertObject:atIndex:"));
        assert!(is_mutating_selector("replaceObjectAtIndex:withObject:"));
        assert!(is_mutating_selector("close"));
        assert!(is_mutating_selector("orderFront:"));
        assert!(is_mutating_selector("display"));
        assert!(is_mutating_selector("performSelector:"));
        assert!(!is_mutating_selector("init"));
        assert!(!is_mutating_selector("length"));
        assert!(!is_mutating_selector("description"));
        assert!(!is_mutating_selector("objectAtIndex:"));
    }

    #[test]
    fn test_camel_to_snake() {
        assert_eq!(
            camel_to_snake("makeKeyAndOrderFront"),
            "make_key_and_order_front"
        );
        assert_eq!(camel_to_snake("UTF8String"), "utf8_string");
        assert_eq!(camel_to_snake("NSWindow"), "ns_window");
        assert_eq!(camel_to_snake("backgroundColor"), "background_color");
    }

    #[test]
    fn test_selector_to_snake_name() {
        assert_eq!(
            selector_to_snake_name("initWithContentRect:styleMask:"),
            "init_with_content_rect_style_mask"
        );
        assert_eq!(selector_to_snake_name("length"), "length");
    }
}
