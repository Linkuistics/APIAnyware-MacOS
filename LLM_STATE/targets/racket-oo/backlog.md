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
all 8 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~72s end-to-end). Class-property
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
Drawing Canvas landed 2026-04-17 —
dynamic NSView subclass with drawRect/mouseDown/mouseDragged/mouseUp overrides
via `make-dynamic-subclass`, per-stroke CGContext rendering with round caps,
NSColorPanel with continuous target-action, line-width NSSlider, Clear button;
VM-validated end-to-end via GUIVisionVMDriver. First app using
`make-dynamic-subclass` for more than one override. Bundle IDs switched
project-wide from `com.apianyware.*` to `com.linkuistics.*`.
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
calls across 2 files. Modaliser FFI upstream blockers all landed (2026-04-17):
`objc-interop.rkt` curated re-export module (21/21 harness checks), `ax-get-attribute/raw`
and `ax-get-attribute/array` in `ax-helpers.rkt`, `make-cgevent-tap` `#:on-disabled`
keyword with forward-reference tap-box plumbing. PDFKit Viewer landed 2026-04-17 —
first app exercising PDFKit bindings and NSNotificationCenter observer pattern;
SceneKit Viewer landed 2026-04-17 — first app using SceneKit; 7 apps now in `APPS`
in the runtime load harness (~55s). Generator bug fixes landed 2026-04-18 (commit
1d03ede): NSEvent class/instance method name collision fixed (`nsevent-modifier-flags-class`
suffix); class-return contracts nullable (`or/c <pred> objc-nil?`);
`list->nsarray`/`hash->nsdictionary` wrap results in `type-mapping.rkt`. Self-contained
app bundling complete (2026-04-18): `copy_dir_recursive` skips `compiled/`, dylib
install_name normalized to `@executable_path/../Resources/racket-app/lib/<name>`.
`_NSEdgeInsets` fix landed 2026-04-18 — `wkwebview.rkt` loads cleanly;
`wkwebview.rkt` added to `LIBRARY_LOAD_CHECKS`. Info.plist overrides API landed
2026-04-18 — `AppSpec.info_plist_overrides: HashMap<String, plist::Value>` with
`merge_info_plist_overrides` helper; 6 integration tests green. Stable signing
identity landed 2026-04-18 — `stub-launcher` `codesign.rs` module; two-stage
signing (stub binary pre-copy, full bundle post-Resources); `StubConfig` and
`AppSpec` gain `signing_identity: Option<String>`; all 27 stub-launcher tests green.
Mini Browser app landed 2026-04-18 — WKWebView + WKNavigationDelegate (4 callbacks),
URL normalisation, NSAlert error path, NSProgressIndicator; 8 apps in `APPS` (~72s).
VM-verified: apple.com load, title update, back/forward disabled state, reload.
Remaining VNC checks (address-bar typing, link navigation, error alert, resize)
need VNC keyboard input (agent set-value unreachable in NSStackView-hosted textfield).
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

#### Mini Browser — VNC Verification
- **Status:** not_started
- **Priority:** high
- **Dependencies:** Mini Browser app landed and raco make + bundle green (2026-04-18)
- **Description:** Complete the remaining Mini Browser test-strategy checklist items
  that require VNC keyboard input:
  1. Address-bar typing — type a URL, press Return, verify navigation
  2. Link navigation — click an in-page link, verify back button enables
  3. Error alert — enter an invalid URL, confirm NSAlert sheet appears
  4. Window resize — verify WKWebView reflows correctly
  The agent `set-value` path cannot reach the NSTextField inside the NSStackView
  address-bar container (accessibility hierarchy depth). Use `guivision input type`
  or VNC keyboard events instead. Boot the existing Mini Browser VM or reuse
  the `mini-browser-test` Tahoe VM from the 2026-04-18 run.
- **Results:** _pending_

#### Note Editor
- **Status:** not_started
- **Dependencies:** none
- **Description:** Markdown editor with live preview. NSSplitView (editor +
  preview), NSTextView, WKWebView (loadHTMLString with JS markdown rendering),
  NSUndoManager, NSNotificationCenter (text-change observation), NSSavePanel
  (completion block), NSOpenPanel, NSAlert (unsaved-changes), window dirty-state
  tracking. Exercises completion blocks, notification observation, and
  cross-framework rendering (AppKit + WebKit) — patterns no existing app tests.
  NSNotificationCenter observer pattern is now established (PDFKit Viewer).
  Completion block pattern (NSSavePanel `beginSheetModalForWindow:completionHandler:`)
  is new territory — expect iteration on block-callback plumbing.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

### Harness & Verification

#### Fix `nsscreen.rkt` duplicate definition
- **Status:** not_started
- **Priority:** medium
- **Dependencies:** none
- **Source:** Reported by Modaliser-Racket (upstream binding-generation bug, 2026-04-18)
- **Symptom:** `nsscreen.rkt` contains a duplicate `define` form that prevents the
  file from loading. Any code transitively requiring `nsscreen.rkt` (or using
  `only-in` on it) fails at load time. Workaround: use raw `tell`/`objc_msgSend`
  for NSScreen calls instead of importing the generated binding.
- **Fix direction:** Identify the duplicate symbol in the NSScreen class emitter.
  Likely a property/method name collision similar to the NSEvent
  `modifierFlags` class/instance collision fixed in commit `1d03ede`; apply the
  same `PropertyNameSets` partitioning or `class_method_disambig` guard in
  `emit_class.rs`. Regenerate and verify via runtime load harness.
  When fixed, add `nsscreen.rkt` to `LIBRARY_LOAD_CHECKS`.
- **Results:** _pending_

### Future Work

#### Framework Coverage Deepening
- **Status:** not_started
- **Dependencies:** none — "at least 2 more sample apps" dependency satisfied
  (8 apps done: hello-window, counter, ui-controls-gallery, file-lister,
  drawing-canvas, pdfkit-viewer, scenekit-viewer, mini-browser).
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
  what sample apps cover. Scope TBD — may be better defined after app experience
  reveals which frameworks have surprising emitter edge cases. Note: the runtime
  load harness already exercises CoreGraphics `functions.rkt` at a shallow level,
  so this task's focus should be deeper per-framework API exercises (construct
  values, call functions, check results) rather than mere load checks.
- **Results:** _pending_

#### Racket Class System Analysis
- **Status:** not_started
- **Dependencies:** Note Editor complete (Mini Browser functionally done 2026-04-18;
  real usage has revealed which patterns matter)
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
  drill-down requires VNC click, not agent snapshot alone; `set-value` unreachable
  for textfields inside NSStackView containers — use VNC keyboard input instead),
  completion block plumbing (NSSavePanel/NSOpenPanel), NSNotificationCenter observer
  lifetime (keep delegate in module-level var — Cocoa holds observers weakly).
  Delegate callback raw cpointer boundary: ObjC delegate callbacks
  (WKScriptMessageHandler, NSTableView data source, etc.) deliver raw cpointers
  for `id`-typed args; generated contracts require `objc-object?`; callers must
  wrap with `(borrow-objc-object ptr)` at every such boundary. Generated contracts
  give no hint that wrapping is required — must be prominently documented with examples.
- **Results:** _pending_
