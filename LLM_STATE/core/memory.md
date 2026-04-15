# Memory

### Typedefs resolve at extraction time
ObjC typedef aliases (e.g., NSImageName) resolve to canonical types during collection. Object pointer typedefs → Id/Class, primitive typedefs → Primitive, enum/struct typedefs → Alias. Unresolved typedefs produce incorrect FFI signatures in all language targets.

### TypeNameAlias nodes require child recursion
`TypeAlias` (type declaration) and `TypeNameAlias` (type reference in signatures) are distinct Swift API digester node kinds. C typedefs like `CFStringEncoding` appear as `TypeNameAlias` nodes whose first child is a `TypeNominal` with the resolved type. `map_swift_type()` recurses into the first child. Without recursion, framework-qualified `Primitive` names (e.g., `CoreFoundation.CFStringEncoding`) reach downstream unrecognized → `_pointer`. Childless `TypeNameAlias` nodes fall through to `Primitive`.

### Function pointer typedefs need pointee inspection
`map_typedef` must check whether a `TypeKind::Pointer` pointee is `FunctionPrototype` and extract full param/return signatures. `TypeRefKind::FunctionPointer` (in `type_ref.rs`) carries the full signature. Without this, callback typedefs like `CGEventTapCallBack` resolve to plain `Pointer`. New `TypeRefKind` variants require updating exhaustive matches in `ffi_type_mapping.rs` and all emitter crates.

### Category properties need dedup by name
ObjC categories can redeclare properties already on the base class. Deduplication by name (HashSet filter in `extract_declarations.rs`) prevents duplicate IR entries.

### Enrichment filters by framework scope
`build_enrichment_data()` and `build_verification_report()` filter by `framework_classes`, computed in `build_enriched_framework()`. Without filtering, violations from all frameworks bleed into every report. Delegate protocol attribution filters by `framework.protocols` (declaration site), not `framework_classes` (usage site). Rule: filter by where the entity is *declared*, not where it's *used*.

### DriverKit and Tk frameworks are ignored
DriverKit requires kernel headers unavailable in user-space SDKs. Tk is a legacy X11 toolkit. Both excluded via `IGNORED_FRAMEWORKS` in `sdk.rs`, filtered in `discover_frameworks()`.

### Cross-framework indexes span all frameworks
`build_method_index()` and `build_property_index()` in `resolve/checkpoint.rs` receive all loaded frameworks. Otherwise cross-framework inherited methods/properties lose full metadata (params, return type, flags) and fall to minimal stubs. Any index that looks up declarations by class name must span all frameworks if inheritance crosses boundaries.

### Stub launcher gives unique CDHash per app
macOS TCC grants permissions per-CDHash. Without per-app stubs, all apps sharing a runtime binary (e.g., `/opt/homebrew/bin/racket`) share one TCC permission set. `apianyware-macos-stub-launcher` (`generation/crates/stub-launcher/`) generates a ~50KB Swift binary per app that `execv`s into the language runtime. API: `StubConfig` → `create_app_bundle()` for full `.app` assembly, or `generate_stub_source()` + `compile_stub()` for custom workflows. Compiles via `swiftc`.

### Prefer synthetic tests over SDK-dependent tests
Tests depending on extracted SDK data (e.g., `Foundation.json`) silently skip when absent → false-green CI. Core logic tests (resolution, enrichment, emission) use synthetic in-memory data. Real-SDK tests are for integration-level extraction fidelity only.

### Snapshot test framework covers emitter paths
`build_snapshot_test_framework()` from `emit/test_fixtures.rs` provides 5 classes, 2 protocols, 1 enum, 2 constants, exercising all emitter code paths. Minimal hand-built frameworks miss edge cases in end-to-end emission.

### FFI mapper normalizes primitive names
`Primitive` matching in `RacketFfiTypeMapper::map_type()` cannot use exact lowercase. Swift digester produces framework-qualified PascalCase (`Swift.Void`, `Swift.Bool`, `Swift.Double`); ObjC uses uppercase `BOOL`. `normalize_primitive_name()` strips framework prefix via `rsplit_once('.')` and lowercases. Applies to `map_type()` and trait methods like `is_void()`. Any new language target's FFI mapper hits the same issue.

### Geometry struct mapping uses single source
Three code paths: `is_known_geometry_struct()` (recognition), `map_geometry_struct_alias()` (Alias kind → Racket type), `Struct` match arm. The `Struct` arm delegates to `map_geometry_struct_alias()`. Adding new geometry structs: (1) `is_known_geometry_struct()`, (2) `map_geometry_struct_alias()`, (3) `define-cstruct` in Racket runtime `type-mapping.rkt` with correct field layout. Discover missing structs by searching collected JSON for `Alias`-kind entries across Foundation, AppKit, CoreGraphics.

