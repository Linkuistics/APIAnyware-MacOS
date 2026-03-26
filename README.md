# APIAnyware-MacOS

Idiomatic macOS API bindings for every language.

Extracts, analyzes, and generates native bindings for the full macOS platform API surface (ObjC, C, Swift) — targeting a broad set of languages: Racket, Chez Scheme, Gerbil Scheme, Common Lisp (SBCL, CCL), Haskell, Idris2, OCaml, Prolog, Mercury, Rhombus, Pharo Smalltalk, Zig, and others.

Part of the [APIAnyware](https://linkuistics.com) family — see also `APIAnyware-Windows` and `APIAnyware-Linux` (planned).

## Goals

- **Idiomatic, not mechanical.** Each target language gets bindings that feel native — not a lowest-common-denominator C wrapper. A Haskell user gets monadic error handling; a Smalltalk user gets message-passing objects; an OCaml user gets modules and variants.
- **Multiple binding styles per language.** Languages with both OO and functional idioms (e.g., Common Lisp, OCaml, Racket) can produce both an object-oriented API and a functional/procedural API from the same enriched IR.
- **Full API coverage.** Every framework in the macOS SDK, not just Foundation and AppKit. Both ObjC and Swift-only APIs.
- **API pattern recognition.** Many APIs implement stereotypical patterns — builder sequences, open/use/close lifecycles, observer registration/removal pairs, begin/commit transactions. The analysis phase recognizes these cross-method behavioral contracts and encodes them in the IR, enabling emitters to produce idiomatic wrappers like `with-path` (Lisp/Scheme), `withCGContext` (Haskell), or RAII guards (Zig) automatically.
- **Auto-generated with human-quality results.** The enriched IR carries enough semantic information (ownership, threading, block lifecycle, error patterns, API usage patterns) for emitters to make intelligent wrapping decisions without per-method human intervention.

## Architecture

Three-phase pipeline, each communicating via JSON checkpoint files:

```
Collection ──► Analysis ──► Generation
```

**Collection** parses macOS SDK headers (libclang) and Swift modules (swift-api-digester) to produce raw API metadata with full provenance and documentation references.

**Analysis** resolves inheritance via Datalog, adds semantic annotations (block invocation style, parameter ownership, threading constraints, error patterns, API usage patterns) via heuristics and LLM analysis, then enriches with Datalog-derived relations for generation. API pattern recognition identifies stereotypical multi-method contracts (builder sequences, resource lifecycles, observer pairs) by analyzing Apple's guides and tutorials in addition to API reference documentation.

**Generation** emits per-language bindings with runtime support libraries and Swift helper dylibs. Each emitter reads the same enriched IR but produces output shaped to the target language's idioms and conventions.

## Pipeline & Checkpoints

Each phase reads the previous checkpoint and writes the next. Intermediate checkpoints allow re-running expensive steps (especially LLM annotation) independently.

| Checkpoint | Location | Produced by | Contains |
|---|---|---|---|
| Collected | `collection/ir/collected/` | `apianyware-macos-collect` | Raw declarations, provenance, doc refs |
| Resolved | `analysis/ir/resolved/` | `apianyware-macos-analyze resolve` | + inheritance, effective methods, ownership |
| Annotated | `analysis/ir/annotated/` | `apianyware-macos-analyze annotate` + LLM | + block/threading/ownership/pattern annotations |
| Enriched | `analysis/ir/enriched/` | `apianyware-macos-analyze enrich` | + derived relations, pattern instances, verification |
| Generated | `generation/targets/{lang}/generated/` | `apianyware-macos-generate` | Per-language, per-style bindings |

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

### Generate language bindings

```sh
cargo run -p apianyware-macos-generate
```

Generates bindings for all registered languages and all binding styles from the enriched IR. To generate for a specific language:

```sh
cargo run -p apianyware-macos-generate -- --lang racket
cargo run -p apianyware-macos-generate -- --list-languages    # show available emitters
```

Output goes to `generation/targets/{lang}/generated/{style}/`.

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
      extract-objc/   # apianyware-macos-extract-objc — libclang ObjC/C parsing
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

  generation/
    crates/
      emit/           # apianyware-macos-emit          — shared emitter framework
      emit-racket/    # apianyware-macos-emit-racket   — Racket emitter (OO + functional)
      cli/            # apianyware-macos-generate       — generation CLI
    targets/          # runtime support + generated output per language

  swift/              # Swift helper dylibs (C-callable ObjC runtime interface)
```

### Target Languages

| Language | Style(s) | Status |
|---|---|---|
| Racket | OO (classes) + functional | Emitter + runtime ported |
| Chez Scheme | Functional | Planned |
| Gerbil Scheme | OO + functional | Planned |
| Common Lisp (SBCL, CCL) | CLOS + functional | Planned |
| Haskell | Monadic + lens-based | Planned |
| Idris2 | Dependently-typed wrappers | Planned |
| OCaml | Modules + OO | Planned |
| Prolog / Mercury | Relational | Planned |
| Rhombus | OO (classes) | Planned |
| Pharo Smalltalk | Message-passing OO | Planned |
| Zig | Low-level procedural | Planned |

Languages with both OO and functional paradigms produce multiple binding styles from the same enriched IR — for example, Common Lisp gets both CLOS wrappers and a `defun`-based procedural API.

## Documentation

- [Design Spec](docs/specs/2026-03-26-macos-workspace-design.md) — full architecture and checkpoint format
- [Memory Architecture](analysis/docs/memory-architecture.md) — ObjC/Swift ownership model, block/delegate lifecycles, GC prevention, verification rules
- [Annotation Workflow](analysis/docs/annotation-workflow.md) — when and how to run each pipeline step, LLM annotation options, merge precedence
- [Enrichment Rules](analysis/docs/enrich-rules.md) — what each Datalog-derived relation means and how emitters use it
- [API Pattern Catalog](analysis/docs/api-pattern-catalog.md) — 10 stereotypical API patterns with detection rules and per-language translation templates

## License

MIT
