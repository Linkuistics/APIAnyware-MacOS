# Session Log

### Session 1 (2026-04-11) — C function pointer typedef extraction
- Discovery: C function, enum, and constant extraction were already fully implemented
  (FunctionDecl, VarDecl, EnumDecl handlers all present and wired through to JSON)
- Problem: function pointer typedefs (CGEventTapCallBack) resolved to plain `Pointer`
  because `map_typedef` saw `TypeKind::Pointer` canonical type and stopped there,
  never checking if the pointee was a `FunctionPrototype`
- Fix: added `FunctionPointer` variant to `TypeRefKind` (type_ref.rs), updated
  `map_typedef` and `map_type_kind` to detect `FunctionPrototype` pointees and extract
  full param/return signatures via new `map_function_pointer_type` helper
- Updated exhaustive matches in `ffi_type_mapping.rs` and `emit_protocol.rs`
- 7 new tests: 4 serde roundtrip (types crate), 3 integration (CoreGraphics extraction)
- Verified: CG 15 callbacks, CF 28, Security 7. Plan updated: all 3 collection tasks done

### Session 2 (2026-04-11) — Enrichment verification fix
- Bug: `build_verification_report()` didn't filter violations by framework — every
  framework got all violations from all frameworks when enriched together
- Root cause: `build_enrichment_data()` already computed `framework_classes` and filtered
  correctly, but `build_verification_report()` was never given the class set
- Fix: lifted `framework_classes` computation to `build_enriched_framework()`, passed to
  both `build_enrichment_data()` and `build_verification_report()`
- 2 new tests: violation isolation and enrichment data isolation across frameworks

### Session 3 (2026-04-11) — Framework ignore list
- Added `IGNORED_FRAMEWORKS` constant in `sdk.rs` with DriverKit and Tk
- `is_framework_ignored()` public helper for callers that need to check
- Filtering built into `discover_frameworks()` — all consumers benefit automatically
- 3 integration tests: exclusion from results, list non-empty guard, helper consistency

### Session 4 (2026-04-11) — Swift stub launcher crate
- New crate `apianyware-macos-stub-launcher` at `generation/crates/stub-launcher/`
- Purpose: generate per-app Swift stub binaries for TCC-compatible .app bundles.
  Each stub `execv`s into the language runtime, giving it a unique CDHash so macOS
  TCC grants permissions per-app rather than per-runtime-binary
- Public API: `StubConfig` (app_name, runtime_path, runtime_args, script resource
  location, bundle_identifier), `generate_stub_source()`, `generate_info_plist()`,
  `compile_stub()` (swiftc), `create_app_bundle()` (full .app directory assembly)
- Error handling via `StubError` (thiserror): CompilerNotFound, CompilationFailed, Io
- 25 tests: 19 unit (source generation, plist XML, Swift/XML escaping) + 5 integration
  (swiftc compilation produces executable, rejects invalid Swift, bundle directory
  structure, plist content, binary permissions) + 1 doc test
- Zero regressions: all 285 workspace tests pass, clippy clean on new crate
- Workspace Cargo.toml updated with member + workspace dependency entry

### Session 5 (2026-04-11) — Synthetic resolution test coverage
- Audited test coverage across all 14 workspace crates: identified resolution crate as
  highest-risk gap — 19 existing tests all depend on Foundation.json (silently skip if
  absent), zero synthetic tests, zero multi-framework tests
- Created `resolve/tests/synthetic_resolution.rs` with 23 tests using hand-built
  Framework IR (no external data dependency):
  - Ancestry: direct parent, transitive, root-has-none, cross-framework,
    cross-framework transitive (5 tests)
  - Method inheritance: basic inheritance with origin tracking, own-methods-no-origin,
    override replaces parent, class vs instance method namespaces (4 tests)
  - Cross-framework methods: inheritance across framework boundaries, override uses
    child version (2 tests)
  - Properties: inheritance with origin, override replaces parent (2 tests)
  - Ownership: init/new/copy return retained, regular does not (4 tests)
  - Protocol conformance: direct satisfaction, inherited method satisfies (2 tests)
  - Multi-framework isolation: results partitioned correctly per-framework (1 test)
  - Deep chains: three-level effective methods/properties, mid-chain override
    origin tracking (2 tests)
  - Checkpoint: resolved checkpoint field set correctly (1 test)
- All 23 tests pass in ~0ms (pure in-memory Datalog, no I/O)
- Full workspace: all tests pass, clippy clean (pre-existing Ascent macro warnings only)
- Key finding: cross-framework inherited methods lose parameter metadata (minimal Method
  created when method_index lookup fails across framework boundary) — documented behavior,
  not a new bug, potential future improvement

### Session 5b (2026-04-11) — Fix cross-framework metadata loss in resolution
- Bug: `build_method_index()` and `build_property_index()` in `resolve/checkpoint.rs`
  only indexed the current framework's classes. Cross-framework inherited methods/properties
  fell through to a minimal stub with empty params, void return type, and lost property flags.
- Impact: every language target emitting AppKit classes that inherit Foundation methods
  would get wrong signatures — no parameters, void return types, wrong property types
- Fix: changed index builders to take `&[Framework]` (all loaded frameworks) and iterate
  all of them. `build_resolved_framework()` now accepts `all_frameworks` parameter.
  Caller in `resolve_loaded_frameworks()` passes the full frameworks slice.
- 3 new tests: `cross_framework_inherited_method_preserves_params`,
  `cross_framework_inherited_method_preserves_return_type`,
  `cross_framework_inherited_property_preserves_type` — all wrote failing first (TDD),
  then passed after fix
- Total: 26 synthetic resolution tests, full workspace green

### Pre-history (migrated from old plan.md)
- Milestones 1-8 complete: shared types, ObjC/C collection, Swift extraction,
  analysis pipeline (resolve/annotate/enrich), shared emitter framework, test
  infrastructure
- ObjC extractor's `type_mapping.rs` resolves typedefs to canonical types at
  extraction time — critical for correct FFI signatures downstream
- Category property deduplication by name required (HashSet filter in
  `extract_declarations.rs`)
- Typedef aliases (e.g., NSImageName) must resolve to canonical types at collection
  time: ObjC object pointer typedefs -> Id/Class, primitive typedefs -> Primitive,
  enum/struct typedefs -> keep as Alias

### Session 6 (2026-04-11) — Enrichment synthetic tests (multi-framework)
- Added 5 multi-framework integration tests to `analysis/crates/enrich/tests/enrichment_rules.rs`
- Tests exercise cross-framework edge cases in the enrichment Datalog program:
  1. **Cross-framework delegate protocol attribution** — protocol declared in FW_B,
     class with setDelegate: in FW_A → delegate_protocol correctly attributed to FW_B
     (filtered by `framework_protocols`, not `framework_classes`)
  2. **Multi-framework block violation scoping** — both frameworks have blocks, only the
     one without annotations gets violations
  3. **Cross-framework collection iterable isolation** — NSFastEnumeration in FW_A,
     count+objectAtIndex: in FW_B → each sees only its own iterables
  4. **Three-framework comprehensive isolation** — FW_A (error+threading), FW_B (blocks),
     FW_C (iterable+scoped_resource) → all relation types correctly scoped
  5. **Flag mismatch violation scoping** — "copy" family method with `returns_retained=false`
     triggers violation only in its own framework
- Also fixed pre-existing clippy lint: `&[fw.clone()]` → `std::slice::from_ref(fw)`
- Key insight: delegate protocol filtering uses `framework.protocols` (declaration site),
  not `framework_classes` (usage site) — this is the correct semantics but non-obvious
- Total enrichment crate tests: 27 (9 unit + 18 integration), all passing

### Session 7 (2026-04-11) — Emitter integration tests
- Added 6 integration tests to `generation/crates/cli/src/generate.rs` exercising the
  full pipeline path: enriched IR → `run_generation()` → registry → emitter → file output
- Used `build_snapshot_test_framework()` from `emit/test_fixtures.rs` (5 classes, 2
  protocols, 1 enum, 2 constants) instead of the minimal `make_test_framework()`
