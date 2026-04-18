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

### Fix `make-objc-block` to treat `#f` as a no-op lambda `[runtime]` `[high]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16); completion-handler arguments set to `#f` caused `(apply #f ...)` crash on block invocation
- **Symptom:** `make-objc-block` in `runtime/block.rkt` stores its `proc` argument directly. Passing `#f` (the idiomatic "no completion handler" value in Racket ObjC code) causes `(apply #f args)` on the first invocation — a Racket error. Callers currently must pass an explicit `(lambda args (void))` as a workaround.
- **Fix direction:** At the top of `make-objc-block`, normalise `#f` → `(lambda args (void))` before storing `proc`. One-line fix with no impact on callers that already pass a real procedure.
- **Scope:** `runtime/block.rkt` only. Low risk.

### Fix duplicate definition in generated `appkit/nsscreen.rkt` `[generation]` `[high]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); `(require … nsscreen)` failed at module load
- **Symptom:** `generated/oo/appkit/nsscreen.rkt` contains a duplicate `define` that prevents the module from loading at all. Any code that `require`s NSScreen bindings must use raw `tell` as a workaround.
- **Fix direction:** Regenerate after identifying and fixing the duplicate in the emitter. Likely a method or property declared both directly on the class and via a category, not deduplicated before emission. Check `emit_class.rs` deduplication logic.
- **Scope:** Regenerate `appkit/nsscreen.rkt` after emitter fix; verify module loads cleanly.

### Fix unbound `_NSEdgeInsets` in generated `webkit/wkwebview.rkt` `[generation]` `[high]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); any module that transitively `require`s WKWebView bindings fails to load
- **Symptom:** `generated/oo/webkit/wkwebview.rkt` references `_NSEdgeInsets`, which is not bound in the generated WebKit FFI layer. The module fails at load time, blocking any application that imports WKWebView — including mini-browser and similar apps that rely on a full app-load path.
- **Suspected root cause:** `NSEdgeInsets` is a struct typedef in AppKit, not WebKit. The WebKit emitter references the FFI type but does not import or re-export the AppKit struct definition. Either the emitter must emit a cross-framework `require` for `_NSEdgeInsets`, or the struct definition must be placed in a shared location accessible to both.
- **Fix direction:** Determine whether `NSEdgeInsets` maps to `TypeRefKind::Struct` in the IR. If so, ensure the WebKit emitter imports the AppKit cstruct definition (or a shared geometry module) before using `_NSEdgeInsets`. Regenerate and verify module load.
- **Scope:** Emitter cross-framework struct import logic. Regenerate `webkit/wkwebview.rkt` after fix; verify transitive `require` works from a standalone module.

### Fix generated `CFStringGetCStringPtr` return contract to allow `#f` `[generation]` `[medium]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); contract violation when `CFStringGetCStringPtr` legitimately returned NULL
- **Symptom:** The generated contract for `CFStringGetCStringPtr` in `generated/oo/corefoundation/functions.rkt` (or equivalent) declares a `string?` return contract. `CFStringGetCStringPtr` legitimately returns NULL when the string's internal encoding does not match the requested encoding — a documented, common case. The contract fires a violation on every NULL return. Callers must currently override with a local `_pointer` binding and NULL-safe fallback.
- **Root cause:** The memory entry "const char * maps to TypeRefKind::CString" states the correct return contract is `(or/c string? #f)`, but the emitter may be generating `string?` alone without the `#f` branch for some code paths.
- **Fix direction:** Audit `map_return_contract` in the emitter for `TypeRefKind::CString` — ensure it always emits `(or/c string? #f)`, not `string?` alone. Regenerate affected functions.rkt files.
- **Scope:** Emitter contract mapper only. Verify `CFStringGetCStringPtr` and any other `const char *`-returning function in the generated bindings.