### extract-objc filters: internal linkage
`extract_constant` / `extract_function` in `extract_declarations.rs` skip declarations with `entity.get_linkage() == Some(Linkage::Internal)`. `static const` variables and `static inline` functions are inlined at use sites and emit no dylib symbol — extracting them causes runtime `get-ffi-obj` failures. Canonical examples: `NSHashTableCopyIn`, `NSHashTableStrongMemory`, `NSHashTableWeakMemory`. Macros never reach `VarDecl`/`FunctionDecl` cursors — they appear as `EntityKind::MacroDefinition` (see "Macros reach IR only via swift-api-digester").

### extract-objc filters: platform unavailability
Clang availability attributes (`API_UNAVAILABLE(macos)`, etc.) mark declarations absent from the macOS dylib despite having `Linkage::External` and ordinary USRs — neither the linkage filter nor any USR filter catches them. `is_unavailable_on_macos(entity)` iterates `entity.get_platform_availability()` for `platform == "macos" || "macosx"` and `unavailable: true`. Missing availability data → `false` (absence is not evidence of unavailability). Canonical canary: `kAudioServicesDetailIntendedSpatialExperience` in AudioToolbox. Removed 1,738 symbols across 56 frameworks (876 constants + 862 functions); AppKit alone: 387 constants. Verification: `dyld_info -exports <dylib>`.

### extract-objc availability filter covers all declaration kinds
`extract_class`, `extract_protocol`, `extract_method`, and `extract_property` each gate on `is_unavailable_on_macos`. Class/protocol-level hits are wholesale drops (see "Wholesale drop is the right default for unavailable parent types"). `extract_method` fires per-selector inside both direct-class and `extract_category` visits. `extract_property` fires per-property for both instance and class properties. libclang's `get_platform_availability()` is reliable at all four granularities (confirmed via synthetic `MixedClass` fixture). Blast radius: class/protocol/method — 53 frameworks, −450 classes, −151 protocols, −2,982 class methods, −414 protocol methods; property — 31 frameworks, −303 properties (AVFoundation alone −223, 74% of total). The filter quartet is complete; all four declaration kinds share one predicate with zero refactoring across additions.

### Wholesale drop is the right default for unavailable parent types
Class- or protocol-level `API_UNAVAILABLE(macos)` drops the entire declaration, not just flags it. Rationale: the macOS variant of the dylib does not export the class/protocol symbols at all, so every inherited method would crash at first call with "unrecognized selector"; a flagged-but-populated IR only defers the runtime failure to language targets. Matches how iOS-family classes inside shared Foundation headers are silently absent from the macOS Foundation dylib today. Applied in `extract_class` and `extract_protocol`; the same predicate fires per-selector in `extract_method` for the subtler mixed-availability case (class available, some selectors not).

### Synthetic libclang tests need LazyLock
`clang::Clang` is `!Send + !Sync`. Synthetic tests using libclang must cache a single instance in a `LazyLock`.

### Shared skipped_symbol reason vocabulary
`apianyware_macos_types::skipped_symbol_reason` holds the five `&'static str` tags used by both extractors: `internal_linkage`, `platform_unavailable_macos`, `swift_native`, `preprocessor_macro`, `anonymous_enum_member`. Format: `"<tag>: <human description>"`. Audit tooling matches via `reason.contains(tag)`. When adding a new filter, extend this module first — do not inline the reason string at the filter site. extract-objc records via the `record_skip(skipped_symbols, name, kind, reason)` helper in `extract_declarations.rs`; method and property records qualify the name as `"{owner}.{selector|prop}"` so class context survives the flat list. extract-swift records via the `non_c_linkable_skip_reason` predicate. Both feed the same `fw.skipped_symbols` vec; `merge.rs::merge_swift_into_objc` extends objc's list with swift's. NSLog / NSApplicationMain confirmed single-entry (objc keeps the C function, swift records only the overlay as `swift_native`). Known duplicate-name edge case: `printed_name` qualification (parameter labels) reduced duplicate `(name, kind)` pairs from 30 to 12 per fresh collection. The remaining 12 are true type-based overloads sharing identical parameter labels (e.g., CoreML `pointwiseMin(_:_:)`×3, TabularData `/(_:_:)`×4, Network `withNetworkConnection(to:using:_:)`×4). Resolving these requires mangled signatures or parameter-type lists (see "Swift printed_name catches label overloads not type overloads").

### Non-C-linkable USR families in extract-swift
Three USR prefix families produce no dylib symbol and are filtered by `non_c_linkable_skip_reason(node)` in `declaration_mapping.rs`:

- `s:` — Swift-native; only callable via Swift ABI
- `c:@macro@` — preprocessor macro cursor; no dylib symbol
- `c:@Ea@<dummy>@<member>` / `c:@EA@<typedef>@<member>` — anonymous enum members; value inlined, no export

