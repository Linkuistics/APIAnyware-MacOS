#!/bin/zsh
# Core Pipeline — APIAnyware-MacOS
# Usage: ./run.sh
# Exit each phase with /exit to advance. Ctrl+C to stop the cycle.

DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="$(cd "$DIR/../.." && pwd)"
SESSION="$(basename "$PROJECT")"

while true; do
  # Phase 1: WORK
  echo "\n=== WORK PHASE ==="
  (cd "$PROJECT" && claude --allow-dangerously-skip-permissions -n "$SESSION" "Read LLM_CONTEXT/index.md for project context, then read
LLM_CONTEXT/backlog-plan.md for the phase cycle spec (focus on Phase 1: WORK).

Read LLM_STATE/core/plan.md for the task backlog.
Read LLM_STATE/core/memory.md for distilled learnings.

Display a summary of the current backlog (title, status, and priority for each
task). Then ask the user if they have any input on which task to work on next.
Wait for the user's response. If they have a preference, work on that task;
otherwise pick the best next task.

Implement it, record results in plan.md, append a session log entry to
LLM_STATE/core/session-log.md, then stop.

Key commands:
- cargo test --workspace — run all tests
- cargo clippy --workspace — lint
- cargo +nightly fmt — format

Constraints:
- TDD: write tests first
- thiserror for library errors, anyhow for CLI
- No unwrap/expect in production code
- See LLM_CONTEXT/coding-style.md for full conventions")

  # Phase 2: REFLECT
  echo "\n=== REFLECT PHASE ==="
  (cd "$PROJECT" && claude --allow-dangerously-skip-permissions -n "$SESSION" "Read LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 2: REFLECT).

Read LLM_STATE/core/session-log.md — focus on the latest entry.
Read LLM_STATE/core/memory.md — the current distilled learnings.

Distill learnings from the latest session into memory.md: add new entries,
sharpen existing ones, remove redundant or outdated ones. Then stop.")

  # Phase 3: TRIAGE
  echo "\n=== TRIAGE PHASE ==="
  (cd "$PROJECT" && claude --allow-dangerously-skip-permissions -n "$SESSION" "Read LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 3: TRIAGE).

Read LLM_STATE/core/plan.md for the task backlog.
Read LLM_STATE/core/memory.md for distilled learnings.

Review the backlog: reprioritize, split, add, or remove tasks based on current
learnings. If learnings affect sibling plans (e.g. LLM_STATE/targets/), add
backlog entries there rather than duplicating memories. Then stop.")

  echo "\n--- Cycle complete. Enter to continue, Ctrl+C to stop ---"
  read
done
