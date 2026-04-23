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
plan under `LLM_STATE/targets/<target>/backlog.md`. Future generation-layer
tasks should be filed directly against the owning per-target plan.

## Tasks

### Investigate and filter bare `c:@<name>` macro USRs (leak class A)

**Category:** `collection`
**Status:** `not_started`
**Dependencies:** none

**Description:**

**Priority:** low

**Surfaced by:** racket-oo Task #7 (migration of `ffi/*.rkt` to generated bindings)

**Symptom:** libclang sometimes exposes a macro through a naked `c:@<name>` USR
without the `@macro@` prefix. Neither the extract-objc nor extract-swift extractor
catches this form. Canary: `kAudioServicesDetailIntendedSpatialExperience`
(AudioToolbox, `AudioServices.h:401`, ObjC source).

**Suspected root cause:** libclang re-exposes certain `#define` macros as `VarDecl`
cursors with a `c:@<name>`-form USR rather than `EntityKind::MacroDefinition` —
possibly for macros that expand to a typed cast. The result lands in extracted IR
as a constant but has no dylib symbol, causing `get-ffi-obj` failure at runtime.

**Scope:** Audit extent across all frameworks before adding a filter. Confirm the
symbol is absent from the dylib via `dyld_info -exports`. Then decide: add a
denylist by name, add a libclang `is_definition()` / `get_linkage()` secondary
guard, or detect via failed `get_platform_availability()` + macro expansion path.
See memory entry "USR prefix families encode declaration origin — bare c:@<name>
macro variant" for the USR-family context.

**Results:** _pending_

---

### Investigate and filter anonymous-enum members leaking through extract-objc (leak class B)

**Category:** `collection`
**Status:** `not_started`
**Dependencies:** none

**Description:**

**Priority:** low

**Surfaced by:** racket-oo triage session 2026-04-15

**Symptom:** Anonymous-enum members with `c:@Ea@<dummy>@<member>` or
`c:@EA@<typedef>@<member>` USRs are correctly filtered by extract-swift's
`non_c_linkable_skip_reason` predicate, but may leak through the extract-objc
path if libclang surfaces them as `EnumConstantDecl` children of an anonymous
`EnumDecl`. Canary: `nw_browse_result_change_identical` (Network framework).

**Suspected root cause:** extract-objc's `EnumDecl` arm visits all children
regardless of whether the parent enum has a name. Anonymous enums produce
constants with no dylib symbol — their values are inlined at use sites — so
emitting them as `fw.constants` entries causes `get-ffi-obj` failure at runtime.

**Scope:** Confirm whether the canary appears in Network's `collected/*.json`
`constants` array (re-collect first). If so, add an anonymous-enum guard in
`extract_enum` (check `entity.get_name().is_none()` or USR prefix) and record
skipped members via `skipped_symbol_reason::anonymous_enum_member`. Audit blast
radius across all frameworks before merging. The extract-swift filter already
catches the same symbols from that path; the fix closes the extract-objc gap so
both paths are symmetric.

**Results:** _pending_

---

### IR annotation for OS_OBJECT_USE_OBJC-typed GCD handles

**Category:** `collection`
**Status:** `not_started`
**Dependencies:** none

**Description:**

**Priority:** low

**Surfaced by:** racket-oo Task (libdispatch `_dispatch_main_q` and `dispatch_queue_t` usage), 2026-04-16

**Symptom:** When SDK headers are compiled with `OS_OBJECT_USE_OBJC=1` (the macOS default), `dispatch_queue_t` and similar GCD handle types are declared as ObjC objects. The IR maps them to an `_id`-equivalent `TypeRef`. Emitters that obtain a GCD queue value via `ffi-obj-ref`/`dlsym`/pointer arithmetic get a raw pointer, not an `_id`-tagged value — an explicit cast is required before passing to any IR-typed `_id` parameter. Currently each emitter target must discover and apply this cast manually.

**Scope:** Add an IR-level annotation (e.g. a flag on `TypeRef` or a new `TypeRefKind` variant) marking types that are "ObjC objects via OS_OBJECT macro" rather than "genuine ObjC class declarations". Emitters can then auto-generate the cast for values obtained outside the normal message-send path. Alternatively, document the cast requirement prominently in the emitter contract so future targets don't rediscover it from scratch.

**Priority justification:** Low — only bites when a framework exposes a struct global whose declared type is OS_OBJECT-based (currently only libdispatch). The manual workaround (explicit cast at the call site) is well understood. Promote if a second framework triggers the same pattern.

**Results:** _pending_

---

### CF struct globals from CoreFoundation absent from collected IR

**Category:** `collection`
**Status:** `not_started`
**Dependencies:** none

**Description:**

**Priority:** low

**Surfaced by:** racket-oo Note Editor app (2026-04-18). Promoted from racket-oo
backlog 2026-04-18: per the 2026-04-18 scope boundary, collection-side gaps
belong in core.

**Symptom:** `kCFTypeDictionaryKeyCallBacks` and `kCFTypeDictionaryValueCallBacks`
(and similar CF struct globals) are absent from the collected IR — they are not
emitted to the per-language `constants.rkt` (or equivalent) by any emitter.
Current racket-oo workaround: raw `get-ffi-obj` call in app code.

**Suspected root cause:** TBD — extractor likely skips struct-typed globals at
some point in the visitor (or libclang surfaces them via a USR form the existing
filters drop). The broader `TypeRefKind::Struct` emit path already exists and works
for geometry constants like `NSZeroPoint`/`NSEdgeInsetsZero`; once these symbols
enter the IR, downstream emitters will pick them up via the existing
`is_struct_data_symbol` branch in the racket-oo constants emitter.

**Scope:** Investigate why the extractor misses these CF struct globals and add
them to the IR so per-language constants emitters can render them as
`ffi-obj-ref` (or equivalent struct-data references). Audit blast radius across
CoreFoundation and adjacent frameworks before merging — there may be a broader
family of `kCF*CallBacks`-style struct globals.

**Results:** _pending_

---

### Emit protocol-inherited methods on class bindings

**Category:** `emission`
**Status:** `not_started`
**Dependencies:** none

**Description:**

**Priority:** medium

**Surfaced by:** SceneKit Viewer sample app (racket-oo target, 2026-04-17).
`SCNNode.runAction:` (via SCNActionable protocol) and `SCNView.setAutoEnablesDefaultLighting:`
(via SCNSceneRenderer protocol) are absent from the generated class bindings.
This is a distinct axis from superclass-inherited methods — the existing
"Emit inherited methods from NSView/NSControl superclasses" entry does not cover
protocol conformance. Workaround: module-local typed `objc_msgSend` aliases
(app-menu.rkt pattern).

When an ObjC class conforms to a protocol, methods declared in
that protocol are not emitted on the class binding — only methods declared directly
on the class or via `@interface` categories appear. Fix: after collecting a class's
direct methods, also walk its conforming protocols (depth-first, deduplicating by
selector name) and emit their methods if not already emitted as direct methods.
The IR already captures protocol conformance via `protocol_names` on `ObjCInterface`;
the emitter needs to use it. Snapshot test updates required.

**Scope:** `emit_class.rs` in `emit-racket-oo`. Snapshot golden file updates needed
for classes with protocol conformance.

**Results:** _pending_

---
