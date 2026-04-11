# Memory

### Typedef resolution happens at extraction time
ObjC typedef aliases (e.g., NSImageName) must resolve to canonical types during
collection, not downstream. Object pointer typedefs → Id/Class, primitive typedefs →
Primitive, enum/struct typedefs → keep as Alias. Failing to resolve early causes
incorrect FFI signatures in all language targets.

### Function pointer typedefs need pointee inspection
`map_typedef` must not stop at `TypeKind::Pointer` — it must check whether the pointee
is a `FunctionPrototype` and extract full param/return signatures. Without this,
callback typedefs like `CGEventTapCallBack` resolve to plain `Pointer`, losing the
signature information needed for correct FFI bindings.

### Category properties need dedup by name
ObjC categories can redeclare properties already on the base class. Deduplication by
name (HashSet filter in `extract_declarations.rs`) prevents duplicate entries in the IR.

### Enrichment must filter by framework
Both `build_enrichment_data()` and `build_verification_report()` must receive and filter
by `framework_classes`. Without filtering, violations from all frameworks bleed into
every framework's report when enriched together.

### DriverKit and Tk frameworks should be ignored
DriverKit requires kernel headers not available in user-space SDKs. Tk is a legacy
X11 toolkit. Both are excluded via `IGNORED_FRAMEWORKS` in `sdk.rs`, filtered in
`discover_frameworks()`.
