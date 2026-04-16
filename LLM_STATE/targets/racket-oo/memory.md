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

Note: dylib-unexported symbols (header-declared but absent from the live dylib) are a separate concern — see "Header-declared ≠ dylib-exported" and "Emit-time filter for dylib-unexported symbols".

### EnumDecl forward-decl shadows definition via `seen` guard
The `seen_enums` HashSet dedup guard in `extract_declarations.rs` checks by name only. For `CF_ENUM`/`NS_ENUM`-generated cursors, libclang emits both a forward `EnumDecl` (no values) and a defining `EnumDecl` (with values); if the forward decl is visited first it wins the seen-set and the definition is skipped. Fix: add `entity.is_definition()` check in the `EnumDecl` arm before inserting. The same latent bug exists in `StructDecl`, `ObjCInterfaceDecl`, and `ObjCProtocolDecl` arms — not yet confirmed to bite in practice, but worth auditing if those cursor types gain seen-set guards.

### Unsigned enum extraction requires canonical type check
`is_unsigned_int_kind` in `extract_declarations.rs` must canonicalize via `get_canonical_type()` before checking the underlying enum type. Without this, `NS_ENUM(NSUInteger, ...)` presents as `Typedef` kind and misses the unsigned branch. Clang's `get_enum_constant_value()` returns `(i64, u64)` — use `.1` (unsigned) for unsigned-backed enums. Values exceeding `i64::MAX` are skipped with `tracing::warn!` rather than wrapped silently (the IR schema is i64; silent wrapping would corrupt value semantics). Pipeline regeneration is required to propagate this to generated output.

### libclang canonicalises symlinked subframeworks to top-level path
ColorSync, CoreGraphics, CoreText, and ImageIO live under `ApplicationServices.framework` as symlinks, but libclang resolves their declarations to the canonical top-level framework paths (`System/Library/Frameworks/CoreGraphics.framework/...`). Only genuinely non-symlinked subframeworks (HIServices, ATS, PrintCore) need an allowlist entry in `is_from_framework`. The symlinked ones are already accepted via their own top-level entries.

### Subframework allowlist in `sdk.rs`
`SUBFRAMEWORK_ALLOWLIST = &["ApplicationServices"]` in `sdk.rs`'s `is_from_framework` accepts header paths under that framework containing `/Headers/`. Quartz is excluded: the `clang-2.0.0` crate panics on a UTF-8 error when visiting a Quartz subframework path during a full collect run. Expanding to Carbon/CoreServices requires fixing that panic first.

### Synthetic pseudo-framework: structure and emitter hookup
For system headers outside the `.framework` tree (e.g. libdispatch, pthread): checked-in umbrella header at `collection/crates/extract-objc/synthetic-frameworks/<name>/<name>.h`; `sdk.rs` appends a synthetic `FrameworkInfo` via `synthetic_frameworks()`; `is_from_framework` branches on the synthetic name to accept the relevant `usr/include/` paths. Emitter hookup: `framework_ffi_lib_arg` in `shared_signatures.rs` maps the synthetic framework name to the actual dylib short name. No other emitter changes needed.

### libdispatch ffi-lib must be `"libSystem"`
The `libdispatch` short name does not resolve via dyld's shared cache on macOS even though the symbols exist. Dispatch symbols are re-exported from `libSystem`. `framework_ffi_lib_arg` in `shared_signatures.rs` maps `libdispatch → "libSystem"`.

### Header-declared ≠ dylib-exported on macOS
Some symbols present in SDK headers do not exist in the live dylib shared cache. Snapshot tests cannot detect this; only the runtime load harness can. When adding new framework coverage, always run the harness before declaring victory.

### Emit-time filter for dylib-unexported symbols
Header-declared symbols absent from the live dylib are filtered at emit time, not at collection time — collection-time filtering would require a Rust `dlopen`/`dlsym` probe per symbol. The emit-time filter (`is_libdispatch_unexported` in `shared_signatures.rs`) is a single grep-able location for "what did we omit and why". Libdispatch known-missing: `dispatch_cancel`, `dispatch_notify`, `dispatch_testcancel`, `dispatch_wait`, `pthread_jit_write_with_callback_np`.

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
- `runtime_load_libraries_via_dynamic_require` — library checks via single racket script collecting all failures
- `runtime_load_apps_via_raco_make` — `raco make` over all sample apps

