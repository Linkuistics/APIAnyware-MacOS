# Plan Restructure Implementation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace APIAnyware's monolithic milestone-based plan system with separated core/target backlog plans, extract the methodology into a shared `LLM_CONTEXT/backlog-plan.md`, and remove all project-specific skills.

**Architecture:** Two layers: a shared methodology doc (`backlog-plan.md`) defines how plans work; individual plan files are pure data (continuation prompt + task backlog + session log). Core pipeline and each language target get independent plan files. A dashboard (`overview.md`) provides at-a-glance status.

**Tech Stack:** Markdown files, no code changes.

**Spec:** `docs/superpowers/specs/2026-04-10-plan-restructure-design.md`

---

### Task 1: Create `../LLM_CONTEXT/backlog-plan.md`

The methodology document. All plan files will reference this.

**Files:**
- Create: `/Users/antony/Development/LLM_CONTEXT/backlog-plan.md`

- [ ] **Step 1: Write `backlog-plan.md`**

```markdown
# Backlog Plan

A backlog plan is a living document for exploratory, incremental work across multiple
sessions. It replaces rigid milestone-based plans with a mutable task backlog and a
triage-first work cycle.

## Philosophy

Work is exploratory. Tasks emerge from doing the work — you discover what needs doing
by doing adjacent things. A backlog plan embraces this: the task list is mutable, new
tasks are added as they're discovered, priorities shift based on what you learn, and
each session starts by choosing the best next task rather than continuing from a fixed
position.

## Plan File Structure

Every plan file has exactly three sections:

### 1. Session Continuation Prompt

A copyable code block that starts a new session. It MUST:
- Reference `LLM_CONTEXT/index.md` for project context
- Reference `LLM_CONTEXT/backlog-plan.md` (this file) for the work cycle
- Point to the plan file itself
- Include any plan-specific instructions (test commands, constraints, domain guidance)

### 2. Task Backlog

A mutable list of tasks. Each task has:

- **Title** — concise description of what to do
- **Status** — `not_started`, `in_progress`, `done`, `blocked`
- **Category** — a grouping tag for triage (e.g., `[collection]`, `[apps]`). Categories
  are not phases — they help you decide what to work on, not what order to work in.
- **Dependencies** — other tasks or external conditions that must be met first. These
  are inputs to the triage decision, not hard gates. If a task is blocked, note what
  it's blocked on.
- **Description** — what and why, with enough context to start work
- **Results** — filled in when done: what happened, what was learned

Tasks are added, split, merged, reprioritized, or dropped as work reveals new
information. Completed tasks stay in the backlog (marked `done`) as a record.

Example:

```
### C function extraction `[collection]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Extend the collector to extract C functions from framework headers.
  Currently only ObjC classes are extracted. Real apps need C functions like
  CGEventTapCreate, CFRunLoopAddSource, AXIsProcessTrusted.
- **Results:** _pending_
```

### 3. Session Log

Append-only, dated entries recording what was done and what was learned in each session.
This is the historical record — never edit past entries, only append new ones.

Format:

```
### Session N (YYYY-MM-DD) — brief title
- What was attempted
- What worked, what didn't
- What this suggests trying next
- Key learnings or discoveries
```

## Work Cycle

Each session follows this cycle:

1. **REVIEW** — read the task backlog and recent session log entries
2. **DECIDE** — pick the best next task. Consider:
   - Dependencies: what's unblocked?
   - Priority: what has the most impact?
   - Context: what builds on recent work?
   - Momentum: what can you finish this session?
   Explain your reasoning before starting work.
3. **IMPLEMENT** — do the work (TDD: write tests first)
4. **VERIFY** — run tests, check results
5. **REFLECT** — what worked? What didn't? What new tasks emerged?
6. **UPDATE** — update this plan:
   - Record results on the task you worked on
   - Add/reprioritize/split tasks based on what you learned
   - Append a dated entry to the Session Log

## Creating a New Plan

See `LLM_CONTEXT/create-a-multi-session-plan.md` for instructions on creating a new
backlog plan through conversation.

## Tips

- **Don't over-plan upfront.** Start with the tasks you know about. More will emerge.
- **Split tasks that grow.** If a task turns out to be bigger than expected, split it
  into smaller tasks rather than letting it sprawl.
- **Record why, not just what.** The session log should capture reasoning and surprises,
  not just "did X."
- **Blocked tasks are information.** When you mark a task blocked, the dependency tells
  future sessions what to unblock first.
- **Categories are lenses, not phases.** Use them to filter the backlog when deciding
  what to work on, not to enforce ordering.
```

- [ ] **Step 2: Verify the file reads correctly**

