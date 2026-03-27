# APIAnyware-MacOS Implementation Plan

Build a three-phase pipeline (Collection → Analysis → Generation) for extracting, analyzing, and generating language bindings for macOS platform APIs.

Full spec: `docs/specs/2026-03-26-macos-workspace-design.md`
Restructure spec: `docs/specs/2026-03-27-plan-restructure-design.md`
POC project: `../APIAnyware/` (harvest code from here)
TestAnyware: `../TestAnyware/` (GUI testing — use dev build, can fix bugs in-place)
The Great Explainer: `../TheGreatExplainer/` (documentation generation — requirements only for now)

## Session Continuation Prompt

```
You MUST first read `LLM_CONTEXT/index.md` and `LLM_CONTEXT/coding-style.md`.

Then continue working on the task outlined in `LLM_STATE/plan.md`.
Review the file to see current progress, then continue from the next incomplete step.
For language-specific work, also read the sub-plan: `LLM_STATE/plan-{lang}.md`.

Design spec: `docs/specs/2026-03-26-macos-workspace-design.md`
Restructure spec: `docs/specs/2026-03-27-plan-restructure-design.md`
Language template: `LLM_STATE/plan-template.md`
POC to harvest from: `../APIAnyware/`

After completing each step, update the relevant plan file with:
1. Mark the step as complete [x]
2. Add any learnings discovered

Use Mermaid for all diagrams — never ASCII art.
```

## Progress

### Milestone 1: Shared Types

Define the IR types, annotation schema, provenance, and checkpoint file format.

- [x] 1.1 Define core IR types in `collection/crates/types/`
  - [x] Harvest `Framework`, `Class`, `Method`, `Property`, `Protocol`, `Enum`, `Struct`, `Function`, `Constant`, `TypeRef` from POC `crates/core/src/ir.rs`
  - [x] Add `SourceProvenance` struct (header path, line, SDK version, availability)
  - [x] Add `DocRefs` struct (header comment, Apple doc URL, USR)
  - [x] Add `source` field to Method/Property (`objc_header` vs `swift_interface`)
  - [x] Add `format_version` and `checkpoint` fields to Framework
  - [x] Null-safe deserialization for Go-style null arrays
  - [x] Write tests: deserialize POC's Level 1 IR JSON successfully
- [x] 1.2 Define annotation schema in `collection/crates/types/`
  - [x] Harvest `MethodAnnotation`, `BlockInvocationStyle`, `OwnershipKind`, `ThreadingConstraint`, `ErrorPattern`, `AnnotationSource` from POC `crates/annotate/src/schema.rs`
  - [x] Add `AnnotationOverrides` and `AnnotationOverride` types
  - [x] Write tests: round-trip annotation JSON
- [x] 1.3 Verify workspace builds and all crates resolve types
  - [x] `cargo check --workspace` passes
  - [x] `cargo test --workspace` passes (21 tests: 14 IR deserialization + 7 annotation roundtrip)

### Milestone 2: ObjC/C Collection

Extract API metadata from macOS SDK headers using libclang.

- [x] 2.1 Set up libclang integration
  - [x] Add `clang` crate dependency to `collection/crates/extract/`
  - [x] Implement SDK discovery via `xcrun --show-sdk-path`
  - [x] Implement framework discovery: scan `{SDK}/System/Library/Frameworks/`
  - [x] Write test: discover Foundation framework from SDK (4 tests)
- [x] 2.2 Implement ObjC header parsing
  - [x] Parse umbrella headers with libclang (`-x objective-c` + SDK flags)
  - [x] Extract classes: name, superclass, protocols
  - [x] Extract methods: selector, params, return type, class_method, init_method
  - [x] Extract properties: name, type, readonly, class_property (including category properties)
  - [x] Extract protocols: name, inherits, required/optional methods (via `is_objc_optional()`)
  - [x] Extract enums: name, type, values
  - [x] Extract structs: name, fields
  - [x] Extract functions: name, params, return type
  - [x] Extract constants: name, type
- [x] 2.3 Capture provenance and documentation
  - [x] Source location: header file path, line number from libclang cursor
  - [x] SDK version from `xcrun --show-sdk-version`
  - [x] Availability attributes from libclang (`get_platform_availability()`)
  - [x] Header doc comments from libclang (`get_comment_brief()`)
  - [x] USR from libclang (`get_usr()`)
  - [x] Apple doc URL construction from USR (basic heuristic)
- [x] 2.4 Implement TypeRef mapping
  - [x] Map libclang types to `TypeRef` variants (id, instancetype, class, block, pointer, primitive, struct, alias, selector)
  - [x] Handle nullability annotations (`_Nullable`, `_Nonnull`)
  - [x] Handle block types with full parameter resolution
  - [x] Handle typedef aliases (NSInteger→int64, NSUInteger→uint64, CGFloat→double, etc.)
- [x] 2.5 Wire up CLI
  - [x] `apianyware-macos-collect` discovers and extracts all frameworks
  - [x] `--only` flag for specific frameworks
  - [x] `--list` flag to show available frameworks (218 frameworks discovered)
  - [x] Write to `collection/ir/collected/{Framework}.json`
- [x] 2.6 Validate against POC output
  - [x] Compare Rust-extracted Foundation against POC's `ir/level0/Foundation.json`
  - [x] Spot-check: NSString 36 properties (matches POC), 167 total methods (vs POC 150 — newer SDK)
  - [x] Spot-check: Block params, nullable types, class generics all work (13 extraction tests)
  - [x] Rust extraction is a superset with provenance, doc_refs, and source fields

### Review 2
- [x] 2.R Review Collection
  - [x] All SDK frameworks discoverable and extractable (218 ObjC + 151 Swift, 0 extraction errors)
  - [x] Provenance and doc_refs populated for all declarations (FIX: added `source`, `provenance`, `doc_refs` fields to Enum, Function, Struct, Constant, Protocol IR types and extraction code — previously only Method/Property had these)
  - [x] TypeRef mapping handles all ObjC type patterns (9 kinds, 14,703 types mapped in Foundation, 0 unhandled fallbacks)
  - [x] Output JSON is deterministic and diffable (identical across runs excluding timestamp)

### Milestone 3: Swift Collection

Extract Swift-only API metadata via swift-api-digester.

