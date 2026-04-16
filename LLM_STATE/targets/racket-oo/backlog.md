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
15 library `dynamic-require` checks, 10 required frameworks, plus `raco make` of
all 4 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~47s end-to-end). Class-property
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

### Bug Fixes and Cleanup

- **Status:** not_started
- **Surfaced:** 2026-04-16 (confirmed via Modaliser-Racket real-world usage).
- **Dependencies:** none.
- **Description:** `nsscreen.rkt` has a duplicate symbol definition that causes a
  load error — any file that `require`s NSScreen fails immediately. Current
  workaround in Modaliser-Racket: use raw `tell` instead of the generated wrapper.
  Fix: locate the duplicate in the emitter (likely a property getter/setter or
  category method emitted twice for NSScreen) and deduplicate in `emit_class.rs`.
  Verify with the runtime load harness by adding NSScreen to `LIBRARY_LOAD_CHECKS`.
- **Results:** _pending_

- **Status:** not_started
- **Surfaced:** 2026-04-16 (confirmed via Modaliser-Racket real-world usage).
- **Dependencies:** none.
- **Description:** The generated `nsmenuitem.rkt` binding treats `+separatorItem`
  (a class method) as an instance property rather than a class method, making the
  emitted `nsmenuitem-separator-item` binding unusable. Workaround: call
  `(tell NSMenuItem separatorItem)` directly. Fix: ensure the IR correctly marks
  `separatorItem` as a class method (not an instance property), and that
  `emit_class.rs` emits it under the class method path. Add a snapshot assertion
  confirming the emitted form is a class-method wrapper, not a property getter.
- **Results:** _pending_

- **Status:** not_started
- **Surfaced:** 2026-04-16 (confirmed via Modaliser-Racket Mini Browser work).
- **Dependencies:** none.
- **Description:** The generated `wkwebview.rkt` does not expose
  `setAutoresizingMask:`, which is inherited from NSView. The generated bindings
  only emit methods declared directly on the class, not inherited ones. Workaround:
  call `objc_msgSend` directly. **Chosen approach: option (b)** — expose a generic
  `set-autoresizing-mask!` helper in the runtime (probably `runtime/nsview-helpers.rkt`)
  that works on any NSView subclass via `tell`. Lower risk than option (a)
  (emitting inherited NSView methods into every subclass wrapper at generation
  time) and avoids golden file churn across all NSView subclass wrappers.
  Update harness coverage to verify the new helper loads and calls correctly.
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

### Non-Linkable Symbol Leak Class A: Bare `c:@<name>` Macros

- **Status:** not_started
- **Surfaced:** 2026-04-16 (documented as open leak class; canary identified via
  extractor filter audit).
- **Dependencies:** none.
- **Description:** libclang sometimes exposes preprocessor macros through naked
  `c:@<name>` USRs (without `@macro@`). Neither extractor catches these; they
  pass `non_c_linkable_skip_reason` and emit `get-ffi-obj` calls that fail at
  `dlsym` time. Canary: `kAudioServicesDetailIntendedSpatialExperience`
  (AudioToolbox, `AudioServices.h:401`, ObjC source). Fix: (a) add a skip-reason
  branch in `non_c_linkable_skip_reason` for bare `c:@<name>` patterns confirmed
  as macros (absent from dylib, present in preprocessor macro table); (b) add
  AudioToolbox to `LIBRARY_LOAD_CHECKS` in the runtime harness as the validation
  canary. Coverage extension is reflexive — see "Standing rule" in the runtime
  load harness memory entry.
- **Results:** _pending_

### Non-Linkable Symbol Leak Class B: Anonymous Enum Members (`c:@Ea@...`)

- **Status:** not_started
- **Surfaced:** 2026-04-16 (documented as open leak class; canary identified via
  extractor filter audit).
- **Dependencies:** none.
- **Description:** Clang's `Ea` USR prefix marks anonymous-enum members (e.g.
  `c:@Ea@nw_browse_result_change_identical`). These are extracted as constants
  and emit `get-ffi-obj` calls that fail at `dlsym` time since anonymous-enum
  members have no linkable symbol. Canary: `nw_browse_result_change_identical`
  (Network framework, Swift source). Fix: (a) add a skip-reason branch in
  `non_c_linkable_skip_reason` matching USRs beginning with `c:@Ea@`, tagged as
  `anonymous_enum_member`; (b) add Network to `LIBRARY_LOAD_CHECKS` in the
  runtime harness as the validation canary.
