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
7 library `dynamic-require` checks across class wrapper, protocol file, Foundation
+ CoreGraphics + CoreText functions/constants, AppKit `nsmenuitem.rkt`
(class-property canary), plus `raco make` of all 4 sample apps,
gated on `RUNTIME_LOAD_TEST=1` (~47s end-to-end). Class-property setter
arity bug fixed (2026-04-15) — setters now omit self for class properties. `_id`
parameter contracts tightened with nullable marking (2026-04-15) — non-nullable
params get 3-element union, nullable get 4-element with `#f`, matching
`coerce-arg`'s accepted set exactly. All three recent core filter fixes
(extract-objc internal-linkage, extract-swift `s:` family, extract-swift `c:@macro@`
family) validated end-to-end against fresh IR. Self-parameter contracts tightened to
`objc-object?` in every class wrapper — the biggest single misuse vector is now
rejected at the wrapper boundary. Accumulated WIP committed and pushed (f7a906c,
2026-04-15). File Lister app landed 2026-04-15 (structural verification
only — compiles clean under `raco make` in both direct and hermetic
harness trees; full GUI smoke in TestAnyware VM still pending). Next
focus: remaining sample apps (Menu Bar Tool → Text Editor → Mini
Browser), then OO style analysis and coverage expansion. Sample apps
are no longer blocked.

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

## Task Backlog

### Menu Bar Tool app `[apps]`
- **Status:** not_started
- **Dependencies:** none; independent of File Lister (which shipped
  2026-04-15, structural verification only)
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard. Tests
  an unusual app lifecycle (no main window, status item driven) and menu
  construction. GCD main-thread dispatch helpers in `main-thread.rkt` are already
  in place for timer callbacks.
  See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Text Editor app `[apps]`
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

### Class-specific runtime predicates `[emission]` _(stretch)_
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
    **return** contracts. The "amortise golden churn with the `_id`
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
    *actually invokes* a class-returning method on a real instance
    and verifies the predicate passes — the existing load-only
    checks cannot observe a contract mismatch that only fires at
    return time.
  - **Golden churn scale:** every class wrapper with an object
    return (most of them). Different cells from the `_id` nullable
    tightening, no savings from running them back-to-back.
- **Blocking decision:** pick a hosting model (A / B / C) before
  implementation starts. Record the decision in a memory entry even
  if A wins by default.
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
  paradigm-appropriate examples for both OO and functional styles. Must include
  threading/callback safety constraints discovered by Modaliser-Racket:
  `_cprocedure` callbacks SIGILL from foreign OS threads (GCD workers,
  libdispatch), `#:async-apply` deadlocks under `nsapplication-run`, safe
  alternatives (`call-on-main-thread`, `dynamic-place` for I/O), and the
  place-backed async facade pattern for Cocoa integration. Any generated binding
  exposing a C callback type should carry a warning about the foreign-thread
  constraint.
- **Results:** _pending_

### Coverage gaps discovered by Modaliser-Racket Task #7 `[coverage]`
- **Status:** not_started
- **Surfaced:** 2026-04-15 by Modaliser-Racket Task #7 (replace
  hand-written `ffi/*.rkt` with generated bindings). One module
  (`ffi/cgevent-emitter.rkt`) successfully migrated in Phase 1 using
  `only-in` imports from `coregraphics/functions.rkt`,
  `corefoundation/functions.rkt`, and `corefoundation/constants.rkt`
  (including global-variable constant `kCFRunLoopCommonModes` via
  `get-ffi-obj` path — confirmed working end-to-end). Full test suite
  (26/26) passes green after migration. Remaining four modules
  (`cgevent.rkt`, `accessibility.rkt`, `permissions.rkt`, `main-thread.rkt`)
  blocked on the gaps below.
- **Dependencies:** none — all gaps are in the input header-set or the
  enum-emission pass.
