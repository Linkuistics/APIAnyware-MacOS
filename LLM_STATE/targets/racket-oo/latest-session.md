### Session 18 (2026-04-16T05:01:02Z) — Research: FFI surface elimination + triage from Modaliser-Racket usage

- **What was attempted:** The original research task ("Transparent Object Wrapping for Delegate Callback Args") was expanded in scope to a comprehensive audit of every FFI concept leaking into app code. The session was entirely research and backlog maintenance — no Rust or Racket source files were modified.

- **What worked:**
  - Full FFI leakage catalog produced across all 4 sample apps (counter, file-lister, ui-controls-gallery, hello-window): 10 distinct categories identified (delegate args as raw cpointers, int/long pointer-encoded args, `ffi/unsafe` requires, `sel_registerName` for actions, `cpointer?` in contracts, `nsstring->string`/`string->nsstring`, `objc-object-ptr` unwrapping, `tell` with raw cast, `tell ... autorelease`, `objc-null?`/`objc-object?` checks).
  - Root causes narrowed to 3 systemic issues: (A) `delegate.rkt` trampolines are type-unaware, (B) `emit_protocol.rs:method_return_kind` discards param types and misclassifies int/long returns as void, (C) generated wrappers expose FFI vocabulary in contracts (SEL params as `cpointer?`).
  - 3-phase solution architecture designed: Phase 1 = `borrow-objc-object` + `#:param-types` on `make-delegate` + fix `method_return_kind` + emit param-type metadata; Phase 2 = selector params accept strings, drop `cpointer?`, add `->string`; Phase 3 = rewrite apps, verify in harness + VM.
  - "Selector parameter contracts" stretch task closed as subsumed by Phase 2a (stronger outcome: string args with internal `sel_registerName`, not just a `sel?` alias).
  - Latent runtime bug confirmed in `ui-controls-gallery.rkt`: slider/stepper callbacks pass raw `sender` cpointer to wrappers that have `objc-object?` contracts — will crash on any code path that executes those callbacks.
  - Three new "Bug Fixes and Cleanup" tasks captured from Modaliser-Racket real-world usage: `nsscreen.rkt` duplicate symbol (load error), `nsmenuitem.rkt` `+separatorItem` misclassified as instance property (not class method), `wkwebview.rkt` missing inherited `setAutoresizingMask:`.
  - Two new core backlog tasks: `make-objc-block` does not handle `#f` input (apply crash), and `is_definition()` guard audit for StructDecl/ObjCInterfaceDecl/ObjCProtocolDecl arms.

- **What didn't work:** Nothing attempted in code — session was research-only by design. The `borrow-objc-object` + `#:param-types` approach was chosen over contract relaxation and struct elimination on the basis of type safety and overhead trade-offs; implementation deferred to the FFI Surface Elimination task.

- **What this suggests trying next:** Begin FFI Surface Elimination Phase 1 in the next session: add `borrow-objc-object` to `objc-base.rkt`, then `#:param-types` to `make-delegate`, then fix `method_return_kind` in `emit_protocol.rs`, then emit param-type metadata from protocol IR. Phase 1 delivers the highest impact (invisible delegate arg handling) and unblocks the `ui-controls-gallery.rkt` latent bug fix.

- **Key learnings:**
  - The delegate trampoline type-unawareness is the single biggest FFI leakage source — every callback touching a wrapper requires manual `wrap-objc-object`+`cast` or `cast _pointer _int64`. Fixing this in `delegate.rkt` eliminates the most common friction point in one place.
  - `emit_protocol.rs:method_return_kind` has a silent correctness gap: int/long returns fall through to "void", so generated protocol factories misclassify NSInteger-returning methods. This went unnoticed because `raco make` compiles without executing callbacks.
  - Real-world Modaliser-Racket usage surfaced three emitter bugs not caught by the snapshot test suite: `nsscreen.rkt` duplicate symbol, `nsmenuitem.rkt` class-vs-instance method classification, and `wkwebview.rkt` missing inherited method — all three are load-time or API-surface failures invisible to golden-file diffs.