### Add Racket `.app` bundler for distributable builds `[generation]` `[medium]` `[done 2026-04-18]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); Modaliser's `.app` bundle currently uses absolute symlinks into the APIAnyware-MacOS source tree, making it machine-specific and non-distributable
- **Symptom:** Racket app bundles built against APIAnyware-MacOS bindings symlink `bindings/` and `runtime/` from the source tree. The bundle cannot be sent to another machine or deployed without path surgery — the stub-launcher handles CDHash uniqueness but not self-contained distribution.
- **Results (2026-04-18):** Gap was narrower than framed — `bundle-racket-oo` already *copied* files; Modaliser-Racket was bypassing it entirely via its own `bundle/build.sh`. Two additional blockers in the existing bundler: (a) the entry path was hardcoded to `apps/<script>/<script>.rkt`, (b) `collect_dependencies` called `.canonicalize()` on require targets and rejected anything whose canonical path resolved outside `source_root`, which killed symlinked-subdir layouts like Modaliser's `bindings/` → APIAnyware-MacOS. Fix: new `bundle_app_with_entry(spec, entry, source_root, output_dir)` public API; switched the walker to absolute+logical normalization (`std::path::absolute` + `.`/`..` collapse, no symlink resolution) so symlinks inside the require tree are preserved in bundle layout while `fs::copy` transparently reads through them. Derived `script_resource_dir` / `script_resource_name` / `script_resource_type` from the entry's path relative to `source_root`. New unit tests: symlink-through-external-dir traversal, parent-traversal-through-symlink logical-path preservation, `derive_script_resource_dir` for root and nested layouts. New integration test: Modaliser-layout bundle with symlinked bindings. All 32 bundle-racket-oo tests pass (including `bundles_every_sample_app`).
- **Follow-up:** Modaliser-Racket can now migrate its `bundle/build.sh` to `bundle_app_with_entry`, but will additionally need Info.plist customization (LSUIElement, NSAccessibilityUsageDescription, NSScreenCaptureUsageDescription, AppIcon.icns) plus a stable signing identity to solve the TCC/CDHash instability noted in the original task. Those Info.plist extensions are a separate bundle-racket-oo feature not addressed here; dylib `@rpath` patching was not needed (bundle copies real files, not symlinks).
- **Fix direction:** Survey what Modaliser's `.app` currently symlinks. Enumerate the minimal transitive closure of `bindings/` and `runtime/` files. Design the bundler to copy them and rewrite `raco` collection paths or use `PLTCOLLECTS` to point inside the bundle. Coordinate with `stub-launcher` (already handles the Swift/CDHash step) so the two tools compose cleanly.
- **TCC/CDHash instability:** A related and more immediate symptom (tracked as `bundle-rebuild-invalidates-tcc` in Modaliser-Racket) is that ad-hoc codesigning means every rebuild produces a new CDHash, invalidating any prior TCC grant for Accessibility/Screen Recording. Users must re-grant after each build. This is a direct consequence of not having a stable signing identity. The bundler should either: (a) use a stable Developer ID or self-signed certificate so the identity persists across rebuilds, or (b) document the re-grant workflow clearly. Option (a) is the correct long-term fix.
- **Scope:** New generation-layer tooling only. Does not block runtime correctness — only distributable builds. `stub-launcher` already exists; this extends the bundling story from "unique CDHash" to "fully self-contained `.app`" with a stable signing identity.

