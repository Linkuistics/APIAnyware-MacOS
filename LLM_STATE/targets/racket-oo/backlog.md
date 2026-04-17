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
16 library `dynamic-require` checks, 10 required frameworks, plus `raco make` of
all 4 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~48s end-to-end). Class-property
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
C-function type mapping fixes landed (2026-04-16): `Boolean` → `_bool`, `const char *`
→ `TypeRefKind::CString` / `_string`, `AXValueType`-style aliases via
`is_generic_type_param`, CF record typedefs → `TypeRefKind::Struct` / `ffi-obj-ref`.
Full pipeline re-run 2026-04-16 (284 frameworks, all 162 workspace tests pass,
runtime load harness passes). CFSTR macro constants emitted via `_make-cfstr` helper
(2026-04-16) — `kAXWindowsAttribute` and all HIServices CFSTR constants now enter
the IR from `MacroDefinition` extraction and emit `(define kFoo (_make-cfstr "literal"))`.
`cf-bridge.rkt` landed (2026-04-16) — CFString/CFNumber/CFBoolean/CFArray/CFDictionary
conversions plus `with-cf-value` auto-release. `nsview-helpers.rkt` landed (2026-04-16)
— NSView geometry helpers. Both in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.
Class-return predicates landed (2026-04-16) — `objc-instance-of?` in `objc-base.rkt`,
per-class inline predicates (`nsview?` etc.) generated via `collect_return_type_class_names`.
`is_definition()` guards added to `StructDecl` and `ObjCProtocolDecl` (2026-04-16);
`ObjCInterfaceDecl` intentionally ungarded (declarations only in SDK headers). AX,
CGEvent, and SPI runtime helpers landed (2026-04-16): `ax-helpers.rkt`,
`cgevent-helpers.rkt`, `spi-helpers.rkt` — all in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.
Non-const `char *` → `_pointer` fix, nullable `_string` return contracts, and
foreign-thread safety warnings in C callback bindings all landed 2026-04-16.
**Bug fix (2026-04-16):** `cf-bridge.rkt` and `ax-helpers.rkt` called `(free buf)`
on Racket GC-managed `(malloc ...)` buffers → SIGABRT. Racket CS's `malloc`
returns GC-tracked memory; `free` expects C-heap pointers. Removed all 9 `free`
calls across 2 files.
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

#### Note Editor
- **Status:** not_started
- **Dependencies:** none
- **Description:** Markdown editor with live preview. NSSplitView (editor +
  preview), NSTextView, WKWebView (loadHTMLString with JS markdown rendering),
  NSUndoManager, NSNotificationCenter (text-change observation), NSSavePanel
  (completion block), NSOpenPanel, NSAlert (unsaved-changes), window dirty-state
  tracking. Exercises completion blocks, notification observation, and
  cross-framework rendering (AppKit + WebKit) — patterns no existing app tests.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

#### Mini Browser
- **Status:** not_started
- **Dependencies:** `wkwebview.rkt` has a generator bug — `_NSEdgeInsets`
  unbound due to `any_struct_type` not detecting `NSEdgeInsets` in WKWebView's
  property set; the fix is tracked in the core backlog (filed 2026-04-16).
  Workaround: use raw `tell` calls against WKWebView.
- **Description:** Minimal web browser. WKWebView, WKNavigationDelegate (async
  multi-step delegate: didStart → didFinish/didFail), NSURL/NSURLRequest,
  back/forward/reload, NSProgressIndicator, NSAlert (error display).
  Tests async multi-callback delegate pattern and cross-framework imports
  (AppKit + WebKit + Foundation). Modaliser uses WKWebView for HTML rendering
  but does NOT exercise WKNavigationDelegate or URL-based navigation.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

#### Drawing Canvas
- **Status:** not_started
- **Dependencies:** none
- **Description:** Freehand drawing app. Custom NSView subclass via
  `make-dynamic-subclass` with 4+ `add-method!` overrides (drawRect:,
  mouseDown:, mouseDragged:, mouseUp:). CoreGraphics drawing (CGContext,
  paths, stroke color/width), NSColorPanel, NSSlider, mouse event handling.
  Most architecturally novel app — dynamic ObjC subclass as primary pattern,
  CoreGraphics API first exercise, mutable shared state from ObjC callbacks.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

#### SceneKit Viewer
- **Status:** not_started
- **Dependencies:** none
- **Description:** 3D scene viewer with animated geometry. SCNView (3D viewport),
  SCNScene, SCNNode, SCNBox/SCNSphere/SCNTorus/SCNCylinder, SCNMaterial,
  SCNLight, SCNCamera, SCNAction (rotation animation), NSPopUpButton (geometry
  picker), NSColorPanel. "Wow factor" app — 3D rendering from Racket. Tests
  SceneKit framework end-to-end, chained object construction (scene graph),
  cross-framework NSView subclass, float-heavy API.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

#### Quartz/PDFKit collection fix
- **Status:** not_started
- **Priority:** high — gates PDFKit Viewer sample app; may also unblock Carbon/CoreServices
- **Dependencies:** none
- **Description:** PDFKit lives under the Quartz umbrella framework, excluded from
  `SUBFRAMEWORK_ALLOWLIST` in `sdk.rs` because the `clang-2.0.0` crate panics with a
  UTF-8 error when visiting a Quartz subframework path during a full collect run.
  Two approaches:
  (a) diagnose and fix the UTF-8 panic in `clang-2.0.0` (check for malformed header
      paths or filenames in the Quartz tree; upgrading the crate version may help);
  (b) add `PDFKit` as a narrow subframework-allowlist entry (same pattern as
      `HIServices` in `ApplicationServices`) without touching Quartz broadly.
  Option (b) is lower risk and sufficient to unblock PDFKit Viewer. Option (a) is
  needed if Carbon/CoreServices expansion is ever desired.
