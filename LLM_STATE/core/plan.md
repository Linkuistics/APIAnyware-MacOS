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

### Framework ignore list `[collection]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Explicitly mark inappropriate frameworks as ignored rather than
  silently failing. Known bad frameworks: DriverKit (C++ headers), Tk (Tcl/Tk, not
  native macOS). Running all 283 frameworks already exposed real bugs — this prevents
  known-bad frameworks from wasting processing time or producing confusing errors.
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

### Enrichment verification `[enrichment]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Add verification that enrichment results are per-framework, not
  global. The bug where global totals were written to every framework's enriched IR
  was caught by running all frameworks — add targeted tests to prevent regression.
- **Results:** _pending_

## Session Log

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
