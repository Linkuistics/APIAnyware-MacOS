# Memory

### Racket OO IR requirements
`Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`),
`Method` has `source`/`provenance`/`doc_refs` fields. These differ from the base IR schema.

### Dylib and runtime path conventions
Dylib name: `libAPIAnywareRacket` (referenced only in `swift-helpers.rkt`). Relative
runtime/generated paths depend on file depth under the target root:
- Class files (`generated/oo/<fw>/<class>.rkt`) → `../../../runtime/`
- Protocol files (`generated/oo/<fw>/protocols/<proto>.rkt`) → `../../../../runtime/`
- Apps (`apps/<name>/<name>.rkt`) → `../../runtime/` and `../../generated/oo/`
After any layout refactor, all three categories must be re-validated. Apps carry stale
prefixes indefinitely because the emitter never touches them.

### Selector filtering
Swift-style selectors containing `(` must be filtered out — e.g. `init(string:)` can't
be called via `objc_msgSend`. The extractor or emitter must exclude these.

### FFI type coercion rules
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs

### Collection-time type resolution
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases must resolve to canonical types at collection time — object pointer typedefs → `Id`/`Class`, primitive typedefs → `Primitive`

### Non-linkable-symbol filters in extractors
Non-linkable symbols (preprocessor macros, internal-linkage decls, Swift-native identifiers) leak into the IR as `get-ffi-obj` calls that fail at `dlsym` time. All filters route through `non_c_linkable_skip_reason` in the collection crates.

**Closed filters** (validated by the runtime load harness):

1. **extract-objc internal-linkage filter** — skips C decls with internal linkage (e.g. `NSHashTableCopyIn`).
2. **extract-swift `s:` USR filter** — skips Swift-native identifiers whose USR begins with `s:` (e.g. `NSLocalizedString`, `NSNotFound`).
3. **extract-swift `c:@macro@` USR filter** — skips C-preprocessor macros via the Swift digester (e.g. `kCTVersionNumber10_10`).
4. **Stale-checkpoint ghost symbols** — symbols in `swift.skipped_symbols` (e.g. `NEFilterFlowBytesMax`, `CoreSpotlightAPIVersion`) reappearing in downstream IR. Root cause: stale downstream checkpoints, not a code bug. Pipeline regeneration removes them.

**Open leak classes:**

A. **Bare `c:@<name>` preprocessor macros.** libclang sometimes exposes a macro through a naked `c:@<name>` USR without `@macro@` — neither extractor catches this. Canary: `kAudioServicesDetailIntendedSpatialExperience` (AudioToolbox, `AudioServices.h:401`, ObjC source).
B. **`c:@Ea@...` anonymous enum members as constants.** Clang's `Ea` USR prefix marks anonymous-enum members; these are extracted as constants. Canary: `nw_browse_result_change_identical` (Network, Swift source).

Adding a new filter: (a) add a skip-reason branch in `non_c_linkable_skip_reason`; (b) add a canary framework to harness coverage. Coverage extension is itself a discovery mechanism — all open classes above were surfaced by coverage tasks, not bug reports.

### Framework dylib and `get-ffi-obj` pattern
`constants.rkt` and `functions.rkt` load the framework dylib as `_fw-lib` (excluded from `provide`) and use `get-ffi-obj`:
- Constants: `(define Name (get-ffi-obj 'Name _fw-lib _type))`
- Functions: `(define Name (get-ffi-obj 'Name _fw-lib (_fun arg-types... -> ret-type)))`
Geometry struct constants (`NSZeroPoint`/`NSZeroRect`) map correctly via alias handling in `RacketFfiTypeMapper`.

### Require block shape for functions/constants
Both files always require `ffi/unsafe`, `ffi/unsafe/objc`, and `racket/contract` (renamed to dodge the `->` conflict), regardless of whether any binding uses `_id`. Unconditional is cheaper than per-binding Id-detection drift. `type-mapping.rkt` is the only conditional require — emitted only when `any_struct_type` (in `shared_signatures.rs`) returns true — because it pulls in geometry cstructs. Forgetting `ffi/unsafe/objc` is invisible until a file with an `_id`-typed binding is loaded.

### Framework subsets differ for functions vs classes
The set of frameworks with emittable C functions (non-variadic, non-inline) is a strict subset of the class emission set, which covers all frameworks. WebKit has classes but no C functions — a common source of confusion when cross-referencing log lines.

### `->` name conflict: `ffi/unsafe` vs `racket/contract`
Requiring both `ffi/unsafe` and `racket/contract` causes a hard `->` identifier conflict. The mandatory form:

    (require ffi/unsafe
             (rename-in racket/contract [-> c->]))

Contract arrows become `(c-> arg-contract ... ret-contract)`. Applies to `functions.rkt`, `constants.rkt`, every class wrapper, and any file needing `racket/contract`. Protocol files use `->*` and dodge the conflict, but `rename-in` is safe prophylactically.

