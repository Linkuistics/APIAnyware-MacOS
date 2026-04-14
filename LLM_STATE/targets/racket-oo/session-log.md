# Session Log

## Pre-history (migrated from milestone 9 learnings)
- Racket emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields
- Dylib name: `libAPIAnywareRacket` (not `libanyware_racket`); only `swift-helpers.rkt` references it
- Generated runtime paths: `../../../runtime/` for class files, `../../../../runtime/` for protocol files
- Swift-style selectors (containing `(`) must be filtered — `init(string:)` can't be called via objc_msgSend
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases must be resolved to canonical types at collection time
- `NSEdgeInsets` not in geometry struct alias list — omit from apps until fixed
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
- Always `pkill -9 -f racket` before relaunching apps

### Session 1 (2026-04-11) — Complete constants emission

- **Task:** Complete constants emission in OO style `[coverage]`
- **What was done:**
  - Updated `generate_constants_file` in `emit_constants.rs` to accept `&[Constant]` and
    emit `get-ffi-obj` definitions using `RacketFfiTypeMapper` for type mapping
  - Each constant becomes `(define Name (get-ffi-obj 'Name _fw-lib _type))`
  - Added framework dylib loading (`_fw-lib`) and excluded it from `provide`
  - Fixed `generate_main_file` in `emit_framework.rs` — the `_has_constants` param was
    unused; now `constants.rkt` is included in require/provide of main.rkt
  - Added 6 unit tests covering NSString, double, alias, framework lib, provide, ordering
  - Updated TestKit and Foundation golden files
  - Regenerated all bindings — Foundation now has 861-line constants.rkt with 852 constants
- **What was learned:**
  - Foundation has 852 constants: 803 NSString (→ `_id`), 10 alias, 8 primitive, etc.
  - Geometry struct constants like `NSZeroPoint`/`NSZeroRect` map correctly via alias handling
  - One edge case: `CoreFoundation.CFStringEncoding` is stored as primitive with qualified
    name, falls through to `_pointer` — pre-existing type mapper limitation, not introduced here
  - Also removed 3 functional-style tasks from backlog (belonged in racket-functional target)
- **All tests pass:** 28 crate tests + full workspace green

### Session 2 (2026-04-11) — AppKit snapshot golden files

- **Task:** AppKit snapshot golden files `[testing]`
- **What was done:**
  - Added `snapshot_racket_oo_appkit_subset` test to `snapshot_test.rs` following the
    Foundation subset pattern: loads real AppKit enriched IR, emits to temp dir, compares
    23 curated files against golden directory
  - Generalized `load_foundation_framework()` into `load_enriched_framework(name)` — both
    Foundation and AppKit tests now use the same loader
  - Curated 23 AppKit golden files covering: view hierarchy (NSResponder→NSView→NSControl→
    NSButton), window management (NSWindow, NSWindowController), table view with delegate/
    data source protocols (NSTableViewDelegate, NSTableViewDataSource), text (NSTextField,
    NSTextView), menus (NSMenu, NSMenuItem), application lifecycle (NSApplication), layout
    (NSStackView), status bar (NSStatusBar), colors (NSColor), images (NSImage), split views
    (NSSplitView), and window delegate protocol (NSWindowDelegate)
  - Golden files at `tests/golden-appkit/oo/` — generated via `UPDATE_GOLDEN=1`
- **What was learned:**
  - AppKit IR is substantial: 313 classes, 151 protocols, 337 enums, 1846 constants
  - NSButton generates 1110 lines, NSWindow 942 lines — much richer than typical Foundation
    classes, exercising more typed message send variants and geometry struct handling
  - NSTableViewDelegate golden file documents 31 protocol methods organized by return type
    (void/bool/id) — good regression anchor for delegate emission
  - The `load_enriched_framework` generalization makes adding more framework golden suites
    trivial (just add a file list and test function)
- **All tests pass:** 29 crate tests (26 unit + 3 snapshot)

## Session 2025-04-12: Runtime fixes — block nil handling + GCD main-thread dispatch
- **Tasks completed:**
  1. `make-objc-block` nil handling — when `proc` is `#f`, now returns `(values #f #f)`
     (NULL block pointer + no block-id) instead of wrapping `#f` in a lambda that crashes.
     `free-objc-block` already handles `#f` gracefully. 3 test cases added.
  2. GCD main-thread dispatch — ported `main-thread.rkt` from Modaliser-Racket to shared
     runtime. Provides `on-main-thread?`, `call-on-main-thread` (sync on main thread,
     async via `dispatch_async_f` otherwise), `call-on-main-thread-after` (delayed via
     `dispatch_after_f`). Uses `dlsym` for `_dispatch_main_q` (global struct, not pointer).
     Module-level `function-ptr` prevents GC collection. 6 test cases added.
- **Files changed:**
  - `runtime/block.rkt` — nil guard in `make-objc-block`
  - `runtime/main-thread.rkt` — new file (8th runtime module)
  - `tests/test-block-creation.rkt` — 3 new nil-handling tests
  - `tests/test-main-thread.rkt` — new file, 6 tests
  - `tests/test-runtime-load.rkt` — updated for 8 modules, main-thread export checks
- **All tests pass:** 29 Rust crate tests, 64 Racket tests (was 58)

## 2026-04-12 — C-API function emission + contract-based API boundaries

- **Tasks completed:** C-API style emission `[coverage]`, Contract-based API boundaries `[coverage]`
- **Motivation:** Improve Modaliser-Racket by generating the same style of C function
  FFI bindings it currently hand-writes (cgevent.rkt, permissions.rkt, accessibility.rkt).
- **What was done:**
  1. Added 6 synthetic C functions to TestKit fixture (4 emittable + 1 variadic + 1 inline
     for skip-testing) in `test_fixtures.rs`
  2. Created `emit_functions.rs` — new emitter module generating `functions.rkt` per framework
     with `(get-ffi-obj 'Name _fw-lib (_fun types... -> ret))` pattern
  3. Integrated `provide/contract` with TypeRef→contract mapping: primitives → `real?`/
     `exact-integer?`/`exact-nonneg-integer?`/`boolean?`, objects → `cpointer?` or
     `(or/c cpointer? #f)` for nullable, geometry structs → `any/c`, void → `void?`
  4. Wired into `emit_framework.rs` and `main.rkt` — `functions.rkt` generated and re-exported
     when framework has emittable functions
  5. Updated golden files (TestKit, Foundation, AppKit snapshots)