- **Description:** Modaliser's hand-written `ffi/*.rkt` modules call
  symbols from frameworks and headers that the racket-oo target does not
  currently emit. Each gap blocks one or more migration tasks downstream:

  1. **`ApplicationServices.framework` AX functions** — `AXIsProcessTrusted`,
     `AXIsProcessTrustedWithOptions`, `AXUIElementCreateApplication`,
     `AXUIElementCopyAttributeValue`, `AXUIElementSetAttributeValue`,
     `AXUIElementCopyAttributeNames`, `AXUIElementGetPid`, `AXValueCreate`,
     `AXValueGetValue`. These live in the `HIServices` private subframework
     of `ApplicationServices`. The current `applicationservices/main.rkt`
     is an 8-line stub — no `functions.rkt` emitted at all. The
     `accessibility/` framework dir under `generated/oo/` covers AX-prefixed
     UI-element APIs (charts, braille, math expressions) but not the
     trust/element/value functions Modaliser needs. Either expand the
     existing `applicationservices` emission to include HIServices or add
     a new `hiservices` framework dir.

     Constants needed: `kAXTrustedCheckOptionPrompt`, `kAXErrorSuccess`,
     `kAXValueCGPointType`, `kAXValueCGSizeType`, plus the `kAX*Attribute`
     CFSTR macros (`kAXMainAttribute`, `kAXFocusedAttribute`,
     `kAXRaiseAction`, `kAXWindowsAttribute`, `kAXTitleAttribute`,
     `kAXPositionAttribute`, `kAXSizeAttribute`, `kAXFullScreenAttribute`).
     Modaliser currently builds these at runtime via
     `CFStringCreateWithCString` — the AX constants are exported as
     `CFSTR("...")` macros, not symbols, so the generator has to
     pre-create them or expose a recipe.

  2. **`libdispatch` (`/usr/lib/system/libdispatch.dylib`)** —
     `dispatch_async_f`, `dispatch_after_f`, `dispatch_time`,
     `pthread_main_np`. Plus the `_dispatch_main_q` C global, which
     `dispatch_get_main_queue()` expands to as `&_dispatch_main_q`.
     The good news is racket-oo *already* handles CFStringRef globals
     via `(get-ffi-obj 'kCFRunLoopCommonModes _fw-lib _pointer)` (see
     `corefoundation/constants.rkt:541`), so `_dispatch_main_q` should
     drop into the same emission path — the blocker is the libdispatch
     headers being absent from the input header-set.

     `pthread_main_np` lives in `pthread.h` (libsystem). Decide
     whether to add a `libsystem`/`pthread` framework dir or fold these
     into a catch-all "system" target.

  3. **`libobjc` runtime (`/usr/lib/libobjc.A.dylib`)** —
     `objc_allocateClassPair`, `class_addMethod`, `objc_registerClassPair`,
     `objc_msgSend` (variadic — already partially handled via the
     `tell` macro, but the raw-form is needed for dynamic class creation),
     `class_getInstanceMethod`, `method_getTypeEncoding`. Used by
     Modaliser's `panel-manager.rkt` for the `ModaliserKeyablePanel`
     dynamic ObjC subclass that overrides `canBecomeKeyWindow → YES`.
     This is borderline — dynamic class creation is rare enough that
     consumers might justifiably keep it as hand-written FFI rather
     than go through generated bindings. Worth a design call before
     committing to emit it.

  4. **CG enum category values are empty stubs** — Discovered during
     the `cgevent-emitter.rkt` migration. `coregraphics/enums.rkt` lists
     `;; CGEventField`, `;; CGEventSourceStateID`, `;; CGEventTapLocation`,
     `;; CGEventType`, `;; CGEventTapPlacement`, `;; CGEventTapOptions`
     etc. as bare comment headers but emits zero values for any of them.
     So consumers currently have to redefine
     `kCGEventSourceStateCombinedSessionState=0`, `kCGHIDEventTap=0`,
     `kCGSessionEventTap=1`, `kCGHeadInsertEventTap=0`,
     `kCGEventTapOptionDefault=0`, `kCGEventKeyDown=10`, `kCGEventKeyUp=11`,
     `kCGKeyboardEventKeycode=9`, `kCGEventTapDisabledByTimeout=0xFFFFFFFE`,
     `kCGEventTapDisabledByUserInput=0xFFFFFFFF` locally — which defeats
     the point of generated bindings.

     Likely root cause: the generator's enum scanner skips `CF_ENUM` /
     `CG_ENUM` typedef'd enums where the values are macros rather than
     `enum` constants, or the input filter is dropping the enum
     declarations entirely. Investigate `extract-objc`'s enum-handling
     branch and confirm against the CoreGraphics public headers.
     This bug is probably not specific to CoreGraphics — every
     framework's `enums.rkt` should be audited for empty-stub
     categories.

