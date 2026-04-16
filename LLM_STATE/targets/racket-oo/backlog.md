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
raw cpointers without cast ceremony. Next focus: transparent object-wrapping
research, then sample apps (Menu Bar Tool → Text Editor → Mini Browser).
```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```
## Task Backlog

### Research: Transparent Object Wrapping for Delegate Callback Args

- **Status:** not_started
- **Surfaced:** 2026-04-16 (radio-button fix required 3 iterations;
  `wrap-objc-object` is correct but too intrusive for app authors).
- **Dependencies:** none.
- **Description:** App programmers writing delegate callbacks currently
  receive raw `cpointer` args from the Swift trampoline but class wrapper
  contracts demand `objc-object?` structs. The workaround —
  `(wrap-objc-object (cast sender _pointer _id))` — is correct but
  requires understanding the difference between cpointer tags and
  `objc-object` struct wrappers, which is an implementation detail that
  should be invisible at the API surface. Research how to close this gap
  so that delegate callback args "just work" with class wrapper functions.
  
  **Approaches to investigate:**
  
  (a) **Trampoline-side wrapping.** Modify `delegate.rkt`'s
      `make-delegate` so that `id`-typed trampoline args are pre-wrapped
      as `objc-object` structs before being passed to the user's lambda.
      Pros: invisible to app code, one-time fix. Cons: every delegate
      invocation pays a `wrap-objc-object` + retain/release cost even if
      the arg is never passed to a wrapper; need to decide ownership
      semantics (borrowed → `#:retained #f` adds a balanced pair).
  
  (b) **Contract relaxation.** Widen the self-contract from `objc-object?`
      to `(or/c objc-object? cpointer?)` and have the wrapper body handle
      both. Pros: zero overhead for delegate args. Cons: weakens type
      safety — a random integer or struct pointer would pass `cpointer?`
      and silently crash in `objc_msgSend`.
  
  (c) **Transparent coercion at the contract boundary.** Use a Racket
      `flat-contract` / `chaperone-contract` that auto-wraps cpointers
      into `objc-object` structs on the way in. Pros: invisible to both
      callers and wrapper internals; contract still rejects non-pointer
      garbage. Cons: need to verify Racket's contract system supports
      value-transforming input contracts without `chaperone-contract`'s
      restrictions.
  
  (d) **Unify the types.** Eliminate the `objc-object` struct entirely
      and use `_id`-tagged cpointers everywhere, with GC prevention
      handled via a separate mechanism (weak hash, pointers registered
      with the runtime). Pros: removes the struct/cpointer split at the
      root. Cons: major refactor touching every constructor, wrapper, and
      test; finalizer attachment becomes less straightforward.
  
  (e) **`borrow-objc-object` helper.** Export a lightweight function from
      the runtime that creates a no-finalizer `objc-object` struct for
      borrowed refs — cheaper than `wrap-objc-object` (no retain/release
      pair, no finalizer registration). Doesn't eliminate the need for the
      helper, but reduces the footprint and cost. A stepping stone toward
      (a) or (c).
  
  **Evaluation criteria:** Does it make app code work without any
  knowledge of `objc-object` vs `cpointer`? Does it preserve contract
  safety (reject garbage, produce good blame)? What's the per-call
  overhead? How much emitter/runtime code changes?
  
  Related: File Lister's `(cast col _pointer _id)` works only because
  it feeds into `tell`, not a contract boundary. If the column value
  ever flows through a wrapper, it hits the same problem. Any solution
  here should cover both delegate-sender and delegate-data-args.
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

- **Status:** not_started
- **Dependencies:** none
- **Promoted from:** residual sub-item 4 of the retired
  "Tighten per-class method wrapper contracts" task.
- **Description:** Parameters whose IR kind is `Selector` currently
  get `cpointer?` via the `map_param_contract` fall-through to
  `map_contract`. The original spec asked for a `sel?` predicate
  instead, but no `sel?` is currently exported from `objc-base.rkt`
  or any re-export, so this requires a runtime-side addition.
  Decide between:
  (a) extend the runtime to export a `sel?` alias for `cpointer?`
    and switch selector params to use it; or
  (b) accept `cpointer?` as the permanent contract and close this
    task as designed, adding a memory entry recording the decision.
  Either outcome is legitimate — the task's real value is forcing
  the decision and recording it, not the code change. Low priority
  because selectors are uncommon in user-facing call sites (most
  selector construction goes through `tell`, not raw params).
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