- [x] 3.1 Implement swift-api-digester integration
  - [x] Locate via `xcrun --find swift-api-digester`
  - [x] Invoke `swift-api-digester -dump-sdk -module {Framework} -sdk {SDK} -target arm64-apple-macos14.0`
  - [x] Parse `ABIRoot` JSON tree (AbiDocument/AbiNode serde model with 2 parse tests)
  - [x] Discover Swift modules by scanning `{SDK}/System/Library/Frameworks/*/Modules/*.swiftmodule`
  - [x] 151 Swift modules discovered, 3 discovery/invocation tests
- [x] 3.2 Map Swift declarations to IR types
  - [x] Swift classes → IR Class (with superclass, conformances, methods, properties)
  - [x] Swift structs → IR Struct (with fields from Var children)
  - [x] Swift methods → IR Method with `source: "swift_interface"` (including static→class_method)
  - [x] Swift constructors → IR Method with `init_method: true`
  - [x] Swift properties → IR Property (readonly from isLet or getter-only accessors)
  - [x] Swift enums → IR Enum (EnumElement cases with synthetic ordinals)
  - [x] Swift protocols → IR Protocol (protocolReq → required_methods)
  - [x] Top-level functions → IR Function
  - [x] Availability attributes from `intro_Macosx` field
  - [x] Type mapping: Swift primitives, Optional→nullable, Array→NSArray, Foundation bridged types, ObjC-bridged USRs, closures→blocks (8 unit tests)
  - [x] 8 declaration mapping integration tests
- [x] 3.3 Merge ObjC and Swift declarations
  - [x] For frameworks with both ObjC headers and Swift modules, merge into single output
  - [x] Swift extensions on ObjC classes: add methods with `source: "swift_interface"` (dedup by selector)
  - [x] Swift-only classes, protocols, enums, structs, functions, constants added if not in ObjC
  - [x] Protocol conformances and imports merged
  - [x] 4 merge unit tests
- [x] 3.4 Update CLI
  - [x] `apianyware-macos-collect` runs both ObjC and Swift extractors
  - [x] `--no-swift` flag to skip Swift extraction
  - [x] `--list` shows `[objc]`, `[swift]`, `[objc+swift]` tags
  - [x] Single `ir/collected/{Framework}.json` per framework with merged output
  - [x] Foundation: 273→308 classes, 44→83 protocols, 14→122 structs after Swift merge
  - [x] SwiftData: 6 classes, 19 protocols, 5 enums, 19 structs (Swift-only)

### Review 3
- [x] 3.R Review Swift Collection
  - [x] Swift-only frameworks produce valid IR (SwiftData: 6 classes/19 protocols/5 enums/19 structs; Charts: 15 protocols/2 enums/98 structs; all `source: swift_interface`; Observation not discoverable — stdlib-level module, documented)
  - [x] ObjC frameworks with Swift overlays merge correctly (Foundation: 3528 ObjC + 163 Swift methods; Swift-only classes like JSONDecoder/PropertyListEncoder added; duplicates correctly deduplicated)
  - [x] `source` field correctly distinguishes ObjC vs Swift declarations (FIX: added `source` field to all declaration types; previously only Method/Property had it. Also fixed `is_method_family` to handle Swift-style `init(...)` selectors for ownership detection)

### Milestone 4: Datalog Resolution

Implement Datalog pass 1: inheritance flattening, ownership detection, protocol conformance.

- [x] 4.1 Set up shared Datalog infrastructure in `analysis/crates/datalog/`
  - [x] Ownership detection helpers (`is_returns_retained`, `is_method_family`) in `ownership.rs` (15 unit tests)
  - [x] Framework JSON loading utilities in `loading.rs` (3 unit tests)
  - [x] Handle cross-framework dependencies (load all frameworks into one program before running)
- [x] 4.2 Implement resolution rules in `analysis/crates/resolve/`
  - [x] `ascent!` program with `ancestor`, `effective_method`, `effective_property`, `returns_retained_method`, `satisfies_protocol_method` rules (harvested from POC)
  - [x] Fact loader: iterates Framework IR → pushes tuples into ResolutionProgram (6 unit tests)
  - [x] Checkpoint builder: maps Datalog results back into Framework IR with `ancestors`, `all_methods`, `all_properties`, `returns_retained`, `satisfies_protocol` fields
  - [x] Write checkpoint: `analysis/ir/resolved/{Framework}.json`
- [x] 4.3 Validate against collected Foundation IR
  - [x] Foundation: 411 ancestor relations, 4912 effective methods, 2286 effective properties
  - [x] Returns retained: 523 methods detected (init/new/copy/mutableCopy families)
  - [x] Protocol conformance: 13 satisfies_protocol matches
  - [x] 16 integration tests: ancestors, inheritance, overrides, properties, ownership, protocol conformance, checkpoint building, JSON roundtrip
- [x] 4.4 Wire up CLI
  - [x] `apianyware-macos-analyze resolve` with `--only` and `--input-dir`/`--output-dir` flags
  - [x] Auto-discovers `collection/ir/collected/*.json`
  - [x] `apianyware-macos-analyze` (no subcommand) runs full pipeline (annotate/enrich stubs)
  - [x] `apianyware-macos-analyze resolve --only Foundation` end-to-end verified

### Milestone 5: Annotation & API Pattern Recognition

Implement heuristic classification, LLM annotation merge, and API usage pattern recognition.

