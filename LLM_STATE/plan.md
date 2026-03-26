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
- [ ] 2.R Review Collection (deferred to review session)
  - [ ] All SDK frameworks discoverable and extractable
  - [ ] Provenance and doc_refs populated for all declarations
  - [ ] TypeRef mapping handles all ObjC type patterns
  - [ ] Output JSON is deterministic and diffable

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

Build the shared emitter framework, port the Racket emitter from POC, then add emitters for all target languages. Each emitter produces idiomatic bindings — not thin C wrappers. Languages with multiple paradigms (OO + functional) get multiple binding styles from the same enriched IR. Not started until Milestones 1-6 are complete.

- [ ] 7.1 Port shared emitter framework (`emit` crate)
  - [ ] Common utilities: name mapping, type resolution, doc rendering, framework ordering
  - [ ] Binding style abstraction: OO vs functional vs procedural output from same IR
- [ ] 7.2 Port Swift helper dylibs (shared C-callable ObjC runtime interface)
- [ ] 7.3 Port Racket emitter + runtime (OO + functional styles)
- [ ] 7.4 Add Chez Scheme emitter + runtime (functional style)
- [ ] 7.5 Add Gerbil Scheme emitter + runtime (OO + functional styles)
- [ ] 7.6 Add Common Lisp emitter + runtime (CLOS + functional styles; SBCL and CCL)
- [ ] 7.7 Add Haskell emitter + runtime (monadic + lens-based)
- [ ] 7.8 Add Idris2 emitter + runtime (dependently-typed wrappers)
- [ ] 7.9 Add OCaml emitter + runtime (modules + OO styles)
- [ ] 7.10 Add Prolog/Mercury emitter + runtime (relational style)
- [ ] 7.11 Add Rhombus emitter + runtime (OO style)
- [ ] 7.12 Add Pharo Smalltalk emitter + runtime (message-passing OO)
- [ ] 7.13 Add Zig emitter + runtime (low-level procedural)
- [ ] 7.14 Generated documentation with cross-references to Apple docs

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
