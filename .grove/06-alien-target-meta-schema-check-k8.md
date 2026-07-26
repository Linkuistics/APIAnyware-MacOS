# alien-target-meta-schema-check-k8

**Kind:** research

## Goal

Test root-brief Q3's shared meta-schema against the *most* paradigmatically alien planned
target, on paper, before any pilot commits to it.

Q3 settled that `targets/_shared` owns a meta-schema (how a construct is declared) while each
target authors its own construct repertoire — the arrangement that keeps the design inside
ADR-0011 with no rework. k3 §9 Q12 is the survey's sharpest result and it is a caution against
exactly that arrangement:

> Every system that reached a paradigmatically alien target shares only source-side facts. The
> two systems with a shared target-side layer have either failed to cross a paradigm boundary
> (wit-bindgen) or never attempted one (uniffi).

A meta-schema for *target constructs* is a target-side commitment — the category with no
successful alien-paradigm precedent in the survey. k3's prescription is a test, not an
argument (§9 Q12, §10.4): write the construct set out against Prolog or Idris2, **not OCaml**,
and check whether every construct it needs is expressible. Doing it against a near neighbour
proves nothing.

Deliverable is a **research document**, not decisions and not code. `write-handoff-doc-k5`
cites it.

## Context

Beyond the brief chain:

- `targets/_shared/docs/research/2026-07-26-model-transform-codegen-prior-art.md` — §2.6 (the
  precedent: wit-bindgen never crossed compiled→interpreted in five years; JavaScript and Python
  **forked** into ComponentizeJS and componentize-py rather than conform), §3.7 (the encouraging
  counter-case: SWIG reaches Guile and Java from one substrate because its shared layer models
  only the source), §9 Q12, §10.4.
- `adr/0011-targets-hermetically-isolated.md` — the mechanism-vs-semantics carve-out this check
  stress-tests, and the ADR that names the planned targets as paradigmatically alien.
- `CONTEXT.md` §"Target model (refactor workstream 6)" — the existing authored layer's shape:
  the §21 idiom **category** vocabulary (25 tokens), the closed `EmitConstruct` taxonomy, the
  `projects "<kind>" { emit "<construct>"; name "<id>" }` form. `plan-k1` Q1 widens
  `EmitConstruct` from its 8 emit-relevant pattern kinds to a target's full construct
  repertoire — that widening is what this check tests.
- `04-plan-mechanism-k4.md`'s running log — Q2 (per-target repertoire is authored `.apiw` data
  read at generation time, so "expressible" means *authorable in the meta-schema*), Q4
  (templates are computation-free/branching-allowed, so a construct the meta-schema cannot
  express cannot be rescued in the template), Q5 (adapter sources are in scope, so the alien
  target's adapter surface counts too).
- `adr/0046-spec-interchange-format-kdl-everywhere.md` — `.apiw` KDL is the authoring format,
  so expressibility is partly a question about what the KDL Schema can state.

## Questions to answer

1. **Which target is the most alien, and why?** ADR-0011 names Haskell, Idris2, Prolog/Mercury,
   Pharo and Zig. Pick the one that stresses the meta-schema hardest and justify the pick against
   the others — the choice is part of the finding. Candidate axes: no mutable object identity, no
   method dispatch, dependent types, logic-programming relational form, image-based runtime,
   manual memory.
2. **Write the construct set out.** For the chosen target, enumerate the constructs its binding
   surface actually needs — what today's five targets carry as classes, methods, properties,
   protocols, enums, constants, functions, structs, trampolines, and the adapter-side entries.
   This is the artifact the check operates on.
3. **Is each construct expressible in the meta-schema?** Where it is not, say precisely what is
   missing and whether the gap is in the meta-schema, in the `EmitConstruct` taxonomy's widening,
   or in the `.apiw`/KDL-Schema authoring form.
4. **Does the meta-schema drift target-side?** k3 §9 Q12 names the two observable pressures:
   uniffi's General IR accreting FFI-shaped concepts that suit its four similar targets, and
   wit-bindgen's 34-instruction ABI encoding a memory model no interpreted language shares. Look
   for the analogous pressure in our proposed shape and name it if present.
5. **If the check fails, what is the fallback?** SWIG's answer (§3.7) is that the shared layer
   models *only the source* and supplies mechanism with no target vocabulary whatsoever — and it
   reaches Guile and Java from one substrate. Say whether that fallback is available to us and
   what it would cost, so a failure hands over a route rather than only a problem.

## Done when

- The chosen alien target is named with its justification against the other candidates.
- Its construct set is written out and each construct is marked expressible or not.
- The document states plainly whether root-brief Q3's shared meta-schema **holds** or **does not
  hold** against the alien case, in those words.
- If it does not hold, the fallback (SWIG's source-only shared layer, or another) is costed.
- Lands at `targets/_shared/docs/research/<date>-alien-target-meta-schema-check.md`.

## Notes

**AFK-safe.** A paper exercise over documents already in the tree; no human decision required.
If the check surfaces a decision — most likely "Q3 does not hold, so what replaces it?" — do not
decide it here: `leaf-insert` a planning leaf ahead of `write-handoff-doc-k5`.

Mint no ADR and touch `CONTEXT.md` not at all (charter Q6). Write no production code and no
prototype (charter, `plan-k1` Q5).

**If this check fails, it changes something `plan-k1` settled.** Q3 is one of the three
decisions the root brief's "Settled design" section carries. Per this grove's practice, a
failure means editing that section **in place** to say what now holds — current-state, not a
changelog — and saying so in the document.
