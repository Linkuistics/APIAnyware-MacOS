# review-handoff-doc-k6

**Kind:** review

## Goal

Adversarial fresh-context read of `TODO.language-model-transforms.md` — the grove's sole
deliverable. Produce **findings, not fixes**.

The framing is `driving.md`'s doubt pass: assume the author was overconfident and try to
**disprove** the doc's usability, rather than confirming it. The doc's whole value is that a
future grove can act on it, and the author of a document is the worst judge of whether a
stranger can follow it.

## Context

- `TODO.language-model-transforms.md` — the subject.
- The two research docs under `targets/_shared/docs/research/` — to spot-check citations.
- `adr/0011`, `adr/0044`, `adr/0047`, `adr/0051` — to check the doc's claims about what the
  existing ADRs say, since the design's whole compatibility argument rests on them.

Deliberately **not** required reading: this grove's task files and briefs. The point is to read
the doc as a stranger would. Consult `.grove/` only to check whether something load-bearing was
left behind in it — which is itself a finding.

## What to attack

1. **Self-containment.** Is anything load-bearing reachable only via `.grove/`, which is deleted
   at finish? Grep for `.grove` and for references to leaf keys (`k1`–`k6`) used as if the reader
   can open them.
2. **Actionability.** Could you `root-init` a grove against this and write a first planning
   leaf? If not, what is missing — specifically.
3. **Hidden decisions.** Find claims stated as settled whose rationale is absent, and rejected
   alternatives that were dropped rather than recorded. A decision without its rejected
   alternatives will be re-opened by the build grove.
4. **Citation integrity.** Spot-check the research docs' primary sources: do the cited URLs and
   quotes exist and say what is claimed? Check the ADR claims verbatim against the ADR text —
   particularly the ADR-0011 "mechanism not semantics" carve-out and the ADR-0044
   "governs runtime/output, not emitter code" line, since the design's compatibility with
   hermetic isolation rests entirely on those two readings being correct.
5. **Risk honesty.** Is the escape-hatch risk stated plainly, or buried and softened? Does the
   doc admit the design was never built or prototyped? Does it name the ADR-0047 tension
   (compile-time rules vs per-target authored rules)?
6. **Numbers.** Re-derive at least two of the quantitative claims independently. Report any that
   do not reproduce, and any presented as current without a date.
7. **The strongest counter-argument.** State the best case *against* this architecture that the
   doc does not make. If a reasonable engineer would object on grounds the doc never addresses,
   that is the most valuable finding available — `wit-bindgen` choosing imperative generators
   and the MDA/QVT retreat are the obvious places to look for it.

## Done when

- Findings are recorded, ranked most-severe first, each with the specific location in the doc
  and what would resolve it.
- Findings are **reconciled** with the human: each becomes one of — a real defect (fix the doc),
  an unclear contract (fix the wording), an accepted trade-off (record it visibly in the doc), or
  noise raised for want of context (note and move on).
- Any fix that follows is applied to `TODO.language-model-transforms.md`, so the grove finishes
  with a reviewed deliverable rather than a review plus a stale doc.

## Notes

Stop when a pass turns up only trivia, or after three rounds (`driving.md`). Three unresolved
rounds is information about the document, not a reason to grind a fourth.

This is the last content leaf. When it retires, the grove has no live leaves and the **Finish**
cycle applies: propose promotion + `.grove/` deletion, **wait for explicit human confirmation**,
then `grove-llm complete --done`. Note the asymmetry this grove creates — the handoff doc and the
two research docs are the durable outputs and they already live outside `.grove/`, so promotion
should be close to a no-op. Verify that rather than assuming it.

## Findings (2026-07-27, one pass — reconciled with the human, all dispositions accepted)

Verification record: every §9 number reproduces exactly (71,719 / 4,092 / 1,491·24 / 9,575 /
153 / 2,413 / ADR-0061 / `.gitignore:10-11`); ADR-0011, ADR-0044 (×2) and ADR-0047 quotations
verbatim and in the cited sections; all spot-checked file:line citations exact
(`model.rs:86`, `model.rs:103-120` seven-variant enum, `idioms.kdl-schema:127`,
`emit_framework.rs:49-152`, `emit_generics.rs:148`); the `KNOWN_UNBINDABLE` md5 re-derived
independently — `4b78965e…` ×4, 51 entries; research docs at the exact cited line counts
(918/2009/727/789); k2/k3/k7 claims traced (226 deprecated, getter renames, 1,834/20 docs,
nine CLI passes, 51/17 frameworks); zero `.grove` references in the doc; wit-bindgen issue
#1265 exists.

Ranked most-severe first; each became a doc fix unless noted:

1. **§5.8.1 — the strongest counter-argument was raised but not answered.** Fleet-stall
   risk (uniffi's successful Python pilot, stalled fleet) vs a kill criterion that only gates
   the pilot. Fixed: §5.8.1 now names the gap, states the structural limit (migrations are
   independent, not sequential; a stall is a bounded cost, not a broken pipeline) and records
   the residual two-architecture carry as an openly accepted trade-off.
2. **§0 — "seven ⚠ corrections" vs 38 actual ⚠ flags.** Unverifiable promise. Fixed: count
   dropped; the load-bearing corrections enumerated by section.
3. **§2.1 — two CONTEXT.md quotations not verbatim.** "projection-independent semantic model"
   appears nowhere in CONTEXT.md (which has "projection-independent source semantics" and never
   the string "semantic model"); the §45.10 quote paraphrased "here" as "`targets/`". Fixed:
   both quote the actual text.
4. **§5.1 — kill criterion carried none of its rejected alternatives** (k4 recorded three:
   the 15–40% bracket, flat 40% uncalibrated, holding 10–20%). Fixed: restored. Also: §4.4's
   decode table mapped k1 to "§2, §3.2–§3.4" but k1's Q5/Q6 charter content landed in §1.2/§2.4
   — mapping widened.
5. **§3.4(a) — `ffi_type_mapping.rs` cited as 1,071 lines; actual 1,070.** Fixed.
6. **Noise, noted:** k1's GIR transfer-ownership "weakest facet" observation is not carried;
   the substance is one hop away in k3 §4 (ownership facet), which the doc cites. No change.

One pass sufficed — nothing severe; the doc's numbers, ADR readings and evidence chain held up.