- **How Modaliser-Racket consumes this:** Each fix unblocks a specific
  migration task in Modaliser-Racket Task #7. After all four gaps are
  closed, Modaliser can drop its `ffi/` directory entirely (~5 hand-
  written modules totalling ~600 lines of `get-ffi-obj` boilerplate)
  and depend purely on generated bindings. Modaliser's
  `tests/run-all.sh` (26 files, ~55 s) is a free downstream
  integration test for any AX/CGEvent/libdispatch additions —
  rebuild Modaliser against the new bindings and run the suite.
- **Results:** _pending_

## Completed Tasks

### Sample-app bundling (stub-launcher + bundle-racket-oo crate) `[packaging]`
- **Completed:** 2026-04-15
- **Summary:** Racket-OO sample apps are now shippable as first-class
  macOS `.app` bundles. Split into two crates with a clean separation
  of concerns:
  - **`apianyware-macos-stub-launcher`** (pre-existing, not touched):
    language-agnostic `.app` skeleton generator — Swift stub source,
    `swiftc` compile, `Info.plist`, bundle assembly.
  - **`apianyware-macos-bundle-racket-oo`** (new crate): racket-oo
    bundling conventions. Walks the entry script's transitive
    `(require ...)` tree via a pure-Rust string-literal scanner,
    discovers every `.rkt` dependency under `generation/targets/racket-oo/`,
    and copies that subset into `Resources/racket-app/<rel>` mirroring
    the source layout so relative requires keep resolving from inside
    the bundle. Reads the human-readable display name from each app's
    `knowledge/apps/<script>/spec.md` first H1 (so `ui-controls-gallery`
    → `UI Controls Gallery`, not `Ui Controls Gallery`). Bundle id is
    derived from the display name as `com.apianyware.<NoSpace>`. The
    optional `lib/libAPIAnywareRacket.dylib` is copied if present.
- **Shared app-menu helper:** new `runtime/app-menu.rkt` exposes
  `install-standard-app-menu!` that every sample app now calls with
  its display name. Installs the standard About / Hide / Hide Others
  / Show All / Quit items with the expected keyboard equivalents
  (⌘Q, ⌘H, ⌥⌘H). Uses raw typed `objc_msgSend` rather than `tell`
  because `tell` fails its `_id` check on the SEL argument to
  `addItemWithTitle:action:keyEquivalent:`. Also fixes a latent bug
  in `runtime/objc-base.rkt`'s `as-id`: the `objc-object?` branch
  wasn't casting to `_id`, which made the function useless for its
  stated purpose. Fixed so both branches cast.
- **CLI:** `cargo run --example bundle_app -p apianyware-macos-bundle-racket-oo -- <script-name>`
  builds a single app; `-- --all` walks `apps/` and builds every
  sample app that has an `apps/<name>/<name>.rkt` entry.
- **All four sample apps now bundle cleanly** (hello-window, counter,
  ui-controls-gallery, file-lister), each producing an `.app` with
  the right `CFBundleName`, the correct menu-bar identity via
  LaunchServices, and the standard macOS menu items. Verified
  end-to-end in the GUIVisionVMDriver VM — screenshot shows Counter's
  menu bar reading "Counter" with the full About / Hide / Quit
  submenu, keyboard shortcuts present.
