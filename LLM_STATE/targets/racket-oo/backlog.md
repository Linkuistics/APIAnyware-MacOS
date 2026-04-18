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
all 6 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~55s end-to-end). Class-property
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
6 apps now in `APPS` in the runtime load harness (~55s).
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
  NSNotificationCenter observer pattern is now established (PDFKit Viewer).
  Completion block pattern (NSSavePanel `beginSheetModalForWindow:completionHandler:`)
  is new territory — expect iteration on block-callback plumbing.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

#### Mini Browser
- **Status:** not_started
- **Dependencies:** `wkwebview.rkt` has a generator bug — `_NSEdgeInsets`
  unbound due to `any_struct_type` not detecting `NSEdgeInsets` in WKWebView's
  property set; root cause is `NSEdgeInsets` missing from `is_known_geometry_struct`
  in `ffi_type_mapping.rs`. Fix tracked in this backlog as "Fix unbound
  `_NSEdgeInsets` in generated `webkit/wkwebview.rkt`" (relocated from core
  backlog 2026-04-18).
  **Workaround is functional**: use raw `tell` calls against WKWebView — skip
  importing `wkwebview.rkt` entirely. Drawing Canvas used the same raw-`tell`
  pattern for event handling, confirming the workaround is viable.
- **Description:** Minimal web browser. WKWebView, WKNavigationDelegate (async
  multi-step delegate: didStart → didFinish/didFail), NSURL/NSURLRequest,
  back/forward/reload, NSProgressIndicator, NSAlert (error display).
  Tests async multi-callback delegate pattern and cross-framework imports
  (AppKit + WebKit + Foundation). Modaliser uses WKWebView for HTML rendering
  but does NOT exercise WKNavigationDelegate or URL-based navigation.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results:** _pending_

### Future Work

#### Framework Coverage Deepening
- **Status:** not_started
- **Dependencies:** none — "at least 2 more sample apps" dependency satisfied
  (6 apps done: hello-window, counter, ui-controls-gallery, file-lister,
  drawing-canvas, pdfkit-viewer).
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
  what sample apps cover. Scope TBD — may be better defined after app experience
  reveals which frameworks have surprising emitter edge cases. Note: the runtime
  load harness already exercises CoreGraphics `functions.rkt` at a shallow level,
  so this task's focus should be deeper per-framework API exercises (construct
  values, call functions, check results) rather than mere load checks.
- **Results:** _pending_

#### Racket Class System Analysis
- **Status:** not_started
- **Dependencies:** Note Editor and Mini Browser complete (SceneKit Viewer
  done 2026-04-17; Drawing Canvas done; real usage reveals which patterns
  matter)
- **Description:** Analyse the current racket-oo emitter output and runtime to
  determine whether it truly models macOS APIs using Racket's class system
  (`racket/class`) as much as possible — e.g., using `class*`, `define/public`,
  `inherit`, `super-new`, interfaces for protocols, mixins for categories.
  Identify where the current approach falls short of idiomatic Racket OO and
  propose concrete changes to make better use of the class system.
- **Results:** _pending_

#### Generator Bug Fixes (Batch — from Modaliser Learnings)
- **Status:** not_started
- **Dependencies:** none
- **Description:** Four generator bugs confirmed via Modaliser usage (filed 2026-04-17).
  All have caller-side workarounds; upstream fixes belong in the emitter.
  1. **`nsmenuitem-separator-item`** — `separatorItem` class factory method emitted as
     instance property. Fix: detect class factory methods in `emit_class.rs`, exclude
     from property emission.
  2. **`nsscreen.rkt` duplicate `define`** — the generated file fails to load at all;
     any code that `require`s NSScreen bindings must use raw `tell` as a workaround.
     Likely a method or property declared both directly on the class and via a category,
     not deduplicated before emission. Fix: dedup gap in `effective_properties` or
     `emit_class.rs` deduplication logic. Regenerate `appkit/nsscreen.rkt` after the
     fix; verify the module loads cleanly. (Augmented 2026-04-18 with context relocated
     from core backlog.)
  3. **`CFStringGetCStringPtr` return contract** — `string?` should be `(or/c string? #f)`;
     the function legitimately returns NULL when the string's internal encoding does not
     match the requested encoding — a documented, common case. Memory entry
     "`const char *` maps to `TypeRefKind::CString`" states the correct return contract
     is `(or/c string? #f)`, but the emitter may be generating `string?` alone without
     the `#f` branch for some code paths. Fix: audit `map_return_contract` in
     `emit_class.rs` for `TypeRefKind::CString` — ensure it always emits `(or/c string? #f)`,
     not `string?` alone. Regenerate affected `functions.rkt` files (start with CoreFoundation).
     (Augmented 2026-04-18 with context relocated from core backlog.)
  4. **Integer param widening** (`AXValueCreate`, `AXValueGetValue`, `CFNumberGetValue`) —
     params emitted as `_uint64` where `_uint32`/`_int32` is correct. Fix: tighten the
     integer-width mapping in `ffi_type_mapping.rs`.
