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

### Fix generator type mapping for AXValueCreate/AXValueGetValue/CFNumberGetValue: `_uint64` should be `_uint32` or correct enum type `[generation]` `[medium]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16)
- **Triaged 2026-04-18, deferred:** The honest fix is broader than the task's three-function scope. `TypeRefKind::Alias` carries `name` only (`collection/crates/types/src/type_ref.rs:28`), so `RacketFfiTypeMapper::map_type` at `generation/crates/emit/src/ffi_type_mapping.rs:167` has no underlying width to consult and defaults to `_uint64` for every enum typedef — correct for `NS_ENUM(NSUInteger, …)`, wrong for `CF_ENUM(uint32_t, …)` (AX) and for `NS_ENUM(NSInteger, …)` (signedness flip). The principled fix — resolve `entity.get_enum_underlying_type()` at extraction in `collection/crates/extract-objc/src/type_mapping.rs:315`, either via a new `Primitive` emission or by extending `Alias { underlying_primitive: Option<String> }` — changes the FFI signature for enum parameters across every framework, requiring a full golden-snapshot refresh and caller-side audit for any code that relied on the `_uint64` default.
- **Suspected root cause:** The IR type mapper resolves the relevant `CFTypeID`/enum parameters to a generic integer width without consulting the typedef's underlying type (e.g. `AXValueType` is `uint32_t`, not `uint64_t`).
- **Fix direction:** Option A: extend `TypeRefKind::Alias` with `underlying_primitive: Option<String>`, populate at extraction from `entity.get_enum_underlying_type()`, consult in the FFI mapper. Option B: change `TypeKind::Enum` in `map_typedef` to emit `TypeRefKind::Primitive { name: <resolved> }` directly. Option B is simpler but deviates from the 2026-04-15 design rationale for keeping enum typedefs as `Alias`. Cross-reference against `HIServices/Accessibility.h` and `CoreFoundation/CFNumber.h`.
- **Scope:** Affects at least three functions in ApplicationServices/CoreFoundation. The real blast radius is every enum-typedef parameter across all 283 frameworks. Do the full audit rather than a name-matched special case.

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

### Emit inherited methods from NSView/NSControl superclasses in subclass bindings `[generation]` `[low]`
- **Surfaced by:** racket-oo development (2026-04-16); WKWebView missing `setAutoresizingMask:` inherited from NSView
- **Symptom:** Generated bindings only emit methods declared directly on a class, not methods inherited from superclasses. Callers must fall back to raw `tell` for any inherited method not re-declared on the subclass — defeating the purpose of generated typed bindings.
- **Two fix options:**
  - **(a) Emit inherited methods via IR inheritance chain:** Walk `superclass_name` in `emit_class.rs`, look up ancestor classes in the IR, and include their methods in the subclass binding. Complete coverage but potentially large generated-file size increase and risks emitting methods the dylib does not export for that subclass.
  - **(b) Expose a generic `set-autoresizing-mask!` (and similar) on a shared NSView base:** Add a small set of universally-needed NSView methods to the runtime or a shared `nsview-base.rkt` that any NSView subclass binding can use. Lower risk, lower coverage.
- **Recommended approach:** Start with option (b) for the highest-frequency NSView/NSControl methods (`setFrame:`, `setAutoresizingMask:`, `setBounds:`, `setHidden:`, `setNeedsDisplay`). Escalate to option (a) if the coverage gap repeatedly blocks target development.
- **Scope:** Either option is confined to the generation layer. Regenerate affected subclass bindings and verify the previously-missing methods are callable without raw `tell`.

### Strengthen generated binding contracts beyond `any/c` `[generation]` `[low]`
- **Surfaced by:** Modaliser-Racket development (2026-04-16); contract violations (wrong receiver type, unwrapped `objc-object` vs `_id`, missing `coerce-arg`, PAC-trapping `char*` passed where NSString expected) were not caught at the binding boundary
- **Symptom:** Generated `provide/contract` forms use `any/c` for all parameters and return types. This means: passing the wrong receiver class, passing an unwrapped `objc-object` where `_id` is expected, omitting `coerce-arg`, or passing a raw Racket string where an NSString pointer is required all fail silently or produce late crashes rather than immediate contract violations. The contracts provide no safety net during development.
- **Possible improvements (in ascending implementation cost):**
  - **(a) Receiver-class predicate:** Add a `(is-a? v <ClassName>%)` check on `self` parameter contracts. Catches wrong-class receivers immediately.
  - **(b) Selector arity contract:** Emit a contract verifying the number of positional arguments matches the selector.
  - **(c) Typed parameter contracts:** Map IR type information to Racket predicates (e.g., `_id`-typed params require `objc-object?`, string params require `string?` or `NSString?`).
- **Fix direction:** Start with (a) as the highest-value, lowest-risk improvement. Assess impact on generated file size before committing to (b) or (c).
- **Scope:** Generator change in `emit_class.rs` / `emit_protocol.rs`. Contracts affect generated files only — no runtime changes required for (a) or (b).

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

### IR annotation for OS_OBJECT_USE_OBJC-typed GCD handles `[collection]` `[low]`
- **Surfaced by:** racket-oo Task (libdispatch `_dispatch_main_q` and `dispatch_queue_t` usage), 2026-04-16
- **Symptom:** When SDK headers are compiled with `OS_OBJECT_USE_OBJC=1` (the macOS default), `dispatch_queue_t` and similar GCD handle types are declared as ObjC objects. The IR maps them to an `_id`-equivalent `TypeRef`. Emitters that obtain a GCD queue value via `ffi-obj-ref`/`dlsym`/pointer arithmetic get a raw pointer, not an `_id`-tagged value — an explicit cast is required before passing to any IR-typed `_id` parameter. Currently each emitter target must discover and apply this cast manually.
- **Scope:** Add an IR-level annotation (e.g. a flag on `TypeRef` or a new `TypeRefKind` variant) marking types that are "ObjC objects via OS_OBJECT macro" rather than "genuine ObjC class declarations". Emitters can then auto-generate the cast for values obtained outside the normal message-send path. Alternatively, document the cast requirement prominently in the emitter contract so future targets don't rediscover it from scratch.
- **Priority:** Low — only bites when a framework exposes a struct global whose declared type is OS_OBJECT-based (currently only libdispatch). The manual workaround (explicit cast at the call site) is well understood. Promote if a second framework triggers the same pattern.
