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
landed 2026-04-15 (structural verification only — compiles clean under `raco make`
in both direct and hermetic harness trees; full GUI smoke in TestAnyware VM still
pending). Next focus: bug fixes (radio-button contract violation, block nil guard),
then sample apps (Menu Bar Tool → Text Editor → Mini Browser).
```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```
## Task Backlog

### Bug Fixes and Cleanup

- **Status:** done
- **Surfaced:** 2026-04-16 (Modaliser-Racket learning).
- **Closed:** 2026-04-16.
- **Dependencies:** none.
- **Description:** The memory entry "Block nil handling convention" records that
  `make-objc-block` returns `(values #f #f)` when `proc` is `#f`. However,
  Modaliser-Racket experienced the live bug: passing `#f` to `make-objc-block`
  produced a callable block that crashed with `(apply #f ...)` on invocation.
  The discrepancy may indicate (a) the guard was added but not yet deployed to
  Modaliser, (b) the guard only covers one code path, or (c) there is a second
  call site that bypasses the guard. Verify by reading `runtime/block.rkt` and
  checking every `make-objc-block` call site for the `#f`-proc branch. If the
  guard is present and complete, close this task and annotate the memory entry.
  If a gap exists, patch it and add a test in `DelegateBridgeTests` (or equivalent)
  that passes `#f` as a completion handler and asserts no crash on invocation.
  Interim workaround: callers should pass `(lambda args (void))` instead of `#f`
  for optional completion handlers.
- **Results:** Audit completed. Guard is present, complete, and test-covered.
  `runtime/block.rkt:66-67` has the `(if (not proc) (values #f #f) ...)` early
  exit at the top of `make-objc-block`. `free-objc-block` no-ops on `#f` id via
  `(hash-ref active-blocks block-id #f)` + `when entry`. `call-with-objc-block`
  propagates `#f` to the body. Three distinct tests in
  `tests/test-block-creation.rkt` cover all three paths ("make-objc-block with
  #f returns NULL pointer", "free-objc-block with #f block-id is a no-op",
  "call-with-objc-block with #f proc passes NULL"). All 8 block tests pass
  live. Call-site audit: every `make-objc-block` call site in generated class
  files passes the caller's parameter directly — the guard covers all paths.
  The guard commit is `f7a906c` (2026-04-15 10:15 +1000); the Modaliser-Racket
  report is 2026-04-16, so Modaliser was running against a pre-guard checkout.
  Task closed; no code change required. Suggests next: if this pattern recurs,
  consider a git-hook-style annotation for memory entries citing the landing
  commit sha so "was this live when X was reported?" is a one-line check.

- **Status:** done (structural verification only — live GUI smoke pending)
- **Closed:** 2026-04-16.
- **Dependencies:** none — `objc-object?` self-contract tightening landed
  2026-04-15.
- **Description:** The radio button target-action callback in
  `ui-controls-gallery.rkt` passes `sender` (a raw `cpointer` from the
  Swift trampoline) directly to `nsbutton-set-int-value!`, which now
  enforces an `objc-object?` self-contract. At runtime, clicking any
  radio button immediately raises a contract violation with caller blame.
  Fix: `(nsbutton-set-int-value! (cast sender _pointer _id) val)`.
  Alternatively route through `tell` directly to bypass the wrapper layer.
  Pattern is identical to File Lister's column-identity cast:
  `(cast col _pointer _id)` in `tableView:objectValueForTableColumn:row:`.
  Previously invisible: the gallery's GUI test pass predates the contract
  tightening; the radio-click code path is not exercised by `raco make`
  or `dynamic-require` — only fires on a live click.