- **Results:** _pending_

#### Fix unbound `_NSEdgeInsets` in generated `webkit/wkwebview.rkt`
- **Status:** not_started
- **Priority:** high
- **Dependencies:** none
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); any module that
  transitively `require`s WKWebView bindings fails to load. Relocated from core backlog
  2026-04-18 (misfiled — racket-oo generation, not shared pipeline).
- **Symptom:** `generated/oo/webkit/wkwebview.rkt` references `_NSEdgeInsets`, which is
  not bound in the generated WebKit FFI layer. The module fails at load time, blocking
  any application that imports WKWebView — including mini-browser and similar apps
  that rely on a full app-load path.
- **Suspected root cause:** `NSEdgeInsets` is a struct typedef in AppKit, not WebKit.
  The WebKit emitter references the FFI type but does not import or re-export the AppKit
  struct definition. Either the emitter must emit a cross-framework `require` for
  `_NSEdgeInsets`, or the struct definition must be placed in a shared location accessible
  to both. Related: the Mini Browser entry above notes `is_known_geometry_struct` in
  `ffi_type_mapping.rs` (in the shared `emit/` crate) does not list `NSEdgeInsets`;
  either extending that allowlist or adding a cross-framework require are the two
  candidate fixes.
- **Fix direction:** Determine whether `NSEdgeInsets` maps to `TypeRefKind::Struct` in
  the IR. If so, ensure the WebKit emitter imports the AppKit cstruct definition (or a
  shared geometry module) before using `_NSEdgeInsets`. Regenerate and verify module
  load via the runtime load harness and a transitive `require` smoke test.
- **Scope:** Emitter cross-framework struct import logic. Regenerate `webkit/wkwebview.rkt`
  after fix; verify transitive `require` works from a standalone module.
- **Results:** _pending_

#### Fix generator to emit `bool`/`BOOL` return types as `_bool` not `_uint8`
- **Status:** not_started
- **Priority:** high
- **Dependencies:** none
- **Surfaced by:** Modaliser-Racket development (2026-04-16); boolean methods silently
  misidentified as true when returning false. Relocated from core backlog 2026-04-18
  (misfiled — racket-oo generation, not shared pipeline).
- **Symptom:** The racket-oo emitter maps C `bool`/`BOOL` return types to `_uint8` on
  some code paths. In Racket, `_uint8` decodes to an integer, and all integers
  (including `0`) are truthy — only `#f` is falsy. A method returning `false`/`0` is
  therefore silently misidentified as true in any boolean context. The correct FFI type
  is `_bool`, which decodes `0` → `#f` and non-zero → `#t`. Until fixed, callers must
  wrap boolean returns with `(positive? ...)` or `(not (zero? ...))`.
- **Fix direction:** `racket_ffi_type_for_primitive` in `generation/crates/emit/src/ffi_type_mapping.rs`
  already maps `"bool" => Some("_bool")` — so the bug path is either (a) `BOOL` (ObjC
  typedef) not being normalised to `bool` before reaching this function, or (b) a
  return-type-specific path that bypasses `racket_ffi_type_for_primitive`. Audit the
  FFI type mapper for `bool`/`BOOL` primitive names and ensure `_bool` is emitted on
  every return-type path. Regenerate and verify with a method known to return `NO`/`false`.
- **Scope:** `ffi_type_mapping.rs` mapper and callers; regenerate affected bindings.
  Likely widespread across frameworks wherever `BOOL` return types appear.
- **Results:** _pending_

#### Add Info.plist customization API to `bundle-racket-oo`
- **Status:** not_started
- **Priority:** medium
- **Dependencies:** none
- **Promoted from:** "Add Racket `.app` bundler for distributable builds" follow-up
  (2026-04-18). Relocated from core backlog 2026-04-18 (misfiled — bundle-racket-oo
  is a racket-oo crate).
- **Symptom:** The new `bundle_app_with_entry` API assembles a self-contained `.app`
  bundle but has no mechanism for callers to inject custom Info.plist keys. Apps
  requiring Accessibility or Screen Recording entitlements need `LSUIElement`,
  `NSAccessibilityUsageDescription`, `NSScreenCaptureUsageDescription`, and
  `AppIcon.icns`. Modaliser-Racket currently cannot migrate from `bundle/build.sh`
  to the new API because of this gap.
- **Fix direction:** Extend `BundleSpec` (or add a new parameter type) with an
  `info_plist_overrides: HashMap<String, plist::Value>` field. Merge caller-supplied
  keys into the generated Info.plist after the base template is written. Add tests
  for key injection and override precedence.
- **Scope:** `bundle-racket-oo/src/bundle.rs` only. No emitter changes required.
- **Results:** _pending_

#### Implement stable signing identity for distributable `.app` bundles
- **Status:** not_started
- **Priority:** medium
- **Dependencies:** none (complements "Self-Contained App Bundling" below — bundles
  can be self-contained without stable signing, and vice versa)
