# Memory

### Racket OO IR requirements
Enum.enum_type is `TypeRef` (not `String`), EnumValue.value is `i64` (not `String`),
Method has `source`/`provenance`/`doc_refs` fields. These are Racket-specific differences
from the base IR schema.

### Dylib and runtime path conventions
Dylib name: `libAPIAnywareRacket` (referenced only in `swift-helpers.rkt`). Relative
runtime/generated paths depend on the file's depth under the racket-oo target root and
are **not interchangeable**:
- Class files (`generated/oo/<fw>/<class>.rkt`) → `../../../runtime/`
- Protocol files (`generated/oo/<fw>/protocols/<proto>.rkt`) → `../../../../runtime/`
  (one level deeper due to the `protocols/` subdir)
- Apps (`apps/<name>/<name>.rkt`) → `../../runtime/` and `../../generated/oo/`
After any target-root layout refactor, all three categories must be re-validated. Apps
in particular can carry stale prefixes indefinitely because the emitter never touches
them — commit `ec82ff0` flattened the layout and the three subdir apps shipped broken
`../../../` prefixes for an entire session before anyone tried to load them.

### Selector filtering
Swift-style selectors containing `(` must be filtered out — e.g. `init(string:)` can't
be called via `objc_msgSend`. The extractor or emitter must exclude these.

### FFI type coercion rules
- `coerce-arg` must cast `objc-object-ptr` to `_id` via `(cast ptr _pointer _id)` for `tell`
- TypedMsgSend methods expect raw pointers for id-type params, not wrapped `objc-object` structs

### Collection-time type resolution
- Category property deduplication by name required (HashSet filter in `extract_declarations.rs`)
- Typedef aliases must resolve to canonical types at collection time, not downstream —
  object pointer typedefs → `Id`/`Class`, primitive typedefs → `Primitive`

### Non-linkable-symbol filters live in the extractors
Non-linkable symbols (preprocessor macros, internal-linkage decls, Swift-native
identifiers) leak into the IR as if they were C constants or functions —
parsing fine as `get-ffi-obj` calls but blowing up at `dlsym` time with
`could not find export from foreign library`. The filter chain has three
**closed** cases and (as of 2026-04-13) three **known-open** leak classes,
all routed through `non_c_linkable_skip_reason` in the collection crates.

**Closed** (each validated end-to-end by the runtime load harness):

1. **extract-objc internal-linkage filter** — skips C decls with internal
   linkage only (e.g. `NSHashTableCopyIn`).
2. **extract-swift `s:` USR filter** — skips Swift-native identifiers whose
   USR begins with `s:` (e.g. `NSLocalizedString`, `NSNotFound`).
3. **extract-swift `c:@macro@` USR filter** — skips C-preprocessor macros
   surfaced through the Swift digester (e.g. `kCTVersionNumber10_10`).

**Known-open** (discovered 2026-04-13 when a supposedly-trivial coverage
extension from CoreText to its `c:@macro@` siblings AudioToolbox /
NetworkExtension / Network / CoreSpotlight hit four distinct failures):

A. **Bare `c:@<name>` preprocessor macros.** libclang sometimes exposes a
   macro through a naked `c:@<name>` USR without the `@macro@` infix —
   neither extract-objc nor extract-swift catches this shape. Canary:
   `kAudioServicesDetailIntendedSpatialExperience` (AudioToolbox,
   `AudioServices.h:401`, ObjC source).
B. **`c:@Ea@...` anonymous enum members surfaced as standalone constants.**
   Clang's `Ea` USR prefix marks anonymous-enum members; these are being
   extracted as constants. Canary: `nw_browse_result_change_identical`
   (Network, Swift source). The arguable fix is to not emit anonymous-enum
   members as constants at all.
C. **Filtered-then-promoted-back symbols** (most dangerous class). Canaries
   `NEFilterFlowBytesMax` (NetworkExtension) and `CoreSpotlightAPIVersion`
   (CoreSpotlight) **do** appear in `swift.skipped_symbols` in
   `collection/ir/collected/*.json`, yet reappear as live constants in
   `resolved/`, `annotated/`, and `enriched/`. `build_resolved_framework`
   (`analysis/crates/resolve/src/checkpoint.rs`) clones collected and only
   touches classes, so the promotion is upstream of resolve — in the
   extract-swift merge or the collected-JSON write path. The filter is
   working at its own stage; the leak is a serialization/merge regression.

