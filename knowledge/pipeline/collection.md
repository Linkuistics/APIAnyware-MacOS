# Collection Pipeline Learnings

**2026-03-31:**
- 🔴 Typedef aliases (e.g., `NSImageName`) must be resolved to canonical types at collection time in `type_mapping.rs`. ObjC object pointer typedefs → `Id`/`Class`, primitive typedefs → `Primitive`, enum/struct typedefs → keep as `Alias`. Without this, the FFI mapper defaults to `_uint64` for unrecognized aliases, which crashes at runtime for object-type parameters.
- 🟡 Category property merging must deduplicate by name — `class.properties.extend(category_props)` creates duplicates when a property exists on both the class interface and a category. Fixed with HashSet filter in `extract_declarations.rs`.
