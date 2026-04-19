### Session 22 (2026-04-19T07:18:36Z) — objc-subclass macro landed

- **Attempted:** Implement the `objc-subclass` Macro (Option B) task: a `define-objc-subclass`
  macro layered over `make-dynamic-subclass` that eliminates the manual boilerplate
  (IMP/fptr assembly, GC pinning, superclass encoding lookup) required to create ObjC subclasses.

- **What worked:**
  - `runtime/objc-subclass.rkt` created with full ObjC type-encoding parser (primitives,
    id/SEL/Class, pointers, balanced struct/union/array tokens) and a `known-structs` table
    covering all geometry types from `type-mapping.rkt` (NSPoint/NSSize/NSRect/NSRange/
    NSEdgeInsets/NSDirectionalEdgeInsets/NSAffineTransformStruct/CGAffineTransform/CGVector).
  - Macro handles the `(self SEL)` prefix automatically, wraps user lambdas to drop the
    SEL arg, pins IMPs in a module-level list against GC.
  - Escape hatch via `#:arg-types` / `#:ret-type` for unsupported struct/union/bitfield types.
  - `drawing-canvas.rkt` rewritten: ~70 lines of boilerplate (4× hand-rolled `*-impl` /
    `*-fptr` / encoding-lookup / tuple-list construction) collapsed to one `define-objc-subclass`
    form with zero type annotations, demonstrating the macro on all four NSView overrides.
  - `runtime_load_test.rs` extended: `objc-subclass.rkt` added to RUNTIME_FILES and
    LIBRARY_LOAD_CHECKS; `runtime_objc_subclass_macro` test exercises zero-arg (`hash`),
    one-arg (`isEqual:`), alloc+init, idempotent re-define, IMP-stays-first, and keyword
    override — 6 sub-checks all pass.
  - Full harness green (4/4 runtime load tests, ~85s). Full workspace `cargo test` green.
  - Backlog task status correctly flipped to `done` with full Results block.

- **What didn't work / wasn't attempted:** No pipeline regeneration needed — no emitter,
  collection, or analysis code was changed. Constructor synthesis (`make-<class>`) was
  deliberately declined — inferring inherited init FFI signatures at expansion time would
  drift per superclass.

- **What this suggests next:** Developer Documentation task can now document both idioms
  cleanly: flat `tell`-message-passing for existing ObjC classes, `define-objc-subclass`
  for dynamic subclasses. If Modaliser-Racket's `ui/panel-manager.rkt` (NSPanel subclass)
  gets imported, it would be a natural second consumer of the macro on a non-NSView superclass.

- **Key learnings:**
  - ObjC encoding strings interleave stack-offset digits between type tokens — the parser
    must skip numeric characters explicitly; `{CGRect=...}` struct tokens need balanced-
    delimiter parsing rather than simple character dispatch.
  - Racket's `syntax-parse` `~?` template is the right tool for optional keyword syntax
    in macros — it collapses absent keyword branches to a sentinel without nested `if`.
  - Idempotency under module reload falls naturally out of `make-dynamic-subclass`'s
    existing "return existing class" path; `class_addMethod` after registration is a
    libobjc no-op (not an error), so re-requiring a module is safe.