- Test coverage:
  1. **EmitResult statistics** — counts match fixture (5 classes, 2 protocols, 1 enum)
  2. **File structure** — per-class .rkt files, protocols/, enums.rkt, constants.rkt, main.rkt
  3. **Output content** — generated files contain expected class names, enum values,
     framework references
  4. **All emitters** — both racket-oo (produces files) and racket-functional (stub, zero
     output) handle rich IR without error
  5. **Framework dependencies** — dependent frameworks both generate correctly
  6. **Statistics accumulation** — two rich frameworks produce 2x counts (10 classes, 4
     protocols, 2 enums)
- Discovery: constants emitter writes a framework-name header stub but doesn't emit
  individual constant definitions — potential future task
- Total generate crate tests: 18 (12 existing + 6 new), all passing
- Full workspace: all tests pass, no regressions

### Session 8 (2026-04-11) — LLM annotation integration
- Discovered AppKit enrichment task was already complete: all 284 frameworks have
  enriched IR (not just Foundation as the backlog claimed). Verified AppKit has
  enrichment data (9 sync blocks, 157 async blocks, 2 delegate protocols, etc.)
  and passes verification with 0 violations.
- Implemented LLM annotation integration as a three-step Claude Code workflow:
  1. New `llm-extract` CLI subcommand extracts "interesting" methods from resolved IR
     (those with block params, error out-params, or delegate/observer patterns) and
     writes compact `.methods.json` summaries per framework
  2. Subagent prompt template (`analysis/scripts/llm-annotate-subagent.md`) guides
     Claude Code subagents to read summaries, consult Apple docs, and produce
     `.llm.json` annotation files
  3. Updated `annotate --llm-dir` flag loads `.llm.json` from a dedicated directory
     and merges with heuristic results (LLM takes precedence via existing merge logic)
- Key discovery: the existing `load_existing_annotations()` only read from annotated
  checkpoints (output dir), not from `.llm.json` files. The shell script's output was
  never consumed. Fixed by adding dedicated `llm_dir` input path.
- New `llm.rs` module in annotate crate: `extract_interesting_methods()`,
  `extract_all_frameworks()`, `load_llm_annotations()`, `discover_llm_annotations()`,
  `write_method_summary()`, plus summary types (FrameworkSummary, ClassSummary, etc.)
- 16 new tests covering extraction, loading, roundtrip, discovery, and error cases
- Updated `annotate_frameworks()` signature to accept `llm_dir: Option<&Path>`
- Tested end-to-end: Foundation extraction yields 117 classes, 492 interesting methods
- All 337+ workspace tests pass, clippy clean, formatted

### Session 9 (2026-04-11) — Fix qualified-name primitive type fallthrough
- Bug: The `Primitive` match arm in `RacketFfiTypeMapper::map_type()` matched on exact
  lowercase unqualified names (`"void"`, `"bool"`, etc.), but the Swift API digester
  produces framework-qualified PascalCase names (`Swift.Void`, `Swift.Bool`) and ObjC
  uses uppercase `BOOL` — all falling through to `_pointer`
- Fix: added `normalize_primitive_name()` in `ffi_type_mapping.rs` that strips the
  framework prefix (via `rsplit_once('.')`) and lowercases (`to_ascii_lowercase()`).
  Applied to both the `Primitive` arm in `map_type()` and the `is_void()` trait method.
- Bonus fix: ObjC `BOOL` (from test fixture `type_bool()`) was mapping to `_pointer` —
  now correctly maps to `_bool`. This fixed the golden snapshots: `hidden` property
  getter/setter in tkbutton.rkt and tkview.rkt now use `_bool` instead of `_pointer`,
  causing the `_msg-N` binding numbering to shift (new signature added).
- 2 new test functions: `test_qualified_primitive_names` (7 assertions covering
  Swift.Void return/param, Swift.Bool, Swift.Double, Swift.Float, unqualified
  regression, unknown qualified fallthrough) and `test_is_void_with_qualified_names`
  (3 assertions)
