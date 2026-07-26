# APIAnyware.language-model-transforms — brief

## Goal

Design — **on paper only** — a re-cut of the pipeline's `generate` half: replace today's
*resolved semantic model → per-target emitter → binding source* path with an explicit
*resolved semantic model → **model transform** → **projection model** → **template**
rendering → binding source + adapter + docs* path.

The motivation is mass and duplication: **71,719 LOC of per-target emit crates** against
**4,092 LOC of shared substrate**, with the same *shape* of logic rediscovered per target.
`targets/_shared/docs/emitter-contract.md` is that rediscovery written down — its one
section ends by telling the next emitter author to hand-copy a type substitution, naming
the raw-pointer spelling in Haskell, OCaml, Zig and Idris2 for them to pick from.

## Done when

**`TODO.language-model-transforms.md` exists at the repo root**, and a *new* grove could
`root-init` against it and start work without re-deriving anything settled here. That means
the doc carries: the settled architecture and its vocabulary; the mechanism decisions with
their rejected alternatives; the prior-art evidence base by citation; the escape-hatch risk
named as the build grove's first-order concern with the evidence that would settle it; and a
proposed decomposition for the build grove.

**This grove writes no production code and no prototype** (charter, `plan-k1` Q5).

## Decomposition

Child ordering encodes an evidence-before-decision dependency (`plan-k1` Q4):

1. `emitter-anatomy-audit` — in-repo, empirical: what is the 71.7k LOC actually *made of*?
   Produces the concrete question list the survey must answer, so the survey is biased by
   real numbers rather than framed abstractly.
2. `prior-art-model-transform-codegen` — external post-mortem survey, biased by (1).
3. `plan-mechanism` — the second grilling: transform engine, template engine, the
   projection model's artifact/derivation status, and the escape hatch. Deliberately **not**
   settled by `plan-k1`.
4. `write-handoff-doc` — author `TODO.language-model-transforms.md`.
5. `review-handoff-doc` — fresh-context adversarial read of the sole deliverable.

(1) before (2) is the one non-obvious ordering: `driving.md` says the leveraged move in a
research brief is naming the downstream questions, and the audit is what produces them.

## Settled design (`plan-k1`, 2026-07-26)

Recorded here because Q6 keeps it out of `CONTEXT.md` and `adr/` until a build grove commits
to it. The running log with rejected options and rationale is in `01-DONE-plan-k1.md`.

- **Q1 — the transform produces an instance-level model.** One node per emitted thing
  (compilation unit, callable, parameter, type reference, …), per target×platform. Being
  instance-level is what makes templates *sufficient*: every projection decision is resolved
  before rendering, so the renderer only renders.
- **Q2 — that model is the `projection model`.** `CONTEXT.md` already calls `semantic/` the
  "projection-**independent** semantic model", and ADR-0044 already names the shared `emit`
  crate "the shared **projection** substrate" — so this is the model that substrate
  produces, in vocabulary the repo already has. Do **not** call it "target API model": the
  existing **target model** (ADR-0051, ws6) is the *capability / idiom / policy knowledge*
  layer, and the two names would sit one adjective apart.
- **Q3 — the construct vocabulary is authored per target over a shared meta-schema.**
  `targets/_shared` owns the meta-schema and engines; each target authors its own construct
  repertoire. This keeps the design inside ADR-0011 with **no rework**: ADR-0011 permits
  shared *mechanism* and forbids shared target *semantics*; ADR-0044 confirms hermetic
  isolation "governs runtime/output, not emitter code". A single closed vocabulary spanning
  Haskell/Idris2/Prolog/Pharo/Zig would be the lowest-common-denominator straitjacket
  ADR-0011 rejected by name.
- **The leverage is *form*, not cross-target reuse.** Rules and templates are per-target
  semantics and stay per-target. The gain is declarative rules + templates in place of
  ~14k LOC of imperative Rust per target, provenance from the derivation trace, and a
  reviewable model as the diff surface. Any argument of the shape "and then all targets can
  share X" contradicts Q3 and must say so explicitly.

## Pointers

ADRs a session here must read:

- `adr/0011-targets-hermetically-isolated.md` — the mechanism-vs-semantics carve-out that
  bounds this whole design. Shared *mechanism* permitted; shared target *semantics* not.
- `adr/0044-shared-emit-substrate-home-targets-shared.md` — `targets/_shared/` is the
  established home for cross-target machinery; hermetic isolation governs runtime/output,
  not emitter code.
- `adr/0047-convention-heuristics-as-datalog-rules.md` — the precedent this design
  generalises: 1,236 lines of imperative classifiers re-expressed as declarative `ascent`
  rules, with per-rule provenance falling out of the derivation trace. Also parks a
  runtime-loadable rule DSL as out of scope, which `plan-mechanism` must revisit.
- `adr/0051-capability-profiles-and-derived-representability.md` — the existing **target
  model**, i.e. what the projection model is *not*.
- `adr/0046-spec-interchange-format-kdl-everywhere.md` — `.apiw` KDL is the interchange
  format for authored artifacts.
- `adr/0010-native-library-is-the-binding.md` + `adr/0005` — the idiom posture the design
  must not erode.

Glossary terms in play (`CONTEXT.md`): *projection-independent semantic model*, *target
model*, *idiom catalogue*, *projection policy*, *representability ladder*, *EmitConstruct*.
Note the new terms from `plan-k1` are deliberately **absent** from `CONTEXT.md` (Q6).

Repo conventions that override grove defaults:

- ADRs are `adr/NNNN-slug.md`, globally numbered (ADR-0024). Next free number **0062**
  (0018 and 0045 are absent; 0061 is highest). This grove mints none (Q6).
- Human-facing agreement checkpoints are `prd/<date>-<slug>.md`, not `docs/specs/`.
- Research is `<domain>/docs/research/<date>-<slug>.md`. Cross-cutting research goes to
  `targets/_shared/docs/research/` — the established home (KDL authoring eval, codec spikes).
- There is no top-level `docs/` tree; docs co-locate with their domain.

## On the horizon

- Whether the build grove is one grove per target or one grove for the pilot plus four
  migrations is a question for the handoff doc to *pose*, not for this grove to answer.
- `chez` has **no golden/snapshot mechanism at all** (confirmed by
  `objc-object-type-lowering-golden-review-k107`). Any equivalence proof strategy the
  handoff doc proposes has to say what chez's proof is, since goldens-as-truth is the
  repo's usual instrument and chez lacks the instrument.

## Notes

**Two groves are live in this repo concurrently, isolated by jj workspace:** this one
(`language-model-transforms`, sitting on `main`) and `APIAnyware.add-ocaml-target` (an
unmerged head, 27 leaves, ending `dune-generalisation-and-goldens-k27`). Because this grove
is design-only and touches no shared code, there is **no coordination requirement** — but
the OCaml grove is actively building a sixth emitter under the *old* architecture, which
makes it a fresh, well-documented data point for the `emitter-anatomy-audit` leaf, and the
handoff doc should say whether the build grove absorbs OCaml or leaves it.

**The repo is mid-way through `structural-refactoring`** (`REFACTOR.md`, `TODO.md`) — the
domain tree is authoritative for where things live, and some prose still names pre-refactor
paths. Treat path strings in older docs as suspect; verify against the tree.
