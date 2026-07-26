# plan-k1

**Kind:** planning

## Goal

Settle the headline design for **model-transform generation**: replace today's
direct *source-model → per-target-emitter → binding source* path with an explicit
three-stage path — *source model → declarative transform → target-API model →
template rendering → binding source + adapter + docs* — and grow the tree that
builds it.

The grove's charter is **investigation-first**: the deliverable of this planning
leaf is a settled architecture plus a tree whose early leaves *measure* the thesis
on a real target before any migration is committed to.

## Context

Beyond the brief chain and `CONTEXT.md`:

- `adr/0044-shared-emit-substrate-home-targets-shared.md` — where shared emission lives.
- `adr/0047-convention-heuristics-as-datalog-rules.md` — the precedent: 1,236 lines of
  imperative classifiers re-expressed as declarative `ascent` rules, with provenance
  falling out of the derivation trace. Also parks a runtime-loadable rule DSL as
  out of scope.
- `adr/0051-capability-profiles-and-derived-representability.md` + `CONTEXT.md`
  §"Target model (refactor workstream 6)" — the **existing** `target model`, which is a
  *capability/idiom/policy knowledge layer*, NOT a model of the generated API. Naming
  collision to resolve (see Q1 below).
- `adr/0046-spec-interchange-format-kdl-everywhere.md` — `.apiw` KDL is the interchange
  format for every authored artifact.
- `targets/_shared/docs/emitter-contract.md` — the per-emitter rediscovery catalogue.
- `targets/_shared/tools/emit/src/` — the 4,092-line shared substrate.

## Survey (facts established this session — not decisions)

Measured 2026-07-26 on this workspace (`mtnuttur`, sitting on `main` = TypeScript-target
commit `kxuplozo`).

**Where the mass is.** Per-target emit crates total **71,719 LOC** against **4,092 LOC**
of shared substrate:

| Target | `emit-<t>` LOC | `bundle-<t>` LOC |
|---|---|---|
| racket | 14,732 | 2,787 |
| chez | 8,186 | 1,767 |
| gerbil | 12,162 | 2,327 |
| sbcl | 11,152 | 1,190 |
| typescript | 25,487 | 1,504 |

Shared `targets/_shared/tools/emit/src/`: `ffi_type_mapping.rs` 1,070 ·
`test_fixtures.rs` 887 · `snapshot_testing.rs` 570 · `naming.rs` 400 ·
`pattern_dispatch.rs` 313 · `code_writer.rs` 211 · `doc_rendering.rs` 209 ·
`framework_ordering.rs` 181 · `enrichment.rs` 156 · `target_emitter.rs` 77 ·
`lib.rs` 18.

**Datalog is already in the repo, but only upstream of the IR.** `ascent 0.7`
(workspace dep) is used by `semantic/tools/{resolve,enrich,datalog}` and
`platforms/macos/tools/{conventions,pattern-detection}`. **No datalog anywhere
downstream of the IR** — the whole generation half is imperative Rust.

**No template engine in the workspace.** No `tera`/`askama`/`handlebars`/`minijinja`/
`liquid`/`mustache`. All emission is Rust string-building through `emit/code_writer.rs`.
Introducing templating is a new dependency decision, not a swap.

**The existing `pattern_dispatch` seam is the nucleus of the proposed architecture.**
`emit/pattern_dispatch::classify_pattern` already reads *authored `.apiw` data* (the
per-target idiom catalogue) and renders a closed `EmitConstruct` taxonomy + a generated
identifier — data-driven projection, already shipped and golden-neutral. `CONTEXT.md`
§ws6 explicitly parks the follow-on: "**Applying** projection — emitters consuming
pattern-instances to emit `with-bracket`/`make-foo` wrappers — moves goldens + needs
per-target VM-verify and is a clearly-scoped, golden-INTENTIONAL follow-on."

**Dependency direction to preserve.** `emit` depends on `target-model`, never the
reverse (§ws6 _Avoid_).