Adding a new non-linkable-symbol class: (a) add a skip-reason branch in
`non_c_linkable_skip_reason`; (b) add a canary framework to the harness's
library coverage. **Harness coverage extension is itself a discovery
mechanism, not insurance** — all four open classes above were surfaced by
a coverage-only task, not by any bug report.

### Framework dylib and `get-ffi-obj` pattern
Both `constants.rkt` and `functions.rkt` load the framework dylib as `_fw-lib` (excluded
from `provide`) and use `get-ffi-obj` for bindings:
- Constants: `(define Name (get-ffi-obj 'Name _fw-lib _type))`
- Functions: `(define Name (get-ffi-obj 'Name _fw-lib (_fun arg-types... -> ret-type)))`
Foundation has 852 constants; CoreGraphics has 777 functions. Geometry struct constants
(`NSZeroPoint`/`NSZeroRect`) map correctly via alias handling in `RacketFfiTypeMapper`.

### `functions.rkt` / `constants.rkt` require block shape
Both files always require `ffi/unsafe`, `ffi/unsafe/objc`, and `racket/contract`
(renamed to dodge the `->` conflict) at the top of the generated file, regardless
of whether any binding in the file actually uses `_id`. Rationale: unconditional is
cheaper than per-binding Id-detection drift and matches the `constants.rkt` pattern
that already existed. `type-mapping.rkt` is the only require that stays **conditional**
— emitted only when `any_struct_type` (in `shared_signatures.rs`) returns true for the
file's functions or constants — because it pulls in geometry cstructs that would be
wasted work for files that don't touch them. Forgetting `ffi/unsafe/objc` here is
invisible until a file with an `_id`-typed binding is loaded — snapshot tests won't
catch it.

### Framework subsets: `functions.rkt` vs class emission
"86 frameworks" is the count that have **emittable C functions** (non-variadic,
non-inline) — it is NOT the class emission set. Class emission covers **all 283
frameworks**. WebKit is in the 283 but not in the 86 (no C functions), which is a common
source of confusion when cross-referencing log lines.

### `->` name conflict: `ffi/unsafe` vs `racket/contract`
Any file that requires both `ffi/unsafe` (for `_fun ... -> ...`) and `racket/contract`
(for `(-> ...)` contract arrows) gets a hard identifier conflict: both export `->` with
different semantics, and Racket rejects the file at load time with "identifier already
required". The mandatory form used by every emitted file that needs contracts is:

    (require ffi/unsafe
             (rename-in racket/contract [-> c->]))

and contract arrows are written `(c-> arg-contract ... ret-contract)`. This applies to
`functions.rkt`, `constants.rkt`, every class wrapper, and anywhere else the emitter
pulls in `racket/contract`. Protocol files currently use `->*` so they dodge the
conflict, but a `rename-in` is still safe to use prophylactically.

### `runtime/type-mapping.rkt` must `provide` every cstruct it defines
Every `define-cstruct` in `runtime/type-mapping.rkt` must appear in its `(provide ...)`
list or downstream emitted files that reference the type fail to load with an unbound
identifier error. Current set that must stay exported: `_NSPoint`, `_NSSize`, `_NSRect`,
`_NSRange`, `_CGPoint`, `_CGSize`, `_CGRect`, `_NSEdgeInsets`,
`_NSDirectionalEdgeInsets`, `_NSAffineTransformStruct`, `_CGAffineTransform`,
`_CGVector`. Adding a new geometry struct means: (1) `define-cstruct`, (2) add to
provide, (3) add to the `is_known_geometry_struct` allowlist in
`emit/src/ffi_type_mapping.rs`. Struct detection at the emit-site level now goes
through a single `any_struct_type(type_refs, mapper)` helper in
`shared_signatures.rs`, used by `class_has_struct_types` (class wrappers),
`generate_functions_file` (`emit_functions.rs`), and `generate_constants_file`
(`emit_constants.rs`). Each caller builds its own type-ref iterator but delegates
the "is any of these a geometry struct?" decision to `any_struct_type`, which in
turn defers to the FFI mapper's allowlist. Adding a struct is therefore a
one-allowlist-edit operation — the earlier "three-site coupling" hazard was
boilerplate rather than decision drift, and is now closed.