- **Results:** _pending_

#### PDFKit Viewer
- **Status:** blocked
- **Dependencies:** Quartz/PDFKit collection fix (see task above).
- **Description:** PDF viewer with page navigation and text search. PDFView,
  PDFDocument, PDFPage, PDFSelection, NSNotificationCenter
  (PDFViewPageChangedNotification), NSOpenPanel (filtered to .pdf). Tests
  whether a non-AppKit/WebKit/SceneKit framework's generated bindings work
  end-to-end.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

### Modaliser FFI Elimination — Upstream Blockers

#### ObjC interop re-export from runtime module
- **Status:** not_started
- **Priority:** high — blocks 9 Modaliser files from eliminating `ffi/unsafe`
- **Dependencies:** none
- **Description:** Consumer apps (e.g. Modaliser) using `tell`, `import-class`,
  `sel_registerName` must currently `(require ffi/unsafe ffi/unsafe/objc)`. To
  achieve zero `ffi/unsafe` outside `bindings/`, the runtime needs a module
  (e.g. `runtime/objc-interop.rkt`) that re-exports:
  - From `ffi/unsafe/objc`: `tell`, `import-class`, `sel_registerName`
  - From `ffi/unsafe`: `_string`, `_long`, `_int32`, `_uint64`, `_bool`,
    `_double`, `_pointer`, `_id`, `_fpointer`, `_void`, `_intptr`, `cast`,
    `cpointer?`, `ptr-equal?`
  This is a re-export convenience — no new implementation needed.
  Filed 2026-04-16 from Modaliser FFI elimination work.

#### Raw AX attribute getter and array helper in ax-helpers.rkt
- **Status:** not_started
- **Priority:** medium — blocks `ffi/accessibility.rkt` full migration
- **Dependencies:** none
- **Description:** `ax-helpers.rkt` provides typed attribute getters
  (`ax-get-attribute/string`, `/boolean`, `/point`, `/size`) but no raw
  `CFTypeRef`-returning variant. Modaliser needs:
  - `ax-get-attribute/raw el attr-string` → `cpointer? or #f` (returns
    the raw `CFTypeRef` from `AXUIElementCopyAttributeValue`, +1 ownership)
  - `ax-get-attribute/array el attr-string` → `list?` (converts the
    CFArray result via `cfarray->list`, each element `CFRetain`ed)
  These cover element-type attributes (focused app, focused window) and
  array-type attributes (window list) that don't fit the typed variants.
  Without these, consumer code needs `malloc _pointer` + `ptr-ref _pointer`
  out-param pattern from `ffi/unsafe`.
  Filed 2026-04-16 from Modaliser FFI elimination work.

#### CGEvent tap handler: expose raw event type for disabled-by-timeout
- **Status:** not_started
- **Priority:** medium — blocks `ffi/cgevent.rkt` full migration
- **Dependencies:** none
- **Description:** `cgevent-helpers.rkt`'s `make-cgevent-tap` handler
  signature is `(keycode modifiers key-down? → 'suppress or 'pass-through)`.
  This doesn't expose the raw CGEvent type, so the handler can't detect
  `kCGEventTapDisabledByTimeout` / `kCGEventTapDisabledByUserInput` events
  and re-enable the tap. Modaliser's tap callback handles these specially.
  Options: (a) pass raw event type as 4th arg to handler, (b) add an
  optional `#:on-disabled` callback param to `make-cgevent-tap`, (c) expose
  a richer handler protocol returning `(values action event-or-#f)`.
  Without this, Modaliser must keep its own `_cprocedure`/`function-ptr`
  callback in `ffi/cgevent.rkt`.
  Filed 2026-04-16 from Modaliser FFI elimination work.

### Future Work

#### Framework Coverage Deepening
- **Status:** not_started
- **Dependencies:** none — "at least 2 more sample apps" dependency satisfied
  (4 apps done: hello-window, counter, ui-controls-gallery, file-lister).
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
  what sample apps cover. Scope TBD — may be better defined after app experience
  reveals which frameworks have surprising emitter edge cases. Note: the runtime
  load harness already exercises CoreGraphics `functions.rkt` at a shallow level,
  so this task's focus should be deeper per-framework API exercises (construct
  values, call functions, check results) rather than mere load checks.
- **Results:** _pending_

#### Racket Class System Analysis
- **Status:** not_started
- **Dependencies:** Note Editor, Mini Browser, Drawing Canvas, and SceneKit
  Viewer complete (real usage reveals which patterns matter)
- **Description:** Analyse the current racket-oo emitter output and runtime to
  determine whether it truly models macOS APIs using Racket's class system
  (`racket/class`) as much as possible — e.g., using `class*`, `define/public`,
  `inherit`, `super-new`, interfaces for protocols, mixins for categories.
  Identify where the current approach falls short of idiomatic Racket OO and
  propose concrete changes to make better use of the class system.
- **Results:** _pending_

#### Developer Documentation
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
  constraint. Also cover: `only-in` for generated binding subsets, auto-terminating
  Cocoa-loop test pattern, VNC/GUIVisionVMDriver workflow quirks (menu accessibility
  drill-down requires VNC click, not agent snapshot alone).
- **Results:** _pending_
