# Observational Memory Plugin: Reusable Knowledge Management for LLM-Driven Projects

## Overview

A personal Claude Code plugin that provides a reusable observational memory system, integrated
plan format, and workflow skills for any LLM-driven project. Extracts the project-independent
patterns from the APIAnyware-MacOS restructure into a toolkit that can be installed into any
repository.

The plugin assumes the user's established conventions: TDD, descriptive naming, small focused
files, `thiserror`/`anyhow` for Rust, `tracing` for logging, and TestAnyware for GUI testing
where applicable.

---

## 1. Plugin Identity

- **Name**: `observational-memory`
- **Location**: `~/.claude/plugins/observational-memory/` (global, available to all projects)
- **Purpose**: Provide observational memory, knowledge management, and integrated planning
  skills to any project

---

## 2. Plugin Structure

```
observational-memory/
├── plugin.json
├── skills/
│   ├── begin-work.md           # Universal entry point: start or continue work
│   ├── reflect.md              # Promote observations to knowledge base
│   ├── setup-knowledge.md      # Scaffold knowledge system for a new project
│   └── create-plan.md          # Create a plan in the integrated format
└── references/
    ├── observational-memory-guide.md   # The technique explained
    ├── plan-format.md                  # Integrated plan format reference
    └── coding-conventions.md           # Personal coding conventions
```

---

## 3. Skills

### `/begin-work <context> [sub-context]`

Universal entry point for starting or continuing any implementation work. The parameters are
project-specific — in APIAnyware they map to target and app, but in another project they might
be module and feature, or service and endpoint.

**Behaviour:**

1. Detect the project's knowledge directory (default: `knowledge/`, configurable via
   `.observational-memory.yml` in project root)
2. Read the knowledge index (`knowledge/CLAUDE.md`) to understand the project's axes
3. Load knowledge relevant to the given context:
   - Primary axis: `knowledge/{primary-axis}/{context}.md`
   - If sub-context: `knowledge/{secondary-axis}/{sub-context}/` files
   - Cross-product: `knowledge/{matrix-axis}/{sub-context}/{context}.md`
4. Check for active plan:
   - Look in the project's plan directory (default: `LLM_STATE/plans/`)
   - Pattern: `{context}/{sub-context}.md` or `{context}/plan.md`
5. If plan exists:
   - Display progress summary (completed/total steps)
   - Identify next incomplete step
   - Show un-promoted observations (count and any 🔴 items)
   - Flag if code review is overdue (>5 steps since last review)
6. If no plan exists:
   - Offer to create one via `/create-plan`
7. Display summary with all loaded context

**Configuration** (`.observational-memory.yml`):

```yaml
knowledge_dir: knowledge
plans_dir: LLM_STATE/plans
axes:
  primary: targets        # The main organisational axis
  secondary: apps         # The sub-context axis
  matrix: matrix          # Cross-product axis
  extras:                 # Additional knowledge axes
    - pipeline
    - testanyware
review_cadence: 5         # Steps between mandatory code review sessions
```

If no config file exists, the skill looks for `knowledge/` and `LLM_STATE/plans/` at the
project root, and infers axes from the knowledge directory structure.

### `/reflect`

Promotes observations from the current plan to the knowledge base. Designed for use during
code review sessions.

**Behaviour:**

1. Identify the current plan (from the most recent `/begin-work` context, or ask)
2. Read the plan's `## Observations` section
3. Cross-reference with `## Promoted` to find un-promoted entries
4. For each un-promoted 🔴 or 🟡 observation:
   - Analyse the observation and suggest which knowledge axis it belongs to
   - Present the suggestion: "This looks like a {axis} learning. Promote to
     `knowledge/{axis}/{file}.md`?"
   - On confirmation: append the dated entry to the target file, record in `## Promoted`
5. For 🟢 observations: summarise and ask if any are worth promoting (default: skip)
6. Pattern detection:
   - If 2+ observations relate to the same topic, suggest consolidation
   - If a matrix observation matches an existing entry in a broader axis, flag the overlap
   - If a narrow-axis learning seems broadly applicable, suggest promotion to a wider axis
7. Summary: "Promoted N observations. M remain un-promoted (🟢 informational)."

### `/setup-knowledge`

Scaffolds the observational memory knowledge system for a new project.

**Behaviour:**

1. Ask: "What are the main organisational axes for this project?" with examples:
   - "For a web app: services, features, infrastructure"
   - "For a multi-language project: targets, apps, pipeline"
   - "For a monorepo: packages, shared-libs, deployment"
2. For each axis, create:
   - `knowledge/{axis}/` directory
   - Template files with headers
3. Create `knowledge/CLAUDE.md` with the axis table and rules
4. Create `.observational-memory.yml` with the configured axes
5. Add to root CLAUDE.md:
   - Pointer to knowledge system
   - Skill references (`/begin-work`, `/reflect`)
   - "Before doing implementation work, read the knowledge relevant to your task"
