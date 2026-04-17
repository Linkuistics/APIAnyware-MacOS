### Session 20 (2026-04-17T08:15:01Z) — Drawing Canvas app + generator correctness fixes

- **Attempted:** Land the Drawing Canvas sample app (dynamic NSView subclass, CGContext
  rendering, NSColorPanel integration) and fix a cluster of generator bugs that surfaced
  during development.

- **What worked:**
  - `apps/drawing-canvas/drawing-canvas.rkt` landed with dynamic `DrawingCanvasView`
    subclass (4 overrides: `drawRect:`, `mouseDown:`, `mouseDragged:`, `mouseUp:`).
    Type encodings pulled from NSView's own `method-type-encoding` to avoid ABI drift.
    Per-stroke CGContext rendering with round caps/joins; single-point strokes handled
    by a coincident-point segment so round caps paint a dot with no special-case branch.
    NSColorPanel with continuous target-action and line-width NSSlider also landed.
    VM-validated via GUIVisionVMDriver: window renders, drag produces stroke, color
    picker updates stroke color without crash, Clear empties canvas.
  - Bundle IDs switched project-wide from `com.apianyware.*` to `com.linkuistics.*`
    as directed.
  - Generator: class-method vs instance-property collision detection now correctly
    partitioned by class vs instance level (`PropertyNameSets`), so `+separatorItem`
    (NSMenuItem) is no longer suppressed by the boolean instance property of the same name.
  - Generator: property deduplication now keyed on generated Racket name rather than
    ObjC property name — fixes NSScreen `CGDirectDisplayID`/`cgDirectDisplayID` emitting
    two identical `define` forms.
  - Generator: `CString` TypeRefKind added and wired through `ffi_type_mapping.rs`
    (`_string` FFI type) and contract mapper (`string?` / `(or/c string? #f)` for return).
  - Generator: `is_generic_type_param()` helper extracted and shared between FFI mapper
    and contract mapper, replacing duplicated block-listed prefix checks.
  - Generator: `emit_functions.rs` emits a thread-safety warning comment on any function
    with a callback (`FunctionPointer` / `Block`) parameter.
  - Generator: class-specific return-type predicates (`nsview?`, `nscolor?`, etc.) now
    emitted inline in generated class files, backed by `objc-instance-of?` from
    `objc-base.rkt`. `map_return_contract` now uses these predicates instead of `any/c`
    for `TypeRefKind::Class` returns.
  - Runtime: `objc-instance-of?` added to `objc-base.rkt` (backed by `isKindOfClass:`
    via `objc_getClass` with a class-name cache).
  - Collection: `@protocol Foo;` forward declarations and struct forward declarations now
    skip-guarded with `is_definition()` to prevent forward-decl shadowing of full definitions.
  - Collection: `MacroDefinition` entities now extracted for CFSTR constants; `macro_value`
    field added to IR `Constant` struct; `emit_constants.rs` emits `_make-cfstr` preamble
    and `(_make-cfstr "literal")` calls for macro-valued constants.
  - Runtime load harness expanded: 7 additional runtime files in `RUNTIME_FILES`,
    7 additional paths in `LIBRARY_LOAD_CHECKS`.
  - New runtime load test: `runtime_block_nil_guard` verifies `make-objc-block #f` returns
    `(values #f #f)` and `free-objc-block #f` is a no-op.
  - Extensive unit tests added across `emit_class.rs`, `emit_functions.rs`,
    `emit_constants.rs` covering all the above.

- **What didn't work / key learnings:**
  - `tell` from `ffi/unsafe/objc` only accepts `_id`-tagged cpointers or imported class
    refs — NOT `objc-object?` struct wrappers. Raw cpointers from ObjC trampolines must
    pass through `coerce-arg` before hitting `tell`; `borrow-objc-object` alone is not
    enough.
  - Delegate handlers that send messages back to their `sender` argument MUST declare
    `#:param-types (hash "selector" '(object))` or the arg arrives as a raw cpointer and
    every generated wrapper call trips its `objc-object?` self contract.
  - NSColor component accessors raise NSException on non-RGB colors; must convert via
    `nscolor-color-using-color-space` with `nscolorspace-device-rgb-color-space` first.
  - Generator bug discovered: `nsevent.rkt` can't be required because `NSEvent
    +modifierFlags` and `-modifierFlags` emit as the same Racket identifier. Filed in
    core backlog. Workaround: raw `tell` for `locationInWindow`.

- **What to try next:**
  - Fix class-method / instance-method selector collision (`nsevent.rkt` / `nsevent-modifier-flags`).
  - Fix `bool`/`BOOL` return types emitting `_uint8` instead of `_bool` (silent truthy bug).
  - Fix `make-objc-block` to treat `#f` as no-op lambda.
  - Fix `wkwebview.rkt` referencing unbound `_NSEdgeInsets`.
  - Proceed to SceneKit Viewer sample app.
