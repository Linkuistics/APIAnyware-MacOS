# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Supports ObjC class/protocol/enum extraction and C function/enum/
constant extraction including function pointer typedefs.

## Task Backlog

### C function extraction `[collection]`
- **Status:** done
- **Dependencies:** none
- **Description:** Extract C functions from framework headers via libclang.
- **Results:** Fully implemented. `FunctionDecl` handler in `extract_declarations.rs`,
  `Function` IR type, dedup, sorting, CLI wiring all in place. Verified output:
  CoreFoundation 858 functions, CoreGraphics 777, Foundation 186, Security 676.
  Specific functions confirmed: CGEventTapCreate (6 params), CFRunLoopAddSource,
  CFDictionaryCreate.

### C enum and constant extraction `[collection]`
- **Status:** done
- **Dependencies:** none
- **Description:** Extract C enums (via `EnumDecl` — same handler as ObjC enums) and
  extern const globals (via `VarDecl` handler). `#define` constants are not captured
  (preprocessor, not AST) but are rarely needed for FFI bindings.
- **Results:** Fully implemented. Verified: CoreFoundation 382 constants (kCFBooleanTrue,
  kCFRunLoopCommonModes confirmed), Security 1141 constants. C enums extracted via
  existing `EnumDecl` handler.

### C callback type extraction `[collection]`
- **Status:** done
- **Dependencies:** none
- **Description:** Function pointer typedefs like `CGEventTapCallBack` are now resolved
  to `FunctionPointer` TypeRefKind with full parameter and return type signatures.
- **Results:** Added `FunctionPointer` variant to `TypeRefKind` with `name`, `params`,
  and `return_type`. Updated `map_typedef` and `map_type_kind` to detect function
  pointer types via `FunctionPrototype` pointee. Verified: CoreGraphics 15 callback
  params (CGEventTapCallBack, CGBitmapContextReleaseDataCallback, etc.),
  CoreFoundation 28, Security 7. Exhaustive match updates in `ffi_type_mapping.rs`
  and `emit_protocol.rs`. 7 new tests (4 serde roundtrip + 3 integration).

### Swift stub launcher for TCC-compatible app bundles `[tooling]`
- **Status:** not_started
- **Dependencies:** app bundler (above) — this is a sub-component
- **Description:** macOS TCC (Transparency, Consent, Control) identifies processes by
  code directory hash (CDHash). Language runtime binaries like `racket`/GRacket share
  their CDHash across all apps — so granting Accessibility to one Racket app silently
  grants it to ALL Racket processes, and `AXIsProcessTrustedWithOptions` never prompts
  because the binary is already trusted. This makes per-app permission management
  impossible and causes confusing UX (no prompt appears, or permissions leak between
  unrelated apps). The fix: a tiny compiled Swift stub binary (~50KB) per app that
  `exec`s into the language runtime. Each stub has its own unique CDHash, so TCC treats
  each app independently — just like Electron apps each have their own binary wrapper.
  The stub is ~5 lines of Swift:
  ```swift
  import Foundation
  let racket = "/opt/homebrew/bin/racket"  // resolved at build time
  let main = Bundle.main.path(forResource: "main", ofType: "rkt", inDirectory: "racket-app")!
  execv(racket, [racket, main].map { strdup($0) })
  ```
  This must be compiled per-app (so each gets a unique CDHash) and placed at
  `Contents/MacOS/<AppName>` in the .app bundle. The `execv` replaces the stub process
  with the runtime, so the runtime inherits the stub's TCC grants. Proven by the
  Modaliser-Racket experience: without the stub, `raco exe --launcher` produced a
  GRacket binary that shared permissions with all Racket processes, caused phantom
  permission grants, and prevented the accessibility prompt from appearing.
- **Results:** _pending_

### LLM annotation integration `[analysis]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** The LLM annotation step currently requires external shell scripts
  and manual invocation. Make it a proper pipeline step in the Rust CLI
  (`apianyware-macos-analyze annotate`). Must run within Claude Code sessions using
  subagents per framework for economic reasons (not external API calls).
- **Results:** _pending_

### Test coverage hardening `[testing]`
- **Status:** not_started
- **Dependencies:** none
- **Description:** Comprehensive testing across the entire pipeline (collection,
  resolution, annotation, enrichment, generation). Running all 283 frameworks exposed
  a real enrichment bug (global totals written to every framework). More comprehensive
  testing will catch similar issues before they compound across language targets.
- **Results:** _pending_