- **Results:** _pending_

### C-Function Type Mapping Fixes (Modaliser-Racket FFI Elimination)

- **Status:** not_started
- **Surfaced:** 2026-04-16 (Modaliser-Racket accessibility/permissions/main-thread
  migration exposed these; 7 functions kept as local hand-written definitions due
  to type mismatches with generated signatures).
- **Dependencies:** none.
- **Description:** Four classes of type-mapping issue prevent Modaliser-Racket from
  using generated C-function bindings for all functions:

  1. **`_uint8` where `_bool` is needed.** C functions returning `Boolean` (unsigned
     char) are emitted with `_uint8` return type. In Racket, `0` is truthy (only `#f`
     is falsy), so `_uint8` silently breaks any boolean-context usage. Affected:
     `CFBooleanGetValue`, `CFStringGetCString`, `CFNumberGetValue`, `AXValueGetValue`,
     `AXIsProcessTrusted`, `AXIsProcessTrustedWithOptions`. Fix: detect `Boolean`,
     `bool`, `_Bool`, `unsigned char` (when used as boolean) return types in the IR
     and emit `_bool` instead of `_uint8`.

  2. **`_pointer` where `_string` is needed.** `const char *` parameters that receive
     C string arguments are emitted as `_pointer`. Racket's `_string` auto-converts
     Racket strings to C strings; `_pointer` does not, requiring manual marshalling.
     Affected: `CFStringCreateWithCString` (2nd param). Fix: detect `const char *`
     (or `char *`) params in the IR and emit `_string`. The contract should be
     `string?`.

  3. **`_id` for non-ObjC enum typedef params.** Some integer enum types
     (`AXValueType`) are typedef'd through ObjC-compatible paths, causing the emitter
     to treat them as `_id` (ObjC object). Plain integers are rejected at runtime.
     Affected: `AXValueCreate` (1st param), `AXValueGetValue` (2nd param). Fix:
     recognise that `AXValueType` is a C enum (underlying type `uint32_t`) and emit
     `_uint32`, not `_id`.

  4. **`ffi-obj-ref` not applied to CoreFoundation struct-typed globals.** The
     `ffi-obj-ref` fix for struct-typed data symbols landed for libdispatch
     (2026-04-16) but `kCFTypeDictionaryKeyCallBacks` and
     `kCFTypeDictionaryValueCallBacks` in `corefoundation/constants.rkt` still use
     `get-ffi-obj ... _uint64`, reading struct bytes instead of the symbol address.
     These are `CFDictionaryKeyCallBacks`/`CFDictionaryValueCallBacks` structs.
     Fix: apply the same struct-vs-pointer detection to CoreFoundation globals.

  Verification: Modaliser-Racket should be able to replace all 7 locally-retained
  `get-ffi-obj` definitions in `ffi/accessibility.rkt` and the 2 local constants
  in `ffi/permissions.rkt` with `only-in` imports from generated bindings.
- **Results:** _pending_

### CFSTR Macro Constant Emission

- **Status:** not_started
- **Surfaced:** 2026-04-16 (Modaliser-Racket accessibility migration).
- **Dependencies:** none.
- **Description:** macOS SDK headers define many important constants as
  `CFSTR("...")` macros (e.g., `kAXWindowsAttribute`, `kAXFocusedWindowAttribute`,
  `kAXMainAttribute`, `kAXPositionAttribute`, `kAXSizeAttribute`,
  `kAXTitleAttribute`, `kAXSubroleAttribute`, `kAXMinimizedAttribute`,
  `kAXFocusedAttribute`, `kAXFullScreenAttribute`, `kAXRaiseAction`).
  These are not exported symbols — there is nothing to link against. Modaliser
  currently creates them at runtime via `CFStringCreateWithCString` and
  pre-allocates at module load.

  The generator should emit these as pre-built `CFString` constants in the
  relevant `constants.rkt` file. The emitter would need to:
  1. Recognise `#define kFoo CFSTR("Bar")` patterns in preprocessor output or
     the IR's macro/constant layer.
  2. Emit `(define kFoo (CFStringCreateWithCString #f "Bar" kCFStringEncodingUTF8))`
     in the constants file, with appropriate requires for the CF function.
  3. Export via `provide/contract` with `(or/c cpointer? #f)`.

  This eliminates the last category of hand-written constant definitions in
  Modaliser's FFI layer. 12 constants in `ffi/accessibility.rkt` would be replaced
  by generated imports.
