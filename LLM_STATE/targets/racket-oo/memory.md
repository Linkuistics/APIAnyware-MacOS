# Memory

### Racket OO IR schema fields
`Enum.enum_type` is `TypeRef` (not `String`), `EnumValue.value` is `i64` (not `String`),
`Method` has `source`/`provenance`/`doc_refs` fields. These differ from the base IR schema.

### Dylib and runtime path conventions
Dylib name: `libAPIAnywareRacket` (referenced only in `swift-helpers.rkt`). Relative
runtime/generated paths depend on file depth under the target root:
- Class files (`generated/oo/<fw>/<class>.rkt`) → `../../../runtime/`
- Protocol files (`generated/oo/<fw>/protocols/<proto>.rkt`) → `../../../../runtime/`
- Apps (`apps/<name>/<name>.rkt`) → `../../runtime/` and `../../generated/oo/`
After any layout refactor, all three categories must be re-validated. Apps carry stale
prefixes indefinitely — the emitter never touches them.

### Selector filtering
Swift-style selectors containing `(` must be filtered out — e.g. `init(string:)` can't
be called via `objc_msgSend`. The extractor or emitter must exclude these.

### FFI type coercion rules
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs

### Collection-time type resolution
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases resolve to canonical types at collection time: object pointer typedefs → `Id`/`Class`, primitive typedefs → `Primitive` (including `Boolean` → `bool`), record typedefs → `TypeRefKind::Struct`

### Non-linkable-symbol filters in extractors
Non-linkable symbols (preprocessor macros, internal-linkage decls, Swift-native identifiers) leak into the IR as `get-ffi-obj` calls that fail at `dlsym` time. All filters route through `non_c_linkable_skip_reason` in the collection crates.

**Closed filters** (validated by the runtime load harness):

1. **extract-objc internal-linkage filter** — skips C decls with internal linkage (e.g. `NSHashTableCopyIn`).
2. **extract-swift `s:` USR filter** — skips Swift-native identifiers whose USR begins with `s:` (e.g. `NSLocalizedString`, `NSNotFound`).
3. **extract-swift `c:@macro@` USR filter** — skips C-preprocessor macros via the Swift digester (e.g. `kCTVersionNumber10_10`).
4. **Stale-checkpoint ghost symbols** — symbols in `swift.skipped_symbols` (e.g. `NEFilterFlowBytesMax`, `CoreSpotlightAPIVersion`) reappearing in downstream IR. Root cause: stale downstream checkpoints, not a code bug. Pipeline regeneration removes them.
5. **extract-objc `is_unavailable_on_macos()` filter** — skips bare `c:@<name>` preprocessor macros (e.g. `kAudioServicesDetailIntendedSpatialExperience`, AudioToolbox). AudioToolbox in `LIBRARY_LOAD_CHECKS`.
6. **extract-swift `c:@Ea@`/`c:@EA@` USR filter** — skips anonymous enum members in `declaration_mapping.rs` (e.g. `nw_browse_result_change_identical`, Network). Network in runtime load test.

Adding a new filter: (a) add a skip-reason branch in `non_c_linkable_skip_reason`; (b) add a canary framework to harness coverage — extensions are a discovery mechanism that surfaces new leak classes.

Dylib-unexported symbols are a separate concern — see "Emit-time filter for dylib-unexported symbols".

### `is_definition()` guards in `extract_declarations.rs`
`EnumDecl`, `StructDecl`, and `ObjCProtocolDecl` arms have `entity.is_definition()` guards to skip forward declarations that would shadow populated definitions in the `seen_*` HashSets. `ObjCInterfaceDecl` intentionally has NO guard: in Clang's AST, `@interface` is a *declaration* (the *definition* is `@implementation`, absent from SDK headers), so `is_definition()` returns `false` for all `ObjCInterfaceDecl` cursors in framework headers. Forward `@class` declarations produce `ObjCClassRef` cursors, not `ObjCInterfaceDecl`, so no forward-decl shadowing is possible for this entity kind.

### Unsigned enums need `get_canonical_type()` check
`is_unsigned_int_kind` in `extract_declarations.rs` must canonicalize via `get_canonical_type()` before checking the underlying enum type. Without this, `NS_ENUM(NSUInteger, ...)` presents as `Typedef` kind and misses the unsigned branch. Clang's `get_enum_constant_value()` returns `(i64, u64)` — use `.1` (unsigned) for unsigned-backed enums. Values exceeding `i64::MAX` are skipped with `tracing::warn!` (the IR schema is i64; silent wrapping would corrupt value semantics). Requires re-collect to propagate.

### libclang resolves symlinked subframeworks to canonical path
ColorSync, CoreGraphics, CoreText, and ImageIO live under `ApplicationServices.framework` as symlinks, but libclang resolves their declarations to the canonical top-level framework paths (`System/Library/Frameworks/CoreGraphics.framework/...`). Only genuinely non-symlinked subframeworks (HIServices, ATS, PrintCore) need an allowlist entry in `is_from_framework`. The symlinked ones are accepted via their own top-level entries.

### Subframework allowlist in `sdk.rs`
`SUBFRAMEWORK_ALLOWLIST = &["ApplicationServices"]` in `sdk.rs`'s `is_from_framework` accepts header paths under that framework containing `/Headers/`. Quartz is excluded: the `clang-2.0.0` crate panics on a UTF-8 error when visiting a Quartz subframework path during a full collect run. Expanding to Carbon/CoreServices requires fixing that panic first.

### Synthetic pseudo-framework structure and hookup
For system headers outside the `.framework` tree (e.g. libdispatch, pthread): checked-in umbrella header at `collection/crates/extract-objc/synthetic-frameworks/<name>/<name>.h`; `sdk.rs` appends a synthetic `FrameworkInfo` via `synthetic_frameworks()`; `is_from_framework` branches on the synthetic name to accept the relevant `usr/include/` paths. Emitter hookup: `framework_ffi_lib_arg` in `shared_signatures.rs` maps the synthetic framework name to the actual dylib short name. No other emitter changes needed.

### libdispatch ffi-lib must be `"libSystem"`
The `libdispatch` short name does not resolve via dyld's shared cache on macOS even though the symbols exist. Dispatch symbols are re-exported from `libSystem`. `framework_ffi_lib_arg` in `shared_signatures.rs` maps `libdispatch → "libSystem"`.

### Header-declared ≠ dylib-exported on macOS
Some symbols present in SDK headers do not exist in the live dylib shared cache. Snapshot tests cannot detect this; only the runtime load harness can. When adding new framework coverage, always run the harness before declaring victory.

