### Session 20 (2026-04-16T13:49:52Z) — Class predicates, C-type fixes, runtime helpers, FFI surface elimination

- **What was attempted:** A multi-front improvement session targeting: (1) per-class return-type
  predicates in generated class wrappers; (2) C-function type-mapping correctness for Boolean,
  const char *, and CF record typedefs; (3) CFSTR macro constant emission; (4) five new runtime
  helper files; (5) FFI surface elimination across all four sample apps; (6) collection-layer
  `is_definition()` guards for struct and protocol declarations.

- **What worked:**
  - **Class-return predicates** — `collect_return_type_class_names` in `emit_class.rs` scans
    property/method return types for `TypeRefKind::Class` and emits inline `(define (nsview? v)
    (objc-instance-of? v "NSView"))` predicates ahead of `provide/contract`. `map_return_contract`
    now emits `nsview?` instead of `any/c` for typed class returns, tightening the contract
    surface. `objc-instance-of?` added to `objc-base.rkt` and its `provide` list.
  - **C-type mapping fixes** (`emit_functions.rs`, `ffi_type_mapping.rs`, `type_mapping.rs`):
    `Boolean` → `_bool`, `const char *` → `TypeRefKind::CString`/`_string`, CF record typedefs
    (CGRect etc. appearing as structs) → `TypeRefKind::Struct`/`ffi-obj-ref`. Non-const `char *`
    → `_pointer`. Nullable `_string` return contracts now correctly emit `(or/c string? #f)`.
    Foreign-thread safety warnings added to C callback (`FunctionPointer`) bindings.
  - **CFSTR macro constants** (`emit_constants.rs`) — `has_cfstr_constants` detects
    `macro_value`-carrying constants; generates `(define kFoo (_make-cfstr "literal"))` using
    the `_make-cfstr` helper, with `(or/c cpointer? #f)` contract.
  - **Runtime helpers** — `ax-helpers.rkt`, `cgevent-helpers.rkt`, `spi-helpers.rkt` landed
    alongside earlier `cf-bridge.rkt` and `nsview-helpers.rkt`. All added to `RUNTIME_FILES`
    and `LIBRARY_LOAD_CHECKS` in `runtime_load_test.rs`.
  - **FFI surface elimination** — all four sample apps (`hello-window`, `counter`,
    `ui-controls-gallery`, `file-lister`) purged of `ffi/unsafe` imports. Radio-button contract
    violation fixed: delegate sender args must flow through `wrap-objc-object` (not raw pointer)
    at `provide/contract` boundaries.
  - **Bug fix** — `cf-bridge.rkt` and `ax-helpers.rkt` were calling `(free buf)` on
    `(malloc …)` buffers that are GC-managed in Racket CS; `free` expects C-heap pointers and
    caused SIGABRT. All 9 `free` calls across the two files were removed.
  - **Collection guards** (`extract_declarations.rs`) — `is_definition()` check added for
    `ObjCProtocolDecl` (forward `@protocol Foo;` declarations now skipped) and `StructDecl`
    (opaque struct forward declarations skipped). `ObjCInterfaceDecl` intentionally ungarded.
  - Golden files across AppKit, Foundation, and TestKit updated to reflect predicate emission,
    contract tightening, and type-mapping corrections. 162 workspace tests pass; runtime load
    harness passes (`RUNTIME_LOAD_TEST=1`).

- **What didn't work / discoveries:**
  - The `free`-on-GC-memory SIGABRT was not caught by any test — it only surfaces at runtime
    when the malloc'd buffer is actually freed. Lesson: runtime helper files with C-interop
    patterns (malloc, free) need explicit ownership reasoning at write time.
  - `_NSEdgeInsets` alias was missing from `is_known_geometry_struct` — Mini Browser task
    remains blocked on WKWebView's `_NSEdgeInsets` binding.

- **What this suggests trying next:**
  - Note Editor sample app (`not_started`) — NSSplitView, NSTextView, WKWebView, NSSavePanel,
    NSUndoManager, NSNotificationCenter; exercises completion blocks and cross-framework rendering.
  - ObjC interop re-export from runtime module (`not_started`) — unblocks 9 Modaliser files
    from needing `ffi/unsafe` directly.
  - Raw AX attribute getter and CGEvent tap handler blockers remain open for Modaliser
    FFI elimination.

- **Key learnings:**
  - Return-type contracts on class wrappers are now class-specific (`nsview?`) rather than `any/c`,
    giving much better call-site blame when methods return wrong types.
  - Racket CS `(malloc …)` returns GC-tracked memory — never pass to `free`; use `(free (cast buf _racket _pointer))` only for C-heap allocations.
  - `is_definition()` on `ObjCProtocolDecl` is essential; forward `@protocol` declarations
    in SDK headers would otherwise shadow the real definition and produce empty protocol files.
