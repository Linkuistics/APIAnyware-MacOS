# Session Log

### Session 1 (2026-04-11) — C function pointer typedef extraction
- Discovery: C function, enum, and constant extraction were already fully implemented
  (FunctionDecl, VarDecl, EnumDecl handlers all present and wired through to JSON)
- Problem: function pointer typedefs (CGEventTapCallBack) resolved to plain `Pointer`
  because `map_typedef` saw `TypeKind::Pointer` canonical type and stopped there,
  never checking if the pointee was a `FunctionPrototype`
- Fix: added `FunctionPointer` variant to `TypeRefKind` (type_ref.rs), updated
  `map_typedef` and `map_type_kind` to detect `FunctionPrototype` pointees and extract
  full param/return signatures via new `map_function_pointer_type` helper
- Updated exhaustive matches in `ffi_type_mapping.rs` and `emit_protocol.rs`
- 7 new tests: 4 serde roundtrip (types crate), 3 integration (CoreGraphics extraction)
- Verified: CG 15 callbacks, CF 28, Security 7. Plan updated: all 3 collection tasks done

### Session 2 (2026-04-11) — Enrichment verification fix
- Bug: `build_verification_report()` didn't filter violations by framework — every
  framework got all violations from all frameworks when enriched together
- Root cause: `build_enrichment_data()` already computed `framework_classes` and filtered
  correctly, but `build_verification_report()` was never given the class set
- Fix: lifted `framework_classes` computation to `build_enriched_framework()`, passed to
  both `build_enrichment_data()` and `build_verification_report()`
- 2 new tests: violation isolation and enrichment data isolation across frameworks

### Session 3 (2026-04-11) — Framework ignore list
- Added `IGNORED_FRAMEWORKS` constant in `sdk.rs` with DriverKit and Tk
- `is_framework_ignored()` public helper for callers that need to check
- Filtering built into `discover_frameworks()` — all consumers benefit automatically
- 3 integration tests: exclusion from results, list non-empty guard, helper consistency

### Pre-history (migrated from old plan.md)
- Milestones 1-8 complete: shared types, ObjC/C collection, Swift extraction,
  analysis pipeline (resolve/annotate/enrich), shared emitter framework, test
  infrastructure
- ObjC extractor's `type_mapping.rs` resolves typedefs to canonical types at
  extraction time — critical for correct FFI signatures downstream
- Category property deduplication by name required (HashSet filter in
  `extract_declarations.rs`)
- Typedef aliases (e.g., NSImageName) must resolve to canonical types at collection
  time: ObjC object pointer typedefs -> Id/Class, primitive typedefs -> Primitive,
  enum/struct typedefs -> keep as Alias