- **Scale:** 86 frameworks now have `functions.rkt` with contract-protected bindings
  (CoreGraphics alone: 777 functions)
- **Files changed:**
  - `generation/crates/emit/src/test_fixtures.rs` — added `Function` import, 6 test functions
  - `generation/crates/emit-racket-oo/src/emit_functions.rs` — new file, 17 unit tests
  - `generation/crates/emit-racket-oo/src/emit_framework.rs` — wire in functions emission
  - `generation/crates/emit-racket-oo/src/lib.rs` — register `emit_functions` module
  - `generation/crates/emit-racket-oo/tests/snapshot_test.rs` — assert functions_emitted count
  - `generation/crates/emit-racket-oo/tests/golden/oo/functions.rkt` — new golden file
  - `generation/crates/emit-racket-oo/tests/golden/oo/main.rkt` — includes functions.rkt
- **All tests pass:** 48 Racket-OO crate tests (was 29), 64 shared emit tests, 19 CLI tests

## Session: Extend contracts to constants and class wrappers (2026-04-12)
- **Task:** Extend `provide/contract` from `functions.rkt` to `constants.rkt` and class wrappers
- **Approach:**
  1. Constants: replaced `(provide (except-out (all-defined-out) _fw-lib))` with
     `(provide/contract [Name contract] ...)` using `map_contract` from `emit_functions`
  2. Class wrappers: replaced `(provide (except-out (all-defined-out) ...))` with
     `(provide/contract [fn-name (-> param-contracts... return-contract)] ...)`
  3. Created context-aware contract mappers for class wrappers:
     - `map_param_contract`: `any/c` for object params (coerce-arg is permissive),
       `(or/c procedure? #f)` for blocks, delegates to `map_contract` for primitives
     - `map_return_contract`: `any/c` for object returns (wrap-objc-object is opaque),
       delegates to `map_contract` for void/primitives
  4. `build_export_contracts` pre-computes all (name, contract) pairs for constructors,
     properties (getters + setters), instance methods, and class methods
- **Design decision:** class wrapper contracts use `any/c` for self parameter because
  `coerce-arg` accepts strings, `objc-object` structs, and raw pointers — a strict
  `cpointer?` would break the ergonomic auto-coercion feature
- **Files changed:**
  - `emit_constants.rs` — `provide/contract` with value contracts, `racket/contract` require
  - `emit_class.rs` — `provide/contract` with arrow contracts, new contract helper functions
  - `emit_functions.rs` — no changes (already had contracts, `map_contract` reused)
  - All 3 golden file suites updated (TestKit, Foundation, AppKit)
- **Tests:** 62 unit tests (was 51) + 3 snapshot suites, all pass. Full workspace clean.
- **Protocol files** remain as a future candidate for contracts

### Session N (2026-04-12) — Protocol file contracts

- **Task:** Protocol file contracts `[coverage]`
- **What was done:**
  1. Added `(require racket/contract)` and replaced the plain `(provide …)` in
     `emit_protocol.rs` with a `(provide/contract …)` form.
  2. Emit two fixed contracts per protocol file:
     - `[make-<proto> (->* () () #:rest (listof (or/c string? procedure?)) any/c)]`
     - `[<proto>-selectors (listof string?)]`
  3. Added 5 unit tests in `emit_protocol.rs` covering:
     `provide/contract` presence, the exact constructor contract string, the exact
     selector-list contract string, mixed-return-type protocols (void/bool/id
     coexisting), and the empty-methods case.
  4. Regenerated 7 protocol golden files under TestKit (2), Foundation (2), and
     AppKit (3) with `UPDATE_GOLDEN=1`.
- **Design decision:** No reuse of `map_param_contract` / `map_return_contract`
  turned out to be needed. The protocol file's only Racket-side exports are the
  variadic `make-<proto>` constructor and the `<proto>-selectors` string list —
  individual delegate method handlers are user-supplied lambdas, not emitted
  bindings, so there is no per-method contract surface in protocol files. The
  backlog description's suggestion to "reuse the contract mappers" was a plausible
  prior — in practice the protocol surface is narrow and fixed.
- **Variadic rest-arg limitation:** Racket `provide/contract` cannot express
  alternation between string and procedure positions in `#:rest` arguments
  (`(listof (or/c string? procedure?))` is the tightest shape), so the contract
  catches "you passed a symbol or number" but not "you passed two strings in a
  row." Getting stronger enforcement would require writing a dependent contract
  combinator, which is out of scope for this task.
- **Files changed:**
  - `emit_protocol.rs` — `provide/contract` form, new constants
    `MAKE_DELEGATE_CONTRACT` and `SELECTOR_LIST_CONTRACT`, new `tests` module
  - 7 golden files (`tests/golden*/oo/protocols/*.rkt`)
- **Tests:** 67 unit tests (was 62) + 3 snapshot suites, all pass.
  `cargo build --workspace` clean.
- **Status:** Contract protection now extends to every FFI boundary in the
  racket-oo emitter: functions, constants, class wrappers, and protocols.

### Session N (2026-04-12) — Verify WebKit emission, uncover contract-migration latent bugs
- **Task:** `Verify WebKit collection and enrichment` — confirm WebKit reaches
  the emitter cleanly and that `WKWebView` / `WKNavigationDelegate` generate
  usable Racket output, to de-risk Mini Browser.
- **What was attempted:**
  1. Walked the pipeline: `WebKit.json` is present in `collection/ir/collected/`,
     `analysis/ir/resolved/`, `annotated/`, and `enriched/`. The overlay
     `_WebKit_SwiftUI.json` is also present at every stage.
  2. Regenerated the full racket-oo target. Generation logs: 283 frameworks,
     7600 files, 0 errors. WebKit specifically: 164 classes, 29 protocols, 196
     files, including `webkit/wkwebview.rkt` (1359 lines) and
     `webkit/protocols/wknavigationdelegate.rkt` (all 15 delegate selectors
     present with correct signatures).
  3. Compiled and loaded each kind of generated file through `racket -e
     '(dynamic-require ... #f)'` to validate them at runtime, not just at the
     text level.