Gated on `RUNTIME_LOAD_TEST=1`, auto-skips if `racket`/`raco` missing or enriched IR absent. ~40s on M1. Builds a hermetic tempdir matching the canonical target tree so it doesn't race the `compiled/` cache.

**Standing rule**: coverage extension to a new framework is reflexive — add it whenever a new `LIBRARY_LOAD_CHECKS` candidate appears, not gated on runtime cost. Amortised Racket startup means adding several new frameworks costs well under 1s on top of the base. Extensions have uncovered orthogonal leak classes (see "Non-linkable-symbol filters in extractors"). New runtime files (e.g. `dynamic-class.rkt`) must be added to both `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS`.

### `dynamic-require` needs `(file ,path)`
The harness uses `(dynamic-require \`(file ,p) #f)`, not `(dynamic-require p #f)`. A raw path string trips a `module-path?` contract violation. The `(file ...)` quasi-form wraps absolute filesystem paths.

### `raco` has no `--version` flag
`raco --version` exits non-zero. The reliable probe is `raco help`. The harness uses `binary_on_path("racket", "--version")` and `binary_on_path("raco", "help")`.

### Contract-based API boundaries
Every FFI boundary uses `provide/contract`. Three contract mappers:
- `map_contract` in `emit_functions.rs` (value/function): primitives → `real?`/`exact-integer?`/`exact-nonnegative-integer?`/`boolean?`, objects → `cpointer?` or `(or/c cpointer? #f)` for nullable, geometry structs → `any/c`, void → `void?`. Reused by functions, constants, and class wrappers. Note: `exact-nonneg-integer?` is not a Racket predicate — fails only at load time.
- `map_param_contract` in `emit_class.rs` (class wrapper params): `Id`/`Class`/`Instancetype` → nullable-aware union mirroring `coerce-arg`'s accepted set (non-nullable: 3-element, nullable: 4-element with `#f`), `(or/c procedure? #f)` for blocks, delegates to `map_contract` for primitives. `type_ref.nullable` selects the variant.
- `map_return_contract` in `emit_class.rs` (class wrapper returns): `any/c` for objects, delegates to `map_contract` for void/primitives.
Protocol files use fixed contracts (see "Protocol file contract shape is fixed").

### Class wrapper self uses `objc-object?`, params use typed unions
Self uses `SELF_CONTRACT` (`"objc-object?"`) in `emit_class.rs` for instance methods and instance property getters/setters.
- **Self** is always a wrapped instance — rejecting non-`objc-object` values catches misuse with caller blame instead of segfaulting in `objc_msgSend`.
- **Object params** (`Id`/`Class`/`Instancetype`) use a nullable-aware union matching `coerce-arg`'s accepted set. `type_ref.nullable` selects between 3-element (non-nullable) and 4-element (includes `#f`) variants. Errors surface at the wrapper with caller blame, not deep in `coerce-arg`.
- **Object returns** stay `any/c` via `map_return_contract`. Class-specific return predicates are a queued follow-up.
`objc-object?` is in scope via the require chain: `coerce.rkt` re-exports from `runtime/objc-base.rkt`. Class-property methods omit `self` (see "Class-property methods omit `self`").

### Delegate callback sender args need `wrap-objc-object`, not bare cast
`objc-object?` is a **struct predicate** (`struct objc-object` in `objc-base.rkt`), NOT a cpointer tag check. `(cast ptr _pointer _id)` tags the pointer for FFI but does NOT create an `objc-object` struct — it fails the `objc-object?` contract. When delegate trampoline args (e.g. target-action `sender`) must flow through a class wrapper's `provide/contract` boundary, the correct pattern is:

    (wrapper-fn (wrap-objc-object (cast sender _pointer _id)) args...)

Default `#:retained #f` adds a balanced retain/release pair, safe for borrowed refs. Do NOT use `tell` as a bypass for non-object parameters (int, bool, SEL) — `tell` types all params as `_id` and rejects integers with `id->C: argument is not 'id' pointer`.

