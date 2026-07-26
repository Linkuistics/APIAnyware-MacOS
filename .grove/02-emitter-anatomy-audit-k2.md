# emitter-anatomy-audit-k2

**Kind:** research

## Goal

Answer empirically, from the code: **what is the 71,719 LOC of per-target emitters actually
made of?** The design in the root brief assumes the mass is mostly mechanical rendering with
a decision layer that can be lifted into declarative rules. Test that assumption against the
real emitters and produce the **concrete question list** that `prior-art-model-transform-codegen-k3`
must answer — so the survey is biased by real numbers rather than framed abstractly
(`driving.md`: the leveraged move in a research brief is naming the downstream questions).

This is an **audit, not a redesign**. Propose nothing; measure and classify.

## Context

Beyond the brief chain:

- `targets/<t>/tools/emit-<t>/` for `t ∈ {racket, chez, gerbil, sbcl, typescript}` — the
  subjects. Baseline LOC from `plan-k1`'s survey: racket 14,732 · chez 8,186 · gerbil 12,162 ·
  sbcl 11,152 · typescript 25,487.
- `targets/_shared/tools/emit/src/` — the 4,092-line shared substrate. Note
  `framework_ordering.rs` and `pattern_dispatch.rs` especially: the first is a hint that
  emission carries **ordering state**, the second is the one already-data-driven seam.
- `targets/_shared/docs/emitter-contract.md` — the rediscovery catalogue; its single section
  is a worked example of a decision that should be one rule over one IR fact.
- `targets/_shared/docs/adding-a-language-target.md` (535 lines) — the current per-target
  build-out procedure. What it *asks a new author to decide* is a direct readout of the
  decision surface.
- The `APIAnyware.add-ocaml-target` jj workspace holds an in-progress **sixth** emitter under
  the old architecture (27 leaves). It is the freshest evidence of what building one costs;
  read its grove tree and ADRs if reachable, but do not modify that workspace.

## Questions to answer

Answer each with counts and named symbols, not impressions.

1. **Mechanical vs decision-bearing.** For each emitter, classify its code into: (a) pure
   rendering (string assembly whose only inputs are already-resolved values), (b) projection
   *decisions* (choosing a target construct, name, type mapping, or shape), (c) traversal /
   orchestration, (d) tests and fixtures. Give LOC per bucket per target. Bucket (a) is the
   template candidate; (b) is the transform candidate.
2. **The escape-hatch inventory — the crux.** Enumerate every site that a datalog rule plus a
   *logic-free* template could **not** express. Candidates to look for specifically:
   arbitrary string computation, arithmetic, recursion over type structure, accumulated state,
   sorting/dedup, conditional emission depending on the whole corpus, and anything reading the
   filesystem or SDK. For each, say what it does and what mechanism would be required. **This
   inventory is the single most valuable output of this leaf** — it is the risk the charter's
   design-only scope cannot otherwise test.
3. **Ordering and statefulness.** Where does emission depend on accumulated state rather than
   the current node — collected imports, forward declarations, framework ordering, symbol
   uniqueness, file-level preambles? Templates are stateless, so each such site is a transform
   responsibility, and this list bounds what the projection model must carry.
4. **The transform's input surface.** Which IR facets, enrichment outputs, and target-model
   `.apiw` entities does each emitter actually read? Anything read by exactly one emitter is a
   candidate for per-target vocabulary; anything read by all five is meta-schema.
5. **The renderer's output surface.** What does each emitter write — file set, layout, and any
   non-source outputs. Does any emitter today generate the Swift adapter sources or the docs,
   or are those hand-written? (The charter names dylib and docs as in-scope outputs; establish
   whether that is currently true of *any* target.)
6. **Genuine idiom vs accidental duplication.** Where the five emitters solve the same problem,
   is the difference load-bearing target idiom (ADR-0005/0011 — must stay per-target) or
   incidental divergence? Quantify. This is the honest measure of whether a projection model
   *shrinks* the code or merely relocates it.
7. **The TypeScript outlier.** 25,487 LOC — roughly 2× racket, 3× chez. Where does the excess
   sit, and is it (i) a richer target surface (`.d.ts` + object model, ADR-0055), (ii) N-API
   substrate, or (iii) avoidable? TypeScript is the target that most tests the thesis because
   it is the least Lisp-like already shipped.
8. **The residual question.** For each target: *if the projection model and renderer existed,
   what would remain as hand-written Rust?* An estimate with reasoning. This is the audit's
   walk-away check and the number the handoff doc will be judged on.

## Done when

- `targets/_shared/docs/research/<YYYY-MM-DD>-emitter-anatomy-audit.md` exists (dated the day
  it lands), answering all eight questions with per-target figures.
- It closes with a **"Questions for k3"** section: the specific things the prior-art survey
  must find out, derived from the escape-hatch inventory (Q2) and the statefulness list (Q3).
- Every quantitative claim cites the file and symbol it came from. Anything that could not be
  classified is listed as unclassified with the reason — an honest residual beats a tidy total.

## Notes

Read-only leaf: change no emitter code, add no dependency, mint no ADR (charter Q6).

Counting discipline: report LOC with the command used, and separate test code from production
code — `emit/test_fixtures.rs` alone is 887 lines, so a raw total flatters the decision surface.

Where the answer is "this can't be determined without running it", say so and stop. This grove
runs no code beyond read-only inspection and existing test/lint commands.
