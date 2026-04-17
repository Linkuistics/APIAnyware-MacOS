# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Supports ObjC class/protocol/enum extraction and C function/enum/
constant extraction including function pointer typedefs.

All major pipeline capabilities are complete. The core is in maintenance mode — new tasks
emerge reactively as target app development reveals edge cases or gaps.

## Task Backlog

The core pipeline is in maintenance mode. Tasks below are reactive — each one
was surfaced either by a runtime failure in a language target or by a memory
entry triaged during a prior cycle. Provenance is recorded per-task in the
"Surfaced by" / "Promoted from" field. Priority ordering at the top of a
pending cluster is `high → medium → low`; within a priority band, the
listing order is a suggested work order, not a hard constraint.

### Add Racket `.app` bundler for distributable builds `[generation]` `[medium]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); Modaliser's `.app` bundle currently uses absolute symlinks into the APIAnyware-MacOS source tree, making it machine-specific and non-distributable
- **Symptom:** Racket app bundles built against APIAnyware-MacOS bindings symlink `bindings/` and `runtime/` from the source tree. The bundle cannot be sent to another machine or deployed without path surgery — the stub-launcher handles CDHash uniqueness but not self-contained distribution.
- **What's needed:** A general Racket `.app` bundler that: (1) copies required `bindings/` and `runtime/` `.rkt` files into the `.app` bundle under `Contents/Resources/`; (2) patches dylib `@rpath` entries to be self-contained; (3) integrates with the existing Swift stub compilation workflow. Natural home: a new crate or tool in `generation/crates/` alongside `stub-launcher`.
- **Fix direction:** Survey what Modaliser's `.app` currently symlinks. Enumerate the minimal transitive closure of `bindings/` and `runtime/` files. Design the bundler to copy them and rewrite `raco` collection paths or use `PLTCOLLECTS` to point inside the bundle. Coordinate with `stub-launcher` (already handles the Swift/CDHash step) so the two tools compose cleanly.
- **Scope:** New generation-layer tooling only. Does not block runtime correctness — only distributable builds. `stub-launcher` already exists; this extends the bundling story from "unique CDHash" to "fully self-contained `.app`".

### Fix class-method vs instance-property misclassification in IR / emitter `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** racket-oo development (2026-04-16); `NSMenuItem +separatorItem` was emitted as an instance property instead of a class method
- **Results:** Verified already resolved in the current generator. `nsmenuitem.rkt` emits `(nsmenuitem-separator-item)` as a zero-arg class method factory under the `;; --- Class methods ---` section (line 302 pre-regenerate), with the class-method-style contract `(c-> nsmenuitem?)`. The instance-property suppression logic lives at `emit_class.rs:44-57`: it builds a set of class-method names and removes any same-named instance property before emission, so the class-method-vs-same-named-instance-property collision case is already handled. No code changes needed for this task.

### Fix duplicate symbol in `nsscreen.rkt` emitter output `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** racket-oo development (2026-04-16); `nsscreen.rkt` load error due to duplicate symbol definition
- **Results:** Verified current `nsscreen.rkt` has no duplicate `define` forms and loads cleanly under `runtime_load_libraries_via_dynamic_require` (added to `LIBRARY_LOAD_CHECKS` at `generation/crates/emit-racket-oo/tests/runtime_load_test.rs:131`). Earlier category-property dedup work (memory entry "Category properties need dedup by name") closed this; kept the harness entry as a regression canary.

### Emit inherited methods from NSView/NSControl superclasses in subclass bindings `[generation]` `[low]`
- **Surfaced by:** racket-oo development (2026-04-16); WKWebView missing `setAutoresizingMask:` inherited from NSView
- **Symptom:** Generated bindings only emit methods declared directly on a class, not methods inherited from superclasses. Callers must fall back to raw `tell` for any inherited method not re-declared on the subclass — defeating the purpose of generated typed bindings.
- **Two fix options:**
  - **(a) Emit inherited methods via IR inheritance chain:** Walk `superclass_name` in `emit_class.rs`, look up ancestor classes in the IR, and include their methods in the subclass binding. Complete coverage but potentially large generated-file size increase and risks emitting methods the dylib does not export for that subclass.
  - **(b) Expose a generic `set-autoresizing-mask!` (and similar) on a shared NSView base:** Add a small set of universally-needed NSView methods to the runtime or a shared `nsview-base.rkt` that any NSView subclass binding can use. Lower risk, lower coverage.
- **Recommended approach:** Start with option (b) for the highest-frequency NSView/NSControl methods (`setFrame:`, `setAutoresizingMask:`, `setBounds:`, `setHidden:`, `setNeedsDisplay`). Escalate to option (a) if the coverage gap repeatedly blocks target development.
- **Scope:** Either option is confined to the generation layer. Regenerate affected subclass bindings and verify the previously-missing methods are callable without raw `tell`.