### Runtime loading is the real acceptance test (and failures cascade)
Text-level snapshot tests are necessary but insufficient for this emitter. The
`provide/contract` migration (functions, constants, classes, protocols) landed green
with every snapshot passing while *no emitted file actually loaded in Racket*. Worse,
load-time failures **cascade**: fixing one missing require just lets the loader reach
the next missing require, and the same symptom (`unbound identifier`) can mask several
orthogonal bugs in sequence. In total the migration + type-mapping fix uncovered, in
order: (1) `->` require conflict, (2) `exact-nonneg-integer?` typo, (3) missing cstruct
provides, (4) missing `type-mapping.rkt` require in functions/constants, (5) missing
`ffi/unsafe/objc` require in functions, (6) non-linkable-symbol leaks from the
extractors (three filter classes — see separate entry). Bug (6) is orthogonal to the
others and only became visible after (4) landed. This cascade is the canonical
illustration of why text-level snapshot parity is not enough. The standing rule and
the implementation live in the "Runtime load verification harness" entry below.

**The harness has its own gap, though**: it only catches *observable* failures. A
calling-convention mismatch where the FFI binding type disagrees with the IR return
type (e.g. a void method bound as `-> _id`) is silently benign on M1 arm64 — the
return register garbage is read, then immediately discarded by an outer wrapper or
ignored — so neither snapshots nor the harness detect it. This class is only catchable
by **static audits** that walk every emit site and cross-reference the FFI dispatch
type against the IR's `return_type`. The void-returning `tell` audit (see "Match
`tell` `#:type` to the IR return type") is the canonical example. When auditing a new
emitter dimension, default to: text snapshot for shape, runtime load harness for "does
it load and link", static cross-reference for "does the FFI binding type agree with
the IR". All three layers are required; none is sufficient alone.

### App verification uses `raco make`, not `dynamic-require`
For emitted **library** files (class wrappers, protocols, `functions.rkt`,
`constants.rkt`), `dynamic-require` is the right acceptance check — they have no
side-effectful top level. For **apps** under `apps/<name>/<name>.rkt` it is wrong:
app top-levels call `nsapplication-run`, so `dynamic-require` opens a window and
blocks the test. Use `raco make apps/<name>/<name>.rkt` instead. It compiles the
target module and its full require graph (runtime + generated/oo/... + any extra
frameworks) without instantiating the body, which is exactly "do the imports resolve
and do the imported modules compile?". That is the right signal for a path-only or
require-graph fix; GUI-level verification is a separate concern that belongs to the
TestAnyware VM workflow.

### Gitignored `generated/` hides source-fixed-but-output-stale state
`generation/targets/racket-oo/generated/` is gitignored. A fix committed to the Rust
emitter does not propagate to disk until `cargo run --bin apianyware-macos-generate` is
re-run, so bugs already fixed in source can appear live in the working tree for as long
as the old output sits there. When verifying any emitter change, regenerate before
running `racket -e '(dynamic-require ...)'`, and when triaging a "bug" in generated
output check whether the source has a fix that just hasn't been regenerated. The same
trap exists one stage upstream: `analysis/ir/enriched/` is also gitignored, so
extract-objc / extract-swift fixes do not reach the emitter input until
`cargo run --bin apianyware-macos-collect` and `cargo run --bin apianyware-macos-analyze`
are re-run. The runtime load harness is the canonical regenerate-or-fail signal for
this class — a failing harness with the relevant fix already committed to source
means "regenerate", not "rewrite the fix".

### Runtime load verification harness
Lives at `generation/crates/emit-racket-oo/tests/runtime_load_test.rs`. Two tests:
`runtime_load_libraries_via_dynamic_require` (6 library checks via single racket
script that collects every failure rather than fail-fast) and
`runtime_load_apps_via_raco_make` (single `raco make` over all 3 sample apps).
Both gated on `RUNTIME_LOAD_TEST=1` (matches `UPDATE_GOLDEN=1` opt-in pattern) and
auto-skip if `racket`/`raco` are missing or enriched IR is absent. Total runtime
~47s on M1 (11s libraries, 36s apps). Builds a hermetic tempdir matching the
canonical target tree (`runtime/`, `lib/`, `generated/oo/<fw>/`, `apps/<name>/`)
so the test does not race the canonical `compiled/` cache and can run alongside
snapshot tests in parallel. Library coverage picks one example per dimension:
class wrapper (`../../../runtime/`), protocol file (`../../../../runtime/`),
Foundation `constants.rkt`+`functions.rkt` (extract-objc internal-linkage filter +
extract-swift `s:` filter), CoreGraphics `functions.rkt` (geometry structs +
largest `s:` blast radius), CoreText `constants.rkt` (`c:@macro@` filter canary).
**Standing rule**: any new FFI surface added to the emitter gets a runtime load
check alongside its snapshot assertion, not instead of it. Snapshot tests verify
the text; the harness verifies the load. The `provide/contract` migration cascade
of six load-time bugs is the canonical illustration of why both are required.

