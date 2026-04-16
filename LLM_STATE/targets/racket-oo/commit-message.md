Eliminate FFI surface: type-aware delegates, clean contracts, zero-FFI apps

Phase 1 — Type-aware delegates: add `borrow-objc-object` (borrowed-reference
wrapper satisfying objc-object?) and `#:param-types` to `make-delegate`/`delegate-set!`
(auto-coerces callback args from raw _pointer to objects/integers/booleans).
`generate_protocol_file` emits `#:param-types` hash from IR param types; `method_return_kind`
gains int32→'int and int64→'long branches with 11 new unit tests.

Phase 2 — Contract cleanup: SEL params accept strings at the contract boundary
(generated wrappers call `sel_registerName` internally, including property setters).
Object param contracts drop `cpointer?` and unify nullable/non-nullable to
`(or/c string? objc-object? #f)`. Add `->string` helper (polymorphic NSString→Racket).

Phase 3 — App rewrites: all 4 sample apps (hello-window, counter, ui-controls-gallery,
file-lister) rewritten to zero FFI imports. VM-validated via GUIVisionVMDriver.
Two runtime bugs fixed during VM testing: nil rejection at makeKeyAndOrderFront:,
missing sel_registerName on SEL property setters.