### Fix generator to emit `bool`/`BOOL` return types as `_bool` not `_uint8` `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** Modaliser-Racket development (2026-04-16); boolean return values from ObjC methods were always truthy in Racket
- **Results:** Verified resolved in two layers. Extractor: `collection/crates/extract-objc/src/type_mapping.rs:256` maps `BOOL`/`Boolean` typedefs to `TypeRefKind::Primitive { name: "bool" }` with an explicit comment about the Racket truthiness gotcha. FFI mapper: `generation/crates/emit/src/ffi_type_mapping.rs:128` maps `"bool"` → `"_bool"`. Verification canary: `generated/oo/foundation/nsfilemanager.rkt:97` now declares `_msg-1` with `-> _bool`, so `fileExistsAtPath:`, `isDeletableFileAtPath:`, etc. decode `0` → `#f` and non-zero → `#t` correctly.

### Fix `make-objc-block` to treat `#f` as a no-op lambda `[runtime]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** Modaliser-Racket development (2026-04-16); users pass `#f` for optional completion handler arguments
- **Results:** Already fixed differently than the task proposed. `make-objc-block` at `runtime/block.rkt:67-70` short-circuits `#f` to `(values #f #f)` — returning a NULL block pointer and NULL id rather than constructing a real no-op block. The ObjC-idiomatic semantic (nil block = "no callback") is tested explicitly at `test-block-creation.rkt:160-167` under "make-objc-block with #f returns NULL pointer"; the 2026-04-17 test file comments note that this is the chosen design. The task's suggested no-op-lambda normalisation would construct a real block that would always fire on the ObjC side; the current NULL path avoids the spurious callback and matches how Cocoa APIs treat a nil block argument. No code changes needed.

### Strengthen generated binding contracts beyond `any/c` `[generation]` `[low]`
- **Surfaced by:** Modaliser-Racket development (2026-04-16); contract violations (wrong receiver type, unwrapped `objc-object` vs `_id`, missing `coerce-arg`, PAC-trapping `char*` passed where NSString expected) were not caught at the binding boundary
- **Symptom:** Generated `provide/contract` forms use `any/c` for all parameters and return types. This means: passing the wrong receiver class, passing an unwrapped `objc-object` where `_id` is expected, omitting `coerce-arg`, or passing a raw Racket string where an NSString pointer is required all fail silently or produce late crashes rather than immediate contract violations. The contracts provide no safety net during development.
- **Possible improvements (in ascending implementation cost):**
  - **(a) Receiver-class predicate:** Add a `(is-a? v <ClassName>%)` check on `self` parameter contracts. Catches wrong-class receivers immediately.
  - **(b) Selector arity contract:** Emit a contract verifying the number of positional arguments matches the selector.
  - **(c) Typed parameter contracts:** Map IR type information to Racket predicates (e.g., `_id`-typed params require `objc-object?`, string params require `string?` or `NSString?`).
- **Fix direction:** Start with (a) as the highest-value, lowest-risk improvement. Assess impact on generated file size before committing to (b) or (c).
- **Scope:** Generator change in `emit_class.rs` / `emit_protocol.rs`. Contracts affect generated files only — no runtime changes required for (a) or (b).

### Fix generator type mapping for AXValueCreate/AXValueGetValue/CFNumberGetValue: `_uint64` should be `_uint32` or correct enum type `[generation]` `[medium]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16)
- **Triaged 2026-04-18, deferred:** The honest fix is broader than the task's three-function scope. `TypeRefKind::Alias` carries `name` only (`collection/crates/types/src/type_ref.rs:28`), so `RacketFfiTypeMapper::map_type` at `generation/crates/emit/src/ffi_type_mapping.rs:167` has no underlying width to consult and defaults to `_uint64` for every enum typedef — correct for `NS_ENUM(NSUInteger, …)`, wrong for `CF_ENUM(uint32_t, …)` (AX) and for `NS_ENUM(NSInteger, …)` (signedness flip). The principled fix — resolve `entity.get_enum_underlying_type()` at extraction in `collection/crates/extract-objc/src/type_mapping.rs:315`, either via a new `Primitive` emission or by extending `Alias { underlying_primitive: Option<String> }` — changes the FFI signature for enum parameters across every framework, requiring a full golden-snapshot refresh and caller-side audit for any code that relied on the `_uint64` default.
- **Suspected root cause:** The IR type mapper resolves the relevant `CFTypeID`/enum parameters to a generic integer width without consulting the typedef's underlying type (e.g. `AXValueType` is `uint32_t`, not `uint64_t`).
- **Fix direction:** Option A: extend `TypeRefKind::Alias` with `underlying_primitive: Option<String>`, populate at extraction from `entity.get_enum_underlying_type()`, consult in the FFI mapper. Option B: change `TypeKind::Enum` in `map_typedef` to emit `TypeRefKind::Primitive { name: <resolved> }` directly. Option B is simpler but deviates from the 2026-04-15 design rationale for keeping enum typedefs as `Alias`. Cross-reference against `HIServices/Accessibility.h` and `CoreFoundation/CFNumber.h`.
- **Scope:** Affects at least three functions in ApplicationServices/CoreFoundation. The real blast radius is every enum-typedef parameter across all 283 frameworks. Do the full audit rather than a name-matched special case.