**Corollary — coverage extension is itself a discovery mechanism.** Extending
harness coverage to a new "obviously-equivalent" framework is not insurance;
it is a test. The 2026-04-13 attempt to extend the `c:@macro@` canary from
CoreText to its four siblings uncovered three orthogonal leak classes (see
"Non-linkable-symbol filters live in the extractors" → known-open A/B/C),
none of which were on any task list. If a coverage extension fails, assume
it has found a real bug before you assume the harness needs fixing.

### `dynamic-require` needs `(file ,path)`, not a raw string
The harness uses `(dynamic-require \`(file ,p) #f)` not `(dynamic-require p #f)`.
Passing an absolute path string trips a `module-path?` contract violation —
`dynamic-require` accepts module-path forms (symbol, list, `(file ...)`,
`(submod ...)`, etc.), not raw strings. The `(file ...)` quasi-form is the
right wrapper for an absolute filesystem path. Easy mistake to make when
shelling out from Rust where path-as-string is the natural representation.

### `raco` has no `--version` flag
`raco --version` exits non-zero with "unrecognized argument" while `racket
--version` works as expected. The reliable existence probe for `raco` is
`raco help`, which prints usage and exits 0. The runtime load harness uses
`binary_on_path("racket", "--version")` and `binary_on_path("raco", "help")`
respectively for skip detection.

### Contract-based API boundaries
Every FFI boundary in the racket-oo emitter is contract-protected: `functions.rkt`,
`constants.rkt`, class wrappers, and protocol files all use `provide/contract`. Three
contract mappers live in `emit_functions.rs` and are reused by functions, constants,
and class wrappers:
- `map_contract` (value/function context): primitives → `real?`/`exact-integer?`/
  `exact-nonnegative-integer?`/`boolean?`, objects → `cpointer?` or
  `(or/c cpointer? #f)` for nullable, geometry structs → `any/c`, void → `void?`.
  Note the full word `exact-nonnegative-integer?` — `exact-nonneg-integer?` is not
  a Racket predicate and fails only at load time, not in the snapshot suite.
- `map_param_contract` (class wrapper params): `any/c` for object params (see next
  entry), `(or/c procedure? #f)` for blocks, delegates to `map_contract` for primitives
- `map_return_contract` (class wrapper returns): `any/c` for object returns, delegates
  to `map_contract` for void/primitives
Protocol files use fixed contracts (see separate entry) and do not need the mappers.

### Class wrapper contracts: `objc-object?` for self, `any/c` for other object positions
Self parameter uses the `SELF_CONTRACT` constant (`"objc-object?"`) in
`emit_class.rs` — routed through instance methods, instance property getters, and
instance property setters. Object params and object returns remain `any/c`. The
split is deliberate:
- **Self is always an instance that has already been wrapped** — by the time
  control reaches the wrapper, `self` has passed through a constructor or another
  wrapper, so it is expected to be an `objc-object` struct. Rejecting anything
  else catches the most common misuse (passing a string, number, `#f`, or stale
  cpointer) with blame on the caller, instead of segfaulting or PAC-trapping
  inside `objc_msgSend`.
- **Object params/returns stay `any/c`** because `coerce-arg` accepts strings,
  `objc-object` structs, and raw pointers, and `wrap-objc-object` returns are
  opaque — a strict `cpointer?` would break the auto-coercion ergonomics that
  make wrappers usable.
`objc-object?` is already in scope in every emitted class wrapper via the
existing require chain: `coerce.rkt` re-exports it from `runtime/objc-base.rkt`.
No runtime-side change was needed to tighten self. When extending contracts to
new wrapper-style emitters, apply the same split: strict `objc-object?` for
self, strict contracts for primitives and blocks, `any/c` for other object
positions.

Tightening **object params** (nullable vs non-nullable, via
`map_param_contract` consulting `type_ref.nullable`) and **class-specific
predicates** are still queued as follow-ups — they would shift every
object-typed param across the entire snapshot suite and so want a dedicated
regeneration pass.

### Match `tell` `#:type` to the IR return type
Racket's `tell` macro defaults to `#:type _id`, so a bare `(tell target selector args)`
against a void-returning ObjC method binds the underlying `objc_msgSend` as
`(_fun ... -> _id)` and reads whatever happens to be in the return register as a tagged
pointer. This is benign on M1 arm64 (no PAC) but undefined on arm64e, and it is just
wrong as a contract about the binding. Wrapping the call in `(void (tell ...))` only
satisfies the Racket-side `void?` contract on the wrapper — it does **nothing** to fix
the underlying type mismatch.

