# APIAnyware-MacOS

Extract, analyze, and generate language bindings for macOS platform APIs (ObjC, C, Swift).

Part of the [APIAnyware](https://linkuistics.com) family — see also `APIAnyware-Windows` and `APIAnyware-Linux` (planned).

## Architecture

Three-phase pipeline, each communicating via JSON checkpoint files:

```
Collection ──► Analysis ──► Generation
```

**Collection** parses macOS SDK headers (libclang) and Swift modules (swift-api-digester) to produce raw API metadata with full provenance and documentation references.

**Analysis** resolves inheritance via Datalog, adds semantic annotations (block invocation style, parameter ownership, threading constraints, error patterns) via heuristics and LLM analysis, then enriches with Datalog-derived relations for generation.

**Generation** emits per-language bindings (Racket, Chez Scheme, Gerbil Scheme) with runtime support libraries and Swift helper dylibs.

## Pipeline & Checkpoints

Each phase reads the previous checkpoint and writes the next. Intermediate checkpoints allow re-running expensive steps (especially LLM annotation) independently.

| Checkpoint | Location | Produced by | Contains |
|---|---|---|---|
| Collected | `collection/ir/collected/` | `apianyware-macos-collect` | Raw declarations, provenance, doc refs |
| Resolved | `analysis/ir/resolved/` | `apianyware-macos-analyze resolve` | + inheritance, effective methods, ownership |
| Annotated | `analysis/ir/annotated/` | `apianyware-macos-analyze annotate` + LLM | + block/threading/ownership annotations |
| Enriched | `analysis/ir/enriched/` | `apianyware-macos-analyze enrich` | + derived relations, verification |

## Quick Start

### Prerequisites

- Rust (see `.tool-versions`)
- Xcode (provides libclang and swift-api-digester)

### Collect API metadata from the SDK

```sh
cargo run -p apianyware-macos-collect
```

Discovers all frameworks in the macOS SDK and writes `collection/ir/collected/{Framework}.json`.

### Run the analysis pipeline

```sh
cargo run -p apianyware-macos-analyze
```

Runs resolve → annotate → enrich on all collected frameworks. Individual steps:

```sh
cargo run -p apianyware-macos-analyze -- resolve     # Datalog pass 1
cargo run -p apianyware-macos-analyze -- annotate    # heuristics + LLM merge
cargo run -p apianyware-macos-analyze -- enrich      # Datalog pass 2 + verification
```

### LLM annotation (Claude Code)

Open this project in Claude Code and run:

```
/analyze
```

This reads resolved IR, fetches Apple documentation, and produces semantic annotations. The annotations are checked into `analysis/ir/annotated/` and only need to be re-run when the SDK updates.

Alternatively, use any OpenAI-compatible API:

```sh
./analysis/scripts/llm-annotate.sh
```

## Workspace Structure

```
APIAnyware-MacOS/
  Cargo.toml                              # workspace root

  collection/
    crates/
      types/          # apianyware-macos-types      — shared IR + annotation schema
      extract/        # apianyware-macos-extract     — libclang ObjC/C parsing
      extract-swift/  # apianyware-macos-extract-swift — swift-api-digester
      cli/            # apianyware-macos-collect     — collection CLI
    ir/collected/                                    — checkpoint output

  analysis/
    crates/
      datalog/        # apianyware-macos-datalog     — shared Datalog types + loaders
      resolve/        # apianyware-macos-resolve     — Datalog pass 1
      annotate/       # apianyware-macos-annotate    — heuristics + LLM merge
      enrich/         # apianyware-macos-enrich      — Datalog pass 2 + verification
      cli/            # apianyware-macos-analyze     — analysis CLI
    ir/resolved/                                     — checkpoint
    ir/annotated/                                    — checkpoint (LLM annotations here)
    ir/enriched/                                     — checkpoint (Generation reads this)
    docs/                                            — memory model, workflow docs
    scripts/                                         — LLM annotation scripts

  generation/         # (deferred — emitters + runtimes)
  swift/              # (deferred — Swift helper dylibs)
```

## Documentation

- [Design Spec](docs/specs/2026-03-26-macos-workspace-design.md) — full architecture and checkpoint format
- `analysis/docs/memory-architecture.md` — ObjC/Swift memory model (planned)
- `analysis/docs/annotation-workflow.md` — when and how to run the pipeline (planned)

## License

MIT