Run: `head -5 /Users/antony/Development/LLM_CONTEXT/backlog-plan.md`
Expected: First 5 lines of the file, starting with `# Backlog Plan`

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/LLM_CONTEXT
git add backlog-plan.md
git commit -m "feat: add backlog-plan.md — methodology for exploratory multi-session plans"
```

---

### Task 2: Rewrite `../LLM_CONTEXT/create-a-multi-session-plan.md`

Replace the rigid sequential plan creation instructions with a conversation-driven process that produces backlog plans.

**Files:**
- Modify: `/Users/antony/Development/LLM_CONTEXT/create-a-multi-session-plan.md`

- [ ] **Step 1: Replace the entire file content**

```markdown
# Creating a Multi-Session Plan

Instructions for creating a new backlog plan through conversation with the user.
The output is a plan file conforming to the format in `backlog-plan.md`.

## Process

### 1. Clarify the scope

Ask the user:
- What is this plan for? What's the overall goal?
- What do you already know needs doing? (Initial tasks)
- What categories make sense for grouping the tasks?
- Are there known dependencies or blockers?
- Any specific instructions that should go in the continuation prompt?
  (e.g., test commands, key constraints, domain-specific guidance)

This is a conversation — ask follow-up questions until the scope is clear.
Don't ask all questions at once; one at a time.

### 2. Draft the plan

Produce a plan file with three sections, per `backlog-plan.md`:

1. **Session Continuation Prompt** — a copyable code block that:
   - References `LLM_CONTEXT/index.md` for project context
   - References `LLM_CONTEXT/backlog-plan.md` for the work cycle
   - Points to the plan file by path
   - Includes any plan-specific instructions from step 1

2. **Task Backlog** — the initial tasks from the conversation, each with:
   - Title and category tag
   - Status (usually `not_started`)
   - Dependencies (if known)
   - Description (what and why)
   - Results placeholder (`_pending_`)

3. **Session Log** — empty, with a header only

### 3. Review with the user

Show the draft plan and ask if it looks right. Adjust as needed.

### 4. Write the file

Save to `LLM_STATE/` with a descriptive name. The name should make the plan's
purpose obvious without opening the file.

Good: `LLM_STATE/core/plan.md`, `LLM_STATE/targets/racket-oo/plan.md`
Good: `LLM_STATE/plan-ocr-accuracy.md`
Avoid: `LLM_STATE/plan.md`, `LLM_STATE/todo.md`

### 5. Commit

Commit the new plan file.

## Reference

See `LLM_CONTEXT/backlog-plan.md` for the full plan format specification,
work cycle, and task format.
```

- [ ] **Step 2: Verify the file reads correctly**

Run: `head -5 /Users/antony/Development/LLM_CONTEXT/create-a-multi-session-plan.md`
Expected: First 5 lines, starting with `# Creating a Multi-Session Plan`

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/LLM_CONTEXT
git add create-a-multi-session-plan.md
git commit -m "feat: rewrite plan creation as conversation-driven backlog plan process"
```

---

### Task 3: Create `LLM_STATE/core/plan.md`

The core pipeline backlog, migrated from the old `plan.md` and post-M9 review items.

**Files:**
- Create: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/core/plan.md`

- [ ] **Step 1: Create directory**

```bash
mkdir -p /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/core
```

- [ ] **Step 2: Write the core plan**

```markdown
# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Currently supports ObjC class extraction; needs extension to C
functions, enums, constants, and callback types.

## Session Continuation Prompt

```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: Core Pipeline

Read `LLM_STATE/core/plan.md`.

Key commands:
- `cargo test --workspace` — run all tests
- `cargo test -p apianyware-macos-types` — types crate tests
- `cargo test -p apianyware-macos-extract-objc` — ObjC extractor tests
- `cargo clippy --workspace` — lint
- `cargo +nightly fmt` — format

Constraints:
- TDD: write tests first
- `thiserror` for library errors, `anyhow` for CLI
- No `unwrap`/`expect` in production code
- See `LLM_CONTEXT/coding-style.md` for full conventions
```

## Task Backlog

### C function extraction `[collection]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Extend the collector to extract C functions from framework headers.
  Currently only ObjC classes/protocols/enums are extracted. Real apps (e.g.,
  Modaliser-Racket) need C functions like CGEventTapCreate, CFRunLoopAddSource,
  AXIsProcessTrusted, CFDictionaryCreate. The extractor uses libclang, which already
  parses C declarations — they're just not being collected.
- **Results:** _pending_

