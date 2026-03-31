# Racket Language Target

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (tell macro, class wrappers), Functional (plain procedures)
Swift dylib: libAPIAnywareRacket.dylib
Milestone: 9
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

Template: `plans/plan-template.md`

## Session Continuation Prompt

```
Run /begin-work racket-oo to load context, then continue from the next
incomplete step. Complete each step's Do → Verify → Observe cycle.
```

## Progress

### 9.1 Emitter crate

- [x] `generation/crates/emit-racket-oo/` — 8 modules ported from POC
  - [x] `naming.rs` — kebab-case constructors, properties, methods with `!` suffix
  - [x] `method_filter.rs` — Tell vs TypedMsgSend dispatch, method support filtering
  - [x] `shared_signatures.rs` — `_msg-N` signature deduplication
  - [x] `emit_class.rs` — complete class file generation (header, constructors, properties, methods, block wrapping)
  - [x] `emit_protocol.rs` — protocol definitions with `make-<protocol>` delegate constructors
  - [x] `emit_enums.rs` — enum definitions
  - [x] `emit_constants.rs` — constant declarations
  - [x] `emit_framework.rs` — framework orchestration, `RACKET_LANGUAGE_INFO`, `EmitResult`
- [x] `RacketFfiTypeMapper` in shared emit crate
- [x] 20 Rust-side unit tests passing
- [x] Added to workspace `Cargo.toml`
- [x] `cargo +nightly fmt` applied

### 9.2 Runtime library

- [x] 7 runtime files ported to `generation/targets/racket-oo/runtime/`
  - [x] `swift-helpers.rkt` — conditional loading of `libAPIAnywareRacket.dylib`
  - [x] `objc-base.rkt` — object wrapping with GC-attached release finalizers
  - [x] `coerce.rkt` — auto-coercion (string→NSString, objc-object→ptr)
  - [x] `block.rkt` — ObjC block creation from Racket lambdas
  - [x] `delegate.rkt` — delegate creation (Swift-backed + pure-Racket fallback)
  - [x] `type-mapping.rkt` — Foundation type conversions, geometry structs
  - [x] `variadic-helpers.rkt` — alternatives for variadic ObjC methods
