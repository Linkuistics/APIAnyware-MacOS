# TODO

## Current Priority: Complete Racket OO Target (Milestone 9)

### 9.7 Sample Apps -- OO Style (4 remaining)

The hello-window, counter, and ui-controls-gallery apps are complete. Four more are needed:

- **Implement the file-lister sample app** for Racket OO at `generation/targets/racket-oo/apps/file-lister/`. This app exercises NSTableView, data source delegate pattern, NSFileManager, and NSOpenPanel. Follow the spec in the plan and use the existing hello-window and counter apps as reference for runtime imports and dylib paths. The app must use `generation/targets/racket-oo/runtime/` and the generated bindings from `generation/targets/racket-oo/generated/oo/`.

- **Implement the text-editor sample app** for Racket OO at `generation/targets/racket-oo/apps/text-editor/`. This app exercises block callbacks, error-out patterns, undo/redo, notifications, and find functionality. See the existing sample apps for patterns.

- **Implement the mini-browser sample app** for Racket OO at `generation/targets/racket-oo/apps/mini-browser/`. This app uses cross-framework WebKit integration, WKNavigationDelegate, and URL handling.

- **Implement the menu-bar-tool sample app** for Racket OO at `generation/targets/racket-oo/apps/menu-bar-tool/`. This app exercises NSStatusBar, NSMenu, no-window app lifecycle, timers, and clipboard access.

### 9.9 TestAnyware Validation

- **Run all Racket OO sample apps through TestAnyware** (`../TestAnyware/`) for GUI validation. For each app: boot the macOS VM with shared directory, build the app, launch it, take screenshots, verify visual correctness. Document results in `generation/targets/racket-oo/test-results/`. Use the workflow documented in the knowledge base at `knowledge/testanyware/general.md`.

### 9.10 Per-Framework Exercisers

- **Create per-framework exerciser scripts** that import each generated Racket OO framework binding and verify it loads without errors. These should cover at least the major frameworks (Foundation, AppKit, CoreFoundation, CoreGraphics, WebKit, CoreData) and confirm that class lookups, method dispatch, and property access work for representative classes.

### 9.11 Documentation Placeholder

- **Create a documentation placeholder** at `generation/targets/racket-oo/docs/` with getting-started instructions, runtime requirements (Racket installation, dylib path setup), and a quick-start guide showing how to use the generated bindings to create a basic macOS window.

## Review 9: Hardening and LLM Integration

These should be completed before starting additional language targets.

- **Create a framework ignore list** in the collection or generation config that explicitly marks DriverKit, Tk, and any other inappropriate frameworks (C++ headers, Tcl/Tk, stub-only) as ignored with documented reasons, rather than silently failing or producing empty output.

- **Audit test coverage** across collection, resolution, annotation, enrichment, and generation. Identify gaps and add tests targeting 100% coverage of all code paths. Consider property-based tests and cross-framework integration tests.

- **Replace `llm-annotate.sh` with a Rust command** (`apianyware-macos-analyze llm-annotate`) that handles batching, provider configuration, prompt management, and merge within the Rust codebase -- no manual steps required.

- **Perform a code review and cleanup pass** to address any accumulated tech debt, naming inconsistencies, or dead code.

## Racket Functional Emitter (Milestone 9.8)

- **Implement the Racket Functional emitter** at `generation/crates/emit-racket-functional/`. The crate exists as a stub. It should emit plain-procedure Racket bindings using explicit `objc_msgSend` calls (no class wrappers). Model it on the Racket OO emitter but produce `(define (ns-string-init-with-string str) ...)` style procedures instead of class definitions. Read the enriched IR the same way the OO emitter does.

## Next Language Target: Chez Scheme (Milestone 10)

- **Begin the Chez Scheme target** by following the 11-step template in `LLM_STATE/plans/plan-template.md`. Create `LLM_STATE/plans/chez/plan.md` from the template. The Swift dylib `APIAnywareChez` already exists as a stub. The emitter crate should be created at `generation/crates/emit-chez/`. Chez Scheme uses a functional binding style with its native FFI (`foreign-procedure`).

## Infrastructure Improvements

- **Migrate from observational-memory plugin to Mnemosyne** (`../Mnemosyne`). Update `.observational-memory.yml`, `LLM_CONTEXT/project-workflow.md`, `CLAUDE.md`, and skill references. See the previous TODO.md for the detailed migration plan.

- **Extract option set / bitmask enum values** during collection. Currently, enums like NSWindowStyleMask have 0 values in the enriched IR because the collector creates enum entries but does not extract individual flag constants. Sample apps must define these inline. Fix the ObjC extractor to capture bitmask values from the SDK headers.
