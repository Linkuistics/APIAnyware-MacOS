#!/bin/zsh
# Target: racket-oo — APIAnyware-MacOS
# Usage: ./run.sh
# Exit each phase with /exit to advance. Ctrl+C to stop the cycle.

DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="$(cd "$DIR/../../.." && pwd)"

while true; do
  # Phase 1: WORK
  echo "\n=== WORK PHASE ==="
  (cd "$PROJECT" && claude "Read LLM_CONTEXT/index.md for project context, then read
LLM_CONTEXT/backlog-plan.md for the phase cycle spec (focus on Phase 1: WORK).

Read LLM_STATE/targets/racket-oo/plan.md for the task backlog.
Read LLM_STATE/targets/racket-oo/memory.md for distilled learnings.

Pick one task, implement it, record results in plan.md, append a session log
entry to LLM_STATE/targets/racket-oo/session-log.md, then stop.

Target-specific context:
- Emitter crate: generation/crates/emit-racket-oo/
- Runtime: generation/targets/racket-oo/runtime/
- Generated output: generation/targets/racket-oo/generated/
- Apps: generation/targets/racket-oo/apps/
- Target learnings: knowledge/targets/racket-oo.md

Key commands:
- cargo test -p apianyware-macos-emit-racket-oo — emitter tests
- cargo run --bin apianyware-macos-generate -- --lang racket-oo — regenerate
- UPDATE_GOLDEN=1 cargo test -p apianyware-macos-emit-racket-oo — update golden files
- TestAnyware VM: ../TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket-oo:racket-oo

Constraints:
- TDD: write tests first
- Always pkill -9 -f racket before relaunching apps in VM
- Use base64 encoding to transfer files to VM (VirtioFS serves stale content)
- If blocked on core pipeline, note the dependency and pick a different task")

  # Phase 2: REFLECT
  echo "\n=== REFLECT PHASE ==="
  (cd "$PROJECT" && claude "Read LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 2: REFLECT).

Read LLM_STATE/targets/racket-oo/session-log.md — focus on the latest entry.
Read LLM_STATE/targets/racket-oo/memory.md — the current distilled learnings.

Distill learnings from the latest session into memory.md: add new entries,
sharpen existing ones, remove redundant or outdated ones. Then stop.")

  # Phase 3: TRIAGE
  echo "\n=== TRIAGE PHASE ==="
  (cd "$PROJECT" && claude "Read LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 3: TRIAGE).

Read LLM_STATE/targets/racket-oo/plan.md for the task backlog.
Read LLM_STATE/targets/racket-oo/memory.md for distilled learnings.

Review the backlog: reprioritize, split, add, or remove tasks based on current
learnings. If learnings affect the core plan (LLM_STATE/core/), add backlog
entries there rather than duplicating memories. Then stop.")

  echo "\n--- Cycle complete. Enter to continue, Ctrl+C to stop ---"
  read
done
