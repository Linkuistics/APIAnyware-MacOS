# Target: racket-oo

Racket OO-style bindings for macOS APIs using the `tell` macro and class wrappers.
Foundation complete (382 files generated), 3 of 7 sample apps validated. Next focus:
remaining sample apps and C-API style.

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (tell macro, class wrappers), Functional (plain procedures), C-API
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

## Session Continuation Prompt

```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: racket-oo

Read `LLM_STATE/targets/racket-oo/plan.md`.

Target-specific context:
- Emitter crate: `generation/crates/emit-racket-oo/`
- Runtime: `generation/targets/racket-oo/runtime/`
- Generated output: `generation/targets/racket-oo/generated/`
- Apps: `generation/targets/racket-oo/apps/`
- Target learnings: `knowledge/targets/racket-oo.md`
- Racket-specific notes: `tell` macro for OO dispatch, `coerce-arg` for auto-conversion,
  `prevent-gc!` for delegate bridges, variadic methods skipped (helpers provided)

Key commands:
- `cargo test -p apianyware-macos-emit-racket-oo` — emitter tests
- `cargo run --bin apianyware-macos-generate -- --lang racket-oo` — regenerate
- `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket-oo` — update golden files
- TestAnyware VM: `../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket-oo:racket-oo`

Constraints:
- TDD: write tests first
- Always kill `pkill -9 -f racket` before relaunching apps in VM
- Use base64 encoding to transfer files to VM (VirtioFS serves stale content)
- If blocked on core pipeline, note the dependency and pick a different task
```

## Task Backlog

### Analyse OO style class system usage `[architecture]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Analyse the current racket-oo emitter output and runtime to determine
  whether it truly models macOS APIs using Racket's class system (`racket/class`) as much
  as possible — e.g., using `class*`, `define/public`, `inherit`, `super-new`, interfaces
  for protocols, mixins for categories. Identify where the current approach falls short of
  idiomatic Racket OO and propose concrete changes to make better use of the class system.
- **Results:** _pending_

### File Lister app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** NSTableView, data source delegate, NSFileManager, NSOpenPanel.
  See `knowledge/apps/file-lister/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Text Editor app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Block callbacks, error-out, undo/redo, notifications, find.
  See `knowledge/apps/text-editor/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Mini Browser app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Cross-framework WebKit, WKNavigationDelegate, URL handling.
  See `knowledge/apps/mini-browser/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Menu Bar Tool app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard.
  See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### C-API style emission `[coverage]`
- **Status:** blocked
- **Dependencies:** core pipeline C function/enum/constant/callback extraction
- **Description:** Emit Racket bindings for C functions, enums, constants, and callback
  types using `get-ffi-obj`, `_cprocedure`, `_enum`. The hand-written FFI in
  `../Modaliser-Racket/ffi/` (cgevent.rkt, permissions.rkt) is the reference for
  what the generated output should look like.
- **Results:** _pending_

### Functional style emitter `[coverage]`
- **Status:** not_started
- **Dependencies:** none (OO emitter exists as reference)
- **Description:** Implement the functional binding style — plain procedures and
  explicit typed message sends, no `tell` macro. The CLI infrastructure already
  routes to the functional output directory; the emitter currently produces OO
  output for both styles.
- **Results:** _pending_

### AppKit snapshot golden files `[testing]`
- **Status:** blocked
- **Dependencies:** AppKit enriched IR (only Foundation is currently enriched)
- **Description:** Add AppKit golden files for snapshot regression testing.
- **Results:** _pending_

### Functional style golden files `[testing]`
- **Status:** blocked
- **Dependencies:** functional style emitter
- **Description:** Snapshot tests for the functional binding style.
- **Results:** _pending_

### Functional style smoke tests `[testing]`
- **Status:** blocked
- **Dependencies:** functional style emitter
- **Description:** Same smoke tests as OO style, using functional bindings.
- **Results:** _pending_

### Per-framework exercisers `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
  what sample apps cover.
- **Results:** _pending_

### Documentation requirements `[docs]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Record Racket-specific documentation requirements: `tell` macro
  usage, `import-class` patterns, what's surprising for Racket developers, paradigm-
  appropriate examples for both OO and functional styles.
- **Results:** _pending_

## Session Log

### Pre-history (migrated from milestone 9 learnings)
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