### C enum and constant extraction `[collection]`
- **Status:** not_started
- **Dependencies:** may share infrastructure with C function extraction
- **Description:** Extract C enums, bit flag constants, and opaque pointer constants
  (e.g., kCFRunLoopCommonModes, kAXTrustedCheckOptionPrompt, kCFBooleanTrue).
  These are `extern const` globals and `#define` constants, distinct from ObjC enums
  which are already extracted.
- **Results:** _pending_

### C callback type extraction `[collection]`
- **Status:** not_started
- **Dependencies:** C function extraction (callbacks appear as function parameter types)
- **Description:** Extract function pointer typedefs like CGEventTapCallBack. These
  define the signature for C callbacks that must be wrapped in each target language
  (e.g., Racket's `_cprocedure` + `function-ptr`).
- **Results:** _pending_

### Framework ignore list `[collection]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Explicitly mark inappropriate frameworks as ignored rather than
  silently failing. Known bad frameworks: DriverKit (C++ headers), Tk (Tcl/Tk, not
  native macOS). Running all 283 frameworks already exposed real bugs — this prevents
  known-bad frameworks from wasting processing time or producing confusing errors.
- **Results:** _pending_

### LLM annotation integration `[analysis]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** The LLM annotation step currently requires external shell scripts
  and manual invocation. Make it a proper pipeline step in the Rust CLI
  (`apianyware-macos-analyze annotate`). Must run within Claude Code sessions using
  subagents per framework for economic reasons (not external API calls).
- **Results:** _pending_

### Test coverage hardening `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Comprehensive testing across the entire pipeline (collection,
  resolution, annotation, enrichment, generation). Running all 283 frameworks exposed
  a real enrichment bug (global totals written to every framework). More comprehensive
  testing will catch similar issues before they compound across language targets.
- **Results:** _pending_

### Enrichment verification `[enrichment]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Add verification that enrichment results are per-framework, not
  global. The bug where global totals were written to every framework's enriched IR
  was caught by running all frameworks — add targeted tests to prevent regression.
- **Results:** _pending_

## Session Log

### Pre-history (migrated from old plan.md)
- Milestones 1-8 complete: shared types, ObjC/C collection, Swift extraction,
  analysis pipeline (resolve/annotate/enrich), shared emitter framework, test
  infrastructure
- ObjC extractor's `type_mapping.rs` resolves typedefs to canonical types at
  extraction time — critical for correct FFI signatures downstream
- Category property deduplication by name required (HashSet filter in
  `extract_declarations.rs`)
- Typedef aliases (e.g., NSImageName) must resolve to canonical types at collection
  time: ObjC object pointer typedefs -> Id/Class, primitive typedefs -> Primitive,
  enum/struct typedefs -> keep as Alias
```

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_STATE/core/plan.md
git commit -m "feat: create core pipeline backlog plan"
```

---

### Task 4: Create `LLM_STATE/targets/template.md`

The parameterized template for new target plans, replacing `LLM_STATE/plans/plan-template.md`.

**Files:**
- Create: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets/template.md`

- [ ] **Step 1: Create directory**

```bash
mkdir -p /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets
```

- [ ] **Step 2: Write the template**

```markdown
# Target: {target}

{Language} ({paradigm}) bindings for macOS APIs. See `LLM_STATE/new-language-guide.md`
for the step-by-step guide to adding a new target.

```
Language: {display name}
Implementations: {runtime/compiler list}
Binding styles: {list, e.g., "OO, Functional, C-API"}
Swift dylib: libAPIAnyware{Lang}.dylib
Emitter crate: emit-{target}
Runtime location: generation/targets/{target}/runtime/
```

## Session Continuation Prompt

\```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: {target}

Read `LLM_STATE/targets/{target}/plan.md`.

Target-specific context:
- Emitter crate: `generation/crates/emit-{target}/`
- Runtime: `generation/targets/{target}/runtime/`
- Generated output: `generation/targets/{target}/generated/`
- Apps: `generation/targets/{target}/apps/`
- Target learnings: `knowledge/targets/{target}.md`

Key commands:
- `cargo test -p apianyware-macos-emit-{target}` — emitter tests
- `cargo run --bin apianyware-macos-generate -- --lang {target}` — regenerate
- `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-{target}` — update golden files
- `cargo +nightly fmt` — format

Constraints:
- TDD: write tests first
- If blocked on a core pipeline feature, note the dependency and pick a different task
- See `LLM_CONTEXT/coding-style.md` for Rust conventions
\```

## Task Backlog

{Initial tasks — adapt from the categories below based on what's already done
for this target. Not all targets start from zero.}

### Create emitter crate `[foundation]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Create `generation/crates/emit-{target}/` with naming conventions,
  dispatch strategy, class/protocol/enum emission, and framework orchestration.
  See `LLM_STATE/new-language-guide.md` Step 2 for structure. Use the Racket emitter
  as reference: `generation/crates/emit-racket-oo/`.
