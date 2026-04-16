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
landed 2026-04-15 (compiles clean under `raco make` in both direct and hermetic harness
trees; full GUI smoke tracked separately). Radio-button contract violation fixed
(2026-04-16) — `wrap-objc-object` is the correct pattern for delegate sender args
flowing through `provide/contract` boundaries; bare `(cast sender _pointer _id)` is
insufficient when an `objc-object?` contract guards the call site. Block nil guard
verified complete (2026-04-16) — guard was already in place and test-covered; Modaliser
report was against a pre-guard checkout. File Lister
`numberOfRowsInTableView:` migrated to `'long` (2026-04-16) — pointer-smuggle
workaround removed, clean return through Int64 trampoline. Struct-data-symbol
emitter fix landed (2026-04-16) — `ffi-obj-ref` for struct-typed globals,
`get-ffi-obj` for pointer-typed; 15 libdispatch globals corrected. libdispatch
`_id`→`_pointer` override landed (2026-04-16) — OS-object dispatch types emitted
as `_pointer` in `functions.rkt` since no wrapper classes exist; consumers pass
raw cpointers without cast ceremony. Next focus: FFI surface elimination —
make the generated API fully opaque to app authors (no `cast`, no `cpointer?`,
no `sel_registerName`, no `ffi/unsafe` requires in app code), then sample apps
(Menu Bar Tool → Text Editor → Mini Browser).
```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```
## Task Backlog

### FFI Surface Elimination

- **Status:** done
- **Surfaced:** 2026-04-16 (derived from research above).
- **Dependencies:** none (self-contained across runtime + emitter).
- **Description:** Implement the 3-phase solution architecture from the
  research above. Phase 1 (type-aware delegates) has the highest impact
  and should land first; phase 2 (contract cleanup) and phase 3 (app
  cleanup) follow. Each phase is independently valuable — partial
  completion still improves the API surface.

  **Phase 1 sub-tasks (runtime + emitter) — COMPLETE (2026-04-16):**
  - 1a: ✓ `borrow-objc-object` in `objc-base.rkt` (no retain, no finalizer)
  - 1b: ✓ `#:param-types` in `delegate.rkt` (auto-wrap/cast callback args)
  - 1c: ✓ Fix `method_return_kind` in `emit_protocol.rs` (int/long returns)
  - 1d: ✓ Emit `#:param-types` + return coercion in protocol factories
  - 1e: ✓ Fix slider/stepper latent bugs in `ui-controls-gallery.rkt`

  **Phase 2 sub-tasks (emitter) — COMPLETE (2026-04-16):**
  - 2a: ✓ Selector params accept strings (emit `sel_registerName` in wrapper body)
  - 2b: ✓ Drop `cpointer?` from `map_param_contract`
  - 2c: ✓ `->string` helper in runtime

  **Phase 3 sub-tasks (apps) — COMPLETE (2026-04-16):**
  - 3a: ✓ Rewrite sample apps (remove `ffi/unsafe`, use new APIs)
  - 3b: ✓ Harness + VM verification
