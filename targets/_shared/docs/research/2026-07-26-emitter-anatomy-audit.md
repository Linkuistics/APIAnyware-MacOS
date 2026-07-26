# Emitter anatomy audit — what the 71,719 LOC is actually made of

**Status:** research finding (grove `language-model-transforms`, leaf
`emitter-anatomy-audit-k2`). Feeds `prior-art-model-transform-codegen-k3` (the
survey's question list is [§10](#10-questions-for-k3)) and, through it,
`plan-mechanism-k4`.
**Date:** 2026-07-26.
**Method:** read-only static inspection of the five `emit-*` crates, the shared
`emit` substrate, and the `generate` CLI, plus a read-only look at the
`APIAnyware.add-ocaml-target` jj workspace's sixth emitter. No emitter code, test,
or dependency was changed; no ADR minted (charter Q6). Measurements were taken with
short scripts whose rules are stated inline so each number is auditable; where a
number depends on a judgement call, the rule and its bias are named.

> **How to read this doc.** Every figure names the file and symbol it came from.
> The audit **proposes nothing** — it measures and classifies. Where the honest
> answer was "cannot be determined without running it", that is recorded as such
> ([§9](#9-unclassified-and-undetermined)). Three findings contradict or sharply
> refine the charter's framing; they are flagged **⚠ reframes the charter** where
> they appear.

---

## Headline

The charter's premise — *the mass is mostly mechanical rendering with a decision
layer that can be lifted into declarative rules* — is **half right, and the wrong
half is the one that matters**.

1. **Half the mass is tests.** Of 71,719 LOC, **35,298 (49.2%) is test code**.
   Production emitter code is **36,421 lines**. ⚠ reframes the charter.
2. **The rendering surface is tiny, and objectively so.** All target-language text
   the five emitters produce is carried in **2,273 string literals totalling
   70,852 bytes — 4.4% of the 1.63 MB of production emitter source**
   ([§2.2](#22-the-objective-measure-emitted-text-payload)). The other ~95% decides
   *which* literal, with *which* substitutions. So the charter's thesis about
   *where the leverage is* is confirmed with room to spare; its thesis about
   *how much code templates displace* is wrong by an order of magnitude — templates
   displace almost none of it.
3. **The emitters have already independently invented the architecture, locally.**
   Every emitter builds a resolved intermediate model before rendering — spelled
   `ClassPlan`, `EnumPlan`, `SignatureMap`, `DispatchTable`, `InboundTable`,
   `FunctionTable`, `ExportSurface`, `MethodDisposition`, `ClassBinding`,
   `ProtocolBinding` — and chez/gerbil/sbcl hand-rolled a `__CALL__`/`__VAL__`
   `str::replace` template engine for the one block big enough to need one
   ([§1.4](#14-the-plan-pattern-the-design-already-exists-locally)).
4. **The escape hatch is not a corner case; it is a whole class of knowledge.**
   The single largest curated table in the emitters is `KNOWN_UNBINDABLE` — 51
   entries recording *what the Swift compiler rejects*, discovered by running
   `swift build` and reading errors, keyed by an FNV-1a content hash. That fact
   is in no IR, derivable from no rule, and duplicated four times
   ([§2.1 E1](#e1-known_unbindable--what-the-downstream-compiler-rejects)).
5. **The "4,092 lines of shared substrate" is 866 lines of live shared
   machinery** — 244 lines are dead, 1,177 are test infrastructure, 1,805 are
   in-file `#[cfg(test)]` ([§1.2](#12-the-shared-substrate-4092--866-live)).
   ⚠ reframes the charter: the like-for-like ratio is 36,421 : 866 (**42:1**), not
   17.5:1. The motivation is stronger than stated, not weaker.
6. **The emitters read the IR and nothing else.** No `emit-*` crate depends on
   `apianyware-target-model`; the 1,491 lines of authored `.apiw` target model
   (ADR-0051) are read by **zero** emitters ([§4.2](#42-the-apiw-target-model-is-unwired)).
   ⚠ reframes the charter: a transform reading authored per-target vocabulary
   (root brief Q3) would be the *first* generation-side consumer of that layer.
7. **Goldens-as-truth is currently inert for the real corpus.** Four of five
   targets' corpus snapshot tests silently take a `SKIPPED` path because
   `resolved.kdl` is gitignored and absent; chez has no snapshot target at all.
   The only goldens that actually run are a synthetic 5-class `TestKit`
   ([§5.3](#53-what-the-goldens-actually-cover)). ⚠ reframes the charter's
   equivalence-proof assumption.

---

## Method and reproducibility

Totals were taken on the `language-model-transforms` jj workspace at
`mkskrvvy 123b1534`, 2026-07-26.

```sh
# (1) per-target emit crate total  → the charter's 71,719
for t in racket chez gerbil sbcl typescript; do
  find targets/$t/tools/emit-$t -name '*.rs' -print0 | xargs -0 cat | wc -l
done
# (2) shared substrate            → 4,092
find targets/_shared/tools/emit -name '*.rs' -print0 | xargs -0 cat | wc -l
# (3) generate CLI                → 1,966
find targets/_shared/tools/generate-cli -name '*.rs' -print0 | xargs -0 cat | wc -l
# (4) authored target model       → 1,491
find targets -name '*.apiw' -print0 | xargs -0 cat | wc -l
```

**Production vs test split.** Every `emit-*/src/*.rs` file carries at most one
`#[cfg(test)]` module, always last, always running to EOF (verified on
`emit-racket/src/emit_class.rs:1941`, `emit-typescript/src/inbound_table.rs:991`,
`emit-sbcl/src/trampoline.rs:2415` — arithmetic checks exactly). "Production" =
lines before that marker; files under `tests/`, `examples/` are wholly test.

**Clone detection.** Function bodies were extracted by brace-matching from the
production region, normalised (comments and whitespace dropped, the target's own
name neutralised, **string literals preserved** — divergent output *is* the
load-bearing idiom), then compared exactly and by token-set Jaccard. Whole-file
similarity used `difflib.SequenceMatcher` over comment-stripped, whitespace-
collapsed production lines.

---

## 1. Q1 — Mechanical vs decision-bearing

### 1.1 The four buckets, per target

| target | total | test | **production** | comments | blank | **code** |
|---|---:|---:|---:|---:|---:|---:|
| racket | 14,732 | 7,794 (53%) | **6,938** | 1,639 | 457 | 4,842 |
| chez | 8,186 | 3,138 (38%) | **5,048** | 1,064 | 358 | 3,626 |
| gerbil | 12,162 | 5,069 (42%) | **7,093** | 1,839 | 484 | 4,770 |
| sbcl | 11,152 | 5,197 (47%) | **5,955** | 1,896 | 417 | 3,642 |
| typescript | 25,487 | 14,100 (55%) | **11,387** | 4,369 | 619 | 6,399 |
| **total** | **71,719** | **35,298 (49.2%)** | **36,421** | 10,807 | 2,335 | **23,279** |

The first honest number is that **the charter's 71.7k is a test-inclusive total**.
It is also a comment-rich total: 10,807 lines of production comments (30% of
production, 46% in `emit-typescript`) carry the design rationale the ADRs cite.

Bucket classification of the 23,279 code lines was attempted two ways and the
two disagree, which is itself the finding:

| rule | rendering | decision | orchestration | declarations |
|---|---:|---:|---:|---:|
| function-role (a fn is "rendering" if ≥40% of its body lines are output calls) | 1,111 (4.3%) | 20,895 (81.7%) | 1,023 | 2,549 |
| line-level (a line is "rendering" if it is inside an output call's paren-span) | 3,964 (17.0%) | 12,502 (53.7%) | 70 | 6,743 |

The spread (4.3%–17.0%) is caused by lines that are genuinely both: a `format!`
that computes an *identifier* rather than emitted source, and one-line `if` guards
around a single `w.line`. **Neither rule puts rendering above one line in six.**
The bracket is reported rather than resolved because resolving it would require a
judgement per line, and the conclusion does not depend on where in the bracket the
truth sits.

### 1.2 The shared substrate: 4,092 → 866 live

| file | total | prod | status |
|---|---:|---:|---|
| `code_writer.rs` | 211 | 121 | live — `CodeWriter`, `FileEmitter`, `write_line!` |
| `doc_rendering.rs` | 209 | 112 | **DEAD** — `render_doc_block`/`format_doc_lines`/`DocBlock` have **0 callers workspace-wide** |
| `enrichment.rs` | 156 | 68 | live — `class_error_selectors` (30 refs), `class_retaining_params` (ts only) |
| `ffi_type_mapping.rs` | 1,070 | 263 | live — but **143 of those 263 are `RacketFfiTypeMapper` + `RacketFfi2TypeMapper` + `ffi_unsafe_to_ffi2`**, i.e. one target's semantics inside the shared crate |
| `framework_ordering.rs` | 181 | 84 | live — `topological_sort`, called **only** by `generate-cli/src/generate.rs:74` |
| `lib.rs` | 18 | 18 | live |
| `naming.rs` | 400 | 251 | live — `split_camel_case`, `camel_to_kebab`, `acronym_aware_kebab` |
| `pattern_dispatch.rs` | 313 | 132 | **DEAD in production** — `classify_pattern` has zero production callers (confirmed by `CONTEXT.md`'s idiom-catalogue entry: "every emitter pattern-blind") |
| `snapshot_testing.rs` | 570 | 355 | test infrastructure |
| `target_emitter.rs` | 77 | 61 | live — the whole shared *contract* (see §1.3) |
| `test_fixtures.rs` | 887 | 822 | test infrastructure |
| **total** | **4,092** | **2,287** | **live 866 · dead 244 · test-infra 1,177 · `#[cfg(test)]` 1,805** |

Two notes worth carrying forward. `framework_ordering.rs` is **not** evidence that
emission carries ordering state (the leaf brief's hypothesis) — it is *driver*
scheduling, invoked once by the CLI. The real emitter-internal ordering state is
elsewhere ([§3](#3-q3--ordering-and-statefulness)). And `pattern_dispatch.rs` +
`doc_rendering.rs` together are 244 lines of shared machinery built for a consumer
that never arrived; the `add-ocaml-target` grove's leaf
`deprecation-invisible-in-sister-targets-k31` reaches the same conclusion about
`doc_rendering.rs` independently.

### 1.3 The shared contract is one method

`targets/_shared/tools/emit/src/target_emitter.rs:48-60`:

```rust
pub trait TargetEmitter {
    fn target_info(&self) -> &TargetInfo;
    fn emit_framework(&self, framework: &Framework, output_dir: &Path) -> io::Result<EmitResult>;
}
```

That is the entire architectural seam: *whole framework in, files on disk out*.
There is **no shared model of what gets emitted** — which is precisely why each
emitter had to invent one.

### 1.4 The "plan" pattern: the design already exists, locally

Every emitter computes a resolved intermediate structure and then renders from it.
Inventory (production only):

| target | resolved-model structures | the transform that builds them |
|---|---|---|
| racket | `SwiftNativeBindings` (`emit_class.rs:44`), `NativeSig` (`native_dispatch.rs:350`), `SignatureMap` (`shared_signatures.rs:66`), `FnDisposition`/`MethodDisposition` (`trampoline.rs:648`/`1576`) | `collect_swift_native_bindings`, `collect_class_native_sigs`, `collect_global_signatures`, `build_export_contracts`, `build_property_name_sets`, `collect_predicate_class_names` |
| chez | `ClassPlan` (`emit_class.rs:279`), `EnumPlan` + `Decision{Bare,Prefixed,Skip}` (`emit_enums.rs:80`/`90`) | `build_class_plan`, `build_plan`, `collect_exports` |
| gerbil | `ClassPlan` (`emit_class.rs:475`), `EnumPlan`/`Decision` (`emit_enums.rs:86`/`94`), `Signature` (`emit_class.rs:966`) | `build_class_plan`, `build_plan`, `collect_signatures`, `collect_global_surface_selectors` |
| sbcl | `EnumPlan`/`Decision` (`emit_enums.rs:148`/`156`), `ExportSurface` (`emit_framework.rs:191`), `FnResidualEntry`, `ConstResidualEntry`, `ResidualEntry` | `build_plan`, `collect_generics`, `collect_residual`, `collect_fn_residual`, `collect_const_residual` |
| typescript | `ClassBinding` (`class_binding.rs:71`), `ProtocolBinding` (`protocol_binding.rs:77`), `DispatchTable` (`dispatch_table.rs:92`), `InboundTable` (`inbound_table.rs:399`), `FunctionTable` (`function_table.rs:116`), `SpecMethod`, `OverridableEntry`, `InboundSig`, `SuperEntry` | `collect_global_entries`, `collect_inbound_table`, `collect_function_entries`, `build_import_map`, `build_class_graph` |

`emit-sbcl/src/emit_enums.rs:183 build_plan` is the clearest specimen: a **two-pass
whole-framework computation** producing `HashMap<(enum, value), Decision>` — pass 1
groups by *emitted* kebab symbol collecting distinct formatted values, pass 2 walks
in IR order assigning `Bare` / `Prefixed` / `Skip` against an `emitted` accumulator.
That is an instance-level projection model fragment, written by hand, four times
(chez `emit_enums.rs:112`, gerbil `:116`, sbcl `:183`, and typescript's
`enum_graph.rs`), with chez↔gerbil at Jaccard ≥0.95.

`emit-typescript/src/class_surface.rs` states the pattern in its own module doc:
*"the single place the `.ts` class body and the co-generated `.d.ts` type surface
derive **what** to emit and **how each method's signature reads**, so the two
artifacts provably cannot drift"*. That is a projection model with two renderers,
already shipped.

---

## 2. Q2 — The escape-hatch inventory (the crux)

Every site below is one a datalog rule plus a logic-free template **could not
express**. Each entry names what it does and what mechanism it would need.

### 2.1 Hard escapes — no declarative form exists

#### E1. `KNOWN_UNBINDABLE` — what the downstream compiler rejects

- **Where:** `emit-racket/src/trampoline.rs:1612` (53 lines, 51 entries); identical
  tables at `emit-chez/src/trampoline.rs:1395`, `emit-gerbil/src/trampoline.rs:1571`,
  `emit-sbcl/src/trampoline.rs:1150`.
- **What it does:** suppresses Swift-native declarations *swiftc refuses to
  compile*, keyed by the content-addressed `@_cdecl` entry name, each tagged with a
  `DeferReason` (`ActorIsolated`, `ModuleMemberMissing`, `NoncopyableReceiver`,
  `ImmutableInoutArgument`, `InaccessibleDecl`, `GenericInferenceFailure`,
  `UnknownAvailability`, `ArgumentShapeMismatch`, `UnresolvedMemberType`,
  `CompileTimeConstantParam`).
- **Why nothing declarative reaches it:** the module doc is explicit — *"decls
  swiftc rejects for a cause the lossy IR cannot mechanically predict —
  `@MainActor`/actor isolation (which `swift-api-digester` does not emit at all)"*.
  The facts were **discovered by running `swift build` and reading the errors**.
  They are not in the IR, not derivable from it, and not a property of the target
  language's grammar.
- **Mechanism required:** authored per-target data keyed on an identifier the
  transform computes, plus a build-time regression guard (today: the full-residual
  `swift build`).

#### E2. FNV-1a content-addressed identifiers

- **Where:** `overload_hash` and `method_hash`, each ×4 targets —
  `emit-racket/src/trampoline.rs:743`/`1846`, chez `:660`/`1614`, gerbil
  `:695`/`1792`, sbcl `:717`/`1367`.
- **What it does:** `h.wrapping_mul(0x0000_0100_0000_01b3)`, `h ^ (h >> 32)`,
  `format!("{:08x}", …)` over the printed param/return shape, to distinguish two
  overloads of the same `(module, name)` **without a global counter**.
- **Mechanism required:** a host function. Datalog has no arithmetic of this shape;
  a template has none at all. Note the mutual dependency with E1: the suppression
  table is keyed by the hash, so the hash must exist before the table can be read.

#### E3. `case_tag` — an injective filename disambiguator by bit-packing

- **Where:** `emit-typescript/src/naming.rs:264`, feeding `ClassFileStems`
  (`:209`).
- **What it does:** the hex of the class name's ASCII-uppercase **bitmap**, eight
  bits per byte LSB-first (`bits |= 1 << i`, `bytes.chunks(8)`,
  `len().div_ceil(8)`). It is a *lossless* encoding of what `to_ascii_lowercase`
  discarded, so the class→stem map is injective **by construction**.
- **Why it exists:** Matter declares 17 ALL-CAPS acronym classes beside their
  Swift-friendly aliases (`MTRBaseClusterWakeOnLAN` / `…WakeOnLan`); lowercasing
  collided them, and spelling the ObjC name verbatim does not help because APFS and
  Windows filesystems are case-**insensitive**. The bug lost 17 classes silently
  while 34 sibling modules kept importing the vanished names.
- **Mechanism required:** bit arithmetic + byte iteration. Nothing declarative.

#### E4. Identifier formation — character-level scanning with a curated table

- **Where:** `_shared/emit/src/naming.rs` — `split_camel_case:10` (byte-level
  boundary scan handling acronym runs and digit boundaries),
  `acronym_aware_words:207` + `longest_token_at:236` (longest-match scan over a
  `KNOWN_TOKENS` table of 23 entries: `OpenGL`, `HTTPS`, `NS`, `URL`, …).
- **Mechanism required:** a host string function. This is the load-bearing
  observation for the whole design: **derived identifiers must be first-class nodes
  in the projection model**, because the collision logic in §2.2 operates on them
  and a rule engine cannot compute them.

#### E5. `chezscheme_import_spec` — a table captured from a live target runtime

- **Where:** `emit-chez/src/chez_builtins.rs:39` (`include_str!("chez_builtins.txt")`,
  **1,715 identifiers**) and `chezscheme_import_spec:56`.
- **What it does:** intersects a file's *complete* export set against every symbol
  `(chezscheme)` exports, sorts, dedups, and emits either `(chezscheme)` or
  `(except (chezscheme) <colliders…>)`. Chez is strict R6RS: a local `define`
  shadowing an import is a hard load error.
- **Why nothing declarative reaches it:** the table is
  `(environment-symbols (environment '(chezscheme)))` **captured from a running
  Chez**, and the decision needs the whole file's export set before line 1 can be
  written.
- **Mechanism required:** authored per-target data (regenerable by running the
  target's own toolchain) + whole-file accumulated state in the transform.

#### E6. Generics sharding — a variable output file set sized by a toolchain limit

- **Where:** `emit-gerbil/src/emit_generics.rs` —
  `collect_global_surface_selectors:65`, `write_global_generics_module:137`,
  `GENERICS_SHARD_SIZE = 256` (`:57`).
- **What it does:** unions every distinct instance-surface selector across **all
  loaded frameworks**, sorts, chunks into 256-selector shards, `remove_dir_all`s the
  shard directory, writes N shard files, then writes a facade whose body is a
  function of N.
- **Why nothing declarative reaches it:** the reason for 256 is that Gambit's
  `gsc -target C` is superlinear in module size (ADR-0023: a 37.8 MB unit ran >67
  min unfinished). That is a fact about a *downstream compiler's performance*, and
  it determines **how many files exist**.
- **Mechanism required:** the renderer must accept a data-dependent output file set;
  the transform must be able to partition by a tunable constant.

#### E7. Curated per-symbol admissions and suppressions

- `emit-typescript/src/method_filter.rs:284` `ADMITTED_COMPLETION_HANDLER_SELECTORS`
  (1 selector), `:339` `ADMITTED_OPAQUE_POINTER_FUNCTIONS` (8 `CGContext*`
  symbols), `:362` `ADMITTED_OPAQUE_POINTER_METHODS` (1). Each doc says the shape
  was **verified by hand for every corpus occurrence**; the module warns that
  selector-name matching alone cannot see a future corpus changing the shape
  underneath.
- `emit-{racket,chez,gerbil,sbcl}/src/shared_signatures.rs is_libdispatch_unexported`
  — 5 symbols libdispatch's headers declare but its dylib does not export
  (`dispatch_cancel`, `dispatch_notify`, `dispatch_testcancel`, `dispatch_wait`,
  `pthread_jit_write_with_callback_np`), **byte-identical in all four**.
- `emit-typescript/src/function_table.rs:68` `UNBUNDLED_FRAMEWORKS = ["libdispatch"]`.
- **Mechanism required:** authored data. Note E7's second bullet is **platform
  truth**, not target semantics — see [§6.3](#63-duplication-that-is-not-target-semantics-at-all).

### 2.2 The objective measure: emitted-text payload

The template's content *is* the string literals plus their substitution structure.
Measured over production regions only, excluding `use`/attribute lines:

| target | string literals | bytes | literals carrying target syntax | their bytes |
|---|---:|---:|---:|---:|
| racket | 1,029 | 21,640 | 536 | 14,855 |
| chez | 805 | 16,377 | 383 | 10,276 |
| gerbil | 997 | 20,055 | 494 | 13,030 |
| sbcl | 585 | 14,159 | 287 | 8,783 |
| typescript | 1,002 | 27,390 | 573 | 23,908 |
| **total** | **4,418** | **99,621** | **2,273** | **70,852** |

Production source is **1,627,518 bytes**. So the emitted-text payload is **4.4%**
of it; all string literals together are **6.1%**.

The largest single literals are 137–173 bytes — and three of them are already
templates with placeholders:

```rust
// emit-chez/src/trampoline.rs:1814  (identical shape at gerbil:2017, sbcl:1886)
"    do {\n      let awR = try await __CALL__\n      return AwChezAsyncOutcome(value: __VAL__)\n    } catch {\n …"
    .replace("__CALL__", &call)
    .replace("__VAL__", &value_expr)
```

`emit-racket/src/trampoline.rs:2054` does the same with `format!` interpolation.
**Three of five emitters hand-rolled a placeholder template engine** the moment a
block exceeded a few lines.

### 2.3 Soft escapes — expressible declaratively, but not by *this* pair

These are not template-expressible, but they *are* rule-shaped, so they belong in
the transform rather than the escape hatch. Listing them is what keeps the escape
hatch honestly small.

- **Transitive reachability with cycle guard.**
  `emit-typescript/src/emit_protocol.rs:185 reaches_bindable_surface` — is a
  protocol emittable transitively over `inherits`, guarded by a `visiting` set.
  Canonical datalog: `reaches(P) :- emittable(P). reaches(P) :- inherits(P,Q),
  reaches(Q).` Its ugly part is a *scope-limit workaround*: `by_name` holds only the
  protocols handed to this call, so a cross-framework ancestor falls back to
  `mapper.is_known_protocol`. **A whole-corpus transform deletes that fallback.**
- **Conformance closure.** `conformance_closure` — 15 production lines, **identical**
  in gerbil `protocol_registry.rs:85`, sbcl `:108`, typescript `protocol_graph.rs:201`.
- **Name-collision resolution.** `emit-racket/src/emit_class.rs:254-426` computes
  `class_method_names`, `prop_names`, `instance_method_names`,
  `instance_property_names_only`, `class_method_disambig`, `class_property_disambig`,
  and a `swift_native.exclude(&objc_names)` pass — set algebra over *derived
  identifiers*. Expressible as rules **iff** derived names are model nodes (E4).
- **Superclass-before-subclass emit order.** `ordered_classes`/`visit_class` —
  stable DFS post-order over same-framework parent edges, at
  `emit-sbcl/src/emit_framework.rs:610`/`626` and
  `emit-typescript/src/class_graph.rs:308`/`323`, at Jaccard ≥0.92. A partial order
  datalog can state; the *total* order (ties by IR order, for golden determinism)
  it cannot.

### 2.4 Filesystem and SDK reads

Almost none. Production filesystem access in the emitters is **output writing
only** (`emit_framework.rs` in each target, plus gerbil's shard `remove_dir_all`).
No emitter reads the SDK, invokes a process, or consults an environment variable in
production. The one compile-time read is `include_str!` in E5. Hardcoded SDK paths
appear as *emitted text*, not as reads:
`/System/Library/Frameworks/{0}.framework/{0}` at
`emit-racket/src/emit_class.rs:1040` and
`emit-{racket,chez,gerbil,sbcl}/src/shared_signatures.rs framework_shared_object_arg`.

---

## 3. Q3 — Ordering and statefulness

Templates are stateless, so every site here is a transform responsibility and
bounds what the projection model must carry.

### 3.1 Whole-corpus state (cross-framework; computed in the CLI pre-pass)

`emit_framework` runs per framework and cannot see the others, so nine
whole-corpus passes live in `_shared/tools/generate-cli/src/generate.rs`:

| pass | site | what it accumulates |
|---|---|---|
| framework ordering | `generate.rs:74` `topological_sort` | Kahn's algorithm over `Framework.depends_on`, ties broken by sort for determinism |
| gerbil `ClassRegistry` | `generate.rs:130` | class → owning framework, whole corpus (ADR-0020 manifest graph) |
| gerbil `ProtocolRegistry` | `generate.rs:136` | protocol `inherits` closure, crosses frameworks |
| gerbil global generics | `generate.rs:145` `write_global_generics_module` | union of every instance-surface selector → sorted → 256-shards (E6) |
| sbcl `ClassRegistry` + `ProtocolRegistry` | `generate.rs:153`,`:158` | same shape, no generics module (a CL package unifies for free) |
| ts `ClassRegistry` + `EnumRegistry` + `ProtocolRegistry` | `generate.rs:167`,`:172`,`:175` | three ownership registries — `emit-typescript/src/protocol_graph.rs` names itself *"the **third** copy of the ownership-registry family"* |
| ts `synthetic_init_blocklist` | `generate.rs:181` | classes with a real descendant *anywhere in the corpus* whose own bare `-init` is `NS_UNAVAILABLE` |
| racket global dispatch + trampolines | `generate.rs:294`,`:336` | `collect_global_signatures` dedups ABI signatures across every framework |
| ts dispatch / inbound / trampoline / function tables | `generate.rs:389`,`:455`,`:506`,`:555` | four global tables, each a dedup+classify over the whole corpus |

Plus four reporting passes (`degradation_report`, `renamed_protocols`,
`slot_report`, and the deferral counters) whose only purpose is *"never silent"*
accounting of what was dropped.

### 3.2 Per-framework state

- Enum symbol dedup + prefix disambiguation (`build_plan`, §1.4) — needs every
  enum's every value before any can be emitted.
- `emit-typescript/src/naming.rs:209 ClassFileStems` — a per-framework occupancy
  count over lowercased names, plus `RESERVED_MODULE_STEMS` pre-occupied.
- `emit-sbcl/src/emit_framework.rs:281` `generics.lisp` — one `defgeneric` per
  selector, collected across the framework's classes *and* their conformed-protocol
  flattening, in lockstep with the per-class `defmethod`s.
- `emit-sbcl/src/emit_framework.rs` load order: facade → `generics.lisp` →
  per-class files **superclass-before-subclass** → the rest.
- Barrel / facade / `main` re-export files (all five targets) — a function of the
  complete file set written.

### 3.3 Per-file state

- E5's import spec — the file's first line depends on its complete export set.
- `emit-typescript/src/imports.rs` — nine `BTreeMap<String, BTreeSet<String>>`
  builders grouping referenced types into `import { … } from '<mod>'` blocks, then
  `merge` + `render_import_blocks`. Read by both the `.ts` and `.d.ts` renderer so
  they "group and sort identically and cannot drift".
- `emit-racket/src/emit_class.rs:400 build_export_contracts` +
  `:420 collect_predicate_class_names` — the `provide/contract` block and the
  predicates it references must both precede the definitions.
- `SignatureMap` / shared `_msg-N` fallback bindings — hoisted to file scope,
  collected from every method in the class.
- `emit-typescript/src/emit_framework.rs:104 WriteOnceEmitter` — a
  `BTreeSet<String>` of filenames written, so `files_written` is **measured, not
  asserted**, and a second write to one name is a hard error. Added because the
  non-injective stem bug (E3) lost 17 classes silently.

### 3.4 Sorting and dedup counts

Across the five production regions: **16** `sort*` calls, **15** `dedup*` calls,
**307** `BTreeSet`/`BTreeMap` uses (218 in typescript alone), **277**
`HashSet`/`HashMap` uses, **14** content-hash sites, **23** `retain` (set
subtraction) calls.

---

## 4. Q4 — The transform's input surface

### 4.1 IR field reads, by reader count

Counts are `.field` occurrences in production regions
(`semantic/tools/types/src/ir.rs` field list).

**Read by all five — meta-schema candidates (30 fields):**
`Framework.{classes, protocols, enums, functions, constants}`,
`Class.{protocols, methods, all_methods, objc_exposed, swift_name}`,
`Method.{selector, class_method, init_method, params, return_type, deprecated,
variadic, returns_retained, objc_exposed, swift_fn}`, `Param.param_type`,
`Protocol.{required_methods, optional_methods}`, `Enum.values`, `Function.inline`,
`SwiftFnInfo.{throwing, is_async, is_generic}`,
`Constant.{constant_type, macro_value}`.

**Read by exactly one — per-target vocabulary candidates (5 fields, all
TypeScript):** `Framework.class_annotations`, `Class.category_methods`,
`Class.ancestors`, `Method.source`, `Constant.array_element`.

**Read by four of five:** `Framework.structs` (not ts), `Framework.enrichment`
(**not chez** — chez has 0 `.enrichment` reads), `Class.properties`,
`Method.provenance`, `Property.{property_type, readonly, class_property}`
(all four not ts — ts routes properties through `class_surface`),
`SwiftFnInfo.self_kind`.

**Read by zero emitters — dead IR surface (14 fields):**
`Framework.{format_version, checkpoint, sdk_version, collected_at,
skipped_symbols, patterns, verification}`, `Class.swift_attributes`,
`Method.{doc_refs, category, overrides, satisfies_protocol}`,
`Property.ownership`, `Struct.fields`.

Three of those deserve a sentence:

- **`Method.doc_refs`** appears in production only as `doc_refs: None` in test
  fixtures. Together with the dead `doc_rendering.rs` (§1.2), the entire
  documentation-in-generated-source path is built and unwired.
- **`Framework.patterns` / `PatternInstance`** is read only by the dead
  `pattern_dispatch.rs`. ws3's first-class pattern-kinds reach no emitter.
- **`Property.ownership`** — ADR-0047 §4's measured declared-ownership fact (907
  slots, correcting 18 the name-sniff had wrong) reaches exactly **one** emitter
  call site: `emit-sbcl/src/emit_generics.rs:617 ret_retained: p.is_copy()`.

### 4.2 The `.apiw` target model is unwired

`emit-*/Cargo.toml` dependencies are, for all five targets, exactly
`apianyware-types` + `apianyware-emit` (racket adds `serde_json`). **No emitter
depends on `apianyware-target-model`.** The shared `emit` crate does, but only for
the dead `pattern_dispatch.rs` (`use apianyware_target_model::{EmitConstruct,
IdiomCatalogue}` at `pattern_dispatch.rs:28`).

On disk there are **24 authored `.apiw` files, 1,491 lines**, across
racket/chez/gerbil/sbcl only — `target.apiw`, `capability.apiw`,
`idioms/catalogue.apiw`, `policies/macos/projection.apiw`,
`adapters/macos/spec.apiw`, `conformance/macos.apiw` each. **TypeScript has none**;
the fifth target was built after ws6 and never got a target model.

So the emitters' input surface today is: **the resolved IR, and nothing else.** The
authored target model is consumed only by `apianyware-conformance` and validators.

---

## 5. Q5 — The renderer's output surface

### 5.1 Per-framework binding source

| target | file set per framework | facade |
|---|---|---|
| racket | `<fw>/<class>.rkt` ×N, `enums.rkt`, `constants.rkt`, `functions.rkt`, `protocols/<p>.rkt` ×M | `<fw>/main.rkt` |
| chez | same shapes, `.sls`, plus `structs/` | `<fw>.sls` (**outside** the dir — Chez library-name resolution) |
| gerbil | `<fw>/<class>.ss` ×N, `structs/`, `protocols/`, aggregates | `<fw>.ss` + the global `generics.ss` and `generics/NNN.ss` shards |
| sbcl | `<fw>/generics.lisp`, `<class>.lisp` ×N, `protocols.lisp`, `enums.lisp`, `constants.lisp`, `functions.lisp`, `structs.lisp` (each residual-gated) | `<fw>.lisp` |
| typescript | `<fw>/<stem>.ts` **and** `<stem>.d.ts` ×N, plus `constants`, `enums`, `functions`, `protocols`, `delegates` (each ×2) | `index.ts` barrel |

Every aggregate file is residual-gated (written only when non-empty), which makes
the file set itself data-dependent in all five targets, not just gerbil.

### 5.2 Non-source outputs — the adapter is generated, the docs are not

**The Swift adapter sources are generated**, by nine global CLI passes writing into
each target's Swift package (defaults in
`_shared/tools/generate-cli/src/main.rs:45-164`):

```
targets/racket/adapters/macos/sources/Generated/Dispatch.swift
targets/racket/adapters/macos/sources/Generated/Trampolines.swift
targets/chez/adapters/macos/sources/Generated/Trampolines.swift
targets/gerbil/adapters/macos/sources/Generated/Trampolines.swift
targets/sbcl/adapters/macos/sources/Generated/Trampolines.swift
targets/typescript/bindings/node/native/src/Generated/{DispatchTable,InboundTable,TrampolineTable,FunctionTable}.swift
```

Build order is `generate → swift build`. All five `Generated/` directories are
gitignored (`.gitignore`: four `targets/<t>/adapters/macos/sources/Generated/` plus
`targets/typescript/bindings/node/native/src/Generated/`), confirming the nine files
are generated. So the charter's "dylib" output **is** in scope today.

**The docs are not generated.** Zero `.md` writes anywhere in the emitters. Every
binding doc is committed, therefore hand-written: 4 per target
(`user-guide.md`, `platform-docs-mapping.md`, `api-coverage.md`,
`unsafe-escape-hatches.md`) — 219 lines racket, 308 chez, 387 gerbil, 460 sbcl,
460 typescript = **1,834 lines hand-written across 20 files**, plus per-app
`report.md` and `learnings.md`. `api-coverage.md` cites `apianyware-conformance`
output but is authored prose around it.

### 5.3 What the goldens actually cover

| target | golden files | golden lines | corpus snapshot status |
|---|---:|---:|---|
| racket | 11 | 484 | `tests/snapshot_test.rs:152-167` **SKIPPED** when `resolved.kdl` absent |
| gerbil | 13 | 732 | same skip path |
| sbcl | 11 | 234 | same skip path |
| typescript | 21 | 714 | same skip path |
| chez | **0** | **0** | **no `snapshot_test` target at all** |

All goldens are one synthetic framework, `TestKit` — five classes (`TKObject`,
`TKView`, `TKButton`, `TKManager`, `TKHelper`), two protocols, and the aggregates.

In *this* workspace, `platforms/macos/api/Foundation/` contains only
`annotations.apiw`; `resolved.kdl` is gitignored (`.gitignore:
platforms/macos/api/*/resolved.kdl`) and absent for all 153 families. Since
`snapshot_test.rs:153` short-circuits on `!framework_path.exists()`, the corpus
goldens do not run here. This is not inference alone: the `add-ocaml-target`
grove's leaf `sister-target-goldens-stale-against-the-corpus-k29` **measured** it
by materialising `resolved.kdl` and re-running, and found racket 2 failures,
gerbil 1, sbcl 1, typescript 1 — plus two non-snapshot `apianyware-generate`
failures.

⚠ **This is the charter's equivalence-proof problem, larger than the brief
assumed.** It is not only that chez lacks the instrument; it is that the
instrument's default state across the other four is *silently inert*, and the
committed goldens cover a five-class fixture rather than the 153-family corpus.

---

## 6. Q6 — Genuine idiom vs accidental duplication

### 6.1 The duplication matrix

Pairwise longest-common-subsequence over comment-stripped, whitespace-collapsed
**production** lines, by shared filename:

| file | racket | chez | gerbil | sbcl | ts | best pair | LCS % of smaller | est. redundant |
|---|---:|---:|---:|---:|---:|---|---:|---:|
| `trampoline.rs` | 1,620 | 1,565 | 1,790 | 1,681 | 371 | chez/racket | **88.4%** | 4,631 |
| `emit_class.rs` | 1,456 | 923 | 1,330 | 94 | 596 | chez/gerbil | 48.6% | 1,431 |
| `naming.rs` | 115 | 129 | 132 | 82 | 140 | chez/gerbil | **89.1%** | 408 |
| `method_filter.rs` | 35 | 77 | 97 | 97 | 163 | chez/gerbil | **100%** | 306 |
| `emit_enums.rs` | 19 | 109 | 104 | 147 | 103 | chez/gerbil | **87.5%** | 293 |
| `emit_framework.rs` | 162 | 200 | 282 | 412 | 448 | chez/gerbil | 47.5% | 501 |
| `emit_functions.rs` | 248 | 137 | 207 | 111 | 388 | chez/gerbil | 56.9% | 400 |
| `emit_protocol.rs` | 255 | 111 | 104 | 89 | 330 | chez/gerbil | 49.0% | 274 |
| `emit_constants.rs` | 122 | 149 | 200 | 78 | 339 | sbcl/ts | 43.6% | 239 |
| `ffi_type_mapping.rs` | — | 168 | 251 | 113 | 156 | chez/gerbil | 50.0% | 218 |
| `class_graph.rs` | — | — | 88 | 88 | 202 | gerbil/sbcl | **98.9%** | 174 |
| `shared_signatures.rs` | 183 | 19 | 37 | 10 | — | chez/sbcl | **100%** | 66 |
| `protocol_registry.rs` | — | — | 45 | 45 | — | gerbil/sbcl | **100%** | 45 |
| | | | | | | | | **≈9,164** |

Three independent estimates of the redundancy, most conservative first:

- **3,513 lines** — function bodies that are *exactly* identical after
  normalisation, counting only the copies beyond the first.
- **4,837 lines** — same-name functions across targets at Jaccard ≥0.85.
- **≈9,164 lines** — the whole-file estimate above (total minus largest, scaled by
  best-pair LCS%).

Against 36,421 production lines that is **9.6% – 25%**.

The `trampoline.rs` case is the whole story in miniature: 1,565–1,790 production
lines each in four targets, **88% line-identical** racket↔chez, 85% chez↔gerbil,
~62% for sbcl (whose CLOS surface diverges). `classify_method` alone is 133–149
lines at Jaccard **0.98** across all four; `collect_trampolines`,
`generate_trampolines_swift`, `emit_init_tramp`, `args_decl_and_prelude`,
`arg_values`, `collect_type_methods`, `classify_param`, `type_shape`,
`overload_hash`, `method_hash`, `emit_cdecl_header`, `known_unbindable`,
`max_macos_version`, `introduced_macos`, `swift_import_module`, `dedup_by_entry`,
`is_overloaded`, `sanitize`, `scalar_typedef`, `scalar_of_primitive` are all at
Jaccard **1.00**.

### 6.2 Genuine, load-bearing idiom

The functions with the *lowest* cross-target overlap are exactly the rendering
functions — which is the thesis, measured:

| function | lines across targets | max pairwise Jaccard |
|---|---:|---:|
| `generate_functions_file` | 524 (4 targets) | 0.57 |
| `emit_method` | 428 (4) | 0.55 |
| `generate_constants_file` | 414 (4) | 0.55 |
| `emit_header` | 410 (4) | **0.46** |
| `emit_property` | 372 (3) | 0.55 |

`emit_header` is 68 lines in racket (`emit_class.rs:978`), 84 in chez (`:685`), 63
in gerbil (`:1242`), and has no counterpart in sbcl (whose orchestrator owns the
`(in-package …)` header). Their divergence is real: racket emits a `require` form
with an `(except-in ffi/unsafe ->)` discipline and conditional ffi2/trampoline/
async-bridge arms; chez emits `(except (chezscheme) …)` computed from the export
set; gerbil emits `:gerbil-bindings/runtime/*` imports.

Racket's contract layer is the clearest per-target semantics in the repo:
`map_param_contract` (`emit_class.rs:687`) and `map_return_contract` (`:712`) map a
`TypeRef` to `(or/c string? objc-object? #f)` / `(or/c <class>? objc-nil?)`, and
`build_export_contracts` (`:838`, 121 lines) assembles the `provide/contract`
block, with `collect_predicate_class_names` (`:776`) ensuring each referenced
predicate is defined first. Nothing analogous exists in any other target. Under
root-brief Q3 this is exactly a per-target rule set over a shared meta-schema.

### 6.3 Duplication that is not target semantics at all

A distinct category the charter's ADR-0011 framing does not cover: **facts that
are neither shared mechanism nor target semantics, but platform or analysis truth
misplaced into the target domain.** ADR-0011 does not permit or forbid these; they
are simply in the wrong domain.

- `is_libdispatch_unexported` — 5 symbols the libdispatch **dylib** does not
  export, byte-identical in all four Lisp `shared_signatures.rs`. That is
  `platforms/macos` truth.
- `framework_shared_object_arg` / `framework_path_for_*` — the
  `/System/Library/Frameworks/{0}.framework/{0}` convention and libdispatch's
  exception, re-derived in four targets.
- The geometry-struct recognition set (`NSRect`, `CGRect`, …, 12 names) appears in
  **ten** files: `_shared/emit/ffi_type_mapping.rs:70`, plus chez, gerbil, sbcl,
  typescript `ffi_type_mapping.rs`, racket `emit_functions.rs` and
  `native_dispatch.rs`, typescript `inbound_table.rs`, `native_dispatch.rs`,
  `swift_abi.rs`.
- `name.ends_with("Type") && is_generic_type_param(name)` — the *same two-part
  naming heuristic* for "is this TypeRef an ObjC generic type parameter?" written
  out at **six** call sites across all five targets
  (`emit-racket/src/emit_functions.rs:81`, chez `ffi_type_mapping.rs:145`, gerbil
  `:363`, sbcl `:71`, typescript `ffi_type_mapping.rs:292` and
  `native_dispatch.rs:553`). Under ADR-0047 this is an analysis-tier convention
  rule, not a projection decision.
- `_shared/emit/ffi_type_mapping.rs` holds `RacketFfiTypeMapper` and
  `RacketFfi2TypeMapper` — 143 of its 263 production lines are one target's
  semantics inside the shared substrate.
- `is_family_match` (Cocoa `init`/`new`/`copy`/`mutableCopy` family detection) at
  Jaccard **1.00** in all five targets; `method_returns_retained` in all five at
  ≥0.86. Both are ObjC *convention* facts.

### 6.4 The freshest measurement: the sixth-emitter tax

`APIAnyware.add-ocaml-target` (workspace `xxrorsty 6b8fd49b`) is building a sixth
emitter — `emit-ocaml` at **15,153 LOC** across 20 modules — under the current
architecture. Three of its live leaves are *sister-target* leaves, i.e. defects
found by building the sixth emitter that all five shipped emitters share:

- **`property-getters-in-sister-targets-k25`** — all four Lisp emitters lower an
  `@property` getter to a send of `p.name` rather than the declared
  `getter=` selector (racket `emit_class.rs`, chez `emit_class.rs`, gerbil
  `emit_class.rs`, sbcl `emit_generics.rs property_getter_dispatch`). **74 of
  Foundation's 1,259 and 264 of AppKit's 2,634 properties rename their getter** —
  `NSView.hidden`, `NSControl.enabled`, `NSWindow.visible`,
  `NSTextField.editable`. Each is a binding that builds clean and fails at the
  call. The leaf's own sizing: *"one line per emitter"* — times four emitters, four
  golden re-blessings, and four VM re-verifications.
- **`sister-target-goldens-stale-against-the-corpus-k29`** — §5.3.
- **`deprecation-invisible-in-sister-targets-k31`** — five targets say nothing
  about a deprecated declaration; **226 bound top-level declarations are
  IR-deprecated in Foundation + AppKit**; the shared machinery that would say it
  (`doc_rendering.rs`) exists, has tests, and has zero callers.

This is the duplication cost measured rather than argued: one defect discovered
once, then N fixes, N golden movements, N verifications.

---

## 7. Q7 — The TypeScript outlier

`emit-typescript` is 25,487 total / 11,387 production. Grouped by concern
(`src/` only; each file assigned to its module doc's stated purpose):

| group | total | prod | is it (i) richer surface, (ii) N-API substrate, or (iii) avoidable? |
|---|---:|---:|---|
| **A. typed `.d.ts` surface** — `emit_dts`, `class_surface`, `ffi_type_mapping`, `imports`, `override_widening`, `naming`, `emit_protocol` | 6,265 | 2,602 | **(i)** — ADR-0055's type deliverable; no Lisp analogue exists |
| **B. N-API / Swift bridge tables** — `dispatch_table`, `inbound_table`, `function_table`, `swift_abi`, `native_dispatch`, `trampoline`, `ptr_value` | 6,697 | 3,233 | **(ii)** — four generated `.swift` tables vs the Lisp targets' one |
| **C. ownership registries + resolved-once decisions** — `class_graph`, `enum_graph`, `protocol_graph`, `class_binding`, `protocol_binding`, `delegate_spec`, `subclass_surface` | 3,924 | 2,035 | **(iii) partly** — `protocol_graph.rs` calls itself *"the **third** copy of the ownership-registry family"* |
| **D. per-construct emitters** (the Lisp-comparable core) — `emit_class`, `emit_constants`, `emit_enums`, `emit_framework`, `emit_functions`, `method_filter`, `lib` | 7,549 | **3,517** | the like-for-like comparison |
| | 24,435 | 11,387 | |

**The excess is not bloat.** TypeScript's Lisp-comparable core (group D) is 3,517
production lines — **smaller than every Lisp target's production total** (chez
5,048 · sbcl 5,955 · racket 6,938 · gerbil 7,093). The 2× headline is groups A+B
(5,835 production lines of genuinely new capability: a typed surface and a
four-table Swift bridge) plus group C's self-declared third registry copy.

Two things TypeScript's newness bought that matter to the design:

- It is the only target with **two renderers over one resolved surface**
  (`class_surface.rs` feeding both `emit_class.rs` and `emit_dts.rs`, plus
  `imports.rs` shared by both), explicitly so they "provably cannot drift".
- It carries the **most reporting-for-honesty machinery** — `degradation_report`,
  `renamed_protocols`, `slot_report`, `deferred_fallible`, `deferred_nominal`,
  `nominal_deferral_counts`, `WriteOnceEmitter` — because it is the target that hit
  the silent-loss failures (E3's 17 lost Matter classes).

TypeScript also has the highest test share (55%) and the highest comment share
(46% of production), which is consistent with it being the target where the
architecture's costs were felt most recently.

---

## 8. Q8 — The residual: what would remain as hand-written Rust?

An estimate with reasoning, not a measurement. Assume the design of the root
brief: a whole-corpus transform producing an instance-level projection model, per
target, with per-target authored rules and templates over a shared meta-schema.

| target | prod today | template (emitted text) | rules (per-target semantics) | **hand-written Rust residual** | reasoning |
|---|---:|---:|---:|---:|---|
| racket | 6,938 | ~15 KB / 536 literals | contract mapping, ffi2/`ffi/unsafe` seam, predicate emission | **~700–1,100** | E2 hash, E4 naming, the contract-string mapper (`map_param_contract`/`map_return_contract` are per-`TypeRef` tables — rules), `GeoStruct`/`NativeSig` ABI collapse |
| chez | 5,048 | ~10 KB / 383 literals | `(except (chezscheme) …)` policy, `foreign-procedure` shapes | **~600–900** | E5's 1,715-entry table becomes authored data but the intersect-sort-dedup stays host code |
| gerbil | 7,093 | ~13 KB / 494 literals | `:std/foreign` shapes, `g:defmethod` surface | **~900–1,300** | E6's sharding (chunking + variable file set + directory clearing) is irreducibly imperative |
| sbcl | 5,955 | ~9 KB / 287 literals | CLOS/MOP projection, `defgeneric` lockstep | **~700–1,000** | `width_mask`/`format_enum_value` bit arithmetic; superclass-before-subclass total order |
| typescript | 11,387 | ~24 KB / 573 literals | `.d.ts` type surface, override widening, protocol binding | **~1,800–2,600** | E3's `case_tag`, `ClassFileStems`, nine `imports.rs` grouping builders, four global ABI tables |
| **shared** | 866 live | — | meta-schema, engines | **~1,200–1,800** | E4 naming (251), `CodeWriter`/`FileEmitter` (121), topological + DFS orders, the transform engine, the template engine, the model types |
| **total** | **37,287** | **~71 KB** | | **~5,900–8,700** | |

That is a **4.3×–6.3× reduction in hand-written Rust**, with the caveat that
~1,491 lines of authored `.apiw` become ~3,000–6,000 (rules + construct vocabulary
+ the curated tables of E1/E5/E7 promoted out of Rust), and 70 KB of templates
appear as files. The residual is dominated by six things, all of them named in
§2.1: content hashing, identifier formation, bit-level disambiguation,
toolchain-limit partitioning, whole-file accumulation, and the curated
compiler-rejection tables.

**The walk-away check.** The reduction is real but it is *not* "14k LOC of
imperative Rust per target becomes rules + templates". It is closer to: **~85% of
each emitter's decision logic becomes declarative rules over a model; ~4% was
already template text; ~10–20% stays as host Rust because it is arithmetic, string
scanning, or accumulation.** The gain the root brief names as primary — *form*,
provenance from a derivation trace, and a reviewable model as the diff surface — is
supported by the evidence. The gain it names as secondary — mass — is supported at
about half the headline, because half the headline is tests, and a rules-plus-
templates architecture does not obviously need fewer tests. **Whether the test mass
moves, shrinks, or grows is the biggest unmeasured risk in the charter, and no
in-repo evidence bears on it.**

---

## 9. Unclassified and undetermined

Recorded as residual rather than folded into a tidy total.

1. **The render/decision boundary is a 4.3%–17.0% bracket, not a number**
   (§1.1). Resolving it needs a per-line judgement on ~4,000 mixed lines.
2. **The redundancy figure is a 9.6%–25% bracket** (§6.1) — three methods, three
   answers, all reported.
3. **Whether the corpus goldens *currently* pass could not be determined here.**
   `target/` does not exist in this workspace and `resolved.kdl` is absent for all
   153 families, so `cargo test` would need a cold build plus an
   `apianyware-analyze` run. The audit establishes statically that the tests
   short-circuit; the *dynamic* evidence that they fail once materialised is
   `sister-target-goldens-stale-against-the-corpus-k29`'s measurement, cited, not
   reproduced. Per the leaf's instruction, this is stated and stopped at.
4. **Generated-output volume was not measured.** The bindings are gitignored and
   absent, so "N lines of generated source per K lines of emitter" — the most
   natural leverage ratio — is unavailable without running the pipeline. The
   emitted-literal payload (§2.2) is the substitute measure.
5. **Bundler crates (9,575 LOC across five `bundle-*`) were not classified.** They
   are outside the leaf's subject (`emit-*`), but the charter's "adapter + docs"
   scope touches them; `bundle-sbcl` in particular has no `bundle.rs` at all
   (`dump.rs`/`stub.rs`/`vendor.rs` instead), suggesting the bundler surface is at
   least as divergent as the emitter surface.
6. **`emit-ocaml`'s internal anatomy was not audited** — only its size (15,153 LOC)
   and its grove's sister-target findings. It is a live workspace; a full audit
   would risk reading a half-finished state as evidence.
7. **`Struct.fields` has zero emitter readers** yet structs are emitted
   (`emit_struct.rs` in sbcl, `structs/` dirs in chez/gerbil). Whether struct field
   layout is genuinely unused or reached by another route was not chased down.
8. **The 10,807 lines of production comments were not classified.** Much of it is
   design rationale that an ADR or a rule's provenance field would carry, but how
   much would survive a rewrite is a judgement the audit did not make.

---

## 10. Questions for k3

Derived from the escape-hatch inventory (§2) and the statefulness list (§3). These
are the things the prior-art survey must find out; each names why the audit could
not settle it.

### On the escape hatch (the crux)

1. **How do shipped model-transform codegen systems handle "what the downstream
   compiler rejects"?** E1 is 51 curated entries per target discovered by running
   `swift build`. Does any surveyed system have a first-class *feedback* channel
   from a downstream compiler back into the model, or do they all park it as
   authored suppression data? Post-mortems specifically: did the suppression table
   rot, and how was that detected?
2. **What escape-hatch shape survived contact with a real corpus?** Named
   candidates to look for and *rank by post-mortem outcome*: (a) host-function
   registry callable from rules and templates; (b) a general-purpose expression
   language embedded in the rule engine; (c) a staged pipeline where imperative
   passes run between declarative ones; (d) "compute it upstream, in the fact
   base". The audit's six hard escapes (§2.1) split across all four.
3. **Where did systems put derived-identifier computation?** E4 is character-level
   scanning with a curated acronym table, and §2.3 shows collision resolution
   *depends* on derived names existing as model nodes. Is "identifiers are computed
   by host functions during transform, then are first-class model nodes" the
   settled answer, or did anyone make naming declarative — and at what cost?
4. **Did any system tolerate a data-dependent output file set?** E6's shard count
   is a function of corpus size and a downstream toolchain's performance limit.
   Template engines usually assume one template → one file. What broke for the ones
   that allowed N?
5. **What was the escape hatch's measured *share*?** The audit estimates 10–20% of
   each emitter stays host code (§8). Do post-mortems report a comparable figure,
   and did it grow over time? A system whose escape hatch grew to 50% is the
   failure mode this design must be able to see coming.

### On statefulness

6. **How were whole-corpus passes expressed?** §3.1 lists nine, including three
   ownership registries, a global generics union, and a whole-corpus
   `synthetic_init_blocklist`. Is "the transform is a whole-corpus function; the
   renderer is per-node" the standard shape, or do systems stage
   global-then-local explicitly?
7. **How were per-file accumulators handled** — E5's import spec, §3.3's
   `imports.rs` grouping, racket's `provide/contract` block that must precede the
   definitions it names? Did any system give the renderer a *deferred region* /
   two-pass emit, or is "compute the header in the transform" universal?
8. **How was deterministic total ordering guaranteed?** §2.3's `ordered_classes`
   breaks ties by IR order purely so goldens stay stable. Datalog yields sets. What
   do surveyed systems do about output determinism, and did any of them get bitten
   by non-determinism in review diffs?

### On the model and its verification

9. **What did the projection model look like on disk, and was it committed?** The
   root brief's Q1 makes it instance-level and Q2 names it. §1.4 shows five hand-
   built local versions. Do post-mortems report the model being reviewed as a diff
   surface (the charter's claimed gain), and did its *size* become a problem at
   corpus scale (153 frameworks, ~6,500 selectors, ~40,000 methods)?
10. **How was equivalence proven during a transform-and-template migration?**
    §5.3 is the audit's most uncomfortable finding: the repo's usual instrument is
    inert by default, covers a five-class fixture, and is absent for chez. What did
    surveyed migrations use — golden output diff, round-trip through a compiler,
    differential execution, or nothing? Which of those caught real regressions?
11. **How much test code did the rewritten systems carry, before and after?** §8
    flags this as the charter's biggest unmeasured risk: 49.2% of today's mass is
    tests, and no in-repo evidence says whether rules and templates need fewer,
    the same, or more.

### On the vocabulary boundary

12. **Where did systems draw the shared-meta-schema / per-target-vocabulary line,
    and did it hold?** §4.1 gives the audit's empirical answer for the IR: 30
    fields read by all five, 5 by exactly one (all TypeScript), 14 by none. Do
    post-mortems report the shared core creeping — and what pulled on it?
13. **How was authored per-target data wired into generation?** §4.2 is stark: the
    1,491-line `.apiw` target model has zero emitter readers, and TypeScript has
    none at all. A transform reading authored vocabulary would be the first
    generation-side consumer. What did systems do about staleness between authored
    rules and a moving fact base, and about a target that never got its authored
    layer?
14. **What happened to facts that were neither shared mechanism nor target
    semantics?** §6.3 finds platform truth (`is_libdispatch_unexported`, the
    framework path convention) and analysis-tier heuristics (`is_generic_type_param`,
    `is_family_match`, the geometry set) duplicated across targets — a category
    ADR-0011 does not address. Do surveyed systems distinguish "wrong domain" from
    "legitimately per-target", and does any of them have a mechanism that forced
    the distinction?
