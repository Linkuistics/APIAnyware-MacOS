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
VM-validated via TestAnyware. Runtime additions: `borrow-objc-object`,
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
VM-validated end-to-end via TestAnyware. First app using
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
VM-verified end-to-end (2026-04-18): apple.com load, title update, back/forward
disabled state, reload, address-bar typing (triple-click + VNC keyboard), link
navigation, error alert (NSAlert sheet), window resize — all PASS on Tahoe VM.
Note Editor landed 2026-04-18 — NSSplitView, NSTextView, WKWebView loadHTMLString,
NSUndoManager, NSNotificationCenter, NSSavePanel completion block, NSOpenPanel;
9th app in `APPS` (~90s harness). Three first-time patterns validated: NSSavePanel
completion block (`make-objc-block` with `(Int64 -> Void)` signature), NSTextDidChange-
Notification observer (module-level var guards weak-observer lifetime), NSAlert via
`objc-interop.rkt` alloc+init escape hatch. `scan_rkt_string_literals` comment-skip
bug fixed in `bundle-racket-oo/src/deps.rs`. Class System Analysis complete
(2026-04-19): zero `racket/class` use confirmed; "OO" is conventional not technical;
option B (`objc-subclass` macro over `make-dynamic-subclass`) recommended; full
analysis in `docs/specs/2026-04-19-racket-oo-class-system-analysis.md`.
`define-objc-subclass` macro landed (2026-04-19) — Option B implemented in
`runtime/objc-subclass.rkt`; type encoding inference from superclass method;
`(self SEL)` prefix auto-inserted; IMPs GC-pinned module-level; `drawing-canvas`
rewritten as first consumer (70+ lines collapsed to one form); full harness green
(4/4 runtime load tests, ~85s).

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (done), C-API (done), functional (not started)
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

## Tasks

### Testing Hardening

**Category:** `harness-and-verification`
**Status:** not_started
**Dependencies:** none

**Description:**

**Priority:** high

Four areas under-tested after the milestone:
(1) `define-objc-subclass` — only `drawing-canvas` is a consumer; add at least
one more test exercising `#:arg-types`/`#:ret-type` overrides and the
struct-type encoding parser (nested `{...}` balanced-delimiter case).
(2) Default constructor synthesis — `make-<class>` synthesized for ~73% of all
classes; add explicit harness checks for NSAlert, NSColorPanel, NSStackView,
NSSavePanel, NSOpenPanel (these formerly required the `objc-interop.rkt`
escape hatch; confirm they now construct cleanly via `make-<class>`).
(3) `LIBRARY_LOAD_CHECKS` coverage audit — identify any runtime files or
generated framework files added since the last audit that are missing from
the harness; add them. Cross-reference `RUNTIME_FILES` list against
`LIBRARY_LOAD_CHECKS` in `runtime_load_test.rs`.
(4) CF struct globals gap — `kCFTypeDictionaryKeyCallBacks` et al. are absent
from collected IR (known gap in memory.md); decide whether to extend IR
extraction or document the `(get-ffi-obj ... _pointer)` workaround as
canonical; add a harness canary for whichever path is chosen.

**Results:** _pending_

---

### Framework Coverage Deepening

**Category:** `future-work`
**Status:** not_started
**Dependencies:** none

**Description:**

**Priority:** medium

**Dependency context:** "at least 2 more sample apps" dependency satisfied
(9 apps done: hello-window, counter, ui-controls-gallery, file-lister,
drawing-canvas, pdfkit-viewer, scenekit-viewer, mini-browser, note-editor).

Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
what sample apps cover. Scope TBD — may be better defined after app experience
reveals which frameworks have surprising emitter edge cases. Note: the runtime
load harness already exercises CoreGraphics `functions.rkt` at a shallow level,
so this task's focus should be deeper per-framework API exercises (construct
values, call functions, check results) rather than mere load checks.

**Results:** _pending_

---
