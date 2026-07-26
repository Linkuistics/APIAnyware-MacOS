# plan-mechanism-k4

**Kind:** planning

## Goal

The second grilling. `plan-k1` deliberately left the mechanism unsettled pending evidence
(Q4); this leaf settles it, with the audit (`k2`) and the prior-art survey (`k3`) in hand.

Deliverable is **decisions, recorded in the running log below** — not code, not ADRs, not
glossary entries (charter Q5/Q6). `write-handoff-doc-k5` transcribes them.

## Context

Beyond the brief chain:

- `targets/_shared/docs/research/<date>-emitter-anatomy-audit.md` (from `k2`) — especially its
  escape-hatch inventory and statefulness list.
- `targets/_shared/docs/research/<date>-model-transform-codegen-prior-art.md` (from `k3`) —
  especially its Synthesis section.
- `adr/0047-convention-heuristics-as-datalog-rules.md` — decision 2 fixes rules as
  **compile-time** and parks a runtime-loadable rule DSL. Whether the transform tier reverses
  that is a question for this leaf, and reversing it means **reworking ADR-0047 in place** for
  the build grove, never appending a superseding ADR.
- `adr/0046-spec-interchange-format-kdl-everywhere.md` — if the projection model is a committed
  artifact, `.apiw` KDL is the presumptive format and this ADR says why.

## Questions to grill

Sequenced so foundational answers land before derived ones. Ask one at a time.

1. **The escape hatch — first, because it bounds everything else.** Given `k2`'s inventory of
   what rules-plus-templates cannot express, what is the escape hatch? Candidate shapes: a
   per-target Rust hook invoked from the transform; a template helper/filter registry; an
   `unsafe`-flavoured "hand-written region" in the projection model; or accepting that some
   fraction of each target stays imperative and scoping the architecture to the rest. **If the
   escape hatch has to be large, the thesis is weaker and the handoff doc must say so.**
2. **Transform mechanism.** `ascent` datalog (proven in five crates, all upstream of the IR),
   compile-time as ADR-0047 fixed? Or does per-target authoring (Q3) require runtime-loaded
   rules, since a target's rules are its own semantics? Note the tension: Q3 says rules are
   per-target authored data, while ADR-0047 says rules are version-controlled Rust — those pull
   in opposite directions and this is the sharpest unresolved point in the design.
3. **Projection model artifact status.** Committed `.apiw` (reviewable, diffable, becomes the
   golden surface, rots against SDK drift) or derived-in-memory (constraint-4 clean, cheap, but
   no review surface)? The repo has precedent both ways: `resolved.kdl` is committed and derived;
   representability status is derived-and-deliberately-uncommitted.
4. **Template mechanism.** Which engine, or none? The workspace currently has **no** template
   engine, so this is a new dependency. Weigh `k3`'s evidence on logic-leaking-into-templates.
   A serious option is a small purpose-built renderer over the projection model rather than a
   general engine — evaluate it rather than assuming a third-party crate.
5. **Output scope.** Does the projection model cover only the scripting-side bindings, or also
   the Swift adapter sources and the docs? `k2` Q5 establishes what is generated today; the
   charter names all three. Decide what the build grove targets.
6. **Equivalence-proof strategy.** How would a build grove prove the new path reproduces the
   old? Goldens-as-truth is the repo's instrument, but **chez has no golden mechanism at all**,
   so chez needs a different answer. Also decide whether equivalence is even the right bar, or
   whether the new path is permitted to produce *better* output and move goldens intentionally.
7. **Build-grove decomposition.** What shape does the follow-on grove take — pilot-plus-four,
   or grove-per-target? Which target pilots, and why? (`k2` Q7 and Q8 give the evidence: the
   pilot should be the target whose residual-Rust estimate is most informative, not necessarily
   the smallest.) Does the build grove absorb the in-flight OCaml target or leave it?

## Done when

- Each question above is settled and recorded in the running log with its rejected
  alternatives and the evidence that decided it — the same shape as `plan-k1`'s log, since
  `k5` transcribes from it.
- Any question the evidence **cannot** settle is recorded as an explicit open question with
  what would settle it, rather than being resolved by guesswork. A design-only grove is allowed
  to hand over open questions; it is not allowed to hide them.
- If the grilling changes anything settled in `plan-k1` (Q1–Q3), the root brief's
  "Settled design" section is **edited in place** to say what now holds — current-state, not a
  changelog.

## Decisions (running log)

_Appended as each question settles._

## Notes

HITL leaf: it needs a human. If the self-driving loop reaches it unattended, that is correct
behaviour — wait.

Grow the tree if the grilling surfaces work that does not fit `k5`/`k6` (`leaf-insert` to
sequence ahead of them). Externalize rather than absorbing: this leaf's goal is decisions, and
a decision session that starts drafting the handoff doc has stopped being one.

Mint no ADR, touch `CONTEXT.md` not at all (charter Q6) — including the vocabulary from
`plan-k1`, which was deliberately reverted out of the glossary and lives in the root brief
until the handoff doc carries it.