- **Results:** _pending_

### Create runtime library `[foundation]`
- **Status:** not_started
- **Dependencies:** none (can develop in parallel with emitter)
- **Description:** Create `generation/targets/{target}/runtime/` with object wrapping,
  memory management, block/delegate bridging, type conversions, struct types, variadic
  helpers, and Swift dylib loading. See `LLM_STATE/new-language-guide.md` Step 3.
- **Results:** _pending_

### Swift dylib integration `[foundation]`
- **Status:** not_started
- **Dependencies:** runtime library
- **Description:** Wire up `libAPIAnyware{Lang}.dylib`. Verify FFI round-trip, block
  creation, delegate creation. See `LLM_STATE/new-language-guide.md` Step 4.
- **Results:** _pending_

### Register with generation CLI `[foundation]`
- **Status:** not_started
- **Dependencies:** emitter crate
- **Description:** Add `--lang {target}` to the generation CLI. See
  `LLM_STATE/new-language-guide.md` Step 5.
- **Results:** _pending_

### Snapshot tests `[testing]`
- **Status:** not_started
- **Dependencies:** emitter crate, CLI wiring
- **Description:** Golden-file regression tests for all binding styles. See
  `LLM_STATE/new-language-guide.md` Step 6.
- **Results:** _pending_

### Smoke tests `[testing]`
- **Status:** not_started
- **Dependencies:** runtime, generated bindings
- **Description:** Non-GUI tests in the target language verifying bindings work.
  See `LLM_STATE/new-language-guide.md` Step 7.
- **Results:** _pending_

### C-API style emission `[coverage]`
- **Status:** not_started
- **Dependencies:** core pipeline C function/enum/constant extraction
- **Description:** Emit bindings for C functions, enums, constants, and callback types.
  This is a new binding style within the target, sharing the runtime and dylib.
- **Results:** _pending_

### Sample apps `[apps]`
- **Status:** not_started
- **Dependencies:** smoke tests passing, runtime working
- **Description:** Implement the 7 standard sample apps. See `knowledge/apps/_index.md`
  for the catalogue and `knowledge/apps/{app}/spec.md` for each spec. Validate each
  with TestAnyware (see `knowledge/testanyware/general.md`).
- **Results:** _pending_

## Session Log

{Empty — sessions append here.}
```

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_STATE/targets/template.md
git commit -m "feat: create backlog-style target plan template"
```

---

### Task 5: Migrate `racket-oo` plan to new format

Convert the existing racket-oo plan from milestone format to backlog format, preserving all learnings.

**Files:**
- Create: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets/racket-oo/plan.md`

- [ ] **Step 1: Create directory**

```bash
mkdir -p /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets/racket-oo
```

- [ ] **Step 2: Write the migrated plan**

```markdown
# Target: racket-oo

Racket OO-style bindings for macOS APIs using the `tell` macro and class wrappers.
Foundation complete (382 files generated), 3 of 7 sample apps validated. Next focus:
remaining sample apps and C-API style.

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (tell macro, class wrappers), Functional (plain procedures), C-API
Swift dylib: libAPIAnywareRacket.dylib
Emitter crate: emit-racket-oo
Runtime location: generation/targets/racket-oo/runtime/
```

## Session Continuation Prompt

\```
You MUST first read `LLM_CONTEXT/index.md`, then read
`LLM_CONTEXT/backlog-plan.md` for the work cycle.

# Continue: racket-oo

Read `LLM_STATE/targets/racket-oo/plan.md`.

Target-specific context:
- Emitter crate: `generation/crates/emit-racket-oo/`
- Runtime: `generation/targets/racket-oo/runtime/`
- Generated output: `generation/targets/racket-oo/generated/`
- Apps: `generation/targets/racket-oo/apps/`
- Target learnings: `knowledge/targets/racket-oo.md`
- Racket-specific notes: `tell` macro for OO dispatch, `coerce-arg` for auto-conversion,
  `prevent-gc!` for delegate bridges, variadic methods skipped (helpers provided)

Key commands:
- `cargo test -p apianyware-macos-emit-racket-oo` — emitter tests
- `cargo run --bin apianyware-macos-generate -- --lang racket-oo` — regenerate
- `UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket-oo` — update golden files
- TestAnyware VM: `../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket-oo:racket-oo`

Constraints:
- TDD: write tests first
- Always kill `pkill -9 -f racket` before relaunching apps in VM
- Use base64 encoding to transfer files to VM (VirtioFS serves stale content)
- If blocked on core pipeline, note the dependency and pick a different task
\```

## Task Backlog

### File Lister app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** NSTableView, data source delegate, NSFileManager, NSOpenPanel.
  See `knowledge/apps/file-lister/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Text Editor app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Block callbacks, error-out, undo/redo, notifications, find.
  See `knowledge/apps/text-editor/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Mini Browser app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Cross-framework WebKit, WKNavigationDelegate, URL handling.
  See `knowledge/apps/mini-browser/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### Menu Bar Tool app `[apps]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** NSStatusBar, NSMenu, no-window app, timers, clipboard.
  See `knowledge/apps/menu-bar-tool/spec.md` and `test-strategy.md`.