- [x] 5.1 Harvest heuristics from POC
  - [x] `heuristics.rs` → `analysis/crates/annotate/src/heuristics.rs` (10 tests: delegate/datasource params, sync/async/stored blocks, error outparam, threading UI class/selector, block copy ownership)
  - [x] `validate.rs` → `analysis/crates/annotate/src/validate.rs` (10 tests: agreement, ownership/block/threading disagreement, merge prefers LLM, merge fills gaps, heuristic-only fallback, threading/block overrides, no-disagreement-when-one-is-none)
  - [x] Adapt for new types crate (imports from `apianyware_macos_types::annotation::*` and `ir::Method`/`type_ref::TypeRefKind`; Method test helper includes `source`/`provenance`/`doc_refs` optional fields)
  - [x] Added `AnnotationDisagreement` and `DisagreementResolution` types to `collection/crates/types/src/annotation.rs` (were in POC's schema.rs but missing from our types crate)
- [x] 5.2 Implement annotation merge
  - [x] Read `analysis/ir/resolved/{Framework}.json` (uses shared `loading::load_all_frameworks`)
  - [x] Run heuristics on all methods (direct methods, inherited `all_methods`, AND category methods)
  - [x] Merge with existing LLM annotations from `analysis/ir/annotated/{Framework}.json`
  - [x] Write merged output to `analysis/ir/annotated/{Framework}.json` (self-contained checkpoint with `class_annotations` field on Framework)
  - [x] Added `class_annotations: Vec<ClassAnnotations>` to Framework IR struct (annotated checkpoint is self-contained)
  - [x] Foundation: 272 classes, 5965 method annotations (81 sync blocks, 103 async blocks, 3 stored, 199 error-out, 221 ownership)
- [x] 5.3 Set up LLM annotation infrastructure
  - [x] Create `analysis/scripts/prompt-template.md` (annotation schema, classification guidance, output format)
  - [x] Create `analysis/scripts/llm-annotate.sh` (provider-agnostic, calls OpenAI-compatible API, filters interesting methods, handles batching)
  - [x] Create `analysis/scripts/config.example.toml` (Anthropic/OpenAI/Ollama/vLLM URLs, model, key env var, paths, batch_size, temperature)
  - [x] Updated `/analyze` Claude Code command to match current architecture (LLM writes temp `.llm.json`, then `cargo run annotate` merges)
- [x] 5.4 Wire up CLI
  - [x] `apianyware-macos-analyze annotate` processes all resolved frameworks
  - [x] Auto-discovers `analysis/ir/resolved/*.json`
  - [x] Full pipeline (no subcommand) now runs resolve → annotate (enrich still stub)
  - [x] `apianyware-macos-analyze annotate --only Foundation` end-to-end verified
- [x] 5.5 Research API pattern stereotypes
  - [x] Survey macOS frameworks for recurring multi-method behavioral contracts
  - [x] Identify stereotypes: resource lifecycle, builder sequence, observer pair, transaction bracket, enumeration, error-out, delegate protocol, target-action, paired state, factory cluster
  - [x] For each stereotype: document the shape (method roles, ordering constraints, ownership/threading implications)
  - [x] For each stereotype: identify canonical macOS examples from Apple's programming guides and tutorials
  - [x] For each stereotype: sketch idiomatic translations for representative target languages (Scheme/Lisp, Haskell, OCaml, Zig, Smalltalk)
  - [x] Write `analysis/docs/api-pattern-catalog.md` — versioned catalog with 10 stereotypes, detection rules, constraints, examples, and translation templates
- [x] 5.6 Define API pattern IR schema
  - [x] Add `ApiPattern`, `PatternStereotype`, `PatternConstraint` types to `collection/crates/types/src/annotation.rs`
  - [x] `PatternStereotype` enum: 10 variants (resource_lifecycle, builder_sequence, observer_pair, transaction_bracket, enumeration, error_out, delegate_protocol, target_action, paired_state, factory_cluster)
  - [x] `ApiPattern`: stereotype, name, participants (flexible JSON), constraints, source, doc_ref
  - [x] Add `api_patterns: Vec<ApiPattern>` field to `Framework` (populated during annotation, carried through enrichment)
  - [x] Write tests: pattern schema roundtrip serialization (2 tests: ApiPattern roundtrip, PatternStereotype serialization)
- [x] 5.7 Implement heuristic pattern detection
  - [x] Detect factory clusters from NSMutable*/NS* class name pairs (10 in Foundation)
  - [x] Detect observer pairs from `addObserver`/`removeObserver` selector pairs (5 in Foundation)
  - [x] Detect paired state from `lock`/`unlock`, `beginEditing`/`endEditing`, `beginUndoGrouping`/`endUndoGrouping`, and generic `begin*`/`end*` pairs (3 in Foundation)
  - [x] Detect delegate protocols from `setDelegate:` + matching `*Delegate` protocol (17 in Foundation)
  - [x] Detect resource lifecycles from `beginAccessing*`/`endAccessing*` pairs (1 in Foundation)
  - [x] Wired pattern detection into annotate pipeline (patterns populate `api_patterns` on Framework)
  - [x] 7 unit tests + 1 Foundation integration test (36 total patterns detected)
  - [x] Error-out detection already handled by per-method heuristics (not a multi-method pattern)
- [x] 5.8 Extend LLM prompt for pattern recognition
  - [x] Rewrote `prompt-template.md` with comprehensive pattern recognition guidance
  - [x] Emphasizes programming guides as primary source (not API reference docs which describe isolated functions)
  - [x] Explains how to recognize implicit patterns from step-by-step instructions, "must"/"should" statements, code examples, and multi-paragraph narratives
  - [x] Full stereotype catalog with recognition signals for each type
  - [x] Guide-by-framework table mapping guides to discoverable patterns
  - [x] Pre-seeded Foundation patterns in `Foundation.patterns.json` (28 patterns: observers, resource lifecycles, transaction brackets, factory clusters, builders, enumerations, delegates, paired state)

### Milestone 6: Enrichment

Implement Datalog pass 2: annotation-derived relations, API pattern enrichment, and verification.

- [x] 6.1 Implement enrichment rules in `analysis/crates/enrich/`
  - [x] Load type facts + annotation facts (`fact_loader.rs`: type-level facts from IR + annotation facts from `class_annotations`)
  - [x] Derive: `sync_block_method`, `async_block_method`, `stored_block_method` (lifted from block classification annotations)
  - [x] Derive: `delegate_protocol` (from setDelegate: + *Delegate protocol conformance), `convenience_error_method` (from error_outparam annotation)
  - [x] Derive: `collection_iterable` (objectAtIndex: + count, or NSFastEnumeration conformance), `scoped_resource` (from api_patterns with PairedState/ResourceLifecycle stereotypes)
  - [x] Derive: `main_thread_class` (from any method with MainThreadOnly threading annotation)
- [x] 6.2 Implement API pattern enrichment
  - [x] Load pattern annotations from annotated checkpoint (`api_patterns` field on Framework)
  - [x] Scoped resources extracted from PairedState/ResourceLifecycle pattern participants (open/close, begin/end, lock/unlock)
  - [x] Delegate protocols extracted from DelegateProtocol pattern names
  - [x] api_patterns carried forward in enriched checkpoint (emitters read them directly)
  - [x] Note: separate pattern_instance/participant/constraint Datalog relations not needed — patterns are already structured JSON that emitters consume directly. Lifting them into flat Datalog tuples would lose the flexible participant structure.
- [x] 6.3 Implement verification rules
  - [x] `violation_flag_mismatch` — retained flag from resolve step vs naming convention (only for resolve-processed methods, avoids false positives on category methods)
  - [x] `violation_unclassified_block` — every block param must have sync/async/stored classification
  - [x] Write verification report in enriched checkpoint (`verification: { passed: true/false, violations: [...] }`)
  - [x] Note: `violation_unwrapped` deferred to emitter stage (requires emitter wrapping metadata, not available at enrichment)
- [x] 6.4 Wire up CLI
  - [x] `apianyware-macos-analyze enrich` processes all annotated frameworks
  - [x] `apianyware-macos-analyze` runs full pipeline: resolve → annotate → enrich
  - [x] Auto-discovers input files at each step (excludes ancillary `*.patterns.json` files)
- [x] 6.5 Validate enrichment
  - [x] Foundation: zero verification violations (0 unclassified blocks, 0 flag mismatches)
  - [x] Enrichment relations populated: 81 sync blocks, 116 async blocks, 4 stored blocks, 199 error methods, 10 iterables, 4 scoped resources
  - [x] API patterns carried forward in enriched checkpoint (36 heuristic patterns from annotate step)
  - [x] Enriched checkpoint is self-contained: `analysis/ir/enriched/Foundation.json` has all data (collected + resolved + annotated + enrichment + verification)
  - [x] 20 enrichment tests (9 unit + 11 integration, including Foundation end-to-end)

### Review 6
- [x] 6.R Review Analysis Pipeline
  - [x] Full pipeline: collect → resolve → annotate → enrich runs end-to-end (Foundation: 308 classes, 447 ancestors, 5165 effective methods, 6218 annotations, 37 patterns, 0 violations)
  - [x] All checkpoints are valid JSON matching the spec (each checkpoint is a proper superset of prior; all spec fields present including provenance, doc_refs, source on all declaration types)
  - [x] Verification passes for all frameworks (Foundation: 0 unclassified blocks, 0 flag mismatches)
  - [x] API pattern catalog is documented and pattern instances are populated (10 stereotypes in catalog, 37 pattern instances in Foundation covering 5 stereotypes: factory_cluster, delegate_protocol, observer_pair, paired_state, resource_lifecycle)
  - [x] Memory architecture doc is complete and accurate (harvested from POC, adapted for new project structure, covers ownership model, block/delegate lifecycle, GC prevention, verification rules)
  - [x] Annotation workflow doc is complete (new doc covering full pipeline, LLM annotation options, heuristic classifications, merge precedence, verification checking)
  - [x] Enrich rules doc created (documents all 8 derived relations + 2 verification rules with meanings, derivation logic, emitter actions, and Foundation numbers)

### Milestone 7: Generation

Build the shared emitter framework, port the Racket emitter from POC, then add emitters for all target languages. Each emitter produces idiomatic bindings — not thin C wrappers. Languages with multiple paradigms (OO + functional) get multiple binding styles from the same enriched IR.

- [x] 7.1 Port shared emitter framework (`emit` crate)
  - [x] Common utilities: name mapping (`naming.rs` — camelCase/kebab/snake conversions, selector parsing, mutating detection), FFI type mapping (`ffi_type_mapping.rs` — `FfiTypeMapper` trait + `RacketFfiTypeMapper`), code writer (`code_writer.rs` — `CodeWriter` + `FileEmitter` + `write_line!` macro)
  - [x] Framework ordering (`framework_ordering.rs` — topological sort via Kahn's algorithm on `depends_on` DAG)
  - [x] Doc rendering (`doc_rendering.rs` — `DocBlock` from provenance/doc_refs, language-neutral lines with `format_doc_lines` prefix adapter)
  - [x] Binding style abstraction (`binding_style.rs` — `BindingStyle` enum: OO/Functional/Procedural, `LanguageInfo` metadata, `EmitResult` counters)
  - [x] API pattern → idiomatic construct dispatch (`pattern_dispatch.rs` — `classify_pattern` maps stereotypes to `IdiomaticConstruct` variants: ScopedResource, BuilderDsl, ScopedObserver, TransactionBracket, IterationAdapter, ResultWrapper, SmartConstructor, ScopedGuard, PassThrough)
  - [x] 45 tests passing, workspace builds clean, `cargo +nightly fmt` applied
- [x] 7.2 Port Swift helper dylibs (shared C-callable ObjC runtime interface)
  - [x] `swift/Package.swift` — Swift 6.0, macOS 14+, 3 dynamic library products (Racket, Chez, Gerbil), each statically embedding APIAnywareCommon
  - [x] `APIAnywareCommon` — 7 modules: MessageSend (typed objc_msgSend wrappers for ptr/void/bool/uint/int/double/struct returns), ClassLookup (class/selector lookup), MemoryManagement (retain/release), AutoreleasePool (push/pop via ObjC runtime), StringConversion (NSString<->UTF-8), StructMarshal (pack/unpack CGPoint/CGSize/CGRect/NSRange/NSEdgeInsets), ObservationBridge (Swift Observation framework bridge to C FFI)
  - [x] `APIAnywareRacket` — 4 modules: RacketFFI (re-export), GCPrevention (registry preventing language-runtime GC of live callbacks), BlockBridge (ObjC block creation from C function pointers with _NSConcreteGlobalBlock isa, copy/dispose helpers, automatic GC handle lifecycle), DelegateBridge (dynamic ObjC class creation with per-instance dispatch table, IMP trampolines for void/bool/id returns with 0-3 args, dealloc cleanup)
  - [x] `APIAnywareChez` and `APIAnywareGerbil` — stubs importing Common
  - [x] 64 tests passing: 7 Common test files (MessageSend 15, ClassLookup 5, MemoryManagement 2, AutoreleasePool 3, StringConversion 4, StructMarshal 13, ObservationBridge 3) + 3 Racket test files (GCPrevention 5, BlockBridge 8, DelegateBridge 7)
  - [x] All 3 dylibs build successfully: libAPIAnywareRacket.dylib, libAPIAnywareChez.dylib, libAPIAnywareGerbil.dylib
- [x] 7.3 Port Racket emitter + runtime (OO + functional styles)
  - [x] `emit-racket` crate: 8 modules ported from POC (naming, method_filter, shared_signatures, emit_class, emit_protocol, emit_enums, emit_constants, emit_framework)
  - [x] Adapted imports: `apianyware_core::ir` → `apianyware_macos_types::ir` + `type_ref`, `apianyware_emit` → `apianyware_macos_emit`
  - [x] Adapted for new IR types: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields
  - [x] Added `is_family_match` support for Swift-style `init(...)` selectors (POC didn't have this)
  - [x] Framework header uses generic format string instead of per-framework match arms
  - [x] `RACKET_LANGUAGE_INFO` constant declares OO + Functional binding styles
  - [x] `EmitResult` uses shared type from emit crate (not POC's local struct)
  - [x] 7 Racket runtime files ported to `generation/targets/racket/runtime/`
  - [x] Updated dylib name: `libanyware_racket` → `libAPIAnywareRacket` in `swift-helpers.rkt`
  - [x] 20 tests passing, workspace builds clean (236 total), `cargo +nightly fmt` applied
**Milestones 7.4–7.14 superseded.** Language targets are now individual milestones (9–19) with comprehensive substeps. See `docs/specs/2026-03-27-plan-restructure-design.md`.

---

### Milestone 8: Test Infrastructure & Workflow

Build the machinery that every language target uses. Must complete before any language target finishes.

- [x] 8.1 Generation CLI (`apianyware-macos-generate`)
  - [x] Binary crate at `generation/crates/cli/` with `registry.rs` (emitter registry) and `generate.rs` (orchestration)
  - [x] `--lang` flag selects language (default: all registered), generates all styles and all frameworks
  - [x] Reads enriched IR from `analysis/ir/enriched/` (reuses `apianyware_macos_datalog::loading`)
  - [x] Invokes registered emitter, writes to `generation/targets/{lang}/generated/{style}/{framework}/`
  - [x] `--list-languages` shows available emitters and their binding styles
  - [x] `LanguageEmitter` trait in shared emit crate, `RacketEmitter` implements it
  - [x] Topological sort for framework dependency ordering during generation
  - [x] 11 tests (4 registry + 7 generation orchestration), Foundation end-to-end verified (382 files, 308 classes)
- [x] 8.2 Snapshot test harness
  - [x] `snapshot_testing.rs` in shared emit crate: `GoldenTest` struct with `assert_matches()`, directory comparison, unified diff output, `UPDATE_GOLDEN=1` env var for refreshing golden files (10 unit tests)
  - [x] `test_fixtures.rs` in shared emit crate: `build_snapshot_test_framework()` — deterministic synthetic `TestKit` framework with 5 classes, 2 protocols, 1 enum, 2 constants exercising all emitter code paths (constructors, properties, methods, blocks, dispatch strategies, inheritance, class methods) (5 unit tests)
  - [x] Racket OO integration test: generates TestKit bindings, compares against 10 golden files (5 classes + 2 protocols + enums + constants + main.rkt)
  - [x] Per-language, per-binding-style golden sets at `emit-{lang}/tests/golden/{style}/`
  - [x] Integrated into `cargo test` — regression detected immediately with diff output and update instructions
- [x] 8.3 Sample app specifications
  - [x] `generation/apps/specs/hello-window.md` — object lifecycle, property setters, NSWindow
  - [x] `generation/apps/specs/counter.md` — target-action, buttons, mutable state
  - [x] `generation/apps/specs/ui-controls-gallery.md` — all standard AppKit controls, visual regression baseline
  - [x] `generation/apps/specs/file-lister.md` — NSTableView, data source delegate, NSFileManager, NSOpenPanel
  - [x] `generation/apps/specs/text-editor.md` — block callbacks, error-out, undo/redo, notifications, find
  - [x] `generation/apps/specs/mini-browser.md` — cross-framework WebKit, WKNavigationDelegate, URL handling
  - [x] `generation/apps/specs/menu-bar-tool.md` — NSStatusBar, NSMenu, no-window app, timers, clipboard
  - [x] `generation/apps/tests/` — 7 TestAnyware validation scripts with step-by-step checklists per app
- [x] 8.4 TestAnyware workflow documentation
  - [x] `generation/apps/testanyware-workflow.md` — full LLM-driven QA workflow: VM setup, build, launch, screenshot-driven exploration loop, issue categorization, fix-and-retest cycle
  - [x] Uses dev build from `../TestAnyware/` with in-place fix workflow documented
  - [x] Test artifact conventions: `generation/targets/{lang}/test-results/{style}/{app}/` with screenshots and report.md template
- [x] 8.5 New language guide
  - [x] `LLM_STATE/new-language-guide.md` — step-by-step instructions for adding a language target (11 steps, checklist, reference implementations, snapshot test harness integration)

### Milestone 9: Racket (OO + Functional)

First language target — proves the template. See `LLM_STATE/plan-racket.md` for full details.

- [x] 9.1 Emitter crate (20 tests)
- [x] 9.2 Runtime library (7 files, all load in Racket, dylib available)
- [x] 9.3 Swift dylib integration (39 Racket tests: 7 load + 20 FFI round-trip + 5 block + 7 delegate)
- [x] 9.4 Generation CLI wiring (already functional from 8.1; Foundation: 382 files × 2 styles)
- [x] 9.5 Snapshot tests (TestKit full + Foundation 18-file curated subset, `assert_subset_matches` added)
- [x] 9.6 Language-side smoke tests (15 OO smoke tests + 3 emitter bugs fixed: runtime paths, Swift selectors, coerce-arg cast)
- [ ] 9.7 Sample apps — OO style (7 apps, each in its own session)
- [ ] 9.8 Sample apps — Functional style (7 apps, blocked on functional emitter)
- [ ] 9.9 TestAnyware validation
- [ ] 9.10 Per-framework exercisers
- [ ] 9.11 Documentation placeholder

### Review 9 — Hardening & LLM Integration

**Stop after Milestone 9 to review and harden before adding more languages.** Running all 283 frameworks already exposed a real enrichment bug. Comprehensive testing and cleanup will prevent issues from compounding across language targets.

- [ ] 9.R.1 Framework ignore list — explicitly mark DriverKit, Tk, and any other inappropriate frameworks (C++ headers, Tcl/Tk, stub-only) as ignored with documented reasons, rather than silently failing or producing empty output
- [ ] 9.R.2 Test coverage audit — identify gaps across collection, resolution, annotation, enrichment, and generation; target 100% coverage of all code paths
- [ ] 9.R.3 Testing methodology improvements — evaluate test reliability, consider property-based tests, cross-framework integration tests, and end-to-end pipeline smoke tests that exercise all 283 frameworks
- [ ] 9.R.4 LLM analysis integration — replace the external `llm-annotate.sh` script with a proper Rust command (`apianyware-macos-analyze llm-annotate`) that handles batching, provider configuration, prompt management, and merge — no manual steps required
- [ ] 9.R.5 Code review and cleanup — address any accumulated tech debt, naming inconsistencies, or dead code discovered during review

### Milestone 10: Chez Scheme (Functional)

See `LLM_STATE/plan-chez.md` (created when work begins).

- [ ] 10.1–10.11 (follows template, single binding style)

### Milestone 11: Gerbil Scheme (OO + Functional)

See `LLM_STATE/plan-gerbil.md` (created when work begins).

- [ ] 11.1–11.11 (follows template)

### Milestone 12: Haskell (Monadic + Lens-based)

See `LLM_STATE/plan-haskell.md` (created when work begins).

- [ ] 12.1–12.11 (follows template)

### Milestone 13: OCaml (Modules + OO)

See `LLM_STATE/plan-ocaml.md` (created when work begins).

- [ ] 13.1–13.11 (follows template)

### Milestone 14: Prolog/Mercury (Relational)

See `LLM_STATE/plan-prolog.md` (created when work begins).

- [ ] 14.1–14.11 (follows template, single binding style)

### Milestone 15: Idris2 (Dependently-typed)

See `LLM_STATE/plan-idris2.md` (created when work begins).

- [ ] 15.1–15.11 (follows template, single binding style)

### Milestone 16: Common Lisp (CLOS + Functional; SBCL and CCL)

See `LLM_STATE/plan-cl.md` (created when work begins).

- [ ] 16.1–16.11 (follows template, two implementations)

### Milestone 17: Rhombus (OO)

See `LLM_STATE/plan-rhombus.md` (created when work begins).

- [ ] 17.1–17.11 (follows template, single binding style)

### Milestone 18: Pharo Smalltalk (Message-passing OO)

See `LLM_STATE/plan-smalltalk.md` (created when work begins).

- [ ] 18.1–18.11 (follows template, single binding style)

### Milestone 19: Zig (Procedural)

See `LLM_STATE/plan-zig.md` (created when work begins).

- [ ] 19.1–19.11 (follows template, single binding style)

### Milestone 20: The Great Explainer — Requirements

Create the companion project and define requirements. See `../TheGreatExplainer/`.

- [ ] 20.1 Create project structure and README
- [ ] 20.2 Write requirements document (driven by APIAnyware-MacOS needs)
- [ ] 20.3 Define integration contract (input: enriched IR + bindings + sample apps → output: docs)
- [ ] 20.4 Sketch architecture for tutorial validation (container/VM-based step verification)

### Milestone 21: Documentation Pass

Blocked on The Great Explainer. Apply to all completed language targets.

- [ ] 21.1 API reference generation for each language
- [ ] 21.2 Tutorial generation for each language (paradigm-appropriate)
- [ ] 21.3 Tutorial validation (every code snippet runs, every step verified)
- [ ] 21.4 Cross-references to Apple documentation

## Learnings

- **POC backward compat via serde alias:** `#[serde(alias = "ir_version")]` on `format_version` lets old POC JSON with `ir_version` field deserialize into the new `format_version` field cleanly. The old `ir_level` field is kept as `Option<i32>` with `skip_serializing` so it reads but never writes.
- **Module structure for types crate:** Split into `ir.rs`, `type_ref.rs`, `provenance.rs`, `annotation.rs`, `serde_helpers.rs`. Each file handles one concern. Re-exports in `lib.rs` keep the public API ergonomic.
- **POC test file paths:** Integration tests reference POC IR JSON at `../../../APIAnyware/ir/level1/`. Path is relative from `CARGO_MANIFEST_DIR` (the types crate dir) up to the Development directory.
- **All types derive Clone + Serialize:** Unlike the POC which only had Deserialize, we derive both Serialize and Deserialize on all IR types since downstream phases need to write checkpoints.
- **ObjC `is_definition()` is always false for `@interface` declarations:** The "definition" in ObjC is the `@implementation`, not the `@interface`. Never use `is_definition()` to filter ObjC interface, protocol, or enum declarations — they have children (methods, properties) even when `is_definition()` returns false.
- **Clang singleton:** `clang::Clang::new()` can only be called once per process. `extract_framework` takes a `&clang::Index` parameter, and tests use `LazyLock` to share the extracted framework across all tests.
- **Category properties must be merged:** ObjC categories contribute both methods and properties. The `extract_category` function extracts both, and properties from categories are merged into the class's `properties` vector (matching POC behavior). This is why NSString's 36 properties mostly come from category extensions.
- **`-fmodules` not needed:** Parsing with `-x objective-c -isysroot {SDK}` without `-fmodules` works correctly. Modules would cause declarations to come from module cache pcm files rather than original headers, making path-based framework filtering unreliable.
- **Extraction counts are a superset of POC:** Rust extraction finds more entities (273 vs 262 classes, 163 vs 141 enums, etc.) because it uses a newer SDK. All POC entities are present.
- **ABIRoot JSON uses inconsistent field naming:** swift-api-digester output mixes camelCase (`printedName`, `declKind`, `funcSelfKind`) with snake_case (`init_kind`, `intro_swift`, `intro_Macosx`). Use `serde(rename_all = "camelCase")` on the struct plus explicit `serde(rename = "init_kind")` on the snake_case exceptions.
- **Swift module discovery location:** Swift modules live at `{SDK}/System/Library/Frameworks/{Name}.framework/Modules/{Name}.swiftmodule/`. Some Swift-only frameworks (like Observation) have their swiftmodule in `usr/lib/swift/` instead — these are stdlib-level modules without a .framework directory. The 151 discovered modules are all proper .framework-based modules.
- **swift-api-digester requires `-target` flag:** Without `-target arm64-apple-macos14.0`, the digester may fail or produce incomplete output. The target architecture must match the host.
- **Swift enum ordinals are synthetic:** Swift enums with cases (`EnumElement` in ABIRoot) don't have integer raw values by default. We assign sequential ordinals (0, 1, 2...) as synthetic values. The `enum_type` is set to `swift_enum` to distinguish from C/ObjC integer-backed enums.
- **Swift merge is additive, ObjC canonical:** When merging Swift into ObjC, ObjC declarations take precedence for duplicates (same selector or property name). Swift-only declarations are appended. This avoids double-counting bridged APIs while capturing Swift extensions and overlays.
- **Foundation Swift merge adds significantly:** Foundation goes from 273→308 classes (+35), 44→83 protocols (+39), 14→122 structs (+108), and 163→182 enums (+19). The structs increase is dramatic because Foundation value types (URL, Data, Date, etc.) are Swift structs bridging ObjC classes.
- **No POC code for Swift extraction:** The POC project has zero Swift extraction code. Milestone 3 is entirely greenfield.
- **Ascent `pub` on relations not supported:** The `ascent!` macro generates a struct where relation fields are automatically public. Adding `pub` before `relation` in the macro body causes a parse error. Only `pub struct ProgramName;` is valid.
- **Collected IR has few direct methods per class:** NSString has only 4 direct methods in collected IR (characterAtIndex:, init, initWithCoder:, length). Most NSString methods come from categories (NSStringExtensionMethods, etc.) which are in `category_methods`. This differs from the POC's Level 1 IR which pre-merged categories. Tests should use `characterAtIndex:` not `compare:` for NSString method checks.
- **Datalog crate split from POC:** The POC had everything in one `CoreProgram` — base relations, resolution rules, AND annotation relations. The new design splits: `datalog` crate provides shared helpers (ownership detection, framework loading), while `resolve` and `enrich` each own their own `ascent!` programs. This is cleaner because resolve doesn't need annotation relations.
- **Cross-framework inheritance works implicitly:** Loading multiple frameworks into the same `ResolutionProgram` before calling `run()` automatically resolves cross-framework inheritance (e.g., AppKit's NSWindow → Foundation's NSResponder → NSObject). No explicit dependency ordering needed.
- **Foundation resolution numbers:** 273 classes, 411 ancestor relations, 4912 effective methods, 2286 effective properties, 523 returns_retained methods, 13 satisfies_protocol matches. 272 of 273 classes have ancestors (all except NSObject).
- **Provenance must be on ALL declaration types:** Originally only Method and Property had `source`, `provenance`, and `doc_refs` fields. Review 2 discovered Enum, Function, Struct, Constant, and Protocol were missing these. Fixed by adding the fields to all IR types and updating both ObjC and Swift extraction code. All ObjC declarations now have full provenance; Swift declarations have availability (from `intro_Macosx`) and USR-based doc_refs but no header/line (swift-api-digester doesn't provide source locations).
- **Swift-style init selectors need `(` in method family detection:** Swift constructors produce selectors like `init(arrayLiteral:)` where the character after `init` is `(`, not uppercase or `:`. The `is_method_family` function must treat `(` as a valid family separator, otherwise Swift init methods won't be detected as `returns_retained`.
- **POC annotate crate had `schema.rs` that we already had:** The POC had AnnotationDisagreement and DisagreementResolution in its schema.rs. These were missing from our types crate and needed to be added. The rest of the POC's schema.rs types (MethodAnnotation, OwnershipKind, etc.) were already in our `annotation.rs`.
- **Annotate must process category methods too:** The initial annotate pipeline only processed `methods` and `all_methods` on each class. Most NSArray/NSString methods are in category_methods (e.g., NSExtendedArray). The annotate pipeline must iterate category_methods alongside direct methods.
- **Annotated checkpoint is self-contained:** Added `class_annotations` and `api_patterns` fields to Framework struct so the annotated checkpoint carries all data needed by the enrich step. No need to read multiple files — one JSON file per framework.
- **Foundation annotation numbers:** 272 classes annotated, 5965 method annotations (81 sync blocks, 103 async blocks, 3 stored, 199 error-out, 221 ownership), 36 heuristic patterns (10 factory clusters, 17 delegate protocols, 5 observer pairs, 3 paired state, 1 resource lifecycle).
- **Pattern recognition from programming guides, not API reference:** API reference describes individual methods in isolation. Programming guides describe how methods work together — sequences, lifecycles, constraints. Pattern recognition requires reading guides for implicit descriptions of multi-method contracts. Apple never names these as "patterns" — they're described through step-by-step instructions, code examples, and "must"/"should" statements.
- **Flexible `participants` as serde_json::Value:** Pattern participants vary by stereotype (resource lifecycle has open/operations/close; observer pair has register/callback/unregister; factory cluster has abstract_class/mutable_variant/factory_methods). Using `serde_json::Value` for participants avoids a complex type hierarchy while keeping the JSON human-readable.
- **Enrichment is a two-source pass:** The EnrichmentProgram loads facts from (1) type-level IR (classes, methods, properties, protocols, block params from TypeRef analysis) and (2) annotation facts (block classifications, threading, error patterns from class_annotations). Both sources come from the same annotated checkpoint JSON, which is a superset of all prior phases.
- **Pattern-derived relations don't need Datalog:** The original plan called for materializing api_patterns as flat Datalog tuples (pattern_instance, pattern_participant, pattern_constraint). In practice, patterns are already structured JSON with flexible participant schemas that vary by stereotype. Flattening them into Datalog would lose this structure. Instead, the enrichment step extracts specific relations (scoped_resource, delegate_protocol) from patterns and carries the full api_patterns array forward for emitters.
- **Category methods don't go through resolve:** The resolve step only processes `methods` on each class (direct declarations). Category methods (from category_methods groups) have no `returns_retained` annotation from resolve. The flag_mismatch verification rule must gate on `resolve_processed_method` to avoid false positives on category init methods.
- **Framework file discovery must skip ancillary files:** The annotated IR directory may contain `Foundation.patterns.json` alongside `Foundation.json`. The `discover_framework_files` loader must filter to `{Name}.json` (no dots in the stem) to avoid trying to parse non-Framework JSON as Framework checkpoints.
- **Foundation enrichment numbers:** 81 sync blocks, 116 async blocks, 4 stored blocks, 199 error methods, 10 collection iterables (NSArray, NSDictionary, NSEnumerator, NSHashTable, NSMapTable, NSOrderedCollectionDifference, NSOrderedSet, NSPointerArray, NSSet + via NSFastEnumeration), 4 scoped resources (NSBundleResourceRequest, NSMutableAttributedString, NSURLHandle, NSUndoManager), 0 delegate protocols (Foundation doesn't use setDelegate: — AppKit does), 0 main thread classes (Foundation is thread-safe — AppKit/UI have main-thread-only).
- **POC emit crate uses `apianyware-core` import:** The POC's `ffi_type_mapping.rs` imports `apianyware_core::ir::{TypeRef, TypeRefKind}`. In the new project this becomes `apianyware_macos_types::type_ref::{TypeRef, TypeRefKind}`. The `naming.rs` and `code_writer.rs` modules are pure Rust with no IR imports, so they port unchanged.
- **Framework has no `category_methods` field:** `category_methods` is on `Class`, not on `Framework`. Test helpers for constructing `Framework` must not include it. The POC's IR had category_methods at the class level too.
- **Added snake_case utilities for non-Lisp emitters:** The POC only had kebab-case (for Racket). Added `camel_to_snake` and `selector_to_snake_name` for languages like Haskell, OCaml, and Zig that use snake_case conventions.
- **Pattern dispatch separates classification from rendering:** `classify_pattern` maps stereotypes to `IdiomaticConstruct` variants (language-neutral). Each language emitter then renders the construct in its own syntax. DelegateProtocol and TargetAction are PassThrough because they're handled inline during class generation, not as separate constructs.
- **Swift helper dylibs port verbatim:** The POC's `swift/` directory has no Rust dependencies — it's pure Swift using `@_cdecl`, `@_silgen_name`, `dlsym`, and ObjC runtime APIs. All 7 Common modules and 4 Racket modules ported without changes. The package name changed from `APIAnyware` to `APIAnywareMacOS` to match the new project. All 64 tests pass immediately after port.
- **Racket emitter ports cleanly with type adaptations:** The emit-racket crate ports from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), and Method now has `source`/`provenance`/`doc_refs` optional fields. The `{}`-formatting of `i64` in Racket `(define name value)` works identically to the POC's string values.
- **Racket runtime dylib name must match Swift package product:** The POC used `libanyware_racket` but the new project builds `libAPIAnywareRacket.dylib` (matching the Swift package product name `APIAnywareRacket`). Only `swift-helpers.rkt` references the dylib name — all other runtime files use `swift-helpers.rkt` indirectly.
- **Framework header simplified from POC:** The POC had per-framework match arms for AppKit/Foundation in `emit_header`. The new version uses a single format string `"/System/Library/Frameworks/{0}.framework/{0}"` — all frameworks follow this path convention on macOS, so the special cases were unnecessary.
- **LanguageEmitter trait enables CLI dispatch:** Added `LanguageEmitter` trait to the shared `emit` crate with `language_info()` and `emit_framework(fw, output_dir, style)` methods. Each language emitter implements this trait (e.g., `RacketEmitter`). The CLI's `EmitterRegistry` collects all implementations and dispatches by language ID. The style parameter is passed through so emitters can differentiate OO vs Functional output when ready.
- **Generation CLI reuses datalog loading infrastructure:** The `apianyware_macos_datalog::loading` module (discover/load framework JSON) is reused by the generation CLI — no need to duplicate file discovery logic. The CLI adds topological sorting on top for dependency-ordered generation.
- **Snapshot tests use custom golden-file comparison, not `insta`:** The `insta` crate handles per-file snapshots well but doesn't naturally handle multi-file directory trees (10+ files per framework). A custom `GoldenTest` in the shared emit crate compares entire directory trees with unified diff output and `UPDATE_GOLDEN=1` env var for refreshing. Simpler, no new dependency, and matches the "diff against checked-in reference files" pattern exactly.
- **Synthetic test framework keeps golden files small and reviewable:** Rather than golden-testing full Foundation (308+ classes), the snapshot harness uses a deterministic 5-class `TestKit` framework that exercises all emitter code paths (constructors, properties, methods, blocks, dispatch strategies, inheritance, class methods, protocols, enums, constants). Per-language X.5 steps add real Foundation/AppKit golden sets later.
- **Dylib symlink required for Racket runtime:** `swift-helpers.rkt` looks for the dylib at `../lib/libAPIAnywareRacket` relative to `runtime/`. A symlink from `generation/targets/racket/lib/libAPIAnywareRacket.dylib` → the Swift build output makes this work without copying.
- **Racket `with-autorelease-pool` forbids `define`:** The macro expands to `begin0` which doesn't support internal definitions. Use `let`/`let*` for bindings inside the pool scope.
- **Racket FFI round-trip verified end-to-end:** All 16 Swift dylib exports successfully callable from Racket — class/selector lookup, string conversion (ASCII + Unicode), autorelease pool, retain/release, GC prevention, block creation, delegate registration. 39 Racket-side tests cover the full FFI surface.
- **Generated runtime paths must account for `generated/{style}/` directory:** The output structure `generation/targets/{lang}/generated/{style}/{framework}/` is 3 levels deep from the language root where `runtime/` lives. Class files need `../../../runtime/`, protocol files need `../../../../runtime/`. The POC had a flatter structure without `generated/{style}/`.
- **Swift-style selectors must be filtered from Racket emission:** Selectors like `init(string:)` contain parentheses which are invalid in Racket identifiers and `tell` macro message names. These are Swift-only methods stored with their Swift name by `swift_name_to_selector` — they can't be called via `objc_msgSend`. The ObjC equivalents (e.g., `initWithString:`) are already present from ObjC extraction. Fixed by filtering `method.selector.contains('(')` in `is_supported_method`.
- **`coerce-arg` must cast to `_id` for `tell` compatibility:** Racket's `tell` macro requires `_id`-tagged pointers, not raw `_pointer`. When `coerce-arg` extracts from `objc-object`, it must `(cast ptr _pointer _id)` rather than returning the raw cpointer. Without this cast, `tell` fails with "argument is not `id` pointer".
- **TypedMsgSend methods take raw pointers, not objc-objects:** Generated methods using the `_msg-N` typed dispatch (rather than `tell`) pass parameters directly to `objc_msgSend`. Callers must pass raw `_id`/`_pointer` values for id-type params, not wrapped `objc-object` structs. The `coerce-arg` function handles self, but additional id params in TypedMsgSend methods are passed raw.
- **Foundation golden subset uses 18 curated files:** Rather than checking in all 312 Foundation files, the snapshot test compares a curated subset (nsobject, nsstring, nsarray, nsdata, nsurl, nsnotificationcenter, nserror, nsfilemanager, nsuserdefaults, nsdateformatter, nslock, nstimer, main, constants, enums, protocols/nscopying, protocols/nscoding, protocols/nslocking). Added `assert_subset_matches` to `GoldenTest` to support this pattern.
