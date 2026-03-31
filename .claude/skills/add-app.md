---
name: add-app
description: Scaffold a new app across the entire APIAnyware matrix. Usage: /add-app <name>
---

You are scaffolding a new app across the APIAnyware matrix.

## 1. Parse arguments

Extract `name` — the app name (kebab-case, e.g., `file-lister`).

## 2. Create knowledge files

Create `knowledge/apps/{name}/` with:

**spec.md:**
```markdown
# {Name (title case)}

## Purpose
What this app demonstrates and why it exists in the progression.

## Complexity Level
Position in the simple-to-complex progression (e.g. "Level N of 8").

## Prerequisites
Which apps should be completed first and why.

## Capabilities Exercised
- _(fill in)_

## Specification
_(fill in: window layout, behaviour, UI elements, interactions)_

## Platform Compliance Requirements
_(fill in: what "100% platform compliant" means for this app type)_
```

**learnings.md:**
```markdown
# {Name (title case)} — App-Universal Learnings

Discoveries that apply to this app regardless of which target implements it.
```

**test-strategy.md:**
```markdown
# {Name (title case)} — TestAnyware Strategy

## Setup
_(what needs to be installed, how to launch)_

## Verification Steps
_(ordered checklist)_

## Known Timing Issues
_(delays, polling)_

## Evidence
_(what constitutes a pass)_
```

## 3. Update app index

Add the new app to `knowledge/apps/_index.md` with its complexity level and key capabilities.

## 4. Scaffold across existing targets

For each directory in `generation/targets/*/`:
1. Create `generation/targets/{target}/apps/{name}/CLAUDE.md` using the per-app template:
   ```markdown
   # {name} — {target}

   ## Required reading

   - Spec: `knowledge/apps/{name}/spec.md`
   - App learnings: `knowledge/apps/{name}/learnings.md`
   - Test strategy: `knowledge/apps/{name}/test-strategy.md`
   - Matrix learnings: `knowledge/matrix/{name}/{target}.md`
   - Target learnings: `knowledge/targets/{target}.md`
   - Active plan: `LLM_STATE/plans/{target}/{name}.md`
   ```
2. Create `knowledge/matrix/{name}/{target}.md` with empty template:
   ```markdown
   # {name} x {target}

   _(No discoveries yet)_
   ```

## 5. Report

List everything created. Prompt: "Spec template created at `knowledge/apps/{name}/spec.md`. Fill in the specification."
