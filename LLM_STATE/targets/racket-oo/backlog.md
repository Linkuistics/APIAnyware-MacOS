# Target: racket-oo
Racket OO-style bindings for macOS APIs using the `tell` macro and class wrappers.
Foundation complete (382 files generated), AppKit snapshot golden files in place (23
files), WebKit OO emission verified (164 classes, 29 protocols, 196 files). Runtime
hardened (block nil handling, GCD main-thread dispatch). C-API function emission done
(86 frameworks with contract-protected `functions.rkt`). Contracts cover every FFI
boundary — functions, constants, class wrappers, and protocol files. Tell-dispatch
FFI return types now match the IR — void methods and `_id`-typed property setters
emit `(tell #:type _void ...)` directly, closing the calling-convention gap that
neither snapshot tests nor the runtime load harness can observe. **Runtime load
verification harness** (`generation/crates/emit-racket-oo/tests/runtime_load_test.rs`):
16 library `dynamic-require` checks, 10 required frameworks, plus `raco make` of
all 4 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~48s end-to-end). Class-property
setter arity bug fixed (2026-04-15) — setters now omit self for class properties.
`_id` parameter contracts tightened with nullable marking (2026-04-15) — non-nullable
params get 3-element union, nullable get 4-element with `#f`, matching `coerce-arg`'s
accepted set exactly. Self-parameter contracts tightened to `objc-object?` in every
class wrapper. Delegate return kinds `'int` and `'long` landed (2026-04-15) — covers
`Int32`/`Int64` trampolines in Swift and matching Racket FFI dispatch; `'long` is the
correct kind for NSInteger-returning delegate methods on 64-bit Apple platforms.
Unsigned enum extraction fixed (2026-04-15) — `extract_declarations.rs` now
canonicalises underlying type before checking signedness; unsigned-backed enums use
the `.1` component of `get_enum_constant_value()`. Modaliser gaps closed in one
session: (1) CG enum empty stubs fixed, CoreGraphics `enums.rkt` 8→446 defines,
Foundation 212→1129; (2) ApplicationServices umbrella now extracts HIServices AX
functions via a narrow subframework-allowlist, 0→384 functions; (3) libdispatch/pthread
plumbed through via a synthetic pseudo-framework pattern; 218 functions, 17 constants.
`runtime/dynamic-class.rkt` landed (2026-04-15) — curated libobjc subclass surface
(`make-dynamic-subclass`, `add-method!`, type aliases `_Class`/`_SEL`/`_Method`/`_IMP`),
idempotent on duplicate names, hooked into the runtime load harness. File Lister app
landed 2026-04-15. Radio-button contract violation fixed (2026-04-16) —
`wrap-objc-object` is the correct pattern for delegate sender args flowing through
`provide/contract` boundaries. FFI Surface Elimination complete (2026-04-16) across
three phases: type-aware delegates (`#:param-types`), contract cleanup (SEL-as-string,
`cpointer?` dropped), and app rewrites. All 4 sample apps (`hello-window`, `counter`,
`ui-controls-gallery`, `file-lister`) carry zero `ffi/unsafe` imports and are
VM-validated via GUIVisionVMDriver. Runtime additions: `borrow-objc-object`,
`objc-autorelease`, `->string`. Object param contracts always include `#f` (nil
messaging is always a no-op). `make-delegate` returns `borrow-objc-object`.
SEL-typed property setters wrap value with `sel_registerName`.
C-function type mapping fixes landed (2026-04-16): `Boolean` → `_bool`, `const char *`
→ `TypeRefKind::CString` / `_string`, `AXValueType`-style aliases via
`is_generic_type_param`, CF record typedefs → `TypeRefKind::Struct` / `ffi-obj-ref`.
Full pipeline re-run 2026-04-16 (284 frameworks, all 162 workspace tests pass,
runtime load harness passes). CFSTR macro constants emitted via `_make-cfstr` helper
(2026-04-16) — `kAXWindowsAttribute` and all HIServices CFSTR constants now enter
the IR from `MacroDefinition` extraction and emit `(define kFoo (_make-cfstr "literal"))`.
`cf-bridge.rkt` landed (2026-04-16) — CFString/CFNumber/CFBoolean/CFArray/CFDictionary
conversions plus `with-cf-value` auto-release. `nsview-helpers.rkt` landed (2026-04-16)
— NSView geometry helpers. Both in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.
```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```
## Task Backlog
### Sample Apps
- **Status:** not_started
- **Dependencies:** none; independent of File Lister (GUI smoke tracked separately)
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard. Tests
 an unusual app lifecycle (no main window, status item driven) and menu
 construction. GCD main-thread dispatch helpers in `main-thread.rkt` are already
 in place for timer callbacks.
 See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_
