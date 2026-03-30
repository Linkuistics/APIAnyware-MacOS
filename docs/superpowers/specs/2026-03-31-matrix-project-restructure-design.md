# Matrix Project Restructure: Directory Layout, Knowledge System, and Observational Memory

## Overview

APIAnyware-MacOS is a three-phase pipeline (collect, analyse, generate) that produces idiomatic
macOS bindings for non-mainstream languages. The project is entering a scaling phase: multiple
language+paradigm targets, a growing suite of sample applications (from simple to the Modaliser
capstone), and shared testing infrastructure via TestAnyware.

This spec redesigns the project's organisational structure for scale. The three core problems:

1. **Target identity**: language+paradigm combinations are distinct targets, not sub-levels of a
   language. `racket-oo` and `racket-functional` are as independent as `racket-oo` and `haskell-monadic`.

2. **Knowledge management**: discoveries happen along five axes (pipeline, TestAnyware, app-universal,
   target-universal, app-x-target). Currently there is no structured system for capturing, routing,
   or consulting these learnings across the N-targets x M-apps matrix.

3. **Workflow enforcement**: Claude (the LLM) is the primary implementer. The system must ensure
   learnings are captured (observational memory) and consulted (CLAUDE.md routing) without relying
   on the LLM remembering to do so.

---

## 1. Directory Structure

### Design principle

Each language+paradigm combination is a **target** — a top-level directory with its own emitter
crate, runtime, apps, tests, and generated output. No paradigm sub-level exists. Knowledge lives
in a parallel centralised tree, not co-located with code.

### Layout

```
generation/
├── targets/
│   ├── racket-oo/                          # One target = one top-level directory
│   │   ├── CLAUDE.md                       # Auto-loads: routes to knowledge files
│   │   ├── crate/                          # emit-racket-oo (Rust emitter crate)
│   │   │   ├── src/
│   │   │   ├── tests/
│   │   │   └── Cargo.toml
│   │   ├── runtime/                        # Target-language runtime modules
│   │   ├── generated/                      # Output: one dir per framework
│   │   │   ├── appkit/
│   │   │   └── foundation/
│   │   ├── apps/                           # Sample app implementations
│   │   │   ├── CLAUDE.md                   # Routes to app-level knowledge
│   │   │   ├── hello-window/
│   │   │   │   └── CLAUDE.md              # Routes to all relevant knowledge axes
│   │   │   ├── counter/
│   │   │   │   └── CLAUDE.md
│   │   │   ├── modaliser/                  # Capstone app
│   │   │   │   └── CLAUDE.md
│   │   │   └── ...
│   │   ├── test-results/                   # TestAnyware evidence (screenshots, reports)
│   │   └── tests/                          # Language-side smoke tests
│   ├── racket-functional/                  # Separate target, same shape
│   │   └── ...
│   ├── haskell-monadic/                    # Future targets follow same shape
│   └── chez-functional/
│
├── crates/
│   ├── emit/                               # Shared emitter framework (unchanged)
│   ├── emit-racket-oo/                     # Was emit-racket, now target-specific
│   ├── emit-racket-functional/             # New: separate crate (stub initially)
│   └── cli/                                # Emitter registry, orchestration
│
└── swift/                                  # Shared Swift dylibs (unchanged)

knowledge/                                  # Centralised knowledge base
├── CLAUDE.md                               # Index: explains axes, navigation rules
├── pipeline/                               # Axis 1: collection/analysis discoveries
│   ├── collection.md
│   ├── analysis.md
│   └── type-mapping.md
├── testanyware/                            # Axis 2: GUI testing strategies
│   ├── general.md                          # Universal TestAnyware learnings + workflow
│   └── strategies/                         # Per-app-type testing patterns
│       ├── menu-bar-apps.md
│       ├── document-apps.md
│       └── modal-overlay-apps.md
├── apps/                                   # Axis 3: app-universal knowledge
│   ├── _index.md                           # App catalogue, progression order
│   ├── hello-window/
│   │   ├── spec.md                         # The app specification
│   │   ├── learnings.md                    # Language-independent discoveries
│   │   └── test-strategy.md               # TestAnyware strategy for this app type
│   ├── counter/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   ├── ui-controls-gallery/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   ├── file-lister/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   ├── text-editor/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   ├── mini-browser/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   ├── menu-bar-tool/
│   │   ├── spec.md
│   │   ├── learnings.md
│   │   └── test-strategy.md
│   └── modaliser/
│       ├── spec.md                         # Derived from the POC (../Modaliser)
│       ├── learnings.md
│       ├── test-strategy.md
│       └── config-patterns.md              # Language-independent config design learnings
├── targets/                                # Axis 4: target-universal knowledge
│   ├── racket-oo.md
│   └── racket-functional.md
└── matrix/                                 # Axis 5: app x target intersection
    ├── counter/
    │   ├── racket-oo.md
    │   └── racket-functional.md
    ├── modaliser/
    │   └── racket-oo.md
    └── ...

LLM_CONTEXT/                                # Project-wide instructions (enhanced)
├── index.md                                # Entry point
├── coding-style.md                         # Coding conventions (existing)
├── create-a-multi-session-plan.md          # Plan format (updated for Observe phase)
├── project-workflow.md                     # NEW: master reference document
└── improve-these-crates.md                 # Template prompt (existing)

LLM_STATE/                                  # Active plans
├── plans/
│   ├── racket-oo/
│   │   ├── plan.md                         # Target-level plan
│   │   ├── counter.md                      # App-specific plan
│   │   └── modaliser.md
│   └── racket-functional/
│       └── plan.md
├── plan.md                                 # Overall project plan (existing, updated)
└── plan-template.md                        # Template for new target plans
```