File Lister's `(cast col _pointer _id)` works only because it feeds into `tell` directly, never through a `provide/contract` boundary. If the value ever flows through a wrapper, it will need `wrap-objc-object` too.

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
- GUIVisionVMDriver agent `exec` can wedge after first use — SSH is the reliable fallback

### Snapshot testing infrastructure
`load_enriched_framework(name)` in `snapshot_test.rs` generalizes framework loading — adding a new framework is a file list and test function. AppKit suite has 23 curated golden files covering key class hierarchies (NSResponder→NSView→NSControl→NSButton, NSWindow, table view, menus, text, layout). Rich classes like NSButton and NSWindow exercise more typed message send variants and geometry struct handling than Foundation classes.

### Block nil handling convention
`make-objc-block` returns `(values #f #f)` when `proc` is `#f` (NULL block pointer + no block-id), rather than wrapping `#f` in a crashing lambda. `free-objc-block` handles `#f` gracefully.

**Confirmed bug (Modaliser-Racket, 2026-04-16):** If the `#f` guard is not in place (or is bypassed), passing `#f` to `make-objc-block` creates a live block object that calls `(apply #f args...)` on invocation — a non-obvious crash deferred to call time. The fix (`(values #f #f)` guard) must be verified for optional completion-handler parameters specifically, not only the primary proc path. Workaround until confirmed: pass a no-op lambda `(lambda args (void))` instead of `#f` for optional completion handlers.

### `function-ptr` satisfies `(or/c cpointer? #f)` contract
Confirmed 2026-04-16 (Modaliser-Racket `ffi/cgevent.rkt` migration): a `function-ptr` constructed from `_cprocedure` satisfies the `(or/c cpointer? #f)` contract that the racket-oo generator emits for C callback parameters. Demonstrated end-to-end with `CGEventTapCreate`'s callback param. No raw-symbol fallback is needed for callback params in generated bindings — the generated contract path works as-is.

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

### `_cprocedure` callbacks unsafe from foreign OS threads
Racket CS SIGILLs (exit 132) when a `_cprocedure` callback is invoked from an OS thread not registered with the Racket VM (e.g., GCD worker pool threads from libdispatch). `#:async-apply` converts the crash to a deadlock under `nsapplication-run` because the async-apply queue drains on the main Racket thread, which is stuck in the Cocoa run loop. The CGEvent tap callback is NOT a counterexample — it fires on the main OS thread via `CFRunLoopGetMain`, not on a foreign thread. Implication for generated bindings: any binding exposing a C callback type should document this constraint and warn against installing the callback on a non-main GCD queue or libdispatch worker.

### `call-in-os-thread` safe for pure Racket/file-I/O only
`ffi/unsafe/os-thread` (`call-in-os-thread`) works for closures, list/hash ops, `parameterize`, file I/O (`open-input-file`, etc.). Segfaults on `tcp-connect`, `subprocess`/`system`, and anything using Racket's place scheduler I/O event pump. `net/url` uses TCP, transitively unsafe. Useful for CPU-bound work (fuzzy matching, serialization).

### `dynamic-place` for I/O off the main thread
Each `dynamic-place` is a separate Racket VM on its own OS thread with its own scheduler. `net/url`, `tcp-connect`, `subprocess` all work correctly. Place-channel semantics: `place-channel-put` is fully buffered (non-blocking sender), `place-channel-get` blocks (fatal on main thread under `nsapplication-run`), `sync/timeout 0` on a place-channel is a non-blocking try-receive (empirically scheduler-independent — the only `sync`-family form safe under `nsapplication-run`). The "place-backed async facade with main-thread polling tick" pattern (Modaliser `services/http.rkt`) generalizes: place does I/O, main thread polls via `place-channel-try-get` on a `call-on-main-thread-after` timer. Main thread never blocks.

### macOS widget quirks (Racket apps)
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
- NSScrollView `dy=+50` scrolls toward top (toward Cocoa unflipped origin) — opposite of natural scrolling mental model

### `only-in` for generated `functions.rkt`/`constants.rkt` subsets
Use `only-in` rather than wholesale `require` when consuming a subset of generated bindings:

    (only-in "../bindings/generated/oo/coregraphics/functions.rkt"
             CGEventSourceCreate CGEventCreateKeyboardEvent ...)
    (only-in "../bindings/generated/oo/corefoundation/functions.rkt" CFRelease)
    (only-in "../bindings/generated/oo/corefoundation/constants.rkt" kCFRunLoopCommonModes)

