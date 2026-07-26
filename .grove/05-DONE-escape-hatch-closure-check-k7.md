# escape-hatch-closure-check-k7

**Kind:** research

## Goal

Retire — or fail to retire — the escape-hatch risk, on paper. `plan-mechanism-k4` Q1 adopted
M1–M5 as the escape hatch's closed repertoire but recorded closure as **provisional**, because
k3 §10.1 says nothing in the audit *appears* to need a sixth mechanism and that the claim needs
a site-by-site check before it can be asserted. This leaf does that check.

The stakes are stated by k3 §10.1 directly:

> If every site maps into M1–M5, the escape-hatch risk is retired to "engineering", because all
> five are shipped mechanisms with known costs. If any site maps to none of them, that site is
> the design's genuine open problem and must be named as such in the handoff doc.

Deliverable is a **research document**, not decisions and not code. `write-handoff-doc-k5`
cites it.

## Context

Beyond the brief chain:

- `targets/_shared/docs/research/2026-07-26-emitter-anatomy-audit.md` — §2.1 (the seven hard
  escapes E1–E7), §2.3 (the four soft escapes), §3 (the statefulness list, which is where
  further sites hide).
- `targets/_shared/docs/research/2026-07-26-model-transform-codegen-prior-art.md` — §10 defines
  M1–M5 and gives the provisional mapping; §9 Q1–Q8 give each mechanism's shipped instances and
  costs.
- `04-plan-mechanism-k4.md`'s running log — Q1 fixes the repertoire and its three riders; Q2
  fixes the transform as typed Rust passes (so "expressible" means *expressible in a pass*, not
  *expressible in datalog*); Q4 fixes the template contract as computation-free/branching-allowed;
  Q5 puts the Swift adapter sources in scope, so adapter-side escapes count.

The mechanisms, from k3 §10.1:

| M1 | authored declarative data, keyed by a path or declaration identity into the model |
| M2 | a host function invoked from a transform pass, whose result becomes a model field |
| M3 | an imperative pass staged between declarative ones |
| M4 | a named insertion point / deferred region in the emitted text |
| M5 | a data-dependent output file list from the renderer |

## Questions to answer

1. **Site by site, which mechanism (or tuple) expresses it?** Cover every entry in k2 §2.1
   (E1–E7), every soft escape in §2.3, and every statefulness site in §3.1–§3.3. Q1's third
   rider is load-bearing here: **sites are M-combinations, not M-assignments** — E5 is M1 (the
   1,715-symbol `chez_builtins.txt`) *plus* M2/M3 (intersect-sort-dedup over the whole file's
   export set), and E1 presupposes E2 because the suppression table is keyed by the FNV hash. A
   site's answer is a tuple with an ordering, not a letter.
2. **Does any site map to none of M1–M5?** That site is the design's genuine open problem. Name
   it, say what mechanism it would need, and do not soften it.
3. **Where M1 applies, is the site type-keyed or declaration-keyed?** Q1 adopted SWIG's and
   uniffi's independently-converged split. Classify each M1 site; a site that fits neither
   cleanly is itself a finding.
4. **Does the check hold against one real framework?** k3 §10.1 asks for the check to be done
   "against one real framework", not in the abstract. Pick one whose surface actually exercises
   the escapes (AppKit or Foundation are the two with measured numbers throughout k2) and walk
   the sites through it.
5. **What does the mapping imply for the pilot?** Q7 picked racket and flagged that it exercises
   M1/M2/M3/M4 but **not M5** (gerbil's E6 sharding is the repo's only M5 site). Confirm or
   correct that, and say which mechanisms the pilot will leave unexercised.

## Done when

- Every site in k2 §2.1, §2.3 and §3 carries an M-tuple, or is named as mapping to none.
- The document states plainly whether the escape-hatch risk is **retired to engineering** or
  **not**, in those words, rather than leaving the reader to infer it.
- Each M1 site is classified type-keyed or declaration-keyed.
- The mechanisms the racket pilot will not exercise are named.
- Lands at `targets/_shared/docs/research/<date>-escape-hatch-closure-check.md` (the established
  home for cross-cutting research; dated per repo convention).

## Notes

**AFK-safe.** This is a paper exercise over documents and code already in the tree — no human
decision is required, so the self-driving loop may run it unattended. If it surfaces a decision
rather than a finding, externalize it (`leaf-insert` ahead of `write-handoff-doc-k5`) rather
than deciding it here.

Mint no ADR and touch `CONTEXT.md` not at all (charter Q6). Write no production code and no
prototype (charter, `plan-k1` Q5) — "on paper" is the whole method, and k3 §10 is explicit that
a prototype of the easy 80% would produce no evidence about the only question that matters.

The audit is read-only input: do not re-measure it. Where this check disagrees with k2, say so
and show the reasoning — k2's §9 already records eight things it could not determine, and a
disagreement there is a finding, not an error to paper over.
