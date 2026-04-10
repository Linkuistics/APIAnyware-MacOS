# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

APIAnyware-MacOS is a three-phase pipeline that extracts macOS platform API metadata, semantically analyzes it, and generates idiomatic language bindings for non-mainstream languages (Racket, Chez Scheme, Haskell, etc.). It produces complete, usable bindings — not thin C wrappers.

## How This Project Is Organised

This is a matrix project: N targets x M apps, with shared pipeline and testing infrastructure.

**Before doing any implementation work**, read `LLM_CONTEXT/project-workflow.md` — it explains
the full workflow and knowledge system.

**Key directories:**
- `knowledge/` — all learnings, app specs, testing strategies, organised by axis
- `generation/targets/{target}/` — one per language+paradigm combination
- `LLM_STATE/` — plans and status tracking
- `LLM_CONTEXT/` — project-wide instructions and coding standards

**Plans (backlog format — see `../LLM_CONTEXT/backlog-plan.md`):**
- `LLM_STATE/overview.md` — at-a-glance status dashboard
- `LLM_STATE/core/plan.md` — core pipeline backlog
- `LLM_STATE/targets/{target}/plan.md` — per-target backlogs

To start a session, copy the continuation prompt from the relevant plan file.

## Build & Test Commands

```bash
# Rust workspace
cargo build                          # Build all crates
cargo test --workspace               # Run all tests (~248 tests)
cargo test -p apianyware-macos-emit-racket-oo  # Single crate
cargo +nightly fmt                   # Format (requires nightly)
cargo clippy --workspace             # Lint

# Swift dylibs (from repo root)
cd swift && swift build              # Build all dylibs
cd swift && swift test               # Run Swift tests (~64 tests)

# Pipeline CLIs
cargo run --bin apianyware-macos-collect -- --only Foundation
cargo run --bin apianyware-macos-analyze                        # Full: resolve → annotate → enrich
cargo run --bin apianyware-macos-analyze -- resolve --only Foundation
cargo run --bin apianyware-macos-generate -- --lang racket-oo
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
collection/ir/collected/      analysis/ir/{resolved,          generation/targets/{target}/
  {Framework}.json              annotated,enriched}/            generated/{style}/
                                {Framework}.json                  {framework}/*.rkt
```

Where `{target}` is a language+paradigm combo like `racket-oo`.

### Crate Map

**Shared types** — `collection/crates/types/` (`apianyware-macos-types`): IR structs (Framework, Class, Method, Property, Protocol, Enum, TypeRef), annotation schema, checkpoint format. Depended on by everything.

**Collection** — `collection/crates/extract-objc/` (libclang parsing), `extract-swift/` (swift-api-digester), `cli/` (orchestration). The ObjC extractor's `type_mapping.rs` resolves typedefs to canonical types at extraction time — this is critical for correct FFI signatures downstream.

**Analysis** — `analysis/crates/datalog/` (shared Ascent-based relations), `resolve/` (inheritance flattening, ownership detection), `annotate/` (heuristic + LLM annotation merge), `enrich/` (derived relations, verification), `cli/`.

**Generation** — `generation/crates/emit/` (shared framework: `FfiTypeMapper` trait, `CodeWriter`, naming utils, snapshot testing, pattern dispatch), `emit-racket-oo/` (Racket OO emission), `cli/` (emitter registry, orchestration).

**Swift dylibs** — `swift/` contains `APIAnywareCommon` (C-callable ObjC runtime: message sending, memory management, struct marshaling) and per-language bridges (`APIAnywareRacket` adds block/delegate bridging with GC prevention).

### Key Patterns

- **`effective_methods()`/`effective_properties()`** in emitters: choose between direct and inherited method lists, with deduplication by selector/name.
- **`DispatchStrategy`** in emit-racket-oo: methods dispatch via either `tell` (Racket's ObjC FFI macro) or typed `_msg-N` bindings depending on parameter/return types.
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

Plans use the backlog format described in `../LLM_CONTEXT/backlog-plan.md`. Each session
starts by triaging the task backlog and picking the best next task.

- `LLM_STATE/overview.md` — status dashboard
- `LLM_STATE/core/plan.md` — core pipeline (collection, analysis, enrichment)
- `LLM_STATE/targets/{target}/plan.md` — per-target plans

Core and target plans are independent. Copy the continuation prompt from a plan file to
start a session.

## Language Targets

Each target gets: an emitter crate, a runtime library, generated bindings, sample apps, and snapshot tests. See `LLM_STATE/new-language-guide.md` for the 11-step checklist and `LLM_STATE/targets/template.md` for the plan template.

Generated output lands at `generation/targets/{target}/generated/{style}/{framework}/`. Runtimes at `generation/targets/{target}/runtime/`. Sample apps at `generation/targets/{target}/apps/`.

## GUI Testing with TestAnyware

Sample apps are tested in a macOS VM via `../TestAnyware/`. Never run GUI apps directly from the CLI — always use TestAnyware for visual verification. Use the release build: `../TestAnyware/.build/release/testanyware`.

Key workflow:
```bash
../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket-oo:racket-oo
../TestAnyware/.build/release/testanyware exec "brew install minimal-racket"
# Copy files to VM local storage (VirtioFS can serve stale content):
# base64-encode on host, decode in VM via testanyware exec
../TestAnyware/.build/release/testanyware exec "pkill -9 -f racket"  # Always kill before relaunch
../TestAnyware/.build/release/testanyware vm stop
```

Workflow docs at `knowledge/testanyware/general.md`. App specs at `knowledge/apps/{app}/spec.md`, validation checklists at `knowledge/apps/{app}/test-strategy.md`.
