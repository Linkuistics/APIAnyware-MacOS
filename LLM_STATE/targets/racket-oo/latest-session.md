### Session 20 (2026-04-17T06:48:03Z) — CString type, CFSTR emission, Modaliser FFI blockers, class predicates

- **Attempted:** Three Modaliser FFI upstream blockers (objc-interop re-export, AX raw/array helpers, CGEvent tap disabled-event support), PDFKit collection diagnosis, and a batch of emitter/collection correctness fixes revealed by the type-mapping work.

- **What worked:**
  - `objc-interop.rkt` landed as a curated named-`provide` re-export of `ffi/unsafe` + `ffi/unsafe/objc` symbols. Wired into runtime load harness; 21/21 checks pass (was 20).
  - `ax-helpers.rkt` gained `ax-get-attribute/raw` (returns +1 owned CFTypeRef) and `ax-get-attribute/array` (calls `cfarray->list` with `_CFRetain` per element). Added missing `_CFRetain` FFI binding.
  - `cgevent-helpers.rkt` gained `#:on-disabled` keyword on `make-cgevent-tap`. Default behaviour auto-re-enables the tap. Tap pointer plumbed via a `tap-box` to break the forward-reference cycle. Two new exports: `kCGEventTapDisabledByTimeout`/`kCGEventTapDisabledByUserInput`.
  - New IR type `TypeRefKind::CString` distinguishes `const char *` (Racket `_string`) from non-const `char *` (output buffer, stays `_pointer`). `macro_value` field added to `ir::Constant` for CFSTR macros.
  - CFSTR macro constants extracted from `MacroDefinition` entities in `extract_declarations.rs` via token-window pattern (`CFSTR ( "literal" )`). Emit as `(_make-cfstr "...")` using an inline CFStringCreateWithCString helper, not `ffi-obj-ref`.
  - `is_definition()` guards added for `ObjCProtocolDecl` and `StructDecl` to stop forward declarations from shadowing full definitions in the seen-set.
  - `Boolean` (Carbon) mapped to `_bool` in `map_typedef`; was `uint8`, breaking boolean-context usage.
  - Struct typedefs changed from `TypeRefKind::Alias` to `TypeRefKind::Struct` so `is_struct_data_symbol` in `emit_constants.rs` correctly emits `ffi-obj-ref` for struct-typed globals.
  - `is_generic_type_param` helper replaces the brittle prefix-allowlist (`!name.starts_with("NS") && …`) for detecting ObjC generic type parameters vs framework-prefixed enum aliases. Pattern: single uppercase letter followed by lowercase.
  - Class/instance property name sets split into two `HashSet`s. Instance properties that share a Racket name with a class method are now suppressed (not the class method). Property deduplication switched from ObjC name to Racket getter name to handle casing divergence between ObjC and Swift extractors.
  - `objc-instance-of?` added to `objc-base.rkt` with a class-lookup cache. Per-class predicates (`nsview?`, etc.) generated via `collect_return_type_class_names` + `emit_class_predicates` and emitted before `provide/contract`.
  - `runtime_block_nil_guard` test added to `runtime_load_test.rs`.
  - PDFKit/Quartz investigation: no fix needed — PDFKit.framework is a top-level SDK framework; the Quartz symlink resolves through libclang to the canonical path. PDFKit Viewer unblocked.
  - All golden files for AppKit and Foundation regenerated to match new emission.

- **What didn't work / wasn't attempted:** No sample app work this session. Emitter changes are substantial; a full pipeline re-run to verify golden files is still pending.

- **What this suggests trying next:** Run the full pipeline re-run and update golden files. Then pick up one of the sample app tasks (Note Editor, Drawing Canvas, PDFKit Viewer, or SceneKit Viewer). PDFKit Viewer is now unblocked and lowest-risk given verified collection data.

- **Key learnings:**
  - `git diff` misses untracked new files; the new runtime `.rkt` files (`ax-helpers.rkt`, `cf-bridge.rkt`, `cgevent-helpers.rkt`, `nsview-helpers.rkt`, `objc-interop.rkt`, `spi-helpers.rkt`) are visible only in `git status` — they need to be staged and committed.
  - The prefix-allowlist for generic type params was fragile and wrong for `AXValueType` (starts with "AX", previously treated as generic). The two-character heuristic (single uppercase + lowercase) is correct for all known Apple SDK generic type params.
  - Forward declaration shadowing in the seen-set was a real bug: a `@protocol Foo;` forward decl inserted `Foo` into `seen_protocols` before the full `@protocol Foo { ... }` definition could be processed, silently dropping the protocol from the IR.