Named-enum members (`c:@E@<Enum>@<Member>`) are routed through `Enum` → `EnumElement`, not this filter. The `Func` and `Var` arms of `map_abi_to_framework` call the predicate and route matches to `skipped_symbols`. Extend this predicate for new non-linkable families. The filter is conservative: missing USRs, `c:`/`c:@F@`/`So` prefixes, and non-Func/Var cursors pass through. Network's 437 `nw_*` and AudioToolbox's 58 `AudioFileComponent*` functions are untouched.

### Symmetric Func/Var filtering is load-bearing
`c:@macro@` and anonymous-enum cursors currently appear only as `Var` nodes, but the `Func` arm guard in `non_c_linkable_skip_reason` costs nothing and survives future digester releases.

### Non-C-linkable filter blast radii
- `s:` — 46 in CoreGraphics alone, dozens across other frameworks
- `c:@macro@` — 30 across 5 frameworks (CoreText 15, AudioToolbox 5, NetworkExtension 5, Network 4, CoreSpotlight 1)
- `c:@Ea@`/`c:@EA@` — 205 across 2 frameworks (Network 150: 7 Ea + 143 EA; AudioToolbox 55)

### USR prefix families encode declaration origin
USRs in `swift-api-digester` output encode the declaration's origin. The prefix family — not the `source` field — is the load-bearing discriminator:

- `s:` — Swift-native; not `dlsym`-able
- `c:@F@<name>` — C function; exported as `_<name>`
- `c:@<name>` — C var / enum constant
- `c:@E@<Enum>@<Member>` — named C enum member; routed through `Enum` → `EnumElement`
- `c:@Ea@<dummy>@<member>` — anonymous C enum member, no typedef wrapper; no dylib symbol
- `c:@EA@<typedef>@<member>` — anonymous C enum member with typedef; no dylib symbol. Single-character case difference from `Ea` — both must be filtered together or 95% of the leak survives
- `c:@macro@<name>` — preprocessor macro; no dylib symbol
- `So<mangled>` — Obj-C declaration

Analogous to libclang's `Linkage` enum for the ObjC path.

### skipped_symbols is per-pipeline, not global
Each extractor records its own filter decisions. `merge.rs::merge_swift_into_objc` appends swift's list onto the objc framework. A symbol can appear in both `functions`/`constants` (from one extractor) and `skipped_symbols` (from the other). Canonical: NSLog — extract-objc keeps the C function (`c:@F@NSLog`), extract-swift skips the Swift-ABI overlay (`s:10Foundation5NSLog…`), merge dedup drops the Swift version, final IR carries NSLog once with ObjC metadata. Same pattern: NSApplicationMain in AppKit. `skipped_symbols` membership does not mean "absent from final IR."

### Macros reach IR only via swift-api-digester
libclang surfaces `#define` macros as `EntityKind::MacroDefinition`, never reaching extract-objc's `VarDecl`/`FunctionDecl` arms. Macros in ObjC framework headers reach collected IR only via `swift-api-digester`, re-exported as top-level `Var` nodes with `c:@macro@` USRs. The filter for macro-derived constants (e.g., CoreText `kCTVersionNumber10_*`) lives in `extract-swift/src/declaration_mapping.rs`, not extract-objc. A defensive comment at `extract_constant` points to the real filter.

### Backlog task descriptions are hypotheses
Task root-cause framing and scope estimates are starting hypotheses. Trace symptom → actual producer → actual consumer before committing to a fix. Scope notes describe importance, not work size — check the production surface before assuming new code is needed. Seven misdirection modes:

1. **Wrong layer** — task says "mapper", fix is in extraction
2. **Wrong crate** — task names extract-objc, fix is in extract-swift (see "Macros reach IR only via swift-api-digester")
3. **Wrong blast radius** — task reports few symbols, real scope spans many frameworks. Audit all frameworks.
4. **Wrong direction for verification** — confirm via fresh evidence (re-collect, re-run), not stale checkpoints
5. **Wrong USR-family granularity** — task names one USR prefix, leak spans multiple nearly-identical families (e.g., `Ea`+`EA` differ by one character). Grep the symptom space broadly — list all non-linkable symbols and check USRs with a loose regex before writing the filter.
6. **Wrong temporal frame** — symptom was fixed by an earlier filter; evidence predates that filter. Detect via mtime sanity check (see "Downstream checkpoints can predate source fixes"). Sibling tasks filed against the same stale evidence may collapse into one regeneration.
7. **Wrong work estimate** — scope notes assess importance; actual effort depends on existing infrastructure. A "scope-expanding" task may be thin test-coverage adds if the production harness already exists.

