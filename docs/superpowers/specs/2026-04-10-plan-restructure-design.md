# Design: Plan Structure and Workflow Rationalization

## Problem

APIAnyware's current plan system has a monolithic milestone-based plan (`LLM_STATE/plan.md`) that mixes core pipeline work with target-specific work, uses rigid sequential ordering, and doesn't reflect how the project actually develops — exploratory, incremental, with tasks emerging from doing the work.

Additionally, the Modaliser-Racket project exposed that the pipeline needs C API extraction (C functions, enums, constants, callback types) alongside the existing ObjC class extraction. C bindings will be a new "style" within each target, sharing the target's runtime.

The plan system needs to:
1. Separate core pipeline work from target-specific work so they can proceed independently
2. Use backlog-style plans (mutable task lists with triage) instead of rigid milestone sequences
3. Make the state-of-play obvious — what's done, what's active, what's blocked
4. Create a shared backlog-plan architecture doc in `LLM_CONTEXT/` that plans reference

## Scope

### In scope
- Restructure `LLM_STATE/` directory layout
- Create core pipeline plan (backlog-style)
- Create target plan template (backlog-style with category groupings)
- Migrate current racket-oo plan to new format
- Create `overview.md` status dashboard
- Create `../LLM_CONTEXT/backlog-plan.md` — the architecture doc describing the methodology
- Replace `../LLM_CONTEXT/create-a-multi-session-plan.md` with a short pointer to `backlog-plan.md`
- Remove all project-specific skills (`/begin-work`, `/reflect`, `/add-app`, `/add-target`, `/create-plan`)
- Delete old monolithic `plan.md`