- **Results:** Applied the cast fix at
  `apps/ui-controls-gallery/ui-controls-gallery.rkt:200` (wrapped `sender` in
  `(cast sender _pointer _id)` before passing to `nsbutton-set-int-value!`).
  `ffi/unsafe` and `ffi/unsafe/objc` are already required (lines 11-12), so
  `cast`/`_pointer`/`_id` are in scope without extra imports. Verification:
  (1) `raco make` on the app source — clean; (2) full
  `runtime_load_apps_via_raco_make` harness — all 4 sample apps pass (53s).
  Live GUI verification in the VM still pending — `raco make` cannot exercise
  the click-path delegate invocation, so the final proof-of-fix is a VM smoke
  run (click each radio, confirm no contract violation, screenshot).
  Follow-up candidates:
  (a) Menu Bar Tool / Text Editor / Mini Browser app work will hit the same
      pattern in their own delegate callbacks — worth watching for a third
      instance so we can factor `as-id-arg` or similar helper into the runtime.
  (b) Consider whether the codegen-side delegate trampoline could pre-wrap
      `id`-typed arguments before dispatch to Racket, so callers never see
      raw cpointers. That would eliminate the class of bug entirely, not just
      this instance.

- **Status:** not_started
- **Surfaced:** 2026-04-15 as explicit follow-up from delegate `'int`/`'long` task.
- **Dependencies:** none — delegate `'long` return kind is in place.
- **Description:** File Lister's `numberOfRowsInTableView:` currently uses the
  pointer-smuggle workaround: declares return kind `'id`, returns
  `(ptr-add #f count)`, relying on arm64 x0 carrying the integer as pointer
  address bits. Now that `'long` is supported, replace with
  `:return-types #hash(("numberOfRowsInTableView:" . long))` in the delegate
  registration and return `count` directly. Verifies the new return kind works
  in a real app and removes a non-obvious workaround from the canonical sample.
- **Results:** _pending_