- **Results:** _pending_

### C-API style emission `[coverage]`
- **Status:** blocked
- **Dependencies:** core pipeline C function/enum/constant/callback extraction
- **Description:** Emit Racket bindings for C functions, enums, constants, and callback
  types using `get-ffi-obj`, `_cprocedure`, `_enum`. The hand-written FFI in
  `../Modaliser-Racket/ffi/` (cgevent.rkt, permissions.rkt) is the reference for
  what the generated output should look like.
- **Results:** _pending_

### Functional style emitter `[coverage]`
- **Status:** not_started
- **Dependencies:** none (OO emitter exists as reference)
- **Description:** Implement the functional binding style — plain procedures and
  explicit typed message sends, no `tell` macro. The CLI infrastructure already
  routes to the functional output directory; the emitter currently produces OO
  output for both styles.
- **Results:** _pending_

### AppKit snapshot golden files `[testing]`
- **Status:** blocked
- **Dependencies:** AppKit enriched IR (only Foundation is currently enriched)
- **Description:** Add AppKit golden files for snapshot regression testing.
- **Results:** _pending_

### Functional style golden files `[testing]`
- **Status:** blocked
- **Dependencies:** functional style emitter
- **Description:** Snapshot tests for the functional binding style.
- **Results:** _pending_

### Functional style smoke tests `[testing]`
- **Status:** blocked
- **Dependencies:** functional style emitter
- **Description:** Same smoke tests as OO style, using functional bindings.
- **Results:** _pending_

### Per-framework exercisers `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Targeted tests for CoreGraphics, AVFoundation, MapKit beyond
  what sample apps cover.
- **Results:** _pending_

### Documentation requirements `[docs]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Record Racket-specific documentation requirements: `tell` macro
  usage, `import-class` patterns, what's surprising for Racket developers, paradigm-
  appropriate examples for both OO and functional styles.
- **Results:** _pending_

### Done tasks (completed in milestone 9)

### Emitter crate `[foundation]`
- **Status:** done
- **Description:** 8 modules, 20 Rust unit tests, `RacketFfiTypeMapper`.
- **Results:** Complete. Ported from POC with three IR type changes.

### Runtime library `[foundation]`
- **Status:** done
- **Description:** 7 runtime modules.
- **Results:** Complete. All modules load, swift-available? is #t.

### Swift dylib integration `[foundation]`
- **Status:** done
- **Description:** 64 Swift tests, FFI round-trip, blocks, delegates.
- **Results:** Complete. 20 FFI tests, 5 block tests, 7 delegate tests.

### Generation CLI wiring `[foundation]`
- **Status:** done
- **Description:** --lang racket-oo registered, generates Foundation (382 files).
- **Results:** Complete. Both OO and functional directories populated.

### TestKit snapshot tests `[testing]`
- **Status:** done
- **Description:** 10 golden files, full directory comparison.
- **Results:** Complete.

### Foundation snapshot tests `[testing]`
- **Status:** done
- **Description:** 18 curated golden files with subset matching.
- **Results:** Complete.

### OO smoke tests `[testing]`
- **Status:** done
- **Description:** 54 Racket tests across 5 files.
- **Results:** Complete. Fixed 3 bugs: runtime paths, Swift selectors, coerce-arg.

### Hello Window app `[apps]`
- **Status:** done
- **Description:** Object lifecycle, property setters, NSWindow.
- **Results:** Validated in TestAnyware VM.

### Counter app `[apps]`
- **Status:** done
- **Description:** Target-action, buttons, mutable state.
- **Results:** Validated. Delegate bridge target-action pattern works.

### UI Controls Gallery app `[apps]`
- **Status:** done
- **Description:** All standard AppKit controls.
- **Results:** Validated. Fixed 2 emitter bugs: duplicate emission + typedef alias mapping.

## Session Log