- **Status:** not_started
- **Dependencies:** File Lister complete — **satisfied 2026-04-15**.
 Delegate-pattern shakedown is in the books (data-source delegate for
 NSTableView landed and compiles clean in the harness).
- **Description:** Block callbacks, error-out, undo/redo, notifications, find.
 Tests complex callback patterns and NSUndoManager integration — the most
 demanding OO interaction patterns. Runtime block nil handling (`make-objc-block`
 returning `(values #f #f)` for `#f` proc) is now in place.
 See `knowledge/apps/text-editor/spec.md` and `test-strategy.md`.
- **Results:** _pending_
- **Status:** not_started
- **Dependencies:** none. WebKit OO emission is verified (164 classes,
 29 protocols, 196 files load cleanly in Racket).
- **Description:** Cross-framework WebKit, WKNavigationDelegate, URL handling.
 Tests cross-framework imports (AppKit + WebKit) and delegate protocols from a
 non-Foundation framework.
 See `knowledge/apps/mini-browser/spec.md` and `test-strategy.md`.
- **Results:** _pending_
### Contract Tightening (Stretch)
- **Status:** done
- **Surfaced:** 2026-04-16 (promoted from embedded blocker inside class predicates task).
- **Dependencies:** none.
- **Description:** Decide predicate hosting model for class-specific return predicates.
- **Results:** Complete 2026-04-16. **Option A chosen** (runtime factory, inline per
 class file). Rationale: scope notes confirm predicates only affect return positions
 (all params flow through `coerce-arg`), so duplication is bounded. Option C
 eliminated by circular dependency risk (NSString methods return NSString). Option B
 adds compilation bottleneck disproportionate to narrow scope. Implementation plan:
 `objc-instance-of?` primitive in `runtime/objc-base.rkt` (backed by
 `class_isKindOfClass:` via libobjc); each class file defines its own predicate as
 `(define (nsview? v) (objc-instance-of? v "NSView"))` — one-liner, no new requires,
 no dependency edges. `map_return_contract` gains a `TypeRefKind::Class { name }`
 branch emitting the class predicate instead of `any/c`. Decision recorded in memory.
- **Status:** done
- **Dependencies:** Predicate hosting model decision — satisfied (Option A chosen).
- **Promoted from:** residual sub-item 3 of the retired
 "Tighten per-class method wrapper contracts" task.
- **Description:** Generate class-specific return predicates (`nsview?`, `nsstring?`,
 etc.) and use them in return contracts where the IR declares a class type.
- **Results:** Complete 2026-04-16. Implementation:
 (1) `objc-instance-of?` primitive added to `runtime/objc-base.rkt` — backed by
 `isKindOfClass:` via `tell`, with class-object caching via `objc_getClass` for
 repeat lookups. Handles `objc-object?`, `cpointer?`, `#f`, and `objc-null` inputs.
 (2) `map_return_contract` in `emit_class.rs` gains a `TypeRefKind::Class { name }`
 branch emitting `<classname>?` predicate. `Id`/`Instancetype` keep `any/c`.
 (3) `collect_return_type_class_names` scans properties and methods for class-typed
 returns; `emit_class_predicates` emits `(define (<class>? v) (objc-instance-of? v "ClassName"))`
 before `provide/contract` (Racket requires definitions before contract references).
 38 golden files updated. All 162 workspace tests pass, runtime load harness green
 (20 library checks + 4 app `raco make` checks).
### `is_definition()` Guard Audit in Extractors
- **Status:** done
- **Surfaced:** 2026-04-16 (latent bug exposed when the unsigned-enum fix added
 an `is_definition()` guard for `EnumDecl`).
- **Dependencies:** none.
- **Description:** Audit `StructDecl`, `ObjCInterfaceDecl`, and `ObjCProtocolDecl`
 arms for missing `is_definition()` guards matching the `EnumDecl` fix.