### What stays unchanged

- `collection/` and `analysis/` directories (pipeline)
- `generation/crates/emit/` (shared emitter framework)
- `swift/` (shared Swift dylibs — used by all targets)
- The `LanguageEmitter` trait and `BindingStyle` enum in the shared emit crate

---

## 2. CLAUDE.md Hierarchy and Knowledge Routing

### Design principle

Claude Code auto-loads CLAUDE.md files from every parent directory when working on a file. This
is the **only** mechanism that guarantees context is loaded without relying on LLM discipline.
Each CLAUDE.md is a routing file — small, containing pointers to knowledge files, not knowledge
itself.

### The chain

When editing `generation/targets/racket-oo/apps/counter/main.rkt`, four CLAUDE.md files load:

1. **Root CLAUDE.md** — project overview, skill references, "read project-workflow.md"
2. **`targets/racket-oo/CLAUDE.md`** — target identity, pointer to target learnings and plan
3. **`targets/racket-oo/apps/CLAUDE.md`** — "for any app, read its spec/learnings/test-strategy"
4. **`targets/racket-oo/apps/counter/CLAUDE.md`** — explicit paths to all five knowledge axes

### Root CLAUDE.md additions

The existing root CLAUDE.md gets a new section at the top:

```markdown
## How This Project Is Organised

This is a matrix project: N targets x M apps, with shared pipeline and testing infrastructure.

**Before doing any implementation work**, read `LLM_CONTEXT/project-workflow.md` — it explains
the full workflow, skills, and knowledge system.

**Key directories:**
- `knowledge/` — all learnings, app specs, testing strategies, organised by axis
- `generation/targets/{target}/` — one per language+paradigm combination
- `LLM_STATE/plans/` — active multi-session plans
- `LLM_CONTEXT/` — project-wide instructions and coding standards

**Skills you must use:**
- `/begin-work <target> [app]` — start or continue any implementation work
- `/reflect` — promote observations to the knowledge base (during code review sessions)
- `/add-app <name>` — scaffold a new app across the matrix
- `/add-target <name>` — scaffold a new target across the matrix
```

### knowledge/CLAUDE.md

```markdown
# Knowledge Base

This directory contains all project learnings organised by axis. It is the single source of
truth for discoveries made during implementation.

## Axes

| Axis         | Path              | What goes here                                          |
|--------------|-------------------|---------------------------------------------------------|
| Pipeline     | `pipeline/`       | Collection/analysis discoveries that affect all targets |
| TestAnyware  | `testanyware/`    | GUI testing strategies, reusable across apps/targets    |
| Apps         | `apps/{app}/`     | App specs, language-independent learnings, test strategies |
| Targets      | `targets/{target}.md` | Target-wide learnings (FFI patterns, runtime quirks) |
| Matrix       | `matrix/{app}/{target}.md` | Discoveries specific to one app in one target    |

## Rules

- **Never duplicate** — if a learning applies to a broader axis, put it there, not in a
  narrower file
- **Date entries** — prefix with `**YYYY-MM-DD:**` so staleness is visible
- **Link don't copy** — CLAUDE.md files point here; knowledge is not inlined into CLAUDE.md
- **Promote eagerly** — if a matrix learning turns out to be target-universal, move it up
- **Priority codes** — use 🔴 (critical), 🟡 (useful), 🟢 (informational) on all entries
```

