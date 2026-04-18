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

**Scope boundary (2026-04-18):** "Core" is the *shared pipeline* —
collection, analysis, enrichment. Per-language generation (the `emit-*`
crates, language runtimes, bundlers) belongs in the matching per-target
plan under `LLM_STATE/targets/<target>/backlog.md`. A batch of seven tasks
that had accumulated here (runtime fixes, racket-oo emitter bugs,
`bundle-racket-oo` API extensions, stub-launcher signing) was relocated
to `LLM_STATE/targets/racket-oo/backlog.md` on 2026-04-18 because they
never touched collection/analysis/enrichment. Two further low-priority
generation tasks ("Emit inherited methods…", "Strengthen generated
binding contracts…") remain listed below pending a deliberate move — flag
during next triage. Future generation-layer tasks should be filed
directly against the owning per-target plan.

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
