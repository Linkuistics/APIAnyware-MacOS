# APIAnyware-MacOS Implementation Plan

Build a three-phase pipeline (Collection → Analysis → Generation) for extracting, analyzing, and generating language bindings for macOS platform APIs.

Full spec: `docs/specs/2026-03-26-macos-workspace-design.md`
POC project: `../APIAnyware/` (harvest code from here)

## Session Continuation Prompt

```
You MUST first read `LLM_CONTEXT/index.md` and `LLM_CONTEXT/coding-style.md`.

Then continue working on the task outlined in `LLM_STATE/plan.md`.
Review the file to see current progress, then continue from the next incomplete step.

Design spec: `docs/specs/2026-03-26-macos-workspace-design.md`
POC to harvest from: `../APIAnyware/`

After completing each step, update this plan file with:
1. Mark the step as complete [x]
2. Add any learnings discovered

Use Mermaid for all diagrams — never ASCII art.
```

## Progress

### Milestone 1: Shared Types

Define the IR types, annotation schema, provenance, and checkpoint file format.

- [ ] 1.1 Define core IR types in `collection/crates/types/`
  - [ ] Harvest `Framework`, `Class`, `Method`, `Property`, `Protocol`, `Enum`, `Struct`, `Function`, `Constant`, `TypeRef` from POC `crates/core/src/ir.rs`
  - [ ] Add `SourceProvenance` struct (header path, line, SDK version, availability)
  - [ ] Add `DocRefs` struct (header comment, Apple doc URL, USR)
  - [ ] Add `source` field to Method/Property (`objc_header` vs `swift_interface`)
  - [ ] Add `format_version` and `checkpoint` fields to Framework
  - [ ] Null-safe deserialization for Go-style null arrays
  - [ ] Write tests: deserialize POC's Level 1 IR JSON successfully
- [ ] 1.2 Define annotation schema in `collection/crates/types/`
  - [ ] Harvest `MethodAnnotation`, `BlockInvocationStyle`, `OwnershipKind`, `ThreadingConstraint`, `ErrorPattern`, `AnnotationSource` from POC `crates/annotate/src/schema.rs`
  - [ ] Add `AnnotationOverrides` and `AnnotationOverride` types
  - [ ] Write tests: round-trip annotation JSON
- [ ] 1.3 Verify workspace builds and all crates resolve types
  - [ ] `cargo check --workspace` passes
  - [ ] `cargo test --workspace` passes

### Milestone 2: ObjC/C Collection

Extract API metadata from macOS SDK headers using libclang.

- [ ] 2.1 Set up libclang integration
  - [ ] Add `clang` crate dependency to `collection/crates/extract/`
  - [ ] Implement SDK discovery via `xcrun --show-sdk-path`
  - [ ] Implement framework discovery: scan `{SDK}/System/Library/Frameworks/`
  - [ ] Write test: discover Foundation framework from SDK
- [ ] 2.2 Implement ObjC header parsing
  - [ ] Parse umbrella headers with libclang (`-x objective-c` + SDK flags)
  - [ ] Extract classes: name, superclass, protocols
  - [ ] Extract methods: selector, params, return type, class_method, init_method
  - [ ] Extract properties: name, type, readonly, class_property
  - [ ] Extract protocols: name, inherits, required/optional methods
  - [ ] Extract enums: name, type, values
  - [ ] Extract structs: name, fields
  - [ ] Extract functions: name, params, return type
  - [ ] Extract constants: name, type
- [ ] 2.3 Capture provenance and documentation
  - [ ] Source location: header file path, line number from libclang cursor
  - [ ] SDK version from `xcrun --show-sdk-version`
  - [ ] Availability attributes from libclang (`API_AVAILABLE`, `NS_DEPRECATED`)
  - [ ] Header doc comments from libclang (`clang_Cursor_getBriefCommentText`)
  - [ ] USR from libclang (`clang_getCursorUSR`)
  - [ ] Apple doc URL construction from USR
- [ ] 2.4 Implement TypeRef mapping
  - [ ] Map libclang types to `TypeRef` variants (id, instancetype, class, block, pointer, primitive, struct, alias, selector)
  - [ ] Handle nullability annotations (`_Nullable`, `_Nonnull`)
  - [ ] Handle block types with full parameter resolution
  - [ ] Handle typedef aliases
- [ ] 2.5 Wire up CLI
  - [ ] `apianyware-macos-collect` discovers and extracts all frameworks
  - [ ] `--only` flag for specific frameworks
  - [ ] `--list` flag to show available frameworks
  - [ ] Write to `collection/ir/collected/{Framework}.json`
- [ ] 2.6 Validate against POC output
  - [ ] Compare Rust-extracted Foundation against POC's `ir/level0/Foundation.json`
  - [ ] Spot-check: NSString class count, method count, property count
  - [ ] Spot-check: TypeRef resolution for block params, nullable types
  - [ ] Document any differences (Rust extraction should be a superset with provenance)

### Review 2
- [ ] 2.R Review Collection
  - [ ] All SDK frameworks discoverable and extractable
  - [ ] Provenance and doc_refs populated for all declarations
  - [ ] TypeRef mapping handles all ObjC type patterns
  - [ ] Output JSON is deterministic and diffable

### Milestone 3: Swift Collection

Extract Swift-only API metadata via swift-api-digester.

- [ ] 3.1 Implement swift-api-digester integration
  - [ ] Locate via `xcrun --find swift-api-digester`
  - [ ] Invoke `swift-api-digester -dump-sdk -module {Framework} -sdk {SDK}`
  - [ ] Parse `ABIRoot` JSON tree