### Target-level CLAUDE.md template

```markdown
# Target: {target}

{One-line description of what this target is.}

## Before working here

1. Read `knowledge/targets/{target}.md` for target-wide learnings
2. Read `LLM_CONTEXT/coding-style.md` for coding conventions
3. Check `LLM_STATE/plans/{target}/plan.md` for current progress

## Target structure

- `crate/` — Rust emitter crate (emit-{target})
- `runtime/` — target-language runtime modules
- `generated/` — output (regenerated, don't edit)
- `apps/` — sample app implementations
- `tests/` — language-side smoke tests
- `test-results/` — TestAnyware evidence
```

### Apps-level CLAUDE.md template

```markdown
# Apps for {target}

Each subdirectory is a sample app implementation. Apps progress from simple to complex,
culminating in Modaliser as the capstone.

## Before working on any app here

1. Read the app spec: `knowledge/apps/{app}/spec.md`
2. Read app-universal learnings: `knowledge/apps/{app}/learnings.md`
3. Read the test strategy: `knowledge/apps/{app}/test-strategy.md`
4. Read matrix learnings: `knowledge/matrix/{app}/{target}.md` (if it exists)
5. Check the plan: `LLM_STATE/plans/{target}/{app}.md` (if it exists)

## All GUI testing uses TestAnyware

Never run apps directly. See `knowledge/testanyware/general.md` for workflow.
```

### Per-app CLAUDE.md template

```markdown
# {App} — {target}

## Required reading

- Spec: `knowledge/apps/{app}/spec.md`
- App learnings: `knowledge/apps/{app}/learnings.md`
- Test strategy: `knowledge/apps/{app}/test-strategy.md`
- Matrix learnings: `knowledge/matrix/{app}/{target}.md`
- Target learnings: `knowledge/targets/{target}.md`
- Active plan: `LLM_STATE/plans/{target}/{app}.md`
```

---

## 3. Knowledge File Formats

### App spec (`knowledge/apps/{app}/spec.md`)

```markdown
# {App Name}

## Purpose
What this app demonstrates and why it exists in the progression.

## Complexity Level
Position in the simple-to-complex progression (e.g. "Level 2 of 8").

## Prerequisites
Which apps should be completed first and why.

## Capabilities Exercised
- Bullet list of macOS/binding capabilities this app tests

## Specification
The actual app spec: window layout, behaviour, UI elements, interactions.

## Platform Compliance Requirements
What "100% platform compliant" means for this specific app type.
```

### App learnings (`knowledge/apps/{app}/learnings.md`)

```markdown
# {App Name} — App-Universal Learnings

Discoveries that apply to this app regardless of which target implements it.

**YYYY-MM-DD:**
- 🔴 {critical discovery}
- 🟡 {useful discovery}
```

### App test strategy (`knowledge/apps/{app}/test-strategy.md`)

```markdown
# {App Name} — TestAnyware Strategy

## Setup
What needs to be installed in the VM, how to launch the app.

## Verification Steps
Ordered checklist: what to check, how to check it (OCR text, click coordinates, etc.)

## Known Timing Issues
Delays or polling requirements.

## Evidence
What screenshots/OCR results constitute a pass.
```

### Target learnings (`knowledge/targets/{target}.md`)

```markdown
# {target} — Target Learnings

## Runtime
Key runtime characteristics and quirks.

## Emitter
Emitter-specific patterns and constraints.

## Dated Discoveries

**YYYY-MM-DD:**
- 🔴 {discovery}
```

### Matrix learnings (`knowledge/matrix/{app}/{target}.md`)

```markdown
# {App} x {target}

**YYYY-MM-DD:**
- 🔴 {discovery specific to this app in this target}
```

### Pipeline learnings (`knowledge/pipeline/{area}.md`)