### Fix generator to emit CF struct globals from CoreFoundation as `ffi-obj-ref` `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16); `kCFTypeDictionaryKeyCallBacks` and `kCFTypeDictionaryValueCallBacks` absent from generated CoreFoundation `constants.rkt`
- **Results:** Verified resolved. `generation/targets/racket-oo/generated/oo/corefoundation/constants.rkt:595-596` emits both `kCFTypeDictionaryKeyCallBacks` and `kCFTypeDictionaryValueCallBacks` as `(ffi-obj-ref 'kCFTypeDictionaryKeyCallBacks _fw-lib)`, and the `provide/contract` lines 220-221 declare them with `cpointer?`. CoreFoundation's IR (`collection/ir/collected/CoreFoundation.json`) carries them with `TypeRefKind::Struct` (names `CFDictionaryKeyCallBacks` / `CFDictionaryValueCallBacks`); the existing `is_struct_data_symbol` path routes them to `ffi-obj-ref` the same way `_dispatch_main_q` goes.

### Make class-return contracts nullable for properties that can return nil `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** racket-oo PDFKit Viewer development (2026-04-17); `pdfview-document` / `pdfview-current-page` fail their generated return contracts when the PDFView is empty
- **Results:** `map_return_contract` at `generation/crates/emit-racket-oo/src/emit_class.rs:334-342` now emits `(or/c <class-pred>? objc-nil?)` for every `TypeRefKind::Class { name }` return. Used the safer `objc-nil?` (re-exported from `runtime/objc-base.rkt` — tolerates raw cpointers, `#f`, and objc-object wrappers) rather than the struct-specific `objc-null?`. Chose the unconditional union over a `nullable`-guarded one because unaudited ObjC headers do not reliably distinguish `_Nonnull` from unspecified; tightening later is easy once the IR-level nullability signal is trustworthy. All AppKit/Foundation goldens refreshed and the pipeline regenerated (284 frameworks, 7059 files). Verified `nsevent.rkt`, `nsscreen.rkt`, `nsmenuitem.rkt`, `wkwebview.rkt` all load cleanly under `runtime_load_libraries_via_dynamic_require` with `RUNTIME_LOAD_TEST=1`.

### Auto-wrap `list->nsarray` / `hash->nsdictionary` results as `objc-object` `[runtime]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** racket-oo PDFKit Viewer development (2026-04-17); `nsopenpanel-set-allowed-file-types!` rejects the `list->nsarray` result with "contract violation: expected (or/c string? objc-object? #f), given: #<cpointer>"
- **Results:** `list->nsarray` and `hash->nsdictionary` in `runtime/type-mapping.rkt:88` / `:103` now wrap their results via `wrap-objc-object … #:retained #t` (the `alloc+init` produces a +1-retained pointer; the finalizer balances it). Also hardened `nsarray->list` and `nsdictionary->hash` to `unwrap-objc-object` their inputs so round-trip tests and mixed callers work uniformly. Updated call sites: `apps/pdfkit-viewer/pdfkit-viewer.rkt` drops the manual `(wrap-objc-object (list->nsarray …) #:retained #t)` ceremony; `tests/test-generated-smoke.rkt` drops its extra wrap; `tests/test-block-creation.rkt` switches the raw `msg-send-block` / `msg-send-block->id` call sites to `(unwrap-objc-object arr)`. All runtime Racket tests green (`test-ffi-roundtrip.rkt`, `test-block-creation.rkt`, `test-generated-smoke.rkt`, `test-runtime-load.rkt`, `test-main-thread.rkt`).

### Fix class-method / instance-method selector collision in generated bindings `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** racket-oo Drawing Canvas development (2026-04-17); `nsevent.rkt` fails to load with "module: identifier already defined" on `nsevent-modifier-flags`
- **Results:** Disambiguation applies in two flavours because NSEvent turned out to declare `modifierFlags` as *both* `@property(class)` and `@property(readonly)` rather than as +/- methods. Added `make_class_method_name` and `make_class_property_getter_name` / `make_class_property_setter_name` in `generation/crates/emit-racket-oo/src/naming.rs`, each with a `disambiguate: bool` flag that appends `-class` to the base name (placed before a trailing `!` for mutating selectors). In `emit_class.rs::generate_class_file`, a single pass builds `instance_bindings = instance_method_names ∪ instance_property_getter_names`, then derives `class_method_disambig` and `class_property_disambig` from the class-side members whose base Racket names land in that set. Threaded both sets through `emit_method`, `emit_property`, and `build_export_contracts`. Post-regeneration: `generated/oo/appkit/nsevent.rkt` now emits `nsevent-modifier-flags-class` (class variant) alongside `nsevent-modifier-flags` (instance variant) at both the contract and the `define` site; loads cleanly under `runtime_load_libraries_via_dynamic_require`. Added `nsevent.rkt`, `nsscreen.rkt`, and `wkwebview.rkt` to `LIBRARY_LOAD_CHECKS` at `tests/runtime_load_test.rs:131-133`, plus `WebKit` to `REQUIRED_FRAMEWORKS` so the harness copies the WebKit bindings into its temp tree. New unit test: `test_class_method_disambiguation` in `naming.rs`. All 119 Rust unit tests and the full snapshot suite green; all seven sample apps still `raco make` cleanly.