- **Results:** _pending_

### CoreFoundation / Accessibility / GCD Runtime Helpers

- **Status:** not_started
- **Surfaced:** 2026-04-16 (Modaliser-Racket FFI elimination goal — the user wants
  zero `ffi/unsafe` requires in app code, matching the FFI-free standard achieved
  by sample apps in Phase 3 of FFI Surface Elimination).
- **Dependencies:** C-function type mapping fixes (above) should land first so the
  generated functions are usable; but helpers can also wrap current signatures.
- **Description:** The FFI Surface Elimination (Phase 1-3) achieved zero `ffi/unsafe`
  imports for sample apps using AppKit/WebKit. Modaliser-Racket uses lower-level C
  APIs (CoreFoundation, Accessibility, CGEvent, GCD) that still require raw FFI
  operations: `malloc`, `ptr-ref`, `ptr-set!`, `cast`, `_cprocedure`, `function-ptr`,
  `ctype-sizeof`, CF memory management. The runtime should provide high-level helpers
  so that real-world apps using these APIs also need zero FFI imports.

  **CF type bridge** (runtime helpers, probably `runtime/cf-bridge.rkt`):
  - `racket-string->cfstring` / `cfstring->racket-string` — create/extract without
    exposing `CFStringCreateWithCString`, `CFStringGetCStringPtr`, encoding constants,
    `malloc`, `cast`, or `CFRelease`.
  - `cfnumber->integer` / `cfnumber->real` — extract CF numbers to Racket values
    without `malloc`, `ptr-ref`, type constants.
  - `cfboolean->boolean` — extract to `#t`/`#f` without the `_uint8` hazard.
  - `cfarray->list` — iterate with auto-retain, release array, return Racket list.
    Optional element-converter parameter.
  - `make-cfdictionary` — build from Racket key-value pairs without `malloc`,
    `ptr-set!`, callback-struct constants, `CFRelease`.
  - Auto-release wrappers or `with-cf-value` form for Create/Copy-rule objects.

  **AX high-level API** (runtime helpers, probably `runtime/ax-helpers.rkt`):
  - `ax-get-attribute/string`, `ax-get-attribute/boolean`,
    `ax-get-attribute/point`, `ax-get-attribute/size` — typed attribute access
    that returns Racket values directly and handles CFRelease internally.
  - `ax-set-position!`, `ax-set-size!` — take Racket numbers, handle AXValue
    creation/release internally (no `malloc`, `ptr-set!`, `ctype-sizeof`).
  - `ax-get-pid` — direct integer return, no out-parameter.

  **GCD dispatch** (runtime helpers, probably `runtime/gcd.rkt`):
  - `call-on-main-thread` / `call-on-main-thread-after` — thunk-based GCD
    dispatch with internal thunk registry, `_cprocedure` callback, and
    `function-ptr` GC management. App code just passes a lambda.
  - `on-main-thread?` — wraps `pthread_main_np`.
  - This is essentially what `ffi/main-thread.rkt` does today, but as a
    reusable runtime module.

  **CGEvent tap** (runtime helper):
  - `make-cgevent-tap` — takes a Racket callback `(keycode modifiers key-down? → 'suppress/'pass-through)`,
    handles `_cprocedure`, `function-ptr`, GC stability, `CGEventTapCreate`,
    `CFRunLoopAddSource` internally. App code never touches raw callback machinery.

  **Private SPI**:
  - `_AXUIElementGetWindow` — private API, never in public headers, will never
    be auto-generated. Should be a hand-written runtime helper rather than
    requiring consumer apps to maintain their own `get-ffi-obj` with fallback.

  Success criteria: Modaliser-Racket can remove all `(require ffi/unsafe ...)` lines
  from every `.rkt` file, achieving the same FFI-free standard as the sample apps.
- **Results:** _pending_

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