- **What worked:** The generation pipeline and WebKit's IR are sound — emission
  covers WKWebView's full inherited-method surface (NSView/NSResponder lineage)
  with typed `objc_msgSend` bindings for 18 distinct signature shapes, and
  `wknavigationdelegate.rkt` uses the protocol-file pattern correctly.
- **What didn't (and what I fixed):** Runtime loading exposed five latent bugs
  that text-level snapshot tests missed. The whole `provide/contract` migration
  had been merged without any file ever being loaded by Racket.
  1. **Bug A — require conflict on `->`.** `ffi/unsafe` and `racket/contract`
     both export `->` with different semantics (`_fun` arrow vs contract
     arrow). Every class wrapper, `functions.rkt`, and `constants.rkt` failed
     to load with "identifier already required: at: -> in: racket/contract
     also provided by: ffi/unsafe". The emitter source *already* carried the
     fix (`(rename-in racket/contract [-> c->])` + `(c-> ...)` contract
     arrows), but the generated files on disk pre-dated that fix — running
     `cargo run --bin apianyware-macos-generate` republished the fix across
     all 7600 files. Takeaway: the emitter had a committed-but-unregenerated
     fix in the working tree, and the gitignored `generated/` directory
     silently held stale output.
  2. **Bug B — `exact-nonneg-integer?` typo.** Contract mapper in
     `emit_functions.rs` emitted the name `exact-nonneg-integer?`, which
     doesn't exist in Racket — the real predicate is `exact-nonnegative-integer?`
     (full word). Fix: lines 40 and 79 of `emit_functions.rs`; assertions
     updated in `emit_functions.rs` (3 sites) and `emit_constants.rs` (1
     site). `UPDATE_GOLDEN=1 cargo test` regenerated affected golden files;
     all 67 unit tests + 3 snapshot suites pass.
  3. **Bug C — missing geometry struct exports.** `runtime/type-mapping.rkt`
     defined `_NSEdgeInsets`, `_NSDirectionalEdgeInsets`, `_NSAffineTransformStruct`,
     `_CGAffineTransform`, and `_CGVector` via `define-cstruct` but never
     listed them in `(provide ...)`. Every class wrapper that uses these types
     in a method signature (any NSView subclass → `_NSEdgeInsets`; any
     CoreGraphics consumer → `_CGAffineTransform`) failed to load. Added them
     to the provide list. After the fix, `wkwebview.rkt`, `nsarray.rkt`, and
     `wkwebviewconfiguration.rkt` all load cleanly in Racket.
  4. **Bug D — functions.rkt / constants.rkt don't require type-mapping.rkt.**
     Even with Bug C fixed, CoreGraphics `functions.rkt` and Foundation
     `constants.rkt` still fail because `emit_functions.rs` and
     `emit_constants.rs` never emit a require for `runtime/type-mapping.rkt`,
     so the geometry struct identifiers are still unbound in those files.
     Left as a new backlog task (`Emit type-mapping.rkt require in
     functions.rkt and constants.rkt`) — needed a `needs_structs`-style flag
     analogous to the class-wrapper emitter.
  5. **Bug E — sample app import paths broken since `ec82ff0`.** All three
     previously "validated" apps (`hello-window`, `counter`,
     `ui-controls-gallery`) use `../../../generated/oo/...` relative imports
     (31 occurrences total). After commit `ec82ff0` flattened the racket-oo
     target layout, the correct prefix is `../../generated/oo/...` (two levels
     up, not three). The apps have been unloadable since that rename — they
     were never re-validated in the VM after the layout change. Recorded as a
     separate blocking backlog task.
- **Verification commands run:**
  - `cargo test -p apianyware-macos-emit-racket-oo` → 67 + 3 + 0 pass.
  - `cargo run --bin apianyware-macos-generate -- --lang racket-oo` →
    283 frameworks, 7600 files, clean.
  - `racket -e '(dynamic-require "wkwebview.rkt" #f) (displayln ...)'` → OK
  - Same for `wknavigationdelegate.rkt`, `wkwebviewconfiguration.rkt`,
    `wknavigation.rkt`, `nsarray.rkt` → all OK.
  - `racket -e '(dynamic-require "functions.rkt" #f)'` → FAIL on
    `_CGAffineTransform` (Bug D, left for future task).
  - `racket -e '(dynamic-require "constants.rkt" #f)'` → FAIL on
    `_NSEdgeInsets` (Bug D).
  - `racket -e '(dynamic-require "apps/counter/counter.rkt" #f)'` → FAIL on
    relative path (Bug E).
- **Files changed:**
  - `generation/crates/emit-racket-oo/src/emit_functions.rs` — two
    `exact-nonneg-integer?` → `exact-nonnegative-integer?` fixes (lines 40 &
    79), three test-assertion updates
  - `generation/crates/emit-racket-oo/src/emit_constants.rs` — one
    test-assertion update (`test_requires_racket_contract` now checks for
    `(rename-in racket/contract [-> c->])`), one `exact-nonnegative-integer?`
    update
  - `generation/targets/racket-oo/runtime/type-mapping.rkt` — added
    `_NSEdgeInsets`, `_NSDirectionalEdgeInsets`, `_NSAffineTransformStruct`,
    `_CGAffineTransform`, `_CGVector` to provide list
  - `generation/targets/racket-oo/generated/oo/**` — 7600 files regenerated
    (gitignored; each now carries the `(rename-in racket/contract [-> c->])`
    require and `(c-> ...)` contract forms)
  - Golden snapshot files for `TestKit`, Foundation subset, and AppKit subset
    updated via `UPDATE_GOLDEN=1`
- **Status:** WebKit verification is complete: the IR is sound, the emitter
  produces correct Racket for WKWebView and WKNavigationDelegate, and both
  files load in the Racket runtime. Mini Browser is NOT unblocked yet — Bug E
  blocks all app loading and must be fixed before any new app work. Bugs D
  (functions.rkt/constants.rkt require) and E (app import paths) are captured
  as new backlog tasks. The snapshot suite needs runtime loading assertions to
  prevent this class of regression — also captured in Bug D's task.
