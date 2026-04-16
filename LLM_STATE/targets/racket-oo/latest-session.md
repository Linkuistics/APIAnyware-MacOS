### Session 20 (2026-04-16T09:47:42Z) — CFSTR emission, emitter collision fixes, CF bridge runtime

- **Attempted:** Pipeline re-run to propagate type mapping fixes; CFSTR macro constant emission; non-linkable symbol leak class triage (A & B); CF bridge runtime helpers; emitter collision bug fixes.

- **What worked:**
  - **Pipeline re-run** completed successfully — all 162 workspace tests pass, runtime load harness passes (16 `dynamic-require` checks + 4 sample app `raco make` compilations, ~48s). Spot-checked all 4 type mapping fixes in generated output: `Boolean`→`_bool`, `const char *`→`_string`, CF struct globals→`ffi-obj-ref`, `AXValueType`-style aliases→`_uint32`.
  - **CFSTR macro constant emission** landed end-to-end: `macro_value: Option<String>` added to `Constant` in `ir.rs`; `MacroDefinition` cursor handler in `extract_declarations.rs` tokenises source ranges and matches `CFSTR("literal")` patterns; `emit_constants.rs` emits `_make-cfstr` preamble (loads `CFStringCreateWithCString` from CoreFoundation at module level) and `(define kFoo (_make-cfstr "literal"))` per constant; contract `(or/c cpointer? #f)`. Golden file updated with TestKit CFSTR constant. Five new unit tests.
  - **Non-linkable symbol leak class A** (bare `c:@<name>` macros) — verified already filtered by `is_unavailable_on_macos()` in ObjC extractor; AudioToolbox in `LIBRARY_LOAD_CHECKS`; no code changes required.
  - **Non-linkable symbol leak class B** (anonymous enum `c:@Ea@` members) — verified `c:@Ea@`/`c:@EA@` filter already present in `declaration_mapping.rs`; Network framework passes runtime load test; no code changes required.
  - **`cf-bridge.rkt`** (214 lines) landed: `racket-string->cfstring`/`cfstring->racket-string`, `cfnumber->integer`/`cfnumber->real`, `cfboolean->boolean`, `cfarray->list`, `make-cfdictionary`, `with-cf-value` auto-release. Added to `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`; loads cleanly.
  - **`nsview-helpers.rkt`** (30 lines) added and wired into runtime load harness.
  - **Emitter collision fixes** in `emit_class.rs`:
    - Property deduplication changed from ObjC name → generated Racket getter name, fixing NSScreen `CGDirectDisplayID`/`cgDirectDisplayID` duplicate `define` crash.
    - Collision detection partitioned into separate `class_property_names` / `instance_property_names` sets, fixing NSMenuItem `+separatorItem` (class factory method) being incorrectly suppressed by the instance property `separatorItem` (bool getter). New pre-pass removes instance properties whose Racket name collides with a class method, letting the class method win.
    - Added four unit tests covering both collision scenarios.

- **What didn't work / remains pending:**
  - AX high-level API helpers (`ax-helpers.rkt`) — not started this session.
  - CGEvent tap helper — not started.
  - GCD dispatch already satisfied by existing `main-thread.rkt`.
  - Private SPI (`_AXUIElementGetWindow`) — not started.
  - Modaliser integration (replacing local `get-ffi-obj` defs with `only-in` imports) — not verified; downstream consumer concern.

- **What to try next:**
  - Implement `ax-helpers.rkt` (typed attribute access, `ax-set-position!`, `ax-set-size!`, `ax-get-pid`) to complete the CoreFoundation/AX runtime helpers task.
  - Consider `is_definition()` guard audit for `StructDecl`/`ObjCInterfaceDecl`/`ObjCProtocolDecl` — low-risk, high-confidence fix.
  - Begin next sample app (menu-bar status item or text editor).

- **Key learnings:**
  - The ObjC and Swift extractors can emit the same property with different capitalisation (e.g. `CGDirectDisplayID` vs `cgDirectDisplayID`); dedup must happen after Racket name normalisation, not on the raw ObjC name.
  - Class-level and instance-level names occupy different namespaces in ObjC but the emitter was sharing a single collision set — the partition fix is architecturally correct and prevents future false suppressions.
  - CFSTR constants are completely unlinked from the dylib; the `_make-cfstr` helper approach (evaluate at module load) mirrors what Modaliser does manually and is safe for ARC-unmanaged `CFStringRef` lifetime (pinned for the module lifetime).
