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
4. `escape-hatch-closure-check` — the paper check that turns `plan-mechanism` Q1's
   *provisional* closure of the M1–M5 repertoire into an assertion or a named open problem
   (k3 §10.1, "the highest-value remaining paper exercise").
5. `alien-target-meta-schema-check` — the paper check of Q3's shared meta-schema against the
   most alien planned target, Prolog or Idris2 (k3 §10.4). Targets the one failure mode with
   a documented precedent: wit-bindgen's interpreted targets forked rather than conform.
6. `write-handoff-doc` — author `TODO.language-model-transforms.md`.
7. `review-handoff-doc` — fresh-context adversarial read of the sole deliverable.

(1) before (2) is the one non-obvious ordering: `driving.md` says the leveraged move in a
research brief is naming the downstream questions, and the audit is what produces them.
(4) and (5) sit after (3) because both check decisions (3) makes, and before (6) because the
handoff doc carries their findings rather than deferring them to the build grove.

## Settled design (`plan-k1` + `plan-mechanism-k4`, 2026-07-26)

Recorded here because Q6 keeps it out of `CONTEXT.md` and `adr/` until a build grove commits
to it. The running logs with rejected options and rationale are in `01-DONE-plan-k1.md`
(architecture) and `04-plan-mechanism-k4.md` (mechanism).

**Architecture.**

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
  repertoire, as authored `.apiw` **data** read at generation time — not as loadable rules.
  This keeps the design inside ADR-0011 with **no rework**, and leaves ADR-0047 untouched:
  ADR-0011 permits shared *mechanism* and forbids shared target *semantics*; ADR-0044
  confirms hermetic isolation "governs runtime/output, not emitter code". A single closed
  vocabulary spanning Haskell/Idris2/Prolog/Pharo/Zig would be the lowest-common-denominator
  straitjacket ADR-0011 rejected by name. **Two qualifications, both from k3:** facts about
  the *Swift adapter's compiler* are not per-target data at all — `KNOWN_UNBINDABLE` is
  byte-identical in four emitters because the rejecting compiler is the same compiler, and
  belongs in a shared authored layer keyed by declaration identity, once (k3 §9 Q14). And Q3
  is a *target-side* commitment, the category with no successful alien-paradigm precedent in
  the survey (k3 §9 Q12) — `alien-target-meta-schema-check-k8` tests it before any pilot.

**Mechanism.**

- **The escape hatch is the closed five-mechanism repertoire M1–M5** — authored declarative
  data keyed by path or declaration identity; a host function in a transform pass whose
  result becomes a model field; an imperative pass staged between declarative ones; a named
  insertion point in emitted text; a data-dependent output file list. M1 splits by keying
  (type-keyed vs declaration-keyed) from day one. A general-purpose expression language
  inside the rule engine is the named anti-pattern. Closure is **provisional** pending
  `escape-hatch-closure-check-k7`.
- **The transform is typed Rust node-to-node passes**, separate node types per stage, with
  `ascent` admitted as *one* pass kind for genuinely relation-shaped derivations — not as the
  engine. No surveyed system uses a rule engine for the projection transform.
- **The projection model is derived and uncommitted**, dumpable per stage and diffable per
  pass. Model *goldens* are committed at fixture scale only.
- **Templates are Askama, as external per-target files**, under a **computation-free,
  branching-allowed** contract with uniffi's display-concern exception.
- **Scope is binding source + Swift adapter sources + doc comments in generated source.**
  Standalone `.md` docs stay authored prose.
- **The bar is golden-INTENTIONAL, not equivalence**: every output diff is either on a
  pre-enumerated deviation list or it is a regression. Proved by a four-layer stack whose
  primary instrument is per-stage model diffing — which is also chez's answer.

**The leverage is *form*, and the mass argument is secondary.** Rules, templates and
repertoires are per-target semantics and stay per-target. The gain is declarative authored
data plus templates in place of imperative Rust, provenance from the derivation trace, a
reviewable model as the diff surface, the end of the sixth-emitter tax, and a generator a
target expert can edit without reading Rust. **The mass gain is real but modest and must be
stated as such:** at the prior art's measured ~40% escape-hatch share, 37,287 production
lines fall to ~14,900 — a **2.5×** reduction, not the 4.3–6.3× k2 §8 estimated — and with
test mass (49.2% of the headline) unquantified here and silent in the entire prior art, the
honest headline is **71,719 → ~50,200 lines of Rust**, roughly 30%. Any argument of the shape
"and then all targets can share X" contradicts Q3 and must say so explicitly; any argument
that sells the re-cut on mass or on templating contradicts the evidence.

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

- The **test-mass question is unresolved and unresolvable here** — 49.2% of today's 71,719
  lines is test code, no in-repo evidence says whether rules and templates need fewer tests,
  and k3 §9 Q11 found *complete silence* in the prior art: no system anywhere reports test
  mass before and after such a migration. The handoff doc names it as the pilot's primary
  instrumented measurement rather than pretending to answer it.
- The five `bundle-*` crates (**9,575 LOC**) were outside `emitter-anatomy-audit-k2`'s
  subject but are touched by the adapter scope; `bundle-sbcl` has no `bundle.rs` at all,
  suggesting the bundler surface is at least as divergent as the emitter surface. Classifying
  them the way k2 classified the emitters is build-grove work the handoff doc should name.

Both horizon items `plan-k1` left here are now answered and have moved into *Settled design*:
the build grove is a **single-target pilot on racket plus N migrations** (`plan-mechanism-k4`
Q7), and **chez's equivalence proof is per-stage model diffing** (Q6) — the only technique the
prior art reports as catching real migration bugs, and the one that needs no goldens.

## Notes

**Two groves are live in this repo concurrently, isolated by jj workspace:** this one
(`language-model-transforms`, sitting on `main`) and `APIAnyware.add-ocaml-target` (an
unmerged head, 27 leaves, ending `dune-generalisation-and-goldens-k27`). Because this grove
is design-only and touches no shared code, there is **no coordination requirement**, and
`plan-mechanism-k4` Q7 settled that it stays that way: the build grove **leaves OCaml
alone**. It lands under the old architecture and migrates as one of the N after the racket
pilot — redirecting it would discard 15,153 LOC of in-flight work and manufacture a
coordination dependency that does not exist today, and OCaml is not paradigmatically alien
enough to be the meta-schema's test case anyway (k3 §10.4: "Prolog or Idris2, **not
OCaml**"). Meanwhile it keeps supplying the duplication-tax evidence the form argument rests
on — three of its live leaves are *sister-target* defects shared by all five shipped
emitters.

**The repo is mid-way through `structural-refactoring`** (`REFACTOR.md`, `TODO.md`) — the
domain tree is authoritative for where things live, and some prose still names pre-refactor
paths. Treat path strings in older docs as suspect; verify against the tree.