### Pre-history (migrated from milestone 9 learnings)
- Racket emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields
- Dylib name: `libAPIAnywareRacket` (not `libanyware_racket`); only `swift-helpers.rkt` references it
- Generated runtime paths: `../../../runtime/` for class files, `../../../../runtime/` for protocol files
- Swift-style selectors (containing `(`) must be filtered — `init(string:)` can't be called via objc_msgSend
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases must be resolved to canonical types at collection time
- `NSEdgeInsets` not in geometry struct alias list — omit from apps until fixed
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
- Always `pkill -9 -f racket` before relaunching apps
```

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_STATE/targets/racket-oo/plan.md
git commit -m "feat: migrate racket-oo plan to backlog format"
```

---

### Task 6: Create `LLM_STATE/overview.md`

The status dashboard.

**Files:**
- Create: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/overview.md`

- [ ] **Step 1: Write the overview**

```markdown
# APIAnyware Status

At-a-glance view of the project. Updated at session boundaries.

## Core Pipeline

| Area | Status | Notes |
|------|--------|-------|
| ObjC class collection | done | libclang-based, typedef resolution at extraction time |
| ObjC protocol collection | done | |
| ObjC enum collection | done | |
| C function collection | not started | needed for C-API style bindings |
| C enum/constant collection | not started | kCFRunLoopCommonModes, etc. |
| C callback type collection | not started | CGEventTapCallBack, etc. |
| Resolution (inheritance) | done | |
| Annotation (heuristic + LLM) | done | LLM step needs integration into CLI |
| Enrichment | done | needs hardening (global totals bug) |

## Targets

| Target | Status | Styles | Apps Done | Notes |
|--------|--------|--------|-----------|--------|
| racket-oo | active | oo (done), functional (not started), c-api (blocked) | 3/7 | Next: remaining apps |
| racket-functional | not started | functional | 0/7 | Needs functional emitter |

## Cross-Cutting Blockers

- C-API style for all targets blocked on core C function/enum/constant/callback extraction
- racket-functional style blocked on functional emitter implementation
- AppKit snapshot tests blocked on AppKit enriched IR
```

- [ ] **Step 2: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_STATE/overview.md
git commit -m "feat: create overview status dashboard"
```

---

### Task 7: Delete old plan files

Remove the monolithic plan and old plans directory.

**Files:**
- Delete: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/plan.md`
- Delete: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/plans/plan-template.md`
- Delete: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/plans/racket-oo/plan.md`
- Delete: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/plans/racket-oo/` (directory)
- Delete: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/plans/` (directory)

- [ ] **Step 1: Verify new plans exist before deleting old ones**

```bash
ls /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/core/plan.md \
   /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets/racket-oo/plan.md \
   /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/targets/template.md \
   /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/overview.md
```

Expected: all four files listed without errors.

- [ ] **Step 2: Delete old files**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git rm LLM_STATE/plan.md
git rm LLM_STATE/plans/plan-template.md
git rm LLM_STATE/plans/racket-oo/plan.md
```

- [ ] **Step 3: Remove empty directories and commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
rmdir LLM_STATE/plans/racket-oo LLM_STATE/plans
git commit -m "chore: remove old monolithic plan and plans directory"
```

---

### Task 8: Delete project-specific skills

Remove all skill files from `.claude/skills/`.

**Files:**
- Delete: `/Users/antony/Development/APIAnyware-MacOS/.claude/skills/add-app.md`
- Delete: `/Users/antony/Development/APIAnyware-MacOS/.claude/skills/add-target.md`
- Delete: `/Users/antony/Development/APIAnyware-MacOS/.claude/skills/` (directory, if empty after)

- [ ] **Step 1: Delete skill files**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git rm .claude/skills/add-app.md
git rm .claude/skills/add-target.md
```

- [ ] **Step 2: Remove empty directory if no other files**

```bash
rmdir /Users/antony/Development/APIAnyware-MacOS/.claude/skills 2>/dev/null || true
```

- [ ] **Step 3: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git commit -m "chore: remove project-specific skills (replaced by prompt exemplars)"
```

---

### Task 9: Update `LLM_CONTEXT/project-workflow.md`

Remove skill references, update plan locations, simplify.

**Files:**
- Modify: `/Users/antony/Development/APIAnyware-MacOS/LLM_CONTEXT/project-workflow.md`

- [ ] **Step 1: Replace the entire file content**

```markdown
# Project Workflow

## Overview

APIAnyware-MacOS is a matrix project: N targets x M apps, generating idiomatic macOS
bindings for non-mainstream languages.

A **target** is a language+paradigm combination — a top-level directory with its own
emitter crate, runtime, apps, tests, and generated output. `racket-oo` and
`racket-functional` are independent targets, just like `racket-oo` and `haskell-monadic`.

Apps progress from simple (hello-window) to complex (menu-bar-tool), culminating in
Modaliser as the capstone proving a target's bindings are production-ready.

## Plans and Progress

