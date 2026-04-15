# LLM Annotation Subagent Prompt

This prompt is used by Claude Code subagents to annotate macOS framework methods.
Each subagent processes one framework's method summary and produces a `.llm.json` file.

## Usage

From a Claude Code session, run the LLM annotation workflow:

```
# Step 1: Extract interesting methods from resolved IR
cargo run -p apianyware-macos-analyze -- llm-extract

# Step 2: For each framework summary, spawn a Claude Code subagent:
#   The subagent reads analysis/ir/llm-summaries/{Framework}.methods.json,
#   consults Apple documentation (via web search), and writes
#   analysis/ir/llm-annotations/{Framework}.llm.json

# Step 3: Merge LLM annotations into annotated checkpoints
cargo run -p apianyware-macos-analyze -- annotate --llm-dir analysis/ir/llm-annotations
```

## Subagent Prompt Template

Use this prompt when spawning a subagent for framework `{FRAMEWORK}`:

---

You are annotating macOS `{FRAMEWORK}` framework methods for a code generation system.

**Input:** Read the method summary at `analysis/ir/llm-summaries/{FRAMEWORK}.methods.json`.
This contains methods that need semantic classification — they have block parameters,
error out-params, or delegate/observer patterns that heuristics can't fully classify.

**Task:** For each method, determine:

1. **Block invocation style** (`block_parameters`): For block-typed params, classify as:
   - `synchronous` — called during the method, NOT copied (caller frees)
   - `async_copied` — copied for later async invocation (runtime manages lifecycle)
   - `stored` — stored for repeated invocation (observers, handlers)

2. **Parameter ownership** (`parameter_ownership`): For non-block object params:
   - `weak` — receiver does NOT retain (delegates, data sources, targets)
   - `copy` — receiver copies the value
   - Only annotate non-default (non-strong) ownership

3. **Threading** (`threading`):
   - `main_thread_only` — must be called on main thread
   - `any_thread` — explicitly thread-safe
   - Only annotate if determinable from Apple documentation

4. **Error pattern** (`error_pattern`):
   - `error_out_param` — last param is NSError**, returns nil/NO on failure
   - `nil_on_failure` — returns nil on failure, no error param

**How to decide:** Consult Apple's developer documentation. The `reasons` field in each
method tells you why it was flagged. Focus on what the documentation says about:
- Block lifecycle (is the block called synchronously during the method?)
- Parameter retention (does the receiver retain this parameter?)
- Threading requirements (is this main-thread-only?)

**Output:** Write a JSON file at `analysis/ir/llm-annotations/{FRAMEWORK}.llm.json` with this schema:

```json
{
  "framework": "{FRAMEWORK}",
  "classes": [
    {
      "class_name": "NSClassName",
      "methods": [
        {
          "selector": "methodName:withParam:",
          "is_instance": true,
          "parameter_ownership": [{"param_index": 0, "ownership": "weak"}],
          "block_parameters": [{"param_index": 1, "invocation": "async_copied"}],
          "threading": "main_thread_only",
          "error_pattern": "error_out_param",
          "source": "llm"
        }
      ]
    }
  ]
}
```

Rules:
- Only include methods where you have non-default annotations to add
- Set `source` to `"llm"` for all annotations
- Omit empty arrays and null fields
- If unsure about a block invocation style, default to `async_copied` (safest)
- Sort classes alphabetically, methods by selector

---

## Orchestration Example

In a Claude Code session:

```python
# Pseudo-code for the orchestration loop
for summary_file in glob("analysis/ir/llm-summaries/*.methods.json"):
    framework = extract_framework_name(summary_file)
    spawn_subagent(
        prompt=SUBAGENT_PROMPT.replace("{FRAMEWORK}", framework),
        description=f"Annotate {framework} methods",
    )
```

The subagents run in parallel (one per framework) and write independent `.llm.json` files.
After all complete, run:

```bash
cargo run -p apianyware-macos-analyze -- annotate --llm-dir analysis/ir/llm-annotations
```