- [ ] 3.2 Map Swift declarations to IR types
  - [ ] Swift classes/structs → IR Class/Struct
  - [ ] Swift methods → IR Method with `source: "swift_interface"`
  - [ ] Swift properties → IR Property
  - [ ] Swift enums → IR Enum
  - [ ] Swift protocols → IR Protocol
  - [ ] Availability attributes from Swift interface
- [ ] 3.3 Merge ObjC and Swift declarations
  - [ ] For frameworks with both ObjC headers and Swift modules, merge into single output
  - [ ] Swift extensions on ObjC classes: add methods with `source: "swift_interface"`
  - [ ] Detect and handle Swift overlays (Swift-specific API on top of ObjC frameworks)
- [ ] 3.4 Update CLI
  - [ ] `apianyware-macos-collect` runs both extractors
  - [ ] Single `ir/collected/{Framework}.json` per framework with merged output

### Review 3
- [ ] 3.R Review Swift Collection
  - [ ] Swift-only frameworks (Observation, SwiftData) produce valid IR
  - [ ] ObjC frameworks with Swift overlays merge correctly
  - [ ] `source` field correctly distinguishes ObjC vs Swift declarations

### Milestone 4: Datalog Resolution

Implement Datalog pass 1: inheritance flattening, ownership detection, protocol conformance.

- [ ] 4.1 Set up shared Datalog infrastructure in `analysis/crates/datalog/`
  - [ ] Harvest base relation types from POC `crates/core/src/datalog.rs`
  - [ ] Implement fact loader: read `ir/collected/{Framework}.json` → Datalog relations
  - [ ] Handle cross-framework dependencies (load all frameworks before running)
- [ ] 4.2 Implement resolution rules in `analysis/crates/resolve/`
  - [ ] Harvest `ancestor`, `effective_method`, `effective_property`, `returns_retained_method`, `satisfies_protocol_method` rules from POC
  - [ ] Write checkpoint: `analysis/ir/resolved/{Framework}.json`
- [ ] 4.3 Validate against POC
  - [ ] Foundation: effective method counts match POC
  - [ ] AppKit: NSWindow effective methods match
  - [ ] Returns retained: same methods detected
- [ ] 4.4 Wire up CLI
  - [ ] `apianyware-macos-analyze resolve` processes all collected frameworks
  - [ ] Auto-discovers `collection/ir/collected/*.json`

### Milestone 5: Annotation

Implement heuristic classification and LLM annotation merge.

- [ ] 5.1 Harvest heuristics from POC
  - [ ] `heuristics.rs` → `analysis/crates/annotate/src/heuristics.rs`
  - [ ] `validate.rs` → `analysis/crates/annotate/src/validate.rs`
  - [ ] Adapt for new types crate
- [ ] 5.2 Implement annotation merge
  - [ ] Read `analysis/ir/resolved/{Framework}.json`
  - [ ] Run heuristics on all methods
  - [ ] Merge with existing LLM annotations from `analysis/ir/annotated/{Framework}.json`
  - [ ] Write merged output to `analysis/ir/annotated/{Framework}.json`
- [ ] 5.3 Set up LLM annotation infrastructure
  - [ ] Create `analysis/scripts/prompt-template.md`
  - [ ] Create `analysis/scripts/llm-annotate.sh` (provider-agnostic)
  - [ ] Create `analysis/scripts/config.example.toml`
  - [ ] Verify `/analyze` Claude Code command works
- [ ] 5.4 Wire up CLI
  - [ ] `apianyware-macos-analyze annotate` processes all resolved frameworks
  - [ ] Auto-discovers `analysis/ir/resolved/*.json`

### Milestone 6: Enrichment

Implement Datalog pass 2: annotation-derived relations and verification.

- [ ] 6.1 Implement enrichment rules in `analysis/crates/enrich/`
  - [ ] Load type facts + annotation facts
  - [ ] Derive: `sync_block_method`, `async_block_method`, `stored_block_method`
  - [ ] Derive: `delegate_protocol`, `convenience_error_method`
  - [ ] Derive: `collection_iterable`, `scoped_resource`
  - [ ] Derive: `main_thread_class`
- [ ] 6.2 Implement verification rules
  - [ ] `violation_unwrapped` — every id-returning method is wrapped
  - [ ] `violation_flag_mismatch` — retained flag matches ownership family
  - [ ] `violation_unclassified_block` — every block param classified
  - [ ] Write verification report alongside enriched checkpoint
- [ ] 6.3 Wire up CLI
  - [ ] `apianyware-macos-analyze enrich` processes all annotated frameworks
  - [ ] `apianyware-macos-analyze` runs full pipeline: resolve → annotate → enrich
  - [ ] Auto-discovers input files at each step
- [ ] 6.4 Validate enrichment
  - [ ] Foundation + AppKit: zero verification violations
  - [ ] Enrichment relations are populated and sensible
  - [ ] Enriched checkpoint is self-contained (Generation can read only this file)

### Review 6
- [ ] 6.R Review Analysis Pipeline
  - [ ] Full pipeline: collect → resolve → annotate → enrich runs end-to-end
  - [ ] All checkpoints are valid JSON matching the spec
  - [ ] Verification passes for all frameworks
  - [ ] Memory architecture doc is complete and accurate
  - [ ] Annotation workflow doc is complete

### Milestone 7: Generation (Deferred)

Port emitters and runtime from POC. Not started until Milestones 1-6 are complete.

- [ ] 7.1 Port shared emitter framework
- [ ] 7.2 Port Racket emitter (reads enriched checkpoint)
- [ ] 7.3 Port Swift helper dylibs
- [ ] 7.4 Port Racket runtime
- [ ] 7.5 Add Chez Scheme emitter + runtime
- [ ] 7.6 Add Gerbil Scheme emitter + runtime
- [ ] 7.7 Documentation with cross-references to Apple docs

## Learnings

(Updated as work progresses)