Plans use the backlog format described in `../LLM_CONTEXT/backlog-plan.md`. Each plan
has a continuation prompt you copy to start a session.

- `LLM_STATE/overview.md` — at-a-glance status dashboard
- `LLM_STATE/core/plan.md` — core pipeline (collection, analysis, enrichment)
- `LLM_STATE/targets/{target}/plan.md` — per-target plans

Core pipeline and target plans are independent. If a target needs a pipeline feature,
it marks a task as `blocked` with a dependency on the core plan.

To create a new plan, follow `../LLM_CONTEXT/create-a-multi-session-plan.md`.

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

## Adding To The Matrix

### Adding a new target
See `LLM_STATE/new-language-guide.md` for the 11-step checklist. Use
`LLM_STATE/targets/template.md` to create the target's plan.

### Adding a new app
1. Create `knowledge/apps/{name}/` with spec.md, learnings.md, test-strategy.md
2. Update `knowledge/apps/_index.md`
3. For each existing target: create app directory with CLAUDE.md, create matrix knowledge file

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
1. Note the issue in the target plan (mark task blocked if necessary)
2. Add a task to `LLM_STATE/core/plan.md`
3. Fix in a core pipeline session
4. Re-generate affected targets
5. Capture the learning in `knowledge/pipeline/{area}.md`

## Coding Standards

See `LLM_CONTEXT/coding-style.md` for project-specific conventions.

Key points: TDD, descriptive names, small files, `thiserror`/`anyhow`, `tracing`,
bounded channels, no `unwrap`/`expect`, `cargo +nightly fmt`.

## App Progression

See `knowledge/apps/_index.md` for the full catalogue. Simple -> complex -> Modaliser capstone.
Each app exercises specific macOS/binding capabilities.
```

- [ ] **Step 2: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_CONTEXT/project-workflow.md
git commit -m "docs: update project-workflow.md for backlog plans, remove skill references"
```

---

### Task 10: Update `LLM_CONTEXT/index.md`

Remove observational-memory plugin references.

**Files:**
- Modify: `/Users/antony/Development/APIAnyware-MacOS/LLM_CONTEXT/index.md`

- [ ] **Step 1: Replace the entire file content**

```markdown
# LLM Context

Project-wide instructions for Claude sessions working on APIAnyware-MacOS.

## Start here

- `project-workflow.md` — master reference: how the project is organised, the knowledge
  system, plans, adding targets/apps, testing workflow
- `coding-style.md` — Rust coding conventions and project-specific style rules
- `../LLM_CONTEXT/backlog-plan.md` — how multi-session plans work (work cycle, task
  format, session log format)
```

- [ ] **Step 2: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_CONTEXT/index.md
git commit -m "docs: update index.md, remove observational-memory references"
```

---

### Task 11: Update `CLAUDE.md`

Update the project root CLAUDE.md to reflect the new structure.

**Files:**
- Modify: `/Users/antony/Development/APIAnyware-MacOS/CLAUDE.md`

- [ ] **Step 1: Replace the "How This Project Is Organised" section**

Find the block starting with `## How This Project Is Organised` and ending before `## Build & Test Commands`. Replace with:

```markdown
## How This Project Is Organised

This is a matrix project: N targets x M apps, with shared pipeline and testing infrastructure.

**Before doing any implementation work**, read `LLM_CONTEXT/project-workflow.md` — it explains
the full workflow and knowledge system.

**Key directories:**
- `knowledge/` — all learnings, app specs, testing strategies, organised by axis
- `generation/targets/{target}/` — one per language+paradigm combination
- `LLM_STATE/` — plans and status tracking
- `LLM_CONTEXT/` — project-wide instructions and coding standards

**Plans (backlog format — see `../LLM_CONTEXT/backlog-plan.md`):**
- `LLM_STATE/overview.md` — at-a-glance status dashboard
- `LLM_STATE/core/plan.md` — core pipeline backlog
- `LLM_STATE/targets/{target}/plan.md` — per-target backlogs

To start a session, copy the continuation prompt from the relevant plan file.
```

- [ ] **Step 2: Replace the "Plan & Progress Tracking" section**

Find the block starting with `## Plan & Progress Tracking` and ending before `## Language Targets`. Replace with:

```markdown
## Plan & Progress Tracking

Plans use the backlog format described in `../LLM_CONTEXT/backlog-plan.md`. Each session
starts by triaging the task backlog and picking the best next task.

- `LLM_STATE/overview.md` — status dashboard
- `LLM_STATE/core/plan.md` — core pipeline (collection, analysis, enrichment)
- `LLM_STATE/targets/{target}/plan.md` — per-target plans

Core and target plans are independent. Copy the continuation prompt from a plan file to
start a session.
```