- **Key discoveries:**
  1. The "86 frameworks" count in `memory.md` refers to frameworks with
     emittable C functions (those whose `functions.rkt` file has content), not
     the class emission set. WebKit has no C functions so it's not in that
     subset, which caused initial confusion. Class emission covers all 283
     frameworks.
  2. Text-level snapshot tests are necessary but insufficient — the whole
     `provide/contract` migration merged green with zero runtime loads. Adding
     a `racket -e '(dynamic-require ...)'` step to the snapshot suite (or a
     separate `raco make` integration test) would have caught Bugs A, B, C, D
     immediately when first introduced.
  3. Gitignored generated output can hide a "source fixed but output stale"
     state indefinitely. Until generation is forced, bugs in old output appear
     live. Worth considering: a pre-commit or CI check that regenerates and
     diffs — but at 7600 files that might be impractical.

### Session (2026-04-12) — type-mapping require in functions.rkt/constants.rkt
- Picked task 2 (type-mapping require) because it is the cleanest of the three
  P0 blockers: well-scoped emitter bug with a known fix pattern, a clear
  precedent (`class_has_struct_types` + `needs_structs` in `emit_class.rs`),
  and unblocks runtime load of CoreGraphics / Foundation FFI files.
- TDD round 1 (RED → GREEN → snapshots):
  - Wrote 5 unit tests in `emit_functions.rs` / `emit_constants.rs` exercising
    the presence/absence of `"../../../runtime/type-mapping.rkt"` in the
    require block: struct param, struct return, struct-typed constant,
    non-struct primitive-only, and a skipped (inline) function whose struct
    type must NOT trigger the require. Watched 3 fail (RED — the negative
    cases already passed by accident because the file never emitted
    type-mapping at all).
  - Fixed by adding `functions_need_structs(&[Function], &dyn FfiTypeMapper)`
    and `constants_need_structs(&[Constant], &dyn FfiTypeMapper)` helpers
    (mirroring `class_has_struct_types` in `shared_signatures.rs`), then
    conditionally appending the runtime require to the top-level
    `(require ...)` form in `generate_functions_file` /
    `generate_constants_file`. All 73 → 74 unit tests green.
  - `UPDATE_GOLDEN=1` regenerated snapshot goldens; Foundation constants.rkt
    golden picked up `"../../../runtime/type-mapping.rkt"` + its full
    provide/contract migration.
- Runtime load verification surfaced **a second missing require** in the same
  class:
  - `racket -e '(dynamic-require "coregraphics/functions.rkt" #f)'` parsed past
    the type-mapping check but then failed with
    `_id: unbound identifier` on
    `CGDirectDisplayCopyCurrentMetalDevice`.
  - Root cause: `_id` comes from `ffi/unsafe/objc`, which `constants.rkt`
    already requires unconditionally but `functions.rkt` never did. Decision:
    add the require unconditionally for parity and to avoid per-function
    `Id`-detection drift.
- TDD round 2:
  - Added `test_functions_file_requires_ffi_unsafe_objc` — watched it RED,
    added the unconditional `ffi/unsafe/objc` line to the require block, then
    GREEN (74 unit tests). Regenerated snapshots.
- Regenerated all 7600 files via
  `cargo run --bin apianyware-macos-generate -- --lang racket-oo`.
- Proof of fix (on-host, no VM needed):
  1. `dynamic-require "coregraphics/functions.rkt"` loads cleanly —
     CoreGraphics exercises BOTH fixes: heavy `_CGAffineTransform` use +
     an object-returning C function that needs `_id`.
  2. A minimal proof file under `generated/oo/_proof/constants.rkt` (same
     relative path depth as real constants.rkt, requires the runtime
     type-mapping module, and defines `NSZeroPoint`/`NSZeroRect` with
     `_NSPoint`/`_NSRect`) loads cleanly — proving the constants.rkt
     require resolves.
- Surprise: Foundation `constants.rkt` and `functions.rkt` still fail at
  load, but with a DIFFERENT class of failure:
  `ffi-obj: could not find export from foreign library: NSHashTableCopyIn`
  (and `NSLocalizedString` in functions.rkt). Both are preprocessor macros,
  not linkable symbols — the ObjC extractor is capturing
  `CXCursor_MacroDefinition` cursors as if they were C constants/functions.
  The generated `get-ffi-obj` call parses fine but blows up at `dlsym` time.
  This is ORTHOGONAL to the type-mapping require bug and only became visible
  because the type-mapping fix let the file reach symbol lookup. Filed as a
  new `[collection]` task in the backlog.
- Final test run: 74 emit-racket-oo unit tests + 3 snapshot suites + full
  `cargo test --workspace` all green.
- Key learnings:
  1. The load-time bug class is recursive: once you fix one missing require,
     the next missing require shows up. The same symptom
     ("unbound identifier") can mask multiple causes. Task 3 (runtime load
     verification in CI) is now even more obviously correct — it would have
     caught both of these at once instead of one on a developer's machine.
  2. "Unconditional require" is the right call for `ffi/unsafe/objc`: cheaper
     than tracking `_id` usage per-file, matches the existing
     `constants.rkt` pattern, and eliminates a whole class of drift.
  3. Runtime load verification catches a THIRD class of bug I wasn't even
     looking for: the macros-as-symbols collection bug. The type-mapping
     require fix let the loader get far enough to surface it. This is
     exactly why "load-time verification is the real acceptance test"
     (memory.md) — snapshot tests would have given us a false "done".
  4. The task description predicted "conditionally emit the require when the
     file uses a geometry struct" and that's exactly what landed for
     type-mapping.rkt. But the sibling `ffi/unsafe/objc` missing-require
     was invisible until host load — neither the task description nor memory
     mentioned it. A generic "run dynamic-require on representative files
     after every emitter change" protocol would have caught this in round 1.

### Session (2026-04-12) — Fix sample app import paths

