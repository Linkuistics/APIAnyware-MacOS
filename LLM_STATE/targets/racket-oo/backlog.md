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

### Research: Eliminate FFI-isms from User-Facing API Surface (COMPLETE)

- **Status:** done
- **Surfaced:** 2026-04-16 (expanded from delegate-args-only scope).
- **Description:** Comprehensive analysis of every point where FFI
  concepts leak into app code, with a layered solution architecture.

- **Results (2026-04-16):**

  **1. FFI Leakage Catalog**

  Audited all 4 sample apps (counter, file-lister, ui-controls-gallery,
  hello-window) and the generated wrapper + runtime code. Every place
  an app author must know about Racket's FFI layer:

  | Category | Example in app code | Frequency |
  |---|---|---|
  | **Delegate args as raw pointers** | `(wrap-objc-object (cast sender _pointer _id))` | Every delegate callback touching a wrapper |
  | **Integer args encoded as pointers** | `(cast row-ptr _pointer _int64)` | Every int/long delegate param |
  | **`ffi/unsafe` require** | `(require ffi/unsafe ffi/unsafe/objc)` | Every app (needed for `cast`, `cpointer?`, `sel_registerName`) |
  | **`sel_registerName` for actions** | `(nsbutton-set-action! btn (sel_registerName "chooseFolder:"))` | Every target-action pattern |
  | **`cpointer?` in contracts** | `(c-> objc-object? cpointer? void?)` on `set-action!` | Every SEL-typed param |
  | **`nsstring->string` / `string->nsstring`** | `(nsstring->string (objc-object-ptr obj))` in `ns->str` helper | Every NSString extraction |
  | **`objc-object-ptr` unwrapping** | `(nsstring->string (objc-object-ptr obj))` | Whenever raw pointer is needed from wrapper |
  | **`tell` with raw cast** | `(tell (cast col-ptr _pointer _id) identifier)` | Missing wrappers / delegate data args |
  | **`tell ... autorelease`** | `(tell (string->nsstring text) autorelease)` | Manual memory mgmt for returned strings |
  | **`objc-null?` / `objc-object?` checks** | `(if (objc-null? obj) "" ...)` | Nil handling in helpers |

  **Latent bugs found:** `ui-controls-gallery.rkt` slider and stepper
  callbacks pass raw `sender` pointer to wrappers like
  `(nsslider-double-value sender)` — contract violation (`sender` is
  `cpointer?`, contract demands `objc-object?`). Not caught because
  `raco make` compiles but doesn't execute callback paths. Same class
  of bug as the radio-button fix, just undiscovered.

  **2. Root Causes (3 systemic issues)**

  **(A) Delegate trampolines are type-unaware.** `delegate.rkt` types
  all callback params as `_pointer` regardless of their actual type.
  Object args arrive as raw cpointers; integer args arrive as
  pointer-encoded integers. Users must manually cast/wrap each arg.
  The protocol emitter HAS the IR type info (visible in comments:
  `tableView:NSTableView, row:int64`) but doesn't emit it into the
  generated `make-delegate` call.

  **(B) Protocol emitter discards param types and misclassifies returns.**
  `method_return_kind` in `emit_protocol.rs:148` only handles
  void/bool/id. Primitives like int64 (NSInteger) fall through to
  the default "void" case. `numberOfRowsInTableView:` is classified
  as void-returning in the generated protocol file, forcing users to
  override with `#:return-types (hash ... 'long)`. More critically,
  no param-type metadata is emitted at all — the protocol factory
  just passes selector+handler pairs through to `make-delegate`.

  **(C) Generated wrappers expose FFI vocabulary in contracts.**
  `set-action!` has contract `(c-> objc-object? cpointer? void?)`
  where `cpointer?` is the SEL param. Users must call
  `sel_registerName` to produce the cpointer. The emitter could
  accept a string and call `sel_registerName` internally.

  **3. Target API Surface**

  The goal: app code never requires `ffi/unsafe` or `ffi/unsafe/objc`,
  never calls `cast`/`wrap-objc-object`/`sel_registerName`/`coerce-arg`,
  never sees `cpointer?`/`_pointer`/`_id` in contracts or values.

  What counter.rkt's target-action should look like:
  ```racket
  (define target
    (make-delegate
     "increment:" (lambda (sender)        ;; sender is objc-object, not pointer
                    (set! counter (add1 counter))
                    (update-label!))))
  (nsbutton-set-action! btn "increment:") ;; string, not sel_registerName
  ```

  What file-lister's data-source delegate should look like:
  ```racket
  (define data-source
    (make-nstableviewdatasource
     "numberOfRowsInTableView:"
     (lambda (tv)                          ;; tv is objc-object
       (length file-entries))
     "tableView:objectValueForTableColumn:row:"
     (lambda (tv col row)                  ;; col=objc-object, row=integer (auto-cast)
       (define id-str (->string (nstablecolumn-identifier col)))
       (define idx (case id-str [("name") 0] [("size") 1] [else 2]))
       (vector-ref (list-ref file-entries row) idx))))  ;; return Racket string → auto-coerced
  ```

  Key: protocol factory knows param types from IR, auto-wraps object
  args as `borrow-objc-object`, auto-casts int/long args to integers,
  auto-coerces return values (Racket string → NSString for `'id` returns).

  **4. Solution Architecture (3 phases)**

  **Phase 1 — Type-aware delegates (highest impact, runtime + emitter)**

  1a. Add `borrow-objc-object` to `objc-base.rkt` — creates an
      `objc-object` struct with no finalizer, no retain/release.
      Ownership: borrowed (caller guarantees liveness for the callback
      duration, which Cocoa's delegate calling convention ensures).
      Cost: one struct allocation, zero FFI calls. This is the key
      primitive that makes trampoline-side wrapping cheap.

  1b. Add `#:param-types` to `make-delegate` — hash mapping selector
      to a list of type symbols (`'object`, `'int`, `'long`, `'bool`,
      `'pointer`). When present, the callback wrapper auto-transforms
      args before calling the user's lambda:
      - `'object` → `(borrow-objc-object (cast arg _pointer _id))`
      - `'int` → `(cast arg _pointer _int32)`
      - `'long` → `(cast arg _pointer _int64)`
      - `'bool` → `(not (ptr-equal? arg #f))`
      - `'pointer` → pass through (escape hatch)

  1c. Fix `method_return_kind` in `emit_protocol.rs` to handle int/long
      return types (map int32→`'int`, int64/NSInteger→`'long`). This
      fixes `numberOfRowsInTableView:` being misclassified as void.

  1d. Emit `#:param-types` in generated protocol factories. The IR
      already has `Method.params[].param_type` — map each to the
      appropriate symbol and emit into the protocol's `make-<proto>`
      function. Also emit the delegate return auto-coercion:
      - Handler returning Racket `string?` for `'id` return kind →
        auto-convert via `string->nsstring + tell autorelease`
      - Handler returning `objc-object?` for `'id` return kind →
        auto-unwrap via `unwrap-objc-object`
      - Handler returning `#f` → pass through as NULL
      This eliminates the `(tell (string->nsstring text) autorelease)`
      ceremony from file-lister.

  **Phase 2 — Wrapper contract cleanup (emitter changes)**

  2a. Selector params accept strings. For `TypeRefKind::Selector`
      params, the generated wrapper body calls `(sel_registerName value)`
      internally. Contract changes from `cpointer?` to `string?`.
      Affects `set-action!`, `set-double-action!`, and ~20 other
      selector-accepting methods. Subsumes the existing "Selector
      parameter contracts" stretch task.

  2b. Drop `cpointer?` from param contracts. Change `map_param_contract`
      to emit `(or/c string? objc-object?)` (non-nullable) or
      `(or/c string? objc-object? #f)` (nullable) — removing `cpointer?`.
      Users pass either Racket strings (auto-coerced to NSString) or
      `objc-object` structs (from constructors/method returns/delegates).
      Raw cpointers are an internal implementation detail.
      **Risk:** any existing code passing raw cpointers to wrappers
      breaks. Mitigated by: (a) delegate callbacks now auto-wrap, so
      the main source of raw cpointers is gone; (b) direct FFI users
      who need raw pointers can use `tell` directly (it accepts both).

  2c. Add `->string` to runtime. Operates on `objc-object?` values:
      `(->string obj)` → `(nsstring->string (objc-object-ptr obj))`.
      Handles nil (`objc-null?` → `""`). Eliminates the per-app
      `ns->str` helper pattern. Export from `coerce.rkt` so it's
      available wherever `objc-object?` is.

  **Phase 3 — App cleanup and validation**

  3a. Rewrite all 4 sample apps to use the new API surface: remove
      `(require ffi/unsafe ffi/unsafe/objc)`, replace `sel_registerName`
      with string args, replace `wrap-objc-object`/`cast` with direct
      wrapper calls, replace `ns->str` with `->string`, use protocol
      factory with auto-typed delegates.

  3b. Verify each app still compiles under `raco make` in the harness,
      and ideally run in GUIVisionVMDriver VM to confirm runtime behavior.

  **5. Approach evaluation (original options a-e)**

  The recommended solution is a hybrid of (a) and (e):
  - (e) `borrow-objc-object` provides the cheap wrapping primitive
  - (a) trampoline-side wrapping uses it to auto-wrap object args
  - Extended with param-type awareness for int/long/bool auto-casting

  Rejected:
  - (b) contract relaxation — weakens safety, doesn't fix int/long args
  - (c) contract-boundary coercion — Racket's `flat-contract` cannot
    transform values; `chaperone-contract` can but adds complexity and
    doesn't solve the int/long problem
  - (d) eliminate objc-object struct — too invasive, loses GC finalization

  **6. Discovered bugs to fix**

  - `emit_protocol.rs:method_return_kind` — int/long/uint returns fall
    through to "void". `numberOfRowsInTableView:` misclassified.
  - `ui-controls-gallery.rkt` — slider/stepper callbacks pass raw
    `sender` pointer to wrappers; will crash at runtime on the
    `objc-object?` contract. Same bug class as radio-button fix.

### FFI Surface Elimination

- **Status:** not_started
- **Surfaced:** 2026-04-16 (derived from research above).
- **Dependencies:** none (self-contained across runtime + emitter).
- **Description:** Implement the 3-phase solution architecture from the
  research above. Phase 1 (type-aware delegates) has the highest impact
  and should land first; phase 2 (contract cleanup) and phase 3 (app
  cleanup) follow. Each phase is independently valuable — partial
  completion still improves the API surface.

  **Phase 1 sub-tasks (runtime + emitter):**
  - 1a: `borrow-objc-object` in `objc-base.rkt` (no retain, no finalizer)
  - 1b: `#:param-types` in `delegate.rkt` (auto-wrap/cast callback args)
  - 1c: Fix `method_return_kind` in `emit_protocol.rs` (int/long returns)
  - 1d: Emit `#:param-types` + return coercion in protocol factories
  - 1e: Fix slider/stepper latent bugs in `ui-controls-gallery.rkt`

  **Phase 2 sub-tasks (emitter):**
  - 2a: Selector params accept strings (emit `sel_registerName` in wrapper body)
  - 2b: Drop `cpointer?` from `map_param_contract`
  - 2c: `->string` helper in runtime

  **Phase 3 sub-tasks (apps):**
  - 3a: Rewrite sample apps (remove `ffi/unsafe`, use new APIs)
  - 3b: Harness + VM verification
- **Results:** _pending_

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

- **Status:** done
- **Dependencies:** none
- **Promoted from:** residual sub-item 4 of the retired
  "Tighten per-class method wrapper contracts" task.
- **Description:** Parameters whose IR kind is `Selector` currently
  get `cpointer?` via the `map_param_contract` fall-through to
  `map_contract`. The original spec asked for a `sel?` predicate
  instead, but no `sel?` is currently exported from `objc-base.rkt`
  or any re-export, so this requires a runtime-side addition.
- **Results:** Subsumed by the FFI Surface Elimination task (phase 2a).
  The decision: selector params should accept **strings**, not
  `cpointer?` or `sel?`. The generated wrapper calls
  `(sel_registerName value)` internally. Contract becomes `string?`.
  This eliminates `sel_registerName` from app code entirely — a
  stronger outcome than either option (a) or (b) originally proposed.
  Recorded 2026-04-16.

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