- [ ] **Step 3: Update the "Language Targets" section**

Find the block starting with `## Language Targets` and ending before `## GUI Testing with TestAnyware`. Replace with:

```markdown
## Language Targets

Each target gets: an emitter crate, a runtime library, generated bindings, sample apps, and snapshot tests. See `LLM_STATE/new-language-guide.md` for the 11-step checklist and `LLM_STATE/targets/template.md` for the plan template.

Generated output lands at `generation/targets/{target}/generated/{style}/{framework}/`. Runtimes at `generation/targets/{target}/runtime/`. Sample apps at `generation/targets/{target}/apps/`.
```

- [ ] **Step 4: Verify no stale references remain**

```bash
grep -n "begin-work\|/reflect\|/create-plan\|/add-app\|/add-target\|observational-memory\|plans/plan-template\|LLM_STATE/plan\.md" /Users/antony/Development/APIAnyware-MacOS/CLAUDE.md
```

Expected: no matches. If any remain, fix them.

- [ ] **Step 5: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for backlog plans, remove skill references"
```

---

### Task 12: Update `LLM_STATE/new-language-guide.md`

Fix references to old plan locations.

**Files:**
- Modify: `/Users/antony/Development/APIAnyware-MacOS/LLM_STATE/new-language-guide.md`

- [ ] **Step 1: Update Step 1 (Plan the target)**

Find:
```
Create `LLM_STATE/plans/{target}/plan.md` by instantiating `LLM_STATE/plans/plan-template.md`:
```

Replace with:
```
Create `LLM_STATE/targets/{target}/plan.md` by instantiating `LLM_STATE/targets/template.md`:
```

- [ ] **Step 2: Update the header fields instructions**

Find:
```
   - **Milestone** — next available milestone number in `plan.md`
```

Replace with:
```
   - **Status** — initial status (usually "not started")
```

- [ ] **Step 3: Update the checklist at the bottom**

Find:
```
[ ] LLM_STATE/plans/{target}/plan.md created from template
```

Replace with:
```
[ ] LLM_STATE/targets/{target}/plan.md created from template
```

Find:
```
[ ] Main plan.md updated with completion status
```

Replace with:
```
[ ] LLM_STATE/overview.md updated with target status
```

- [ ] **Step 4: Verify no stale references remain**

```bash
grep -n "plans/\|plan\.md\|milestone\|Milestone" /Users/antony/Development/APIAnyware-MacOS/LLM_STATE/new-language-guide.md
```

Review output — `plan.md` references should all point to `targets/` not `plans/`. Milestone references in the checklist should be gone.

- [ ] **Step 5: Commit**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add LLM_STATE/new-language-guide.md
git commit -m "docs: update new-language-guide.md references to new plan locations"
```

---

### Task 13: Final verification

Verify everything is consistent.

**Files:**
- None (read-only verification)

- [ ] **Step 1: Check for stale references across the project**

```bash
cd /Users/antony/Development/APIAnyware-MacOS
grep -r "LLM_STATE/plan\.md\|LLM_STATE/plans/\|/begin-work\|/reflect\|/create-plan\|/add-app\|/add-target\|observational-memory" \
  --include="*.md" \
  --exclude-dir=docs/superpowers \
  --exclude-dir=.git \
  . | grep -v "node_modules"
```

Expected: no matches (the spec files in `docs/superpowers/` are excluded as they're design docs).

- [ ] **Step 2: Verify new file structure**

```bash
find /Users/antony/Development/APIAnyware-MacOS/LLM_STATE -type f | sort
```

Expected:
```
LLM_STATE/core/plan.md
LLM_STATE/new-language-guide.md
LLM_STATE/overview.md
LLM_STATE/targets/racket-oo/plan.md
LLM_STATE/targets/template.md
```

- [ ] **Step 3: Verify `../LLM_CONTEXT/` changes**

```bash
ls /Users/antony/Development/LLM_CONTEXT/backlog-plan.md
head -3 /Users/antony/Development/LLM_CONTEXT/create-a-multi-session-plan.md
```

Expected: `backlog-plan.md` exists; `create-a-multi-session-plan.md` starts with `# Creating a Multi-Session Plan`.

- [ ] **Step 4: Check that knowledge system is untouched**

```bash
ls /Users/antony/Development/APIAnyware-MacOS/knowledge/CLAUDE.md
```

Expected: file exists, unmodified.

- [ ] **Step 5: Commit any remaining fixes, if needed**

If step 1 found stale references, fix them and commit:

```bash
cd /Users/antony/Development/APIAnyware-MacOS
git add -A
git commit -m "fix: clean up remaining stale plan/skill references"
```
