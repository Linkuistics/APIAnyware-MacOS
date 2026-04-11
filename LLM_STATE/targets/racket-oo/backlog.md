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
- **Status:** not_started
- **Dependencies:** none (core C function/enum/constant/callback extraction is done)
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
