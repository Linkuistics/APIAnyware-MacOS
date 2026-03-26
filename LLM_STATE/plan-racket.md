# Racket Language Target

```
Language: Racket
Implementations: Racket (BC or CS)
Binding styles: OO (tell macro, class wrappers), Functional (plain procedures)
Swift dylib: libAPIAnywareRacket.dylib
Milestone: 9
Emitter crate: emit-racket
Runtime location: generation/targets/racket/runtime/
```

Template: `plan-template.md`

## Progress

### 9.1 Emitter crate

- [x] `generation/crates/emit-racket/` — 8 modules ported from POC
  - [x] `naming.rs` — kebab-case constructors, properties, methods with `!` suffix
  - [x] `method_filter.rs` — Tell vs TypedMsgSend dispatch, method support filtering
  - [x] `shared_signatures.rs` — `_msg-N` signature deduplication
  - [x] `emit_class.rs` — complete class file generation (header, constructors, properties, methods, block wrapping)
  - [x] `emit_protocol.rs` — protocol definitions with `make-<protocol>` delegate constructors
  - [x] `emit_enums.rs` — enum definitions
  - [x] `emit_constants.rs` — constant declarations
  - [x] `emit_framework.rs` — framework orchestration, `RACKET_LANGUAGE_INFO`, `EmitResult`
- [x] `RacketFfiTypeMapper` in shared emit crate
- [x] 20 Rust-side unit tests passing
- [x] Added to workspace `Cargo.toml`
- [x] `cargo +nightly fmt` applied

### 9.2 Runtime library

- [x] 7 runtime files ported to `generation/targets/racket/runtime/`
  - [x] `swift-helpers.rkt` — conditional loading of `libAPIAnywareRacket.dylib`
  - [x] `objc-base.rkt` — object wrapping with GC-attached release finalizers
  - [x] `coerce.rkt` — auto-coercion (string→NSString, objc-object→ptr)
  - [x] `block.rkt` — ObjC block creation from Racket lambdas
  - [x] `delegate.rkt` — delegate creation (Swift-backed + pure-Racket fallback)
  - [x] `type-mapping.rkt` — Foundation type conversions, geometry structs
  - [x] `variadic-helpers.rkt` — alternatives for variadic ObjC methods
- [ ] Runtime loads and works in Racket (manual verification pending)

### 9.3 Swift dylib integration

- [x] `libAPIAnywareRacket.dylib` builds successfully (from Milestone 7.2)
- [x] 64 Swift tests pass (7 Common + 3 Racket test files)
- [ ] FFI round-trip test from Racket → Swift helper → verify result
- [ ] Block creation through dylib verified from Racket
- [ ] Delegate creation through dylib verified from Racket

### 9.4 Generation CLI wiring

- [ ] Register Racket emitter in `apianyware-macos-generate`
- [ ] Generate all enriched frameworks
- [ ] Output to `generation/targets/racket/generated/oo/` and `generation/targets/racket/generated/functional/`
- [ ] Both binding styles produce separate output

**Note:** The current emitter produces OO-style output (tell macro + class wrappers). The functional style (plain procedures, no tell macro, explicit objc_msgSend everywhere) needs to be implemented as a second code path.

### 9.5 Snapshot tests

- [ ] Generate Foundation + AppKit golden files (OO style)
- [ ] Generate Foundation + AppKit golden files (Functional style)
- [ ] Regression test integrated into `cargo test`

### 9.6 Language-side smoke tests

- [ ] OO style: import Foundation, create NSObject, call description, verify
- [ ] OO style: NSString round-trip, NSArray count, property get/set, block invoke
- [ ] Functional style: same tests using functional bindings
- [ ] Tests run with `raco test`

### 9.7 Sample apps — OO style

All 7 standard apps using `tell` macro and class wrappers:

- [ ] Hello Window
- [ ] Counter
- [ ] UI Controls Gallery
- [ ] File Lister
- [ ] Text Editor
- [ ] Mini Browser
- [ ] Menu Bar Tool

### 9.8 Sample apps — Functional style

All 7 standard apps using plain procedures and explicit typed message sends:

- [ ] Hello Window
- [ ] Counter
- [ ] UI Controls Gallery
- [ ] File Lister
- [ ] Text Editor
- [ ] Mini Browser
- [ ] Menu Bar Tool

### 9.9 TestAnyware validation

- [ ] All OO sample apps validated via TestAnyware in VM
- [ ] All Functional sample apps validated via TestAnyware in VM
- [ ] Issues discovered and resolved
- [ ] Screenshots archived

### 9.10 Per-framework exercisers

- [ ] CoreGraphics — drawing paths, contexts
- [ ] AVFoundation — audio playback
- [ ] MapKit — map view with annotations

### 9.11 Documentation placeholder

- [ ] `generation/targets/racket/docs/requirements.md`
- [ ] Racket-specific idiom notes (OO: `tell` macro, `import-class`; Functional: explicit `objc_msgSend`, no `tell`)
- [ ] Notes on what Racket users would find surprising

## Racket-Specific Notes

- The OO style uses Racket's built-in `ffi/unsafe/objc` module's `tell` macro for clean message-passing syntax. The functional style bypasses `tell` entirely, using explicit `objc_msgSend` bindings for everything.
- Racket's GC is precise — the runtime must prevent GC of ObjC objects, C callbacks, and block structs via the `active-blocks` hash and `swift-gc-handles` registry.
- The `coerce-arg` function auto-converts Racket strings to NSString for convenience. The functional style should still provide this — it's ergonomic, not paradigmatic.
- Variadic ObjC methods are intentionally skipped. `variadic-helpers.rkt` provides Racket-idiomatic alternatives.

## Learnings

- Racket emitter ports cleanly from POC with three IR type changes: `Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`), Method has `source`/`provenance`/`doc_refs` fields.
- Dylib name changed from `libanyware_racket` to `libAPIAnywareRacket` — only `swift-helpers.rkt` references it.
- Framework header simplified from POC's per-framework match arms to a single format string.