### Out of scope
- Implementing C API extraction in the pipeline (that becomes a task in the core backlog)
- Changes to the knowledge system (5-axis structure stays as-is)
- Changes to the observational-memory plugin infrastructure (just removing this project's skills from it)

## Design

### 1. Directory Layout

```
LLM_STATE/
├── overview.md                    # status dashboard (not a plan)
├── core/
│   └── plan.md                    # core pipeline backlog
├── targets/
│   ├── template.md                # parameterized template for new target plans
│   └── racket-oo/
│       └── plan.md                # racket-oo target backlog
```

The following are deleted:
- `LLM_STATE/plan.md` (monolithic master plan)
- `LLM_STATE/plans/` (old plans directory, including `racket-oo/plan.md` and `plan-template.md`)

### 2. Architecture: `../LLM_CONTEXT/backlog-plan.md`

A new shared document that describes the backlog-plan methodology. This is the single source of truth for how plans work — individual plans reference it rather than repeating the methodology.

Contents:
- **Philosophy** — exploratory, incremental development; tasks emerge from doing the work; triage replaces rigid ordering
- **Work cycle** — the REVIEW → DECIDE → IMPLEMENT → VERIFY → REFLECT → UPDATE loop
- **Task format** — status (`not_started | in_progress | done | blocked`), category (for grouping, not ordering), dependencies (inputs to triage, not hard gates), description, results
- **Session log format** — append-only, dated entries recording what was done and learned
- **Continuation prompt conventions** — must reference `LLM_CONTEXT/index.md`, must reference `backlog-plan.md` for the work cycle, must point to the plan file itself
- **Plan file structure** — three sections only: continuation prompt, task backlog, session log

This replaces `create-a-multi-session-plan.md` (which described rigid sequential plans). That file becomes a short pointer to `backlog-plan.md`.

### 3. Plan File Format (All Plans)

Each plan is pure data — three sections, no methodology:

```markdown
# <Plan Title>

<2-3 sentence summary of what this plan covers and its current focus.>

## Session Continuation Prompt

\```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: <Plan Title>

Read `LLM_STATE/<path>/plan.md`.

<any plan-specific instructions — e.g., test commands, 
key constraints, domain-specific triage guidance>
\```

## Task Backlog

<mutable task list — see backlog-plan.md for format>

## Session Log

<append-only dated entries — see backlog-plan.md for format>
```

Plans are lean. The methodology lives in `backlog-plan.md`; the plan file holds only the data and any plan-specific instructions that supplement the standard work cycle.

### 4. Core Pipeline Plan

The core plan covers everything that feeds all targets: collection, analysis, enrichment, testing infrastructure.

Task categories: `[collection]`, `[analysis]`, `[enrichment]`, `[testing]`, `[infra]`

Initial backlog (migrated from current state + post-M9 review + Modaliser findings):

- **C function extraction** `[collection]` — extract C functions from framework headers (CGEventTapCreate, CFRunLoopAddSource, etc.)
- **C enum/constant extraction** `[collection]` — extract C enums, bit flags, opaque pointer constants (kCFRunLoopCommonModes, etc.)
- **C callback type extraction** `[collection]` — extract function pointer typedefs (CGEventTapCallBack, etc.)
- **Framework ignore list** `[collection]` — explicitly mark inappropriate frameworks (DriverKit, Tk) as ignored
- **LLM annotation integration** `[analysis]` — make LLM annotation a proper pipeline step, not external scripts
- **Test coverage hardening** `[testing]` — comprehensive testing across the entire pipeline
- **Enrichment verification** `[enrichment]` — prevent bugs like global totals written to every framework

Dependencies are noted on individual tasks (e.g., C enum extraction may depend on C function extraction sharing infrastructure).

### 5. Target Plan

Each target plan covers: emitter crate, runtime, generated bindings, apps, and validation for one language+paradigm combination.

Task categories: `[foundation]`, `[coverage]`, `[apps]`, `[testing]`, `[docs]`

Categories help with triage — you'd generally focus on `[foundation]` tasks before `[apps]` tasks, but it's a judgment call, not a gate.

When a target discovers it needs something from the core pipeline (e.g., "we need C function extraction to emit C-API bindings"), it creates a task in its own backlog marked `blocked` with a dependency on the core plan, and optionally notes the need in the core plan's backlog.

#### C-API as a style

Each target can have multiple binding styles. Currently racket-oo has `oo` and `functional`. The new `c-api` style generates bindings for C functions, enums, constants, and callback types. It shares the target's runtime and Swift dylib.

The `c-api` style tasks appear in target plans under `[coverage]`, with dependencies on core pipeline C extraction tasks.

### 6. Overview Dashboard

`overview.md` is not a plan — it's a concise status view updated at session boundaries.

```markdown
# APIAnyware Status

## Core Pipeline
| Area | Status | Notes |
|------|--------|-------|
| ObjC class collection | done | |
| C function collection | not started | |
| C enum/constant collection | not started | |
| C callback collection | not started | |
| Resolution | done | |
| Annotation | done | needs LLM integration |
| Enrichment | done | needs hardening |

## Targets
| Target | Status | Styles | Apps | Notes |
|--------|--------|--------|------|-------|
| racket-oo | active | oo | 3/7 | Phase: apps |
| racket-functional | not started | functional | 0/7 | |

## Cross-Cutting Blockers
- C-API style for all targets blocked on core C extraction tasks
- racket-functional blocked on functional emitter implementation
```

### 7. Remove All Project-Specific Skills

Delete all skills: `/begin-work`, `/reflect`, `/add-app`, `/add-target`, `/create-plan`.

Their functionality is replaced by:
- **Starting a session** — copy the continuation prompt from the plan file (documented in `backlog-plan.md`)
- **Creating a plan** — follow instructions in `create-a-multi-session-plan.md` (a prompt exemplar, not a skill)
- **Adding a target** — follow `new-language-guide.md`
- **Adding an app** — follow the app spec template in `knowledge/apps/`
- **Promoting learnings** — append to the session log during the work cycle (part of the REFLECT → UPDATE step)

### 8. CLAUDE.md Updates

Update the project's `CLAUDE.md` to reflect the new structure:
- Point to `LLM_STATE/overview.md` for status
- Point to `LLM_STATE/core/plan.md` for pipeline work
- Point to `LLM_STATE/targets/{target}/plan.md` for target work
- Remove all skill references
- Remove references to milestone-based progression
- Reference `backlog-plan.md` for the work methodology

### 9. `create-a-multi-session-plan.md`

The existing `../LLM_CONTEXT/create-a-multi-session-plan.md` is rewritten as a **plan creation script** — instructions for Claude on how to produce a new backlog plan. It is not just a pointer to `backlog-plan.md`; it is the process for populating one.

The creation script:
1. **Clarify with the user** — ask what the plan is for, what the scope is, what's already known, what the initial tasks are. This is a conversation, not a template fill.
2. **Elicit the initial backlog** — help the user identify tasks, categories, known dependencies, and any plan-specific instructions for the continuation prompt.
3. **Produce the plan file** — conforming to the format defined in `backlog-plan.md` (continuation prompt, task backlog, session log). Write it to `LLM_STATE/`.
4. **Reference `backlog-plan.md`** — the created plan's continuation prompt references `backlog-plan.md` for the work cycle methodology, so the plan file stays lean.

This keeps the two documents complementary: `backlog-plan.md` defines what a plan *is*; `create-a-multi-session-plan.md` defines how to *make* one.

### 10. Migration

Learnings from the current `plan.md` and `racket-oo/plan.md` are preserved:
- The 26 racket-oo learnings move to the new `targets/racket-oo/plan.md` session log
- Pipeline-relevant learnings move to `core/plan.md` session log
- Task status is migrated: completed items are noted as done, remaining items become backlog tasks

The `new-language-guide.md` is kept as reference material (it's a how-to guide, not a plan).
