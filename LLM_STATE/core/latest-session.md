### Session N (2026-04-14T02:26:56Z) — Auto-regenerate stale pipeline before each work phase
- Implemented the high-priority "Auto-regenerate analysis + generation at the
  top of every work session" task. Goal: prevent the stale-checkpoint failure
  mode where a downstream task forms a fix hypothesis against drifted
  artifacts. Memory-only guardrails proved insufficient on 2026-04-13 — the
  LLM wrote the "Wrong temporal frame" lesson *during* the wasted cycle, not
  before it.
- **Design choice: shared-script-with-opt-in-hook.** Modified
  `~/Development/LLM_CONTEXT/run-backlog-plan.sh` to add a generic pre-work
  bootstrap: if `<plan-dir>/pre-work.sh` exists and is executable, run it
  from the project root before launching the work-phase claude session.
  Hook failure aborts the cycle. Verified that none of the 12 sibling plans
  across 5 projects have a `pre-work.sh`, so they are unaffected.
- **Regen logic in a dedicated script.** Wrote
  `analysis/scripts/regenerate-stale-pipeline.sh` (lives alongside
  `llm-annotate.sh` in the existing pipeline scripts dir). Two stages:
  - **analyze**: inputs are
    `analysis/crates/{datalog,resolve,annotate,enrich,cli}/src` +
    `collection/crates/types/src` + `collection/ir/collected`. Output:
    `analysis/ir/enriched`. Stale rule fires when newest input mtime >
    newest output mtime.
  - **generate**: inputs are `generation/crates/{emit,emit-*,cli}/src` +
    enriched IR newest mtime. Output: `generation/targets/{lang}/generated`.
    Per-target staleness check, scoped via `--lang` to avoid paying for
    other emitters during target-specific sessions.
  - Skipped: collection. Per the task description, it costs ~2 minutes
    and is gated on SDK header changes which are a manual decision.
- **Project-local shims.**
  - `LLM_STATE/core/pre-work.sh` — `exec ./analysis/scripts/regenerate-stale-pipeline.sh`
  - `LLM_STATE/targets/racket-oo/pre-work.sh` — `exec ./analysis/scripts/regenerate-stale-pipeline.sh --lang racket-oo`
  - Both are executable, both use `set -euo pipefail` + `exec`.
- **Two non-obvious bugs caught during verification, both surprising:**
  - **"Newest input > oldest output" was the wrong rule.** Initial
    design used oldest-output as the comparison point. This caused
    perpetual stale detection on `racket-oo` for two independent
    reasons: (1) Racket's `raco make` writes `.zo`/`.dep` bytecode under
    `generated/oo/*/compiled/` with mtimes unrelated to the Rust
    generator, and (2) the Rust generator orphans files from prior
    generator versions — e.g., `generated/oo/avrouting/constants.rkt`
    from a prior run that the current generator no longer produces.
    Both classes of files have older mtimes than current source and
    register as forever-stale under the oldest-output rule. Switched
    to "newest input > newest output": if any file in the output tree
    is newer than the newest input, the output cannot be globally
    stale. Also added `*/compiled/*` exclusion to `find` for
    defense-in-depth.
  - **Stub emitters break "missing dir = stale".** `racket-functional`
    has no `generated/` dir at all because its emitter is a registered
    stub. Initial design treated missing dir as "definitely stale and
    must regen" — would have triggered an infinite regen loop on every
    session because the regen never produces a `generated/` dir. Fix:
    skip targets without an existing `generated/` dir entirely. The
    freshness hook is a drift guardrail, not a first-time setup tool.
    First-time generation remains a manual `cargo run` step.
- **Verified end-to-end:**
  - No-op runs complete in 0.5s (all `find` / `stat`, no cargo).
  - Touching `generation/crates/emit-racket-oo/src/lib.rs` triggers
    only `generate`, not `analyze`. Confirmed scoping correct.
  - Touching `analysis/crates/enrich/src/program.rs` triggers both
    `analyze` and `generate` (downstream stage must follow upstream
    change — confirmed correct).
  - Both shims (`core/pre-work.sh` and `targets/racket-oo/pre-work.sh`)
    work correctly when invoked through `cd $PROJECT && ./LLM_STATE/.../pre-work.sh`,
    matching how the shared script invokes them.
  - LLM annotation preservation not exercised: no `*.llm.json` files
    exist yet under `analysis/ir/annotated/`. Safety relies on the
    existing `load_existing_annotations()` documented in the
    "LLM annotation flows through a dedicated input directory" memory
    entry.
- **Key learnings to distill in reflect:**
  - The "newest input > newest output" rule is the right freshness
    check pattern for codegen pipelines where the generator may
    orphan files from prior versions and where downstream tools (raco
    make, etc.) write artifacts the freshness check shouldn't see.
    "Oldest output" is a tempting wrong answer because it sounds more
    conservative.
  - Stub emitters break naive "missing output = stale" rules. Drift
    guardrails should not double as first-time bootstrap mechanisms.
  - The shared `run-backlog-plan.sh` now has a generic pre-work hook
    point. Future cross-cutting bootstrap concerns (env var setup,
    secret refresh, etc.) can use the same `<plan-dir>/pre-work.sh`
    convention without further script changes.
  - Cross-project blast radius of the shared script change: zero
    (verified — 0 of 12 sibling plans have a `pre-work.sh`).
- **What this suggests trying next:** The medium-priority
  "Platform-availability filter for ObjC methods, classes, protocols"
  task is now the natural next pick. The freshness hook will protect
  any future "wrong temporal frame" recurrences during that work,
  including the stash → re-collect → diff blast-radius procedure
  (which still requires a manual `cargo run -p apianyware-macos-collect`
  by design, since collection is not auto-regenerated).