- Unknown qualified names like `CoreFoundation.CFStringEncoding` still fall through to
  `_pointer` — these are typedefs misclassified as `Primitive` at collection time
  (separate collection-level issue, not mapper's responsibility)
- All workspace tests pass, no new clippy warnings

### Session 11 (2026-04-11) — Fix Swift digester TypeNameAlias fallthrough
- Bug: `map_swift_type()` in `extract-swift/src/type_mapping.rs` only handled `TypeNominal`
  and `TypeFunc` node kinds. C typedefs (e.g., `CFStringEncoding`) appear in method
  signatures as `TypeNameAlias` nodes — a distinct type *reference* kind from `TypeAlias`
  (which is a *declaration* kind, already skipped in `declaration_mapping.rs`).
  `TypeNameAlias` fell to the `_` arm → `Primitive { name: "CoreFoundation.CFStringEncoding" }`,
  which no downstream mapper recognized → `_pointer`.
- Root cause analysis: examined `observation_abi.json` fixture and confirmed `TypeNameAlias`
  structure: `kind: "TypeNameAlias"`, first child is a `TypeNominal` with the resolved
  underlying type. E.g., `CFStringEncoding` child = `UInt32` TypeNominal.
- Fix: added `"TypeNameAlias" if !node.children.is_empty() => map_swift_type(&node.children[0])`
  to the top-level match in `map_swift_type()`. Recurses into the resolved type.
  Childless `TypeNameAlias` nodes still fall through to `Primitive` (safe default).
- 4 new tests (TDD — all 3 non-trivial tests failed before fix, passed after):
  `map_type_name_alias_resolves_to_underlying_type` (CFStringEncoding → uint32),
  `map_type_name_alias_resolves_void` (Swift.Void → void),
  `map_type_name_alias_resolves_class` (NSObject class resolution),
  `map_type_name_alias_no_children_falls_back` (graceful degradation)
- Also regenerated golden snapshot files for Foundation and AppKit subset tests
  (`UPDATE_GOLDEN=1`). Foundation golden-foundation/ had diffs from prior emitter changes
  (constants.rkt gained 856 lines, main.rkt gained 2). AppKit golden-appkit/ was entirely
  new (23 curated files across classes, protocols, enums, constants).
- All 349 workspace tests pass, zero failures

### Session 10 (2026-04-11) — Fix geometry struct gaps in FfiTypeMapper
- Bug: `NSEdgeInsets` and `NSAffineTransformStruct` were listed in `is_known_geometry_struct()`
  but NOT in `map_geometry_struct_alias()` — so `is_struct_type()` recognized them but
  `map_type()` fell through to `_uint64`. The `Struct` match arm also lacked them (fell
  to `_pointer`).
- IR audit: searched Foundation, AppKit, and CoreGraphics collected IR for all Alias-kind
  entries. Found 3 additional geometry structs not recognized at all: `CGAffineTransform`,
  `CGVector`, `NSDirectionalEdgeInsets`.
- Fix (3 code paths):
  1. `is_known_geometry_struct()` — added `CGAffineTransform`, `CGVector`,
     `NSDirectionalEdgeInsets`
  2. `map_geometry_struct_alias()` — added all 5 missing mappings: `NSEdgeInsets` →
     `_NSEdgeInsets`, `NSDirectionalEdgeInsets` → `_NSDirectionalEdgeInsets`,
     `NSAffineTransformStruct` → `_NSAffineTransformStruct`, `CGAffineTransform` →
     `_CGAffineTransform`, `CGVector` → `_CGVector`
  3. `Struct` match arm — refactored to delegate to `map_geometry_struct_alias()` instead
     of duplicating the match (eliminates the drift that caused this bug)
- Racket runtime: added 5 `define-cstruct` definitions to `type-mapping.rkt` with correct
  field layouts (NSEdgeInsets 4×double, NSDirectionalEdgeInsets 4×double,
  NSAffineTransformStruct 6×double, CGAffineTransform 6×double, CGVector 2×double)
- TDD: wrote 15 new test assertions across 3 test functions before implementing fix
- All 8 mapper tests pass, clippy clean

### Session N (2026-04-12) — Filter internal-linkage symbols in extract-objc
- Surfacing symptom: racket-oo `constants.rkt`/`functions.rkt` for Foundation were
  unloadable at runtime — `get-ffi-obj` failed with `could not find export from foreign
  library` on names like `NSHashTableCopyIn`, `NSHashTableStrongMemory`,
  `NSHashTableWeakMemory`
- Backlog task framed the cause as "preprocessor macros leaking through extraction"
- Investigation: the leaked symbols are **not** preprocessor macros. They are
  `static const NSPointerFunctionsOptions NSHashTableCopyIn = NSPointerFunctionsCopyIn;`
  — real VarDecls with `static` storage. `static` gives internal linkage, so the
  compiler inlines the value at use sites and emits no dylib symbol. `dlsym` then
  fails at runtime. Same mechanism for `static inline` functions (none in Foundation
  but the filter covers them preemptively).
- Verified against `dyld_info -exports` on the real Foundation dylib — `NSHashTableCopyIn`,
  `NSHashTableStrongMemory`, `NSHashTableWeakMemory` are all absent from the export list,
  confirming the internal-linkage hypothesis.
- Fix: `extract_constant` and `extract_function` in `extract_declarations.rs` now skip
  entities whose `get_linkage()` returns `Some(Linkage::Internal)`. The check uses the
  `clang::Linkage` enum directly — more robust than filtering by cursor kind since
  `MacroDefinition` entities never reach the VarDecl/FunctionDecl match arms in the
  first place.
- Separate leak still present via extract-swift: `NSLocalizedString`, `pow`, and
  `kCFStringEncodingASCII` appear in Foundation's `swift_interface` functions/constants.
  Root cause is different (Swift-only declarations that aren't C-linkable); needs a
  follow-up task in the collection backlog.
- Tests (TDD):
  1. New `tests/filter_internal_linkage.rs` — synthetic SDK test using a tempdir layout
     (`System/Library/Frameworks/LinkageTestFW.framework/Headers/LinkageTestFW.h`) with
     both `extern` and `static`/`static inline` declarations. Four assertions:
     extern const kept, static const filtered, extern function kept, static function
     filtered. Caches `ExtractionResult` in a `LazyLock` since `clang::Clang` is
     `!Send + !Sync` and can only be created once per process.
  2. New assertion in `tests/extract_foundation.rs`: `foundation_skips_static_const_variables`
     — end-to-end regression guard against the real SDK, asserting that `NSHashTableCopyIn`
     and its four siblings are absent from Foundation's extracted constants.
- Results: all 4 new linkage-filter tests pass, all 14 Foundation integration tests
  pass, full workspace `cargo test` green with no new warnings. Clippy warnings on
  extract-objc are pre-existing (map_or, useless vec, manual prefix strip) and untouched.
- Learning: the backlog task description can be slightly off about root cause. The
  symptom (Racket runtime-load failure) was real, but the fix space turned out to be
  "non-external linkage" rather than "preprocessor macros". The libclang `Linkage` API
  is the right tool for this class of problem.

### Session N (2026-04-12) — Verify CFStringEncoding typedef classification
- Task: core backlog "Verify CFStringEncoding typedef classification `[collection]`".
  Explicit verification task — re-run collection on Foundation/CoreFoundation and
  confirm the `TypeNameAlias` recursion fix in `extract-swift/src/type_mapping.rs`
  resolves `CoreFoundation.CFStringEncoding` to its underlying primitive.
- Investigation path:
  1. Searched collected IR. Confirmed the offending entry: `kCFStringEncodingASCII` in
     `collection/ir/collected/Foundation.json` had
     `{"kind": "primitive", "name": "CoreFoundation.CFStringEncoding"}` from
     `source: swift_interface`. CoreFoundation.json's enum `CFStringEncodings`
     (plural) was already fine — that comes through the `objc_header` path as
     `{"kind": "alias"}`, not the swift-interface path.
  2. Inspected `map_swift_type()` in `extract-swift/src/type_mapping.rs:22` — the
     `TypeNameAlias` recursion is present and has a dedicated unit test
     (`map_type_name_alias_resolves_to_underlying_type`, line 402) using a synthetic
     `CFStringEncoding → UInt32` alias node.
  3. Traced the constant extraction path: `map_top_level_constant()` in
     `declaration_mapping.rs:430` calls `map_swift_type(&node.children[0])`, so the
     fix *should* apply to constant types. No bypass.
  4. Ran `xcrun swift-api-digester -dump-sdk -module Foundation` directly and grepped
     raw output for `kCFStringEncodingASCII`. The node shape is
     `Var → TypeNameAlias("CFStringEncoding", printedName="CoreFoundation.CFStringEncoding")`
     with a single child `TypeNominal("UInt32", usr="s:s6UInt32V")`. Exactly what the
     fix expects — there is no edge case to investigate.
  5. Hypothesis became: "the committed Foundation.json is stale". Verified that
     `collection/ir/collected/` is gitignored — file mtime is not a reliable signal of
     which source version produced it, since any local run overwrites it.
- Resolution: re-ran `cargo run -p apianyware-macos-collect -- --only Foundation,CoreFoundation`.
  Post-run: `kCFStringEncodingASCII` resolves to `{"kind": "primitive", "name": "uint32"}`.
  A broader regex search for any `Primitive` entry with a framework-qualified name
  (`"[A-Z][a-zA-Z]*\.`) in the updated Foundation.json returned **zero matches** —
  the `TypeNameAlias` fix is load-bearing for more than just CFStringEncoding, and
  the cleanup is complete.
- Tests: the existing unit test `map_type_name_alias_resolves_to_underlying_type` and
  3 sibling `type_name_alias_*` tests all pass (`cargo test -p apianyware-macos-extract-swift
  type_name_alias` → 4 pass, 0 fail). No new tests added — the synthetic test already
  covers the exact case, and the real-SDK re-run served as an integration check.
- Results: task closed. Follow-up captured in the task's Results block for the
  reflect phase: prune the stale "Known type mapper limitations" entry in
  `LLM_STATE/targets/racket-oo/memory.md` (lines 34–37). The entry now contradicts
  observed pipeline behaviour.
- Meta-learning: the "Backlog task descriptions are hypotheses, not diagnoses" rule
  applies even in the opposite direction. This task's hypothesis — "the fix already
  landed, just verify" — turned out to be correct, but I initially suspected a
  serde deserialization gap or a constant-extraction bypass because the on-disk IR
  disagreed with the source. The real explanation was simpler: gitignored build
  artifacts can silently carry forward old state across fix commits, and file mtime
  is not a diagnosis. Worth surfacing in memory: when verifying a claimed-landed fix
  against on-disk IR, regenerate the IR first; don't trust existing checkpoints.
- Task #1 (`swift_interface` symbol leak filter) intentionally left for a fresh work
  phase per the plan's "one task per work phase" rule. This session did touch
  extract-swift and did build up useful context (raw digester output, constant
  extraction path, abi_types.rs shape), but that context belongs in a fresh session
  where the investigation can be the focus rather than a bolt-on.

### Session N (2026-04-12) — Swift-native symbol filter in extract-swift
- Task: filter non-C-linkable `swift_interface` symbols from extract-swift. Chosen
  approach: "diagnose first, fix second" — trace symptom → producer → actual fix
  layer before committing (explicit user direction, and the standing memory rule
  "Backlog task descriptions are hypotheses, not diagnoses").
- Diagnosis path:
  - Re-ran `cargo run -p apianyware-macos-collect -- --only Foundation` per the
    "regenerate before grepping" memory rule. Confirmed the pre-fix IR had
    `functions=125, constants=838` and contained all four symbols as swift-sourced
    top-level entries — with one wrinkle: the task named 3 (NSLocalizedString,
    pow, kCFStringEncodingASCII), but `NSNotFound` was a silent fourth leaker.
  - Ran `swift-api-digester -dump-sdk -module Foundation -sdk $(xcrun --show-sdk-path)`
    directly on the live SDK. All four symbols carried USRs of the form
    `s:10Foundation…` (Swift-mangled) and `mangledName` `$s10Foundation…`.
    Compared against referenced classes in the same nodes (e.g., `NSDecimalNumber`
    → `So9NSDecimal…`); the `So` prefix for clang-imported Obj-C declarations
    distinguishes them from `s:` Swift-native decls.
  - `dyld_info -exports /System/Library/Frameworks/Foundation.framework/Foundation`
    confirmed none of the four appear as dylib exports; also checked
    CoreFoundation.framework and libSystem.B.dylib — zero matches, ruling out
    "declared-in-Foundation but-exported-elsewhere" as an escape hatch.
  - Broadened the scan across every framework in the SDK with a
    `.swiftmodule`. Output per framework: `<name> <funcs> <vars> <s:funcs>
    <s:vars> <non-s:funcs> <non-s:vars>` plus sample non-`s:` names. Two
    classes of framework emerged:
    * Frameworks with Swift-native top-level leakers (all `s:`): Foundation 3/2,
      Accessibility 2/0, AppKit 1/0, AuthenticationServices 0/2, CoreGraphics
      46/0, CoreML 8/0, CreateML 6/1, CreateMLComponents 9/0, GameController
      0/31, IdentityLookup 0/1, LightweightCodeRequirements 10/0, MetricKit
      2/0, RealityFoundation 5/0, SwiftUICore 4/0, TabularData 10/0, Network
      4/0 (alongside 433/166 legit c:-prefixed re-exports).
    * Frameworks with only C re-exports (all `c:`): AudioToolbox 58/60,
      CoreText 1/15, Network 433/166, NetworkExtension 0/16, CoreSpotlight
      0/3, CoreTransferable 0/1, FSKit 0/2, GameSave 0/2, SharedWithYouCore
      0/2, Vision 0/1, AutomaticAssessmentConfiguration 0/1.
  - Conclusion: the USR prefix is a decisive and narrow discriminator. `s:`
    means "Swift-native declaration; only reachable via Swift ABI; not
    `dlsym`-able". The task's "Foundation, 3 symbols" framing undersold the
    blast radius — **CoreGraphics alone has 46 top-level Swift-native
    functions** that would have broken the moment a Racket CG sample app
    touched FFI. The symptom that drove the task was Foundation-first only
    because racket-oo was exercising Foundation first.
- Fix (in `collection/crates/extract-swift/src/declaration_mapping.rs`):
  added `is_swift_native_declaration(node)` → returns `true` iff
  `node.usr.starts_with("s:")`. Applied to the `"Func"` and `"Var"` arms of
  `map_abi_to_framework` before the existing emission call. Filtered nodes
  are pushed to a new local `skipped_symbols: Vec<ir::SkippedSymbol>` with
  kind `"function"`/`"constant"` and reason "swift-native top-level
  declaration (not c-linkable; only reachable via Swift ABI)". Extended
  `merge.rs::merge_swift_into_objc` to append swift's `skipped_symbols`
  onto the objc framework, so the checkpoint has both pipelines'
  filter decisions in one place (extract-objc's internal-linkage skips
  were already flowing through `result.skipped_symbols`). Conservative
  by design: `c:` USRs, missing USRs, and decls other than `Func`/`Var`
  pass through unchanged, so the 437 nw_* funcs in Network and the 58
  AudioFileComponent* funcs in AudioToolbox are unaffected.
- Tests (TDD, tests written first, seen to fail, then code added):
  - Updated existing fixture test
    `map_test_framework_function_is_filtered_as_swift_native`: the synthetic
    TestFramework fixture's `createDefaultWidget` has a
    `s:13TestFramework…` USR, so under the new contract it must land in
    `skipped_symbols` rather than `functions`. This turned out to be the
    cleanest possible TDD hook — the synthetic fixture already modeled the
    very pattern being filtered.
  - Three new integration tests that build `AbiDocument` inline via
    `serde_json::from_value` (no gitignored-fixture dependency):
    `swift_native_top_level_func_is_skipped_while_c_reexport_is_kept`,
    `swift_native_top_level_var_is_skipped_while_c_reexport_is_kept`, and
    `foundation_swift_overlay_symbols_are_filtered` — the latter pins the
    exact USRs captured from the live digester run.
  - New unit test `merge_carries_forward_skipped_symbols_from_both_sides`
    in `merge.rs` to pin the cross-pipeline flow.
  - `cargo test -p apianyware-macos-extract-swift`: 17 unit + 11
    integration + 2 parse_abi + 3 swift_module_discovery, all pass.
  - `cargo test --workspace`: zero failures. No downstream regressions in
    emit-racket-oo / resolve / enrich / annotate / extract-objc, which
    confirms the filter didn't remove anything those crates were
    depending on.
  - `cargo clippy -p apianyware-macos-extract-swift -- -D warnings`: clean
    after fixing a `doc_overindented_list_items` warning by flattening the
    `is_swift_native_declaration` doc bullet list into prose.
- Verification via re-collection (post-fix):
  - Foundation: `functions=123, constants=836` (down from 125/838);
    `skipped_symbols` contains 5 swift-native entries.
  - **NSLog surprise.** The skipped list has 5 entries, not the 4 the
    digester scan predicted. The 5th is `NSLog`, which turned out to
    have BOTH a real C export
    (`dyld_info -exports Foundation.framework/Foundation` shows `_NSLog`
    at `0x00048BA4`) AND a Swift-ABI overlay declaration
    (`s:10Foundation5NSLog…`). Post-fix, the final IR has `NSLog` exactly
    once, from extract-objc, with `source: objc_header`,
    `variadic: true`, `usr: c:@F@NSLog`. Pre-fix, the Swift-ABI
    declaration was already being discarded by
    `merge.rs::extend_if_absent`'s by-name dedup, so the final observable
    IR is unchanged — the filter just moves the decision earlier and
    records it. Clarifies the semantic of `skipped_symbols`: it is a
    **per-pipeline** record of what each extractor chose not to emit,
    not a global claim about the final IR. `NSApplicationMain` in
    AppKit is the same pattern (1 skipped, C counterpart present).
  - Cross-framework re-audit via a single-shot collector invocation over
    Foundation, AppKit, CoreData, CoreFoundation, CoreGraphics, Network,
    AudioToolbox: zero top-level functions with `source='swift_interface'`
    remain in any framework. Network retains 154 constants with
    `source='swift_interface'` — these are all `c:`-prefixed re-exports
    (NEAppProxyErrorDomain etc.), correctly kept.
- Unexpected findings / out-of-scope:
  - **`c:@macro@…` leakage.** The cross-framework scan surfaced another
    category of non-`dlsym`-able symbols: preprocessor macro cursors with
    USRs like `c:@macro@kCTVersionNumber10_10` (CoreText has ~15 of
    these). They pass through my filter because their USR starts with
    `c:`, not `s:`, and they get emitted as `Constant` entries. Same
    flavor as the extract-objc internal-linkage leak, but through a
    different cursor kind and a different extractor. Deliberately not
    fixed in this session per "one task per work phase"; flagged in the
    backlog task's Results block for triage.
  - **Pre-existing workspace clippy failures.** `cargo clippy --workspace
    -- -D warnings` fails on annotate/enrich/emit-racket-oo/extract-objc/
    resolve with a grab bag of standard clippy lints (`doc_overindented_list_items`,
    `manual_strip`, `needless_lifetimes`, `collapsible_if`, `useless_vec`,
    `clone_on_copy`, `needless_pass_by_ref_mut`, and more). Present on
    `main` and unrelated to this change; flagged for triage as a cleanup
    task.
- Meta-learning:
  - The "one task per work phase" rule paid off. Diagnosis alone — raw
    digester dump, cross-framework scan, `dyld_info` ground-truthing —
    filled most of the session budget. The fix itself was a ~15-line
    USR prefix check; the tests and audit took longer than the code.
    Trying to also address `c:@macro@…` or the pre-existing clippy
    debt would have blurred the investigation and produced a less
    trustworthy patch.
  - USR prefixes are a load-bearing signal for this pipeline: `s:` =
    Swift-native, `c:@F@` = C function, `c:@<Name>` = C var/enum,
    `So` = clang-imported Obj-C, `c:@macro@` = preprocessor macro. The
    digester exposes all of them; downstream code should match on the
    prefix family rather than on `source: SwiftInterface` alone, which
    only tells you which extractor produced the node, not what the
    node represents.
  - `skipped_symbols` is best understood as a per-pipeline local record,
    not a global claim. NSLog being both in `functions` (as ObjC) AND
    in `skipped_symbols` (as Swift-native duplicate) is correct — the
    two extractors independently record their decisions; merge
    reconciles.

### Session — 2026-04-13 — Filter `c:@macro@` preprocessor-macro cursor leaks
- **Task framed the producer wrong.** Backlog entry said extract-objc was
  letting `c:@macro@` macros through via its Constant builder. Tracing
  showed the opposite: extract-objc's `extract_constant` is only reachable
  via `EntityKind::VarDecl`, and preprocessor macros are
  `EntityKind::MacroDefinition`, which has no match arm. extract-objc
  cannot produce these entries. The real producer is extract-swift:
  `swift-api-digester` surfaces clang-imported macros as top-level `Var`
  nodes whose USR is `c:@macro@<name>`, and `is_swift_native_declaration`
  only matched the `s:` prefix. The comment at declaration_mapping.rs:116
  literally said `c:@macro@…` is "handled by extract-objc, not here" —
  documenting an intent that was never implemented. Another data point
  for "Backlog task descriptions are hypotheses, not diagnoses" — this
  one rotated the fix location across crates, not just layers.
- **Implementation:** replaced `is_swift_native_declaration` +
  `SWIFT_NATIVE_SKIP_REASON` with a single consolidating predicate
  `non_c_linkable_skip_reason(node) -> Option<&'static str>` that
  dispatches on USR prefix family (`s:` → swift-native,
  `c:@macro@` → preprocessor macro). Call sites in both `Func` and
  `Var` arms collapse to `if let Some(reason) = … { skip } else { emit }`.
  The string literal for the `s:` branch is unchanged, so existing
  tests asserting `reason.contains("swift-native")` still pass without
  modification. Chose the consolidating refactor over parallel helpers
  because core memory flags USR prefixes as the decisive origin signal
  and documents new families keep appearing — a single dispatch table
  is the natural shape for that growth.
- **Symmetric filter across Var and Func arms.** The test
  `preprocessor_macro_top_level_func_is_skipped` started as defensive
  symmetry (assumed the digester surfaces function-like macros as Func
  nodes) but turned out to be load-bearing in the full blast-radius run
  — the 30 filtered symbols are all `Var`-kind in practice today, but
  the Func-arm filter guards against a future digester release without
  requiring a second patch.
- **Tests (3 new, all TDD-RED first):**
  1. `preprocessor_macro_top_level_var_is_skipped_while_c_var_is_kept` —
     discriminator test: `c:@macro@kPreprocessorMacro` filtered;
     `c:@kRealCVar` (clang VarDecl) kept. Also asserts the skip reason
     string contains "preprocessor macro" so future refactors can't
     silently degrade the carry-forward.
  2. `coretext_version_macro_regression_is_filtered` — regression guard
     with three real USRs of shape `c:@macro@kCTVersionNumber10_1X`
     reconstructed inline (not read from gitignored
     `collection/ir/collected/CoreText.json`) per memory's
     "Prefer synthetic tests over external-data-dependent tests".
  3. `preprocessor_macro_top_level_func_is_skipped` — symmetric
     coverage of the Func arm, separating `c:@F@CTFontGetGlyphCount`
     (real C function) from `c:@macro@MIN` (macro).
- **Observable-IR verification on fresh collection (not stale JSON):**
  `cargo run -p apianyware-macos-collect` (full re-collect across all
  283 frameworks) after landing the fix. Audited all
  `collected/*.json` for remaining `c:@macro@` USRs in either
  `constants` or `functions`, and counted entries routed into
  `skipped_symbols` with reason containing "preprocessor macro":
  - **Total filtered: 30 symbols across 5 frameworks.**
    CoreText (15), AudioToolbox (5), NetworkExtension (5),
    Network (4), CoreSpotlight (1).
  - **Total leaks remaining: 0.**
  - Task description had framed the blast radius as "~15 entries in
    CoreText"; true scope was 2× that and spanned 5 frameworks. The
    "almost always report the symptom in the first framework that
    surfaced it" pattern from core memory held again.
- **Defensive note at the wrong-guess fix site.** Added a short comment
  to extract-objc's `extract_constant` explaining that preprocessor
  macros arrive as `MacroDefinition` cursors (not `VarDecl`) so this
  function never sees them, and pointing to the real filter in
  extract-swift. Non-obvious architectural information for the next
  investigator who chases a macro leak through the ObjC path.
- **What worked well:** the RED → GREEN cycle caught a genuine
  production bug at step 1 (the `MIN` test leaked through initial
  implementation drafts I didn't commit); the consolidating predicate
  refactor left every pre-existing test passing with zero edits
  because the `s:` skip-reason literal was preserved verbatim.
- **Out of scope / deferred:** pre-existing `cargo clippy` warning in
  `extract-objc/src/extractor.rs:88` (`useless_vec` on `clang` arg
  list) is unrelated to this patch and tracked by the hygiene task
  in `backlog.md`. Fixing the misleading comment at line 116 of
  `declaration_mapping.rs` was absorbed into the implementation
  rewrite — the whole doc comment was replaced with a USR-family
  table on `non_c_linkable_skip_reason`.
- **Outcome:**
  - 3 new unit tests in `extract-swift/tests/declaration_mapping.rs`,
    all passing together with the 11 pre-existing tests in that file
    (14/14 green).
  - Full workspace `cargo test --workspace` green.
  - `cargo +nightly fmt` applied to both touched crates
    (`apianyware-macos-extract-swift`, `apianyware-macos-extract-objc`).
  - Zero new clippy warnings introduced.
  - Fresh full-workspace collect: 30 previously-silent load-time
    failures now impossible for downstream C-FFI targets across
    CoreText / AudioToolbox / NetworkExtension / Network / CoreSpotlight.

### Session N (2026-04-13) — Clippy hygiene pass across workspace
- Task: clear all warnings so `cargo clippy --workspace --all-targets -- -D warnings`
  becomes a clean baseline, letting the gate surface new regressions
  without drowning them in pre-existing noise.
- Scope reality check: task description named 5 failing crates; actual
  failing set was 8 (also extract-swift, emit, collection-cli). Same
  lint families, just undercounted. Reinforces existing memory that
  backlog task descriptions are hypotheses — verify the concrete failing
  set first.
- Lints fixed by category:
  - Ascent-generated code (resolve/program.rs, enrich/program.rs): added
    module-level `#![allow(clippy::clone_on_copy, clippy::unused_unit,
    clippy::needless_lifetimes)]`. These trigger on code inside the
    `ascent!` macro expansion; clippy reports spans at the macro invocation
    site, so there's no hand-written expression to rewrite and the allow
    is the correct lever. Left an explanatory comment above each allow.
  - `map_or(false, |x| pred)` → `is_some_and(|x| pred)` — stable since
    Rust 1.70 and clippy now promotes it.
  - Manual prefix stripping → `str::strip_prefix` — also let me flatten
    an `if let Some … else …` branch because the `None` case became
    unreachable after the rewrite.
  - `vec![...]` → `[...]` where the value was only iterated (no Vec API
    needed).
  - `&[x.clone()]` → `std::slice::from_ref(&x)` — avoids an allocation
    when building a single-element slice.
  - `&mut Vec<T>` → `&mut [T]` for functions that only mutate by index
    (strictly more flexible, no runtime cost).
  - `&PathBuf` → `&Path` in CLI wrappers — the underlying library
    functions already took `&Path`, so `&PathBuf` params were just
    forwarding with needless restriction.
  - Collapsible nested `if`s → single `&&`-joined condition (×3 sites).
  - Doc list items overindented: the nicely column-aligned continuation
    lines (18-space indent to match `- \`s:…\`         — `) get parsed
    by clippy's markdown lint as over-indented sub-lists. Reduced to
    2-space continuations — loses visual alignment but gains lint
    compliance.
  - Explicit `'a` lifetimes that could be elided (×2 fn signatures) —
    removed where there was exactly one effective input lifetime.
  - `unsafe_code` warning on `env::{set,remove}_var` inside a test (Rust
    2024 marked these unsafe for concurrent-reader reasons): added
    `#[allow(unsafe_code)]` on the test fn. The existing SAFETY comment
    documents the single-threaded-test invariant.
- Verification: `cargo clippy --workspace --all-targets -- -D warnings`
  clean; `cargo test --workspace` green (410 tests, 0 failures); ran
  `cargo +nightly fmt`.
- Key learning — the `unsafe_code` warning is a rustc lint, not clippy.
  It was gated on the workspace-wide `unsafe_code = "warn"` in
  `[workspace.lints.rust]`. For the `-D warnings` gate to remain useful
  at the workspace level, rustc lints need the same tolerance for
  necessary exceptions that clippy lints already have; `#[allow]` on
  the specific fn is the right granularity.
- Memory update candidate: new entry about the `ascent!` macro + clippy
  interaction — when adding new Datalog rules, expect clippy noise on
  Copy-typed relation fields; the allow block is already in place, no
  action needed unless a new lint family appears.

### Session (2026-04-13) — Platform-unavailable `extern` symbol filter
- Task: "Bare `c:@<name>` macro USRs leak past the `c:@macro@` filter"
  — turned out to be misnamed. Canary
  `kAudioServicesDetailIntendedSpatialExperience` (AudioToolbox) was
  failing `dlsym` at racket-oo harness load time, and the backlog
  framed it as a `c:@<name>` USR filter bug in extract-swift.
- Diagnosis correction (this is the headline). Three hypotheses in the
  task description turned out wrong simultaneously:
  - **Wrong layer.** Not a USR filter problem. The canary is
    `extern const CFStringRef … API_AVAILABLE(visionos(26.0))
    API_UNAVAILABLE(ios, watchos, tvos, macos)` — a perfectly ordinary
    clang `VarDecl` with `Linkage::External`. USR is irrelevant; the
    discriminator is platform availability.
  - **Wrong crate.** Not extract-swift. The canary's `source` in the
    collected IR is `objc_header`, and
    `swift-api-digester -dump-sdk -module AudioToolbox | grep Spatial`
    returns zero hits. The entire leak class goes through extract-objc's
    `extract_constant` / `extract_function`.
  - **Wrong blast radius.** Task reported 1 symbol in AudioToolbox;
    pre/post comparison across all 283 frameworks found **1,738 symbols
    filtered — 876 constants + 862 functions — across 56 frameworks**.
    AudioToolbox contributed 45 (~3%). AppKit was the single largest at
    387 constants — an iOS-family framework's UI symbols that AppKit
    headers declare unavailable on macOS (this was the most surprising
    discovery).
- The prior "Backlog task descriptions are hypotheses" memory entry
  predicted this class of drift exactly — wrong layer + wrong crate +
  wrong blast radius — and the only reason I didn't chase the wrong
  fix for hours was that entry existing. Memory pays rent.
- Fix (extract-objc/src/extract_declarations.rs):
  - New helper `is_unavailable_on_macos(entity: &Entity) -> bool`
    queries libclang's `get_platform_availability()` table for any
    entry where `platform == "macos" || "macosx"` and
    `unavailable: true`. Missing metadata → false (absence is not
    evidence).
  - Called from both `extract_constant` and `extract_function` after
    the existing `Linkage::Internal` check. Symmetric across both
    arms — same producer, same discriminator, same skip path — matching
    the pattern of the existing linkage filter.
  - Note left in code that `extract_method`, `extract_class`, and
    `extract_protocol` still don't check availability. That's a separate
    leak class (emitter bindings that would bind-fail at call time, not
    `dlsym`-fail at load time) and deferred to triage.
- TDD harness: new `tests/filter_platform_unavailable.rs` mirrors the
  existing `filter_internal_linkage.rs` scaffolding
  (`SyntheticSdk` + `LazyLock<ExtractionResult>`, `clang::Clang` dropped
  before cache). Six tests cover plain `extern`, the single-platform
  unavailable shape (`__attribute__((availability(macos, unavailable)))`),
  and the full visionOS-only multi-platform shape, for both constants
  and functions. All six failed on pre-fix code, all six green after.
- Blast radius audit methodology: stashed just the one modified source
  file via `git stash push -- <path>`, re-ran `cargo run -p
  apianyware-macos-collect` (~2 minutes for 283 frameworks), captured
  `(constants, functions)` counts per framework into a pickle, stash
  popped, re-collected with the fix, diffed per-framework. This pattern
  was cleaner than trying to count via `dyld_info` or header grep —
  and it catches the actual filter delta, not a structural proxy.
  Recording it here so future leak-audit tasks can reuse it.
- Verification gates: 421 tests passed / 0 failed; `cargo clippy
  --workspace --all-targets -- -D warnings` clean; `cargo +nightly fmt`
  clean. No golden-snapshot regressions despite 1,738 symbol removals —
  the curated Foundation/AppKit fixtures don't happen to reference any
  of them, which is useful signal: snapshot tests protect against
  formatting drift, not semantic leaks like this one.
- Non-obvious finding: the internal-linkage filter doesn't record to
  `skipped_symbols`, and I followed that pattern (silent return None)
  for consistency. This means the 1,738 filtered symbols are invisible
  in the IR — there's no way to audit *what* was filtered after the
  fact, only whether it happened. That's a design tension; a future
  observability task may want to surface silent filter decisions to
  `skipped_symbols` for both the linkage and availability filters.
  Not actioned in this session.
- The three original "non-linkable leak" tasks from the 2026-04-13 split
  remain two-out-of-three open: "Anonymous-enum members extracted as
  standalone constants" (canary `nw_browse_result_change_identical`)
  and "Constants flagged in `skipped_symbols` still reach final IR"
  (canaries `NEFilterFlowBytesMax`, `CoreSpotlightAPIVersion`). Quick
  header inspection during this session confirmed these are genuinely
  different root causes — task 2 is a true C enum member with USR
  `c:@Ea@…`, task 3 is two real `#define` macros. Neither is the same
  bug as task 1. The per-task canaries need independent diagnosis.

### Session (2026-04-13) — Anonymous-enum-member constants filter
- Task: filter the `c:@Ea@<dummy>@<member>` USR family (anonymous enum
  members) from extract-swift's top-level `Var`/`Func` constants pipeline.
  Surfaced by the racket-oo runtime load harness extension attempt failing
  at `dlsym` for `nw_browse_result_change_identical` in Network. The task
  was the second of three siblings split out of the 2026-04-13 parent task
  "Non-linkable symbol leaks beyond the c:@macro@ filter" (the third
  sibling — platform-unavailable extern symbols — closed in the previous
  session; the first sibling — task 3 in the backlog, the
  NEFilterFlowBytesMax / CoreSpotlightAPIVersion `#define` leaks — remains
  open).
- Diagnosis path:
  - Read `non_c_linkable_skip_reason` in
    `extract-swift/src/declaration_mapping.rs:128`. Confirmed it currently
    handles only `s:` and `c:@macro@`; any `c:@Ea@…` USR falls through to
    `map_top_level_constant`. The dispatch in `map_abi_to_framework`
    already routes `Var`/`Func` nodes through the predicate *before*
    `map_top_level_constant`/`map_top_level_function`, so adding an arm
    here *is* the producer-level fix — there is no earlier point at which
    the cursor enters the constants pipeline.
  - Re-collected Network on its own with current source per the
    "regenerate before grepping" rule. Canary present in
    `Network.json` with the predicted USR
    `c:@Ea@nw_browse_result_change_invalid@nw_browse_result_change_identical`,
    `source: swift_interface`. Verified `dyld_info -exports
    /System/Library/Frameworks/Network.framework/Network` → 0 hits for
    `nw_browse_result_change` against 4439 other `nw_*` exports. Leak is
    real and producer is the Swift pipeline.
  - **Off-by-one-USR-family discovery.** While checking the broader
    Network constants list with USR prefix `c:@(E|Ea)`, found a *second*
    leaking family: `c:@EA@<typedef>@<member>` (uppercase `A`). This is
    libclang's USR for members of `typedef enum { … } Name_t`-style
    anonymous enums, distinct from the `Ea` (lowercase, no-tag-no-typedef)
    cursor. In Network alone: 7 leaks via `Ea` (the
    `nw_browse_result_change_*` enum the task named) and 143 leaks via
    `EA` (the `nw_browser_state_t`, `nw_connection_state_t`,
    `nw_connection_group_state_t`, … typedef'd enums). Filtering only
    `c:@Ea@` would have left 95% of the leak in place. The four-segment
    USR check on `c:@E@<Enum>@<Member>` (named-enum members) returned
    zero hits — the digester routes named-enum members through the
    `Enum` → `EnumElement` mapping path, not the top-level `Var` path,
    so the existing enum-mapping code already handles them correctly.
- Fix: extended `non_c_linkable_skip_reason` with a single arm matching
  `usr.starts_with("c:@Ea@") || usr.starts_with("c:@EA@")`, returning
  `"anonymous enum member (c:@Ea@ / c:@EA@ USR; integer value inlined by
  the C compiler, no dylib export)"`. Updated the function's USR-family
  table comment to document both shapes, the named-enum exception, and
  why the second segment of an `Ea` USR is the synthetic disambiguator.
- Tests: 3 new tests in
  `extract-swift/tests/declaration_mapping.rs`, all written **before** the
  source change and verified failing first per project TDD discipline:
  - `anonymous_enum_member_top_level_vars_are_skipped_while_c_var_is_kept`
    — synthetic mixed-prefix discriminator: feeds one `c:@Ea@`, one
    `c:@EA@`, and one real `c:@kRealCVar` clang VarDecl, asserts only
    the real one survives and both anonymous shapes land in
    `skipped_symbols` with reason containing `"anonymous enum member"`.
  - `nw_browse_result_change_regression_is_filtered` — regression guard
    using all seven verbatim USRs from the live Network IR. Pattern
    follows `coretext_version_macro_regression_is_filtered`. Inline
    fixture, not file-dependent (per the "synthetic over external-data"
    memory rule), so CI is not silently green when
    `collection/ir/collected/Network.json` is absent.
  - `anonymous_enum_member_top_level_func_is_skipped` — defensive
    symmetry on the `Func` arm, mirroring the existing
    `preprocessor_macro_top_level_func_is_skipped` symmetry test. The
    digester does not surface anonymous-enum-shaped Func nodes today,
    but the predicate is shared across both arms so a future digester
    release that does will be caught automatically without a follow-up
    patch.
  All 17 tests in the file pass post-fix. Full `cargo test --workspace`
  green. `cargo clippy --workspace --all-targets -- -D warnings` clean.
- **Blast radius (full re-collect of all 283 frameworks, release build):**
  205 symbols across just **2** frameworks — Network 150 (7 `Ea` + 143
  `EA`), AudioToolbox 55. Zero `c:@Ea@`/`c:@EA@` USRs remain in any
  framework's `.constants` array post-fix.
- **Surprising blast-radius shape.** This is the *smallest* blast radius
  of any filter landed on this project — well below the 1,738/56 of the
  platform-availability filter and the 30/5 of the `c:@macro@` filter.
  The "filter scope is always 10–1000× the named symptom" intuition from
  earlier sessions does **not** generalise: in this case the named
  scope (1 framework, 7 symbols) was off by exactly 30× on the symbol
  count (`Ea` + `EA` shapes the task didn't distinguish) but exactly 2×
  on the framework count. Structural reason: most C frameworks use
  named enums (`enum Foo { … }`) which reach the IR through the
  dedicated `Enum` → `EnumElement` path. Only the `nw_*` and
  `Audio*` C APIs follow the older anonymous-enum-with-typedef
  convention common in pre-modern C library design.
- **Why the leak went undetected for so long.** Network and AudioToolbox
  are not in the curated Foundation snapshot subset, and the synthetic
  TestKit framework doesn't model anonymous typedef'd enums. A Network
  golden-test framework would have caught this immediately. The same
  observation applied to the platform-availability filter and probably
  applies to whatever's still hiding behind tasks 3 and 4 in the
  backlog. Not actioned this session, but flagged for triage.
- Meta-learning: the "Backlog task descriptions are hypotheses" memory
  rule fired in a new mode this session — the task's hypothesis named
  *one* USR family (`c:@Ea@`) when the real producer leaked through
  *two* nearly-identical USR families (`c:@Ea@` and `c:@EA@`)
  distinguished by a single character of case. The blast-radius
  measurement caught this *before* committing — the intermediate count
  in Network after the test file was drafted but before the fix was
  applied (150 leaks across both shapes, 7 from `Ea`, 143 from `EA`)
  forced the filter to be widened during the diagnosis phase rather
  than after a partial-fix re-collect. This is a strong endorsement of
  the discipline: **always grep the symptom space broadly, not narrowly,
  before writing the filter**. The fifth misdirection mode in the
  existing memory entry is "wrong USR family granularity" — finer than
  "wrong crate" or "wrong layer", but equally easy to miss.
- Unblocks racket-oo's "Extend runtime load harness to remaining
  `c:@macro@` framework siblings" task once racket-oo regenerates against
  the post-fix enriched IR. Task 3 in the backlog (NEFilterFlowBytesMax
  + CoreSpotlightAPIVersion `#define`-style leaks) remains independent
  and untouched — its canaries are real `#define` constants per the
  task description, not enum members, so they leak through a different
  path entirely.
- Per "one task per work phase": stopping here. Reflect phase next.

### Session N+1 (2026-04-13) — `skipped_symbols`-canary task dissolved by pipeline regeneration
- Task: "Constants flagged in `skipped_symbols` still reach final IR" —
  high priority, described as the only remaining blocker for the racket-oo
  `dynamic-require` load harness on NetworkExtension and CoreSpotlight.
  Canaries: `NEFilterFlowBytesMax` (a `#define` in `NEFilterFlow.h`) and
  `CoreSpotlightAPIVersion` (a `#define` in `CoreSpotlight.h`).
- **Corrected root cause: stale downstream checkpoints.** No code bug.
  The task description's "reappear as live constants in resolved/, annotated/,
  enriched/" was true at the moment the task was filed, but the evidence was
  from files dated 27 Mar 18:07 — *before* the `c:@macro@` filter landed in
  `extract-swift/src/declaration_mapping.rs::non_c_linkable_skip_reason`.
  The fresh collected IR (13 Apr 20:00) already filters both canaries into
  `skipped_symbols` and omits them from the `constants` array.
- Evidence trail actually walked (pointedly ignoring `skipped_symbols`
  membership as the task instructed, per the memory warning):
  1. `dyld_info -exports` on both canary dylibs → 0 occurrences each,
     confirming the runtime symptom was legitimate.
  2. `grep` for both names in the *live* `collected/*.json` → each appears
     only in `skipped_symbols`, not in `constants`. Extract-swift's filter
     is working correctly.
  3. Cross-project scan of all 283 `collected/*.json` files for any
     constant whose USR still starts with `c:@macro@` → **zero leaks**.
     The filter is correct everywhere.
  4. mtime survey: 278 of 283 `resolved/*.json` files dated 27 Mar 18:07;
     283 of 283 `collected/*.json` files dated 13 Apr 20:00. The entire
     downstream IR was stale. The "reappears in resolved/annotated/enriched"
     symptom was a direct consequence.
  5. `analysis/ir/enriched/` and the racket-oo `generated/` tree are all
     gitignored, so regenerating them produced zero git churn.
- Fix applied: `cargo run -p apianyware-macos-analyze` (full resolve →
  annotate → enrich across all 283 frameworks), then
  `cargo run -p apianyware-macos-generate -- --lang racket-oo`. Both
  canaries are now absent from
  `generation/targets/racket-oo/generated/oo/networkextension/constants.rkt`
  and `.../corespotlight/constants.rkt`. `cargo test --workspace` is green
  except the pre-existing `snapshot_racket_oo_foundation_subset` golden-file
  drift, which already failed at HEAD before this session started (verified
  by stashing the local golden edits and re-running the test).
- **Meta-learning (sharpens an existing memory entry).** The
  "Regenerate collected IR before using it as evidence" memory rule already
  covers this case in spirit, but the session showed it has a second-order
  failure mode: stale *analysis* checkpoints can masquerade as "a filter
  leak in extraction" even when the extractor's own fresh output is clean.
  Every hypothesis in the task description — internal-linkage filter leak,
  umbrella-dylib lookup mismatch, header-annotation routing, serialization
  regression in `merge.rs` — assumed the fault was in currently-living
  source code. None considered "downstream pipeline artifact is older than
  the filter that would have caught this". The entire batch of root-cause
  hypotheses was in the wrong *time*, not the wrong layer/crate/granularity
  that the existing memory entry lists. Propose adding a sixth misdirection
  mode to the "Backlog task descriptions are hypotheses" entry:
  **wrong temporal frame — the "symptom" was fixed by an earlier session's
  filter but the evidence predates that filter**. Pair it with a
  pre-investigation sanity check: before forming any code-fix hypothesis
  against evidence found in `resolved/`, `annotated/`, or `enriched/`,
  compare its mtime to the mtimes of files under
  `collection/crates/extract-{swift,objc}/src/` — if the source has moved
  since the checkpoint was written, regenerate the checkpoint *first*.
- **Connection to the prior session.** The preceding session (anonymous
  enum member filter, Network + AudioToolbox) explicitly noted at the end:
  "Unblocks racket-oo's 'Extend runtime load harness to remaining
  `c:@macro@` framework siblings' task once racket-oo regenerates against
  the post-fix enriched IR. Task 3 in the backlog [this task] remains
  independent and untouched — its canaries are real `#define` constants
  per the task description, not enum members, so they leak through a
  different path entirely." The second sentence was true at filing time
  but misleading: the canaries *did* leak through "a different path
  entirely" (`c:@macro@`), and that path's filter had already landed in
  a still-earlier session — the only thing missing was the pipeline
  regeneration the prior session itself called for. The two tasks dissolve
  into a single regeneration step that unblocks both.
- **Scope discipline note.** The snapshot test failure (golden-Foundation
  subset) reflects several filters' cumulative effect on Foundation
  constants since the golden was last refreshed; it is independent of
  this task and was deliberately not re-baselined in this session per the
  "one task per work phase" rule. It should be picked up as its own backlog
  item during triage, not silently folded into this session's commit.
- Per "one task per work phase": stopping here. Reflect phase next.
### Session N (2026-04-14T02:26:56Z) — Auto-regenerate stale pipeline before each work phase
- Implemented the high-priority "Auto-regenerate analysis + generation at the
  top of every work session" task. Goal: prevent the stale-checkpoint failure
  mode where a downstream task forms a fix hypothesis against drifted
  artifacts. Memory-only guardrails proved insufficient on 2026-04-13 — the
  LLM wrote the "Wrong temporal frame" lesson *during* the wasted cycle, not
  before it.
- **Design choice: shared-script-with-opt-in-hook.** Modified
  `~/Development/LLM_CONTEXT/run-backlog-plan.sh` to add a generic pre-work
  bootstrap: if `<plan-dir>/pre-work.sh` exists and is executable, run it
  from the project root before launching the work-phase claude session.
  Hook failure aborts the cycle. Verified that none of the 12 sibling plans
  across 5 projects have a `pre-work.sh`, so they are unaffected.
- **Regen logic in a dedicated script.** Wrote
  `analysis/scripts/regenerate-stale-pipeline.sh` (lives alongside
  `llm-annotate.sh` in the existing pipeline scripts dir). Two stages:
  - **analyze**: inputs are
    `analysis/crates/{datalog,resolve,annotate,enrich,cli}/src` +
    `collection/crates/types/src` + `collection/ir/collected`. Output:
    `analysis/ir/enriched`. Stale rule fires when newest input mtime >
    newest output mtime.
  - **generate**: inputs are `generation/crates/{emit,emit-*,cli}/src` +
    enriched IR newest mtime. Output: `generation/targets/{lang}/generated`.
    Per-target staleness check, scoped via `--lang` to avoid paying for
    other emitters during target-specific sessions.
  - Skipped: collection. Per the task description, it costs ~2 minutes
    and is gated on SDK header changes which are a manual decision.
- **Project-local shims.**
  - `LLM_STATE/core/pre-work.sh` — `exec ./analysis/scripts/regenerate-stale-pipeline.sh`
  - `LLM_STATE/targets/racket-oo/pre-work.sh` — `exec ./analysis/scripts/regenerate-stale-pipeline.sh --lang racket-oo`
  - Both are executable, both use `set -euo pipefail` + `exec`.
- **Two non-obvious bugs caught during verification, both surprising:**
  - **"Newest input > oldest output" was the wrong rule.** Initial
    design used oldest-output as the comparison point. This caused
    perpetual stale detection on `racket-oo` for two independent
    reasons: (1) Racket's `raco make` writes `.zo`/`.dep` bytecode under
    `generated/oo/*/compiled/` with mtimes unrelated to the Rust
    generator, and (2) the Rust generator orphans files from prior
    generator versions — e.g., `generated/oo/avrouting/constants.rkt`
    from a prior run that the current generator no longer produces.
    Both classes of files have older mtimes than current source and
    register as forever-stale under the oldest-output rule. Switched
    to "newest input > newest output": if any file in the output tree
    is newer than the newest input, the output cannot be globally
    stale. Also added `*/compiled/*` exclusion to `find` for
    defense-in-depth.
  - **Stub emitters break "missing dir = stale".** `racket-functional`
    has no `generated/` dir at all because its emitter is a registered
    stub. Initial design treated missing dir as "definitely stale and
    must regen" — would have triggered an infinite regen loop on every
    session because the regen never produces a `generated/` dir. Fix:
    skip targets without an existing `generated/` dir entirely. The
    freshness hook is a drift guardrail, not a first-time setup tool.
    First-time generation remains a manual `cargo run` step.
- **Verified end-to-end:**
  - No-op runs complete in 0.5s (all `find` / `stat`, no cargo).
  - Touching `generation/crates/emit-racket-oo/src/lib.rs` triggers
    only `generate`, not `analyze`. Confirmed scoping correct.
  - Touching `analysis/crates/enrich/src/program.rs` triggers both
    `analyze` and `generate` (downstream stage must follow upstream
    change — confirmed correct).
  - Both shims (`core/pre-work.sh` and `targets/racket-oo/pre-work.sh`)
    work correctly when invoked through `cd $PROJECT && ./LLM_STATE/.../pre-work.sh`,
    matching how the shared script invokes them.
  - LLM annotation preservation not exercised: no `*.llm.json` files
    exist yet under `analysis/ir/annotated/`. Safety relies on the
    existing `load_existing_annotations()` documented in the
    "LLM annotation flows through a dedicated input directory" memory
    entry.
- **Key learnings to distill in reflect:**
  - The "newest input > newest output" rule is the right freshness
    check pattern for codegen pipelines where the generator may
    orphan files from prior versions and where downstream tools (raco
    make, etc.) write artifacts the freshness check shouldn't see.
    "Oldest output" is a tempting wrong answer because it sounds more
    conservative.
  - Stub emitters break naive "missing output = stale" rules. Drift
    guardrails should not double as first-time bootstrap mechanisms.
  - The shared `run-backlog-plan.sh` now has a generic pre-work hook
    point. Future cross-cutting bootstrap concerns (env var setup,
    secret refresh, etc.) can use the same `<plan-dir>/pre-work.sh`
    convention without further script changes.
  - Cross-project blast radius of the shared script change: zero
    (verified — 0 of 12 sibling plans have a `pre-work.sh`).
- **What this suggests trying next:** The medium-priority
  "Platform-availability filter for ObjC methods, classes, protocols"
  task is now the natural next pick. The freshness hook will protect
  any future "wrong temporal frame" recurrences during that work,
  including the stash → re-collect → diff blast-radius procedure
  (which still requires a manual `cargo run -p apianyware-macos-collect`
  by design, since collection is not auto-regenerated).