### Fix generated `wkwebview.rkt` referencing unbound `_NSEdgeInsets` `[generation]` `[done]`
- **Completed:** 2026-04-18
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16); anything transitively importing `wkwebview.rkt` cannot load
- **Results:** Verified already resolved. `generated/oo/webkit/wkwebview.rkt:11` emits the `runtime/type-mapping.rkt` require, so `_NSEdgeInsets` is in scope for the `_msg-0`/`_msg-7`/`_msg-8` FFI bindings and for `additionalSafeAreaInsets`, `alignmentRectInsets`, `maximumViewportInset` accessors. The `is_known_geometry_struct`/`any_struct_type` detection chain handles `NSEdgeInsets` properly. Added `wkwebview.rkt` to `LIBRARY_LOAD_CHECKS` and `WebKit` to `REQUIRED_FRAMEWORKS` in `runtime_load_test.rs` so future regressions surface at test time; harness copies WebKit + dependencies and `dynamic-require`s the file successfully.

### Add HIServices/AX functions and constants to ApplicationServices extraction `[collection]` `[medium]`
- **Surfaced by:** racket-oo Task #7 (migration of `ffi/*.rkt` to generated bindings)
- **Symptom:** `applicationservices/main.rkt` is an 8-line stub; no `functions.rkt` is
  emitted at all. Missing: `AXIsProcessTrusted`, `AXIsProcessTrustedWithOptions`,
  `AXUIElementCreateApplication`, `AXUIElementCopyAttributeValue`,
  `AXUIElementSetAttributeValue`, `AXUIElementCopyAttributeNames`,
  `AXUIElementGetPid`, `AXValueCreate`, `AXValueGetValue`. Also absent: AX constants
  (`kAXTrustedCheckOptionPrompt`, `kAXErrorSuccess`, `kAXValueCGPointType`, etc.) and
  CFSTR-macro attributes (`kAXMainAttribute`, `kAXWindowsAttribute`,
  `kAXTitleAttribute`, etc.).
- **Suspected root cause:** The input header-set does not include HIServices headers.
  HIServices is a private subframework of ApplicationServices —
  check whether `ApplicationServices/ApplicationServices.h` transitively includes
  `HIServices/Accessibility.h` and whether the collection config explicitly lists it.
- **Scope:** Once headers are included, verify the CFSTR-macro attributes land correctly
  (they are CFSTR macros, not enum constants). The AX functions should flow through
  the existing C-function path once the headers are present.


### Fix clang-2.0.0 UTF-8 panic on Quartz subframework paths `[collection]` `[medium]`
- **Surfaced by:** racket-oo triage session 2026-04-15
- **Symptom:** The external `clang-2.0.0` Rust crate panics with a UTF-8 error when
  visiting certain Quartz subframework paths during a full collection run. The panic
  fires before any ObjC entity is extracted, aborting collection of the affected framework.
- **Impact:** Blocks adding Carbon, CoreServices, or any umbrella framework that shares
  the Quartz subframework tree to `SUBFRAMEWORK_ALLOWLIST` in `sdk.rs`. Expanding the
  framework set beyond ApplicationServices requires this fix first.