```markdown
# {Area} Pipeline Learnings

**YYYY-MM-DD:**
- 🔴 {discovery about collection/analysis that affects all targets}
```

### TestAnyware learnings (`knowledge/testanyware/general.md` and `strategies/*.md`)

```markdown
# TestAnyware — General Learnings

Universal GUI testing workflow and discoveries.

## Workflow
The standard process for testing any app in the VM.

## Dated Discoveries

**YYYY-MM-DD:**
- 🔴 {discovery}
```

Strategy files follow the same format but scoped to an app type (e.g. menu-bar apps,
document-based apps, modal overlay apps).

---

## 4. Observational Memory

### Design principle

Adapted from [Mastra's Observational Memory](https://mastra.ai/docs/memory/observational-memory).
Learning capture is **structural, not deliberate** — woven into the workflow so it happens
automatically at mandatory checkpoints, not when the LLM remembers to invoke a skill.

### Three-tier knowledge lifecycle

| Tier                 | Where                              | When written                  | When promoted                        |
|----------------------|------------------------------------|-------------------------------|--------------------------------------|
| **Raw observations** | Plan step's `Observe` field        | After every plan step         | During code review / reflect session |
| **Durable learnings**| `knowledge/` axis files            | During `/reflect`             | When pattern recurs across targets   |
| **Cross-cutting patterns** | Broader `knowledge/` axis   | During `/reflect` when overlap detected | Ongoing as matrix grows       |

### Plan step format

Every plan step has a mandatory three-phase structure: Do, Verify, Observe.

```markdown
- [ ] Step 3: Implement target-action binding for Counter buttons
  - **Do**: Wire NSButton targets using delegate bridge
  - **Verify**: Button clicks update the label in TestAnyware
  - **Observe**: _(filled after completion)_
```

After completion:

```markdown
- [x] Step 3: Implement target-action binding for Counter buttons
  - **Do**: Wire NSButton targets using delegate bridge
  - **Verify**: Button clicks update the label in TestAnyware
  - **Observe**: 🔴 delegate bridge requires prevent-gc! on the target object or it
    gets collected mid-session. 🟡 NSButton setTarget: accepts _id, no coercion needed.
```

### Plan Observations section

Step-level observations accumulate in the plan's `## Observations` section, grouped by date:

```markdown
## Observations

**YYYY-MM-DD:**
- 🔴 delegate bridge requires prevent-gc! on target (Step 3)
- 🟡 NSButton setTarget: accepts _id directly (Step 3)
- 🟢 Counter label updates are synchronous, no async polling needed (Step 4)
```

### Plan Promoted section

Tracks which observations have been promoted to the knowledge base, preventing duplication:

```markdown
## Promoted

- 🔴 prevent-gc! requirement → knowledge/targets/racket-oo.md (YYYY-MM-DD)
- 🔴 NSButton target-action needs delegate bridge → knowledge/apps/counter/learnings.md (YYYY-MM-DD)
```

### Priority codes

- 🔴 **Critical** — will break things or cause significant time loss if not known
- 🟡 **Useful** — saves time, avoids confusion, or clarifies an ambiguity
- 🟢 **Informational** — context that may be helpful but is not actionable

### Code review sessions as Reflection

The existing plan format (from `LLM_CONTEXT/create-a-multi-session-plan.md`) requires
interleaved code review sessions. These now serve as the **Reflector** phase:

1. Review all new observations since last reflection
2. For each 🔴 or 🟡 observation, determine: does this apply beyond this specific step?
3. If yes — promote to the appropriate knowledge axis via the `/reflect` skill
4. Look for patterns across observations (e.g. "three observations mention GC issues —
   this is a target-level pattern")
5. Condense related observations into a single knowledge entry
6. Record promotions in the plan's `## Promoted` section

### The promote-eagerly rule

Observations start at the narrowest applicable axis (matrix). During reflection, they
may be promoted upward:

```
matrix/{app}/{target}.md  →  targets/{target}.md       (target-universal)
matrix/{app}/{target}.md  →  apps/{app}/learnings.md    (app-universal)
targets/{target}.md       →  pipeline/{area}.md          (pipeline-wide)
apps/{app}/test-strategy.md → testanyware/strategies/   (testing pattern)
```

When promoting, remove the entry from the narrower file and record the promotion in the
plan's `## Promoted` section.

---

## 5. Skills

### `/begin-work <target> [app]`

The universal entry point for starting or continuing any implementation work.

**Trigger**: At the start of every work session. The root CLAUDE.md instructs its use. Session
continuation prompts in plans invoke it.

**Behaviour:**

1. Validate the target exists; if app specified, validate it exists
2. Read `knowledge/targets/{target}.md`
3. If app specified:
   - Read `knowledge/apps/{app}/spec.md`
   - Read `knowledge/apps/{app}/learnings.md`
   - Read `knowledge/apps/{app}/test-strategy.md`
   - Read `knowledge/matrix/{app}/{target}.md` (if it exists)
4. Check for active plan at `LLM_STATE/plans/{target}/[{app}.md | plan.md]`
   - If plan exists: display progress, identify next incomplete step, show un-promoted
     observations, flag if code review is overdue
   - If no plan: offer to create one using the plan template
5. Display summary: "You are working on {app} for {target}. Here is what you need to know..."

### `/reflect`

Promotes observations from the current plan to the knowledge base. Used during code review
sessions.

**Trigger**: During code review sessions (interleaved with implementation in every plan).

**Behaviour:**

1. Read the current plan's `## Observations` section
2. Identify un-promoted entries (cross-reference with `## Promoted`)
3. For each un-promoted 🔴 or 🟡 observation:
   - Suggest the axis it belongs to (matrix, target, app, pipeline, testanyware)
   - Ask for confirmation
   - Write the dated entry to the correct knowledge file
   - Record the promotion in the plan's `## Promoted` section
4. For 🟢 observations: ask whether any are worth promoting (default: skip)
5. Look for patterns: flag if 2+ observations relate to the same topic and suggest
   consolidation into a single knowledge entry at a broader axis

### `/add-app <name>`

Scaffolds a new app across the entire matrix.

**Trigger**: When adding a new sample app to the suite.

**Behaviour:**

1. Create `knowledge/apps/{name}/` with template files:
   - `spec.md` (template with sections to fill)
   - `learnings.md` (empty, with header)
   - `test-strategy.md` (empty, with header)
2. Update `knowledge/apps/_index.md` with the new app and its progression position
3. For each existing target:
   - Create `generation/targets/{target}/apps/{name}/` with CLAUDE.md
   - Create `knowledge/matrix/{name}/{target}.md` (empty, with header)
4. Prompt: "Spec template created at knowledge/apps/{name}/spec.md. Fill in the specification."

### `/add-target <name>`

Scaffolds a new target across the entire matrix.

**Trigger**: When adding a new language+paradigm target.

**Behaviour:**

1. Create `generation/targets/{name}/` with full directory structure:
   - `CLAUDE.md`, `crate/`, `runtime/`, `generated/`, `apps/`, `tests/`, `test-results/`
   - `apps/CLAUDE.md`
2. Create `knowledge/targets/{name}.md` (empty template)
3. For each existing app:
   - Create `generation/targets/{name}/apps/{app}/` with CLAUDE.md
   - Create `knowledge/matrix/{app}/{name}.md` (empty, with header)
4. Create `LLM_STATE/plans/{name}/plan.md` from plan template
5. Register emitter crate stub in Cargo workspace
6. Update CLI registry

---

## 6. Plan System

### Plan hierarchy

```
LLM_STATE/plans/
├── racket-oo/
│   ├── plan.md              # Target-level plan (emitter, runtime, overall progress)
│   ├── counter.md           # App-specific plan
│   ├── modaliser.md         # Capstone plan
│   └── ...
├── racket-functional/
│   └── plan.md
└── plan-template.md         # Template for new target/app plans
```

### Enhanced plan format

Plans follow the existing `LLM_CONTEXT/create-a-multi-session-plan.md` format, enhanced with
the observational memory system:

```markdown
# {App/Target} — {target}

## Task Summary
Brief description of the goal.

## Session Continuation Prompt

\```
Run /begin-work {target} {app} to load context, then continue from the next
incomplete step. Complete each step's Do → Verify → Observe cycle. After every
3-5 implementation steps, conduct a code review session using /reflect.
\```

## Progress

- [x] Step 1: ...
  - **Do**: ...
  - **Verify**: ...
  - **Observe**: 🟡 ...
- [ ] Step 2: ...
  - **Do**: ...
  - **Verify**: ...
  - **Observe**: _(pending)_
- [ ] Code Review Session 1
  - Review steps 1-5, run /reflect, assess progress

## Observations

**YYYY-MM-DD:**
- 🔴 ... (Step N)
- 🟡 ... (Step N)

## Promoted

- 🔴 ... → knowledge/targets/{target}.md (YYYY-MM-DD)

## Learnings

Significant in-flight discoveries not yet ready for promotion (per existing plan format).
```

### Code review cadence

Every plan interleaves code review sessions after every 3-5 implementation steps. Code review
sessions are explicit plan steps:

```markdown
- [ ] Code Review Session 1
  - Review implementation of steps 1-5
  - Run /reflect to promote observations
  - Assess overall progress and plan accuracy
  - Update remaining steps if approach has changed
```

### Session continuation prompt

Every plan's session prompt invokes `/begin-work`, which handles both the "load context" and
"find where we left off" concerns:

```
Run /begin-work racket-oo counter to load context, then continue from the next
incomplete step. Complete each step's Do → Verify → Observe cycle.
```

---

## 7. Master Reference Document: `LLM_CONTEXT/project-workflow.md`

This is the single document that explains the entire system. A fresh Claude session with no
memory must be able to understand how to operate from this file alone.

### Outline

```markdown
# Project Workflow

## Overview
- What this project is (matrix of targets x apps generating macOS bindings)
- What a "target" is (language+paradigm, fully independent)
- The progression: simple apps → complex apps → Modaliser capstone
- The POC Modaliser (../Modaliser) as the reference implementation

## The Knowledge System
- The five axes explained with examples
- Where knowledge lives (knowledge/ directory)
- How CLAUDE.md files route to the right knowledge automatically
- The observational memory system: Observe → accumulate → Reflect → promote
- Priority codes: 🔴 🟡 🟢
- The promote-eagerly rule

## Working On Implementation
- Always start with /begin-work <target> [app]
- The Do → Verify → Observe step cycle
- How plans work (format, session continuation, review sessions)
- Code review cadence: every 3-5 implementation steps
- When to update plans vs when observations get promoted to knowledge

## Skills Reference
- /begin-work <target> [app] — start or continue work
- /reflect — promote observations during code review
- /add-app <name> — scaffold new app across matrix
- /add-target <name> — scaffold new target across matrix

## Adding To The Matrix
- Adding a new app: what /add-app scaffolds, what you write manually
- Adding a new target: what /add-target scaffolds, what you write manually
- The plan template

## GUI Testing With TestAnyware
- The universal workflow (knowledge/testanyware/general.md)
- Per-app-type strategies (knowledge/testanyware/strategies/)
- Never run apps directly from the CLI
- How to record testing learnings

## Pipeline Changes
- When app/generation work reveals pipeline bugs
- How to track pipeline learnings (knowledge/pipeline/)
- The feedback loop: discovery → fix → re-generate → re-test

## Coding Standards
- Pointer to LLM_CONTEXT/coding-style.md
- TDD emphasis
- Snapshot test workflow (UPDATE_GOLDEN=1)

## App Progression
- Pointer to knowledge/apps/_index.md
- Simple → complex → Modaliser capstone
- Each app exercises specific macOS/binding capabilities
- Platform compliance requirements
```

---

## 8. Modaliser

### Role in the project

Modaliser is the **capstone application** — the final proof that a target's bindings are
production-ready. It is the most complex app in the progression, exercising keyboard capture,
window management, app lifecycle, UI overlays, and a language-idiomatic configuration/scripting
system.

### POC reference

The existing Modaliser at `../Modaliser` is a **working, validated proof-of-concept** written
in Swift with Scheme (LispKit) scripting. It is the authoritative source for:

- **Behaviour**: what the app does, how modes work, how commands are defined
- **Features**: app launching, window management, keyboard capture, fuzzy search, clipboard
- **UX expectations**: overlay appearance, timing, responsiveness, key sequences
- **Configuration model**: hierarchical command trees, per-app overrides, theme customisation

Each target's Modaliser implementation must achieve **functional parity** with the POC. The
configuration approach is adapted to be idiomatic for the target language — executable
configuration is appropriate for Scheme-family targets, but other languages may use different
approaches (DSLs, builder patterns, YAML+lambdas, etc.). The choice of configuration paradigm
is itself a design decision that gets captured in `knowledge/apps/modaliser/config-patterns.md`.

### Spec derivation

The `knowledge/apps/modaliser/spec.md` is derived from the POC by:

1. Cataloguing all features and behaviours from the working implementation
2. Abstracting away Swift/Scheme-specific implementation details
3. Defining platform compliance requirements
4. Establishing a TestAnyware testing strategy for modal overlay apps

### Testing challenge

Modaliser's modal overlay, global keyboard capture, and multi-app interaction make it
significantly harder to test in TestAnyware than the simpler sample apps. The testing
strategy needs to be worked out once and documented in:

- `knowledge/apps/modaliser/test-strategy.md` — app-specific strategy
- `knowledge/testanyware/strategies/modal-overlay-apps.md` — reusable pattern for overlay apps

---

## 9. Migration

### Mapping from current to new structure

| Current location | New location | Notes |
|---|---|---|
| `generation/targets/racket/generated/oo/` | `generation/targets/racket-oo/generated/` | Flatten paradigm |
| `generation/targets/racket/generated/functional/` | `generation/targets/racket-functional/generated/` | Separate target |
| `generation/targets/racket/runtime/` | `generation/targets/racket-oo/runtime/` | Current runtime is OO-focused |
| `generation/targets/racket/apps/oo/` | `generation/targets/racket-oo/apps/` | Flatten |
| `generation/targets/racket/apps/functional/` | `generation/targets/racket-functional/apps/` | Separate |
| `generation/targets/racket/tests/` | `generation/targets/racket-oo/tests/` | Current tests are OO |
| `generation/targets/racket/test-results/oo/` | `generation/targets/racket-oo/test-results/` | Flatten |
| `generation/crates/emit-racket/` | `generation/crates/emit-racket-oo/` | Rename crate |
| `generation/apps/specs/*.md` | `knowledge/apps/{app}/spec.md` | One spec per app dir |
| `generation/apps/tests/*-test.md` | `knowledge/apps/{app}/test-strategy.md` | Rename and move |
| `generation/apps/testanyware-workflow.md` | `knowledge/testanyware/general.md` | Move |
| `LLM_STATE/plan-racket.md` | `LLM_STATE/plans/racket-oo/plan.md` | Restructure |
| `LLM_STATE/plan.md` | Keep, add pointers to new structure | Overall project plan |
| `LLM_CONTEXT/*` | Keep in place, update plan format doc | Already referenced |
| `generation/apps/` | Remove after migration | All content moves to `knowledge/apps/` and `knowledge/testanyware/` |

### Updates to existing files

- **`LLM_CONTEXT/create-a-multi-session-plan.md`**: Update the plan step format to include the
  mandatory Do/Verify/Observe structure. Add the Observations and Promoted sections to the plan
  template. Add code review session cadence instructions.
- **Root `CLAUDE.md`**: Add the "How This Project Is Organised" section with skill references
  and key directory pointers.
- **`LLM_STATE/plan.md`**: Add pointers to the new `LLM_STATE/plans/` hierarchy and the
  knowledge system.

### New files to create

- `knowledge/` directory tree with all CLAUDE.md and axis subdirectories
- All nested CLAUDE.md routing files
- `knowledge/targets/racket-oo.md` — seeded from `LLM_STATE/plan-racket.md` learnings
- `knowledge/apps/{app}/learnings.md` — seeded from any existing discoveries
- `knowledge/matrix/` — mostly empty, populated during future work
- `knowledge/pipeline/` — seeded from `LLM_STATE/plan.md` learnings
- `LLM_CONTEXT/project-workflow.md` — master reference document
- Skills: `/begin-work`, `/reflect`, `/add-app`, `/add-target`
- `racket-functional` target directory (stub)
- `emit-racket-functional` crate (stub)

### Cargo workspace changes

- Rename `emit-racket` to `emit-racket-oo` (update `Cargo.toml`, all `use` paths)
- Add `emit-racket-functional` as stub crate
- Update CLI registry to register both targets
- `BindingStyle` enum remains in shared `emit` crate

### Existing Racket work preservation

All existing Racket OO work (3 completed apps, runtime, emitter, tests, test results) is
preserved — it moves to `racket-oo` with no content changes, only path changes. The
`racket-functional` target starts as a stub.
