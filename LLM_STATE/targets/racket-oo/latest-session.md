### Session 19 (2026-04-16T06:54:55Z) — FFI Surface Elimination complete (all 3 phases)

- **Attempted:** Implement all three phases of FFI Surface Elimination — type-aware
  delegates (Phase 1), contract cleanup (Phase 2), sample app rewrites (Phase 3).
  All three phases landed in a single session.

- **What worked:**

  Phase 1 — Type-aware delegates:
  - `borrow-objc-object` added to `objc-base.rkt`: lightweight borrowed-reference
    wrapper (no retain/finalizer) that satisfies `objc-object?`. Used for delegate
    callback args that are valid only for the call duration.
  - `#:param-types` keyword added to `make-delegate` in `delegate.rkt`: hash mapping
    selectors to lists of type symbols (`'object`, `'long`, `'int`, `'bool`,
    `'pointer`). The trampoline auto-coerces each callback arg before the handler
    runs. `delegate-set!` also looks up stored param-types and wraps new handlers.
  - `make-delegate` now returns `borrow-objc-object` so delegates satisfy
    `objc-object?` contracts when passed to wrappers like `nsbutton-set-target!`.
  - `objc-autorelease` added to `objc-base.rkt` — converts a +1 pointer to +0
    autoreleased; used by the file-lister delegate to return NSString values safely.
  - `method_return_kind` in `emit_protocol.rs` extended: int32→`'int`, int64→`'long`.
    `generate_protocol_file` emits `#:param-types` hash built from IR param types
    via new `param_type_symbol` function. Protocol factory comments now include
    `int-returning` and `long-returning` groups.

  Phase 2 — Contract cleanup:
  - SEL-typed params in `emit_class.rs` now accept `string?` at the contract boundary.
    `coerce_sel_params` wraps them with `sel_registerName` in the generated wrapper
    body. SEL-typed property setters also wrapped.
  - `cpointer?` dropped from `map_param_contract` — object params narrowed to
    `(or/c string? objc-object? #f)`. Nullable vs. non-nullable distinction removed:
    all object params now include `#f` since ObjC nil messaging is always a no-op.
  - `->string` helper in `type-mapping.rkt`: polymorphic NSString→Racket string
    conversion accepting `objc-object`, `cpointer`, `string?`, or `#f`.
    Provided through the `coerce.rkt` re-export chain.

  Phase 3 — App rewrites:
  - All 4 sample apps rewritten to zero FFI imports (`hello-window`, `counter`,
    `ui-controls-gallery`, `file-lister`).
  - `file-lister.rkt`: `ns->str` helper deleted (replaced by `->string`),
    `col->id-str`/`col-index` rewritten to use wrapped `col` arg directly via
    `nstablecolumn-identifier`, `cast` and manual `sel_registerName` calls removed.
  - VM validation (GUIVisionVMDriver): all 4 apps launched and visually verified.

  Runtime bugs caught during VM testing and fixed:
  - Object param contracts always include `#f` — many APIs accept nil without
    `_Nullable` annotation; previous contract rejected `#f` at `makeKeyAndOrderFront:`.
  - SEL-typed property setters missed `sel_registerName` wrapping (methods had it,
    properties didn't) — caused `setAction:` crash.

  Test count: 11 new unit tests in `emit_protocol.rs`, 8+ new tests in
  `emit_class.rs`. All 107 emitter tests pass; 3 snapshot suites pass; runtime
  load harness pass.

- **What didn't work:** No significant failures. The VM test loop caught two runtime
  bugs in Phase 3 that weren't covered by the snapshot/unit tests, validating the
  importance of VM validation as the final gate.

- **What to try next:** Bug Fixes and Cleanup backlog (NSScreen duplicate symbol,
  `+separatorItem` class-method classification, inherited NSView methods on
  WKWebView). Then Sample Apps (Menu Bar Tool → Text Editor → Mini Browser).

- **Key learnings:**
  - The SEL-property setter gap (missing `sel_registerName` wrapping) was invisible
    to snapshot tests because the golden files didn't include a property with a SEL
    setter — the VM test was the first real exerciser.
  - Returning `borrow-objc-object` from `make-delegate` (rather than the raw pointer)
    was necessary to satisfy `objc-object?` at `nsbutton-set-target!` — the delegate
    itself crosses a contract boundary before the callback fires.
  - The `->string` helper is a quality-of-life multiplier: every app that talks to
    NSString-returning APIs benefits from not having to unwrap manually.
