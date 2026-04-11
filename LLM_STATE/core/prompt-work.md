Read ../LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 1: WORK).

Read LLM_STATE/core/backlog.md for the task backlog.
Read LLM_STATE/core/memory.md for distilled learnings.

Display a summary of the current backlog (title, status, and priority for each
task). Then ask the user if they have any input on which task to work on next.
Wait for the user's response. If they have a preference, work on that task;
otherwise pick the best next task.

Implement it, record results in backlog.md, append a session log entry to
LLM_STATE/core/session-log.md.
Write reflect to LLM_STATE/core/phase.md, then stop.

Key commands:
- cargo test --workspace — run all tests
- cargo clippy --workspace — lint
- cargo +nightly fmt — format

Constraints:
- TDD: write tests first
- thiserror for library errors, anyhow for CLI
- No unwrap/expect in production code
