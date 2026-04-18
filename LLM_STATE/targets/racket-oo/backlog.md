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
all 7 sample apps, gated on `RUNTIME_LOAD_TEST=1` (~55s end-to-end). Class-property
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
`_NSEdgeInsets` fix landed 2026-04-18 — `wkwebview.rkt` loads cleanly.
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
- **Status:** in_progress — entry script lands, raco make + bundle checks
  green; VM visual verification remains.
- **Dependencies:** none (`_NSEdgeInsets` fix resolved 2026-04-18 — `wkwebview.rkt`
  loads cleanly; workaround of using raw `tell` against WKWebView remains viable
  if any other WebKit binding issues surface).
- **Description:** Minimal web browser. WKWebView, WKNavigationDelegate (async
  multi-step delegate: didStart → didFinish/didFail), NSURL/NSURLRequest,
  back/forward/reload, NSProgressIndicator, NSAlert (error display).
  Tests async multi-callback delegate pattern and cross-framework imports
  (AppKit + WebKit + Foundation). Modaliser uses WKWebView for HTML rendering
  but does NOT exercise WKNavigationDelegate or URL-based navigation.
  See `docs/specs/2026-04-16-sample-app-portfolio-design.md`.
- **Results (2026-04-18):** Entry script landed at
  `apps/mini-browser/mini-browser.rkt`. Uses `make-wknavigationdelegate`
  from the generated WebKit protocol file, wiring four navigation
  callbacks (didStart / didFinish / didFailNavigation /
  didFailProvisionalNavigation). URL normalisation auto-prepends `https://`
  when the input has no scheme. NSAlert path uses
  `nsalert-alert-with-error` (idiomatic for NSError; NSAlert has no
  generated `-init`). Registered in `APPS` in the runtime load harness —
  `raco make` across all 8 apps (including this one) passes in ~72s.
  `bundles_every_sample_app` also passes via directory discovery. Status
  label at the bottom toggles "Loading..." / "Done" on didStart /
  didFinish; window title updates from `wkwebview-title` during chrome
  refresh. **VM verification (2026-04-18):** Booted a fresh Tahoe VM
  (`mini-browser-test`), installed `minimal-racket` via brew, bundled
  and uploaded `Mini Browser.app`, launched via `open`. Accessibility
  snapshot confirms: (1) initial apple.com load succeeds — address bar
  shows `https://www.apple.com/`; (2) window title updates to
  "Apple — Mini Browser" proving the `didFinishNavigation:` →
  `refresh-chrome!` path; (3) Back/Forward buttons correctly disabled
  (fresh history); (4) Reload button activates successfully, app stays
  responsive; (5) WKWebView accessibility group/scroll-area visible
  under content view. Remaining items from the test-strategy checklist
  (address-bar typing, link navigation, error alert on invalid URL,
  resize) need VNC keyboard input rather than agent set-value — the
  agent's set-value query didn't match the NSStackView-hosted textfield;
  likely needs a deeper accessibility hierarchy descent or VNC-level
  typing. Task stays `in_progress` until those remaining checks are
  walked via VNC.

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

#### Add `wkwebview.rkt` to `LIBRARY_LOAD_CHECKS`
- **Status:** done
- **Priority:** high
- **Dependencies:** none (`_NSEdgeInsets` fix landed 2026-04-18 — `wkwebview.rkt`
  loads cleanly per Mini Browser task verification)
- **Description:** Memory notes "when fixed, add `wkwebview.rkt` to
  `LIBRARY_LOAD_CHECKS`". The `_NSEdgeInsets` generator fix is now in place.
  Add `"webkit/wkwebview.rkt"` to the `LIBRARY_LOAD_CHECKS` list in
  `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`. Verify the
  harness passes with `RUNTIME_LOAD_TEST=1`. One-line harness edit; no emitter
  or runtime changes needed.
- **Results (2026-04-18):** No code change required — the entry
  `"generated/oo/webkit/wkwebview.rkt"` had already been added to
  `LIBRARY_LOAD_CHECKS` in commit `1d03ede` (same commit wave that landed
  the nullable-class-returns and naming-disambiguation changes). Grep
  verified the line in place; `RUNTIME_LOAD_TEST=1 cargo test -p
  apianyware-macos-emit-racket-oo --test runtime_load_test
  runtime_load_libraries_via_dynamic_require` passes all 25 checks in
  ~21s. Backlog task was stale. Matches the "grep source before filing
  relocated backlog tasks" rule in memory.md.

### Future Work

#### Framework Coverage Deepening
- **Status:** not_started
- **Dependencies:** none — "at least 2 more sample apps" dependency satisfied
  (7 apps done: hello-window, counter, ui-controls-gallery, file-lister,
  drawing-canvas, pdfkit-viewer, scenekit-viewer).
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

#### Add Info.plist customization API to `bundle-racket-oo`
- **Status:** done
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
- **Results (2026-04-18):** Added `plist = "1.7"` as workspace dep.
  `AppSpec` gained an `info_plist_overrides: HashMap<String, plist::Value>`
  field (default empty). After `create_app_bundle` emits the base
  template, the new `merge_info_plist_overrides` helper parses the
  generated plist, inserts each override key into the top-level
  dictionary (so caller keys replace base-template keys of the same
  name), and writes back via `plist::to_file_xml`. Empty-overrides path
  skips the round-trip entirely, so the base template stays
  byte-identical in the common case. New error variants
  `InfoPlistMerge(plist::Error)` and `InfoPlistRootNotDict(PathBuf)`.
  6 integration tests in `tests/info_plist_overrides.rs` — default
  empty; string / boolean / array / dict value shapes; replace-existing;
  byte-level preservation for the no-override path. All green; full
  workspace test suite still green (no regressions).

#### Implement stable signing identity for distributable `.app` bundles
- **Status:** done
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
- **Results (2026-04-18):** Two-stage signing. stub-launcher grew a
  `codesign.rs` module exporting `codesign_path(path, identity)` that
  shells out to `codesign --force --sign <identity> <path>`; error
  variants `CodesignNotFound` and `CodesignFailed { path, identity,
  stderr }` on `StubError`. `StubConfig` gained a
  `signing_identity: Option<String>` field; `create_app_bundle` calls
  `codesign_path` on the stub binary immediately after compile when set.
  bundle-racket-oo's `AppSpec` gained the same field, propagated to
  `StubConfig`; after lib/ is populated, `bundle_app_with_entry` re-signs
  the full bundle via `codesign_path` so the signature covers Resources/
  (without this second pass, `codesign --verify` rejects the bundle).
  Tests: stub-launcher `codesign.rs` unit tests cover ad-hoc success and
  bogus-identity failure; a new `bundle::create_app_bundle_applies_signing_identity_when_set`
  integration test confirms the binary gets signed; bundle-racket-oo
  `tests/signing_identity.rs` asserts `codesign --verify` passes on the
  fully populated bundle. All 27 stub-launcher tests green, all
  bundle-racket-oo tests green, full workspace suite clean.

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
