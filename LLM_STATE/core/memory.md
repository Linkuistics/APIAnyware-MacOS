# Memory

### Typedef resolution happens at extraction time
ObjC typedef aliases (e.g., NSImageName) must resolve to canonical types during
collection, not downstream. Object pointer typedefs → Id/Class, primitive typedefs →
Primitive, enum/struct typedefs → keep as Alias. Failing to resolve early causes
incorrect FFI signatures in all language targets.

### Swift digester TypeNameAlias must recurse into children
The Swift API digester has two distinct typedef-related node kinds that are easy to
confuse: `TypeAlias` (a type *declaration*, correctly skipped in `declaration_mapping.rs`)
and `TypeNameAlias` (a type *reference* appearing in method signatures). C typedefs like
`CFStringEncoding` appear as `TypeNameAlias` nodes whose first child is a `TypeNominal`
with the resolved underlying type. The fix in `map_swift_type()` recurses into the first
child. Without this, C typedefs produce qualified `Primitive` names (e.g.,
`CoreFoundation.CFStringEncoding`) that no downstream mapper recognizes → `_pointer`.
Childless `TypeNameAlias` nodes fall through to `Primitive` as a safe default. The fix
is load-bearing beyond just CFStringEncoding: after a full Foundation re-extraction,
zero framework-qualified `Primitive` names remain in the collected IR.

### Function pointer typedefs need pointee inspection
`map_typedef` must not stop at `TypeKind::Pointer` — it must check whether the pointee
is a `FunctionPrototype` and extract full param/return signatures. The
`TypeRefKind::FunctionPointer` variant (added to `type_ref.rs`) carries the full
signature. Without this, callback typedefs like `CGEventTapCallBack` resolve to plain
`Pointer`, losing the signature information needed for correct FFI bindings. Any new
`TypeRefKind` variant requires updating exhaustive matches in `ffi_type_mapping.rs` and
all emitter crates.

### Category properties need dedup by name
ObjC categories can redeclare properties already on the base class. Deduplication by
name (HashSet filter in `extract_declarations.rs`) prevents duplicate entries in the IR.

### Enrichment must filter by framework, using the right scope
Both `build_enrichment_data()` and `build_verification_report()` must receive and filter
by `framework_classes`. The fix pattern: lift `framework_classes` computation to
`build_enriched_framework()` so it can be passed to both functions. Without filtering,
violations from all frameworks bleed into every framework's report when enriched together.

Subtlety: not all enrichment relations filter by the same set. Classes filter by
`framework_classes`, but delegate protocol attribution filters by `framework.protocols`
(declaration site), not `framework_classes` (usage site). A class in FW_A with
`setDelegate:` may reference a protocol declared in FW_B — the protocol belongs to FW_B.
When adding new enrichment relations, choose the correct filtering scope: where the
entity is *declared*, not where it's *used*.

### DriverKit and Tk frameworks should be ignored
DriverKit requires kernel headers not available in user-space SDKs. Tk is a legacy
X11 toolkit. Both are excluded via `IGNORED_FRAMEWORKS` in `sdk.rs`, filtered in
`discover_frameworks()`.

### Cross-framework indexes must span all frameworks
`build_method_index()` and `build_property_index()` in `resolve/checkpoint.rs` must
receive all loaded frameworks, not just the current one. Otherwise cross-framework
inherited methods/properties lose their full metadata (params, return type, property
flags) and fall through to minimal stubs. Same principle applies to any future index
that looks up declarations by class name — if inheritance can cross framework
boundaries, the index must span all frameworks.

### Stub launcher gives each app a unique CDHash for TCC
macOS TCC grants permissions per-CDHash. Without per-app stubs, all apps using the same
runtime binary (e.g., `/opt/homebrew/bin/racket`) share a single TCC permission set.
`apianyware-macos-stub-launcher` (`generation/crates/stub-launcher/`) generates a tiny
Swift binary per app that `execv`s into the language runtime. Key API: `StubConfig` →
`create_app_bundle()` for full `.app` assembly, or `generate_stub_source()` +
`compile_stub()` for custom workflows. The stub is ~50KB and compiles via `swiftc`.

### Prefer synthetic tests over external-data-dependent tests
Tests that depend on extracted SDK data (e.g., `Foundation.json`) silently skip when the
file is absent, creating false-green CI. For core logic (resolution, enrichment,
emission), prefer synthetic tests with deterministic in-memory data. Reserve real-SDK
tests for integration-level validation of extraction fidelity.

