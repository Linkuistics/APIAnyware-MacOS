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

### Fix generator to emit `bool`/`BOOL` return types as `_bool` not `_uint8` `[generation]` `[high]`
- **Surfaced by:** Modaliser-Racket development (2026-04-16); boolean methods silently misidentified as true when returning false
- **Symptom:** The racket-oo emitter maps C `bool`/`BOOL` return types to `_uint8`. In Racket, `_uint8` decodes to an integer, and all integers (including `0`) are truthy — only `#f` is falsy. A method returning `false`/`0` is therefore silently misidentified as true in any boolean context. The correct FFI type is `_bool`, which decodes `0` → `#f` and non-zero → `#t`. Until fixed, callers must wrap boolean returns with `(positive? ...)` or `(not (zero? ...))`.
- **Fix direction:** Audit the FFI type mapper for `bool`/`BOOL` primitive names and emit `_bool` instead of `_uint8`. Regenerate and verify with a method known to return `NO`/`false`.
- **Scope:** `ffi_type_mapping.rs` mapper; regenerate affected bindings. Likely widespread across frameworks wherever `BOOL` return types appear.

### Fix generated `CFStringGetCStringPtr` return contract to allow `#f` `[generation]` `[medium]`
- **Surfaced by:** Modaliser-Racket FFI migration (2026-04-17); contract violation when `CFStringGetCStringPtr` legitimately returned NULL
- **Symptom:** The generated contract for `CFStringGetCStringPtr` in `generated/oo/corefoundation/functions.rkt` (or equivalent) declares a `string?` return contract. `CFStringGetCStringPtr` legitimately returns NULL when the string's internal encoding does not match the requested encoding — a documented, common case. The contract fires a violation on every NULL return. Callers must currently override with a local `_pointer` binding and NULL-safe fallback.
- **Root cause:** The memory entry "const char * maps to TypeRefKind::CString" states the correct return contract is `(or/c string? #f)`, but the emitter may be generating `string?` alone without the `#f` branch for some code paths.
- **Fix direction:** Audit `map_return_contract` in the emitter for `TypeRefKind::CString` — ensure it always emits `(or/c string? #f)`, not `string?` alone. Regenerate affected functions.rkt files.
- **Scope:** Emitter contract mapper only. Verify `CFStringGetCStringPtr` and any other `const char *`-returning function in the generated bindings.

### Add Info.plist customization API to `bundle-racket-oo` `[generation]` `[medium]`
- **Promoted from:** "Add Racket `.app` bundler for distributable builds" follow-up (2026-04-18)
- **Symptom:** The new `bundle_app_with_entry` API assembles a self-contained `.app` bundle but has no mechanism for callers to inject custom Info.plist keys. Apps requiring Accessibility or Screen Recording entitlements need `LSUIElement`, `NSAccessibilityUsageDescription`, `NSScreenCaptureUsageDescription`, and `AppIcon.icns`. Modaliser-Racket currently cannot migrate from `bundle/build.sh` to the new API because of this gap.
- **Fix direction:** Extend `BundleSpec` (or add a new parameter type) with an `info_plist_overrides: HashMap<String, plist::Value>` field. Merge caller-supplied keys into the generated Info.plist after the base template is written. Add tests for key injection and override precedence.
- **Scope:** `bundle-racket-oo/src/bundle.rs` only. No emitter changes required.

### Implement stable signing identity for distributable `.app` bundles `[generation]` `[medium]`
- **Promoted from:** "Add Racket `.app` bundler for distributable builds" follow-up (2026-04-18)
- **Symptom:** Ad-hoc codesigning (`-`) produces a new CDHash on every rebuild, invalidating TCC grants for Accessibility/Screen Recording. Users must re-grant permissions after every build. This is the root cause of the `bundle-rebuild-invalidates-tcc` issue in Modaliser-Racket.
- **Fix direction:** Extend `stub-launcher`'s `create_app_bundle` / `compile_stub` workflow to accept an optional signing identity (Developer ID or self-signed cert with a stable key). When a stable identity is provided, `codesign` with it instead of ad-hoc. Document the self-signed-cert setup path as the recommended local-dev workflow (no Apple Developer account required).
- **Scope:** `generation/crates/stub-launcher/`. Requires `Security.framework` or shell-out to `security` and `codesign`. Does not affect bundle layout or Racket file copying.

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