### Measure filter blast radius before committing
Triggering symptoms underpredict scope unpredictably: 30/5 frameworks (`c:@macro@`), 1,738/56 (availability), 205/2 (anonymous enum). Steps:

1. `git stash push -- <modified source>`
2. `cargo run -p apianyware-macos-collect` — full re-collect (~2 min, 283 frameworks), snapshot counts
3. `git stash pop`, re-collect, diff per-framework

Catches semantic removals (not structural proxies like `dyld_info` counts) and wrong-granularity errors mid-diagnosis. Reusable for ObjC or Swift filters.

### Both extractors have real-SDK integration tests
extract-objc: Foundation, CoreGraphics, AudioToolbox. extract-swift: CoreText (`c:@macro@` canary — all 15 Vars are macros, binary pass/fail), Network (`c:@Ea@`/`c:@EA@` canary — exact-7 `nw_browse_result_change_*` catches single-character case regressions). Both CoreText and Network harnesses also assert `depends_on` / `extract_imports`: non-empty `depends_on`, presence of known parent frameworks (Foundation / Dispatch), absence of `_`-prefixed private imports. Synthetic filter tests remain the primary coverage; real-SDK tests are integration-level fidelity checks only (see "Prefer synthetic tests over SDK-dependent tests").

### Regenerate IR before using as evidence
`collection/ir/collected/` is gitignored; file mtime is unreliable. Re-run the collector before grepping JSON to verify fixes. Applies to `collected/`, `resolved/`, `annotated/`, `enriched/`.

### Downstream checkpoints can predate source fixes
A fresh `collected/` can sit above stale `resolved/` for weeks if analysis was not re-run after an extraction filter landed. Symptom: canary absent from `collected/*.json` but present in `resolved/*.json` — frozen before the filter existed. Pre-investigation check: compare checkpoint mtime to `collection/crates/extract-{swift,objc}/src/**` mtimes. If source is newer, regenerate (`cargo run -p apianyware-macos-analyze`) before forming hypotheses. Automated by `analysis/scripts/regenerate-stale-pipeline.sh`. See "Codegen freshness uses newest-input vs newest-output" for the comparison rule.

### Workspace lint requires two escape hatches
`cargo clippy --workspace --all-targets -- -D warnings` is the lint gate.

1. **Ascent-generated code.** `ascent!` macro in `resolve/program.rs` and `enrich/program.rs` triggers `clone_on_copy`, `unused_unit`, `needless_lifetimes` on Copy-typed fields. Module-level `#![allow(...)]` covers it; add new lint names only for new families.
2. **`unsafe_code` is a rustc lint, not clippy.** Workspace sets `unsafe_code = "warn"`. Rust 2024 makes `env::set_var`/`env::remove_var` unsafe, firing in tests. Use per-fn `#[allow(unsafe_code)]` with SAFETY comment; do not relax the workspace setting.

### Codegen freshness uses newest-input vs newest-output
Multi-stage codegen freshness: "newest input mtime > newest output mtime", not "newest > oldest output". The oldest-output variant produces perpetual false positives from tool-managed files (e.g., `raco make` `.zo`/`.dep`) or orphaned prior-version output. Exclude tool-managed subdirectories (e.g., `*/compiled/*`) from the output scan.

### Missing output dirs are not staleness signals
Freshness guardrails skip targets with no existing output directory. Stub emitters (e.g., `racket-functional`) register in the emitter registry but never produce a `generated/` directory. Treating absence as staleness creates an infinite regen loop. First-time generation is manual.

### Swift printed_name catches label overloads not type overloads
`printed_name` encodes parameter labels (e.g., `pointwiseMin(_:_:)`) but not parameter types. ObjC's `{owner}.{selector}` is stronger because selectors encode full parameter structure. True type-based overloads sharing identical `printed_name` (12 remaining per fresh collection) require mangled signatures or parameter-type lists to distinguish.

### Wire-format JSON in docs and tests is a coupling surface
Design-doc examples (e.g., `docs/specs/2026-03-26-macos-workspace-design.md`) and tests asserting on `serde_json::to_string` output (e.g., `foundation_serializes_to_json`) are tightly coupled to serde annotations. Both must update in lockstep with serde `rename`/`alias`/`skip` changes.

### LLM annotations use a dedicated input directory
Two annotation sources: (1) heuristic annotations via checkpoint output dir (`load_existing_annotations()`), (2) LLM-generated `.llm.json` files from `--llm-dir` (`load_llm_annotations()` in `llm.rs`). LLM annotations take precedence via merge logic. Workflow: `llm-extract` CLI → `.methods.json` summaries of interesting methods (block params, error out-params, delegate/observer patterns) → Claude Code subagent → `.llm.json` → `annotate --llm-dir` merges. Runs within Claude Code for cost reasons.