6. Create `LLM_STATE/plans/` directory
7. Offer to create CLAUDE.md routing files for existing directories

**Templates created:**

Knowledge CLAUDE.md:
```markdown
# Knowledge Base

[Axis table generated from user's answers]

## Rules

- **Never duplicate** — if a learning applies to a broader axis, put it there
- **Date entries** — prefix with `**YYYY-MM-DD:**` so staleness is visible
- **Link don't copy** — CLAUDE.md files point here; knowledge is not inlined
- **Promote eagerly** — if a narrow learning turns out to be broadly applicable, move it up
- **Priority codes** — 🔴 (critical), 🟡 (useful), 🟢 (informational)
```

### `/create-plan <name> [context] [sub-context]`

Creates a multi-session plan in the integrated format with observational memory.

**Behaviour:**

1. If context provided, run `/begin-work` first to load relevant knowledge
2. Ask for a task summary (2-3 sentences)
3. Ask for the steps (or offer to help break down the task)
4. Generate the plan with:
   - Task summary
   - Session continuation prompt (referencing `/begin-work` with the right context)
   - Progress checklist with Do/Verify/Observe for each step
   - Code review sessions interleaved every N steps (from config, default 5)
   - Empty Observations, Promoted, and Learnings sections
5. Write to `LLM_STATE/plans/{context}/{name}.md`

---

## 4. References

### `references/observational-memory-guide.md`

The complete technique reference. This is the document that explains the system to a fresh
Claude session that has never seen it before.

**Contents:**

```markdown
# Observational Memory for LLM-Driven Projects

## The Problem

LLM agents (like Claude) working on multi-session projects lose context between sessions and
fail to accumulate knowledge systematically. Key discoveries get lost because:

1. The LLM forgets to record them (deliberate capture fails)
2. Learnings are trapped in one plan file, invisible to other workstreams
3. No mechanism ensures learnings are consulted when relevant

## The Solution: Observational Memory

Adapted from Mastra's Observational Memory system for AI agents. The core principle:
learning capture must be **structural, not deliberate** — woven into the workflow at
mandatory checkpoints.

### Three Tiers

| Tier | Where | When written | When promoted |
|------|-------|-------------|---------------|
| Raw observations | Plan step Observe field | After every step | During /reflect |
| Durable learnings | knowledge/ axis files | During /reflect | When patterns recur |
| Cross-cutting patterns | Broader knowledge/ axis | During /reflect | Ongoing |

### The Step Cycle: Do → Verify → Observe

Every plan step has three mandatory phases:

- **Do**: The implementation work
- **Verify**: Confirm it works (tests, manual check, TestAnyware)
- **Observe**: Record what was discovered — not what was done, but what was *learned*

Observations use priority codes:
- 🔴 Critical — will break things or waste significant time if not known
- 🟡 Useful — saves time, avoids confusion, clarifies ambiguity
- 🟢 Informational — context, not directly actionable

### Reflection: Code Review as Promotion

Every 3-5 implementation steps, a code review session serves as the Reflector:

1. Review accumulated observations
2. Determine which apply beyond the current task
3. Promote to the appropriate knowledge axis via /reflect
4. Detect patterns across observations
5. Condense related entries

### The Promote-Eagerly Rule

Start observations at the narrowest axis. During reflection, promote upward when a learning
applies more broadly. Always remove from the narrow file when promoting — no duplication.

### CLAUDE.md Routing

Claude Code auto-loads CLAUDE.md files from parent directories. Each CLAUDE.md is a routing
file — small, containing pointers to knowledge files. This is the only mechanism that
guarantees context loading without relying on LLM discipline.

### Knowledge Axes

Every project has its own axes, but common patterns:

- **Primary axis**: the main organisational dimension (services, targets, packages)
- **Secondary axis**: the cross-cutting dimension (features, apps, endpoints)
- **Matrix axis**: the intersection of primary x secondary
- **Infrastructure axes**: pipeline, deployment, testing strategies

## Using the Skills

- `/begin-work <context> [sub-context]` — always start here
- `/reflect` — run during code review sessions
- `/setup-knowledge` — scaffold the system for a new project
- `/create-plan` — create a plan with observational memory built in
```

### `references/plan-format.md`

The integrated plan format, combining the existing multi-session plan instructions with
observational memory.

**Contents:**