- **Results:** Complete 2026-04-16. Guards added to `StructDecl` and
 `ObjCProtocolDecl`. `ObjCInterfaceDecl` intentionally left WITHOUT the guard:
 in Clang's AST, `@interface` is a declaration (not a definition — `@implementation`
 is the definition, but `.m` files are absent from SDK headers), so
 `is_definition()` returns `false` for all `ObjCInterfaceDecl` cursors in
 framework headers. Forward `@class` declarations produce `ObjCClassRef` cursors
 not `ObjCInterfaceDecl`, so no forward-decl shadowing is possible for this
 entity kind. All 67 extract-objc tests and 117 emit-racket-oo tests pass.
 Memory entry updated to reflect the Clang AST nuance.
### Accessibility / CGEvent / Private SPI Runtime Helpers
- **Status:** done
- **Surfaced:** 2026-04-16 (Modaliser-Racket FFI elimination goal — zero `ffi/unsafe`
 requires in app code, matching the FFI-free standard achieved by sample apps).
- **Dependencies:** Pipeline re-run complete (2026-04-16). CF bridge landed
 (`cf-bridge.rkt`). GCD helpers exist (`main-thread.rkt`). NSView geometry
 helpers landed (`nsview-helpers.rkt`).
- **Description:** Three helper categories to eliminate all `ffi/unsafe`
 requires from Modaliser-Racket: AX typed-attribute helpers, CGEvent tap,
 private SPI.
- **Results:** Complete 2026-04-16. Three new runtime files landed:
 `ax-helpers.rkt` — typed AX attribute access (`ax-get-attribute/string`,
 `/boolean`, `/point`, `/size`), setters (`ax-set-position!`, `ax-set-size!`),
 and `ax-get-pid`. All handle malloc/free/CFRelease internally.
 `cgevent-helpers.rkt` — `make-cgevent-tap` wrapping CGEventTapCreate +
 CFRunLoop integration with keyboard event mask; `cgevent-tap-enable!` for
 toggle. Module-level function-ptr for GC stability; callback fires on main
 OS thread (safe without `#:async-apply`).
 `spi-helpers.rkt` — `ax-element-get-window` wrapping private
 `_AXUIElementGetWindow` SPI with graceful `#f` fallback if symbol absent.
 All three added to `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS` in the runtime
 load harness; all load cleanly. Combined with prior `cf-bridge.rkt`,
 `nsview-helpers.rkt`, and `main-thread.rkt`, Modaliser-Racket can now
 remove all `(require ffi/unsafe ...)` lines from app code.
### Future Work
- **Status:** not_started
- **Dependencies:** at least 2 more sample apps complete (scope clarifies with
 real usage)
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
 what sample apps cover. Scope TBD — may be better defined after app experience
 reveals which frameworks have surprising emitter edge cases. Note: the runtime
 load harness already exercises CoreGraphics `functions.rkt` at a shallow level,
 so this task's focus should be deeper per-framework API exercises (construct
 values, call functions, check results) rather than mere load checks.
- **Results:** _pending_
- **Status:** not_started
- **Dependencies:** all 4 remaining apps complete (real usage reveals which
 patterns matter)
- **Description:** Analyse the current racket-oo emitter output and runtime to
 determine whether it truly models macOS APIs using Racket's class system
 (`racket/class`) as much as possible — e.g., using `class*`, `define/public`,
 `inherit`, `super-new`, interfaces for protocols, mixins for categories.
 Identify where the current approach falls short of idiomatic Racket OO and
 propose concrete changes to make better use of the class system.
- **Results:** _pending_
- **Status:** not_started
- **Dependencies:** none
- **Description:** Record Racket-specific documentation requirements: `tell`
 macro usage, `import-class` patterns, what's surprising for Racket developers,
 paradigm-appropriate examples for both OO and functional styles. Must include
 threading/callback safety constraints discovered by Modaliser-Racket:
 `_cprocedure` callbacks SIGILL from foreign OS threads (GCD workers,
 libdispatch), `#:async-apply` deadlocks under `nsapplication-run`, safe
 alternatives (`call-on-main-thread`, `dynamic-place` for I/O), and the
 place-backed async facade pattern for Cocoa integration. Any generated binding
 exposing a C callback type should carry a warning about the foreign-thread
 constraint.
- **Results:** _pending_