- [x] Runtime loads and works in Racket (7 tests: all modules load, swift-available? is #t, all FFI bindings non-#f)

### 9.3 Swift dylib integration

- [x] `libAPIAnywareRacket.dylib` builds successfully (from Milestone 7.2)
- [x] 64 Swift tests pass (7 Common + 3 Racket test files)
- [x] Dylib symlinked at `generation/targets/racket-oo/lib/libAPIAnywareRacket.dylib`
- [x] FFI round-trip test from Racket → Swift helper → verify result (20 tests: class/selector lookup, string round-trip with ASCII/Unicode/empty, NSString length, autorelease pool push/pop, retain/release, GC prevention, wrap-objc-object, struct creation, array round-trip)
- [x] Block creation through dylib verified from Racket (5 tests: block lifecycle, enumerateObjectsUsingBlock: with 3 elements, early stop via BOOL* parameter, sortedArrayUsingComparator: with NSNumbers, call-with-objc-block convenience)
- [x] Delegate creation through dylib verified from Racket (7 tests: delegate creation + respondsToSelector:, void dispatch to 2 handlers, bool return #t, bool return #f, delegate-set! live update, free-delegate cleanup, multiple coexisting delegates)

### 9.4 Generation CLI wiring

- [x] Register Racket emitter in `apianyware-macos-generate` (already done in Milestone 8.1)
- [x] Generate all enriched frameworks (Foundation: 382 files, 308 classes, 71 protocols, 182 enums)
- [x] Output to `generation/targets/racket-oo/generated/oo/` and `generation/targets/racket-oo/generated/functional/` (312 files each, both directories populated)
- [x] Both binding styles produce separate output (OO and Functional each get their own directory; CLI dispatches via `--lang racket-oo`)

**Note:** The current emitter produces OO-style output for both styles. The functional style (plain procedures, no tell macro, explicit objc_msgSend everywhere) needs to be implemented as a separate code path in emit-racket-oo. The CLI infrastructure correctly routes to both directories.

### 9.5 Snapshot tests

- [x] TestKit golden files (OO style, 10 files, full directory comparison — from 8.2)
- [x] Foundation golden files (OO style, 18 curated files — nsobject, nsstring, nsarray, nsdata, nsurl, nsnotificationcenter, nserror, nsfilemanager, nsuserdefaults, nsdateformatter, nslock, nstimer, main, constants, enums, protocols/nscopying, protocols/nscoding, protocols/nslocking)
- [x] Added `assert_subset_matches` to `GoldenTest` for curated golden sets (only checks files present in golden dir, ignores extras)
- [x] Regression tests integrated into `cargo test` (2 snapshot tests: TestKit full + Foundation subset)
- [ ] AppKit golden files (blocked on AppKit enriched IR — only Foundation is currently enriched)
- [ ] Functional style golden files (blocked on functional emitter implementation — currently emits same as OO)

### 9.6 Language-side smoke tests

- [x] OO style: 15 smoke tests using generated Foundation bindings (test-generated-smoke.rkt)
  - [x] NSString: length, description, hash, integer-value, constructor procedure check
  - [x] NSArray: count, first-object, last-object, description
  - [x] NSMutableArray: add-object! + count, remove-last-object!
  - [x] NSNumber: int-value, bool-value, double-value
  - [x] NSData: length via dataUsingEncoding:
  - [x] NSLock: try-lock, name property set/get
- [x] Fixed 3 bugs discovered during smoke testing:
  - [x] Runtime path: `../../runtime/` → `../../../runtime/` (class files) and `../../../runtime/` → `../../../../runtime/` (protocol files) — output structure is `generated/{style}/{framework}/`, one level deeper than assumed
  - [x] Swift-style selectors: filter out methods with `(` in selector (e.g., `init(string:)`) — these can't be called via objc_msgSend; ObjC equivalents already present
  - [x] `coerce-arg` for objc-object: cast to `_id` via `(cast ptr _pointer _id)` so `tell` macro accepts it
- [ ] Functional style: same tests using functional bindings (blocked on functional emitter implementation)
- [x] Tests run with `racket` directly (54 total Racket tests across 5 files)

### 9.7 Sample apps — OO style

All 7 standard apps using `tell` macro and class wrappers.

**Each app should be developed in its own session** — each involves writing the app, debugging emitter issues discovered during real use, and full TestAnyware validation. See `knowledge/apps/{app}/spec.md` for detailed specs and `knowledge/apps/{app}/test-strategy.md` for validation checklists.

- [x] Hello Window — object lifecycle, property setters, NSWindow (validated in TestAnyware VM: window + centered label render correctly)
- [x] Counter — target-action, buttons, mutable state (validated: +/−/Reset all work, negatives, delegate bridge target-action pattern)
- [x] UI Controls Gallery — all standard AppKit controls, visual regression baseline (validated: all 8 sections render, scrolling works, native appearance; fixed 2 emitter bugs: duplicate emission + typedef alias FFI type mapping)
- [ ] File Lister — NSTableView, data source delegate, NSFileManager, NSOpenPanel
- [ ] Text Editor — block callbacks, error-out, undo/redo, notifications, find
- [ ] Mini Browser — cross-framework WebKit, WKNavigationDelegate, URL handling
- [ ] Menu Bar Tool — NSStatusBar, NSMenu, no-window app, timers, clipboard

### 9.8 Sample apps — Functional style

All 7 standard apps using plain procedures and explicit typed message sends.

**Each app should be developed in its own session.** Blocked on functional emitter implementation — currently emits same as OO.

- [ ] Hello Window
- [ ] Counter
- [ ] UI Controls Gallery
- [ ] File Lister
- [ ] Text Editor
- [ ] Mini Browser
- [ ] Menu Bar Tool

### 9.9 TestAnyware validation

- [ ] All OO sample apps validated via TestAnyware in VM
- [ ] All Functional sample apps validated via TestAnyware in VM
- [ ] Issues discovered and resolved
- [ ] Screenshots archived

### 9.10 Per-framework exercisers

- [ ] CoreGraphics — drawing paths, contexts
- [ ] AVFoundation — audio playback
- [ ] MapKit — map view with annotations

### 9.11 Documentation placeholder

- [ ] `generation/targets/racket-oo/docs/requirements.md`
- [ ] Racket-specific idiom notes (OO: `tell` macro, `import-class`; Functional: explicit `objc_msgSend`, no `tell`)
- [ ] Notes on what Racket users would find surprising

## Racket-Specific Notes

- The OO style uses Racket's built-in `ffi/unsafe/objc` module's `tell` macro for clean message-passing syntax. The functional style bypasses `tell` entirely, using explicit `objc_msgSend` bindings for everything.
- Racket's GC is precise — the runtime must prevent GC of ObjC objects, C callbacks, and block structs via the `active-blocks` hash and `swift-gc-handles` registry.
- The `coerce-arg` function auto-converts Racket strings to NSString for convenience. The functional style should still provide this — it's ergonomic, not paradigmatic.
- Variadic ObjC methods are intentionally skipped. `variadic-helpers.rkt` provides Racket-idiomatic alternatives.

## Learnings

- Racket emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields.
- Dylib name changed from `libanyware_racket` to `libAPIAnywareRacket` — only `swift-helpers.rkt` references it.
- Framework header simplified from POC's per-framework match arms to a single format string.
- Dylib must be symlinked at `generation/targets/racket-oo/lib/libAPIAnywareRacket.dylib` for the runtime to find it (swift-helpers.rkt looks at `../lib/` relative to `runtime/`).
- Racket's `with-autorelease-pool` macro uses `begin0` internally, so `define` forms inside it are invalid — use `let`/`let*` instead.
- Racket's `_cprocedure` + `function-ptr` successfully creates C-callable function pointers that ObjC's block invoke and delegate IMP trampolines can call. The block self-pointer must be skipped in the wrapper (first arg).
- Block early stop via `BOOL*` parameter works: `(ptr-set! stop-ptr _byte 1)` sets the pointed-to BOOL to YES, causing NSArray enumeration to halt.
- `sortedArrayUsingComparator:` passes raw id pointers to the comparator block — these must be cast to `_id` before using `tell` on them.
- Delegate `respondsToSelector:` works automatically — the Swift helper (or ObjC runtime fallback) registers the methods on the dynamic class, so the standard introspection API reports them correctly.
- Multiple delegates can coexist independently — each gets its own ObjC class (Swift mode) or dispatch table entry (Racket fallback mode), with no cross-talk.
- Generated runtime paths must be `../../../runtime/` for class files and `../../../../runtime/` for protocol files — the `generated/{style}/` directory adds one level beyond what the POC had.
- Swift-style selectors (containing `(`) must be filtered from emission — `init(string:)` is not a valid Racket identifier and can't be called via `objc_msgSend`. The `is_supported_method` filter now checks `!method.selector.contains('(')`.
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` — Racket's `tell` macro only accepts `_id`-tagged pointers, not raw `_pointer` values.
- TypedMsgSend methods (`_msg-N` bindings) expect raw pointers for id-type parameters, not wrapped `objc-object` structs. Callers should pass `_id` pointers directly. Only `self` goes through `coerce-arg`.
- **Always kill GUI app processes in the VM after TestAnyware validation.** `nohup racket app.rkt &` leaves the process running; use `testanyware exec "pkill -f app.rkt"` to clean up before moving on or stopping the VM. Failing to do this can leave orphan processes that interfere with subsequent tests.
- Category property merging must deduplicate by name — `class.properties.extend(category_props)` creates duplicates when a property exists on both the class interface and a category. Fixed with HashSet filter in `extract_declarations.rs`.
- Emitter must also deduplicate effective_methods by selector and effective_properties by name before emission — defensive layer against any remaining duplicate sources.
- Typedef aliases (e.g., `NSImageName`) must be resolved to their canonical types at collection time. ObjC object pointer typedefs → `Id`/`Class`, primitive typedefs → `Primitive`, enum/struct typedefs → keep as `Alias`. Without this, the FFI mapper defaults to `_uint64` for unrecognized aliases, which crashes at runtime for object-type parameters.
- `NSEdgeInsets` is not in the geometry struct alias list, so `nsstackview-set-edge-insets!` gets a `_uint64` typed msg-send that can't accept the struct. Omit edge insets from apps until this is fixed.
- VirtioFS shared filesystem can serve stale files after host edits. Restart the VM or copy files to VM local storage to work around this.
- Racket module compilation is very slow on first run (~5+ minutes for apps importing many generated modules). Compiled bytecode is cached in `compiled/` directories for subsequent runs.
- Radio button mutual exclusion with standalone NSButton (not deprecated NSMatrix) requires manual target-action delegate that deselects all and selects the sender.
- NSStepper requires `setContinuous: YES` to fire target-action on click. Without it, the stepper changes its own intValue but never sends the action message. This is a macOS behavior — other NSControl subclasses (NSButton, NSSlider) fire actions by default.
- NSStepper (and likely other small controls) inside a plain NSView container added to NSStackView may not receive clicks. Adding the control directly to the stack view as an arranged subview fixes this.
- When transferring files to the VM, use base64 encoding via `testanyware exec "echo '<b64>' | base64 -d > file"` instead of relying on VirtioFS shared filesystem, which can serve stale/truncated content after host edits.
- Always `pkill -9 -f racket` before relaunching an app — failing to do so leaves the old process holding the NSApplication singleton, and the new process may silently fail or show the old window.