**Existing golden/snapshot coverage is uneven** — a constraint on any equivalence proof:
racket + gerbil + sbcl have real-IR snapshot goldens; **chez has no golden/snapshot
mechanism at all** (confirmed by `objc-object-type-lowering-golden-review-k107`, per
`TODO.md`). Emit-dependent tests skip-as-pass when the gitignored emitted tree is absent.

## Done when

- The naming collision with the existing `target model` is resolved and the new
  entity/entities are defined in `CONTEXT.md`.
- The transform mechanism, the rendering mechanism, and the artifact/derivation status of
  the target-API model are settled, each with an ADR where the when-to-write test holds.
- The equivalence-proof strategy against the existing 71.7k LOC of emitters is agreed.
- The tree is grown: `01-plan-k1` decomposed into a node whose ordered children
  sequence investigation before migration.

## Decisions (running log)

**Q1 — the transform produces an instance-level projected model.** Settled 2026-07-26.
One node per emitted thing (module / function / class / method / param), per
target×platform, expressed in a construct vocabulary that widens today's closed
`EmitConstruct` taxonomy from its 8 emit-relevant pattern kinds to the target language's
full construct repertoire. Consequences accepted: (i) templates *render only* — every
projection decision must already be resolved in the model before rendering begins, which
is what makes a template engine sufficient rather than a program; (ii) the natural golden
surface moves from emitted text to the projected model, so a diff shows the projected API
rather than 71.7k LOC of source; (iii) the construct vocabulary becomes a first-class,
much-widened artifact. Rejected: producing richer projection *decisions* while keeping
imperative emitters (smallest change, but rules out templating and keeps the 71.7k LOC);
and standing up a separately-authored per-target metamodel as a second new entity —
deferred rather than dismissed, since the existing idiom catalogue already covers part of
that ground (revisit if the transform proves untypable without it).

**Q2 — the new entity is the `projection model`.** Settled 2026-07-26. Chosen because
`CONTEXT.md` already calls `semantic/` the "projection-**independent** semantic model", so
this is its projected counterpart in vocabulary the repo already has — and ADR-0044
independently names the shared `emit` crate "the shared **projection** substrate", making
the projection model the model that substrate produces. "Projection" also already carries
the placement rule (§45.10 "projection lives in `targets/`, never `platforms/`"), so the
name answers *where it belongs* for free. Rejected: "target API model" (one adjective from
the existing "target model" — retroactively ambiguates every brief and ADR citing "the
target model", which is the drift `CONTEXT.md` exists to prevent); "binding model"
(ADR-0010 makes the native library *the* binding); "surface model" ("surface" is already
used of the source surface). Glossary entry written this session, plus a disambiguation
clause added to the existing **target model** entry's `_Avoid_` line.

**Q3 — the construct vocabulary is authored per target over a shared meta-schema.**
Settled 2026-07-26. `targets/_shared` owns the meta-schema (how a construct is declared)
and the engines; each target authors its own construct repertoire. This is what keeps the
design inside ADR-0011 with **no rework needed**: ADR-0011 permits shared *mechanism* and
forbids shared target *semantics*, and ADR-0044 already establishes `targets/_shared/` as
"the established home for any future cross-target machinery" while confirming hermetic
isolation "governs runtime/output, not emitter code". Precedent is exact — one shared
`target-model` crate parsing per-target authored `.apiw` data — and §ws6's own note
anticipated it ("the model permits a future non-Lisp target to author its own").
Rejected: one shared closed vocabulary (maximum leverage, but directly contradicts
ADR-0011's chosen option and its paradigm-diversity rationale, so it would force an
in-place ADR-0011 rework); and a shared "universal core + per-target extensions" spine
(the spine is exactly where the straitjacket forms, and the planned targets — Haskell,
Idris2, Prolog/Mercury, Pharo, Zig — are the ones ADR-0011 names as paradigmatically alien,
so they test it hardest).

**Q4 — prior-art research is commissioned before the mechanism is settled.** Settled
2026-07-26. So the transform engine, the template engine, and the projection model's
artifact/derivation status are **explicitly not settled by this leaf** — they belong to a
later planning leaf that reads the research. Trigger per `driving.md`: this sits in a
heavily-trodden neighbourhood (SWIG, uniffi, wit-bindgen, Djinni, protoc plugins,
GObject-Introspection/GIR, and the MDA/QVT/ATL model-transformation lineage), and two of the
closest analogues partly contradict the thesis — `wit-bindgen` generates via imperative
per-language Rust rather than templates, and `uniffi` pairs Askama templates with
substantial handwritten per-language runtime glue. GIR is a ~20-year worked example of a
projection model in production, including known pain in transfer-ownership annotations —
this repo's own weakest facet (ADR-0047's ownership cascade). The load-bearing question the
research must answer is the **escape hatch**: declarative transform + logic-free templates
covers most of a surface, then meets cases needing arbitrary computation, at which point
templates grow logic and the architecture silently reverts. Research lands in
`targets/_shared/docs/research/` (established home for cross-cutting research — the KDL
authoring eval and codec spikes are there), dated per repo convention.