- **Status:** not_started
- **Surfaced:** 2026-04-16 (Modaliser-Racket Task #7b, `_dispatch_main_q` migration).
- **Dependencies:** none.
- **Description:** The generator emits struct-typed C data globals the same
  way it emits pointer-typed ones, producing semantically wrong values.
  Concretely, `_dispatch_main_q` is declared
  `DISPATCH_EXPORT struct dispatch_queue_s _dispatch_main_q;` — the symbol
  IS the struct. C callers use `dispatch_get_main_queue()`, a macro expanding
  to `((dispatch_queue_main_t)&(_dispatch_main_q))` — i.e. they take the
  *address* of the symbol. The generated binding is
  `(define _dispatch_main_q (get-ffi-obj '_dispatch_main_q _fw-lib _pointer))`
  which reads the first 8 bytes stored *at* the symbol and returns those
  bytes interpreted as a pointer — the opaque first field of the struct,
  not the struct's address. For `CFStringRef`-style globals
  (`kCFRunLoopCommonModes` etc.) this is correct, because the symbol's
  memory is itself a pointer; for struct globals it produces garbage.
  Empirically confirmed on 2026-04-16:
  `(ffi-obj-ref #"_dispatch_main_q" libSystem)` and
  `dlsym(RTLD_DEFAULT, "_dispatch_main_q")` agree on an address X; the
  generated constant returns a different value Y — the first 8 bytes of
  the queue struct. Modaliser-Racket's `ffi/main-thread.rkt` now works
  around this with a local `ffi-obj-ref` + `cast _pointer _id`.
  Fix: when the IR records that a data global's declared type is a struct
  (not a pointer), emit
  `(define foo (ffi-obj-ref 'foo _fw-lib))`
  so the result is the symbol's address, not its dereferenced contents.
  For pointer-typed globals keep the current `get-ffi-obj` path. The IR
  already distinguishes the two at the clang-AST level.
  Affected symbols today: every `DISPATCH_GLOBAL_OBJECT` queue / source-type
  global (`_dispatch_data_empty`, `_dispatch_queue_attr_concurrent`, the
  `_dispatch_source_type_*` family) in `libdispatch/constants.rkt` is almost
  certainly wrong for the same reason — any consumer that gets a non-crash
  out of them is reading first-field bytes by coincidence. Likely also
  affects Carbon / HIToolbox / CoreAudio struct globals, though the
  Modaliser-side audit only touched libdispatch.
  Verification: once the emitter is fixed, add a runtime-load harness check
  that calls `dispatch_async_f` with the generated `_dispatch_main_q` and a
  no-op function-pointer callback, and asserts the call does not crash. Also
  assert `(equal? _dispatch_main_q (ffi-obj-ref #"_dispatch_main_q" libSystem))`
  to lock the invariant. Reverting Modaliser's workaround to use the
  generated constant directly is the acceptance test.
- **Results:** _pending_

- **Status:** not_started
- **Surfaced:** 2026-04-16 (Modaliser-Racket Task #7b, `_dispatch_main_q` migration).
- **Dependencies:** none.
- **Description:** Low-priority ergonomics follow-up to the struct-data-symbol
  fix above. The generator types `dispatch_async_f`'s queue parameter as
  `_id` because `dispatch_queue_t` is declared as an ObjC object in headers
  with `OS_OBJECT_USE_OBJC=1`. This is defensible, but creates friction for
  consumers who obtain the queue from a raw source (`dlsym`, `ffi-obj-ref`,
  pointer arithmetic): the Racket ObjC runtime's `id->C` conversion rejects
  plain cpointers with "argument is not `id' pointer". The workaround is an
  inline `(cast ptr _pointer _id)`, correct but non-obvious — Modaliser hit
  this twice during Task #7b (first with a plain cpointer, then after
  stripping the `ffi-obj-ref` tag, still rejected until cast to `_id`).
  Consider one of:
  (a) Emit `_pointer` instead of `_id` for `DISPATCH_DECL`-style OS-object
      parameter types. The ABI is identical, no wrapper class exists for
      dispatch objects in the generated bindings, and safety is not lost —
      the generator has no runtime type check at this boundary either way.
  (b) Keep `_id` and export an `as-id` helper from the framework module
      (mirrors `runtime/objc-base.rkt`'s `as-id`, hosted next to the queue
      accessors so consumers don't need to reach into the runtime).
  (c) Accept the friction and document the `(cast ptr _pointer _id)` idiom
      in the knowledge file alongside the framework.
  Whichever path is chosen, record the decision in a memory entry — this
  will come up again as more libdispatch / OS-object APIs get consumed.
- **Results:** _pending_

### Sample Apps

- **Status:** not_started
- **Dependencies:** none; independent of File Lister (which shipped
  2026-04-15, structural verification only)
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
- **Dependencies:** none (`_id` nullable tightening is complete; scope
  notes confirm different golden cells, so no amortisation benefit from
  sequencing).
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
  - **Predicate hosting decision (required before coding):**
    - **Option A — Runtime factory, inline per class file.**
      Each class file gets
      `(define nsview? (class-predicate "NSView"))` at the top and
      `provide`s it. No cross-class imports. Simplest. Predicates
      for class Y that appear in class X's return contracts must be
      defined *in class X's file too*, so the same predicate gets
      duplicated across every class that references it. Compile
      cost O(references).
    - **Option B — Central generated barrel
      (`runtime/class-predicates.rkt` or emitter-generated under
      `generated/`).** One file defining every predicate; each class
      wrapper requires it. Cleanest consumer side. Adds a generated
      file that has to track the class set, and the barrel becomes
      a compilation bottleneck (every class file requires it).
    - **Option C — Per-class-file predicate + cross-class requires.**
      `nsview.rkt` defines and provides `nsview?`; any wrapper that
      mentions NSView in a return contract requires `nsview.rkt`.
      Matches the "expose them as runtime type-test primitives from
      the class files themselves" phrasing in the original
      description. But introduces a *new* dependency edge between
      class wrappers — currently class files don't require each
      other, only the runtime. The edge is a real DAG (roughly
      mirrors the inheritance / uses graph) but it's a structural
      change with load-order implications worth thinking through.
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
- **Blocking decision:** pick a hosting model (A / B / C) before
  implementation starts. Record the decision in a memory entry even
  if A wins by default.
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
