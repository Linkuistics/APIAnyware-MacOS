# Session Log

## Pre-history (migrated from milestone 9 learnings)
- Racket emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields
- Dylib name: `libAPIAnywareRacket` (not `libanyware_racket`); only `swift-helpers.rkt` references it
- Generated runtime paths: `../../../runtime/` for class files, `../../../../runtime/` for protocol files
- Swift-style selectors (containing `(`) must be filtered — `init(string:)` can't be called via objc_msgSend
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases must be resolved to canonical types at collection time
- `NSEdgeInsets` not in geometry struct alias list — omit from apps until fixed
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
- Always `pkill -9 -f racket` before relaunching apps