### `type-mapping.rkt` must `provide` every cstruct
Every `define-cstruct` in `runtime/type-mapping.rkt` must appear in its `(provide ...)` list. Current exports: `_NSPoint`, `_NSSize`, `_NSRect`, `_NSRange`, `_CGPoint`, `_CGSize`, `_CGRect`, `_NSEdgeInsets`, `_NSDirectionalEdgeInsets`, `_NSAffineTransformStruct`, `_CGAffineTransform`, `_CGVector`. Adding a geometry struct: (1) `define-cstruct`, (2) add to provide, (3) add to `is_known_geometry_struct` in `emit/src/ffi_type_mapping.rs`. Struct detection goes through `any_struct_type(type_refs, mapper)` in `shared_signatures.rs`, used by class wrappers, `emit_functions.rs`, and `emit_constants.rs` — a one-allowlist-edit operation.

### Snapshot tests insufficient; runtime load required
Text-level snapshot tests are necessary but insufficient. Load-time failures cascade — fixing one missing require reveals the next, and `unbound identifier` masks several orthogonal bugs. Three verification layers are required; none alone suffices:
- **Snapshot tests** — verify text shape
- **Runtime load harness** — verify files load and link (see "Runtime load verification harness")
- **Static cross-reference** — verify FFI binding types agree with IR (see "Match `tell` `#:type` to IR return type")

Calling-convention mismatches (e.g. void method bound as `-> _id`) are silently benign on M1 arm64 — return register garbage is read then discarded. Neither snapshots nor the harness detect this; only static audits cross-referencing FFI dispatch types against IR `return_type` catch it.

### App verification uses `raco make`
For library files, `dynamic-require` is the right check. For apps under `apps/<name>/<name>.rkt`, `dynamic-require` opens a window and blocks (apps call `nsapplication-run`). Use `raco make` instead — it compiles the module and full require graph without instantiating the body. GUI-level verification belongs to the TestAnyware VM workflow.

### Gitignored `generated/` hides stale state
`generation/targets/racket-oo/generated/` and `analysis/ir/enriched/` are gitignored. Source fixes don't propagate to disk until the pipeline is re-run. When verifying emitter changes, regenerate before testing. When triaging a "bug" in generated output, check whether the source already has a fix that hasn't been regenerated.

### Runtime load verification harness
Lives at `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`. Two tests:
- `runtime_load_libraries_via_dynamic_require` — 7 library checks via single racket script collecting all failures
- `runtime_load_apps_via_raco_make` — `raco make` over all sample apps

Gated on `RUNTIME_LOAD_TEST=1`, auto-skips if `racket`/`raco` missing or enriched IR absent. ~40s on M1. Builds a hermetic tempdir matching the canonical target tree so it doesn't race the `compiled/` cache. Library coverage picks one example per dimension: class wrapper, protocol file, Foundation `constants.rkt`+`functions.rkt`, CoreGraphics `functions.rkt` (geometry structs), CoreText `constants.rkt` (`c:@macro@` canary), AppKit `nsmenuitem.rkt` (class-property canary — see "Class-property methods omit `self`").

**Standing rule**: new FFI surface gets a runtime load check alongside its snapshot assertion. Coverage extension to a new framework is a test, not insurance — extensions have uncovered orthogonal leak classes (see "Non-linkable-symbol filters in extractors").

### `dynamic-require` needs `(file ,path)`
The harness uses `(dynamic-require \`(file ,p) #f)`, not `(dynamic-require p #f)`. A raw path string trips a `module-path?` contract violation. The `(file ...)` quasi-form wraps absolute filesystem paths.

### `raco` has no `--version` flag
`raco --version` exits non-zero. The reliable probe is `raco help`. The harness uses `binary_on_path("racket", "--version")` and `binary_on_path("raco", "help")`.

### Contract-based API boundaries
Every FFI boundary uses `provide/contract`. Three contract mappers in `emit_functions.rs` (reused by functions, constants, and class wrappers):
- `map_contract` (value/function): primitives → `real?`/`exact-integer?`/`exact-nonnegative-integer?`/`boolean?`, objects → `cpointer?` or `(or/c cpointer? #f)` for nullable, geometry structs → `any/c`, void → `void?`. Note: `exact-nonneg-integer?` is not a Racket predicate — fails only at load time.
- `map_param_contract` (class wrapper params): `any/c` for objects, `(or/c procedure? #f)` for blocks, delegates to `map_contract` for primitives
- `map_return_contract` (class wrapper returns): `any/c` for objects, delegates to `map_contract` for void/primitives
Protocol files use fixed contracts (see "Protocol file contract shape is fixed").

### Class wrapper self uses `objc-object?`, objects use `any/c`
Self uses `SELF_CONTRACT` (`"objc-object?"`) in `emit_class.rs` — routed through instance methods and instance property getters/setters. Object params/returns remain `any/c`.
- **Self is always a wrapped instance** — rejecting non-`objc-object` values catches misuse (string, number, `#f`, stale cpointer) with caller blame instead of segfaulting in `objc_msgSend`.
- **Object params/returns stay `any/c`** — `coerce-arg` accepts strings, `objc-object` structs, and raw pointers; strict `cpointer?` would break auto-coercion.
`objc-object?` is in scope via the require chain: `coerce.rkt` re-exports from `runtime/objc-base.rkt`. Class-property methods omit `self` (see "Class-property methods omit `self`"). Tightening object params (nullable) and class-specific predicates are queued follow-ups.