### Fix generator type mapping for AXValueCreate/AXValueGetValue/CFNumberGetValue: `_uint64` should be `_uint32` or correct enum type `[generation]` `[medium]` `[done 2026-04-18]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-16)
- **Triaged 2026-04-18, deferred then picked up same session:** The honest fix is broader than the task's three-function scope. `TypeRefKind::Alias` carries `name` only (`collection/crates/types/src/type_ref.rs:28`), so `RacketFfiTypeMapper::map_type` at `generation/crates/emit/src/ffi_type_mapping.rs:167` has no underlying width to consult and defaults to `_uint64` for every enum typedef — correct for `NS_ENUM(NSUInteger, …)`, wrong for `CF_ENUM(uint32_t, …)` (AX) and for `NS_ENUM(NSInteger, …)` (signedness flip). The principled fix — resolve `entity.get_enum_underlying_type()` at extraction in `collection/crates/extract-objc/src/type_mapping.rs:315`, either via a new `Primitive` emission or by extending `Alias { underlying_primitive: Option<String> }` — changes the FFI signature for enum parameters across every framework, requiring a full golden-snapshot refresh and caller-side audit for any code that relied on the `_uint64` default.
- **Results (2026-04-18):** Took Option A. Extended `TypeRefKind::Alias` with `underlying_primitive: Option<String>` (serde default + skip_if_none, backward-compatible). New `enum_underlying_primitive()` helper in `collection/crates/extract-objc/src/type_mapping.rs` resolves the underlying type via `Entity::get_enum_underlying_type()` → `Type::get_canonical_type()` (the canonicalization step is load-bearing: CF_ENUM(UInt32, …) reports the `UInt32` typedef, not the underlying `unsigned int`, so without canonicalization the primitive name came through as `"UInt32"` and the FFI mapper's match missed). Populated at both enum-typedef and bare-enum extraction sites. FFI mapper now consults `underlying_primitive` for `Alias` kinds and falls back to `_uint64` when `None` (preserves behavior for older IR / non-enum aliases). Extracted a shared `racket_ffi_type_for_primitive` helper so the same name→Racket mapping is used for both `Primitive` and `Alias` paths. Updated ~37 `TypeRefKind::Alias { name, framework }` construction sites across emit-racket-oo, emit, ffi_type_mapping tests, and function_pointer_roundtrip. Full pipeline regenerated: AXValueCreate now `_uint32 _pointer -> _pointer` (was `_uint64 _pointer -> _pointer`); AXValueGetValue now `_pointer _uint32 _pointer -> _bool`; CFNumberGetValue now `_pointer _int64 _pointer -> _bool` (CFNumberType → NSInteger → signed 64). 17 appkit/foundation golden snapshots refreshed via `UPDATE_GOLDEN=1`; the enum-typed accessor deltas (e.g. `nscolor-type` flipped `_uint64` → `_int64` for `NSColorType`) are the principled, correct changes. New unit tests: `racket_alias_uses_underlying_uint32_when_known`, `racket_alias_uses_underlying_int64_for_nsinteger_enum`, `racket_alias_falls_back_to_uint64_when_underlying_unknown`. All 544 workspace tests pass, `cargo clippy --workspace --all-targets -- -D warnings` clean.
- **Suspected root cause:** The IR type mapper resolves the relevant `CFTypeID`/enum parameters to a generic integer width without consulting the typedef's underlying type (e.g. `AXValueType` is `uint32_t`, not `uint64_t`).
- **Fix direction:** Option A: extend `TypeRefKind::Alias` with `underlying_primitive: Option<String>`, populate at extraction from `entity.get_enum_underlying_type()`, consult in the FFI mapper. Option B: change `TypeKind::Enum` in `map_typedef` to emit `TypeRefKind::Primitive { name: <resolved> }` directly. Option B is simpler but deviates from the 2026-04-15 design rationale for keeping enum typedefs as `Alias`. Cross-reference against `HIServices/Accessibility.h` and `CoreFoundation/CFNumber.h`.
- **Scope:** Affects at least three functions in ApplicationServices/CoreFoundation. The real blast radius is every enum-typedef parameter across all 283 frameworks. Do the full audit rather than a name-matched special case.

### Add HIServices/AX functions and constants to ApplicationServices extraction `[collection]` `[medium]` `[done pre-2026-04-18, backlog stale]`
- **Surfaced by:** racket-oo Task #7 (migration of `ffi/*.rkt` to generated bindings)
- **Results (2026-04-18):** No code change required — the work was already landed via the 2026-04-15 Modaliser gap batch (see memory entry "Modaliser gap batch landed 2026-04-15"). Current state verified: `applicationservices/main.rkt` is 20 lines (re-exports), not the 8-line stub the task described; `functions.rkt` (908 lines) contains all 9 AX functions (`AXIsProcessTrusted`, `AXIsProcessTrustedWithOptions`, `AXUIElementCreateApplication`, `AXUIElementCopyAttributeValue`, `AXUIElementSetAttributeValue`, `AXUIElementCopyAttributeNames`, `AXUIElementGetPid`, `AXValueCreate`, `AXValueGetValue`); `constants.rkt` (1292 lines) emits CFSTR-macro attributes via `_make-cfstr` (`kAXWindowsAttribute`, `kAXTitleAttribute`, `kAXFocusedWindowAttribute`, etc.) and plain globals (`kAXTrustedCheckOptionPrompt`, `kAXErrorSuccess`); `enums.rkt` carries the modern `AXValueType` enum members (`kAXValueTypeCGPoint = 1`, etc.). The only backlog-listed constant missing is `kAXValueCGPointType` (and its siblings), which are `static const UInt32` aliases for the enum members — they're deliberately filtered by the internal-linkage rule (memory "extract-objc filters: internal linkage"). Apple's own header comment says they'll be deprecated shortly; callers should use `kAXValueTypeCGPoint` directly. No action taken; task is dead-letter closure. Regression coverage: `collection/crates/extract-objc/tests/extract_applicationservices.rs` (3 tests) already pins the AX-function and CFSTR-attribute invariants.


### Fix clang-2.0.0 UTF-8 panic on Quartz subframework paths `[collection]` `[medium]` `[done 2026-04-18]`
- **Surfaced by:** racket-oo triage session 2026-04-15
- **Results (2026-04-18):** Hypothesis in the task description was wrong about both the trigger and the location — a clean example of the "backlog task descriptions are hypotheses" memory rule. Real trigger: `Entity::get_comment_brief()` (not `File::get_path()` as implied); doc-comment text for some Quartz-subframework cursors contains a stray non-UTF-8 byte (reproduced cases: valid-up-to 20, 21, 22, 32 bytes with `error_len: 1`). clang-2.0.0's `utility::to_string` calls `CStr::to_str().expect("invalid Rust string")`, so the panic is raised normally in Rust code but is then one frame below `extern "C" fn visit` — Rust converts the unwind-across-FFI to a process abort before the visitor can continue. Fix: wrap `get_comment_brief()` in `std::panic::catch_unwind(AssertUnwindSafe(…))` via a reusable `catch_clang_utf8_panic` helper; on panic, the doc comment is dropped (advisory, not load-bearing) and traversal continues. Option (a) patch-the-crate and option (b) pre-filter-paths from the original task framing were both inappropriate for this actual root cause. Validation: reproduced by temporarily adding `"Quartz"` to `SUBFRAMEWORK_ALLOWLIST` — pre-fix aborted with `invalid Rust string: Utf8Error { valid_up_to: 22, error_len: 1 }`; post-fix extracts 27 classes + 161 constants and swallows 3+ distinct panics per run. Reverted the allowlist expansion; adding Quartz/Carbon/CoreServices to the allowlist is now unblocked but out of scope. Regression test: 3 new unit tests for `catch_clang_utf8_panic` (simulated panic → None; successful return → Some(T); Option return-type preservation).

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
