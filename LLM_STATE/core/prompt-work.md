Read {{DEV_ROOT}}/LLM_CONTEXT/fixed-memory/coding-style.md and {{DEV_ROOT}}/LLM_CONTEXT/fixed-memory/coding-style-rust.md
for coding style guidelines.

Key commands:
- cargo test --workspace — run all tests
- cargo clippy --workspace — lint
- cargo +nightly fmt — format

Constraints:
- TDD: write tests first
- thiserror for library errors, anyhow for CLI
- No unwrap/expect in production code