### Class-property methods omit `self`
Class-property getters/setters have no `self` parameter. `build_export_contracts` drops `self` for `prop.class_property`. `emit_property`'s setter branches substitute `class_name` for `(coerce-arg self)` as the target. TestKit has no class-method properties, so arity divergence is only caught by the real-framework canary (`nsmenuitem.rkt` in `LIBRARY_LOAD_CHECKS`).

### Match `tell` `#:type` to IR return type
`tell` defaults to `#:type _id`, so a bare `tell` against a void method reads return register garbage as a tagged pointer. `(void (tell ...))` only satisfies the Racket-side contract — it doesn't fix the underlying type mismatch. Correct void emission:

    (tell #:type _void target args)

Same applies to property setters with `Id`-shaped value types (still `_void`-returning). TypedMsgSend dispatch already handles this via `mapper.map_type`. The two emit sites needing explicit `#:type` are the `_id`-typed property setter (`emit_property`) and the Tell-dispatch void-method body (`emit_method`, `ret_is_void` branch). Test pattern: assert `tell #:type _void` present AND `(void (tell` absent.

### Contract export plumbing in class wrappers
`build_export_contracts` in `emit_class.rs` pre-computes `(name, contract)` pairs for constructors, properties, instance methods, and class methods, then emits a single `provide/contract` form. New exported bindings must be added to `build_export_contracts` — otherwise they won't be provided.

### Protocol file contract shape is fixed
Protocol files export exactly two bindings:
- `make-<proto>` — `(->* () () #:rest (listof (or/c string? procedure?)) any/c)`
- `<proto>-selectors` — `(listof string?)`
No per-method contracts exist — delegate handlers are user-supplied lambdas, not emitted bindings. The contract mappers from `emit_functions.rs` don't apply. Constants `MAKE_DELEGATE_CONTRACT` and `SELECTOR_LIST_CONTRACT` in `emit_protocol.rs` hold the strings.

### `provide/contract` rest-arg limitation
`provide/contract` cannot express positional alternation inside `#:rest` — `(listof (or/c string? procedure?))` catches type errors but cannot enforce the string/procedure pairing `make-<proto>` requires. Stronger enforcement needs a dependent contract combinator.

### Function emission filtering
Variadic and inline functions are skipped — they can't be bound via `get-ffi-obj`. TestKit includes both types to verify exclusion.

### VM and testing workflow
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Always `pkill -9 -f racket` before relaunching apps
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`

### Snapshot testing infrastructure
`load_enriched_framework(name)` in `snapshot_test.rs` generalizes framework loading — adding a new framework is a file list and test function. AppKit suite has 23 curated golden files covering key class hierarchies (NSResponder→NSView→NSControl→NSButton, NSWindow, table view, menus, text, layout). Rich classes like NSButton and NSWindow exercise more typed message send variants and geometry struct handling than Foundation classes.

### Block nil handling convention
`make-objc-block` returns `(values #f #f)` when `proc` is `#f` (NULL block pointer + no block-id), rather than wrapping `#f` in a crashing lambda. `free-objc-block` handles `#f` gracefully.

### Racket green threads dead under `nsapplication-run`
All Racket green-thread primitives (`thread`, `sleep`, `sync`, `sync/timeout`, `thread-wait`, `semaphore-wait`) are non-functional once `nsapplication-run` is called. The Cocoa run loop blocks the Racket place main thread, so the scheduler never advances — `(thread ...)` bodies silently never execute. Alternatives: `call-on-main-thread` / `call-on-main-thread-after` (GCD dispatch), synchronous main-thread execution, or shell-level watchdogs. Any code using `(thread ...)` alongside `nsapplication-run` is broken by design.

### GCD main-thread dispatch
`main-thread.rkt` provides `on-main-thread?`, `call-on-main-thread` (sync if on main, async via `dispatch_async_f` otherwise), and `call-on-main-thread-after` (delayed via `dispatch_after_f`). FFI details:
- `_dispatch_main_q` is a global struct, not a pointer — access via `dlsym` directly
- Module-level `function-ptr` prevents GC collection of the C callback pointer

### Platform-availability filters at all four levels
The platform-availability filter operates at classes, protocols, methods, and properties. No further extraction-level removals of this class are expected. Both extractors record filter decisions in `skipped_symbols` with tagged reasons: `internal_linkage`, `platform_unavailable_macos`, `swift_native`, `preprocessor_macro`, `anonymous_enum_member`. Grep `skipped_symbols` in collected IR to debug missing-symbol issues.

### Wire-format JSON changes need golden file regeneration
Serde annotations on core IR structs define the JSON wire format. Field name/alias/removal changes update Rust source across all crates but do not automatically update golden files — those require `UPDATE_GOLDEN=1`. Design-doc examples and tests asserting on `serde_json::to_string` output are tightly coupled to serde annotations.

### macOS widget quirks (Racket apps)
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
