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
verification harness now in place** (`generation/crates/emit-racket-oo/tests/runtime_load_test.rs`):
6 library `dynamic-require` checks across class wrapper, protocol file, Foundation
+ CoreGraphics + CoreText functions/constants, plus `raco make` of all 3 sample apps,
gated on `RUNTIME_LOAD_TEST=1` (~47s end-to-end). All three recent core filter fixes
(extract-objc internal-linkage, extract-swift `s:` family, extract-swift `c:@macro@`
family) validated end-to-end against fresh IR. Self-parameter contracts tightened to
`objc-object?` in every class wrapper — the biggest single misuse vector is now
rejected at the wrapper boundary. Next focus: remaining sample apps (File Lister →
Menu Bar Tool → Text Editor → Mini Browser), then OO style analysis and coverage
expansion. Sample apps are no longer blocked.

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

## Task Backlog

### File Lister app `[apps]`
- **Status:** not_started
- **Dependencies:** none — Runtime load verification landed 2026-04-13
  and validated all three core filter fixes end-to-end, removing the
  last cross-cutting blocker for app work.
- **Description:** NSTableView, data source delegate, NSFileManager, NSOpenPanel.
  Tests the delegate pattern — the most common AppKit integration point. First of
  the remaining four apps because the delegate/data-source plumbing it exercises
  is a precondition for Text Editor's more demanding callback patterns.
  See `knowledge/apps/file-lister/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Tighten `_id` parameter contracts with nullable marking `[emission]`
- **Status:** not_started
- **Dependencies:** none
- **Promoted from:** residual sub-item 2 of the now-retired
  "Tighten per-class method wrapper contracts" task (self-tightening
  landed 2026-04-13; the remaining sub-items are split out as
  independent tasks per the "lift embedded blockers to top-level
  tasks" rule).
- **Description:** Replace the literal `(or/c any/c #f)` in class
  wrapper param positions with a meaningfully tighter contract.
  Non-nullable `_id` params become
  `(or/c string? objc-object? cpointer?)`; nullable `_id` params
  become `(or/c string? objc-object? cpointer? #f)`. These match
  exactly what `coerce-arg` accepts (see `runtime/coerce.rkt`), so
  the change is ergonomics-neutral but catches numbers / symbols /
  lists at the wrapper boundary with the right blame. Implementation
  touches `map_param_contract` in `emit_functions.rs` — it must
  consult `type_ref.nullable` and return the union contract for
  `TypeRefKind::Class | Id | Instancetype`. This will shift every
  snapshot containing object-typed params, so plan on a full
  `UPDATE_GOLDEN=1` regeneration followed by a
  `RUNTIME_LOAD_TEST=1` harness pass.
- **Results:** _pending_

### Menu Bar Tool app `[apps]`
- **Status:** not_started
- **Dependencies:** none; independent of File Lister
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard. Tests
  an unusual app lifecycle (no main window, status item driven) and menu
  construction. GCD main-thread dispatch helpers in `main-thread.rkt` are already
  in place for timer callbacks.
  See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Text Editor app `[apps]`
- **Status:** not_started
- **Dependencies:** File Lister complete (delegate-pattern shakedown first)
- **Description:** Block callbacks, error-out, undo/redo, notifications, find.
  Tests complex callback patterns and NSUndoManager integration — the most
  demanding OO interaction patterns. Runtime block nil handling (`make-objc-block`
  returning `(values #f #f)` for `#f` proc) is now in place.
  See `knowledge/apps/text-editor/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Mini Browser app `[apps]`
- **Status:** not_started
- **Dependencies:** none. WebKit OO emission is verified (164 classes,
  29 protocols, 196 files load cleanly in Racket).
- **Description:** Cross-framework WebKit, WKNavigationDelegate, URL handling.
  Tests cross-framework imports (AppKit + WebKit) and delegate protocols from a
  non-Foundation framework.
  See `knowledge/apps/mini-browser/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Add `audiotoolbox/constants.rkt` to runtime load harness `[testing]`
- **Status:** not_started — **unblocked 2026-04-13** by the closed core
  task "Platform-unavailable `extern` symbols leak into macOS IR" (was
  formerly the first sibling of the parent harness-extension task).
- **Dependencies:** none — the underlying leak is fixed and verified
  against fresh IR.
- **Promoted from:** the still-blocked "Extend runtime load harness to
  remaining `c:@macro@` framework siblings" task below. Promoted because
  this single sibling is now actionable on its own and would otherwise
  stay invisible to the work phase while waiting for its three blocked
  siblings. Per "lift embedded blockers to top-level tasks": if a piece
  of work can run independently right now, it must surface as its own
  top-level entry rather than as a footnote inside a `blocked` parent.
- **Description:** Add one entry to `LIBRARY_LOAD_CHECKS` in
  `generation/crates/emit-racket-oo/tests/runtime_load_test.rs` for
  `audiotoolbox/constants.rkt`, plus `AudioToolbox` to `REQUIRED_FRAMEWORKS`
  so the harness emits it. Re-run with `RUNTIME_LOAD_TEST=1` and confirm
  all 7 library checks pass. Estimated impact: +1–2s harness runtime,
  +50KB tempdir footprint. Also delete the stale "Attempted 2026-04-13"
  note from the parent task once this lands.
- **Results:** _pending_

### Extend runtime load harness to remaining `c:@macro@` framework siblings `[testing]`
- **Status:** not_started — **fully unblocked 2026-04-14**. Both
  core-backlog dependencies now closed against fresh IR:
  - "Anonymous-enum members extracted as standalone constants" landed
    earlier and unblocks `network/constants.rkt`.
  - "Constants flagged in `skipped_symbols` still reach final IR"
    closed 2026-04-13 — the task dissolved into a pipeline regeneration
    (stale downstream checkpoints, no code change), and both canaries
    (`NEFilterFlowBytesMax`, `CoreSpotlightAPIVersion`) are now absent
    from the regenerated `networkextension/constants.rkt` and
    `corespotlight/constants.rkt`. See core session log / memory mode-6.
- **Dependencies:** none — can be re-attempted immediately.
- **Description:** Re-attempt the 2026-04-13 extension: add three entries
  to `LIBRARY_LOAD_CHECKS` in `tests/runtime_load_test.rs`:
  `networkextension/constants.rkt`, `network/constants.rkt`,
  `corespotlight/constants.rkt`. Add the same frameworks to
  `REQUIRED_FRAMEWORKS` so the harness emits them. Re-run with
  `RUNTIME_LOAD_TEST=1` and confirm all library checks pass.
  Estimated impact: +5–10s harness runtime, +200KB tempdir footprint.
- **Results:** _Attempted 2026-04-13: extension reverted because all four
  new checks failed. Both relevant leaks have since been resolved
  (anonymous-enum filter landed earlier; skipped_symbols "leak" turned
  out to be stale downstream checkpoints). Audiotoolbox sibling split
  out into its own unblocked task above._

### Investigate pre-existing `snapshot_racket_oo_foundation_subset` golden drift `[testing]`
- **Status:** not_started
- **Priority:** medium — not a runtime blocker (the harness and all
  runtime load checks pass), but it's a failing workspace test at HEAD.
  A red test in the default `cargo test` run erodes the signal on every
  future change and masks genuine emitter regressions.
- **Surfaced by:** 2026-04-14 core triage. The 2026-04-13 core task
  "Constants flagged in `skipped_symbols` still reach final IR" explicitly
  noted this test was already failing at HEAD and was out-of-scope for
  that task. Lifted to its own racket-oo backlog entry so the work phase
  can pick it up independently.
- **Description:** `snapshot_racket_oo_foundation_subset` in
  `generation/crates/emit-racket-oo/tests/` was observed failing against
  HEAD during the 2026-04-13 pipeline regeneration (full `cargo test`
  pass). Determine whether the drift is legitimate emitter output change
  (→ `UPDATE_GOLDEN=1` regenerate the foundation subset files and commit)
  or a genuine regression (→ diagnose and fix). Check git log on the
  relevant emitter crates against the snapshot file mtimes first; if the
  emitter output shape changed recently without a corresponding golden
  update, the fix is probably a regenerate. If the emitter source hasn't
  moved but the snapshot still diverges, something upstream in collection
  or analysis has shifted the IR for Foundation and the divergence is
  real signal.
- **Results:** _pending_

### Class-specific runtime predicates `[emission]` _(stretch)_
- **Status:** not_started
- **Dependencies:** none — but sequence after `_id` parameter nullable
  tightening so the snapshot churn is amortised over one regeneration
  pass, not two.
- **Promoted from:** residual sub-item 3 of the retired
  "Tighten per-class method wrapper contracts" task.
- **Description:** Generate `nsview?`, `nsstring?`, etc. predicates
  from the class files themselves and expose them as runtime type-test
  primitives. Use them in contract positions where the IR knows the
  declared type **and** where ergonomic coercion isn't needed (i.e.
  returns and non-coerced params). Consumers gain a runtime predicate
  they currently lack. Marked stretch because the ergonomics win is
  real but narrow, and the snapshot regeneration cost is the same as
  the higher-value `_id`-nullable task. Worth tackling only after the
  `_id` tightening lands, so the two changes share one
  `UPDATE_GOLDEN=1` pass if scheduled back-to-back.
- **Results:** _pending_

### Selector / SEL parameter contracts `[emission]`
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

### Per-framework exercisers `[testing]`
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

### Analyse OO style class system usage `[architecture]`
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

### Typed Racket binding layer `[coverage]`
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

### Documentation requirements `[docs]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Record Racket-specific documentation requirements: `tell`
  macro usage, `import-class` patterns, what's surprising for Racket developers,
  paradigm-appropriate examples for both OO and functional styles.
- **Results:** _pending_

## Completed Tasks

_None pending capture. The three cleanups from the 2026-04-13 cycle (stale
`memory.md` entry prune, stale `apps/hello-window.rkt` delete, `needs_structs`
helper consolidation) and the parent "Tighten per-class method wrapper
contracts" task (self-tightening completed, residual sub-items split into
independent tasks above) have been captured in session-log and memory and
are removed from the backlog entirely. The "Non-linkable symbol leaks beyond
the `c:@macro@` filter" task has been moved to `LLM_STATE/core/backlog.md`
since it is a cross-target collection/extract concern, not racket-oo-specific;
see the "Extend runtime load harness" task above for the racket-oo follow-up
that depends on the core fix._
