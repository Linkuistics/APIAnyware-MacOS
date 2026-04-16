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
- **Status:** not_started
- **Surfaced:** 2026-04-16 (promoted from embedded blocker inside class predicates task).
- **Dependencies:** none.
- **Description:** Before implementing class-specific return predicates (`nsview?`,
 `nsstring?`, etc.), decide the predicate hosting model. Three options:
 (A) Runtime factory, inline per class file — simplest, duplicates predicate
   definitions across every class file that references a given class. Compile
   cost O(references).
 (B) Central generated barrel (`runtime/class-predicates.rkt` or emitter-generated
   under `generated/`) — cleanest consumer side, but adds a compilation
   bottleneck (every class file requires it).
 (C) Per-class-file predicate with cross-class requires — mirrors IR semantics,
   but introduces new dependency edges between class wrappers (currently none),
   with load-order implications.
 Evaluate each option against: compilation time impact, dependency graph
 complexity, golden file churn, and maintainability. Record the decision in a
 memory entry. The class predicates implementation task cannot start until this
 decision is made.
- **Results:** _pending_
- **Status:** not_started
- **Dependencies:** none (`_id` nullable tightening is complete; scope
 notes confirm different golden cells, so no amortisation benefit from
 sequencing). Predicate hosting model decision (task above) must be
 recorded before coding starts.
- **Promoted from:** residual sub-item 3 of the retired
 "Tighten per-class method wrapper contracts" task.
- **Description:** Generate `nsview?`, `nsstring?`, etc. predicates
 from the class files themselves and expose them as runtime type-test
 primitives. Use them in contract positions where the IR knows the
 declared type **and** where ergonomic coercion isn't needed (i.e.
 returns and non-coerced params). Consumers gain a runtime predicate
 they currently lack. Marked stretch because the ergonomics win is
 real but narrow.
- **Scope notes (2026-04-15):**
 - **"Non-coerced params" is empty.** Every object param flows through
  `coerce-arg`, so this task only affects `map_return_contract` +
  return positions. Different golden cells from the `_id` task, no overlap.
 - **Runtime has zero class introspection.** A real `nsview?` predicate needs
  a new runtime primitive (probably `objc-instance-of?` backed by
  `class_isKindOfClass:` via `objc_msgSend`, so subclass instances
  satisfy the parent predicate). This is new code with its own test surface.
 - **`map_return_contract` update:** class-aware branch for
  `TypeRefKind::Class { name }` (emit the class-specific predicate),
  `objc-object?` fallback for `Id`/`Instancetype`.
 - **Harness coverage:** needs a new runtime-load check that verifies the
  predicate passes — existing load-only checks cannot observe a contract
  mismatch that only fires at return time.
 - **Golden churn scale:** every class wrapper with an object return (most
  of them).
- **Results:** _pending_
### `is_definition()` Guard Audit in Extractors
- **Status:** not_started
- **Surfaced:** 2026-04-16 (latent bug exposed when the unsigned-enum fix added
 an `is_definition()` guard for `EnumDecl`).
- **Dependencies:** none.
- **Description:** The `seen_enums` HashSet dedup guard in `extract_declarations.rs`
 checks by name only. For `CF_ENUM`/`NS_ENUM`-generated cursors, libclang emits
 both a forward `EnumDecl` (no values) and a defining `EnumDecl` (with values);
 if the forward decl is visited first it wins and the definition is skipped.
 The `is_definition()` guard added for `EnumDecl` closes this for enums. The
 same latent bug exists in the `StructDecl`, `ObjCInterfaceDecl`, and
 `ObjCProtocolDecl` arms — any of these can shadow a full definition with a
 forward declaration. Audit all three arms and add `entity.is_definition()`
 guards where missing. Verify with the runtime load harness — a shadowed class
 or struct definition would surface as a load error or missing binding.
- **Results:** _pending_
### Accessibility / CGEvent / Private SPI Runtime Helpers
- **Status:** in_progress
- **Surfaced:** 2026-04-16 (Modaliser-Racket FFI elimination goal — zero `ffi/unsafe`
 requires in app code, matching the FFI-free standard achieved by sample apps).
- **Dependencies:** Pipeline re-run complete (2026-04-16). CF bridge landed
 (`cf-bridge.rkt`). GCD helpers exist (`main-thread.rkt`). NSView geometry
 helpers landed (`nsview-helpers.rkt`). Remaining items below are independent
 of each other and of all open tasks.
- **Description:** Three remaining helper categories to eliminate all `ffi/unsafe`
 requires from Modaliser-Racket:

 **AX typed-attribute helpers** — typed attribute access returning Racket values
 directly, handling `CFRelease` internally (no `malloc`, `ptr-ref`, `AXValue`
 construction in caller):
 - `ax-get-attribute/string`, `ax-get-attribute/boolean`,
   `ax-get-attribute/point`, `ax-get-attribute/size`
 - `ax-set-position!`, `ax-set-size!` — take Racket numbers, handle AXValue
   creation/release internally (no `malloc`, `ptr-set!`, `ctype-sizeof`).
 - `ax-get-pid` — direct integer return, no out-parameter.

 **CGEvent tap helper** — `make-cgevent-tap`: takes a Racket callback
 `(keycode modifiers key-down? → 'suppress/'pass-through)`, handles
 `_cprocedure`, `function-ptr`, GC stability, `CGEventTapCreate`,
 `CFRunLoopAddSource` internally. Note: the CGEvent callback fires on the main
 OS thread via `CFRunLoopGetMain`, not a foreign thread — `_cprocedure` is safe
 here without `#:async-apply`.

 **Private SPI** — `_AXUIElementGetWindow`: absent from public headers and will
 never be auto-generated. Hand-written runtime helper with `get-ffi-obj` +
 fallback so consumers avoid carrying their own raw FFI boilerplate.

 Success criterion: Modaliser-Racket can remove all remaining `(require ffi/unsafe ...)`
 lines from every `.rkt` file.
- **Results:** Partial 2026-04-16. `cf-bridge.rkt` landed — CFString, CFNumber,
 CFBoolean, CFArray, CFDictionary conversions plus `with-cf-value` auto-release.
 `nsview-helpers.rkt` landed — NSView geometry helpers. `main-thread.rkt` covers
 GCD dispatch. All added to `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`; load cleanly.
 Remaining: AX typed-attribute helpers, `make-cgevent-tap`, `_AXUIElementGetWindow` SPI.
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
- **Dependencies:** none (independent binding style)
- **Description:** Emit Typed Racket (`#lang typed/racket`) versions of the
 generated bindings that provide static type checking at compile time. This
 involves: mapping TypeRef kinds to Typed Racket types (primitives → `Integer`,
 `Flonum`, etc.; ObjC objects → `(Instance ClassName)` or opaque types; enums →
 union types or `Symbol`), wrapping `ffi/unsafe` calls using `require/typed` at
 module boundaries, and handling the `_id` ↔ typed object boundary carefully
 (ObjC's dynamic dispatch means some casts are unavoidable). This is a separate
 binding style from OO/functional — consumers `require` the typed modules and
 get compile-time checking. Investigate whether the typed layer should wrap the
 untyped OO bindings (via `require/typed`) or emit standalone typed modules.
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