- **Testing:** 19 unit tests in `bundle-racket-oo` (deps walker, spec
  reader, AppSpec constructors) + 4 integration tests (bundle file-
  lister, bundle every app under `apps/`, reject missing app, root
  sanity). The `bundles_every_sample_app` test auto-discovers apps
  by directory walk, so adding a new sample app lights up coverage
  without touching the test.
- **Runtime-load harness update:** `runtime/app-menu.rkt` added to
  `RUNTIME_FILES` in `tests/runtime_load_test.rs`. `APPS` bumped to
  include all 4 sample apps. `RUNTIME_LOAD_TEST=1 cargo test -p
  apianyware-macos-emit-racket-oo --test runtime_load_test` → both
  tests green. Full `cargo test --workspace` → exit 0, 484 passes,
  0 failures.
- **Docs:** README gets a new two-tier "App Bundling" section
  explaining the stub-launcher ↔ bundle-racket-oo split and showing
  the CLI. Workspace structure listing and Target Languages table
  updated. `knowledge/targets/racket-oo.md` gets a new "Sample app
  bundling" section, a "Toolbar baseline alignment" section, and
  2026-04-15 dated discoveries (NSProcessInfo filtered, arm64 x0
  smuggle for NSInteger return, NSStackView firstBaseline pattern,
  `as-id` cast bug, `minimal-racket` lacks `raco make`).
- **`.gitignore`:** `generation/targets/*/apps/*/build/` added.
- **Suggests next:** stretch goal is teaching
  `apianyware-macos-generate` to auto-bundle sample apps after a
  successful emission run. Out of scope for this round — bundling
  is a separate lifecycle step per the user's intent.

### File Lister app `[apps]`
- **Completed:** 2026-04-15 (structural only; GUI smoke pending)
- **App file:** `generation/targets/racket-oo/apps/file-lister/file-lister.rkt`
- **Summary:** Three-column NSTableView (Name / Size / Modified) driven
  by an NSTableViewDataSource delegate, NSOpenPanel modal directory
  picker, NSFileManager `contentsOfDirectoryAtPath:error:` for listing,
  and Racket built-ins (`file-size`, `file-or-directory-modify-seconds`)
  for size/date formatting. Scope-traded NSDictionary attribute
  extraction (NSNumber/NSDate) out: the bindings don't yet expose
  ergonomic extraction helpers and the point of the task was exercising
  the delegate pattern, not every API in the spec.
- **Delegate-runtime discoveries** (new surface, not previously used):
  - **NSTableViewDataSource's NSInteger return.** `delegate.rkt` only
    supports `'void` / `'bool` / `'id` return kinds. `numberOfRowsInTableView:`
    returns NSInteger. Worked around by declaring the method `'id` and
    returning `(ptr-add #f count)` — on arm64 both return types live in
    x0, and the ObjC caller (NSTableView) reads x0 as NSInteger without
    consulting the method's type encoding, so the pointer's address
    bits pass through cleanly as the row count. Fully documented with
    a comment block in the app. **Standing follow-up** (not promoted to
    a task yet): a real fix would add `'int` / `'long` kinds to
    `delegate.rkt` + the Swift trampoline, which is more work than this
    one app warrants. Recording the smuggle pattern here so Menu Bar
    Tool / Text Editor can reuse it without re-deriving.
  - **Raw-pointer args in delegate callbacks.** The trampoline passes
    every arg as `_pointer` (cpointer), not `objc-object`. Class
    wrapper self-contracts are strict `objc-object?`, so calling
    e.g. `nstablecolumn-identifier` on the raw `col` pointer from the
    `tableView:objectValueForTableColumn:row:` callback would fail the
    contract. The app routes column-identity through `(tell (cast col
    _pointer _id) identifier)` — direct `tell` bypasses the wrapper
    layer. Memory.md already records the self-contract policy; this
    adds the practical consequence for delegate handlers. Note: the
    existing `ui-controls-gallery.rkt` radio callback passes `sender`
    (also a raw cpointer) straight to `nsbutton-set-int-value!`, which
    would fail the `objc-object?` self contract if actually invoked —
    previously invisible because that code path only fires on a radio
    click and the gallery's GUI test pass predates the contract
    tightening. Not fixing here (different task, different app), but
    worth flagging.
  - **Row index extraction.** The `row` arg arrives as a cpointer whose
    address bits are the integer value. `(cast row-ptr _pointer _int64)`
    reads those bits as a Racket exact integer. Mirror of the number-of-
    rows smuggle on the output side.
  - **NSString return from objectValue callback.** Built with
    `string->nsstring` (CFString, +1 retained) then `tell autorelease`
    to hand +0 ownership back to NSTableView. Autorelease pool drain
    happens on the next event-loop turn, which keeps cell-drawing
    memory bounded. Not a leak.
