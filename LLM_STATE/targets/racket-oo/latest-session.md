### Session 20 (2026-04-17T12:12:37Z) — PDFKit Viewer app + generator correctness fixes

- **Attempted:** Build and VM-validate the PDFKit Viewer sample app; fix generator correctness bugs
  discovered during that work; harden the runtime load test harness.

- **What worked:**
  - PDFKit Viewer landed and fully VM-validated via GUIVisionVMDriver: empty state ("No PDF loaded"),
    NSOpenPanel `.pdf` filter, PDF rendering, ◀/▶ page navigation, page-label refresh from
    `PDFViewPageChangedNotification`, nav-button enable/disable at document boundaries.
  - `PDFKit` added to `REQUIRED_FRAMEWORKS`; `drawing-canvas` and `pdfkit-viewer` added to `APPS`
    in the runtime load harness — all 6 sample apps now compile under `raco make` (53s).
  - **Generator: class-return predicates** — `collect_return_type_class_names` + `emit_class_predicates`
    in `emit_class.rs` generate per-class inline predicates (`nsview?`, `pdfdocument?`, etc.) backed
    by `objc-instance-of?`; `map_return_contract` now emits `<class>?` instead of `any/c` for
    `TypeRefKind::Class` returns.
  - **Runtime: `objc-instance-of?`** — added to `objc-base.rkt` with class-name caching via
    `objc_getClass`; exported and used by all generated class predicates.
  - **Generator: property deduplication by Racket name** — `effective_properties` now deduplicates
    on the generated getter name, not the raw ObjC name, so ObjC/Swift extractor pairs that differ
    only in casing (e.g. `CGDirectDisplayID` vs `cgDirectDisplayID`) no longer produce duplicate
    `define` forms.
  - **Generator: class/instance property name set partitioning** — `build_property_name_sets` splits
    collision detection into class-level and instance-level; class methods now only suppress
    class-property names (not instance properties), fixing the `NSMenuItem +separatorItem` vs
    `separatorItem` boolean property collision.
  - **Collector: `const char *` → `TypeRefKind::CString`** — `type_mapping.rs` now maps
    `const char *` pointer/typedef paths to `CString`; non-const `char *` (output buffers) stays
    `Pointer`; `ffi_type_mapping.rs` maps `CString` to `_string`.
  - **Generator: `CString` return contracts** — `map_contract` in `emit_functions.rs` emits
    `(or/c string? #f)` for CString returns (NULL maps to `#f` via `_string`) and `string?` for
    CString params; golden `functions.rkt` snapshot updated.
  - **Generator: `Boolean` typedef → `_bool`** — `map_typedef` in `type_mapping.rs` maps Carbon's
    `Boolean` to `bool` (same branch as ObjC `BOOL`); prevents `0` being truthy in Racket.
  - **Generator: `is_generic_type_param`** — extracted as `pub fn` in `ffi_type_mapping.rs`,
    replacing the brittle namespace-prefix blocklist with a structural check (single uppercase +
    lowercase start); shared between `ffi_type_mapping.rs` and `emit_functions.rs`.
  - **Generator: foreign-thread safety warnings** — `emit_functions.rs` emits a `; WARNING:` comment
    block before any function with a callback parameter (`FunctionPointer` or `Block`); golden
    `functions.rkt` snapshot updated.
  - **Generator: CFSTR macro constants** — `extract_declarations.rs` handles `MacroDefinition` AST
    nodes and extracts `#define kFoo CFSTR("literal")` patterns via token scanning;
    `ir::Constant` gets a `macro_value: Option<String>` field; `emit_constants.rs` emits
    `(_make-cfstr "literal")` forms with a CoreFoundation preamble; golden `constants.rkt` snapshot
    updated; tests added for all paths.
  - **Collector: forward-decl guards** — `extract_declarations.rs` now gates `ObjCProtocolDecl`
    and `StructDecl` on `entity.is_definition()` to prevent forward declarations from shadowing
    full definitions via the `seen_*` sets; `ObjCInterfaceDecl` explicitly ungated with a comment.
  - **Runtime load harness** — 7 new runtime files added to `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`
    (`ax-helpers.rkt`, `cf-bridge.rkt`, `cgevent-helpers.rkt`, `nsevent-helpers.rkt`,
    `nsview-helpers.rkt`, `objc-interop.rkt`, `spi-helpers.rkt`); `runtime_block_nil_guard` test
    added to verify `make-objc-block #f` nil-guard behavior.
  - **Test coverage** — extensive unit tests added across `emit_class.rs`, `emit_constants.rs`,
    `emit_functions.rs`, `ffi_type_mapping.rs`; `snapshot_test.rs` updated with new fixture
    functions `TKGetName` (CString return), `TKRegisterCallback` (callback param),
    `TKStatusAttribute` (CFSTR constant).
  - **Backlog housekeeping** — 8 new gaps filed in `LLM_STATE/core/backlog.md` (nullable class
    returns, auto-wrap `list->nsarray`, `nsevent.rkt` selector collision, `wkwebview.rkt` unbound
    `_NSEdgeInsets`, `bool`/`BOOL` return `_bool` fix, AXValue type-width mismatch, CF struct
    globals, Racket `.app` bundler); protocol emitter int/long fix moved to Completed.

- **What didn't work / gaps discovered:**
  - Nullable class-return predicates not yet implemented — `pdfview-document` / `pdfview-current-page`
    raise contract violations when PDFView is empty (nil return). Workaround in-app; gap filed.
  - `list->nsarray` returns a raw cpointer; class-wrapper param contracts reject it. Workaround:
    `(wrap-objc-object … #:retained #t)`. Gap filed.

- **What to try next:** Note Editor sample app (completion blocks, NSUndoManager, NSSavePanel,
  cross-framework AppKit+WebKit); or tackle nullable class-return predicates / `list->nsarray`
  auto-wrap from the core backlog.

- **Key learnings:**
  - Clang's `ObjCInterfaceDecl` is always a declaration (never `is_definition()` true) because
    `@implementation` lives in `.m` files absent from SDK headers — ungating it is correct and
    necessary.
  - `_string` in Racket FFI converts NULL C pointers to `#f`, so nullable return contracts must
    include `#f` even when the IR marks the field as non-nullable.
  - Class-method vs instance-property collision detection must be partitioned: class methods should
    only check class property names, not instance property names, to avoid suppressing valid factory
    methods (e.g. `+separatorItem`).