- **Task:** Fix sample app import paths `[apps]`
- **What was done:**
  - Grep confirmed 3 subdir apps (`hello-window/hello-window.rkt`, `counter/counter.rkt`,
    `ui-controls-gallery/ui-controls-gallery.rkt`) each had `../../../generated/oo/...` and
    `../../../runtime/...` imports — 7 + 9 + 23 = 39 broken occurrences total.
  - From `apps/<name>/file.rkt` the container dir is `apps/<name>/`; `../..` resolves to
    `racket-oo/` (correct), while `../../..` resolves to `targets/` (outside the target
    tree). So the fix is mechanical: drop one `../`.
  - Applied via a single `sed -i '' 's|"\.\./\.\./\.\./|"../../|g' ...` over the three
    files (safe because every such triple-dotdot occurs inside a `(require "...")` path
    in these files — no false positives).
  - Verified post-fix: `ctx_search` reports 0 remaining `../../../` hits under `apps/`.
  - Compile-level verification: `raco make apps/<name>/<name>.rkt` succeeded with exit
    code 0 for all three apps, producing `compiled/<name>_rkt.zo` / `.dep`. This
    exercises the full require graph (runtime + generated/oo/appkit/*.rkt +
    foundation/nsdate.rkt in the gallery) and confirms every path resolves and every
    imported module compiles cleanly on the host.
- **What was learned / surprises:**
  - A fourth file, the *loose* `apps/hello-window.rkt` at apps/ root (dated 2026-03-31,
    older than the subdir restructure), has its own broken paths: it uses
    `../../runtime/...` and `../../generated/oo/...` from apps/ level, which resolve
    one level above `racket-oo/` — wrong. `raco make` on it errors out inside
    cm-minimal.rkt. This file is NOT referenced by the backlog task, its content is an
    independent older implementation (different constants, slightly different layout),
    and it's almost certainly a stale artifact left behind when the app was moved into
    its `hello-window/` subdir. Flagging for triage: either delete, or fix paths to
    `../runtime/...` + `../generated/oo/...`. Recommend delete — keeping two divergent
    `hello-window.rkt` implementations is a hazard.
  - GUI-level verification in TestAnyware VM was **deferred**. The backlog task text
    asks for VM re-validation, but: (a) compile-level verification is strong evidence
    for a path-fix-only change; (b) the VM is cold (`testanyware vm status` shows no
    golden VM, no snapshot, no active session), so setup cost is high for marginal
    additional signal; (c) real runtime verification is the explicit scope of the
    separately-tracked `[testing]` task "Runtime load verification in test suite", and
    per memory.md, that task's real value is a CI-level harness, not a manual one-off
    VM run. So the narrow fix has landed + compile-verified; deeper runtime verification
    will come via task #2 when it's built.
  - `raco make` as a lightweight path-resolution sanity check is safer here than
    `dynamic-require` because the apps' top-level *runs* the event loop
    (`nsapplication-run`), so `dynamic-require` would open a window and block.
    `raco make` compiles the target module without instantiating its body, which is
    exactly what "do the imports resolve?" needs.
- **New backlog item candidate** (for triage phase):
  - Delete or fix the loose `apps/hello-window.rkt` stale file (see above).

### Session — 2026-04-13 — Runtime load verification harness
- **Task:** Runtime load verification in test suite. Picked because (a) it
  was the single cross-cutting blocker for ~6 other backlog tasks, (b) the
  recent core sessions (extract-objc internal-linkage filter, extract-swift
  `s:` filter, extract-swift `c:@macro@` filter — all 2026-04-12/13) made
  landing it more valuable now than before: each fix removed a previously
  latent racket-oo runtime regression surface, and the harness validates
  all three end-to-end in a single landing. Three pending validation tasks
  ("Validate Swift-native filter closure", "Validate `c:@macro@` filter
  closure", and "Runtime load verification" itself) collapsed into one
  session.
- **Design (file: `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`):**
  - **Hermetic tempdir** matching the canonical target tree:
    `<root>/runtime/` (8 files copied from
    `generation/targets/racket-oo/runtime/`),
    `<root>/lib/libAPIAnywareRacket.dylib` (copied if present;
    `swift-helpers.rkt` already degrades gracefully via `with-handlers`
    around `ffi-lib`), `<root>/generated/oo/<fw>/` (emitted via
    `RacketEmitter::emit_framework` for Foundation, AppKit, CoreGraphics,
    CoreText), `<root>/apps/<name>/` (copied from the canonical apps).
    Hermetic so the test does not race the canonical `compiled/` cache and
    can run in parallel with snapshot tests.
  - **Two `#[test]` fns** rather than one combined:
    `runtime_load_libraries_via_dynamic_require` (fast, library load) and
    `runtime_load_apps_via_raco_make` (slow, full compilation). Splitting
    lets each fail independently and lets a future caller skip just the
    slow one if needed.
  - **Library coverage** picks one example per dimension:
    1. `foundation/nsstring.rkt` — class wrapper, `../../../runtime/`
       relative path resolution.
    2. `foundation/protocols/nscopying.rkt` — protocol file,
       `../../../../runtime/` (one level deeper than classes; tested
       independently because the depth difference has bitten before).
    3. `foundation/constants.rkt` — exercises both extract-objc's
       internal-linkage filter (`NSHashTableCopyIn` et al) and extract-swift's
       `s:` filter (`NSLocalizedString`, `NSNotFound`).
    4. `foundation/functions.rkt` — same filters, different binding kind.
    5. `coregraphics/functions.rkt` — geometry-struct require + the
       largest population of `s:`-prefix Swift-native filtered symbols (46).
    6. `coretext/constants.rkt` — `c:@macro@` filter canary (15 of 30
       cleared macro symbols).
  - **App coverage**: all 3 sample apps via a single `raco make`
    invocation. `raco make` compiles the full require graph without
    instantiating the body, so `nsapplication-run` doesn't open a window
    and block the test.
  - **Single racket invocation per test**. The library check builds a
    small racket script that wraps each `dynamic-require` in
    `with-handlers ([exn:fail? ...])`, collects failures into a list, and
    prints a per-path report. Amortises racket startup across all 6 checks.
    The app check uses one `raco make` over all 3 apps.
  - **Skip behaviour**: gated on `RUNTIME_LOAD_TEST=1` (matches the
    `UPDATE_GOLDEN=1` opt-in pattern in the same crate). Auto-skips with
    a clear `SKIPPED:` message if `racket`/`raco` are missing or if the
    enriched IR for any required framework is absent.
- **Implementation gotchas (recorded in memory.md):**
  - **`dynamic-require` rejects raw strings.** First run failed all 6
    checks with `dynamic-require: contract violation, expected:
    module-path? ... given: "/var/folders/.../foundation/nsstring.rkt"`.
    Fix: wrap each path in `(file ,p)` quasi-form. Easy mistake when the
    Rust caller naturally has paths as strings.
  - **`raco --version` exits non-zero.** Initial probe used
    `Command::new("raco").arg("--version")`; raco prints "unrecognized
    argument" and exits 1, so `binary_on_path` reported it missing. Fix:
    `raco help` is the equivalent (prints usage and exits 0). Generalised
    `binary_on_path` to take a per-binary `probe_arg`. The lesson: don't
    assume CLI conventions are uniform across siblings.
- **Validation result — the headline finding.** First post-fix run
  against the on-disk enriched IR produced **exactly the three failures
  the recent core fixes were designed to prevent**:
  1. `NSHashTableCopyIn` from `foundation/constants.rkt` —
     extract-objc internal-linkage filter (fixed 2026-04-12).
  2. `NSLocalizedString` from `foundation/functions.rkt` — extract-swift
     `s:` USR filter (fixed 2026-04-12).
  3. `kCTVersionNumber10_10` from `coretext/constants.rkt` —
     extract-swift `c:@macro@` USR filter (fixed 2026-04-13).
  Each filter's per-frame fix is committed to source on `main`, but the
  on-disk `analysis/ir/enriched/` checkpoint predated all three. Per
  core memory: "Regenerate collected IR before using it as evidence".
  Re-ran `cargo run --release --bin apianyware-macos-collect -- --only
  Foundation,AppKit,CoreGraphics,CoreText,CoreFoundation` (~1s) and
  `cargo run --release --bin apianyware-macos-analyze -- --only ...`
  (~13s). After regeneration: all 6 library checks and all 3 app checks
  pass on the first re-run. End-to-end harness runtime: ~11s libraries,
  ~36s apps.
- **Side effect: snapshot golden refresh.** After regeneration, the
  pre-existing 17-file `M` state in `tests/golden-foundation/` and
  `tests/golden-appkit/` (which had been sitting at session start)
  drifted further: the `provide/contract` migration emission landed in
  a prior session without a golden refresh, so class wrapper goldens
  showed `(except-out (all-defined-out))` while regenerated output now
  showed `provide/contract` blocks. `UPDATE_GOLDEN=1 cargo test -p
  apianyware-macos-emit-racket-oo --test snapshot_test` brought the
  goldens up to date in one pass. The diff is contract-form drift in
  class wrappers plus a +1687-line constants.rkt (Foundation re-emit)
  and minor protocol changes — mechanical and consistent with current
  source. The golden refresh is independent of the harness work; it
  just got reconciled in the same regeneration cycle.
- **Verification:**
  - `cargo test -p apianyware-macos-emit-racket-oo` clean (5 tests:
    snapshot_testkit, snapshot_foundation, snapshot_appkit, both
    runtime_load test fns skip cleanly with `RUNTIME_LOAD_TEST` unset).
  - `RUNTIME_LOAD_TEST=1 cargo test -p apianyware-macos-emit-racket-oo
    --test runtime_load_test` clean: both tests pass.
  - `cargo clippy -p apianyware-macos-emit-racket-oo --tests -- -D
    warnings` clean.
  - `cargo test --workspace` green: zero failures across the entire
    workspace, no regressions in any other crate.
- **Cross-task closure:** "Validate Swift-native symbol filter closure
  in load checks" and "Validate `c:@macro@` filter closure in load
  checks" were both folded into this session's results — each had
  predicted exactly the leaker the harness's first run found, so the
  validation work for both is already discharged. Backlog updated to
  mark both done.
- **Follow-up identified:** The harness covers `coretext/constants.rkt`
  as the canary for the `c:@macro@` filter, but the same filter also
  cleared symbols from AudioToolbox (5), NetworkExtension (5),
  Network (4), and CoreSpotlight (1). All 5 frameworks share the
  single dispatch table in `non_c_linkable_skip_reason`, so the canary
  is theoretically sufficient — but a concrete check on each prevents
  any future single-prefix-family regression. Filed as new
  `[testing]` task "Extend runtime load harness to remaining
  `c:@macro@` framework siblings". Low-cost coverage extension; not a
  blocker for app work.
- **Memory updates:**
  - New entry: "Runtime load verification harness" — file location,
    test split, skip behaviour, hermetic tempdir rationale, library
    coverage breakdown, the standing rule that any new FFI surface
    gets a load check alongside snapshot.
  - New entry: "`dynamic-require` needs `(file ,path)`, not a raw
    string" — the contract violation gotcha.
  - New entry: "`raco` has no `--version` flag" — the probe-arg
    discrepancy.
  - Extended: "Gitignored `generated/` hides source-fixed-but-output-stale
    state" — same trap exists one stage upstream at
    `analysis/ir/enriched/`. The harness is now the regenerate-or-fail
    signal for this class.
- **Meta-learning:** The harness paid for itself in its first run,
  surfacing three orthogonal core-fix validations that would otherwise
  have required three separate manual investigations. The standing
  pattern from core memory ("Backlog task descriptions are hypotheses,
  not diagnoses") inverted neatly here: the hypothesis "the fixes are
  in source, the harness will validate them" turned out to be true,
  but only after the additional inversion "the fixes are in source,
  the on-disk pipeline checkpoints are stale". Two layers of
  evidence-vs-source mismatch in one session, both caught by the
  regenerate-or-fail loop the harness now bakes in.

### Session — 2026-04-13 — Audit `void?` / FFI return-type mismatches
- Picked task: "Audit return-type emission for `void?` contract / FFI
  mismatches". The task was promoted out of the larger "Tighten per-class
  method wrapper contracts" item during the 2026-04-12 triage on the
  grounds that an embedded validation step inside a larger task is
  invisible to future work phases. That promotion turned out to be the
  right call — the audit landed in a single work session with concrete
  source changes and a green runtime load harness, completely unblocked
  by the still-open contract tightening agenda.
- The original Modaliser-Racket bug was diagnosed last cycle as
  "garbage `_id` rejected by `void?` contract on `nsapplication-set-
  delegate!`" and fixed by wrapping `tell` in `(void ...)`. That fix
  satisfied the Racket contract checker but did **not** correct the
  underlying calling-convention mismatch: Racket's `tell` form defaults
  to `#:type _id`, so the underlying `objc_msgSend` binding is created
  as `(_fun ... -> _id)` regardless of whether the C method actually
  returns void. For genuinely void-returning methods, this reads
  whatever happens to be in the return register as a tagged pointer —
  benign on most x86_64/arm64 calling conventions, undefined behaviour
  on arm64e (PAC), and just wrong as a contract about the binding.
- Static audit walked every `void?` emission site in `emit_class.rs`
  and cross-referenced each against its FFI dispatch path:
  - **Property getters (lines 580/589):** already use `tell #:type
    <ffi_type>`, so the FFI binding matches the IR type. Not affected.
  - **Property setters, non-`_id` case (lines 615–642):** already
    emit `_void` in the explicit `_fun ... -> _void` signature. Safe.
  - **Property setters, `_id` case (lines 605–614):** wrapped in
    `(void (tell ...))`. **MISMATCH.** Underlying tell is `_id`-typed.
  - **Methods, Tell dispatch + `ret_is_void` (lines 701–703):** wrapped
    in `(void (tell ...))`. **MISMATCH.** Same root cause.
  - **Methods, TypedMsgSend (lines 708–793):** uses
    `mapper.map_type(&method.return_type, true)` for the FFI return
    type, which yields `_void` for void Primitive returns. Safe on
    both the SignatureMap path and the inline `objc_msgSend` path.
  - **Constructors:** never void. Not affected.
  - `emit_functions.rs` (C functions) uses `mapper.map_type(...,
    true)` for `_fun ... -> _void` and `map_contract(..., true)` for
    `void?` contracts in lockstep. Safe.
- TDD cycle: added three inline tests under `emit_class::tests`:
  `test_id_property_setter_body_uses_void_typed_tell` (asserts the new
  setter body and that `(void (tell` is absent from the output),
  `test_void_method_tell_dispatch_uses_void_typed_tell` (one-arg void
  method body), and `test_void_zero_arg_tell_dispatch_uses_void_typed_
  tell` (zero-arg case for `dealloc`-style methods). Ran red — confirmed
  the existing emitter still produced `(void (tell ...))`. Then
  replaced the two emit sites with `tell #:type _void`:
  - `emit_property` `_id` setter:
    `(tell #:type _void (coerce-arg self) setX: (coerce-arg value))`
  - `emit_method` Tell + ret_is_void:
    `(tell #:type _void target args)`
  Both forms drop the outer `(void ...)` wrapper — a `_void`-typed
  `tell` already evaluates to `(void)` in Racket, so wrapping it again
  is redundant. Reran the three new tests green.
- Fallout: all three snapshot suites diffed (TestKit + Foundation
  subset + AppKit subset) — every void setter and dealloc/setNeedsX
  body was using the old form. Regenerated via
  `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket-oo`. The
  snapshot diffs are mechanical: each `(void (tell foo ...))` becomes
  `(tell #:type _void foo ...)`. No body restructuring, no contract
  changes (the `void?` contract still fits, just for the right reason
  now).
- Validation: `RUNTIME_LOAD_TEST=1 cargo test -p apianyware-macos-emit-
  racket-oo --test runtime_load_test` — both tests green in 38s
  (libraries `dynamic-require` + `raco make` of all 3 sample apps).
  Then `cargo test --workspace` clean across every crate. Final
  repo-wide grep for `(void (tell` matched only the negative-assertion
  test code in `emit_class.rs`, confirming no live emission site
  remains.
- What this confirms about the standing rule "snapshots verify text,
  the harness verifies the load": the harness was green even before
  this fix. The bug was *latent* — current arm64 (M1, no PAC) Racket
  FFI doesn't trap on cross-typed return reads, so `(void (tell ...))`
  has been silently working for as long as it's been emitted. The
  audit was specifically about *contract correctness in the absence of
  an observable failure*, which is exactly the kind of work that needs
  static analysis backed by snapshot regeneration rather than
  runtime-failure-driven fixes. The harness's role here was a
  no-regression check, not a discovery mechanism.
- What this *doesn't* fix: the larger contract tightening task
  (`self`-as-`cpointer?`, nullable `_id` params, `Selector`/`sel?`,
  class-specific predicates) is unchanged and still queued — it
  addresses a different class of bug (loose param contracts that don't
  reject obviously-wrong callers). That separation was the point of
  promoting this audit to its own task.
- Files touched: `generation/crates/emit-racket-oo/src/emit_class.rs`
  (2 emit sites + 3 new tests), and the regenerated golden trees at
  `generation/crates/emit-racket-oo/tests/golden-foundation/`,
  `tests/golden-appkit/`, and `tests/golden/snapshot/`.
- Connection to the existing memory entry "Runtime loading is the real
  acceptance test (and failures cascade)": the cascade story is about
  load-time failures masking each other. This session's bug is the
  *opposite* shape — a load-time pass masking a latent ABI mismatch.
  Both shapes argue for the same standing rule (text snapshots + load
  harness, neither one alone), but they argue for it from different
  directions. Worth distilling in the next reflect cycle.

### Session (2026-04-13) — Cleanup bundle: tasks 1, 2, 12, 13, 11 (partial)
- Worked five tasks in sequence in one work phase. Three trivial/mechanical
  wins, one pure refactor, one genuinely scope-significant win with three
  residual sub-items deferred.

- **Task 1 (prune stale `memory.md` entry).** Deleted the
  `CoreFoundation.CFStringEncoding` "Known type mapper limitations"
  section in `LLM_STATE/targets/racket-oo/memory.md`. Single-section
  delete; no downstream effect. Last stale item in that stack.

- **Task 2 (delete stale `apps/hello-window.rkt`).** Verified orphaned
  via `ctx_search` — only self-reference, backlog mention, and session
  log reference. Removed. The canonical
  `apps/hello-window/hello-window.rkt` (inside the per-app subdir) is
  untouched. No test or build step references the loose file.

- **Task 12 (extend runtime load harness to `c:@macro@` siblings) —
  ATTEMPTED, REVERTED, uncovered a real bug.** The task's premise was
  that CoreText is a sufficient canary for the `c:@macro@` filter, and
  adding AudioToolbox/NetworkExtension/Network/CoreSpotlight would be
  pure coverage-insurance. Reality: all four sibling checks failed at
  `dynamic-require` with `dlsym` "symbol not found" errors. The harness
  is doing exactly what it was built to do — it caught four real
  filter gaps that text-level snapshots and the current harness coverage
  were missing. Specific leaks observed:

    1. `kAudioServicesDetailIntendedSpatialExperience` in AudioToolbox,
       `AudioServices.h:401`, ObjC source, USR
       `c:@kAudioServicesDetailIntendedSpatialExperience`. A bare
       `c:@<name>` USR is *not* `@macro@` and is *not* internal-linkage —
       it is a preprocessor macro that libclang exposes with a naked
       cursor. Neither extract-objc nor extract-swift filter chains
       catch it.
    2. `nw_browse_result_change_identical` in Network, Swift source,
       USR `c:@Ea@nw_browse_result_change_invalid@nw_browse_result_change_identical`.
       `Ea` is clang's USR prefix for "enum anonymous"; this is an
       anonymous-enum member being extracted as a standalone constant.
       Arguably the fix here is to *not* emit anonymous-enum members
       as constants in the first place.
    3. `NEFilterFlowBytesMax` in NetworkExtension, and
       `CoreSpotlightAPIVersion` in CoreSpotlight. Both *are* correctly
       placed in `swift.skipped_symbols` at the extract-swift stage
       — I verified this in `collection/ir/collected/{NetworkExtension,CoreSpotlight}.json`.
       But they appear as live constants in the `resolved/`,
       `annotated/`, and `enriched/` IR. Somewhere between collected
       and resolved (or perhaps in the merge step of extract-swift
       itself, since the collected JSON is already post-merge),
       a filtered symbol is being promoted back into the constants
       list. `build_resolved_framework` in `analysis/crates/resolve/src/checkpoint.rs`
       only clones `collected` and populates class fields — it does
       not touch constants — so the leak is upstream of that.

  I reverted the harness extension (both the `REQUIRED_FRAMEWORKS` and
  `LIBRARY_LOAD_CHECKS` additions) so the harness stays green, marked
  the original task as `blocked`, and added a new high-priority
  backlog entry "Non-linkable symbol leaks beyond the `c:@macro@`
  filter" (category: `[collection]`) with all four diagnostic
  findings written up. This is exactly the "discover what needs doing
  by doing adjacent things" pattern the backlog-plan spec describes —
  a supposedly-trivial coverage extension surfaced a real collection-level
  regression.

- **Task 13 (consolidate `needs_structs` helpers).** Pure refactor.
  Introduced `any_struct_type<'a, I>(type_refs: I, mapper: &dyn FfiTypeMapper) -> bool`
  in `shared_signatures.rs`. Rewrote `class_has_struct_types` to build
  its type-ref iterator inline and delegate; rewrote
  `generate_functions_file` and `generate_constants_file` similarly and
  deleted the standalone `functions_need_structs` and
  `constants_need_structs` helpers. No behavioural change; all 77 lib
  tests and 3 snapshot tests pass unchanged. The memory entry about
  "update three sites in lockstep" is now fixed at the code level —
  the iterator-construction lives with each caller but the struct
  check lives in one place. (Note: the underlying "what counts as a
  geometry struct" decision was already centralized in
  `emit/src/ffi_type_mapping.rs::is_known_geometry_struct`, so adding
  a new geometry cstruct only ever required one allowlist update
  anyway — the three-site coupling was more theoretical than the
  memory entry implied.)

- **Task 11 (tighten per-class method wrapper contracts) — partial.**
  Implemented item 1 "self tightening": added a `SELF_CONTRACT`
  constant (`"objc-object?"`) in `emit_class.rs` and routed
  instance-method contracts, instance-property getters, and
  instance-property setters through it. `objc-object?` is exported
  from `runtime/objc-base.rkt` and re-exported by `coerce.rkt`, so
  it is already in scope in every emitted class wrapper — no
  runtime change required. Updated 5 unit tests and regenerated
  snapshot goldens (`UPDATE_GOLDEN=1`). Runtime load harness
  re-run with `RUNTIME_LOAD_TEST=1`: libraries via
  `dynamic-require` all pass, sample apps via `raco make` all
  compile. Total runtime 38s — no regression from baseline.

  **What self tightening actually catches.** Previously any Racket
  value would satisfy the self contract (`any/c`); a user passing a
  number or string or `#f` or a stale cpointer would get a generic
  failure deep inside `coerce-arg` or, worse, a segfault/PAC trap
  inside `objc_msgSend`. Now the contract boundary rejects
  non-`objc-object?` values immediately with blame on the caller.
  This is a direct answer to the Modaliser-Racket Task 1 complaint
  "bindings silently accept wrong types" for the most common misuse
  case.

  **What I deliberately did not tighten.** Items 2 (nullable `_id`
  params), 3 (class-specific predicates), 4 (Selector / `sel?`) are
  left as residual sub-items on the same task. Item 2 as spec'd
  literally (`(or/c any/c #f)`) is a semantic no-op; a better
  version (`(or/c string? objc-object? cpointer? [#f])` mirroring
  `coerce-arg`'s accept list) is available and would be pure win,
  but requires touching `map_param_contract` to consult
  `type_ref.nullable` and would shift every object-typed param in
  every snapshot — a full regeneration pass worth scheduling
  independently. Item 3 is marked stretch. Item 4 needs a runtime
  decision (expose a `sel?` alias, or accept `cpointer?` as the
  permanent contract). All three are captured in the task's
  "Residual sub-items" section in backlog.md.

- **Key learnings.**
  - The "run four cheap tasks in a row" pattern works well when
    at least one of them is a real refactor or win. The three
    cleanup tasks would have been 15 minutes each in isolation;
    batching them with 11 and 13 gave me a natural place to push
    until the context budget tightened.
  - The harness-catches-real-bugs outcome from Task 12 is exactly
    the standing-rule validation for memory.md's "Runtime loading
    is the real acceptance test" entry. The same class of cascade
    (fix one filter gap, discover the next) applies to filter
    families, not just emission-site bugs.
  - `objc-object?` being already-in-scope in every class wrapper
    (via `coerce.rkt` re-exporting from `objc-base.rkt`) is a
    small but load-bearing architectural choice. It meant the
    self tightening was a one-line constant change in the emitter
    rather than a runtime-side refactor plus emitter change.
  - The memory entry "Consolidating the three `needs_structs`
    helpers into one shared utility is a latent refactor"
    overstated the risk: the geometry-struct decision was already
    centralized in the FFI mapper. The real duplication was
    boilerplate, not decision drift. Worth refining in the next
    reflect cycle.
