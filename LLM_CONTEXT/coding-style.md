# Coding Style Guidelines

> **Note:** This file contains project-specific coding conventions.

When writing or refactoring code in this project, follow these principles:

## Development Approach
- **Use Test-Driven Development (TDD)** - This is particularly useful when working with LLMs
- Write tests first, then implement the functionality

## File Organization
- **Keep files small** - Break large files into modules with smaller, focused files
- **Each file should contain closely related functionality only**
- **File and module names must be descriptive** of their functionality

## Naming Conventions
- **Use descriptive names** for modules, functions, and variables
- **Avoid short, cryptic names** - clarity is prioritized over brevity. Long names are perfectly fine if they improve descriptiveness by removing ambiguity i.e. being fully explicit. This applies to function and variable names as well as module and file names.
- **Use uniform naming semantics** - for example, don't use BlahName and FooId if both wrap string identifiers; choose one convention and stick to it. Rename existing code to conform to the chosen convention when necessary.
- **Use consistent naming patterns** - for example, if you have a function called `get_thing`, don't have another function called `fetch_thing` that does the same thing; choose one verb and use it consistently across the codebase.

## Code Quality Principles
- **Simplicity** - Code should be as simple as possible
- **Readability** - Maximum readability is essential
- **Reusability** - Code should be reusable and composable
- **Single Concern** - Code should be decomplected (handle only one concern)
- **Testability** - All code should be designed to be testable

## Rust-Specific Guidelines

### Formatting (rustfmt)
- **Edition:** 2021
- **Import Grouping:** Group imports as StdExternalCrate (stdlib, external crates, then local)
- **Import Granularity:** Crate level (merge imports from the same crate)
- **Field Init Shorthand:** Always use field init shorthand when variable name matches field name
- **Apply formatting:** Run `cargo +nightly fmt` before committing

### Linting (clippy)
All workspace lints are set to "warn" level and enforced by CI.

#### Function Parameters
- **Maximum arguments:** 20 parameters (clippy threshold)
- If approaching this limit, consider refactoring into a configuration struct

#### Disallowed Patterns

**Unbounded Channels (DO NOT USE):**
- ❌ `tokio::sync::mpsc::unbounded_channel` - Use bounded channels instead
- ❌ `futures::channel::mpsc::unbounded` - Use bounded channels instead
- Reason: Unbounded channels can lead to memory issues and are for expert use only

**Blocking Operations:**
- ❌ `futures::executor::block_on` - Use `tokio::runtime::Runtime::block_on` instead

**Serialization:**
- ❌ `bincode::deserialize_from` - Use `bincode::deserialize` instead (safer)

**Encoding:**
- ❌ `base64::Engine::encode` - Use `fastcrypto::encoding::Base64::encode` instead
- ❌ `base64::Engine::decode` - Use `fastcrypto::encoding::Base64::decode` instead

### Logging
- **Use `tracing` macros** - `tracing::info!`, `tracing::debug!`, `tracing::error!`, `tracing::warn!`
- **Avoid `log` crate** - Being phased out in favor of tracing (with log feature enabled)

### Safety and Warnings
The following are enforced at workspace level:
- **Unsafe Code:** Marked as warning (use sparingly with clear justification)
- **Future Incompatible:** Warned
- **Nonstandard Style:** Warned
- **Rust 2018 Idioms:** Enforced
- **All Clippy Lints:** Enabled at warn level

### Error Handling
- Use `thiserror` for error types with `#[derive(Error)]`
- Use `anyhow` for application-level error handling, and `thiserror` for library-level error types
- Provide descriptive error messages
- Avoid using `unwrap` or `expect` in production code; handle errors gracefully
- Use `?` operator for propagating errors when appropriate
- Consider using `Result` types for functions that can fail, and avoid panicking unless absolutely necessary
- When defining custom error types, include relevant context and information to aid in debugging and error handling
- When handling errors, consider the user experience and provide actionable feedback when possible, rather than just logging the error or returning a generic message

### Async Code
- Use Tokio runtime
- Prefer bounded channels over unbounded
- Avoid blocking operations in async contexts

### Dependencies
- Workspace dependencies are managed centrally in root `Cargo.toml`
- Use workspace dependency versions to maintain consistency
- Justify any deviation from workspace versions
- Avoid unnecessary dependencies; prefer standard library and existing workspace dependencies when possible
