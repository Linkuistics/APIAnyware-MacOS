# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Currently supports ObjC class extraction; needs extension to C
functions, enums, constants, and callback types.

## Session Continuation Prompt

```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: Core Pipeline

Read `LLM_STATE/core/plan.md`.

Key commands:
- `cargo test --workspace` — run all tests
- `cargo test -p apianyware-macos-types` — types crate tests
- `cargo test -p apianyware-macos-extract-objc` — ObjC extractor tests
- `cargo clippy --workspace` — lint
- `cargo +nightly fmt` — format

Constraints:
- TDD: write tests first
- `thiserror` for library errors, `anyhow` for CLI
- No `unwrap`/`expect` in production code
- See `LLM_CONTEXT/coding-style.md` for full conventions
```

## Task Backlog

### C function extraction `[collection]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Extend the collector to extract C functions from framework headers.
  Currently only ObjC classes/protocols/enums are extracted. Real apps (e.g.,
  Modaliser-Racket) need C functions like CGEventTapCreate, CFRunLoopAddSource,
  AXIsProcessTrusted, CFDictionaryCreate. The extractor uses libclang, which already
  parses C declarations — they're just not being collected.
- **Results:** _pending_

### C enum and constant extraction `[collection]`
- **Status:** not_started
- **Dependencies:** may share infrastructure with C function extraction
- **Description:** Extract C enums, bit flag constants, and opaque pointer constants
  (e.g., kCFRunLoopCommonModes, kAXTrustedCheckOptionPrompt, kCFBooleanTrue).
  These are `extern const` globals and `#define` constants, distinct from ObjC enums
  which are already extracted.
- **Results:** _pending_

### C callback type extraction `[collection]`
- **Status:** not_started
- **Dependencies:** C function extraction (callbacks appear as function parameter types)
- **Description:** Extract function pointer typedefs like CGEventTapCallBack. These
  define the signature for C callbacks that must be wrapped in each target language
  (e.g., Racket's `_cprocedure` + `function-ptr`).
- **Results:** _pending_

### App bundler for all language targets `[tooling]`
- **Status:** not_started
- **Dependencies:** at least one language target with a working app (racket-oo qualifies)
- **Description:** Create a cross-target app bundler that produces proper macOS `.app`
  bundles from apps written in any APIAnyware-supported language. The goal: apps built
  with APIAnyware bindings should produce `.app` bundles indistinguishable from native
  Swift apps — real Mach-O binaries, proper entitlements, icons, bundle IDs, usage
  descriptions, and code signing. Each language target needs a target-specific binary
  strategy (e.g., Racket uses `raco exe --gui --launcher` for a GRacket launcher binary;
  Python might use `py2app`; etc.) but the surrounding bundle structure (Info.plist,
  .icns generation, code signing, entitlements) is shared infrastructure. Reference
  implementation: `../Modaliser-Racket/bundle/build.sh`. Key learning from Racket:
  `raco exe` without `--launcher` fails with module instantiation errors for FFI-heavy
  binding code; the launcher mode avoids this by loading at runtime.
- **Results:** _pending_

### LLM annotation integration `[analysis]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** The LLM annotation step currently requires external shell scripts
  and manual invocation. Make it a proper pipeline step in the Rust CLI
  (`apianyware-macos-analyze annotate`). Must run within Claude Code sessions using
  subagents per framework for economic reasons (not external API calls).
- **Results:** _pending_

### Test coverage hardening `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Comprehensive testing across the entire pipeline (collection,
  resolution, annotation, enrichment, generation). Running all 283 frameworks exposed
  a real enrichment bug (global totals written to every framework). More comprehensive
  testing will catch similar issues before they compound across language targets.
- **Results:** _pending_

## Session Log

### 2026-04-11: Enrichment verification fix
- Bug: `build_verification_report()` didn't filter violations by framework — every
  framework got all violations from all frameworks when enriched together
- Root cause: `build_enrichment_data()` already computed `framework_classes` and filtered
  correctly, but `build_verification_report()` was never given the class set
- Fix: lifted `framework_classes` computation to `build_enriched_framework()`, passed to
  both `build_enrichment_data()` and `build_verification_report()`
- 2 new tests: violation isolation and enrichment data isolation across frameworks

### 2026-04-11: Framework ignore list
- Added `IGNORED_FRAMEWORKS` constant in `sdk.rs` with DriverKit and Tk
- `is_framework_ignored()` public helper for callers that need to check
- Filtering built into `discover_frameworks()` — all consumers benefit automatically
- 3 integration tests: exclusion from results, list non-empty guard, helper consistency

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
