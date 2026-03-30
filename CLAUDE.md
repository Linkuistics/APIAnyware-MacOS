# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

APIAnyware-MacOS is a three-phase pipeline that extracts macOS platform API metadata, semantically analyzes it, and generates idiomatic language bindings for non-mainstream languages (Racket, Chez Scheme, Haskell, etc.). It produces complete, usable bindings — not thin C wrappers.

## Build & Test Commands

```bash
# Rust workspace
cargo build                          # Build all crates
cargo test --workspace               # Run all tests (~248 tests)
cargo test -p apianyware-macos-emit-racket  # Single crate
cargo +nightly fmt                   # Format (requires nightly)
cargo clippy --workspace             # Lint

# Swift dylibs (from repo root)
cd swift && swift build              # Build all dylibs
cd swift && swift test               # Run Swift tests (~64 tests)

# Pipeline CLIs
cargo run --bin apianyware-macos-collect -- --only Foundation
cargo run --bin apianyware-macos-analyze                        # Full: resolve → annotate → enrich
cargo run --bin apianyware-macos-analyze -- resolve --only Foundation
cargo run --bin apianyware-macos-generate -- --lang racket
cargo run --bin apianyware-macos-generate -- --list-languages

# Snapshot tests: update golden files after emitter changes
UPDATE_GOLDEN=1 cargo test --workspace
```

## Architecture

Three-phase checkpoint pipeline. Each phase reads JSON, transforms it, writes JSON:

```
Collection                    Analysis                        Generation
(macOS SDK → IR)             (IR → enriched IR)              (enriched IR → code)

apianyware-macos-collect      apianyware-macos-analyze         apianyware-macos-generate
        │                     resolve → annotate → enrich              │
        ▼                              ▼                               ▼
collection/ir/collected/      analysis/ir/{resolved,          generation/targets/{lang}/
  {Framework}.json              annotated,enriched}/            generated/{style}/
                                {Framework}.json                  {framework}/*.rkt
```

### Crate Map

**Shared types** — `collection/crates/types/` (`apianyware-macos-types`): IR structs (Framework, Class, Method, Property, Protocol, Enum, TypeRef), annotation schema, checkpoint format. Depended on by everything.

**Collection** — `collection/crates/extract-objc/` (libclang parsing), `extract-swift/` (swift-api-digester), `cli/` (orchestration). The ObjC extractor's `type_mapping.rs` resolves typedefs to canonical types at extraction time — this is critical for correct FFI signatures downstream.

**Analysis** — `analysis/crates/datalog/` (shared Ascent-based relations), `resolve/` (inheritance flattening, ownership detection), `annotate/` (heuristic + LLM annotation merge), `enrich/` (derived relations, verification), `cli/`.

**Generation** — `generation/crates/emit/` (shared framework: `FfiTypeMapper` trait, `CodeWriter`, naming utils, snapshot testing, pattern dispatch), `emit-racket/` (Racket-specific emission), `cli/` (emitter registry, orchestration).

**Swift dylibs** — `swift/` contains `APIAnywareCommon` (C-callable ObjC runtime: message sending, memory management, struct marshaling) and per-language bridges (`APIAnywareRacket` adds block/delegate bridging with GC prevention).

### Key Patterns

- **`effective_methods()`/`effective_properties()`** in emitters: choose between direct and inherited method lists, with deduplication by selector/name.
- **`DispatchStrategy`** in emit-racket: methods dispatch via either `tell` (Racket's ObjC FFI macro) or typed `_msg-N` bindings depending on parameter/return types.
- **`coerce-arg`** in Racket runtime: auto-converts strings→NSString, objc-object→_id pointer. All generated property setters use it.
- **Snapshot tests**: golden files at `emit-{lang}/tests/golden/{style}/`. `GoldenTest::assert_matches()` does directory comparison with unified diffs. `assert_subset_matches()` checks only files present in the golden dir.
- **`test_fixtures::build_snapshot_test_framework()`**: deterministic synthetic `TestKit` framework exercising all emitter code paths.

## Coding Conventions

Read `LLM_CONTEXT/coding-style.md` before writing or refactoring code. Key points:

- **TDD** — write tests first
- **Descriptive names** — long is fine; consistency matters (don't mix `get_thing`/`fetch_thing`)
- **Small files** — each file handles one concern
- **`thiserror`** for library errors, **`anyhow`** for CLI/application errors
- **`tracing`** macros only (not `log` crate)
- **Bounded channels only** — `unbounded_channel` is banned
- **No `unwrap`/`expect`** in production code
- **Import grouping**: stdlib → external → local (enforced by rustfmt)
- **`cargo +nightly fmt`** before committing

## Plan & Progress Tracking

`LLM_STATE/plan.md` tracks overall progress across all milestones. Language-specific sub-plans live at `LLM_STATE/plan-{lang}.md`. After completing each step, update the plan: mark `[x]`, add learnings.

The session continuation prompt at the top of `plan.md` should be used to resume work.

## Language Targets

Each language gets: an emitter crate, a runtime library, generated bindings, sample apps, and snapshot tests. See `LLM_STATE/new-language-guide.md` for the 11-step checklist and `LLM_STATE/plan-template.md` for the plan structure.

Generated output lands at `generation/targets/{lang}/generated/{style}/{framework}/`. Runtimes at `generation/targets/{lang}/runtime/`. Sample apps at `generation/targets/{lang}/apps/{style}/`.

## GUI Testing with TestAnyware

Sample apps are tested in a macOS VM via `../TestAnyware/`. Never run GUI apps directly from the CLI — always use TestAnyware for visual verification. Use the release build: `../TestAnyware/.build/release/testanyware`.

Key workflow:
```bash
../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket:racket
../TestAnyware/.build/release/testanyware exec "brew install minimal-racket"
# Copy files to VM local storage (VirtioFS can serve stale content):
# base64-encode on host, decode in VM via testanyware exec
../TestAnyware/.build/release/testanyware exec "pkill -9 -f racket"  # Always kill before relaunch
../TestAnyware/.build/release/testanyware vm stop
```

Specs at `generation/apps/specs/`, validation checklists at `generation/apps/tests/`, workflow doc at `generation/apps/testanyware-workflow.md`.