- **Harness update:** added `"file-lister"` to `APPS` in
  `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`. The
  `runtime_load_apps_via_raco_make` test now compiles 4 apps in the
  hermetic tempdir; runtime jumped from ~40s to ~47s as expected.
- **Verification:** `raco make` on the app in the live target tree
  (exit 0); `RUNTIME_LOAD_TEST=1 cargo test -p apianyware-macos-emit-racket-oo
  --test runtime_load_test` both tests green in 46.90s; full
  `cargo test -p apianyware-macos-emit-racket-oo` green (82 lib unit +
  3 snapshot + 2 runtime-load). No golden regeneration needed — the app
  doesn't touch the emitter. **Not yet verified:** GUI smoke test in
  TestAnyware VM. Follows the same pattern as the existing three apps
  (compile-only structural check for initial landing; VM workflow is
  separate QA).
- **Suggests next:** Menu Bar Tool next (independent, different
  lifecycle). If anyone takes Text Editor before Menu Bar Tool, it can
  now reuse the delegate pointer-smuggle pattern for NSUndoManager
  callbacks if they ever hit a non-id/bool/void return type. Also: a
  full GUI verification pass across all 4 apps in the VM is worth
  scheduling as a batched follow-up — compile success says the require
  graph resolves, not that the window actually opens without a
  contract violation or missing selector at runtime.

### Tighten `_id` parameter contracts with nullable marking `[emission]`
- **Completed:** 2026-04-15
- **Summary:** `map_param_contract` in
  `generation/crates/emit-racket-oo/src/emit_class.rs` now consults
  `type_ref.nullable` for `TypeRefKind::Class | Id | Instancetype` and
  returns `(or/c string? objc-object? cpointer?)` (non-nullable) or
  `(or/c string? objc-object? cpointer? #f)` (nullable). The union
  mirrors `coerce-arg`'s accepted set in `runtime/coerce.rkt` exactly,
  so the change is ergonomics-neutral but catches numbers / symbols /
  lists / non-coerce-compatible pointers at the wrapper boundary with
  caller blame instead of bubbling up a `coerce-arg` `else`-branch
  error. (The task description pointed at `emit_functions.rs` — the
  function actually lives in `emit_class.rs`, because `emit_functions`
  covers C-API functions while class wrappers own their own param
  contract mapper.)
- **Tests:** 4 new unit tests in `emit_class::tests`
  (`test_map_param_contract_nullable_id`,
  `test_map_param_contract_class_types`,
  `test_map_param_contract_instancetype`, plus the existing
  `test_map_param_contract_coercion` updated to the new expectation).
  Two pre-existing tests rewritten for the new string
  (`test_property_setter_contract`,
  `test_class_property_setter_impl_and_contract_agree`). 82 lib unit
  tests green.
