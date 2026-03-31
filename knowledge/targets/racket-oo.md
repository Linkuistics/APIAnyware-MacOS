# racket-oo — Target Learnings

## Runtime
- Racket's GC is precise — the runtime must prevent GC of ObjC objects, C callbacks, and block structs via the `active-blocks` hash and `swift-gc-handles` registry
- `coerce-arg` auto-converts Racket strings to NSString for convenience
- TypedMsgSend methods (`_msg-N` bindings) expect raw pointers for id-type parameters, not wrapped `objc-object` structs
- `with-autorelease-pool` uses `begin0` internally, so `define` forms inside it are invalid — use `let`/`let*`
- Racket module compilation is very slow on first run (~5+ minutes for apps importing many generated modules); cached in `compiled/` after

## Emitter
- Emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef`, `EnumValue.value` is `i64`, Method has `source`/`provenance`/`doc_refs`
- Swift-style selectors (containing `(`) must be filtered from emission
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell` macro compatibility
- Category property merging must deduplicate by name; emitter must also deduplicate effective_methods by selector
- Runtime paths: `../../../runtime/` for class files, `../../../../runtime/` for protocol files (generated/{style}/ adds a level)

## Dated Discoveries

**2026-03-31:**
- 🔴 delegate bridge requires prevent-gc! on target object or it gets collected mid-session
- 🔴 typedef aliases must be resolved to canonical types at collection time or FFI mapper defaults to _uint64
- 🔴 NSEdgeInsets not in geometry struct alias list — omit from apps until fixed
- 🟡 Dylib name is `libAPIAnywareRacket`, only `swift-helpers.rkt` references it
- 🟡 NSStepper requires `setContinuous: YES` to fire target-action
- 🟡 NSStepper inside plain NSView in NSStackView may not receive clicks — add directly as arranged subview
- 🟡 Radio button mutual exclusion requires manual target-action delegate
