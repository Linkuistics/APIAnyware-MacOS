# Project Workflow

## Overview

APIAnyware-MacOS is a matrix project: N targets x M apps, generating idiomatic macOS
bindings for non-mainstream languages.

A **target** is a language+paradigm combination — a top-level directory with its own
emitter crate, runtime, apps, tests, and generated output. `racket-oo` and
`racket-functional` are independent targets, just like `racket-oo` and `haskell-monadic`.

Apps progress from simple (hello-window) to complex (menu-bar-tool), culminating in
Modaliser as the capstone proving a target's bindings are production-ready.

The POC Modaliser (`../Modaliser`) is the reference implementation — a working Swift app
with LispKit scripting.

## The Knowledge System

Knowledge is captured along five axes:

| Axis | Path | What goes here |
|------|------|----------------|
| Pipeline | `knowledge/pipeline/` | Collection/analysis discoveries affecting all targets |
| TestAnyware | `knowledge/testanyware/` | GUI testing strategies, reusable across apps/targets |
| Apps | `knowledge/apps/{app}/` | App specs, language-independent learnings, test strategies |
| Targets | `knowledge/targets/{target}.md` | Target-wide learnings (FFI patterns, runtime quirks) |
| Matrix | `knowledge/matrix/{app}/{target}.md` | Discoveries specific to one app in one target |

See `knowledge/CLAUDE.md` for the full rules.

CLAUDE.md files in target and app directories route to the relevant knowledge files
automatically. This is the only mechanism that guarantees context loading.

### Observational Memory

The observational-memory plugin provides the workflow:

1. **Observe** — after every plan step, record what was *learned* (not what was done)
2. **Accumulate** — observations collect in the plan's Observations section
3. **Reflect** — during code review sessions, promote observations to the knowledge base
4. **Promote eagerly** — start narrow, promote upward when applicable more broadly

Priority codes: 🔴 (critical), 🟡 (useful), 🟢 (informational)

## Working On Implementation

1. Always start with `/begin-work <target> [app]`
2. Follow the Do → Verify → Observe cycle for each plan step
3. Every 3-5 steps, conduct a code review session using `/reflect`
4. When the plan requires updating, update it directly

Plans live at `LLM_STATE/plans/{target}/plan.md` (or `{target}/{app}.md`).

## Skills Reference

- `/begin-work <target> [app]` — start or continue any implementation work
- `/reflect` — promote observations to the knowledge base (during code review)
- `/create-plan <name> [target] [app]` — create a new plan with observational memory
- `/add-app <name>` — scaffold a new app across the matrix (project-level skill)
- `/add-target <name>` — scaffold a new target across the matrix (project-level skill)

## Adding To The Matrix

### Adding a new app
1. Create `knowledge/apps/{name}/` with spec.md, learnings.md, test-strategy.md
2. Update `knowledge/apps/_index.md`
3. For each existing target: create app directory with CLAUDE.md, create matrix knowledge file
4. Use `/add-app <name>` to scaffold automatically

### Adding a new target
1. Create `generation/targets/{name}/` with CLAUDE.md, runtime/, generated/, apps/, tests/
2. Create `knowledge/targets/{name}.md`
3. For each existing app: create app dir with CLAUDE.md, create matrix file
4. Create `LLM_STATE/plans/{name}/plan.md` from template
5. Create emitter crate stub, register in Cargo workspace and CLI
6. Use `/add-target <name>` to scaffold automatically

## GUI Testing With TestAnyware

Never run apps directly from the CLI. Use the TestAnyware VM workflow:
```bash
../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/{target}:{target}
../TestAnyware/.build/release/testanyware exec "..."
../TestAnyware/.build/release/testanyware vm stop
```

See `knowledge/testanyware/general.md` for the full workflow.

When transferring files to the VM, use base64 encoding — VirtioFS can serve stale content.
Always `pkill -9 -f racket` (or equivalent) before relaunching apps.

## Pipeline Changes

When app/generation work reveals pipeline bugs:
1. Record as 🔴 observation in the plan
2. Fix the pipeline code
3. Re-generate affected targets: `cargo run --bin apianyware-macos-generate -- --lang {target}`
4. Re-test
5. During `/reflect`, promote to `knowledge/pipeline/{area}.md`

## Coding Standards

See `LLM_CONTEXT/coding-style.md` for project-specific conventions. The observational-memory
plugin provides universal conventions at `references/coding-conventions.md`.

Key points: TDD, descriptive names, small files, `thiserror`/`anyhow`, `tracing`,
bounded channels, no `unwrap`/`expect`, `cargo +nightly fmt`.

## App Progression

See `knowledge/apps/_index.md` for the full catalogue. Simple → complex → Modaliser capstone.
Each app exercises specific macOS/binding capabilities.
