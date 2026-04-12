Read {{PROJECT}}/CLAUDE.md for project conventions, architecture, and commands.
Read {{LLM_CONTEXT}}/backlog-plan.md for the phase cycle spec
(focus on Phase 1: WORK).

Read {{PLAN}}/backlog.md for the task backlog.
Read {{PLAN}}/memory.md for distilled learnings.

Display a summary of the current backlog (title, status, and priority for each
task). Then ask the user if they have any input on which task to work on next.
Wait for the user's response. If they have a preference, work on that task;
otherwise pick the best next task.

Implement it, record results in backlog.md, append a session log entry to
{{PLAN}}/session-log.md.
Write reflect to {{PLAN}}/phase.md, then stop.

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
- If blocked on core pipeline, note the dependency and pick a different task