- **Promoted from:** "Add Racket `.app` bundler for distributable builds" follow-up
  (2026-04-18). Relocated from core backlog 2026-04-18 (the stub-launcher crate is
  language-agnostic, but the TCC-grant re-prompt pain point currently surfaces only
  in racket-oo bundling; move with it so a single plan owns bundling end-to-end).
- **Symptom:** Ad-hoc codesigning (`-`) produces a new CDHash on every rebuild,
  invalidating TCC grants for Accessibility/Screen Recording. Users must re-grant
  permissions after every build. This is the root cause of the
  `bundle-rebuild-invalidates-tcc` issue in Modaliser-Racket.
- **Fix direction:** Extend `stub-launcher`'s `create_app_bundle` / `compile_stub`
  workflow to accept an optional signing identity (Developer ID or self-signed cert
  with a stable key). When a stable identity is provided, `codesign` with it instead
  of ad-hoc. Document the self-signed-cert setup path as the recommended local-dev
  workflow (no Apple Developer account required).
- **Scope:** `generation/crates/stub-launcher/`. Requires `Security.framework` or
  shell-out to `security` and `codesign`. Does not affect bundle layout or Racket
  file copying. If a second language target begins bundling, extract the shared
  signing logic upward at that time rather than pre-emptively.
- **Results:** _pending_

#### `make-objc-block` nil/`#f` Regression Fix
- **Status:** not_started
- **Priority:** high
- **Dependencies:** none
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16); completion-handler
  arguments set to `#f` caused `(apply #f ...)` crash on block invocation. Relocated
  from core backlog 2026-04-18 (misfiled — racket-oo runtime, not shared pipeline).
- **Description:** `runtime/block.rkt` has a documented nil guard (memory: "returns `(values #f #f)`
  for `#f` input") and a passing `runtime_block_nil_guard` harness test. However, Modaliser
  (2026-04-18) confirms the fix is incomplete: passing `#f` as the callback to `make-objc-block`
  still creates a live block whose invocation calls `(apply #f args)`, crashing or silently
  misbehaving. The guard may only protect certain code paths, not the general construction path.
  Callers currently must pass an explicit `(lambda args (void))` as a workaround.
- **Fix direction:** Audit `make-objc-block` in `runtime/block.rkt`. Either (a) at the
  top of the function, normalise `#f` → `(lambda args (void))` before storing `proc`
  (one-line fix, keeps a live block wrapper around a no-op) — simple but allocates an
  unused block; or (b) ensure `#f` input produces `(values #f #f)` (NULL block pointer,
  no block allocated) without creating a live block wrapper — preferred, matches the
  existing documented contract. Update `runtime_block_nil_guard` to also exercise
  invocation of the returned values, not just construction.
- **Scope:** `runtime/block.rkt` only. Low risk.
- **Results:** _pending_

#### `spi-helpers.rkt` GC-malloc `free` Fix
- **Status:** not_started
- **Priority:** high
- **Dependencies:** none
- **Description:** `spi-helpers.rkt` calls `free` on a `(malloc …)` buffer — GC-managed
  memory → SIGABRT at runtime. `cf-bridge.rkt` and `ax-helpers.rkt` had 9 analogous
  `free` calls removed already. Apply the same fix to `spi-helpers.rkt`: drop the
  `free` call and let the GC reclaim. Filed 2026-04-17 from Modaliser learnings.
- **Results:** _pending_

#### Self-Contained App Bundling (Swift Stub Launcher)
- **Status:** not_started
- **Dependencies:** none
- **Description:** Current `.app` bundles produced by `bundle-racket-oo` use absolute
  symlinks into `generation/targets/racket-oo/`, making them machine-specific and
  non-distributable. A distributable bundle needs: (1) bindings and runtime copied
  verbatim (no symlinks), (2) dylib `@rpath` rewritten to `@executable_path/../Frameworks`
  or equivalent, (3) a Swift stub launcher — ~15-line Swift file compiled with
  `swiftc -O` that `execv`s into `/opt/homebrew/bin/racket` — so the bundle has its
  own CDHash and independent macOS TCC permissions (camera, accessibility, etc.
  prompt under the app's identity, not racket's). Implement in `bundle-racket-oo`
  crate. Filed 2026-04-17 from Modaliser bundling observations.
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
  drill-down requires VNC click, not agent snapshot alone), completion block
  plumbing (NSSavePanel/NSOpenPanel), NSNotificationCenter observer lifetime
  (keep delegate in module-level var — Cocoa holds observers weakly).
  Delegate callback raw cpointer boundary: ObjC delegate callbacks
  (WKScriptMessageHandler, NSTableView data source, etc.) deliver raw cpointers
  for `id`-typed args; generated contracts require `objc-object?`; callers must
  wrap with `(borrow-objc-object ptr)` at every such boundary. Generated contracts
  give no hint that wrapping is required — must be prominently documented with examples.
- **Results:** _pending_