Documents exactly which generated names the consumer uses; prevents `racket/contract` re-exports from leaking through. Global-variable constants (e.g. `kCFRunLoopCommonModes`) are emitted as `(get-ffi-obj 'name lib _pointer)` and resolve correctly via `dlsym`.

### Sample apps bundle via `bundle-racket-oo` crate
`apianyware-macos-bundle-racket-oo` builds racket-oo `.app` bundles: require-tree BFS for dependency discovery, `Resources/racket-app/<rel>` layout preserving the source tree so relative requires resolve at runtime, optional `lib/libAPIAnywareRacket.dylib` copy. CLI: `cargo run --example bundle_app -p apianyware-macos-bundle-racket-oo -- <script>` or `-- --all`. Built bundles land at `apps/<name>/build/<App Name>.app` (gitignored). Every sample app calls `(install-standard-app-menu! app "<Display>")` from `runtime/app-menu.rkt`.

### `NSProcessInfo setProcessName:` ignored on modern macOS
`setProcessName:` has no effect on the bold app-name slot in the macOS menu bar. `CFBundleName` in `Info.plist` is the only path. `racket script.rkt` direct execution always shows "racket" in the menu bar. Bundling is required for correct app identity, not optional polish.

### New sample app: spec.md only, no test edits
Create `apps/<name>/<name>.rkt` and `knowledge/apps/<name>/spec.md` with `# <Display Name>` as the first heading. `bundle-racket-oo` reads the H1 for the canonical display name — kebab→title conversion produces wrong capitalisation for acronyms (e.g. "Ui Controls Gallery"). The integration test in `bundle-racket-oo` auto-discovers apps via directory walk; no test edits needed for a new app.

### `app-menu.rkt` uses raw typed `objc_msgSend` for SEL params
`tell` fails on selectors with SEL parameters (`id->C: argument is not 'id' pointer`) — Racket SELs are plain `cpointer`, not `_id`-tagged. `addItemWithTitle:action:keyEquivalent:` and `initWithTitle:action:keyEquivalent:` both hit this. `app-menu.rkt` defines explicitly-typed `objc_msgSend` aliases (`_msg-init-with-title-action-key`, `_msg-add-item-with-title-action-key`, ...) and calls them with `sel_registerName` selectors — the same pattern the generated framework bindings use for non-id-parameter methods.

### `as-id` casts both branches to `_id`
`as-id` in `runtime/objc-base.rkt` must `(cast ... _pointer _id)` in both the `objc-object?` and `cpointer?` branches. If the `objc-object?` branch returns the raw pointer instead, callers passing a wrapped object to `tell` get `id->C: argument is not 'id' pointer`.

### Accessibility menu drill-down needs a mouse click
`guivision agent snapshot --window "Menu Bar"` only surfaces the top-level menu items (Apple, app-name). The submenu is not in the accessibility tree until the menu opens. To verify the full menu content, click the menu title via VNC (`guivision input click --connect spec.json X Y`) then `screenshot` the region. The agent's `press --role menu-item --label "Counter"` query returns `No element found matching query` because accessibility doesn't treat menu bar items as directly-pressable in the default snapshot mode.

### GUIVisionVMDriver VNC password recovery
`vm-start.sh --viewer` exports `GUIVISION_VNC_PASSWORD` but the value does NOT survive pipeline subshells (`source ... | tail`) — the sourced env vars only exist in the pipeline-subshell scope. Source the script with output redirected to a file (`source vm-start.sh > /tmp/start.log 2>&1`) so the env ends up in the parent shell. Persist `$GUIVISION_VNC`, `$GUIVISION_VNC_PASSWORD`, and `$GUIVISION_AGENT` to `/tmp/gv_*` files plus a `/tmp/gv_connect.json` connect spec; later `guivision` calls read them via `--connect /tmp/gv_connect.json` for authenticated VNC (screenshot, find-text, input click). The password is generated fresh per `tart run`, so recovery after a lost sourcing requires re-booting the VM.

