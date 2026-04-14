# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Supports ObjC class/protocol/enum extraction and C function/enum/
constant extraction including function pointer typedefs.

All major pipeline capabilities are complete. The core is in maintenance mode — new tasks
emerge reactively as target app development reveals edge cases or gaps.

## Task Backlog

The core pipeline is in maintenance mode. Tasks below are reactive — each one
was surfaced either by a runtime failure in a language target or by a memory
entry triaged during a prior cycle. Provenance is recorded per-task in the
"Surfaced by" / "Promoted from" field. Priority ordering at the top of a
pending cluster is `high → medium → low`; within a priority band, the
listing order is a suggested work order, not a hard constraint.

### Auto-regenerate analysis + generation at the top of every work session `[tooling]`
- **Status:** done (2026-04-14)
- **Priority:** high — promoted from medium on 2026-04-14. The
  2026-04-13 "Constants flagged in `skipped_symbols` still reach final
  IR" work phase just dissolved into a single pipeline regeneration,
  and the pre-existing "Regenerate collected IR before using it as
  evidence" memory entry did not prevent it — the LLM wrote the
  reinforced mode-6 "Wrong temporal frame" lesson *during* the wasted
  cycle, not before it. This is direct evidence that a memory-only
  guardrail is insufficient: the same failure mode will recur on the
  next cycle that forms a fix hypothesis against stale downstream
  checkpoints. A shell-level preamble in `run-backlog-plan.sh` (or this
  project's `prompt-work.md`) is the only guardrail that cannot be
  skipped by the work-phase LLM forgetting to check mtimes. Every
  recurrence still costs one full work phase per downstream target that
  stumbles over the drift; 2–3 minutes of CPU at session start is
  dramatically cheaper than paying 30+ minutes of investigation per
  recurrence.
- **Surfaced by:** 2026-04-13 session post-mortem on Task 1 + user
  feedback ("We should aggressively regenerate to avoid issues like
  this"), saved as memory
  `feedback_regenerate_pipeline_aggressively.md`.
- **Description:** Bake pipeline regeneration into the work-phase bootstrap
  so stale `analysis/ir/{resolved,annotated,enriched}/` and
  `generation/targets/*/generated/` checkpoints cannot survive across
  sessions. Currently, all four checkpoint dirs and every emitter's
  `generated/` tree are gitignored, so drift between source filters and
  on-disk artifacts has zero git-diff signal and is invisible until a
  downstream harness happens to exercise an affected symbol.
- **Suggested investigation (hypothesis — verify before fixing):**
  - The lightest-touch hook is a preamble added to
    `LLM_CONTEXT/run-backlog-plan.sh` (the canonical script) or to the
    per-plan `prompt-work.md` that runs
    `cargo run -p apianyware-macos-analyze` and
    `cargo run -p apianyware-macos-generate` before `claude` is invoked.
    Preferred over a prompt-level instruction: the prompt can be ignored
    or misread, the shell step cannot.
  - Consider a freshness check instead of unconditional rerun: compare
    newest mtime of `collection/crates/extract-*/src/**`,
    `analysis/crates/{resolve,annotate,enrich}/src/**`, and
    `generation/crates/emit-*/src/**` against oldest mtime of
    `analysis/ir/enriched/*.json` / `generation/targets/*/generated/`.
    Only rerun when source is newer than the oldest artifact. Saves 2–3
    minutes on no-op sessions while still catching real drift.
  - Decide the scope: run the analysis pipeline always (cheap,
    deterministic) but keep generation per-target so a racket-oo-only
    session doesn't pay for all emitters. Note that `generate` doesn't
    currently support framework filtering — it loads all frameworks
    from `input_dir` and emits all of them — so the scoping lever is
    `--lang`, not `--only`.
  - LLM annotations must not be clobbered. The annotate pass already
    preserves them via `load_existing_annotations()` in
    `analysis/crates/annotate/src/lib.rs` when `--llm-dir` is omitted,
    so rerunning is safe. Verify this holds on a live run before
    wiring the bootstrap.
  - Cross-project implication: the same pattern applies to sibling
    projects using the same `run-backlog-plan.sh`. Either solve it in
    the shared script with a project-local opt-in manifest, or copy
    the preamble into this project's `prompt-work.md` only. Prefer the
    former if the shared script grows a standard "project setup"
    hook, otherwise start project-local and promote later.
  - Consider whether the regeneration preamble should *also* kick off
    `cargo run -p apianyware-macos-collect` when SDK headers change,
    or whether that's too heavy-handed for every session. The SDK
    mtime under `/Applications/Xcode.app/Contents/Developer/Platforms/
    MacOSX.platform/Developer/SDKs/` is a reasonable freshness signal
    but collection is the most expensive step (~2 minutes on its own),
    so a weekly/daily policy may be more appropriate than every session.
- **Results:**
  - Chose the **shared-script-with-opt-in-hook** path over editing
    `prompt-work.md`: shell-level enforcement cannot be skipped by an
    LLM that forgets to read instructions, and the hook is generic
    enough that all 12 sibling plans across 5 projects are unaffected
    (no `pre-work.sh` = no-op).
  - Added a generic pre-work hook to
    `~/Development/LLM_CONTEXT/run-backlog-plan.sh`: if
    `<plan-dir>/pre-work.sh` exists and is executable, the shared
    script runs it from the project root before launching the
    work-phase `claude` session. Hook failure aborts the cycle.
  - Wrote `analysis/scripts/regenerate-stale-pipeline.sh` (the actual
    freshness-checked regen logic). Lives alongside `llm-annotate.sh`
    in the existing pipeline scripts dir. Two stages — analyze and
    generate — each gated on a `newest input mtime > newest output
    mtime` comparison. Skips collection (gated on SDK changes, manual
    decision per task description).
  - Wrote two project-local shims:
    `LLM_STATE/core/pre-work.sh` (all targets) and
    `LLM_STATE/targets/racket-oo/pre-work.sh` (`--lang racket-oo` so
    racket-oo-only sessions don't pay for other emitters). Both are
    one-line `exec` shims into the shared regen script.
  - **Two non-obvious bugs caught during verification, both worth
    recording in memory:**
    - Initial design used "newest input > **oldest** output" as the
      stale rule. This caused perpetual stale detection on `racket-oo`
      because Racket's `raco make` writes `.zo`/`.dep` bytecode under
      `generated/oo/*/compiled/` with mtimes unrelated to the Rust
      generator, and the Rust generator orphans files from prior
      generator versions (e.g., `avrouting/constants.rkt` from a
      previous run that the current generator no longer emits). Both
      classes of files have older mtimes than current source and would
      register as forever-stale. Fix: switched to "newest input >
      **newest** output" — if any file in the output tree is newer
      than the newest input, the output cannot be globally stale.
      Also added `*/compiled/*` exclusion to find for defense-in-depth.
    - `racket-functional` has no `generated/` dir at all (stub
      emitter). My initial "missing dir = stale" rule would have
      triggered an infinite regen loop. Fix: skip targets without a
      `generated/` dir — the freshness hook is a drift guardrail, not
      a first-time setup tool. First-time generation is still a
      manual `cargo run` step.
  - Verified end-to-end:
    - No-op runs: 0.5s (all `find` / `stat`, no cargo).
    - Touching a `generation/crates/emit-racket-oo/src/*.rs` file
      triggers only `generate`, not `analyze`.
    - Touching an `analysis/crates/enrich/src/*.rs` file triggers
      both `analyze` and `generate` (correct: downstream stage must
      follow upstream change).
    - LLM annotation preservation not exercised in verification
      because no `*.llm.json` files exist yet under
      `analysis/ir/annotated/`. Safety relies on the existing
      `load_existing_annotations()` documented in the
      "LLM annotation flows through a dedicated input directory"
      memory entry.

### Platform-availability filter for ObjC methods, classes, protocols `[collection]`
- **Status:** not_started
- **Priority:** medium — different failure mode from the two `dlsym` leaks
  above. These leaks fail at *call time* (Objective-C runtime: "selector not
  recognized" / "class not found"), not at library *load time*, so they don't
  block racket-oo's `dynamic-require` harness and aren't on the critical path
  for sample-app work. They will, however, surface as runtime crashes the
  first time a generated binding actually invokes one.
- **Promoted from:** "scope left open for triage" note on the closed
  "Platform-unavailable `extern` symbols" task (2026-04-13). Promoted now
  rather than left buried per the "lift embedded blockers to top-level
  tasks" rule.
- **Description:** `is_unavailable_on_macos(entity)` is currently called only
  from `extract_constant` and `extract_function` in
  `extract-objc/src/extract_declarations.rs`. The same predicate is not yet
  applied in `extract_method`, `extract_class`, or `extract_protocol`, so
  ObjC declarations marked `API_UNAVAILABLE(macos)` on otherwise-available
  parents (or wholesale macos-unavailable classes/protocols) still flow into
  the IR and emit bindings that will crash on first use.
- **Suggested investigation (hypothesis — verify before fixing):**
  - The fix probably mirrors the existing extern path one-for-one: call
    `is_unavailable_on_macos` immediately after the existing `Linkage`
    / cursor-kind gates in each extractor, returning `None` on match.
  - Methods are the trickiest case: a class can be macos-available while
    individual selectors are not. Confirm libclang exposes
    `get_platform_availability()` at method granularity (it should, but
    verify with a synthetic fixture) before assuming the same code path
    works.
  - Use the **stash → re-collect → diff** procedure from memory to measure
    blast radius across all 283 frameworks before committing. The extern
    filter removed 1,738 symbols from 56 frameworks; this filter likely
    has a similar order of magnitude on the method side, where iOS-only
    selectors are common in shared headers.
  - Add per-decl-kind regression tests in
    `collection/crates/extract-objc/tests/filter_platform_unavailable.rs`,
    extending the existing `SyntheticSdk` scaffolding to cover macos-only,
    visionos-only-multi-platform, and partial-class shapes.
  - Decide whether class-level `API_UNAVAILABLE(macos)` should drop the
    entire class (and any methods/properties hanging off it) versus just
    flagging it. The cleaner option is probably wholesale drop, matching
    how AppKit's iOS-family symbols are silently absent from the macOS
    dylib today — but record the decision in memory once made.
- **Results:** _pending_

### Golden-test coverage for C-heavy framework shapes `[testing]`
- **Status:** not_started
- **Priority:** medium — no active bug blocked on this, but the absence of
  this coverage is the meta-reason *every* extraction-time leak landed on
  this project so far (Swift-native symbols, `c:@macro@` macro cursors,
  platform-unavailable externs, `c:@Ea@`/`c:@EA@` anonymous-enum members)
  was first surfaced by runtime `dlsym` / `get-ffi-obj` failures in
  racket-oo's load harness rather than by `cargo test`. The next filter
  leak in this class will land the same way until this gap closes.
- **Promoted from:** "Golden-test framework coverage is biased toward
  Foundation/AppKit" memory entry, which explicitly flags this as a backlog
  candidate whenever a new leak in a C-heavy framework lands. Four such
  leaks have now landed (most recently the anonymous-enum-member filter
  during the 2026-04-13 cycle) without a single one being caught in CI;
  the meta-gap is now load-bearing enough to own a task rather than stay
  a drifting note.
- **Description:** The curated golden-test subset and the synthetic
  `TestKit` fixture in `generation/crates/emit-racket-oo/tests/` both model
  Foundation- and AppKit-shaped APIs: ObjC classes, protocols, named
  enums, category properties. They do not exercise the structural quirks
  of C-heavy frameworks — Network's anonymous typedef'd enums
  (`c:@EA@` family), AudioToolbox's internal-linkage `static inline`
  helpers, CoreText's macro-derived version constants, CoreMIDI's
  availability-gated selectors. Add representative fixtures covering
  these shapes so regressions in any of the four already-landed filter
  classes, plus the two still-pending ones (`skipped_symbols` constants
  leak, ObjC method-level platform availability), land in CI rather
  than in downstream language-target harnesses.
- **Suggested investigation (hypothesis — verify before fixing):**
  - Decide first: extend the real golden set (add a curated Network or
    AudioToolbox subset alongside `golden-foundation/`) vs expand the
    synthetic `TestKit` fixture. The existing memory guidance ("Prefer
    synthetic tests over external-data-dependent tests") leans synthetic
    for filter-logic coverage; reserve real-SDK golden tests for
    integration-level extraction fidelity.
  - A synthetic "TestNetwork" (or single-file addition to `TestKit`)
    could cover all four landed leak classes with one declaration per
    class: a `static const` (internal linkage), an
    `API_UNAVAILABLE(macos)` function, a `#define` macro cursor reaching
    `Var` via the Swift digester path, and a `typedef enum { … } Foo_t;`
    anonymous-enum-member shape. Each regression fires on a different
    filter; one fixture catches all four.
  - Scope is bounded: the goal is *structural* coverage for filter
    regressions, not exhaustive framework modelling. Resist growing the
    new fixture into a second TestKit.
  - Confirm the fixture is exercised by both the extraction tests and
    the emitter golden tests — a regression that reaches the emitter
    but not the collector (or vice versa) is still a diagnostic gap.
  - Once coverage lands, sharpen or narrow the
    "Golden-test framework coverage is biased toward Foundation/AppKit"
    memory entry — the meta-observation it captures will have a
    concrete test-suite anchor and no longer need to stand alone as a
    disembodied warning.
- **Results:** _pending_

### Surface ObjC silent-filter decisions into `skipped_symbols` `[observability]`
- **Status:** not_started
- **Priority:** low — defensive / auditability. No active bug; flagged for
  triage by the "Silent filters create an observability gap vs
  skipped_symbols" memory entry so the design tension doesn't get
  rediscovered later. Schedule after the two outstanding `dlsym` leaks
  above, since the extra recording is most useful once filter coverage
  is stable.
- **Description:** extract-objc's filter classes (`Linkage::Internal`,
  `is_unavailable_on_macos`, and any platform-availability extension to
  methods/classes/protocols from the task above) currently return `None`
  silently — the ~1,738 platform-availability removals and the handful of
  internal-linkage removals per framework are invisible post-hoc.
  extract-swift's `non_c_linkable_skip_reason`, by contrast, records every
  dropped node into `skipped_symbols` with a human-readable reason. Bring
  extract-objc to the same standard so audit tooling can answer "what got
  filtered from this framework, and why" uniformly across both pipelines.
- **Suggested investigation (hypothesis — verify before fixing):**
  - extract-swift records into `skipped_symbols` partly because `merge.rs`
    needs the cross-pipeline record for dedup. extract-objc has no
    equivalent merge consumer, so check whether *appending* (not replacing)
    to `skipped_symbols` from the ObjC side produces any double-counts when
    a symbol is filtered by both pipelines independently — NSLog and
    NSApplicationMain are the documented benign cases to verify against.
  - Decide on a uniform reason vocabulary across both extractors
    (`internal_linkage`, `platform_unavailable_macos`, `swift_native`,
    `preprocessor_macro`, …) rather than letting each filter coin its own
    string. A small enum or `&'static str` table is fine; the value is
    that downstream audit tooling can match on it.
  - Once recording lands, sharpen or remove the
    "Silent filters create an observability gap" memory entry — the design
    tension it documents will no longer exist.
- **Results:** _pending_

## Completed Tasks

The "Auto-regenerate analysis + generation at the top of every work session"
task above is `done` (2026-04-14) and awaits triage cleanup once reflect has
distilled its learnings into memory. Triage should remove it from the
backlog entirely.