- **Results:**
  Phase 1 landed 2026-04-16. Five changes:
  (1) `borrow-objc-object` in `objc-base.rkt` — lightweight struct wrapping
  without retain/release, satisfies `objc-object?` contracts for borrowed
  delegate callback args.
  (2) `#:param-types` keyword on `make-delegate` in `delegate.rkt` — hash
  mapping selectors to lists of type symbols (`'object`, `'long`, `'int`,
  `'bool`, `'pointer`). The trampoline wrapper auto-coerces each callback
  arg: objects → `borrow-objc-object`, integers → `cast _pointer → _int64/_int32`,
  bools → null-pointer test. Stored per-delegate so `delegate-set!` also wraps.
  (3) `method_return_kind` in `emit_protocol.rs` — added int32→`'int` and
  int64→`'long` branches. `numberOfRowsInTableView:` (NSTableViewDataSource)
  and `tableView:nextTypeSelectMatchFromRow:toRow:forString:` (NSTableViewDelegate)
  correctly classified as `'long` instead of `'void`. 6 new unit tests.
  (4) `generate_protocol_file` emits `#:param-types` hash from IR param types
  via new `param_type_symbol` function. All generated protocol factories now
  pass type metadata to `make-delegate`. 5 new unit tests.
  (5) `ui-controls-gallery.rkt` — slider, stepper, and radio button callbacks
  use `#:param-types '(object)` instead of manual `wrap-objc-object` + `cast`.
  Radio button callback simplified from 4-line ceremony to direct `sender` use.
  `ffi/unsafe` require dropped (only `ffi/unsafe/objc` remains for `sel_registerName`).
  All 105 emitter tests pass, 3 snapshot suites pass, runtime load harness (2 tests) pass.
  Golden files updated for AppKit protocols (param-types + int/long grouping).
  Phase 2 landed 2026-04-16. Three changes:
  (1) SEL params accept strings — `coerce_sel_params` in `emit_class.rs` wraps
  SEL-typed params with `(sel_registerName ...)` in the generated wrapper body.
  `map_param_contract` maps `Selector` → `string?`. App code passes plain strings
  like `"sliderChanged:"` instead of `(sel_registerName "sliderChanged:")`.
  (2) `cpointer?` dropped from `map_param_contract` — object param contracts
  narrowed from `(or/c string? objc-object? cpointer?)` to `(or/c string? objc-object?)`.
  Raw FFI pointers no longer accepted at the contract boundary.
  (3) `->string` helper in `type-mapping.rkt` — accepts `objc-object`, raw `cpointer`,
  `string?`, or `#f`; extracts a Racket string via `nsstring->string`. Idempotent on
  strings. Provided through `coerce.rkt` re-export chain.
  `ui-controls-gallery.rkt` updated: all `sel_registerName` calls replaced with plain
  strings, both `ffi/unsafe` and `ffi/unsafe/objc` requires dropped — **zero FFI imports**.
  All 107 emitter tests pass, 3 snapshot suites pass, runtime load harness (2 tests) pass.
  Golden files updated across 16+ AppKit class wrappers and TestKit.
  Phase 3 landed 2026-04-16. VM-validated all 4 apps:
  (1) All 4 sample apps rewritten to zero FFI imports (`hello-window`, `counter`,
  `ui-controls-gallery`, `file-lister`). No `ffi/unsafe` or `ffi/unsafe/objc` requires
  in any app.
  (2) VM validation: all 4 apps bundled, uploaded to GUIVisionVMDriver VM, launched,
  and visually verified. Hello Window: window + label. Counter: buttons + display.
  UI Controls Gallery: all 8 control sections render. File Lister: 3-column table
  with directory listing, correct sizes/dates.
  (3) Two runtime bugs discovered and fixed during VM testing:
  - Object param contracts always include `#f` (nil) — ObjC nil messaging is no-op,
    many APIs accept nil without explicit _Nullable annotation. Previous contract
    rejected `#f` for non-nullable params (`makeKeyAndOrderFront:` crash).
  - `make-delegate` returns `borrow-objc-object` — delegates satisfy `objc-object?`
    contract when passed to wrappers like `nsbutton-set-target!`.
  - SEL-typed property setters wrap value with `(sel_registerName value)` — previously
    only methods had this, properties were missed (`setAction:` crash).
  (4) New runtime helpers: `objc-autorelease` (autorelease a +1 pointer, returns it),
  `->string` (NSString → Racket string from any input type).
  All 107 emitter tests pass, runtime load harness pass.
  **FFI Surface Elimination is complete across all three phases.**

### Sample Apps

- **Status:** not_started
- **Surfaced:** 2026-04-15; structural verification only on initial landing.
- **Dependencies:** `numberOfRowsInTableView:` `'long` migration complete —
  **satisfied 2026-04-16**. Smoke test should exercise the final `'long`
  implementation.
- **Description:** Run File Lister in GUIVisionVMDriver VM. Verify: app
  launches, window appears, file list is populated, scrolling works, column
  headers render correctly. Exercise the `numberOfRowsInTableView:` `'long`
  return path by verifying the row count matches the directory contents.
  No crashes in stderr; process stays alive after exercising the UI.
- **Results:** _pending_

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
  `nsstring?`, etc.), decide the predicate hosting model. Three options are
  analysed in the class predicates task below:
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
- **Scope notes (2026-04-15, from failed attempt to batch with `_id`
  nullable tightening):**
  - **"Non-coerced params" is empty.** Every object param currently
    flows through `coerce-arg`, so in practice this task only shifts
    tightening" framing no longer applies — the `_id` task touched
    `map_param_contract` + param positions; this one touches
    `map_return_contract` + return positions. Different golden cells,
    no overlap.
  - **Runtime has zero class introspection.** `runtime/objc-base.rkt`
    et al. contain no `object_getClass`, `class_getName`,
    `isKindOfClass:`, or equivalent. A real `nsview?` predicate needs
    a new runtime primitive (probably `objc-instance-of?` backed by
    `class_isKindOfClass:` via `objc_msgSend`, so subclass instances
    satisfy the parent predicate). This is new code with its own
    test surface, not a pure emitter change.
  - **`map_return_contract` update:** class-aware branch for
    `TypeRefKind::Class { name }` (emit the class-specific
    predicate), `objc-object?` fallback for `Id`/`Instancetype`
    (the IR doesn't know the concrete class).
  - **Harness coverage:** needs a new runtime-load check that
    verifies the predicate passes — the existing load-only
    checks cannot observe a contract mismatch that only fires at
    return time.
  - **Golden churn scale:** every class wrapper with an object
    return (most of them). Different cells from the `_id` nullable
    tightening, no savings from running them back-to-back.
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
  call `objc_msgSend` directly. Fix options: (a) emit inherited NSView methods into
  WKWebView's wrapper at generation time via the IR inheritance chain, or (b) expose
  a generic `set-autoresizing-mask!` helper in the runtime that works on any NSView
  subclass via `tell`. Option (b) is lower risk and avoids golden file churn across
  all NSView subclass wrappers. Decide and record the approach before implementing.
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