### Auto-terminating Cocoa-loop test pattern
Tests that must enter `nsapplication-run` (CGEvent tap, delegate reentry, full lifecycle) need a structured exit strategy to avoid hanging the test runner:

1. Inside `applicationDidFinishLaunching:` body, register a **safety-net** first:
   `(call-on-main-thread-after 5.0 (lambda () (eprintf "safety net: test timed out\n") (exit 1)))`
   — fires even if an assertion exception is caught by the delegate's `with-handlers` boundary.
2. Run assertions inside the existing `with-handlers` boundary.
3. Schedule a **normal-path exit**: `(call-on-main-thread-after 0.5 (lambda () ... (exit 0)))`.
4. File ends with `(nsapplication-run app)`.

Outcomes: assertions pass → `(exit 0)` → `[OK]`. Assertion raises (caught by `with-handlers`) → safety net fires → `(exit 1)` → `[FAIL]`. Genuine hang → test runner's `timeout -k 1 30` → `[TIMEOUT]`. The safety-net timeout (5 s) must be longer than the normal-path delay (0.5 s).

### ObjC type encoding `q` is NSInteger on 64-bit
NSInteger is `typedef long NSInteger` on 64-bit Apple platforms; clang encodes `long` as `q` (not `l`). Delegate trampoline mapping: `'long → "q"` in both Swift `typeEncoding` and Racket `return-kind->string`. No separate `'nsinteger` kind is needed. This is the correct encoding for `numberOfRowsInTableView:` and other NSInteger-returning delegate methods.

### Delegate return kinds `'int` and `'long` supported
DelegateBridge.swift defines `impInt0..3` (returning `Int32`) and `impLong0..3` (returning `Int64`). `selectIMP` and `typeEncoding` extended with `("int", N)` / `("long", N)` cases. `delegate.rkt` mirrors in `return-kind->string`, `make-delegate/swift`, `make-delegate/racket`, `delegate-set!`, plus `type-encoding-int` / `type-encoding-long` helpers. `'long` is the correct kind for NSInteger-returning delegate methods on 64-bit Apple platforms (see "ObjC type encoding `q` is NSInteger on 64-bit").

### `dynamic-class.rkt` exports libobjc subclass surface
`generation/targets/racket-oo/runtime/dynamic-class.rkt` exports: `objc-get-class`, `allocate-subclass`, `add-method!`, `register-subclass!`, `get-instance-method`, `method-type-encoding`, and `make-dynamic-subclass` (chains allocate→add-method→register in the correct order). Type aliases `_Class`/`_SEL`/`_Method`/`_IMP` exported for raw-msgSend consumers. Must be added to both `RUNTIME_FILES` and `LIBRARY_LOAD_CHECKS` in the harness.

### libdispatch `_id` params emitted as `_pointer`
`dispatch_queue_t`, `dispatch_group_t`, etc. resolve to `id` in the IR (under `OS_OBJECT_USE_OBJC=1`), but no wrapper classes exist in the generated bindings. The emitter maps `_id` → `_pointer` in libdispatch's `functions.rkt` so consumers can pass raw cpointers (from `ffi-obj-ref`, `dlsym`, etc.) without a `(cast ... _pointer _id)` ceremony. The ABI is identical. This override is scoped to `framework == "libdispatch"` in `generate_functions_file`. Non-libdispatch frameworks keep `_id`. If future frameworks gain the same OS-object pattern (e.g. `xpc_object_t`), extend the same override.

### Struct-typed global constants use `ffi-obj-ref`
Constants whose IR type is `TypeRefKind::Struct` (e.g. `_dispatch_main_q`, `_dispatch_source_type_*`) are emitted as `(define sym (ffi-obj-ref 'sym lib))` — returning the symbol's address. Non-struct constants keep `(get-ffi-obj 'sym lib type)` — dereferencing the symbol. The distinction is in `generate_constants_file` via `is_struct_data_symbol()`. Contract for struct globals is `cpointer?`.

### `make-dynamic-subclass` guards against duplicate registration
`objc_allocateClassPair` returns NULL for a name already registered — subsequent `class_addMethod` would crash. `make-dynamic-subclass` guards by returning the existing class via `objc_getClass` first. Required for modules that register a subclass at load time and may be required twice in the same Racket VM.