**Q5 — charter: purely a design/research grove.** Settled 2026-07-26 by direct
instruction, superseding the options put in Q5. The grove writes **no production code and
no prototype**. Its single deliverable is **`TODO.language-model-transforms.md`** — a
handoff document a *new* grove consumes as its initial input. I had recommended running
through one proven pilot target, on the grounds that the escape-hatch question looks solved
in prose and fails on contact with a real API surface; that concern is noted and the
decision stands as given. Its mitigation moves *into* the handoff doc: the doc must name
the escape-hatch question as the build grove's first-order risk and say what evidence would
settle it, rather than leaving a future session to rediscover it.

**Q6 — the handoff doc is self-contained; nothing lands in `CONTEXT.md` or `adr/`.**
Settled 2026-07-26. Vocabulary, settled decisions, rejected options and open questions all
live inside `TODO.language-model-transforms.md`. **One exception:** research output lands in
`targets/_shared/docs/research/` as dated durable evidence, per repo precedent — it is
evidence about the world, true regardless of whether this design is ever built. Rationale:
`CONTEXT.md` is the repo's *current* ubiquitous language, and under a design-only charter
these terms name a pipeline stage that will not exist when the grove ends — a future session
would find glossary entries with no code behind them. ADRs bind future work and this repo
reworks them in place rather than superseding (ADR-0024 + `linkuistics:decision-records`), so
minting ADRs for an unbuilt design creates rework debt for the build grove. **Action taken:**
this session's `CONTEXT.md` edits (the `projection model` / `model transform` /
`construct vocabulary` entries and the `target model` disambiguation clause) were **reverted**
— verified back to 2413 lines with no diff — and that content moves into the handoff doc.

**Reframing carried forward, agreed implicitly by Q3:** the value of this architecture is
*not* cross-target reuse of rules or templates — those are per-target semantics and stay
per-target. It is the change of **form**: declarative rules and templates in place of
~14k LOC of imperative Rust per target, with provenance from the derivation trace and a
reviewable model as the diff surface. Any later leaf that justifies itself by "and then all
targets can share X" is arguing against Q3 and needs to say so explicitly.

## Notes

Repo convention overrides two grove defaults, deliberately:

- **ADRs live at `adr/NNNN-slug.md` with global numbering**, not `docs/adr/<slug>.md`
  (ADR-0024 — the central cross-target decision graph). Next free number: **0062**
  (0018 and 0045 are absent; 0061 is the highest).
- **PRDs at `prd/<date>-<slug>.md`** are this repo's human-facing agreement checkpoint —
  grove's `docs/specs/<slug>.md` role. Per-domain docs co-locate; there is no top-level
  `docs/` tree.

Two groves are live in this repo concurrently, isolated by jj workspace: this one
(`language-model-transforms`) and `APIAnyware.add-ocaml-target` (unmerged head, 27 leaves,
ending `dune-generalisation-and-goldens-k27`). Anything this grove changes about the
emitter contract will land under that grove's feet — a coordination question for the
grilling.
