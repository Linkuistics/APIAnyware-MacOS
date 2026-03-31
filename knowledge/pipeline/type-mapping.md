# Type Mapping Pipeline Learnings

**2026-03-31:**
- 🔴 `NSEdgeInsets` is not in the geometry struct alias list in `ffi_type_mapping.rs`, so setters using it get a `_uint64` typed msg-send. Needs to be added to the geometry struct alias list.
- 🟡 Geometry struct aliases recognised: NSRect, CGRect, NSPoint, CGSize, NSRange, NSAffineTransformStruct.