### Emit-time filter for dylib-unexported symbols
Header-declared symbols absent from the live dylib are filtered at emit time, not at collection time — collection-time filtering would require a Rust `dlopen`/`dlsym` probe per symbol. The emit-time filter (`is_libdispatch_unexported` in `emit_functions.rs`) is a single grep-able location for "what did we omit and why". Libdispatch known-missing: `dispatch_cancel`, `dispatch_notify`, `dispatch_testcancel`, `dispatch_wait`, `pthread_jit_write_with_callback_np`.

### Framework dylib and `get-ffi-obj` pattern
`constants.rkt` and `functions.rkt` load the framework dylib as `_fw-lib` (excluded from `provide`) and use `get-ffi-obj`:
- Constants: `(define Name (get-ffi-obj 'Name _fw-lib _type))`
- Functions: `(define Name (get-ffi-obj 'Name _fw-lib (_fun arg-types... -> ret-type)))`
Geometry struct constants (`NSZeroPoint`/`NSZeroRect`) map correctly via alias handling in `RacketFfiTypeMapper`.

### Require block shape for functions and constants
Both files always require `ffi/unsafe`, `ffi/unsafe/objc`, and `racket/contract` (renamed to dodge the `->` conflict), regardless of whether any binding uses `_id`. Unconditional is cheaper than per-binding Id-detection drift. `type-mapping.rkt` is a conditional require for `functions.rkt` only — emitted when `any_struct_type` (in `shared_signatures.rs`) returns true. `constants.rkt` never requires `type-mapping.rkt` — struct-typed globals use `ffi-obj-ref`, so no cstruct type is needed. Forgetting `ffi/unsafe/objc` is invisible until a file with an `_id`-typed binding is loaded.

### Framework subsets differ for functions vs classes
The set of frameworks with emittable C functions (non-variadic, non-inline) is a strict subset of the class emission set, which covers all frameworks. WebKit has classes but no C functions — a common source of confusion when cross-referencing log lines.

### `->` name conflict: `ffi/unsafe` vs `racket/contract`
Requiring both `ffi/unsafe` and `racket/contract` causes a hard `->` identifier conflict. The mandatory form:

    (require ffi/unsafe
             (rename-in racket/contract [-> c->]))

Contract arrows become `(c-> arg-contract ... ret-contract)`. Applies to `functions.rkt`, `constants.rkt`, every class wrapper, and any file needing `racket/contract`. Protocol files use `->*` and dodge the conflict, but `rename-in` is safe prophylactically.

### `make-nsrect` takes 4 scalars; `make-NSRect` takes point+size
The 4-scalar convenience constructor `make-nsrect` (x y w h) is the form apps use. The low-level `make-NSRect` struct constructor takes an `NSPoint` and an `NSSize`. Same split applies to `make-nssizey`/`make-NSSize` and `make-nspoint`/`make-NSPoint`.

### `type-mapping.rkt` must `provide` every cstruct
Every `define-cstruct` in `runtime/type-mapping.rkt` must appear in its `(provide ...)` list. Current exports: `_NSPoint`, `_NSSize`, `_NSRect`, `_NSRange`, `_CGPoint`, `_CGSize`, `_CGRect`, `_NSEdgeInsets`, `_NSDirectionalEdgeInsets`, `_NSAffineTransformStruct`, `_CGAffineTransform`, `_CGVector`. Adding a geometry struct: (1) `define-cstruct`, (2) add to provide, (3) add to `is_known_geometry_struct` in `emit/src/ffi_type_mapping.rs`. Struct detection goes through `any_struct_type(type_refs, mapper)` in `shared_signatures.rs`, used by class wrappers, `emit_functions.rs`, and `emit_constants.rs` — a one-allowlist-edit operation.

### Three verification layers; none alone suffices
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
- `runtime_load_libraries_via_dynamic_require` — library checks via single racket script collecting all failures
- `runtime_load_apps_via_raco_make` — `raco make` over all sample apps

Gated on `RUNTIME_LOAD_TEST=1`, auto-skips if `racket`/`raco` missing or enriched IR absent. ~40s on M1. Builds a hermetic tempdir matching the canonical target tree so it doesn't race the `compiled/` cache.

