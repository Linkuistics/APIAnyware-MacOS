### Session 20 (2026-04-16T08:14:33Z) — C-function type mapping fixes and emitter collision/dedup bugs

- **Attempted:** Four C-function type-mapping sub-issues (Boolean→_bool, const char*→_string, AXValueType→_uint64, CF struct globals→ffi-obj-ref), plus two emitter collision/dedup bugs (NSScreen duplicate define, NSMenuItem class-method suppression), plus a new `nsview-helpers.rkt` runtime file.

- **What worked:**
  - *Boolean → `_bool`*: Added `"Boolean"` to the typedef well-known list in `collection/crates/extract-objc/src/type_mapping.rs`. `BOOL | Boolean` now maps to `TypeRefKind::Primitive { name: "bool" }`. Needs re-collect to propagate.
  - *`const char *` → `_string`*: Added new `TypeRefKind::CString` variant to the IR schema (`collection/crates/types/src/type_ref.rs`). ObjC extractor detects `char`/`const char` pointees via `is_c_string_pointee()` (matches `CharS | CharU` only — excludes `signed char` / `unsigned char`). FFI mapper emits `_string`; contract mapper emits `string?`. Golden files updated: `nsfilemanager.rkt` return contracts for `fileSystemRepresentationWithPath:` and `stringWithFileSystemRepresentation:length:` now show `string?`. Needs re-collect.
  - *`AXValueType` → `_uint64`*: Replaced fragile hand-enumerated prefix list (15 prefixes) with `is_generic_type_param()` in `generation/crates/emit/src/ffi_type_mapping.rs`. Detects ObjC generic type params (single uppercase then lowercase, e.g. "ObjectType") vs framework-prefixed aliases (2+ uppercase, e.g. "AXValueType"). Refactored `emit_functions.rs` `map_contract` to reuse the same function. 2 new unit tests.
  - *CF struct globals → `ffi-obj-ref`*: Changed `map_typedef` to emit `TypeRefKind::Struct { name }` (not `Alias`) for `TypeKind::Record` typedefs. `is_struct_data_symbol` now catches CF struct globals (`kCFTypeDictionaryKeyCallBacks`, `NSInt*CallBacks`, `NSNonOwnedPointer*`, `NSZeroPoint/Rect/Size`, `NSEdgeInsetsZero`, `NSDirectionalEdgeInsetsZero`, etc.). Large golden-file churn in `constants.rkt` for both Foundation and AppKit. 1 new test. Needs re-collect.
  - *NSScreen duplicate define*: `effective_properties` now deduplicates by generated Racket getter name instead of raw IR property name. Fixes the ObjC `CGDirectDisplayID` / Swift `cgDirectDisplayID` case where both kebab-case to the same identifier. 2 new unit tests.
  - *NSMenuItem class-method suppression*: Partitioned the property name set into `class_property_names` / `instance_property_names` (`PropertyNameSets` struct). Class methods now only collide with class property names; the instance property `separatorItem` (bool getter) no longer suppresses the class method `+separatorItem` (factory). Added inverse rule: instance properties whose getter name collides with a class method are suppressed (class method wins). `nsmenuitem.rkt` golden updated. 2 new unit tests.
  - *`nsview-helpers.rkt`*: New runtime file with `set-autoresizing-mask!` using typed `objc_msgSend` binding (NSUInteger param). Added to `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS` in `runtime_load_test.rs`. Loads clean.
  - *Enum golden cleanup*: Unsigned bitmask values previously emitted as negative signed literals (e.g. `NSDragOperationEvery -1`, `NSEventMaskAny -1`, `NSFontDescriptorClassMask -268435456`) are now emitted as unsigned values or removed. The `-1` "any/all" sentinels were dropped from the enum golden files.
  - *`type-mapping.rkt` require removed from constants emitter*: Struct-typed globals now use `ffi-obj-ref` (no typed accessor needed), so the `type-mapping.rkt` require was dropped from Foundation and AppKit `constants.rkt` golden files.

- **What didn't work / wasn't attempted:**
  - Re-collection was not run — type-mapping fixes require a full pipeline rerun to propagate to IR and generated files. Deployed bindings need `cargo run --example bundle_app` after re-collect.
  - Sub-issue 3 (AXValueType) is fixed at the emitter level but not confirmed via re-collect.

- **What to try next:**
  - Run full pipeline re-collect to propagate Boolean/CString/Struct typedef fixes into deployed IR and generated `.rkt` files.
  - Verify Modaliser-Racket can replace its 7 locally-retained `get-ffi-obj` definitions in `ffi/accessibility.rkt` with generated imports.
  - Address the `is_definition()` guard audit for `StructDecl`/`ObjCInterfaceDecl`/`ObjCProtocolDecl` arms.
  - Begin non-linkable symbol leak classes A and B (bare `c:@<name>` macros and anonymous enum members).

- **Key learnings:** Deduplication of ObjC/Swift dual-extracted properties must happen at the Racket-name level, not the IR name level — casing collisions are invisible until both names kebab-case identically. The `is_generic_type_param` single-uppercase-prefix heuristic is more robust and self-documenting than a maintained allowlist of framework prefixes. Partitioning collision sets by class vs instance level is essential — a flat merged set causes cross-level false positives that silently drop correct bindings.
