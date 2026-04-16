### Session 20 (2026-04-16T10:36:33Z) — Class predicates, FFI surface elimination, AX/CGEvent/SPI runtime helpers

- **Attempted:** Multiple tasks from the triage plan: class-specific return predicates (Option A),
  `is_definition()` guard audit in extractors, C-function type mapping fixes, CFSTR constant
  emission, Accessibility/CGEvent/SPI runtime helpers, and full FFI surface elimination across
  all 4 sample apps. Also runtime additions and contract cleanup.

- **What worked:**
  - **Class-specific return predicates** (`emit_class.rs` +312/-21): `collect_return_type_class_names`
    scans properties and methods for `TypeRefKind::Class`-typed returns; `emit_class_predicates`
    emits `(define (<class>? v) (objc-instance-of? v "ClassName"))` before `provide/contract`.
    `map_return_contract` gains a `TypeRefKind::Class` branch using the class predicate instead
    of `any/c`. `objc-instance-of?` primitive added to `runtime/objc-base.rkt` (backed by
    `isKindOfClass:` via `tell`, with `objc_getClass` caching). 38 golden files updated.
  - **`is_definition()` guard audit** (`extract_declarations.rs` +107/-12): Guards added to
    `StructDecl` and `ObjCProtocolDecl`. `ObjCInterfaceDecl` intentionally left without the
    guard — in Clang's AST, `@interface` is a declaration not a definition, so `is_definition()`
    returns `false` for all `ObjCInterfaceDecl` cursors in SDK headers.
  - **C-function type mapping fixes** (`ffi_type_mapping.rs` +66/-16): `Boolean` → `_bool`,
    `const char *` → `TypeRefKind::CString` / `_string`, `AXValueType`-style aliases via
    `is_generic_type_param`, CF record typedefs → `TypeRefKind::Struct` / `ffi-obj-ref`.
  - **CFSTR constants** (`emit_constants.rs` +137/-3): `has_cfstr_constants` detects
    `macro_value`-bearing constants; these emit `(define kFoo (_make-cfstr "literal"))` with
    `(or/c cpointer? #f)` contracts.
  - **Accessibility/CGEvent/SPI helpers**: `ax-helpers.rkt` (typed AX attribute access,
    malloc/free/CFRelease internal), `cgevent-helpers.rkt` (CGEventTapCreate + CFRunLoop,
    module-level fptr for GC stability, fires on main OS thread so `_cprocedure` is safe),
    `spi-helpers.rkt` (`_AXUIElementGetWindow` with graceful `#f` fallback). All added to
    runtime harness load checks.
  - **FFI surface elimination**: all 4 sample apps (`hello-window`, `counter`, `ui-controls-gallery`,
    `file-lister`) carry zero `ffi/unsafe` imports. Radio-button contract violation fixed —
    `wrap-objc-object` is correct for delegate sender args through `provide/contract` boundaries.
    Runtime additions: `borrow-objc-object`, `objc-autorelease`, `->string`. `make-delegate`
    returns `borrow-objc-object`. SEL-typed property setters wrap value with `sel_registerName`.
    Type-aware delegates (`#:param-types`), SEL-as-string and `cpointer?` contracts dropped.
  - **Full pipeline re-run**: 284 frameworks, all 162 workspace tests pass, runtime load
    harness passes (20 library checks + 4 app `raco make` checks).

- **What didn't work / gaps:** No failures recorded. All tasks reached "done" status.

- **What this suggests trying next:** The backlog now shows only sample apps (NSStatusBar
  menu-bar-tool, text-editor, mini-browser) and future-work items (cross-framework tests,
  idiomatic Racket OO audit, documentation). Next session should start one of the remaining
  sample apps — menu-bar-tool is the most self-contained (no new delegate patterns needed).

- **Key learnings:**
  - `ObjCInterfaceDecl.is_definition()` always returns `false` in SDK headers (Clang AST
    defines `@implementation` as the definition, not `@interface`); guarding on it would
    drop all ObjC class declarations.
  - Delegate sender args crossing `provide/contract` boundaries must use `wrap-objc-object`
    not raw pointer passing — Racket's contract system wraps the object on entry.
  - `_cprocedure` callbacks from `CGEventTapCreate` are safe without `#:async-apply`
    because the tap fires on `CFRunLoopGetMain` (already the main OS thread).
