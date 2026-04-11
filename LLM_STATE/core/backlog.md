# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Supports ObjC class/protocol/enum extraction and C function/enum/
constant extraction including function pointer typedefs.

## Task Backlog

### Test coverage hardening `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Comprehensive testing across the entire pipeline (collection,
  resolution, annotation, enrichment, generation). Running all 283 frameworks exposed
  a real enrichment bug (global totals written to every framework). More comprehensive
  testing will catch similar issues before they compound across language targets.
  Priority: this is the top post-M9 hardening task — catch bugs before they compound
  across language targets.
- **Results:** _pending_

### AppKit enrichment `[analysis]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Run the full analysis pipeline (resolve → annotate → enrich) on
  AppKit to produce enriched IR. Currently only Foundation has enriched IR. AppKit
  enrichment unblocks AppKit snapshot golden files in target plans and is needed for
  any app using AppKit-specific APIs beyond what Foundation provides.
- **Results:** _pending_

### LLM annotation integration `[analysis]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** The LLM annotation step currently requires external shell scripts
  and manual invocation. Must run within Claude Code sessions using subagents per
  framework for economic reasons (not external API calls). Design as a Claude Code
  workflow — likely a command that reads annotated IR, filters to methods needing LLM
  classification (those heuristics couldn't classify), presents them to Claude for
  analysis via subagents (one per framework), and writes results as `.llm.json` files
  that the existing merge pipeline consumes. The prompt template at
  `analysis/scripts/prompt-template.md` is the starting point. This replaces the
  external API approach in `analysis/scripts/llm-annotate.sh`.
- **Results:** _pending_
