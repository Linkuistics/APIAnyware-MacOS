### Session 20 (2026-04-18T07:08:15Z) — triage: verify and close backlog items relocated from core

- Worked through five backlog tasks relocated from core to racket-oo during the prior triage session. All five turned out to be already resolved or never broken; the triage session's job was verification and closure.
- **Generator Bug Fixes (Batch):** Confirmed all four sub-bugs (separatorItem, nsscreen duplicate define, CFStringGetCStringPtr contract, integer param widening) resolved in commit `1d03ede` (2026-04-18 00:44). No source edits required.
- **Fix unbound `_NSEdgeInsets`:** Confirmed `NSEdgeInsets` in `is_known_geometry_struct` and exported from `runtime/type-mapping.rkt`; `wkwebview.rkt` loads cleanly. No source edits required.
- **Fix BOOL return type → `_bool`:** Fix already in `extract-objc/src/type_mapping.rs:257-261` mapping `BOOL`/`Boolean` → `Primitive { name: "bool" }`. Added regression test `foundation_bool_return_resolves_to_primitive_bool` in `collection/crates/extract-objc/tests/extract_foundation.rs` to guard against regression.
- **`make-objc-block` nil guard:** Guard already implemented at `runtime/block.rkt:67-70`. Hardened `runtime_block_nil_guard` test in `generation/crates/emit-racket-oo/tests/runtime_load_test.rs` from 3 to 5 checks: added explicit `#f` block-ptr assertion and a positive-path lambda test.
- **`spi-helpers.rkt` GC-malloc free:** File was authored correctly from the start with guidance comment; no `free` call present. Backlog entry was stale.
- Key learning: triage sessions that relocate tasks from core to racket-oo should grep the source before writing the backlog entry — several of these were already fixed in the same commit wave (1d03ede) that prompted the relocation.
- Next: Mini Browser app (WKWebView workaround pattern confirmed viable) or Note Editor (completion block territory).
