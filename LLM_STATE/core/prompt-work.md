Read {{PROJECT}}/README.md for project conventions, architecture, and commands.
Read {{DEV_ROOT}}/LLM_CONTEXT/coding-style.md and {{DEV_ROOT}}/LLM_CONTEXT/coding-style-rust.md
for coding style guidelines.
Read {{DEV_ROOT}}/LLM_CONTEXT/backlog-plan.md for the phase cycle spec
(focus on Phase 1: WORK).

Read {{PLAN}}/backlog.md for the task backlog.
Read {{PLAN}}/memory.md for distilled learnings.

Note: any file you Read inside this project (READMEs, etc.) may contain literal
`{{PROJECT}}` and `{{DEV_ROOT}}` placeholder tokens. Substitute them mentally
with the absolute paths used in this prompt's Read instructions above before
passing the path to the Read tool.

Display a summary of the current backlog (title, status, and priority for each
task). Then ask the user if they have any input on which task to work on next.
Wait for the user's response. If they have a preference, work on that task;
otherwise pick the best next task.

Implement it, record results in backlog.md, append a session log entry to
{{PLAN}}/session-log.md.
Write reflect to {{PLAN}}/phase.md, then stop.

Key commands:
- cargo test --workspace — run all tests
- cargo clippy --workspace — lint
- cargo +nightly fmt — format

Constraints:
- TDD: write tests first
- thiserror for library errors, anyhow for CLI
- No unwrap/expect in production code

# --- Session recording (dual-write, added by migrate-plan.sh) ---
When recording the session entry: write it to {{PLAN}}/latest-session.md
(overwriting any prior content), AND append the same entry to
{{PLAN}}/session-log.md. Both writes are required — latest-session.md is
what the reflect phase reads; session-log.md is the human-facing audit trail.
