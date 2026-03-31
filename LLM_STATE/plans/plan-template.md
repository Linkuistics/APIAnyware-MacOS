# Language Target Template

Parameterized workflow for implementing a language target. Each language milestone instantiates this template in `plans/{target}/plan.md`.

Design spec: `docs/specs/2026-03-27-plan-restructure-design.md`

## Header Fields

Every `plans/{target}/plan.md` starts with:

```
Language: {display name, e.g., "Haskell"}
Implementations: {runtime/compiler list, e.g., "GHC" or "SBCL, CCL"}
Binding styles: {list, e.g., "Monadic, Lens-based"}
Swift dylib: {e.g., "libAPIAnywareHaskell.dylib"}
Milestone: {number in main plan}
Emitter crate: {e.g., "emit-haskell"}
Runtime location: {e.g., "generation/targets/haskell/runtime/"}
```

## Steps

### X.1 Emitter crate

Create `generation/crates/emit-{lang}/` with:

- `Cargo.toml` — depends on `apianyware-macos-types` and `apianyware-macos-emit`
- `src/lib.rs` — module declarations
- `src/naming.rs` — target language naming conventions (from shared `naming` utilities)
- `src/method_filter.rs` — dispatch strategy, method support filtering
- `src/shared_signatures.rs` — FFI signature collection/deduplication (if applicable)
- `src/emit_class.rs` — class/type binding generation
- `src/emit_protocol.rs` — protocol/interface/typeclass generation
- `src/emit_enums.rs` — enum/constant generation
- `src/emit_constants.rs` — constant declarations
- `src/emit_framework.rs` — top-level framework orchestration, `LanguageInfo` constant
- `src/ffi_type_mapping.rs` — `FfiTypeMapper` implementation (if not in shared crate)

Adapt modules to the target language's idioms. Not all languages need all modules — e.g., a Haskell emitter may not need `shared_signatures.rs` if it uses a different FFI approach.

**Deliverables:**
- [ ] Crate compiles (`cargo check`)
- [ ] Unit tests pass (naming, method filtering, dispatch strategy, code generation)
- [ ] `cargo +nightly fmt` applied
- [ ] Added to workspace `Cargo.toml`

### X.2 Runtime library

Create `generation/targets/{lang}/runtime/` with target-language source files providing:

- **Object wrapping** — wrap ObjC pointers with release finalizers appropriate to the language's memory model
- **Memory management** — retain/release dispatch (Swift helpers or fallback)
- **Block bridging** — create ObjC blocks from the language's closure/lambda type
- **Delegate bridging** — create ObjC delegate instances from language callbacks
- **Type conversions** — string, array, dictionary conversions between language and Foundation types
- **Struct types** — NSPoint, NSSize, NSRect, NSRange definitions
- **Variadic helpers** — alternatives for ObjC variadic methods that can't be auto-generated
- **Swift helper loading** — conditional loading of `libAPIAnyware{Lang}.dylib`

The runtime must work both with and without the Swift dylib (graceful fallback).

**Deliverables:**
- [ ] All runtime source files written
- [ ] Runtime compiles/loads in the target language
- [ ] Basic manual test: load runtime, call a Swift helper function

### X.3 Swift dylib integration

Wire up the target language's Swift dylib (stub already exists from Milestone 7.2 for Scheme variants).

- Verify the dylib builds: `swift build` in `swift/`
- Verify FFI calls from the target language to all Common module functions
- Verify FFI calls to language-specific module functions (block bridging, delegate bridging, GC prevention)
- If a new dylib product is needed, add it to `swift/Package.swift`

**Deliverables:**
- [ ] Dylib builds successfully
- [ ] FFI round-trip test: call Swift helper from target language, verify result
- [ ] Block creation works through the dylib
- [ ] Delegate creation works through the dylib

### X.4 Generation CLI wiring

Register the emitter in `apianyware-macos-generate`:

- Add language to the `--lang` flag's accepted values
- Emitter reads enriched IR from `analysis/ir/enriched/`
- Generates all frameworks for all binding styles
- Writes output to `generation/targets/{lang}/generated/{style}/{framework}/`