- **Golden churn:** 25 golden files regenerated under
  `UPDATE_GOLDEN=1`: 2 TestKit (`tkview.rkt`, `tkbutton.rkt`), 12
  Foundation subset (nsarray, nsdateformatter, nserror, nsfilemanager,
  nslock, nsnotificationcenter, nsstring, nstimer, nsurl,
  nsuserdefaults, …), 11 AppKit subset (nsapplication, nsbutton,
  nscolor, nscontrol, nsimage, nsmenu, nsmenuitem, nssplitview,
  nsview, nswindow, nswindowcontroller, …). Spot-checked diffs: `_id`
  setters with a nullable property type now carry the `#f` variant;
  non-nullable constructor params (e.g.
  `make-nsbutton-init-with-coder`) carry the 3-element variant.
  Getters remain on `any/c` — returns are out of scope (queued for
  the "Class-specific runtime predicates" task which will touch
  `map_return_contract`).
- **Verification:** `RUNTIME_LOAD_TEST=1` harness green (~40s, 7
  library `dynamic-require` checks + `raco make` of all 3 sample
  apps). Full `cargo test -p apianyware-macos-emit-racket-oo` green
  (82 unit + 3 snapshot + 2 runtime-load). Fresh AppKit IR already
  carries correct nullable flags from the extractor's
  `_Nullable`/`_Nonnull` handling, so the tightening exercises real
  SDK annotations end-to-end.
- **Suggests next:** the stretch "Class-specific runtime predicates"
  task can now amortise its snapshot churn by reusing the
  just-regenerated golden set if scheduled soon — touching
  `map_return_contract` (currently `any/c` for object returns) would
  rewrite the getter contracts. Scheduling gap: the longer the delay,
  the more unrelated drift rides in on the next regeneration pass.

### Commit accumulated emitter changes `[emission]`
- **Completed:** 2026-04-15
- **Commit:** f7a906c ("Accumulated WIP: runtime load harness, contract
  tightening, appkit goldens, pipeline polish"), pushed to origin/main.
- **Summary:** Scope was broader than the task framing suggested — not
  just the emitter, but also collection filters (internal-linkage,
  platform-availability, swift-USR `s:` and `c:@macro@`), analysis
  (new `annotate/src/llm.rs`, `resolve/tests/synthetic_resolution.rs`),
  new `stub-launcher` crate (Swift stub binaries for per-app TCC),
  runtime `main-thread.rkt` (GCD dispatch), hello-window app
  subdirectory migration, appkit golden set (23 files), foundation
  golden regeneration, and LLM_CONTEXT migration cleanup. Landed as
  one commit because cross-cutting dependencies (types/ir.rs, new
  `skipped_symbol_reason`, `shared_signatures` drift) made slicing
  unsafe. New `.gitignore` entries for Racket `compiled/` caches and
  `LLM_STATE/**/compact-baseline` scratch files. Verification: full
  `cargo test --workspace` green; `RUNTIME_LOAD_TEST=1` harness green
  (~40s, 7 library checks + `raco make` of 3 sample apps).
- **Side effect:** the "Fix stale `snapshot_racket_oo_foundation_subset`
  golden files" task is resolved in the same commit — the foundation
  snapshot is now green at HEAD.

### Fix stale `snapshot_racket_oo_foundation_subset` golden files `[testing]`
- **Completed:** 2026-04-15 (via f7a906c side effect)
- **Summary:** Availability-filter delta plus emitter rewrite drift
  were regenerated together in the accumulated-WIP commit. The
  follow-up split anticipated in the original task description was
  unnecessary — the goldens had to land with the emitter changes that
  produced them to keep the commit coherent. Red workspace test at
  HEAD cleared.

### Class-method property accessors drop self-arg in contract but not impl `[emission]`
- **Completed:** 2026-04-15
- **Summary:** Class-property setter impls were hard-wired to take `self`
  but contracts omitted it, causing `provide/contract` arity failures at
  load time. Fixed in `emit_class.rs::emit_property` (option 2 — make impl
  match contract). Getters were already correct. Added 2 unit tests and
  `nsmenuitem.rkt` runtime load canary. Surfaced from Modaliser-Racket.