For pipeline-level integration tests (enriched IR → emitter → file output), use
`build_snapshot_test_framework()` from `emit/test_fixtures.rs` — it provides 5 classes,
2 protocols, 1 enum, and 2 constants, exercising all emitter code paths. Minimal
hand-built frameworks are fine for unit-level logic tests but miss edge cases in
end-to-end emission.

### FFI type mapper must normalize primitive names before matching
The `Primitive` match arm in `RacketFfiTypeMapper::map_type()` must not match on exact
lowercase names alone. The Swift API digester produces framework-qualified PascalCase
(`Swift.Void`, `Swift.Bool`, `Swift.Double`) and ObjC uses uppercase `BOOL`. The fix
pattern: `normalize_primitive_name()` strips the framework prefix via `rsplit_once('.')`
and lowercases. This applies to both `map_type()` and trait methods like `is_void()`.
Any new language target's FFI mapper will hit the same issue if it matches raw primitive
names.

### Geometry struct mapping must use a single source of truth
The FFI type mapper has three code paths for geometry structs: `is_known_geometry_struct()`
(recognition), `map_geometry_struct_alias()` (Alias kind → Racket type), and the `Struct`
match arm. These drifted apart — structs were recognized but not mapped, falling through
to `_uint64` or `_pointer`. Fix: the `Struct` arm now delegates to
`map_geometry_struct_alias()`, eliminating the duplicate match. When adding new geometry
structs: (1) add to `is_known_geometry_struct()`, (2) add to `map_geometry_struct_alias()`,
(3) add `define-cstruct` to Racket runtime `type-mapping.rkt` with correct field layout.
The authoritative source for discovering missing structs is an IR audit — search collected
JSON for `Alias`-kind entries across Foundation, AppKit, and CoreGraphics.

### extract-objc has two orthogonal extraction-time filters: linkage, availability
extract-objc drops declarations from the IR at two distinct points in
`extract_constant` / `extract_function` (`extract-objc/src/extract_declarations.rs`).
Both filter classes exist because extracting the declaration would cause runtime
`get-ffi-obj: could not find export from foreign library` errors in any
C-FFI target — but the discriminators are independent and both are needed.

1. **Internal linkage.** `static const` variables and `static inline` functions are
   inlined at use sites and emit no dylib symbol. Check
   `entity.get_linkage() == Some(Linkage::Internal)` and skip. Canonical symptoms:
   Foundation's `NSHashTableCopyIn`, `NSHashTableStrongMemory`, `NSHashTableWeakMemory`.
   Note: such symptoms are often *mis*described as "preprocessor macros leaking
   through", but macros never reach `VarDecl`/`FunctionDecl` cursors in libclang —
   they appear as `EntityKind::MacroDefinition`, a different arm entirely.

2. **Platform unavailability.** Clang availability attributes
   (`API_UNAVAILABLE(macos)`, `API_AVAILABLE(visionos(26.0)) API_UNAVAILABLE(macos, …)`,
   etc.) mark declarations that compile successfully but are absent from the dylib's
   exported symbols on macOS. These have ordinary `Linkage::External` and ordinary
   `c:@…` USRs — neither the linkage filter nor any USR-family filter catches them.
   Fix: `is_unavailable_on_macos(entity)` iterates
   `entity.get_platform_availability()` looking for any entry where
   `platform == "macos" || "macosx"` and `unavailable: true`. Missing availability
   data → `false` (absence is not evidence). Canonical canary:
   `kAudioServicesDetailIntendedSpatialExperience` in AudioToolbox.

Blast-radius pattern: both filter classes, when first introduced, dwarfed their
triggering symptoms. The availability filter removed **1,738 symbols across 56
frameworks** (876 constants + 862 functions), with AppKit alone contributing 387
constants — iOS-family UI symbols that AppKit headers declare unavailable on
macOS. Always audit the full framework set after landing a new filter, not just
the triggering framework.

Authoritative verification: `dyld_info -exports <dylib>` lists exactly what the
dynamic linker can resolve at runtime. Note: `clang::Clang` is `!Send + !Sync`,
so synthetic libclang tests must cache a single instance in a `LazyLock`.

Still missing: `extract_method`, `extract_class`, `extract_protocol` do not yet
check platform availability. That leak class fails at *call time* (emitter
bindings → Obj-C selector not found) rather than *load time* (`dlsym`), and is
tracked separately in the backlog.

