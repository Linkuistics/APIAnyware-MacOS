### Session 20 (2026-04-16T11:34:02Z) — Type mapping, CFSTR extraction, class predicates, expanded harness

- **What was attempted:** Four parallel improvements to the collection/generation pipeline:
  (1) type system gaps (CString, CF struct typedefs, Boolean), (2) CFSTR macro constant
  extraction and emission, (3) class-specific return-type predicates for `provide/contract`,
  (4) expanded runtime load test harness coverage.

- **What worked:**
  - `TypeRefKind::CString` added to `type_ref.rs`; `const char *` / `char *` now mapped
    in `extract_declarations.rs` type_mapping via `is_c_string_pointee()`, emitted as
    `_string` in `ffi_type_mapping.rs`. Closes FFI marshalling gap for C-string params.
  - CF record typedefs (e.g. `AXValueRef`) now map to `TypeRefKind::Struct` in
    `type_mapping.rs`; `ffi_type_mapping.rs` emits `ffi-obj-ref` for struct-data constants
    in `emit_constants.rs`. `Boolean` primitive now maps to `_bool`.
  - `is_generic_type_param()` in `ffi_type_mapping.rs` distinguishes ObjC generic type
    params (`ObjectType`, `KeyType`) from framework-prefixed enum aliases (`AXValueType`,
    `CGColorRenderingIntent`), fixing over-broad `_id` emission for enum-alias types.
  - `MacroDefinition` entity handling added to `extract_declarations.rs`:
    `extract_cfstr_macro_constant()` tokenises the source range and matches `CFSTR("...")`.
    `ir::Constant` gains `macro_value: Option<String>`. `emit_constants.rs` emits
    `(_make-cfstr "literal")` using an inlined CFStringCreateWithCString preamble.
    `is_definition()` guards added for `ObjCProtocolDecl` and `StructDecl` to prevent
    forward declarations shadowing full definitions.
  - `collect_return_type_class_names()` and `emit_class_predicates()` added to
    `emit_class.rs`: every class wrapper now emits inline `(define (nsview? v) ...)`
    predicates backed by `objc-instance-of?`, and return contracts use these specific
    predicates instead of `any/c`. Method/property collision detection partitioned into
    separate class vs. instance name sets to prevent cross-level suppression.
  - `runtime_load_test.rs` expanded: `nsview-helpers.rkt`, `cf-bridge.rkt`,
    `ax-helpers.rkt`, `cgevent-helpers.rkt`, `spi-helpers.rkt` added to `RUNTIME_FILES`
    and `LIBRARY_LOAD_CHECKS`; `ApplicationServices`, `libdispatch`, `Network`,
    `NetworkExtension` added to `REQUIRED_FRAMEWORKS`. All golden snapshot files updated.

- **What didn't work / wasn't attempted:** Full pipeline re-run not performed in this
  session — changes are in working directory, not committed. Runtime load harness
  (`RUNTIME_LOAD_TEST=1`) not re-run against updated output; test correctness assumed
  from golden file diffs and prior harness structure.

- **Key learnings / discoveries:**
  - `is_definition()` is safe for `ObjCProtocolDecl` and `StructDecl` but must NOT be
    applied to `ObjCInterfaceDecl` — SDK headers use `@interface` (declaration) without
    `@implementation` (definition), so the guard would drop all classes.
  - Class-method vs. instance-level property collision detection requires separate name
    sets; a single shared set incorrectly suppressed class factory methods whose names
    matched instance boolean properties (e.g. `+[NSMenuItem separatorItem]` vs.
    `separatorItem: bool`).
  - CFSTR token extraction requires matching the four-token sequence `CFSTR ( "..." )`
    because the preprocessor does not expand macros in the AST token stream; raw source
    tokenization is needed.
  - `map_return_contract()` using class-specific predicates propagates a stronger contract
    guarantee at module boundaries, enabling Racket to detect class mismatches at call
    site rather than deep in `coerce-arg`.

- **What this suggests trying next:** Full pipeline re-run to regenerate IR and committed
  output; runtime load harness re-verification; then proceed to next sample app (Menu Bar
  Tool or Text Editor).
