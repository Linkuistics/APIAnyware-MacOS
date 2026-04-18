### Session 20 (2026-04-18T13:24:39Z) — Synthesize default constructor for init-less ObjC classes

- **Attempted:** Implement `NSAlert Synthesized Constructor` task — detect ObjC classes
  whose IR has no explicit init (or only bare `init`) and synthesize a `make-<class>`
  default constructor so callers no longer need the `objc-interop.rkt` escape hatch.

- **What worked:**
  - Audit revealed the problem is system-wide: 54% of 5,304 generated classes have no
    init in IR at all; a further 19% have only bare `init`; together 73% had no usable
    constructor before this fix.
  - Two new helpers in `emit_class.rs`: `has_explicit_constructor` (mirrors the existing
    emit-time skip on `m.selector == "init"`) and `emit_default_constructor` (emits the
    `alloc/init/wrap-objc-object` trio).
  - `build_export_contracts` adds `[make-<class> (c-> any/c)]` under the same condition.
  - Suppression verified: NSWindow retains only its explicit init constructor.
  - 3 new unit tests (no-init, bare-init-only, explicit-init) + updated
    `test_empty_class_provide`; 122 unit tests pass; full workspace `cargo test` green.
  - 11 golden files regenerated (nsobject, nsdata, nsdateformatter, nsfilemanager,
    nslock, nsnotificationcenter in Foundation; nsstatusbar in AppKit; tkbutton,
    tkhelper, tkmanager, tkobject, tkview in TestKit).
  - Runtime load harness green: library checks (21.3s), all 9 sample apps `raco make`
    (87.7s).
  - Note Editor refactored: `make-nsalert` replaces the
    `(tell (tell NSAlert alloc) init) + wrap-objc-object #:retained #t` hack;
    `objc-interop.rkt` import dropped from Note Editor.
  - Core backlog updated: CF struct globals from CoreFoundation absent from IR filed as
    a new `[collection] [low]` gap item.
  - `memory.md` updated: obsolete "NSAlert has no generated alloc+init wrapper" entry
    replaced with authoritative note on the system-wide default constructor synthesis.

- **What didn't work:** Nothing blocked — the implementation landed cleanly in one pass.

- **What to try next:** Triage phase will re-examine remaining backlog. Likely candidates:
  Racket Class System Analysis (now unblocked), Framework Coverage Deepening, or
  Developer Documentation. CF struct globals gap is low-priority collection-side work.

- **Key learnings:**
  - The `make_constructor_name` function already existed in `naming.rs` but was only
    used in tests — the synthesis simply wired it into the production emit path.
  - The 73% coverage gap had been silently forcing every simple-construction call site
    through the `objc-interop.rkt` escape hatch; the fix is a pure emitter improvement
    with no runtime changes.
