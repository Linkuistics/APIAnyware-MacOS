### Session 20 (2026-04-17T14:06:14Z) — Generator bug fixes batch + triage

- **What was attempted:** Fix the four generator bugs filed in the previous triage session
  (NSMenuItem separatorItem collision, NSScreen duplicate define, CFStringGetCStringPtr nullable
  return contract, integer param widening). Also: backlog triage reflecting SceneKit Viewer done,
  plus filing new backlog tasks (spi-helpers free fix, self-contained bundling, developer docs).

- **What worked:**
  - Bug #1 (NSMenuItem separatorItem): Fixed by splitting the property-name collision set into
    class vs. instance partitions (`PropertyNameSets`). Instance properties whose getter name
    collides with a class method are now suppressed; the class method wins. Four unit tests
    added covering both the class-method-wins and class-property-wins cases.
  - Bug #2 (NSScreen duplicate define): Fixed by deduplicating `effective_properties` by
    generated Racket getter name rather than ObjC property name. ObjC `CGDirectDisplayID` and
    Swift `cgDirectDisplayID` both map to `nsscreen-cg-direct-display-id`; only the first
    survives. Two unit tests added.
  - Bug #3 (CFStringGetCStringPtr nullable return): Fixed end-to-end. New `TypeRefKind::CString`
    variant added to the IR; `const char *` (only const-qualified) maps to `CString → _string`;
    return contracts emit `(or/c string? #f)`, param contracts emit `string?`. Several tests added.
  - CFSTR macro constants: `macro_value` field added to `ir::Constant`; ObjC extractor now
    tokenises `MacroDefinition` entities and extracts `CFSTR("literal")` patterns; emitter
    generates `_make-cfstr` helper and `(define kFoo (_make-cfstr "..."))` forms. Tests cover
    mixed CFSTR/regular constants, contract, preamble presence/absence.
  - Class-specific return predicates: `collect_return_type_class_names` + `emit_class_predicates`
    added; `TypeRefKind::Class { name }` returns now emit `nsview?`-style contracts backed by
    `objc-instance-of?` instead of `any/c`.
  - `Boolean` typedef mapped to `_bool` (was silently `uint8`, breaking boolean-context usage).
  - Struct typedef `TypeKind::Record` changed from `Alias` to `Struct` in `type_mapping.rs` —
    fixes `is_struct_data_symbol` so CF struct globals (kCFTypeDictionaryKeyCallBacks etc.) use
    `ffi-obj-ref` with `cpointer?` contract.
  - Forward declaration shadowing fix: `StructDecl` and `ObjCProtocolDecl` now gated on
    `is_definition()` so forward decls don't shadow the full definition in `seen_` sets.
  - `is_generic_type_param()` extracted from inline prefix allowlists in both
    `ffi_type_mapping.rs` and `emit_functions.rs`; now uses character-based detection
    (single uppercase + lowercase = generic; 2+ uppercase = framework-prefixed).
  - Foreign-thread safety warnings added to `emit_functions.rs`: functions with callback
    (FunctionPointer/Block) params now emit a `; WARNING:` comment about SIGILL on foreign threads.
  - Runtime load harness expanded: 7 runtime files added to `LIBRARY_LOAD_CHECKS`,
    PDFKit/SceneKit to `REQUIRED_FRAMEWORKS`, drawing-canvas/pdfkit-viewer/scenekit-viewer to
    `APPS`, new `runtime_block_nil_guard` test.
  - Backlog updated: SceneKit Viewer marked done; Generator Bug Fixes batch, spi-helpers free fix,
    self-contained bundling, developer docs filed as new tasks.

- **What didn't work / not attempted:**
  - Bug #4 (integer param widening for AXValueCreate/AXValueGetValue/CFNumberGetValue) was
    not addressed in this session.

- **What this suggests trying next:**
  - Run the full pipeline regeneration to propagate the CString, Struct typedef, CFSTR, and
    class-predicate changes through all 284 frameworks; update snapshot golden files.
  - Fix the spi-helpers.rkt GC-malloc free bug (simple one-line removal).
  - Begin Note Editor or Mini Browser sample app.