- **Suspected root cause:** A path component in the Quartz subframework tree contains
  non-UTF-8 bytes (or a filename the crate's path handling assumes is valid UTF-8). The
  `clang-2.0.0` crate does not guard its path-to-string conversions.
- **Fix direction:** Either (a) patch the `clang` crate to use lossy UTF-8 conversion for
  path display, or (b) pre-filter subframework paths in `sdk.rs::discover_frameworks()` /
  `is_from_framework()` to exclude the offending Quartz path before libclang visits it.
  Option (b) is lower-risk and avoids a fork of the external crate.
- **Verification canary:** After fix, a full collection run must complete without panic
  when the Quartz subframeworks are reachable.

### Audit `is_definition()` guard in StructDecl / ObjCInterfaceDecl / ObjCProtocolDecl dedup arms `[collection]` `[low]`
- **Surfaced by:** racket-oo cycle learnings (2026-04-16); latent risk identified when EnumDecl forward-decl shadow was fixed
- **Symptom:** None confirmed yet. The `EnumDecl` arm in `extract_declarations.rs` was fixed with an `entity.is_definition()` guard (2026-04-15) to prevent a forward-declaration from winning the `seen_enums` dedup set before the actual definition is visited. The same structural pattern — a `HashSet` inserted on first encounter without an `is_definition()` guard — may exist in the `StructDecl`, `ObjCInterfaceDecl`, and `ObjCProtocolDecl` arms if those arms use similar seen-sets.
- **Suspected root cause:** Forward declarations for ObjC interfaces and protocols (e.g., `@class Foo;`, `@protocol Bar;`) appear in header imports before the defining `@interface`/`@protocol` body. If a seen-set inserts on the first cursor visit, the actual definition is skipped, yielding an empty or stub IR entry.
- **Scope:** Read the three arms in `extract_declarations.rs`. Confirm whether each uses a `HashSet`-based dedup guard. If so, check whether `entity.is_definition()` is already guarded. Add the guard where missing. Write a synthetic test with a forward-declaration followed by a definition. Blast-radius check: regenerate and diff per-framework counts before/after.
- **Note:** The `EnumDecl` fix (2026-04-15) confirmed that forward-decl shadowing produces silently empty IR sections — the cost of missing this guard is high and silent.

### Investigate and filter bare `c:@<name>` macro USRs (leak class A) `[collection]` `[low]`
- **Surfaced by:** racket-oo Task #7 (migration of `ffi/*.rkt` to generated bindings)
- **Symptom:** libclang sometimes exposes a macro through a naked `c:@<name>` USR
  without the `@macro@` prefix. Neither the extract-objc nor extract-swift extractor
  catches this form. Canary: `kAudioServicesDetailIntendedSpatialExperience`
  (AudioToolbox, `AudioServices.h:401`, ObjC source).
- **Suspected root cause:** libclang re-exposes certain `#define` macros as `VarDecl`
  cursors with a `c:@<name>`-form USR rather than `EntityKind::MacroDefinition` —
  possibly for macros that expand to a typed cast. The result lands in extracted IR
  as a constant but has no dylib symbol, causing `get-ffi-obj` failure at runtime.
- **Scope:** Audit extent across all frameworks before adding a filter. Confirm the
  symbol is absent from the dylib via `dyld_info -exports`. Then decide: add a
  denylist by name, add a libclang `is_definition()` / `get_linkage()` secondary
  guard, or detect via failed `get_platform_availability()` + macro expansion path.
  See memory entry "USR prefix families encode declaration origin — bare c:@<name>
  macro variant" for the USR-family context.

### Investigate and filter anonymous-enum members leaking through extract-objc (leak class B) `[collection]` `[low]`
- **Surfaced by:** racket-oo triage session 2026-04-15
- **Symptom:** Anonymous-enum members with `c:@Ea@<dummy>@<member>` or
  `c:@EA@<typedef>@<member>` USRs are correctly filtered by extract-swift's
  `non_c_linkable_skip_reason` predicate, but may leak through the extract-objc
  path if libclang surfaces them as `EnumConstantDecl` children of an anonymous
  `EnumDecl`. Canary: `nw_browse_result_change_identical` (Network framework).
- **Suspected root cause:** extract-objc's `EnumDecl` arm visits all children
  regardless of whether the parent enum has a name. Anonymous enums produce
  constants with no dylib symbol — their values are inlined at use sites — so
  emitting them as `fw.constants` entries causes `get-ffi-obj` failure at runtime.
- **Scope:** Confirm whether the canary appears in Network's `collected/*.json`
  `constants` array (re-collect first). If so, add an anonymous-enum guard in
  `extract_enum` (check `entity.get_name().is_none()` or USR prefix) and record
  skipped members via `skipped_symbol_reason::anonymous_enum_member`. Audit blast
  radius across all frameworks before merging. The extract-swift filter already
  catches the same symbols from that path; the fix closes the extract-objc gap so
  both paths are symmetric.

### [low] IR annotation for OS_OBJECT_USE_OBJC-typed GCD handles
- **Surfaced by:** racket-oo Task (libdispatch `_dispatch_main_q` and `dispatch_queue_t` usage), 2026-04-16
- **Symptom:** When SDK headers are compiled with `OS_OBJECT_USE_OBJC=1` (the macOS default), `dispatch_queue_t` and similar GCD handle types are declared as ObjC objects. The IR maps them to an `_id`-equivalent `TypeRef`. Emitters that obtain a GCD queue value via `ffi-obj-ref`/`dlsym`/pointer arithmetic get a raw pointer, not an `_id`-tagged value — an explicit cast is required before passing to any IR-typed `_id` parameter. Currently each emitter target must discover and apply this cast manually.
- **Scope:** Add an IR-level annotation (e.g. a flag on `TypeRef` or a new `TypeRefKind` variant) marking types that are "ObjC objects via OS_OBJECT macro" rather than "genuine ObjC class declarations". Emitters can then auto-generate the cast for values obtained outside the normal message-send path. Alternatively, document the cast requirement prominently in the emitter contract so future targets don't rediscover it from scratch.
- **Priority:** Low — only bites when a framework exposes a struct global whose declared type is OS_OBJECT-based (currently only libdispatch). The manual workaround (explicit cast at the call site) is well understood. Promote if a second framework triggers the same pattern.

## Completed Tasks

### Fix protocol emitter `method_return_kind` missing int/long primitives `[generation]`
- **Completed:** 2026-04-16
- **Surfaced by:** racket-oo development (2026-04-16); `numberOfRowsInTableView:` (NSInteger/int64) misclassified as void-returning in generated protocol files
- **Summary:** Added int32 → `'int` and int64 → `'long` branches to `method_return_kind` in `emit_protocol.rs`. Landed as Phase 1c of racket-oo FFI Surface Elimination. `numberOfRowsInTableView:` (NSTableViewDataSource) and `tableView:nextTypeSelectMatchFromRow:toRow:forString:` (NSTableViewDelegate) now correctly classified as `'long` instead of `'void`. 6 new unit tests added. All generated AppKit protocol golden files updated. Affects all language targets consuming generated protocol files.

### Fix unsigned enum constant values (signed-component-only extraction) `[collection]`
- **Completed:** 2026-04-15
- **Surfaced by:** racket-oo triage session 2026-04-15 (discovered after EnumDecl forward-decl fix)
- **Summary:** For enums with an unsigned underlying type (`CF_ENUM(uint32_t, ...)`,
  `CG_ENUM(uint32_t, ...)`), `extract_declarations.rs` now canonicalises the underlying
  enum type via `get_canonical_type()` before deciding signedness, and uses the `.1`
  (u64) component of `get_enum_constant_value()` for unsigned-backed enums. Constants
  whose value exceeds `i64::MAX` are skipped with a warning rather than silently
  misrepresented. Verification canary: `kCGEventTapDisabledByTimeout` now emits as
  `4294967294` (not `-2`) in `coregraphics/enums.rkt`. All language targets that consume
  enum IR inherit the corrected values.

### Add libdispatch headers via synthetic pseudo-framework pattern `[collection]`
- **Completed:** 2026-04-15
- **Surfaced by:** racket-oo Task #7 (migration of `ffi/*.rkt` to generated bindings)
- **Summary:** Implemented the synthetic pseudo-framework pattern for libdispatch:
  checked-in umbrella header at
  `collection/crates/extract-objc/synthetic-frameworks/libdispatch/libdispatch.h`;
  `sdk.rs` appends a synthetic `FrameworkInfo` via `synthetic_frameworks()`;
  `is_from_framework` branches on the synthetic name to accept `usr/include/dispatch/`
  paths; emitter's `framework_ffi_lib_arg` in `shared_signatures.rs` maps `"libdispatch"`
  to `"libSystem"` (the actual dylib). `pthread_main_np` deferred — left as manual
  caller-side define. This also established the general synthetic pseudo-framework
  pattern for future system-header extractions outside the standard `.framework` tree.

### Fix EnumDecl forward-decl shadow (seen_enums skipping actual definitions) `[collection]`
- **Completed:** 2026-04-15
- **Surfaced by:** racket-oo triage session 2026-04-15
- **Summary:** The `seen_enums` HashSet dedup guard in `extract_declarations.rs` was
  inserting enum names on the first visit — which for `CF_ENUM`/`NS_ENUM` macros is a
  forward-declaration with no values — causing the actual definition to be skipped.
  Fixed by adding an `entity.is_definition()` guard in the `EnumDecl` arm: only insert
  into `seen_enums` when the cursor *is* a definition. Blast radius: CoreGraphics
  `enums.rkt` 8 → 446 define lines; Foundation `enums.rkt` 212 → 1129 define lines.
  Note: the same latent pattern exists in the `StructDecl`, `ObjCInterfaceDecl`, and
  `ObjCProtocolDecl` arms — not confirmed to cause problems yet, but worth checking
  if those cursor types gain seen-set guards in the future.

### Remove legacy POC serde aliases from `Framework` `[cleanup]`
- **Completed:** 2026-04-15
- **Surfaced by:** Memory entry "Legacy POC serde aliases have no production consumers"
- **Summary:** Dropped all three POC-era serde annotations from
  `collection/crates/types/src/ir.rs::Framework`: removed
  `#[serde(alias = "ir_version", default)]` from `format_version` (kept
  plain `default`), removed `#[serde(rename = "framework")]` from `name`,
  and removed the `ir_level: Option<i32>` field entirely along with its
  13 `ir_level: None,` struct-literal call sites across
  collection/extract-{objc,swift}, analysis/{resolve,annotate,enrich},
  generation/{cli,emit,emit-racket-oo}, and two test files. Rewrote
  `collection/crates/types/tests/deserialize_ir.rs` to use a
  `MINIMAL_FRAMEWORK_JSON` literal with modern keys (`format_version`,
  `name`) — 5 tests covering format_version/name deserialization, post-
  minimum default behaviour, depends_on round-trip, and modern-to-modern
  re-serialise round-trip. Updated design-doc JSON example in
  `docs/specs/2026-03-26-macos-workspace-design.md` and the
  `foundation_serializes_to_json` assertion in
  `collection/crates/extract-objc/tests/extract_foundation.rs` which was
  pinning the old on-the-wire `"framework":` key directly. Full pipeline
  regenerated end-to-end (collect + analyze) across all 283 frameworks —
  Foundation.json confirmed writing `"name": "Foundation"` at top of
  file. Workspace green at 451/451 tests. Retires the "Legacy POC serde
  aliases have no production consumers" memory entry.

### Qualify Swift overload names with parameter labels `[collection]`
- **Completed:** 2026-04-15
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** Changed the `Func` arm in
  `collection/crates/extract-swift/src/declaration_mapping.rs::map_abi_to_framework`
  to record `child.printed_name.clone()` instead of `child.name.clone()`
  when pushing into `fw.skipped_symbols`. `fw.functions[]` remains
  unchanged to preserve FFI compatibility — the qualification only
  affects observability in the skipped_symbols audit list. The `Var`
  arm was not touched because Swift constants do not overload and
  `printed_name == name` for vars. Blast radius: synthetic
  `createDefaultWidget` test fixture now shows as
  `"createDefaultWidget(name:)"`; 4 existing synthetic filter tests
  (swift-native/macro/anon-enum Func arms, Foundation overlay regression)
  updated to use `"swiftNative()"`, `"MIN()"`, `"anon_enum_func_a()"`,
  `"pow()"`, `"NSLocalizedString()"` shapes. Real-SDK pipeline
  regenerated: `(name, kind)` duplicate groups in `skipped_symbols`
  across all frameworks dropped from **18 → 12**. The 12 remaining are
  true type-based Swift overloads that share parameter labels but
  differ only in types (e.g. CoreML `pointwiseMin(_:_:)`×3 with
  different tensor element types, TabularData `/(_:_:)`×4 for numeric
  operator variants, Network `withNetworkConnection(to:using:_:)`×4).
  Full signature disambiguation is out of scope for this task — the
  task description explicitly specified the `printed_name` form
  (e.g. `pointwiseMin(_:_:)`) and my fix implements exactly that.
- **Follow-ups:**
  - 12 type-based Swift overload collisions in `skipped_symbols`
    still present. Disambiguating would require embedding the mangled
    Swift type signature or the parameter type list into the name —
    both deviate from the task's "printed_name matches objc owner.selector"
    design. Defer unless a concrete consumer actually reads these
    entries and cares about the duplication.

### Test `depends_on` / `extract_imports` output in extract-swift `[testing]`
- **Completed:** 2026-04-15
- **Surfaced by:** Follow-up from "Real-SDK integration test harness" (2026-04-14)
- **Summary:** Added four assertions to the existing real-SDK
  integration harness: `coretext_depends_on_contains_foundation` and
  `coretext_depends_on_excludes_private_imports` in
  `tests/extract_coretext.rs`;
  `network_depends_on_contains_foundation_and_dispatch` and
  `network_depends_on_excludes_private_imports` in
  `tests/extract_network.rs`. Together they pin that
  `extract_imports` actually produces non-empty output end-to-end
  (Foundation for CoreText; Foundation + Dispatch for Network) and
  that the `_`-prefixed private-import filter inside `extract_imports`
  is honoured. These are the first real-SDK assertions on
  `depends_on` — the synthetic fixture tests cover filter shape, these
  pin the digester's actual `Import`-node output. Full workspace
  count: 455/455 tests green (+4 from this task), clippy clean, fmt
  clean.

### Rewrite `deserialize_ir.rs` as synthetic schema-evolution test `[testing]`
- **Completed:** 2026-04-14
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** Replaced 16 fixture-coupled assertions (244 lines, all
  loading `APIAnyware/ir/level1/Foundation.json` which no longer
  exists) with 6 focused tests (88 lines) driven by one inline
  `LEGACY_POC_JSON` literal in `collection/crates/types/tests/deserialize_ir.rs`.
  Pins the load-bearing schema-evolution contract: `ir_version` →
  `format_version` serde alias, `framework` → `name` rename via
  `#[serde(rename)]`, `ir_level` legacy field preserved on
  deserialisation, and `serde(default)` behaviour for every post-POC
  field (`sdk_version`, `collected_at`, `checkpoint`, `skipped_symbols`,
  `class_annotations`, `api_patterns`, `enrichment`, `verification`).
  Adds a legacy→modern→legacy round-trip that confirms re-serialised
  output drops `ir_level` per `skip_serializing` and re-parses cleanly.
  Workspace test count went 437 → 452 (+15: 6 from this rewrite, 9 from
  the prior real-SDK integration work which had not appeared in the
  earlier baseline). The "Prefer synthetic tests over SDK-dependent
  tests" memory rule is now actually enforced for this file.
- **Correction to task framing:** The pending-task description said
  the test "silently skips → false-green CI". The actual code was
  `unwrap_or_else(|e| panic!(...))` — the test was loudly failing on
  main, not silently passing. The fix is the same regardless of the
  mechanism, but future triage should not assume "stale fixture"
  implies silent-skip — read the load helper. Reinforces the
  "Backlog task descriptions are hypotheses" memory rule.

### Fix formatting drift in `extract_network.rs` `[testing]`
- **Completed:** 2026-04-14
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** `cargo +nightly fmt -- collection/crates/extract-swift/tests/extract_network.rs`
  cleared the pre-existing fmt drift on main. Workspace
  `cargo +nightly fmt --check` now passes clean. Bundled into the same
  work cycle as the `deserialize_ir.rs` rewrite — both are tiny
  collection-tree hygiene fixes from the same follow-up triage cluster,
  share the same evidence trail, and want to ship together.

### Surface ObjC silent-filter decisions into `skipped_symbols` `[observability]`
- **Completed:** 2026-04-14
- **Summary:** New `apianyware_macos_types::skipped_symbol_reason` module
  centralises five tagged `&'static str` constants — `internal_linkage`,
  `platform_unavailable_macos`, `swift_native`, `preprocessor_macro`,
  `anonymous_enum_member`. Each reason string starts with its tag so
  downstream audit tooling can match via `reason.contains("<tag>")`.
  extract-objc now threads a `&mut Vec<ir::SkippedSymbol>` through
  `extract_class`, `extract_protocol`, `extract_method`, `extract_property`,
  `extract_category`, `extract_function`, `extract_constant` via a new
  `record_skip` helper. Methods and properties qualify the recorded name
  as `"{owner}.{selector|property}"` so class-level context survives. The
  dead-code `"extraction failed"` outer record for classes was removed.
  extract-swift now references the same constants instead of inline
  strings. 12 new regression tests added across the two filter test
  files (internal linkage: +3, platform unavailability: +9). Pipeline
  re-collected end-to-end — 3,927 skipped symbols now recorded across
  283 frameworks: 2,528 `platform_unavailable_macos` (65 frameworks,
  top: AVFoundation 633 / Intents 372 / ARKit 367 / SensorKit 250),
  1,016 `internal_linkage` (newly visible; AppKit alone 390), 205
  `anonymous_enum_member`, 148 `swift_native`, 30 `preprocessor_macro`.
  Canonical double-count cases (NSLog, NSApplicationMain) verified
  single-entry: both land once in `fw.functions` from extract-objc and
  once in `fw.skipped_symbols` as `swift_native` from extract-swift,
  with no objc-side skip record since they're externally linked and
  macOS-available. The 30 duplicate (name, kind) pairs that do exist
  in `collected/*.json` are all CoreML/CreateML Swift overloads with
  the same printed simple name (`pointwiseMin`, `show`,
  `maximumAbsoluteError`) — a pre-existing extract-swift behaviour,
  not introduced by this change. Retires the "Silent filters create an
  observability gap vs skipped_symbols" memory entry.
- **Follow-ups:**
  - Swift overload printed-name collisions are now visible as duplicate
    entries in `skipped_symbols`. Consider qualifying the `name` field
    with parameter labels in extract-swift (e.g. `pointwiseMin(_:_:)`)
    for uniqueness, matching how extract-objc qualifies methods with
    their owner class.
  - Pre-existing workspace test failures unrelated to this task:
    `collection/crates/types/tests/deserialize_ir.rs` still points at
    the legacy `APIAnyware/ir/level1/Foundation.json` path that no
    longer exists. Fix or delete per the "Prefer synthetic tests over
    SDK-dependent tests" memory rule.
  - Pre-existing formatting drift in
    `collection/crates/extract-swift/tests/extract_network.rs` (fmt
    check fails on main, not touched by this task).

### Real-SDK integration test harness for extract-swift `[testing]`
- **Completed:** 2026-04-14
- **Summary:** Added `tests/extract_coretext.rs` (4 tests) and
  `tests/extract_network.rs` (5 tests) invoking `swift-api-digester`
  against the installed macOS SDK via the existing
  `extract_swift_framework` pipeline. CoreText canaries the `c:@macro@`
  filter (all 15 `kCTVersionNumber*` macros absent from `fw.constants`,
  recorded into `skipped_symbols` with "preprocessor macro cursor"
  reason) plus a `CTGetCoreTextVersion` positive control. Network
  canaries the `c:@Ea@`/`c:@EA@` filter (all 7
  `nw_browse_result_change_*` anonymous-enum members absent, ≥50
  anonymous-enum entries in `skipped_symbols`) plus >400 `nw_*`
  functions and `nw_parameters_create` positive controls. Production
  surface already existed; the gap was test coverage, not
  infrastructure. 14/14 extract-swift tests green, clippy clean.
  Retires memory entries "Real-SDK canary gap is extract-swift only"
  and "extract-swift tests use pre-captured fixtures only".
- **Follow-ups:** `depends_on` / `extract_imports` output untested;
  harness re-runs digester (~2s per framework) on every `cargo test`
  — watch cumulative cost if more frameworks are added.

### Platform-availability filter for ObjC methods, classes, protocols `[collection]`
- **Completed:** 2026-04-14
- **Summary:** Extended `is_unavailable_on_macos` to gate `extract_class`
  (wholesale drop), `extract_protocol` (wholesale drop), and
  `extract_method` (per-selector). Blast radius: 53 frameworks, −450
  classes, −151 protocols, −2,982 class methods, −414 protocol methods.
  15 regression tests added. Per-property filter deferred to separate task.

### Per-property availability filter for ObjC properties `[collection]`
- **Completed:** 2026-04-14
- **Summary:** Added `is_unavailable_on_macos` gate to `extract_property`,
  completing the ObjC platform-availability filter quartet (methods, classes,
  protocols, properties). Blast radius: 303 properties dropped across 31
  frameworks (AVFoundation −223, 74% of total). TDD: 4 tests on synthetic
  `MixedClass` fixture. Full workspace green (437/437). Not yet committed
  (pending alongside larger emitter rewrite WIP).

### Stale Foundation/AppKit golden snapshots `[testing]`
- **Completed:** 2026-04-14
- **Summary:** Updated `main.rkt` (−1 iOS-only class) and `constants.rkt`
  (−13 iOS/tvOS-only symbols) in the Foundation golden subset to match
  the availability-filter blast radius. AppKit goldens already clean.
  Workspace tests restored to green. Not yet committed (same WIP context).