### Non-C-linkable declarations are filtered in extract-swift by USR prefix family
Top-level `Func`/`Var` nodes from `swift-api-digester` come from several origin
families, and three of them are not reachable via `dlsym` — extracting them produces
runtime `get-ffi-obj` failures in any C-FFI target:

- `s:` — Swift-native declarations; only callable via the Swift ABI
- `c:@macro@` — preprocessor macro cursors; no dylib symbol is emitted
- `c:@Ea@<dummy>@<member>` and `c:@EA@<typedef>@<member>` — anonymous enum
  members (without and with a typedef wrapper, respectively). The integer value
  is inlined by the C compiler at every use site; no dylib export exists.
  Named-enum members (`c:@E@<Enum>@<Member>`) do **not** leak through this
  path — the digester routes them through the dedicated `Enum` → `EnumElement`
  mapping, which already handles them correctly.

All three are handled by a single consolidating predicate
`non_c_linkable_skip_reason(node) -> Option<&'static str>` in
`extract-swift/src/declaration_mapping.rs`, dispatching on USR prefix and returning
a human-readable reason. The `Func` and `Var` arms of `map_abi_to_framework` call
it once and route matches into `skipped_symbols`. Prefer extending this predicate
over parallel helpers when new non-linkable families appear — the prefix-family
dispatch table is the natural growth shape here. The filter is conservative:
missing USRs, `c:`/`c:@F@`/`So` prefixes, and non-Func/Var cursors pass through
unchanged, so Network's 437 `nw_*` C re-exports and AudioToolbox's 58
`AudioFileComponent*` functions are untouched.

Symmetric Func/Var coverage is load-bearing even when one arm looks empty today.
`c:@macro@` and anonymous-enum-member cursors currently appear only as `Var`
nodes, but guarding the `Func` arm costs nothing and survives future digester
releases without a follow-up patch.

Blast radii observed so far (none predictable from their triggering symptoms):
- `s:` filter: 46 leakers in CoreGraphics alone, dozens across other frameworks,
  triggered by 3–5 names in Foundation.
- `c:@macro@` filter: 30 symbols across 5 frameworks (CoreText 15, AudioToolbox 5,
  NetworkExtension 5, Network 4, CoreSpotlight 1), triggered by ~15 in CoreText.
- `c:@Ea@` / `c:@EA@` filter: 205 symbols across just 2 frameworks — Network 150
  (7 `Ea` + 143 `EA`), AudioToolbox 55. Triggered by 7 `nw_browse_result_change_*`
  names. The 2-framework concentration is a structural consequence of modern C
  APIs using named enums; only the `nw_*` and `Audio*` APIs still use the older
  anonymous-typedef-enum idiom.

### USR prefixes are the decisive origin signal in the Swift digester pipeline
USRs in `swift-api-digester` output encode the declaration's origin. The prefix family,
not the extractor's `source` field, is the load-bearing discriminator:

- `s:` — Swift-native declaration; only callable via Swift ABI, not `dlsym`-able
- `c:@F@<name>` — clang-imported C function; exported as `_<name>` in the dylib
- `c:@<name>` — clang-imported C var / enum constant
- `c:@E@<Enum>@<Member>` — named C enum member (`enum Foo { BAR }`); routed
  through the digester's `Enum` → `EnumElement` path, not top-level `Var`
- `c:@Ea@<dummy>@<member>` — anonymous C enum member with no typedef wrapper
  (`enum { BAR };`); reaches top-level `Var`, no dylib symbol
- `c:@EA@<typedef>@<member>` — anonymous C enum member inside a typedef
  (`typedef enum { BAR } Foo_t;`); reaches top-level `Var`, no dylib symbol.
  Note the single-character case difference (`Ea` vs `EA`) — libclang treats
  these as distinct cursor families and both must be filtered together or
  95% of the leak survives
- `c:@macro@<name>` — preprocessor macro cursor; no dylib symbol
- `So<mangled>` — clang-imported Obj-C declaration

When writing filters or transformations that care about "is this a C-linkable symbol",
match on USR prefix family rather than on `source: SwiftInterface`. The `source` field
only tells you which extractor emitted the node; the USR tells you what the node
actually represents. This is the Swift-pipeline analogue of libclang's `Linkage` enum
for the ObjC path — prefer the authoritative origin marker over proxy attributes.

