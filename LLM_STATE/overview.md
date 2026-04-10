# APIAnyware Status

At-a-glance view of the project. Updated at session boundaries.

## Core Pipeline

| Area | Status | Notes |
|------|--------|-------|
| ObjC class collection | done | libclang-based, typedef resolution at extraction time |
| ObjC protocol collection | done | |
| ObjC enum collection | done | |
| C function collection | not started | needed for C-API style bindings |
| C enum/constant collection | not started | kCFRunLoopCommonModes, etc. |
| C callback type collection | not started | CGEventTapCallBack, etc. |
| Resolution (inheritance) | done | |
| Annotation (heuristic + LLM) | done | LLM step needs integration into CLI |
| Enrichment | done | needs hardening (global totals bug) |

## Targets

| Target | Status | Styles | Apps Done | Notes |
|--------|--------|--------|-----------|--------|
| racket-oo | active | oo (done), functional (not started), c-api (blocked) | 3/7 | Next: remaining apps |
| racket-functional | not started | functional | 0/7 | Needs functional emitter |

## Cross-Cutting Blockers

- C-API style for all targets blocked on core C function/enum/constant/callback extraction
- racket-functional style blocked on functional emitter implementation
- AppKit snapshot tests blocked on AppKit enriched IR
