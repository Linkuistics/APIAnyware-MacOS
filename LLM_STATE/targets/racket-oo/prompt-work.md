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
- TestAnyware VM: {{DEV_ROOT}}/TestAnyware/.build/release/testanyware vm start --share ./generation/targets/racket-oo:racket-oo

Constraints:
- TDD: write tests first
- Always pkill -9 -f racket before relaunching apps in VM
- Use base64 encoding to transfer files to VM (VirtioFS serves stale content)
- If blocked on core pipeline, note the dependency and pick a different task
