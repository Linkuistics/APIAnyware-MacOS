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
Class-return predicates landed (2026-04-16) — `objc-instance-of?` in `objc-base.rkt`,
per-class inline predicates (`nsview?` etc.) generated via `collect_return_type_class_names`.
`is_definition()` guards added to `StructDecl` and `ObjCProtocolDecl` (2026-04-16);
`ObjCInterfaceDecl` intentionally ungarded (declarations only in SDK headers). AX,
CGEvent, and SPI runtime helpers landed (2026-04-16): `ax-helpers.rkt`,
`cgevent-helpers.rkt`, `spi-helpers.rkt` — all in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.
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

#### Menu Bar Tool
- **Status:** not_started
- **Dependencies:** none; independent of File Lister (GUI smoke tracked separately)
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard. Tests
  an unusual app lifecycle (no main window, status item driven) and menu
  construction. GCD main-thread dispatch helpers in `main-thread.rkt` are already
  in place for timer callbacks.
  See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_

#### Text Editor
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

#### Mini Browser
- **Status:** not_started
- **Dependencies:** none. WebKit OO emission is verified (164 classes,
  29 protocols, 196 files load cleanly in Racket).
- **Description:** Cross-framework WebKit, WKNavigationDelegate, URL handling.
  Tests cross-framework imports (AppKit + WebKit) and delegate protocols from a
  non-Foundation framework.
  See `knowledge/apps/mini-browser/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Non-const `char *` params mapped to `_string` (should be `_pointer`) `[emitter, type-mapping]`
- **Status:** not_started
- **Priority:** 4 — runtime breakage for any function with writable buffer params
- **Dependencies:** none
- **Filed by:** Modaliser-Racket (2026-04-16)
- **Description:** The `const char *` → `_string` type mapping fix (2026-04-16)
  appears to also map non-const `char *` to `_string`. For output buffer parameters,
  `_string` is wrong — it auto-converts a Racket string to a temporary C `char*`
  on input, but the C function writes into the buffer and the written data is lost
  when the temporary is freed. Output buffers need `_pointer` so callers can pass
  `malloc`'d memory and read back results.
  
  **Concrete example:** `CFStringGetCString(theString, buffer, bufferSize, encoding)`
  — second param `char *buffer` is an output buffer. Generated:
  `(_fun _pointer _string _int64 _uint32 -> _bool)`. Should be:
  `(_fun _pointer _pointer _int64 _uint32 -> _bool)`.
  
  **Fix:** Only map `const char *` to `_string`; map non-const `char *` to `_pointer`.
  The const qualifier distinguishes input strings from output buffers at the C level.
  
  **Scope:** Likely affects many functions across frameworks — any function that
  takes a writable `char *` buffer (e.g., `CFStringGetCString`, `CFURLGetFileSystemRepresentation`,
  `AXValueGetValue`-style out-params). A grep for `_string` in parameter position
  combined with checking the C declaration's const qualification would identify all cases.
- **Results:** _pending_

### Nullable `_string` returns need `(or/c string? #f)` contract `[emitter, contracts]`
- **Status:** not_started
- **Priority:** 4 — runtime contract violation for any function returning nullable strings
- **Dependencies:** none
- **Filed by:** Modaliser-Racket (2026-04-16)
- **Description:** Functions returning `const char *` are mapped to `_string` return
  type. Racket's `_string` FFI type correctly converts NULL to `#f`, but the
  generated contract says `string?` (non-nullable), which rejects `#f` at the
  contract boundary before the caller can handle it.
  
  **Concrete example:** `CFStringGetCStringPtr(theString, encoding)` returns
  `const char *` which is NULL when the internal encoding doesn't match the
  requested one. Generated contract: `(c-> (or/c cpointer? #f) exact-nonnegative-integer? string?)`.
  Should be: `(c-> (or/c cpointer? #f) exact-nonnegative-integer? (or/c string? #f))`.
  
  At runtime:
  ```
  CFStringGetCStringPtr: broke its own contract
    promised: string?
    produced: #f
  ```
  
  **Fix:** When a C function's return type maps to `_string`, emit
  `(or/c string? #f)` in the contract (matching the FFI type's actual behavior).
  All `const char *` returns are potentially nullable in C.
  
  **Scope:** Affects `CFStringGetCStringPtr` and likely every function returning
  `const char *`. The general pattern: any FFI type that maps to a Racket type
  capable of producing `#f` (nullable pointers, `_string` for NULL) should have
  `#f` in the contract.
- **Results:** _pending_

### Emit foreign-thread safety warnings in generated C callback bindings `[emitter]`
- **Status:** not_started
- **Priority:** 3 — silent SIGILL (exit 132) on Racket CS, non-obvious cause
- **Dependencies:** none
- **Description:** Generated `functions.rkt` bindings that expose C callback
  parameters (function-pointer or block-typed args) should carry an inline Racket
  comment warning that `_cprocedure` callbacks SIGILL when invoked from a non-main
  GCD queue or libdispatch worker thread. The crash mode is SIGILL (exit 132) and
  `#:async-apply` converts it to a deadlock under `nsapplication-run` — both
  failure modes are non-obvious.
  
  **Fix:** In `emit_functions.rs`, detect parameters whose type maps to a function
  pointer or `_cprocedure` and emit a `; WARNING: callback must run on main OS thread
  — _cprocedure invoked from a foreign thread SIGILLs on Racket CS` comment above
  the `define` form. The CGEvent tap case is safe because it fires on
  `CFRunLoopGetMain` (main OS thread), not a GCD worker — distinguish this in the
  comment if the framework is CoreGraphics/CoreFoundation.
  
  **Note:** The Documentation task captures this for the developer guide; this task
  closes the gap at the generated-code level so consumers see the warning at point
  of use without consulting docs.
- **Results:** _pending_

### Future Work

#### Framework Coverage Deepening
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

#### Racket Class System Analysis
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

#### Developer Documentation
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