**Standing rule**: add coverage whenever a new `LIBRARY_LOAD_CHECKS` candidate appears — several new frameworks cost well under 1s (amortized Racket startup). Extensions surface new leak classes (see "Non-linkable-symbol filters in extractors"). New runtime files (e.g. `dynamic-class.rkt`) must be added to both `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.

### `dynamic-require` needs `(file ,path)`
The harness uses `(dynamic-require \`(file ,p) #f)`, not `(dynamic-require p #f)`. A raw path string trips a `module-path?` contract violation. The `(file ...)` quasi-form wraps absolute filesystem paths.

### `raco` has no `--version` flag
`raco --version` exits non-zero. The reliable probe is `raco help`. The harness uses `binary_on_path("racket", "--version")` and `binary_on_path("raco", "help")`.

### Contract-based API boundaries
Every FFI boundary uses `provide/contract`. Three contract mappers:
- `map_contract` in `emit_functions.rs` (value/function): primitives → `real?`/`exact-integer?`/`exact-nonnegative-integer?`/`boolean?`, objects → `cpointer?` or `(or/c cpointer? #f)` for nullable, CString return → `(or/c string? #f)` (`_string` converts NULL → `#f`), CString param → `string?`, geometry structs → `any/c`, void → `void?`. `exact-nonneg-integer?` is not a Racket predicate — fails only at load time.
- `map_param_contract` in `emit_class.rs` (class wrapper params): `Id`/`Class`/`Instancetype` → `(or/c string? objc-object? #f)` for all object params (always includes `#f`; `cpointer?` excluded), SEL → `string?`, `(or/c procedure? #f)` for blocks, delegates to `map_contract` for primitives.
- `map_return_contract` in `emit_class.rs` (class wrapper returns): `<class>?` predicate for `TypeRefKind::Class { name }` (see "Class return predicates: per-file inline factory"), `any/c` for `Id`/`Instancetype`, delegates to `map_contract` for void/primitives.
Protocol files use fixed contracts (see "Protocol file contract shape is fixed").

### Class wrapper contracts: self `objc-object?`, params typed unions
Self uses `SELF_CONTRACT` (`"objc-object?"`) in `emit_class.rs` for instance methods and property getters/setters — rejects misuse at caller blame.
- **Object params** (`Id`/`Class`/`Instancetype`): `(or/c string? objc-object? #f)` — always includes `#f` (ObjC nil messaging is always a no-op). `cpointer?` excluded.
- **SEL params**: `string?` at contract boundary; wrapper calls `sel_registerName`. Applies to both methods and property setters.
- **Object returns**: `<class>?` predicate for `TypeRefKind::Class { name }` (see "Class return predicates: per-file inline factory"); `any/c` for `Id`/`Instancetype` via `map_return_contract`.
`objc-object?` in scope via `coerce.rkt` re-exporting `runtime/objc-base.rkt`. Class-property methods omit `self` (see "Class-property methods omit `self`").

### Class return predicates: per-file inline factory
Each class file defines its own predicate (e.g. `(define (nsview? v) (objc-instance-of? v "NSView"))`) — no cross-class requires, no central barrel. `objc-instance-of?` primitive in `runtime/objc-base.rkt` backs all predicates via `class_isKindOfClass:` from libobjc (subclass instances satisfy parent predicate). Predicates only affect `map_return_contract` return positions — all params flow through `coerce-arg`. `TypeRefKind::Class { name }` emits the class predicate; `Id`/`Instancetype` keep `any/c`. Cross-class requires create circular dependency risk; a central barrel is disproportionate for this narrow scope.

### `objc-object?` is a struct predicate, not cpointer
`(cast ptr _pointer _id)` tags the pointer for FFI but does NOT create an `objc-object` struct — it fails the `objc-object?` contract at class wrapper boundaries. For `make-delegate` with `#:param-types`, `'object`-typed callback args are wrapped automatically via `borrow-objc-object`. For `tell`-based code not using `#:param-types`, use `wrap-objc-object` manually. Do NOT use `tell` as a bypass for non-object parameters (int, bool, SEL) — `tell` rejects them with `id->C: argument is not 'id' pointer`.

### `tell` receiver must be `coerce-arg`'d
`tell` from `ffi/unsafe/objc` accepts only `_id`-tagged cpointers or imported class refs — it does NOT accept `objc-object?` struct wrappers. Raw cpointers from ObjC trampolines (e.g. `self`, `event` args in dynamic-subclass IMPs) give `id->C: argument is not 'id' pointer`. `borrow-objc-object` ALSO fails — the result is still an `objc-object` struct, not an `_id`-tagged pointer.
Correct fix: `(tell (coerce-arg receiver) selector ...)`. `coerce-arg` does the `(cast ... _pointer _id)` internally for all of {string?, objc-object?, cpointer?, #f}:
`(tell #:type _NSPoint (coerce-arg event) locationInWindow)`.

### Dynamic-subclass delegate callbacks need `#:param-types`
Dynamic-subclass IMPs created via `function-ptr` + `_cprocedure` pass raw cpointers for `id`-typed args. If the handler sends messages to that arg via a generated class wrapper (e.g. `(nscolorpanel-color sender)`), the contract violation is `objc-object?` self — raw cpointer fails the self predicate. Fix: pass `#:param-types (hash "selector" '(object))` to `make-delegate`. The trampoline then auto-wraps the arg via `borrow-objc-object`. Symptom looks identical to the `tell`-on-cpointer error but the root cause is a contract violation at the delegate boundary, not the `tell` boundary.

### NSColor component accessors require RGB color space
`nscolor-red-component`, `-green-component`, `-blue-component`, `-alpha-component` raise `NSException` on colors not in an RGB color space (pattern, named, greyscale colors). Before accessing components on a color from NSColorPanel (whose color space is user-selectable), convert via `(nscolor-color-using-color-space c (nscolorspace-device-rgb-color-space))`. The result may be `#f` if the color cannot be converted — always `(when rgb ...)` guard after the conversion.

### `only-in` does NOT skip module expansion
`(only-in path bind1 bind2)` still fully expands the target module — it's a consumer-side visibility filter, not a module-load filter. If `path` has a module-level error (e.g. generator-produced duplicate `define` forms), even importing one identifier fails. Workaround when blocked on a generator-level module bug: use raw `tell`/`objc_msgSend` for the specific call sites instead of touching the broken module at all.

### Class-property methods omit `self`
Class-property getters/setters have no `self` parameter. `build_export_contracts` drops `self` for `prop.class_property`. `emit_property`'s setter branches substitute `class_name` for `(coerce-arg self)` as the target. TestKit has no class-method properties, so arity divergence is only caught by the real-framework canary (`nsmenuitem.rkt` in `LIBRARY_LOAD_CHECKS`).

### Match `tell` `#:type` to IR return type
`tell` defaults to `#:type _id`, so a bare `tell` against a void method reads return register garbage as a tagged pointer. `(void (tell ...))` only satisfies the Racket-side contract — it doesn't fix the underlying type mismatch. Correct void emission:

    (tell #:type _void target args)

Same applies to property setters with `Id`-shaped value types (still `_void`-returning). TypedMsgSend dispatch handles this via `mapper.map_type`. The two emit sites needing explicit `#:type` are the `_id`-typed property setter (`emit_property`) and the Tell-dispatch void-method body (`emit_method`, `ret_is_void` branch). Test pattern: assert `tell #:type _void` present AND `(void (tell` absent.

### Contract export plumbing in class wrappers
`build_export_contracts` in `emit_class.rs` pre-computes `(name, contract)` pairs for constructors, properties, instance methods, and class methods, then emits a single `provide/contract` form. New exported bindings must be added to `build_export_contracts` — otherwise they won't be provided.

### Protocol file contract shape is fixed
Protocol files export exactly two bindings:
- `make-<proto>` — `(->* () () #:rest (listof (or/c string? procedure?)) any/c)`
- `<proto>-selectors` — `(listof string?)`
No per-method contracts exist — delegate handlers are user-supplied lambdas, not emitted bindings. Constants `MAKE_DELEGATE_CONTRACT` and `SELECTOR_LIST_CONTRACT` in `emit_protocol.rs` hold the strings.

### `provide/contract` rest-arg limitation
`provide/contract` cannot express positional alternation inside `#:rest` — `(listof (or/c string? procedure?))` catches type errors but cannot enforce the string/procedure pairing `make-<proto>` requires. Stronger enforcement needs a dependent contract combinator.

### Function emission filtering
Variadic and inline functions are skipped — they can't be bound via `get-ffi-obj`. TestKit includes both types to verify exclusion.

### VM and testing workflow
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Always `pkill -9 -f racket` before relaunching apps
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`
- TestAnyware agent `exec` is reliable for long-running commands (wedge fixed 2026-04-17). The `timedOut: true` response field signals a deadline-expired run — distinct from a non-zero exit code; the underlying command keeps running in the VM, so poll for completion rather than switching tools. **Do not use SSH** — `exec` is the right tool.

### Snapshot testing infrastructure
`load_enriched_framework(name)` in `snapshot_test.rs` generalizes framework loading — adding a new framework is a file list and test function. AppKit suite has 23 curated golden files covering key class hierarchies (NSResponder→NSView→NSControl→NSButton, NSWindow, table view, menus, text, layout). Rich classes like NSButton and NSWindow exercise more typed message send variants and geometry struct handling than Foundation classes.

### `make-objc-block` nil guard
`make-objc-block` returns `(values #f #f)` for `#f` input (NULL block pointer + no block-id). `free-objc-block` handles `#f` gracefully (no-op via `hash-ref` miss). `call-with-objc-block` passes `#f` through to body. Tested via `runtime_block_nil_guard` in `runtime_load_test.rs` (gated on `RUNTIME_LOAD_TEST=1`).

### `function-ptr` satisfies `(or/c cpointer? #f)` contract
A `function-ptr` constructed from `_cprocedure` satisfies the `(or/c cpointer? #f)` contract emitted for C callback parameters. No raw-symbol fallback is needed for callback params in generated bindings.

### Racket green threads dead under `nsapplication-run`
All Racket green-thread primitives (`thread`, `sleep`, `sync`, `sync/timeout`, `thread-wait`, `semaphore-wait`) are non-functional once `nsapplication-run` is called. The Cocoa run loop blocks the Racket place main thread, so the scheduler never advances — `(thread ...)` bodies silently never execute. Alternatives: `call-on-main-thread` / `call-on-main-thread-after` (GCD dispatch), synchronous main-thread execution, or shell-level watchdogs.

### GCD main-thread dispatch
`main-thread.rkt` provides `on-main-thread?`, `call-on-main-thread` (sync if on main, async via `dispatch_async_f` otherwise), and `call-on-main-thread-after` (delayed via `dispatch_after_f`). FFI details:
- `_dispatch_main_q` is a global struct, not a pointer — access via `dlsym` directly
- Module-level `function-ptr` prevents GC collection of the C callback pointer

### Platform-availability filters at all four levels
The platform-availability filter operates at classes, protocols, methods, and properties. Both extractors record filter decisions in `skipped_symbols` with tagged reasons: `internal_linkage`, `platform_unavailable_macos`, `swift_native`, `preprocessor_macro`, `anonymous_enum_member`. Grep `skipped_symbols` in collected IR to debug missing-symbol issues.

### Wire-format changes require golden file regeneration
Serde annotations on core IR structs define the JSON wire format. Field name/alias/removal changes update Rust source across all crates but do not automatically update golden files — those require `UPDATE_GOLDEN=1`. Design-doc examples and tests asserting on `serde_json::to_string` output are tightly coupled to serde annotations.

### `_cprocedure` callbacks unsafe from foreign OS threads
Racket CS SIGILLs (exit 132) when a `_cprocedure` callback is invoked from an OS thread not registered with the Racket VM (e.g., GCD worker pool threads from libdispatch). `#:async-apply` converts the crash to a deadlock under `nsapplication-run` because the async-apply queue drains on the main Racket thread, which is stuck in the Cocoa run loop. The CGEvent tap callback fires on `CFRunLoopGetMain` (main OS thread), not a foreign thread — it is safe without `#:async-apply`. Any binding exposing a C callback type should warn against installing it on a non-main GCD queue or libdispatch worker.

### Emitter auto-warns on `FunctionPointer`/`Block` params
`generate_functions_file()` emits a 3-line `; WARNING:` comment before any `define` with `FunctionPointer` or `Block` param types, citing `_cprocedure`, SIGILL risk, and `#:async-apply`/deadlock. See "`_cprocedure` callbacks unsafe from foreign OS threads".

### `call-in-os-thread` safe for pure Racket/file-I/O only
`ffi/unsafe/os-thread` (`call-in-os-thread`) works for closures, list/hash ops, `parameterize`, file I/O (`open-input-file`, etc.). Segfaults on `tcp-connect`, `subprocess`/`system`, and anything using Racket's place scheduler I/O event pump. `net/url` uses TCP, transitively unsafe. Useful for CPU-bound work (fuzzy matching, serialization).

### `dynamic-place` for I/O off the main thread
Each `dynamic-place` runs a separate Racket VM on its own OS thread with its own scheduler. `net/url`, `tcp-connect`, `subprocess` work correctly inside places. Place-channel semantics: `place-channel-put` is fully buffered (non-blocking sender), `place-channel-get` blocks (fatal on main thread under `nsapplication-run`), `sync/timeout 0` on a place-channel is a non-blocking try-receive safe under `nsapplication-run`. Pattern: place does I/O; main thread polls via `place-channel-try-get` on a `call-on-main-thread-after` timer — main thread never blocks.

### macOS widget quirks (Racket apps)
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
- NSScrollView `dy=+50` scrolls toward top (toward Cocoa unflipped origin) — opposite of natural scrolling mental model

### `only-in` for generated binding subsets
Use `only-in` rather than wholesale `require` when consuming a subset of generated bindings:

    (only-in "../bindings/generated/oo/coregraphics/functions.rkt"
             CGEventSourceCreate CGEventCreateKeyboardEvent ...)
    (only-in "../bindings/generated/oo/corefoundation/functions.rkt" CFRelease)
    (only-in "../bindings/generated/oo/corefoundation/constants.rkt" kCFRunLoopCommonModes)

Documents exactly which generated names the consumer uses; prevents `racket/contract` re-exports from leaking through. Global-variable constants (e.g. `kCFRunLoopCommonModes`) are emitted as `(get-ffi-obj 'name lib _pointer)` and resolve correctly via `dlsym`.

### Distributable bundles must exclude `compiled/` subdirectories
Host-compiled `.zo` files under `compiled/` are machine- and Racket-version-specific
(linklets bake in host-specific path references). Copying them to a different machine
causes runtime contract errors at load time (e.g. wrong-arity contract on `make-nsmenuitem-init-with-title-action-key-equivalent`). Strip before packaging:
`find . -name compiled -type d -exec rm -rf {} +` or `rsync --exclude=compiled`.
**`bundle-racket-oo` enforces this automatically:** the `.rkt`-only walker skips
`compiled/` implicitly (no `.rkt` files inside), and `copy_dir_recursive` for `lib/`
explicitly skips any `compiled/` subdirectory. Tests
`bundle_lib_copy_excludes_compiled_subdirectory` and
`bundle_has_no_compiled_directories_anywhere` guard this invariant.

### `bundle-racket-oo` normalizes dylib install_name
After copying `lib/` into the bundle, `normalize_dylib_install_names` shells out to
`install_name_tool -id @executable_path/../Resources/racket-app/lib/<name>` on each
`.dylib`. Racket's `ffi-lib` uses an explicit filesystem path and is indifferent to
the identity, but any native consumer (direct-link tool, dyld introspection) can now
resolve the dylib inside the bundle — the defining property of a self-contained
bundle. Non-fatal if `install_name_tool` is missing: logs a `tracing::warn!` and
leaves the original identity. Test `bundle_dylib_install_name_is_bundle_relative`
asserts the `@executable_path/` prefix on the bundled dylib.

### Sample apps bundle via `bundle-racket-oo` crate
`apianyware-macos-bundle-racket-oo` builds racket-oo `.app` bundles: require-tree BFS for dependency discovery, `Resources/racket-app/<rel>` layout preserving the source tree so relative requires resolve at runtime, optional `lib/libAPIAnywareRacket.dylib` copy. CLI: `cargo run --example bundle_app -p apianyware-macos-bundle-racket-oo -- <script>` or `-- --all`. Built bundles land at `apps/<name>/build/<App Name>.app` (gitignored). Every sample app calls `(install-standard-app-menu! app "<Display>")` from `runtime/app-menu.rkt`.

### `NSProcessInfo setProcessName:` ignored on modern macOS
`setProcessName:` has no effect on the bold app-name slot in the macOS menu bar. `CFBundleName` in `Info.plist` is the only path. `racket script.rkt` direct execution always shows "racket" in the menu bar. Bundling is required for correct app identity, not optional polish.

### New sample apps need spec.md only
Create `apps/<name>/<name>.rkt` and `knowledge/apps/<name>/spec.md` with `# <Display Name>` as the first heading. `bundle-racket-oo` reads the H1 for the canonical display name — kebab→title conversion produces wrong capitalisation for acronyms (e.g. "Ui Controls Gallery"). The integration test in `bundle-racket-oo` auto-discovers apps via directory walk; no test edits needed for a new app.

### `app-menu.rkt` uses typed `objc_msgSend` for SEL params
`tell` fails on selectors with SEL parameters (`id->C: argument is not 'id' pointer`) — Racket SELs are plain `cpointer`, not `_id`-tagged. `addItemWithTitle:action:keyEquivalent:` and `initWithTitle:action:keyEquivalent:` both hit this. `app-menu.rkt` defines explicitly-typed `objc_msgSend` aliases (`_msg-init-with-title-action-key`, `_msg-add-item-with-title-action-key`, ...) and calls them with `sel_registerName` selectors — the same pattern the generated framework bindings use for non-id-parameter methods.

### `as-id` casts both branches to `_id`
`as-id` in `runtime/objc-base.rkt` must `(cast ... _pointer _id)` in both the `objc-object?` and `cpointer?` branches. If the `objc-object?` branch returns the raw pointer instead, callers passing a wrapped object to `tell` get `id->C: argument is not 'id' pointer`.

### Accessibility menu drill-down needs a mouse click
`testanyware agent snapshot --window "Menu Bar"` only surfaces the top-level menu items (Apple, app-name). The submenu is not in the accessibility tree until the menu opens. To verify the full menu content, click the menu title via VNC (`testanyware input click --connect spec.json X Y`) then `screenshot` the region. The agent's `press --role menu-item --label "Counter"` query returns `No element found matching query` because accessibility doesn't treat menu bar items as directly-pressable in the default snapshot mode.

### TestAnyware uses per-VM connection spec
`vm-start.sh` writes a per-VM spec to `$XDG_STATE_HOME/testanyware/vms/<id>.json`
(default: `~/.local/state/testanyware/vms/<id>.json`), enabling multiple concurrent VMs
with distinct ids. `vm-start.sh` prints the VM id on stdout (so `ID=$(vm-start.sh ...)`
captures it). Auto-generated id is `testanyware-<hex>` unless `--id <name>` is passed.

CLI resolution order (highest priority first):
  1. `--connect <path>` — explicit spec file
  2. `--vm <id>` — resolves via `$XDG_STATE_HOME/testanyware/vms/<id>.json`
  3. `--vnc`/`--agent`/`--platform` explicit flags
  4. `TESTANYWARE_VM_ID` env var
  5. `TESTANYWARE_VNC`/`TESTANYWARE_VNC_PASSWORD`/`TESTANYWARE_AGENT` env vars

Use `--vm <id>` or `TESTANYWARE_VM_ID=<id>` and thread it through `Bash` calls — no
manual `/tmp/ta_*` file-copying. `vm-stop.sh <id>` tears down a specific VM.

### Auto-terminating Cocoa-loop test pattern
Tests entering `nsapplication-run` need a structured exit to avoid hanging the test runner:

1. Inside `applicationDidFinishLaunching:` body, register a **safety-net** first:
   `(call-on-main-thread-after 5.0 (lambda () (eprintf "safety net: test timed out\n") (exit 1)))`
   — fires even if an assertion exception is caught by the delegate's `with-handlers` boundary.
2. Run assertions inside the existing `with-handlers` boundary.
3. Schedule a **normal-path exit**: `(call-on-main-thread-after 0.5 (lambda () ... (exit 0)))`.
4. File ends with `(nsapplication-run app)`.

Outcomes: assertions pass → `(exit 0)` → `[OK]`. Assertion raises (caught by `with-handlers`) → safety net fires → `(exit 1)` → `[FAIL]`. Genuine hang → test runner's `timeout -k 1 30` → `[TIMEOUT]`. The safety-net timeout (5 s) must be longer than the normal-path delay (0.5 s).

### ObjC type encoding `q` is NSInteger on 64-bit
NSInteger is `typedef long NSInteger` on 64-bit Apple platforms; clang encodes `long` as `q` (not `l`). Delegate trampoline mapping: `'long → "q"` in both Swift `typeEncoding` and Racket `return-kind->string`. No separate `'nsinteger` kind is needed.

### Delegate return kinds `'int` and `'long` supported
DelegateBridge.swift defines `impInt0..3` (returning `Int32`) and `impLong0..3` (returning `Int64`). `selectIMP` and `typeEncoding` extended with `("int", N)` / `("long", N)` cases. `delegate.rkt` mirrors in `return-kind->string`, `make-delegate/swift`, `make-delegate/racket`, `delegate-set!`, plus `type-encoding-int` / `type-encoding-long` helpers. `'long` is the correct kind for NSInteger-returning delegate methods on 64-bit Apple platforms (see "ObjC type encoding `q` is NSInteger on 64-bit"). Protocol emitter generates these as entries in the `#:param-types` hash via `param_type_symbol` in `emit_protocol.rs`.

### `borrow-objc-object` wraps raw pointer as `objc-object?`
`borrow-objc-object` in `objc-base.rkt` creates a struct satisfying `objc-object?` from a raw cpointer, with no retain/release. `make-delegate` returns one so delegates satisfy `objc-object?` at class wrapper boundaries (e.g. `nsbutton-set-target!`). The `#:param-types` trampoline uses `borrow-objc-object` to wrap `'object`-typed callback args automatically.

### `make-delegate` handlers receive no `self`; positional args alternate
Positional args to `make-delegate` are alternating selector-string / procedure pairs. Handler lambdas do NOT receive `self` — only the delegated arguments. Keyword args are `#:return-types` and `#:param-types`. `make-<proto>` pre-fills both hashes from protocol IR.

### `#:param-types` on `make-delegate` auto-coerces callback args
Hash mapping selectors to lists of type symbols (`'object`, `'long`, `'int`, `'bool`, `'pointer`). The trampoline coerces each arg before the handler runs; `delegate-set!` also reads stored param-types. Protocol emitter generates the hash via `param_type_symbol` in `emit_protocol.rs` from IR param types.

### `objc-autorelease` converts owned pointer to autoreleased
`objc-autorelease` in `objc-base.rkt` converts a +1 owned pointer to +0 autoreleased. Used when delegate callbacks return ObjC objects (e.g. NSString from `tableView:objectValueForTableColumn:row:`).

### `->string` converts NSString polymorphically
`->string` in `runtime/type-mapping.rkt` (re-exported via `coerce.rkt`) accepts `objc-object`, `cpointer`, `string?`, or `#f`. Replaces per-app `ns->str` helpers.

### All 4 sample apps use zero `ffi/unsafe` imports
`hello-window`, `counter`, `ui-controls-gallery`, `file-lister` contain no `ffi/unsafe` requires. Achieved via `#:param-types` auto-wrapping, `->string` for NSString returns, and SEL-as-string at class wrapper boundaries.

### `dynamic-class.rkt` exports libobjc subclass surface
`generation/targets/racket-oo/runtime/dynamic-class.rkt` exports: `objc-get-class`, `allocate-subclass`, `add-method!`, `register-subclass!`, `get-instance-method`, `method-type-encoding`, and `make-dynamic-subclass` (chains allocate→add-method→register in the correct order). Type aliases `_Class`/`_SEL`/`_Method`/`_IMP` exported for raw-msgSend consumers. Must be added to both `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS` in the harness.

When overriding superclass methods, pull the type encoding string via `(method-type-encoding (get-instance-method SuperClass sel))` rather than hardcoding. Hardcoded strings drift silently if Apple changes the ABI; pulling from the live superclass method is always correct.

### libdispatch `_id` params emitted as `_pointer`
`dispatch_queue_t`, `dispatch_group_t`, etc. resolve to `id` in the IR (under `OS_OBJECT_USE_OBJC=1`), but no wrapper classes exist in the generated bindings. The emitter maps `_id` → `_pointer` in libdispatch's `functions.rkt` so consumers can pass raw cpointers without a `(cast ... _pointer _id)` ceremony. The ABI is identical. This override is scoped to `framework == "libdispatch"` in `generate_functions_file`. If future frameworks gain the same OS-object pattern (e.g. `xpc_object_t`), extend the same override.

### Struct-typed global constants use `ffi-obj-ref`
Constants whose IR type is `TypeRefKind::Struct` (e.g. `_dispatch_main_q`, `_dispatch_source_type_*`, geometry zero-constants) are emitted as `(define sym (ffi-obj-ref 'sym lib))` — returning the symbol's address. Non-struct constants keep `(get-ffi-obj 'sym lib type)` — dereferencing the symbol. The distinction is in `generate_constants_file` via `is_struct_data_symbol()`. Contract for struct globals is `cpointer?`. `constants.rkt` does not require `type-mapping.rkt` — struct globals use `ffi-obj-ref`, not a typed getter needing a cstruct. **Known gap:** CF struct globals from CoreFoundation (`kCFTypeDictionaryKeyCallBacks`, `kCFTypeDictionaryValueCallBacks`) are NOT currently emitted — absent from collected IR. Workaround: `(get-ffi-obj 'kCFTypeDictionaryKeyCallBacks (ffi-lib "CoreFoundation") _pointer)`.

### `NSEdgeInsets` absent from geometry struct allowlist causes missing require
`NSEdgeInsets` was missing from `is_known_geometry_struct` in `ffi_type_mapping.rs`, causing `any_struct_type` to miss it and the conditional `type-mapping.rkt` require to be omitted from `wkwebview.rkt`. Fixed by adding `NSEdgeInsets` to the allowlist. `wkwebview.rkt` is in `LIBRARY_LOAD_CHECKS`.

### `make-dynamic-subclass` guards against duplicate registration
`objc_allocateClassPair` returns NULL for a name already registered — `class_addMethod(NULL, ...)` crashes. `make-dynamic-subclass` guards by returning the existing class via `objc_getClass` first. `class_addMethod` on an already-registered class (non-NULL) is a libobjc no-op, not an error, so re-requiring a module that calls `make-dynamic-subclass` at load time is safe.

### Record typedefs extract to `TypeRefKind::Struct`
`map_typedef` in `extract-objc` emits `TypeRefKind::Struct { name }` (not `Alias`) for `TypeKind::Record` typedefs. Enables `is_struct_data_symbol` in the constants emitter to recognize CF struct globals (`kCFTypeDictionaryKeyCallBacks`, `NSInt*CallBacks`, geometry zero-constants like `NSZeroPoint`/`NSEdgeInsetsZero`) and emit `ffi-obj-ref` instead of `get-ffi-obj`. Requires re-collect to propagate.

### `const char *` maps to `TypeRefKind::CString`
`is_c_string_pointee()` in `extract-objc` accepts `CharS | CharU` pointees only and requires `is_const_qualified()` on the pointee (not the pointer). Non-const `char *` (output buffers) maps to `Pointer`. IR carries `TypeRefKind::CString`; FFI mapper emits `_string`. Requires re-collect to propagate to generated files.

### Property dedup by Racket getter name, not IR name
ObjC/Swift dual-extracted properties can differ only in casing (e.g., `CGDirectDisplayID` vs `cgDirectDisplayID`), which kebab-cases to the same Racket identifier. `effective_properties` must deduplicate by generated Racket getter name; IR-name dedup leaves duplicate `define` forms in emitted class files.

### `is_generic_type_param` identifies ObjC generic params by case pattern
Single uppercase letter followed by lowercase chars (e.g., `ObjectType`, `KeyType`) identifies ObjC generic type parameters; framework-prefixed aliases have 2+ uppercase chars (e.g., `AXValueType`). Used in `emit/src/ffi_type_mapping.rs` to prevent mapping framework-defined type aliases as `_uint64`. Replaces a maintained allowlist of 15+ framework prefixes in `map_contract`.

### Property/method collision sets partition by class vs instance
`PropertyNameSets` in `emit_class.rs` separates `class_property_names` and `instance_property_names`. A flat merged set causes cross-level false positives — e.g., an instance bool-property getter name suppressing a same-named class factory method. Class methods collide only with class property names; instance properties whose getter name matches a class method name are suppressed (class method wins).

### CFSTR constants emitted via `_make-cfstr` module-level helper
`CFSTR(...)` macro constants are not linked to any dylib. `ir.rs` carries `macro_value: Option<String>` on `Constant`; the ObjC extractor tokenises source ranges to match `CFSTR("literal")` patterns. Emitter outputs a module-level `_make-cfstr` preamble (loads `CFStringCreateWithCString` from CoreFoundation) and `(define kFoo (_make-cfstr "literal"))` per constant. `CFStringRef` lifetime is pinned to the module (no ARC). Contract: `(or/c cpointer? #f)`.

### `cf-bridge.rkt` and `nsview-helpers.rkt` runtime helpers
`cf-bridge.rkt` exports: `racket-string->cfstring`/`cfstring->racket-string`, `cfnumber->integer`/`cfnumber->real`, `cfboolean->boolean`, `cfarray->list`, `make-cfdictionary`, `with-cf-value` (auto-release). `nsview-helpers.rkt` provides NSView geometry helpers. Both listed in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.

### AX, CGEvent, and SPI runtime helper files
Three runtime files, all in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`:
- `ax-helpers.rkt`: typed AX attribute access; `ax-get-attribute/raw` returns +1 owned CFTypeRef; `ax-get-attribute/array` calls `cfarray->list` with `_CFRetain` per element; `malloc`/`CFRelease` scoped internally (no `free` — see "Racket CS `malloc` returns GC memory").
- `cgevent-helpers.rkt`: `CGEventTapCreate` + `CFRunLoop`; `make-cgevent-tap` accepts `#:on-disabled` keyword (default: auto-re-enables tap); tap pointer threaded via `tap-box` to break forward-reference cycle; exports `kCGEventTapDisabledByTimeout`/`kCGEventTapDisabledByUserInput`; module-level `function-ptr` for GC stability; tap fires on `CFRunLoopGetMain` so `_cprocedure` is safe without `#:async-apply` (see "`_cprocedure` callbacks unsafe from foreign OS threads").
- `spi-helpers.rkt`: `_AXUIElementGetWindow` with graceful `#f` fallback.

### `objc-interop.rkt` provides curated FFI symbol re-exports
`runtime/objc-interop.rkt` is a named-`provide` re-export of `ffi/unsafe` + `ffi/unsafe/objc` symbols. Wired into the runtime load harness. Listed in `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.

### Racket CS `malloc` returns GC memory; never `free`
`(malloc …)` in Racket CS returns GC-tracked memory. Passing it to `free` causes SIGABRT because `free` expects C-heap pointers only. Do not call `free` on `(malloc …)` buffers — the GC reclaims them automatically. Only call `free` on memory returned by a C function that itself calls `malloc` internally.

### Class/instance selector disambiguation handles `+`/`-` collisions
`emit_class.rs` builds `instance_bindings` = instance method names ∪ instance property getter names, then `class_method_disambig` flags class methods whose selector collides. `make_class_method_name(..., true)` emits the `-class` suffix. NSEvent's `+modifierFlags`/`-modifierFlags` split correctly into `nsevent-modifier-flags-class` and `nsevent-modifier-flags`. `nsevent.rkt` is in `LIBRARY_LOAD_CHECKS` and loads cleanly.

### Typed class returns are nullable via `(or/c <pred>? objc-nil?)`
`map_return_contract` in `emit_class.rs` emits `(or/c {pred} objc-nil?)` for every `TypeRefKind::Class { name }` return. `objc-nil?` lives in `runtime/objc-base.rkt`. Legitimately-nil Cocoa properties (`PDFView.document` before assignment, `NSTableView.dataSource` before wiring, `NSWindow.firstResponder` under timing races) no longer fail their own contracts.

### `list->nsarray`/`hash->nsdictionary` live in `type-mapping.rkt`
Both helpers in `runtime/type-mapping.rkt` wrap the `(tell (tell NSMutableArray alloc) init)` result via `(wrap-objc-object arr #:retained #t)` — `alloc+init` is +1 retained so the finalizer balances. Callers pass the result directly into class-wrapper param contracts without manual wrapping. `nsarray->list` / `nsdictionary->hash` accept both raw cpointers and wrappers via `unwrap-objc-object`.

### `PDFViewPageChangedNotification` observer pattern
NSNotificationCenter observer setup:
1. `PDFViewPageChangedNotification` is generated as `(get-ffi-obj 'PDFViewPageChangedNotification _fw-lib _id)` — a raw `_id`-typed cpointer. The `name` contract is `(or/c string? objc-object? #f)` — raw cpointers rejected. Wrap via `(borrow-objc-object PDFViewPageChangedNotification)` — the constant's lifetime is tied to the dylib, so no retain/release is needed.
2. The observer is a `make-delegate` with a handler (selector can be any valid ObjC identifier ending in `:`) and `#:param-types (hash "pageChanged:" '(object))` so the NSNotification arg arrives as an `objc-object?` wrapper.
3. Keep the `make-delegate` result in a module-level variable — Cocoa holds observers weakly; a GC'd observer silently stops firing.

### Grep source before filing relocated backlog tasks
Tasks relocated from another target plan may already be fixed in the same commit wave that prompted the relocation. Always grep the relevant source files before writing a new backlog entry for a relocated task.

### Sample app registration in runtime load harness
Apps are listed in `APPS` in `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`, distinct from the `bundle-racket-oo` integration test which auto-discovers. Adding a new app requires: (1) append to `APPS`; (2) append to `REQUIRED_FRAMEWORKS` if the app imports a framework not already in the hermetic tree. All 9 sample apps are exercised via `raco make` under the harness (~90s for the full run).

### Two-stage signing required for app bundles
Sign the stub binary before copying `Resources/` (first pass), then re-sign the full bundle after `Resources/` is populated (second pass). A single post-copy sign produces an inconsistent bundle that Gatekeeper rejects. `stub-launcher`'s `codesign.rs` implements both passes via `codesign --force --sign`.

### `plist` crate skips round-trip for empty overrides
`plist::to_file_xml` output is not byte-identical to Apple's `PlistBuddy`. `merge_info_plist_overrides` in `bundle-racket-oo` skips the read-modify-write cycle entirely when `info_plist_overrides` is empty to avoid spurious diffs.

### Accessibility set-value fails for NSStackView-hosted textfields
The TestAnyware accessibility agent's set-value path cannot reach textfields nested inside `NSStackView` containers. VNC keyboard input is the correct path for address-bar interaction tests. Concrete symptoms on Tahoe: `set-value --role textfield --window ...` returns `Multiple elements matched`; retrying with `--index 0` returns `No element found matching query`. Use `input click` (screen-absolute coords, triple-click for select-all) followed by `input type` + `input key return`.

### `testanyware input click --window` coord offset on Tahoe
The `--window <name>` flag on `testanyware input click` translates window-relative coords via the AX-reported window origin, which includes the window's drop-shadow inset. On Tahoe this produces VNC click coords roughly 40 px below the intended target. Use screen-absolute VNC coords derived from a full-screen screenshot, not `--window`-relative.

### Triple-click focuses and selects NSStackView-hosted NSTextField
A single VNC click at the center of an NSStackView-hosted NSTextField does NOT always grant first-responder. Triple-click at the same coords reliably focuses AND selects the field contents. Subsequent `input type` replaces the selection. Pattern for URL-bar-style interaction:
  1. `input click --count 3 <screen-x> <screen-y>`
  2. `input type "<new value>"`
  3. `input key return`
No Cmd+A step needed.

### Orphan tart VMs have no recoverable VNC password
`tart run --vnc-experimental` generates a random VNC password printed once to stdout. If the VM was started outside `scripts/macos/vm-start.sh`, the password is lost when the starting shell closes — it is not in `~/.tart/vms/<id>/config.json`. Recovery: `tart stop <id>` and restart via `bash scripts/macos/vm-start.sh --id <id>`, which re-clones from the golden image (any installed tooling inside the clone is lost and must be reinstalled).

### Detached install pattern under agent exec
Long-running installs (`brew install minimal-racket`, ~5 min on Tahoe) should be launched via `nohup ... > /tmp/x.log 2>&1 &` through `testanyware exec`, then polled for completion. If the command is NOT detached, the spawning shell ends with the HTTP call and the child is killed. Poll via `until $TA_BIN exec --vm $ID "test -x /path/to/binary" 2>/dev/null | grep -q DONE; do sleep 15; done` from the host.

### `scan_rkt_string_literals` skips `;`-to-EOL comments
`scan_rkt_string_literals` in `bundle-racket-oo/src/deps.rs` must skip `;`-to-EOL comments in its state machine. Without this, string literals embedded in doc-comments (e.g. the path `".../runtime/objc-interop.rkt"` appearing in `objc-interop.rkt`'s own header comment) are treated as broken require targets. Two regression tests guard this invariant.

### NSSavePanel completion block uses `(Int64 -> Void)` signature
`NSSavePanel beginSheetModalForWindow:completionHandler:` expects a block typed `(Int64 -> Void)`. Pass via `make-objc-block`; the completion receives `NSModalResponseOK` (1) or `NSModalResponseCancel` (0) as the `Int64` arg. Same pattern works for any modal completion handler whose response is an `NSModalResponse` enum.

### `racket-oo` generated files use no Racket class system
Every file under `generation/targets/racket-oo/` uses `#lang racket/base`. Zero occurrences of `class*`, `define/public`, `inherit`, or `interface` forms. "OO" is a conventional target name, not a technical description of the emitted code.

### ObjC inheritance is flattened at emit time
`effective_methods()` merges the full superclass method set at emit time. The emitted API is flat procedural — no Racket class hierarchy is encoded. Inheritance is a collection-time concern, not a runtime one.

### Protocols emit delegate factories, not interface forms
Protocol files generate `make-<proto>` delegate factory functions — thin wrappers over `make-delegate` that pre-fill both the handler hash and the `#:param-types` hash from protocol IR. No Racket `interface`, `mixin`, or `class*` forms are used. The friction in the target is FFI-shaped, not OO-shaped.

### `make-dynamic-subclass` is the only genuine OO mechanism
All ObjC subclassing goes through `dynamic-class.rkt`'s `make-dynamic-subclass`. It is the single use case in the target that resembles class-based OO — everything else is flat message-passing. See "`dynamic-class.rkt` exports libobjc subclass surface".

### `objc-subclass` macro is the ObjC subclassing surface
`runtime/objc-subclass.rkt` implements Option B: `define-objc-subclass` layered over `make-dynamic-subclass`. Eliminates manual IMP/fptr assembly, GC pinning, and superclass encoding lookup. The `(self SEL)` prefix is handled automatically; user lambdas receive args without SEL. IMPs are pinned module-level against GC. Use `#:arg-types`/`#:ret-type` for unsupported struct/union/bitfield types. Constructor synthesis (`make-<class>`) is deliberately absent — inferring inherited init FFI signatures at expansion time would drift per superclass. `drawing-canvas.rkt` is the canonical consumer. Design rationale in `docs/specs/2026-04-19-racket-oo-class-system-analysis.md`.

### ObjC encoding strings interleave stack-offset digits
Stack-offset digits appear between type tokens in ObjC encoding strings (e.g. `q8@0:4`). The parser in `objc-subclass.rkt` must skip numeric characters explicitly between tokens. Struct and union tokens (`{...}` / `(...)`) require balanced-delimiter parsing, not simple character dispatch — e.g. `{CGRect={CGPoint=dd}{CGSize=dd}}` nests arbitrarily deep.

### `syntax-parse` `~?` for optional keyword macro syntax
`~?` in `syntax-parse` pattern templates collapses an absent keyword clause to a sentinel value without nested `if`. Used in `define-objc-subclass` for `#:arg-types`/`#:ret-type` optional keywords — the preferred approach for optional keyword syntax in macros.

### Default constructor `make-<class>` synthesized for init-less classes
The emitter synthesizes `(define (make-<class>) (wrap-objc-object (tell (tell <Class> alloc) init) #:retained #t))` for any class whose IR lacks an explicit init beyond bare `init`. Covers ~73% of all generated classes (5,304 total: 54% no init at all, 19% bare-init-only). Suppressed when at least one explicit init exists (e.g. NSWindow keeps only `make-nswindow-init-with-content-rect-...`). The synthesis trigger lives in `has_explicit_constructor` in `emit_class.rs` and mirrors the long-standing emit-time skip on `m.selector == "init"`. Examples that previously required the `objc-interop.rkt` escape hatch and now have a direct constructor: NSAlert, NSColorPanel, NSStackView, NSSavePanel, NSOpenPanel, NSFileManager.