```markdown
# Integrated Plan Format

Plans track progress across multiple work sessions with built-in observational memory.

## File Structure

### 1. Task Summary
2-3 sentences describing the overall goal.

### 2. Session Continuation Prompt
A copyable prompt that invokes /begin-work with the right context:

\```
Run /begin-work {context} {sub-context} to load knowledge and find your place,
then continue from the next incomplete step. Complete each step's
Do → Verify → Observe cycle.
\```

### 3. Progress Checklist

Steps with the three-phase structure:

\```markdown
- [ ] Step 1: {description}
  - **Do**: {what to implement}
  - **Verify**: {how to confirm it works}
  - **Observe**: _(filled after completion)_
- [ ] Step 2: ...
- [ ] Code Review Session 1
  - Review steps 1-N, run /reflect, assess progress
\```

Step granularity: each step completable in 1-2 hours, clear completion criteria.

Code review sessions interleaved every 3-5 implementation steps.

### 4. Observations
Accumulated from step-level observations, grouped by date:

\```markdown
**YYYY-MM-DD:**
- 🔴 {critical discovery} (Step N)
- 🟡 {useful discovery} (Step N)
\```

### 5. Promoted
Tracks observations promoted to the knowledge base:

\```markdown
- 🔴 {observation} → knowledge/{axis}/{file}.md (YYYY-MM-DD)
\```

### 6. Learnings
Significant in-flight discoveries not yet ready for promotion. Reviewed during
code review sessions.

## Lifecycle

1. Create the plan at the start of a multi-session task
2. After each step: fill in Observe, copy to Observations section
3. Every 3-5 steps: code review session with /reflect
4. Start each session with /begin-work
5. When complete: final /reflect to promote remaining observations
```

### `references/coding-conventions.md`

Personal coding conventions, applicable across all projects.

**Contents:**

```markdown
# Coding Conventions

## Development Approach
- **TDD** — write tests first, then implement
- **Small files** — each file handles one concern
- **Descriptive names** — long is fine; consistency matters
- **Uniform naming** — don't mix get_thing/fetch_thing; pick one verb

## Code Quality
- Simplicity, readability, reusability, single concern, testability
- No unwrap/expect in production code
- No unbounded channels
- Bounded complexity — don't add features/abstractions beyond what's asked

## Rust-Specific
- `thiserror` for library errors, `anyhow` for CLI/application errors
- `tracing` macros only (not `log` crate)
- `cargo +nightly fmt` before committing
- Import grouping: stdlib → external → local

## Error Handling
- Use `?` operator for propagation
- Provide descriptive error messages with context
- Handle errors gracefully — no panicking unless absolutely necessary

## Async
- Tokio runtime
- Bounded channels only
- No blocking operations in async contexts
```

---

## 5. plugin.json

```json
{
  "name": "observational-memory",
  "version": "1.0.0",
  "description": "Observational memory, knowledge management, and integrated planning for LLM-driven projects",
  "skills": [
    {
      "name": "begin-work",
      "path": "skills/begin-work.md",
      "description": "Start or continue implementation work with full knowledge context"
    },
    {
      "name": "reflect",
      "path": "skills/reflect.md",
      "description": "Promote plan observations to the knowledge base during code review"
    },
    {
      "name": "setup-knowledge",
      "path": "skills/setup-knowledge.md",
      "description": "Scaffold the observational memory knowledge system for a new project"
    },
    {
      "name": "create-plan",
      "path": "skills/create-plan.md",
      "description": "Create a multi-session plan with built-in observational memory"
    }
  ]
}
```

---

## 6. Relationship to APIAnyware-MacOS

APIAnyware-MacOS is the first consumer of this plugin. The project-specific configuration:

```yaml
# .observational-memory.yml in APIAnyware-MacOS root
knowledge_dir: knowledge
plans_dir: LLM_STATE/plans
axes:
  primary: targets
  secondary: apps
  matrix: matrix
  extras:
    - pipeline
    - testanyware
review_cadence: 5
```

The plugin provides the generic skills and technique. The APIAnyware spec
(`2026-03-31-matrix-project-restructure-design.md`) defines the project-specific directory
layout, CLAUDE.md routing, migration plan, and Modaliser integration.

When `/begin-work racket-oo counter` is invoked in APIAnyware, the skill reads the config,
maps `racket-oo` to the primary axis (targets) and `counter` to the secondary axis (apps),
and loads knowledge from the paths defined by those axes.

---

## 7. Integration with Existing LLM_CONTEXT

The plugin's `references/` directory replaces the need for per-project `LLM_CONTEXT/` files
for the common concerns:

| Current per-project file | Plugin replacement | Notes |
|---|---|---|
| `LLM_CONTEXT/create-a-multi-session-plan.md` | `references/plan-format.md` | Enhanced with Observe phase |
| `LLM_CONTEXT/coding-style.md` | `references/coding-conventions.md` | Personal conventions |
| `LLM_CONTEXT/improve-these-crates.md` | Not replaced | Project-specific template |
| `LLM_CONTEXT/project-workflow.md` | Not replaced | Project-specific, but /setup-knowledge generates one |

Projects keep their `LLM_CONTEXT/` for project-specific instructions. The plugin handles
the universal patterns. The root CLAUDE.md points to both.