**Deliverables:**
- [ ] `apianyware-macos-generate --lang {lang}` runs without errors
- [ ] Output directory structure is correct
- [ ] All enriched frameworks are generated
- [ ] Each binding style produces separate output

### X.5 Snapshot tests

Create golden-file regression tests:

- Generate Foundation and AppKit bindings
- Check in reference output as golden files
- Test compares fresh generation against golden files
- One golden set per binding style
- Integrated into `cargo test` for the emitter crate

**Deliverables:**
- [ ] Golden files checked in for Foundation + AppKit, per binding style
- [ ] `cargo test` detects regressions (intentionally break output, verify test fails)

### X.6 Language-side smoke tests

Non-GUI tests that run in the target language, verifying the generated bindings actually work:

- Import generated Foundation bindings
- Create an NSObject, call `description`, verify it returns a string
- Create an NSString from a native string, verify round-trip
- Create an NSArray from a native list, verify count
- Set and get properties on an object
- Call a method with primitive parameters and verify return value
- Create and invoke a block
- One test suite per binding style

**Deliverables:**
- [ ] Smoke tests pass for each binding style
- [ ] Tests cover: object creation, properties, methods, blocks, type conversions

### X.7 Sample apps — {Style 1}

Implement all 7 standard sample apps using the first binding style:

1. Hello Window
2. Counter
3. UI Controls Gallery
4. File Lister
5. Text Editor
6. Mini Browser
7. Menu Bar Tool

Each app must match the language-independent specification in `generation/apps/specs/`.

**Deliverables:**
- [ ] All 7 apps build and run
- [ ] Each app matches its specification
- [ ] Apps located at `generation/targets/{lang}/apps/{style1}/`

### X.8 Sample apps — {Style 2}

Same 7 apps in the second binding style. **Skipped (not renumbered) if language has only one binding style.**

The implementations should feel idiomatically different — not just syntactic variation of Style 1.

**Deliverables:**
- [ ] All 7 apps build and run
- [ ] Each app matches its specification
- [ ] Apps demonstrate genuinely different idioms from Style 1

### X.9 TestAnyware validation

LLM-driven GUI testing of each sample app:

1. Boot macOS VM with `testanyware vm start --share ./generation/targets/{lang}:apps`
2. Build each sample app in/for the VM
3. Launch app
4. LLM agent uses TestAnyware screenshot → think → act → verify loop
5. Autonomous exploration comparing behavior against spec
6. Issues found → fix bindings/runtime/app, re-test
7. Continue until app matches spec

This covers all binding styles. The validation steps in `generation/apps/tests/` define what to check, but the LLM agent may discover additional issues beyond the script.

**Deliverables:**
- [ ] All sample apps validated via TestAnyware
- [ ] All binding styles tested
- [ ] Known issues documented and resolved
- [ ] Screenshots archived as evidence

### X.10 Per-framework exercisers

Targeted tests for frameworks beyond AppKit/Foundation:

- CoreGraphics — drawing paths, colors, contexts
- AVFoundation — audio playback
- MapKit — map view with annotations
- WebKit — (covered by Mini Browser, but additional edge cases)
- Other frameworks as relevant

Not every framework needs a full app — focused exercisers that verify the bindings work for key APIs.

**Deliverables:**
- [ ] At least 3 non-AppKit/Foundation frameworks exercised
- [ ] Tests run successfully in target language

### X.11 Documentation placeholder

Record language-specific documentation requirements for The Great Explainer:

- Language-specific idioms and conventions that docs should follow
- Paradigm-appropriate explanation style (e.g., monadic Haskell docs should use `do` notation examples, not imperative pseudocode)
- Key concepts a user of this language would need explained
- Cross-references to Apple documentation that are most relevant
- Notes on what's unusual or surprising about the bindings for this language

**Deliverables:**
- [ ] `generation/targets/{lang}/docs/requirements.md` written
- [ ] Paradigm-specific notes for each binding style

## Review Gate

After X.9, conduct a review:

- [ ] All Rust emitter tests pass
- [ ] All snapshot tests pass
- [ ] All language-side smoke tests pass
- [ ] All sample apps build, run, and pass TestAnyware validation
- [ ] Per-framework exercisers pass
- [ ] Documentation requirements recorded
- [ ] No regressions in other workspace tests