Correct emission for void return:

    (tell #:type _void target args)

The outer `(void ...)` wrapper is then redundant: a `_void`-typed `tell` already
evaluates to `(void)`. The same rule applies to property setters whose value type is
`Id`-shaped — they are still `_void`-returning methods. (TypedMsgSend dispatch already
gets this right because it derives the FFI return type from
`mapper.map_type(&method.return_type, true)`.) The two emit sites in `emit_class.rs`
that need the explicit `#:type` annotation are the `_id`-typed property setter
(`emit_property`) and the Tell-dispatch void-method body (`emit_method`, `ret_is_void`
branch). Test pattern: assert both the presence of `tell #:type _void` AND the absence
of `(void (tell` in the emitted output, so any regression to the old wrapper form is
caught at the snapshot layer.

### Contract export plumbing in class wrappers
`build_export_contracts` in `emit_class.rs` pre-computes `(name, contract)` pairs for
constructors, properties (getters + setters), instance methods, and class methods, then
emits a single `provide/contract` form. This replaces the older
`(provide (except-out (all-defined-out) ...))` pattern. When adding a new exported
binding to a class, add it to `build_export_contracts` so it gets a contract — otherwise
it won't be provided at all.

### Protocol file contract shape is fixed
Protocol files export exactly two bindings with fixed contracts:
- `make-<proto>` — variadic constructor, contract
  `(->* () () #:rest (listof (or/c string? procedure?)) any/c)`
- `<proto>-selectors` — string list, contract `(listof string?)`
No per-method contract surface exists because delegate method handlers are user-supplied
lambdas passed into `make-<proto>`, not emitted bindings. This is why the contract
mappers from `emit_functions.rs` aren't reused here — the protocol surface is narrow
and fixed, and any prior suggesting "reuse the mappers for protocols" is misleading.
Constants `MAKE_DELEGATE_CONTRACT` and `SELECTOR_LIST_CONTRACT` in `emit_protocol.rs`
hold the two contract strings.

### Racket `provide/contract` rest-arg limitation
`provide/contract` cannot express positional alternation inside `#:rest` —
`(listof (or/c string? procedure?))` catches "you passed a symbol or number" but cannot
enforce the string/procedure pairing that `make-<proto>` actually requires. Stronger
enforcement needs a dependent contract combinator, which is out of scope for emission.
This matters if you're tempted to strengthen any variadic contract in the emitter.

### Function emission filtering
Variadic functions and inline functions are skipped during emission — they can't be bound
via `get-ffi-obj` (variadic needs special calling conventions; inline has no symbol).
TestKit includes both types specifically to verify they're excluded.

### VM and testing workflow
- VirtioFS shared filesystem can serve stale files — use base64 transfer or restart VM
- Always `pkill -9 -f racket` before relaunching apps
- Racket module compilation very slow on first run (~5+ min); cached in `compiled/`

### Snapshot testing infrastructure
`load_enriched_framework(name)` in `snapshot_test.rs` generalizes framework loading —
adding a new framework's golden suite is just a file list and test function. AppKit suite
has 23 curated golden files covering key class hierarchies (NSResponder→NSView→NSControl→
NSButton, NSWindow, table view with delegate/data source protocols, menus, text, layout).
AppKit IR scale: 313 classes, 151 protocols, 337 enums, 1846 constants. Rich classes like
NSButton (1110 lines) and NSWindow (942 lines) exercise more typed message send variants
and geometry struct handling than Foundation classes — better regression coverage.

### Block nil handling convention
`make-objc-block` returns `(values #f #f)` (NULL block pointer + no block-id) when `proc`
is `#f`, rather than wrapping `#f` in a lambda that would crash. `free-objc-block` already
handles `#f` gracefully. This allows callers to pass `#f` for optional block parameters
without special-casing.

### GCD main-thread dispatch
`main-thread.rkt` provides `on-main-thread?`, `call-on-main-thread` (sync if already on
main, async via `dispatch_async_f` otherwise), and `call-on-main-thread-after` (delayed
via `dispatch_after_f`). Key FFI details:
- `_dispatch_main_q` is a global struct, not a pointer — access via `dlsym` directly
- Module-level `function-ptr` prevents GC collection of the C callback pointer; without
  this, the GC can collect the closure before GCD invokes it

### macOS widget quirks (Racket apps)
- Radio button mutual exclusion requires manual target-action delegate
- NSStepper requires `setContinuous: YES` to fire target-action
- NSStepper inside plain NSView in NSStackView may not receive clicks — add directly to stack view