### skipped_symbols is a per-pipeline local record, not a global IR claim
Each extractor records its own filter decisions into `skipped_symbols`, and
`merge.rs::merge_swift_into_objc` appends swift's list onto the objc framework. A single
symbol can therefore appear both in `functions`/`constants` (from one extractor) AND in
`skipped_symbols` (from the other). NSLog is the canonical example: extract-objc keeps
it as a valid C function (`c:@F@NSLog`), extract-swift skips its Swift-ABI overlay
(`s:10Foundation5NSLog…`), the merge's by-name dedup would have dropped the Swift
version anyway, and the final IR carries NSLog exactly once with ObjC metadata while
`skipped_symbols` independently records the Swift-side decision. NSApplicationMain in
AppKit is the same pattern. Do not interpret `skipped_symbols` membership as "this
symbol is absent from the final IR" — it only means "this extractor filtered its own
occurrence". Treat it as a diagnostic log per pipeline, not a global exclusion set.

### libclang macros never reach extract-objc's VarDecl/FunctionDecl paths
A natural guess when debugging "preprocessor macro leaks into Constants" is to add
a filter in `extract-objc/src/extract_declarations.rs::extract_constant`. That fix
location is wrong: libclang surfaces `#define` macros as
`EntityKind::MacroDefinition` cursors, which never reach any of extract-objc's
`VarDecl`/`FunctionDecl` match arms. Macros that appear in Obj-C framework headers
reach the collected IR only via `swift-api-digester`, which re-exports clang macro
cursors as top-level `Var` nodes with USRs of the form `c:@macro@<name>`. The
fix for the CoreText `kCTVersionNumber10_*` class of leaks therefore lives in
`extract-swift/src/declaration_mapping.rs` (see "Non-C-linkable declarations are
filtered in extract-swift"), not in extract-objc. There is a short defensive
comment at `extract-objc/src/extract_declarations.rs::extract_constant` pointing
to the real filter for the next investigator who retraces this path.

### Backlog task descriptions are hypotheses, not diagnoses
When a task frames the root cause ("preprocessor macros leaking through", "mapper
doesn't handle X", "bare `c:@<name>` USRs leak past the filter", "filter the
`c:@Ea@` family"), treat it as a starting hypothesis and re-verify before picking
a fix location. Recent sessions (Swift qualified primitives, geometry struct
drift, internal linkage, Swift-native symbol filter, `c:@macro@` filter,
platform-unavailable externs, anonymous-enum members) all found the real fix
lived somewhere the task didn't suggest. Trace symptom → actual producer →
actual consumer *before* committing to a fix, and record the corrected root
cause in the session log so the distinction survives. The platform-availability
task triggered three misdirection modes simultaneously — wrong layer (not a
USR filter), wrong crate (extract-objc, not extract-swift), and wrong blast
radius (1,738 symbols across 56 frameworks, not 1 in AudioToolbox).

The rule is multi-dimensional — tasks can mislead in six ways, independently:
1. **Wrong layer.** Task says "fix the mapper", fix is actually in extraction.
2. **Wrong crate.** Task names extract-objc, real fix is in extract-swift because
   libclang's cursor-kind model routes the relevant nodes through a different
   pipeline entirely (see the macro-cursor entry).
3. **Wrong blast radius.** Task reports 3 symbols in Foundation; the real scope is
   46 in CoreGraphics and dozens elsewhere. Audit all frameworks before committing,
   not just the triggering one.
4. **Wrong direction even for verify-only tasks.** "The fix already landed, just
   confirm" can also mislead — confirm via *fresh* evidence (re-collect, re-run),
   not via whatever checkpoint happens to be on disk.
5. **Wrong USR-family granularity.** Task names one USR prefix family (`c:@Ea@`),
   the real producer leaks through *two* nearly-identical families (`c:@Ea@` +
   `c:@EA@`) distinguished by a single character of case — or more generally,
   by any subdivision of the stated family that the task conflated. Always grep
   the *symptom space* broadly, not the *USR space* narrowly: list every
   non-linkable constant in the triggering framework and check their USRs with
   a loose regex *before* writing the filter arm. The canary for this session
   (`nw_browse_result_change_identical`) sat in the lowercase `Ea` family; 143
   of its siblings sat in the uppercase `EA` family that the task never
   mentioned. Without the broad grep, a narrow filter would have looked "fixed"
   locally while leaving 95% of the leak in place.
6. **Wrong temporal frame.** The "symptom" was fixed by an earlier session's
   filter, but the evidence the task was filed against predates that filter.
   Every code-fix hypothesis then aims at phantom bugs in current source. The
   2026-04-13 `NEFilterFlowBytesMax` / `CoreSpotlightAPIVersion` task is the
   canonical case: fresh `collected/` already filtered both canaries into
   `skipped_symbols`, but the `resolved/`/`annotated/`/`enriched/` checkpoints
   were 17 days older than the `c:@macro@` filter that would have caught them,
   so the canaries re-appeared in every downstream artifact. No code bug
   existed; the entire task dissolved into a single analysis pipeline
   regeneration. Detect this mode with the mtime sanity check in the
   "Regenerate collected IR" entry: if evidence comes from `resolved/` or
   later, and any `extract-{swift,objc}/src/**` file is newer than the
   checkpoint, regenerate *first* — do not form code-fix hypotheses against
   stale downstream artifacts. This mode also tends to collapse sibling
   backlog tasks: two tasks filed against the same stale evidence may
   dissolve into one regeneration step.

### Measure new-filter blast radius via stash → re-collect → diff
When adding a new extraction-time filter, measure the true scope *before* committing.
The triggering task's canary reports a tiny local symptom, but the real scope is
unpredictable in *both* directions: it has ranged from 30/5 (`c:@macro@`) to
1,738/56 (platform availability) to 205/2 (anonymous enum members) across filters
landed on this project. Previous sessions formed a "10–1000× larger" intuition;
the `Ea`/`EA` session falsified it — sometimes the framework count is *smaller*
than the narrowly-named scope because the leak is a structural property of a
specific C-API convention (anonymous typedef'd enums), not a cross-cutting one.
The discipline is not "expect a big number", it is "measure before committing
so the actual shape guides the fix before you lock it in".

1. `git stash push -- <modified source file>` — keeps the fix in stash, restores the
   working tree to the pre-fix baseline.
2. `cargo run -p apianyware-macos-collect` — full re-collect, ~2 minutes for all
   283 frameworks. Snapshot per-framework `(constants, functions)` counts.
3. `git stash pop` — restores the fix.
4. Re-collect and diff per-framework.

This catches the actual filter delta (semantic removals), not a structural proxy
like `dyld_info -exports` counts or header grep. It surfaces surprising
cross-framework contributors (e.g., AppKit being the single largest contributor
for a task triggered by AudioToolbox) and equally surprising *non*-contributors
(most frameworks untouched by the anonymous-enum filter because they use named
enums). It is reusable for any filter class, ObjC or Swift, and has also caught
wrong-granularity errors mid-diagnosis: an intermediate blast-radius count taken
before the source change is landed will reveal a USR-family subdivision the
task didn't name, letting the filter be widened in the same session.

### Silent filters create an observability gap vs skipped_symbols
The two extract-objc filters (internal linkage, platform availability) return
`None` silently — the skipped symbols are *not* written to the
framework's `skipped_symbols` list. extract-swift's non-C-linkable filter, by
contrast, does record into `skipped_symbols`. The inconsistency means the ~1,738
platform-availability removals and ~handful of linkage removals per framework
are invisible post-hoc: there's no way to audit *what* was filtered, only
*whether* filtering happened.

This is a design tension, not an active bug. extract-swift records into
`skipped_symbols` partly because merge.rs needs the cross-pipeline record for
dedup; extract-objc has no equivalent merge consumer, so silent-return is
idiomatic. A future observability task may surface both ObjC filter classes'
decisions into `skipped_symbols` for auditability — flagged for triage, not
actioned. Be aware when writing audit tooling: `skipped_symbols` today
documents the Swift-side filters only, not the ObjC-side ones.

### Golden-test framework coverage is biased toward Foundation/AppKit
The curated golden-test subset and the synthetic TestKit framework model
mostly Foundation- and AppKit-shaped APIs: ObjC classes, protocols, named enums,
category properties. They do **not** exercise the structural quirks of C-heavy
frameworks — Network's anonymous typedef'd enums, AudioToolbox's
`AudioFileComponent*` families, CoreText's macro-derived version constants.
Every extraction-time leak landed on this project (Swift-native symbol filter,
`c:@macro@` filter, platform-availability filter, anonymous-enum-member filter)
could have been caught at test time by a golden-test framework that covered the
triggering API family, and none were — all were first surfaced by runtime
`dlsym`/`get-ffi-obj` failures in downstream language targets.

Implication for triage: leaks in Network, AudioToolbox, CoreText, CoreMIDI, and
similar C-heavy frameworks will continue to escape CI until their shape is
represented either in the real golden set or in an expanded synthetic fixture.
A "Network golden-test framework" task (and siblings for the other C-heavy
frameworks) belongs in the backlog whenever a new leak in that class lands.
Not a blocker for any single filter, but the meta-reason runtime harnesses
keep discovering these classes of bugs instead of the test suite.

### Regenerate collected IR before using it as evidence
`collection/ir/collected/` is gitignored. Any local run of the collector overwrites
it, and file mtime is not a reliable signal of which source version produced the
on-disk JSON. When verifying that a fix to extraction/type-mapping code lands in
observable IR, re-run `cargo run -p apianyware-macos-collect -- --only <FW>` *before*
grepping the JSON. A disagreement between source and on-disk IR is most likely stale
artifacts, not a missing code path. Applies to `collected/`, `resolved/`,
`annotated/`, and `enriched/` alike.
**Downstream-staleness corollary.** The rule bites hardest on the *analysis*
checkpoints (`resolved/`, `annotated/`, `enriched/`), not just `collected/`. A
fresh `collected/` can sit above a stale `resolved/` for weeks if no one re-ran
analysis after an extraction filter landed. The symptom looks identical to a
"filter leak": a canary symbol is correctly absent from `collected/*.json`'s
`constants` but still present in `resolved/*.json` — it was frozen into the
analysis checkpoint before the filter existed. Every code-fix hypothesis then
points at imaginary bugs in currently-living source.
**Pre-investigation sanity check.** Before forming *any* code-fix hypothesis
against evidence from `resolved/`, `annotated/`, `enriched/`, or a generated
language target, compare the checkpoint's mtime to the mtimes of
`collection/crates/extract-{swift,objc}/src/**`. If any source file is newer,
regenerate the full analysis pipeline (`cargo run -p apianyware-macos-analyze`)
*first*, then re-verify the symptom. The 2026-04-13 `NEFilterFlowBytesMax` /
`CoreSpotlightAPIVersion` task dissolved entirely at this step — 278/283
`resolved/*.json` dated 27 Mar, 283/283 `collected/*.json` dated 13 Apr, and
the `c:@macro@` filter had landed in between. No code change was needed.

### Workspace lint gates need targeted `#[allow]` escape hatches
`cargo clippy --workspace --all-targets -- -D warnings` is the project's lint gate;
keeping it green requires two non-obvious carve-outs.

1. **Ascent-generated code.** The `ascent!` macro in `analysis/crates/resolve/src/program.rs`
   and `analysis/crates/enrich/src/program.rs` expands to code that triggers
   `clippy::clone_on_copy`, `clippy::unused_unit`, and `clippy::needless_lifetimes`
   on Copy-typed relation fields. Clippy reports the spans at the macro invocation
   site, so there is no hand-written expression to rewrite. Both files carry a
   module-level `#![allow(clippy::clone_on_copy, clippy::unused_unit,
   clippy::needless_lifetimes)]` with an explanatory comment. When adding new
   Datalog rules, expect noise on Copy fields — the allow already covers it; only
   add a new lint name if a fresh family appears.

2. **`unsafe_code` is a rustc lint, not clippy.** The workspace sets
   `unsafe_code = "warn"` in `[workspace.lints.rust]`, which fires on Rust 2024's
   newly-unsafe `env::set_var`/`env::remove_var` even inside tests. For the
   `-D warnings` gate to remain useful, rustc lints need the same per-fn `#[allow]`
   discipline as clippy lints — `#[allow(unsafe_code)]` on the specific test fn,
   paired with a SAFETY comment documenting the single-threaded-test invariant.
   Do not relax the workspace setting; do annotate the call sites.

### LLM annotation flows through a dedicated input directory, not checkpoints
The annotate crate has two annotation sources: (1) heuristic annotations written to
checkpoint output dir (read by `load_existing_annotations()`), and (2) LLM-generated
`.llm.json` files loaded from a separate input directory via `--llm-dir` flag (read by
`load_llm_annotations()` in `llm.rs`). LLM annotations take precedence via the existing
merge logic. The three-step workflow: `llm-extract` CLI writes `.methods.json` summaries
of "interesting" methods (block params, error out-params, delegate/observer patterns) →
Claude Code subagent reads summaries + Apple docs → produces `.llm.json` → `annotate
--llm-dir` merges them. This runs within Claude Code for cost reasons (no external API).
