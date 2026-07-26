# write-handoff-doc-k5

**Kind:** work

## Goal

Author **`TODO.language-model-transforms.md`** at the repo root — the grove's sole deliverable
and the initial input a *new* grove consumes (charter Q5).

The test it must pass: **a session with no access to this conversation, this grove's task
files, or these briefs could `root-init` a build grove against this doc and start work without
re-deriving anything settled here.** Everything load-bearing must be *in* the doc, not cited
from `.grove/` — which is deleted when this grove finishes.

## Context

Beyond the brief chain:

- The root `BRIEF.md`'s "Settled design" section — Q1–Q3 with rationale.
- `01-DONE-plan-k1.md`'s running log — the fuller record, including rejected options and the
  reverted `CONTEXT.md` vocabulary that must land in the doc instead.
- `04-plan-mechanism-k4.md`'s running log — the mechanism decisions and open questions.
- The two research docs under `targets/_shared/docs/research/` — these **stay** after the grove
  ends, so the handoff doc should cite them rather than restate them at length.
- `TODO.md` at the repo root — the existing cross-target findings file. Match its register and
  conventions (dated resolutions, per-item status, explicit "the defect (was)" framing). Do
  **not** merge into it: the charter names a separate file.

## Required contents

1. **Charter and scope** — what a build grove is being asked to do, and the explicit statement
   that this design was never built or prototyped, so every claim is on-paper.
2. **Vocabulary** — `projection model`, `model transform`, `construct vocabulary`, with the
   `_Avoid_` notes, including why the terms were kept *out* of `CONTEXT.md` and the collision
   with the existing `target model` they must not fall into. The build grove lands these in
   `CONTEXT.md` when it builds.
3. **The settled architecture** — Q1–Q3 from `plan-k1` plus `k4`'s mechanism decisions, each
   with its rejected alternatives and the evidence that decided it. Rejected options are load-bearing:
   without them the build grove re-opens settled ground.
4. **The evidence base** — the motivating measurements (per-target emit LOC, the shared-substrate
   ratio, the datalog and template-engine facts), pointers to the two research docs, and the
   audit's residual-Rust estimates.
5. **Risks, honestly ranked, escape-hatch first.** The escape-hatch question is the build grove's
   first-order risk and must be named as such, with what evidence would settle it. Also: the
   ADR-0047 compile-time-rules vs per-target-authored-rules tension; the chez no-goldens gap;
   the TypeScript outlier.
6. **Open questions** — everything `k4` could not settle, with what would settle each.
7. **ADR work the build grove owes** — which ADRs it will need to mint (next free number **0062**)
   and, critically, which existing ADRs it must **rework in place** rather than supersede.
   ADR-0047 is the likely one if runtime rules win.
8. **A proposed decomposition** for the build grove, framed as a proposal it may reject.

## Done when

- `TODO.language-model-transforms.md` exists at the repo root and covers all eight sections.
- It is **self-contained**: no load-bearing content reachable only via `.grove/`. Verify by
  grepping the doc for `.grove` references and removing or inlining each.
- Every measurement in it is either re-verified this session or explicitly dated and attributed
  to the leaf that measured it. Stale numbers presented as current are the failure mode here.
- Nothing was added to `CONTEXT.md` or `adr/` (charter Q6).

## Notes

Write for a reader who is skeptical and in a hurry: they will decide whether to start a grove
off this doc. Lead with the charter and the risk, not the reasoning chain.

Do not soften the escape-hatch risk to make the design look better. `plan-k1` recorded that a
pilot was recommended and the design-only charter chosen instead; the honest consequence is that
this doc hands over an untested thesis, and saying so plainly is what makes it usable.

Resist scope creep into building anything. If drafting surfaces a design hole, record it as an
open question — or `leaf-insert` a leaf ahead of `k6` if it needs real work — rather than
solving it inline.
