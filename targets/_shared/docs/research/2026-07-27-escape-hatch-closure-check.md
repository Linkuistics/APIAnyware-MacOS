# Escape-hatch closure check — every site in the audit against M1–M5

**Status:** research finding (grove `language-model-transforms`, leaf
`escape-hatch-closure-check-k7`). Consumed by `write-handoff-doc-k5`.
**Date:** 2026-07-27.
**Input:** [`2026-07-26-emitter-anatomy-audit.md`](./2026-07-26-emitter-anatomy-audit.md)
§2.1 / §2.3 / §3 supplies the site list;
[`2026-07-26-model-transform-codegen-prior-art.md`](./2026-07-26-model-transform-codegen-prior-art.md)
§10.1 defines M1–M5 and sets the check; `plan-mechanism-k4` Q1 adopts the repertoire with three
riders and records closure as **provisional**. This leaf makes it assertable or names what fails.
**Method:** read-only static inspection of the five `emit-*` crates, the shared `emit` substrate,
the `generate` CLI, and `platforms/macos/api/{AppKit,Foundation}/annotations.apiw`, on the
`language-model-transforms` jj workspace at `ouuzttwxlxqx 934e844e`. No code, test, or dependency
changed; no ADR minted; `CONTEXT.md` untouched (charter Q6).

> **How to read this doc.** Every site carries an **M-tuple** with an ordering, per k4 Q1's third
> rider — `M2 → M1` means the M2 result is the M1 lookup's key, so M2 must run first. Every claim
> names the file and line it was read from. The audit is read-only input and was not re-measured;
> the places this check **disagrees** with k2, k3 or k4 are collected in
> [§9](#9-where-this-check-disagrees-with-k2-k3-or-k4) and flagged ⚠ where they appear.
> This document **decides nothing** — the repertoire's final wording is `write-handoff-doc-k5`'s.

---

## Verdict

**The escape-hatch risk is retired to engineering.** Every site in k2 §2.1, §2.3 and §3 maps into
M1–M5. **No site maps to none of them, and no sixth mechanism is required.**

That verdict is not free. It holds **only with three amendments to how M1, M4 and M5 are stated**,
each forced by a site the definition as written does not cover:

1. **M1 has two modes and its definition names only one.** "Authored declarative data, keyed by a
   path or declaration identity into the model" covers E1 and E7. It does **not** cover E5's
   1,715-entry `chez_builtins.txt`, E4b's 27-entry `KNOWN_TOKENS`, or E3's `RESERVED_MODULE_STEMS`
   — three authored tables keyed on the **emitted identifier**, not on any model node, and consumed
   as an operand of an M2 host function. Call these **table mode**; the definition must cover them
   or three of the seven hard escapes map to nothing. ([§2.1](#21-m1-has-two-modes))
2. **M5 must be desired-state, not append-only.** protoc's `CodeGeneratorResponse` and
   `windows-bindgen` return files to *write*; neither has a delete verb, because neither owns its
   output tree. E6 does (`remove_dir_all` at `emit_generics.rs:148`). Stated as "the renderer
   returns the complete file set for a directory and the driver makes the directory match", the
   reclamation is free; stated as protoc states it, it is unexpressed. ([§2.2](#22-m5-must-be-desired-state-not-append-only))
3. ⚠ **M4 has zero sites in this repo** — including the two the prior art nominated. This is
   proved structurally, not by enumeration: `CodeWriter` is append-only, so no emitter *can* be
   using a deferred region. Closure is unaffected (a mechanism with no sites cannot fail to cover
   one), but two downstream claims are: k3 §10.1's provisional mapping of racket's
   `provide/contract` to M4, and k4 Q7's ground (ii) for choosing racket as the pilot.
   ([§2.3](#23-m4-has-zero-sites-in-this-repo))

Two coverage warnings ride with the verdict, both about what a *pilot* can observe:

- **The escapes are sparse and framework-specific, so no single framework exercises the E-list**
  (Q4's premise fails as stated — [§1](#1-method-and-the-one-place-it-had-to-deviate)). The escape
  hatch is a per-**corpus** tax concentrated in a handful of frameworks — E1's 51 entries span 17,
  and neither AppKit nor Foundation is one of them — not a tax every framework pays.
- **racket exercises fewer mechanisms than k4 Q7 recorded**: M1 override-mode and type-keyed, M2,
  M3, and M5 (list). It exercises **no M1 table-mode site**, **no M4 site**, and **no M5 (reconcile)
  site**. ([§8](#8-q5--what-the-racket-pilot-exercises-and-what-it-does-not))

---

## 1. Method, and the one place it had to deviate

k3 §10.1 sets the check as: *"for each of E1–E7 and each soft escape in §2.3, name which of M1–M5
expresses it, on paper, **against one real framework**."* The leaf brief narrows the framework to
AppKit or Foundation, "the two with measured numbers throughout k2".

⚠ **That is not satisfiable, and the reason is a finding rather than an obstacle.** The escape
sites are not uniformly distributed across the corpus; several are triggered by declarations that
exist in exactly one framework, and none of those frameworks is AppKit or Foundation.

`KNOWN_UNBINDABLE` (E1) is the sharpest case. All 51 entries, in all four emitters, name **17
frameworks — and neither AppKit nor Foundation is among them**:

| entries | frameworks |
|---:|---|
| 11 | RealityFoundation |
| 7 | WebKit |
| 4 | ImmersiveMediaSupport · SwiftUICore · Translation · VisionKit |
| 3 | MediaExtension |
| 2 | AppIntents · AuthenticationServices · CloudKit · CompositorServices |
| 1 | CoreHID · CoreVideo · IdentityDocumentServicesUI · ImagePlayground · StoreKit · `_StoreKit_SwiftUI` |
| **51** | **17 frameworks; AppKit and Foundation absent** |

The same holds elsewhere: E3's `case_tag` exists because of **Matter**'s 17 ALL-CAPS acronym
classes (`emit-typescript/src/naming.rs:184`); E5's two named collisions are `Foundation.Date` →
`make-date` and MediaExtension's `List` → `make-list` (`emit-chez/src/chez_builtins.rs:11-14`); E6
is a union over the *whole* corpus and has no per-framework existence at all.

**So the walk was run as: AppKit as the framework, with four named borrows.** AppKit genuinely
exercises E2, E4a, E7 (two of its three tables), all four soft escapes, and every statefulness
class in k2 §3. For the four it cannot reach, a named substitute framework was walked instead and
is labelled as such: **WebKit** for E1 (7 entries, the largest single-framework block, and its four
`WebPage.load` overloads exercise the E2→E1 ordering constraint in one site), **Foundation** for
E5, **Matter** for E3, **the corpus** for E6. The walk is [§7](#7-q4--the-walk-against-appkit).

The corpus IR itself was **not** available: `resolved.kdl` is gitignored and absent for all 153
families (k2 §5.3, re-confirmed — `platforms/macos/api/AppKit/` holds only `annotations.apiw`).
The walk therefore reasons over real declarations named in the emitters' own doc comments and in
the authored `annotations.apiw` overlays, not over a materialised IR. Where a claim would have
needed the IR, it is left in [§10](#10-what-this-check-did-not-settle) rather than estimated.

**Reproducing the measurements taken here.** Everything else is a file read at a cited line.

```sh
# §1  KNOWN_UNBINDABLE distribution by framework (any one target; all four agree)
awk '/const KNOWN_UNBINDABLE/,/^\];/' targets/racket/tools/emit-racket/src/trampoline.rs \
  | grep -o 'aw_[a-z]*_swift_[a-z]*_[A-Za-z_]*' | sed -E 's/aw_[a-z]+_swift_(init|m)_//' \
  | sed -E 's/_.*//' | sort | uniq -c | sort -rn

# §3 E1  the four tables are key-identical once the target prefix is stripped
for t in racket chez gerbil sbcl; do
  awk '/const KNOWN_UNBINDABLE/,/^\];/' targets/$t/tools/emit-$t/src/trampoline.rs \
    | grep -o '"aw_[a-z]*_swift_[a-z]*_.*"' | sed -E 's/"aw_[a-z]+_swift_/"/' | md5; done
# → 4b78965e8b2096a00890fc8d14c1bafb, four times

# §6  authored-table sizes
wc -l < targets/chez/tools/emit-chez/src/chez_builtins.txt                       # 1715
awk '/^const KNOWN_TOKENS/,/^\];/' targets/_shared/tools/emit/src/naming.rs \
  | grep -o '"[A-Za-z]*"' | wc -l                                                # 27

# §8  racket's authored tables, production regions only
for f in targets/racket/tools/emit-racket/src/*.rs; do
  t=$(grep -n '#\[cfg(test)\]' $f | head -1 | cut -d: -f1); t=${t:-999999}
  awk -v lim=$t 'NR<lim && /^(pub )?(static|const) [A-Z_]+/ {print FILENAME":"NR}' $f; done
grep -rn 'include_str!' targets/racket/tools/emit-racket/src/                    # (none)
```

---

## 2. The repertoire as tested, and the three amendments it forces

### 2.1 M1 has two modes

M1 as k3 §10.1 states it: *"authored declarative data, keyed by a path or declaration identity into
the model"* — citing uniffi `exclude`, haskell-gi `set-attr`, SWIG `%feature`, bindgen blocklist.
Every one of those cites is an **override**: it addresses a node the model already has and changes
a fact about it.

Three of this repo's authored tables are not that shape:

| table | size | key | consumer |
|---|---:|---|---|
| `chez_builtins.txt` (E5) | 1,715 | a `(chezscheme)` identifier | `is_chezscheme_builtin` (`chez_builtins.rs:48`) |
| `KNOWN_TOKENS` (E4b) | 27 | an acronym/brand token | `longest_token_at` (`_shared/emit/naming.rs:236`) |
| `RESERVED_MODULE_STEMS` (E3) | 6 | a module filename stem | `ClassFileStems::new` (`emit-typescript/src/naming.rs:220`) |

None of these keys addresses a model node. `make-date` is not a declaration — it is a *rendering*
of one, and the table is consulted on the **output** side, after projection has produced the name.
`KNOWN_TOKENS` is consulted mid-scan over a raw byte string, before any name exists at all. These
are authored data used as an **operand of an M2 host function**, not as an override on a node.

⚠ **This is a gap in M1's write-up, not a sixth mechanism.** The prior art has the shape and k3
recorded it under a different question: uniffi's `names.rs` carries *"`heck` casing plus a 35-entry
keyword table"* (k3 §9 Q3), which is exactly table mode, filed under derived identifiers rather
than under the escape hatch. Both modes are shipped; only one made it into M1's sentence.

The distinction matters for the design because the two modes have different homes and different
authors. Override-mode data is per-declaration and belongs beside whatever owns the declaration
(GIR's siting rule, k3 §9 Q13). Table-mode data is a property of the **target language or its
runtime**, is regenerable by running the target's own toolchain (`chez_builtins.rs:26-32` ships the
recipe), and must be authorable by a target expert who does not read Rust — which is precisely the
contributor-filter benefit k4 Q4 built the whole external-templates argument on. A design that
externalises only override-mode data leaves 1,748 entries of table-mode data baked into Rust.

**Amended M1 for the handoff doc:** *authored declarative data, either keyed into the model by path
or declaration identity (**override mode**) or consulted as a set/table by a host function
(**table mode**).*

### 2.2 M5 must be desired-state, not append-only

M5 is *"a data-dependent output file list from the renderer"*, cited to protoc's
`CodeGeneratorResponse` and `windows-bindgen`. Both return a list of files to **write**. Neither
has a delete verb, and neither needs one: a protoc plugin does not own its output directory.

E6 does. `write_global_generics_module` (`emit-gerbil/src/emit_generics.rs:137`) clears the shard
directory before writing:

```rust
let shard_dir = output_dir.join(GENERICS_MODULE_STEM);
if shard_dir.exists() { std::fs::remove_dir_all(&shard_dir)?; }   // :147-149
std::fs::create_dir_all(&shard_dir)?;
let chunks: Vec<&[String]> = selectors.chunks(GENERICS_SHARD_SIZE).collect();   // :152
```

with the reason stated at `:135-136`: *"so a regeneration with fewer shards leaves no stale
`generics/NNN.ss` behind."* A stale shard is not inert — the facade re-exports shards `000..N-1`
(`:116-124`), so a leftover shard is an orphan file that a hand-written import could still reach,
and a *missing* one breaks the facade. The invariant is "the directory equals the computed set",
which is strictly stronger than "these files were written".

Two more sites want the same contract from the other side. `WriteOnceEmitter`
(`emit-typescript/src/emit_framework.rs:104`) carries a `BTreeSet<String>` of filenames and makes a
second write to one name a hard error — added after E3's non-injective-stem bug silently lost 17
classes. And racket's struct-file emission (`emit-racket/src/emit_framework.rs:74-87`) renames on
collision using a `used_filenames` accumulator. All three are the same concern: the emitted file
set is a computed object with an identity, not a stream of writes.

⚠ **This is free if designed in, and unexpressed if not.** k4 Q4 already adopted
`Vec<(path, content)>` as the renderer's output contract, which is the hard half. The amendment is
one clause on what the *driver* does with it.

**Amended M5:** *the renderer returns the complete `Vec<(path, content)>` for an output directory,
and the driver reconciles the directory to it — writing, overwriting, and removing what is no
longer in the set.* Two grades are worth distinguishing when reasoning about coverage, and this
document uses them as local notation:

- **M5 (list)** — the file set is data-dependent. Present in **all five targets**.
- **M5 (reconcile)** — the set's *cardinality* is fixed by a non-model fact (a downstream
  toolchain's performance limit) and the previous run's output must be reclaimed. **gerbil only.**

### 2.3 M4 has zero sites in this repo

M4 is *"a named insertion point / deferred region in the emitted text"*, cited to protoc's
`@@protoc_insertion_point`. k3 §10.1's provisional mapping assigns racket's `provide/contract` to
it; k4 Q7 makes that racket's second of four grounds for pilot selection — *"it holds the repo's
only clean **M4** site."*

⚠ **Neither claim survives contact with the code.**

**The structural proof.** `CodeWriter` (`targets/_shared/tools/emit/src/code_writer.rs:11-71`) is
`buffer: String` plus `indent_level`/`indent_str`. Its entire mutating API is `line`, `line_fmt`,
`blank_line`, `raw`, `raw_line`, `indent`, `dedent`, `finish` — every one of which appends. There
is no marker type, no `insert`, no splice, no handle into the buffer. **An append-only writer
cannot express a deferred region**, so no emitter can be using one, without inspecting a single
call site.

The bypass objection is closed by measurement. Across all five `emit-*` crates, the shared `emit`
substrate and the `generate` CLI, **production regions contain zero occurrences** of
`replace_range`, `insert_str`, `String::splice`, or any `PLACEHOLDER` / `insertion_point` marker:

```sh
for f in $(find targets/*/tools/emit-* targets/_shared/tools/emit \
                targets/_shared/tools/generate-cli -name '*.rs'); do
  t=$(grep -n '#\[cfg(test)\]' $f | head -1 | cut -d: -f1); t=${t:-999999}
  awk -v lim=$t 'NR<lim && /replace_range|insert_str|\.splice\(|PLACEHOLDER|insertion_point/ \
    {print FILENAME":"NR}' $f; done          # → no output
```

The one construct that *looks* like an insertion point is not one: k2 §2.2's `__CALL__` / `__VAL__`
`str::replace` (`emit-chez/src/trampoline.rs:1809-1816`, and the gerbil/sbcl/racket twins) rewrites
a string literal with values already in hand, in the same expression. That is template
substitution — the substituends exist before the literal is touched — and it is M2 output feeding a
template, which is exactly the shape k4 Q4 replaces with Askama.

**The three candidate sites, each verified.** All resolve by k3 §9 Q7's *first* answer — compute
the header in the transform — which is the answer uniffi calls its stated ideal (jhugman's
*"a principled approach for imports"*, k3 §1.6):

| candidate | computed at | rendered at | verdict |
|---|---|---|---|
| racket `provide/contract` + predicates | `build_export_contracts` called `emit_class.rs:400`; `collect_predicate_class_names` called `:420` | `emit_header` `:429`, `emit_class_predicates` `:446`, `emit_provide` `:449` | no deferred region — strictly linear |
| chez `(except (chezscheme) …)` | `exports` built `emit_class.rs:329` | `chezscheme_import_spec(&exports)` `:342` | the export set precedes line 1 by construction |
| ts `import { … } from '…'` blocks | `build_import_map`/`merge_type_imports` `emit_class.rs:353-359` | `render_import_blocks` `:360`, `render_type_import_blocks` `:361` | imports rendered *before* the body they describe |

racket's ordering is explicit in the source comment at `emit_class.rs:417-419`: *"Collect class
names for predicates (must be defined before provide/contract references them)"* — an ordering
constraint on a **transform** step, discharged before rendering starts. The `provide/contract`
block is not back-patched into a reserved region; it is emitted third, from an export list computed
first.

**Why this is a positive result, stated so it is not mistaken for a gap.** k3 §9 Q7 found five
shipped answers to per-file accumulation and called it *"the one statefulness question the prior art
has not converged on"*. This repo has already converged, on the answer uniffi rates highest, in all
three of its accumulator sites independently. That is a property of the design worth recording, not
an accident to be corrected.

**What it costs.** M4 is a mechanism the migration cannot validate, because there is nothing to
migrate onto it. The handoff doc must either drop it from the repertoire or keep it explicitly
marked *reserved and unexercised* — a choice this document does not make. Keeping it has one
non-obvious argument in favour: dropping it loses the record that compute-in-transform was
*achieved*, and the pressure toward a deferred region reappears the moment a target needs a trailer
whose content depends on the body (a `#lang` reader extension, a module footer, a C-style forward
declaration block). Should that arrive, M4 is protoc's shipped mechanism and adopting it is not new
research.

---

## 3. Site by site — the hard escapes (k2 §2.1)

Tuples read left to right in execution order.

### E1 — `KNOWN_UNBINDABLE`

**`M2 → M1(override, declaration-keyed) → M3`.** `known_unbindable`
(`emit-racket/src/trampoline.rs:1669`) computes the content-addressed entry name via
`init_entry_name`/`method_entry_name`, then looks it up. The lookup is called from `classify_method`
(`:1691`), the disposition pass that partitions each method into `Method` / `Init` / `Deferred`
(`MethodDisposition`, `:1576`) and counts each deferral under its `DeferReason` — an M3 pass whose
output is a model field.

The **ordering is load-bearing and is the repertoire's clearest instance of k4 Q1's third rider**:
M2 must run before M1, because the M1 key *is* the M2 result. A design that treats authored
overrides as an input-side pre-pass — the natural reading of uniffi `exclude`, which keys on
source-level `Name` / `Type.method` — cannot express E1 at all, because the key does not exist until
the transform has computed it.

⚠ **Measured, and it strengthens k3 §9 Q14 from a claim into a mechanism.** k3 found that E1 is
Swift-adapter-toolchain truth rather than per-target data, because *"the rejecting compiler is the
same compiler"*. Stripping the target prefix from all four tables' keys yields **byte-identical key
sets** (md5 `4b78965e8b2096a00890fc8d14c1bafb`, four times; 51 entries each). So the overload hash
that discriminates `WebPage.load` ×4 is computed over the *Swift* signature and is
target-independent. **Sharing E1 once is mechanically achievable, not merely principled** — the key
is already the same string modulo a target prefix that is a rendering concern.

**Keying:** declaration-keyed, with a *derived* key. Neither SWIG's `%feature` nor uniffi's
`exclude` has a derived key; both address source-level names. Recorded as a rider on the split, not
a fourth kind.

### E2 — FNV-1a content-addressed identifiers

**`M2`, alone.** `overload_hash` / `method_hash` (`emit-racket/src/trampoline.rs:743`/`:1846`, and
the three sibling pairs) are pure functions of the printed param/return shape. No authored data, no
accumulation, no ordering constraint of their own — but they are the *precondition* of E1, and
their results must be first-class model fields for E1's lookup and for the `@_cdecl` entry the Swift
adapter emits. Confirms k3 §9 Q3's settled answer with no qualification.

### E3 — `case_tag` and `ClassFileStems`

**`M1(table) → M2 → M3 → M5(list)`.** Four mechanisms in one site, in a fixed order:

1. **M1 (table mode)** — `RESERVED_MODULE_STEMS` (6 entries, `emit-typescript/src/naming.rs`)
   pre-seeds the occupancy map so a class named `Enums` is tagged rather than colliding with
   `enums.ts` (`:218-223`).
2. **M2** — `case_tag` (`:264`) is bit arithmetic over the ASCII-uppercase bitmap, eight bits per
   byte LSB-first. Pure, no table.
3. **M3** — `ClassFileStems::new` (`:216`) accumulates a per-framework occupancy count over
   lowercased names, then assigns every member of a colliding group a tag (`:227-238`). Note the
   deliberate design constraint at `:205-208`: *every* member is tagged, not just later ones,
   because "which class is first" would otherwise depend on IR order — a determinism requirement of
   exactly the shape k3 §9 Q8 found the prior art has no guidance on.
4. **M5 (list)** — the stem becomes the output path; the file set is one `.ts` + one `.d.ts` per
   class, plus the residual-gated aggregates.

The stem must be a **model field**, because `emit_class.rs`, `emit_dts.rs` and the barrel all read
it and `ClassFileStems::stem` panics on a name it was not built from (`:247-254`). This is k2 §2.1
E4's load-bearing observation — derived identifiers are first-class nodes — applying to a second
identifier family.

### E4 — Identifier formation

⚠ **This is two sites, not one**, and the split changes the pilot's coverage:

- **E4a — `split_camel_case`** (`_shared/emit/naming.rs:10`) and its wrapper `camel_to_kebab`
  (`:58`): a byte-level boundary scan handling acronym runs and digit boundaries. **Pure M2, no
  authored table.** Used by racket, chez, gerbil and typescript.
- **E4b — `acronym_aware_kebab`** (`:167`) → `acronym_aware_words` (`:207`) → `longest_token_at`
  (`:236`) over `KNOWN_TOKENS`: **`M1(table) → M2`**. Used by **sbcl only**
  (`emit-sbcl/src/naming.rs:25,34,62,68,89,119,145,148,173`); no other emitter references it.

Both produce model fields. The consequence for the design is E4b's alone: it is the **only**
table-mode M1 site in the Lisp family, and it lives in the *shared* crate while being consumed by
exactly one target — a small instance of the same misplacement k2 §1.2 found in
`ffi_type_mapping.rs`.

### E5 — `chezscheme_import_spec`

**`M3 → M1(table) → M2`.** `chezscheme_import_spec` (`emit-chez/src/chez_builtins.rs:56`) takes the
file's complete `exports` list — accumulated in the transform, `emit_class.rs:329` for struct files,
the class and function paths at `:722` and `emit_functions.rs:143` — filters it through
`is_chezscheme_builtin` (`:48`, a 1,715-entry `HashSet` from `include_str!`), then sorts, dedups and
formats (`:62-68`).

**Not M4**, verified: the export list is complete before the import line is written, so there is no
deferred region. This is k3 §9 Q7 answer #1 with the authored table as an operand — the "authored
per-target import spec" row of that table (which k3 attributed to *us*) is the M1 component, not a
separate answer.

**Keying: table mode.** The key is a target-language identifier (`make-date`), produced by
projection, not present in the model. The regeneration recipe is in the module doc
(`:26-32`) — `(environment-symbols (environment '(chezscheme)))` piped through `sort -u` — which
makes this authored data that is *derived from the target's own toolchain*, the cleanest example in
the repo of why table mode wants to be an authored artifact rather than a Rust `const`.

### E6 — Generics sharding

**`M3 → M2 → M5(reconcile)`.** `collect_global_surface_selectors`
(`emit-gerbil/src/emit_generics.rs:65`) unions every distinct instance-surface selector across all
loaded frameworks into a `BTreeSet`, including conformed-protocol methods via a `ProtocolRegistry`
built over the same framework set (`:66`); `write_global_generics_module` (`:137`) chunks by
`GENERICS_SHARD_SIZE = 256` (`:57`), clears the shard directory (`:147-149`), writes N shards, then
writes a facade whose body is a function of N (`:160-163`).

Two properties the repertoire must carry and one it did not:

- The partition constant is a **non-model fact** — `:50-56` gives the reason: 6,496 selectors made a
  ~54 MB macro-expanded unit, and Gambit's `gsc -target C` is superlinear in module size,
  independent of `-O` (ADR-0023: a 37.8 MB unit ran >67 min unfinished). It is documented
  *"Tunable"*. Under k3 §9 Q6's taxonomy this is neither downward propagation nor upward
  accumulation; it is a per-target constant the transform reads, which makes it authored data
  (M1) in the design even though it is a `const` today.
- N is a function of corpus size, so the file **count** is data-dependent — plain M5 (list).
- The `remove_dir_all` is the site that forces [§2.2](#22-m5-must-be-desired-state-not-append-only).

### E7 — Curated per-symbol admissions and suppressions

**`M1(override, declaration-keyed) → M3`** for all five tables. They differ in the *completeness of
the key*, which is where the finding is:

| table | entries | key | key complete? |
|---|---:|---|---|
| `ADMITTED_COMPLETION_HANDLER_SELECTORS` (`method_filter.rs:284`) | 1 | bare selector | ⚠ **no** — owner not qualified |
| `ADMITTED_OPAQUE_POINTER_FUNCTIONS` (`:339`) | 8 | C symbol name | yes (globally unique by C linkage) |
| `ADMITTED_OPAQUE_POINTER_METHODS` (`:362`) | 1 | bare selector | ⚠ **no** — owner not qualified |
| `is_libdispatch_unexported` (`shared_signatures.rs:34`, ×4) | 5 | C symbol name | yes |
| `UNBUNDLED_FRAMEWORKS` (`function_table.rs:68`) | 1 | framework name | ⚠ a **third grain** |

The two bare-selector keys are the interesting ones, because the code knows the key is incomplete
and compensates *differently* in each case. For the completion handler, `emit_class::emit_body`
derives the actual signature from the IR at emit time and *"panics loudly if a future corpus
regeneration ever disagrees"* (`method_filter.rs:279-283`) — a runtime tripwire standing in for a
key. For `CGContext`, the doc asserts corpus-uniqueness by measurement instead
(`:355-359`).[^corpus]

⚠ **This is the "site that fits neither cleanly" the leaf brief asked about, and it is a finding
about *key completeness*, not about which of the two keyings applies.** SWIG's `%feature` and
uniffi's `exclude` both address a *fully qualified* declaration. Three of our five E7 tables do not,
and two of them ship a bespoke compensation for it. The design's M1 must **require** a complete
declaration identity and make partial keys unexpressible; otherwise the tripwires get re-invented
per table, which is the sixth-emitter tax at table grain.

`is_libdispatch_unexported` is classified here for completeness but should not survive as an M1
site at all: per k2 §6.3 and k3 §9 Q14 it is **platform truth** about a dylib's export table,
mechanically discoverable, and belongs in the IR at the Extraction tier — k3 §9 Q2's option (d),
"compute it upstream in the fact base". Its presence in four emitters is a domain misplacement, not
an escape.

[^corpus]: The `CGContext` doc comment says *"grep -c '\"selector\" \"CGContext\"' across all 252
frameworks' `extracted.kdl` = 1"*. This workspace has **153** families under
`platforms/macos/api/`. The count is stale relative to today's corpus; the uniqueness claim is
untested here (`resolved.kdl`/`extracted.kdl` are gitignored and absent) and is recorded in
[§10](#10-what-this-check-did-not-settle) rather than repaired.

---

## 4. Site by site — the soft escapes (k2 §2.3)

These are rule-shaped, so they belong in the transform rather than the hatch. k4 Q2 admits `ascent`
as **one pass kind inside** the staged pipeline; an `ascent` pass is therefore a flavour of M3, and
is written **M3(ascent)** below.

| site | tuple | note |
|---|---|---|
| Transitive protocol reachability (`emit_protocol.rs:185 reaches_bindable_surface`) | **M3(ascent)** | canonical two-rule closure. The `visiting` cycle guard and the `mapper.is_known_protocol` fallback both **disappear**: the guard is what a fixpoint gives free, and the fallback exists only because `by_name` holds one call's protocols (k2 §2.3). A whole-corpus transform deletes it — and that deletion is on Q6's deviation list, because it changes how cross-framework ancestors resolve. |
| `conformance_closure` (gerbil `protocol_registry.rs:85`, sbcl `:108`, ts `protocol_graph.rs:201`) | **M3(ascent)** | 15 production lines, identical in three targets. The clearest ADR-0047-precedent site in the repo. |
| Name-collision resolution (racket `emit_class.rs:254-426`) | **M2 → M3** | set algebra over *derived* identifiers — `class_method_disambig`, `class_property_disambig`, and `swift_native.exclude(&objc_names)` at `:414-415`. The ordering is the constraint: M2 must have made the derived names model nodes before M3 can do set algebra on them. This is E4's dependency, restated as a soft escape. |
| Superclass-before-subclass order (`emit-sbcl/src/emit_framework.rs:610`/`626`, ts `class_graph.rs:308`/`323`) | **M3(ascent) → M3** | ⚠ two passes, not one. The *partial* order (`inherits` within a framework) is relation-shaped and `ascent` states it; the *total* order — stable DFS pre-order over `fw.classes` with ties broken by IR index (`ordered_classes` builds the index map at `class_graph.rs:309-314`) — is not, because datalog yields sets (k3 §9 Q8). Splitting the tuple is what keeps `ascent` earning its place here instead of being discarded for the whole site. |

**No soft escape needs M1, M4 or M5.** All four are transform-internal.

---

## 5. Site by site — statefulness (k2 §3)

### 5.1 Whole-corpus (k2 §3.1)

All nine live in `_shared/tools/generate-cli/src/generate.rs` today because `emit_framework` runs
per framework and cannot see the others. Under a whole-corpus transform that constraint evaporates,
which is why every one is M3.

| pass | site | tuple |
|---|---|---|
| framework ordering | `generate.rs:74 topological_sort` | **M3** today; ⚠ k3 §9 Q6 says it should be a **model property**, not a pass (protoc guarantees topological order before any plugin runs). Reclassify as option (d) in the design. |
| gerbil `ClassRegistry` | `:130` | **M3** (upward accumulation) |
| gerbil `ProtocolRegistry` | `:136` | **M3(ascent)** — the `inherits` closure |
| gerbil global generics | `:145` | E6 |
| sbcl `ClassRegistry` + `ProtocolRegistry` | `:153`, `:158` | **M3** / **M3(ascent)** |
| ts `Class` + `Enum` + `ProtocolRegistry` | `:167`, `:172`, `:175` | **M3** ×2, **M3(ascent)** ×1 — `protocol_graph.rs` calls itself *"the third copy of the ownership-registry family"* |
| ts `synthetic_init_blocklist` | `:181` → `class_graph.rs:180` | **M3** — one whole-corpus scan extending `blocked` by each offending class's `ancestors` (`:184-192`) |
| racket global dispatch + trampolines | `:294`, `:336` | **M2 → M3** — dedup is over the *printed ABI signature*, so E2's shape-printing must precede it |
| ts dispatch / inbound / trampoline / function tables | `:389`, `:455`, `:506`, `:555` | **M2 → M3** ×4, same reason |

The four reporting passes (`degradation_report`, `renamed_protocols`, `slot_report`, the deferral
counters) are **M3** passes whose results are model fields. They are not escapes; they are
observability, and they are worth naming because **Q1b's longitudinal escape-hatch ratio is the same
shape** — a whole-corpus accounting pass emitting a build artifact. The instrument k3 §10.3 says
does not exist in the prior art already has four working precedents in this repo.

### 5.2 Per-framework (k2 §3.2)

| site | tuple |
|---|---|
| Enum symbol dedup + prefix disambiguation (`emit-sbcl/src/emit_enums.rs:183 build_plan`, and chez `:112`, gerbil `:116`, ts `enum_graph.rs`) | **M2 → M3 → M3** — pass 1 groups by the *emitted* kebab symbol (so M2's formatting runs first), pass 2 walks in IR order assigning `Bare`/`Prefixed`/`Skip` against an `emitted` accumulator. Two M3 passes because pass 2 reads pass 1's whole result. |
| `ClassFileStems` | E3 |
| sbcl `generics.lisp` `defgeneric` collection (`emit_framework.rs:281`) | **M3** — collected across the framework's classes *and* their conformed-protocol flattening, in lockstep with the per-class `defmethod`s |
| sbcl load order (facade → generics → superclass-before-subclass → rest) | **M3 → M5(list)** |
| Barrel / facade / `main` re-export (all five) | **M3 → M5(list)** — ⚠ this is the site that makes M5 (list) universal; see [§8](#8-q5--what-the-racket-pilot-exercises-and-what-it-does-not) |

### 5.3 Per-file (k2 §3.3)

| site | tuple |
|---|---|
| chez import spec | E5 |
| ts `imports.rs` (nine grouping builders → `merge` → `render_*_import_blocks`) | **M3**, rendered first — **not M4** ([§2.3](#23-m4-has-zero-sites-in-this-repo)) |
| racket `build_export_contracts` + `collect_predicate_class_names` | **M2 → M3**, rendered in order — **not M4** |
| `SignatureMap` / shared `_msg-N` fallback bindings | **M3** — collected from every method in the class, hoisted to file scope |
| ts `WriteOnceEmitter` (`emit_framework.rs:104-118`) | ⚠ **maps to none of M1–M5, and correctly so** — it is not a projection mechanism but a renderer-side **invariant check** on the output file set. It is the assertion form of the M5 (reconcile) contract in [§2.2](#22-m5-must-be-desired-state-not-append-only): under a reconciled desired-state contract, a duplicate path is a malformed set and the check is structural rather than a guard bolted onto the writer. Named here so a reader walking k2 §3.3 does not find a gap where there is a category error. |

⚠ k2 §3.3 cites `build_export_contracts` at `emit_class.rs:400` and `collect_predicate_class_names`
at `:420`; those are the **call sites**. The definitions are at `:838` and `:776`, which is what k2
§6.2 cites. Both sites are real; the two sections disagree on which line to quote. Noted so a
future session does not chase the discrepancy.

---

## 6. Q3 — where M1 applies, is the site type-keyed or declaration-keyed?

k4 Q1's first rider adopts SWIG's and uniffi's independently-converged split. **Classifying every
M1 site in the repo finds the split is three-way, not two-way** — and the third kind is where three
of the seven hard escapes live.

### Type-keyed (SWIG `%typemap`)

| site | shape today |
|---|---|
| racket `map_param_contract` / `map_return_contract` (`emit_class.rs:687`/`:712`) | `match &type_ref.kind` — a per-`TypeRefKind` table written as Rust match arms. k2 §6.2 calls this *"the clearest per-target semantics in the repo"*; it is `%typemap` almost exactly. |
| `is_known_geometry_struct` (`_shared/emit/ffi_type_mapping.rs:71`) | 12 type names, `matches!` |
| racket `GeoStruct` (`native_dispatch.rs:88`) | 9 variants — the routable subset of the above |
| per-target `FfiTypeMapper` impls (`ffi_type_mapping.rs` ×5) | the type substitutions `targets/_shared/docs/emitter-contract.md` tells the next author to hand-copy |

### Declaration-keyed (SWIG `%feature` / `%ignore`, uniffi `exclude`)

E1 (derived key — see [§3](#e1--known_unbindable)); E7's five tables (three with incomplete keys —
see [§3](#e7--curated-per-symbol-admissions-and-suppressions)).

### Table mode — keyed on the emitted identifier, not on the model

E5's `chez_builtins.txt` (1,715); E4b's `KNOWN_TOKENS` (27); E3's `RESERVED_MODULE_STEMS` (6). These
are the sites [§2.1](#21-m1-has-two-modes) is about. They are **not** addressable in the model under
any keying, because their keys are outputs of projection, and no amount of choosing between
type-keyed and declaration-keyed reaches them.

### A fourth axis, already shipped and worth knowing about

`emit/pattern_dispatch::classify_pattern` keys authored `.apiw` data on a **derived pattern kind** —
a ws3 analysis-tier classification of a group of declarations, mapped to the closed `EmitConstruct`
taxonomy plus a generated identifier (`CONTEXT.md`, "Idiom catalogue + the `pattern_dispatch`
seam"). That is neither a type nor a declaration; it is a *classification*. It is dead in production
(zero callers, k2 §1.2) but it is the shipped nucleus k4 Q2 identified, and it demonstrates that
authored `.apiw` data can be keyed on a derived classification without a rule language. If the
design wants one keying vocabulary rather than a growing list, **haskell-gi's "address nodes by
path" is the generalisation that covers all four** (k3 §4.2 — eleven directives, 90% of uses one
`set-attr` verb), with type-keyed and declaration-keyed as the two common path shapes and table mode
as the explicit exception that is not a path at all.

---

## 7. Q4 — the walk against AppKit

AppKit as the corpus framework, with the four borrows [§1](#1-method-and-the-one-place-it-had-to-deviate)
names. `platforms/macos/api/AppKit/annotations.apiw` carries 124 classes and 373 annotated methods
(273 `threading`, 151 `block-param`, 73 `error-pattern`); Foundation's carries 99 classes and 418
methods.

| site | does AppKit reach it? | the declaration walked |
|---|---|---|
| **E1** | ⚠ **no** | *borrowed — WebKit.* `aw_racket_swift_m_WebKit_WebPage_load_{4808a66d,60456c20,6dde058d,77ec487a}` — four `load` overloads on one type, all `ActorIsolated`. Walk: M2 prints each overload's param/return shape → `overload_hash` distinguishes the four → the entry name is formed → M1 lookup hits → M3 records four `ActorIsolated` deferrals. Remove M2 and the four sites become one unkeyable declaration. |
| **E2** | **yes** | every AppKit class with an overloaded Swift-native member; the mechanism is target-independent and corpus-wide |
| **E3** | ⚠ **no** | *borrowed — Matter.* AppKit's 124 classes have no ALL-CAPS/aliased pair, so `occupancy[&lower] > 1` never fires and every stem is the bare lowercase. `RESERVED_MODULE_STEMS` still pre-occupies six stems, so the M1(table) component *is* live for AppKit — the M2 and M3 components are not. |
| **E4a** | **yes** | `NSTextField`, `NSGraphicsContext`, `beginSheetModalForWindow:completionHandler:` — every emitted AppKit identifier |
| **E4b** | **no** (sbcl-only path; AppKit reaches it under sbcl, not under racket) | `NSAlert` → `ns-alert` via `KNOWN_TOKENS`'s `NS` entry, which `split_camel_case` alone would render differently |
| **E5** | ⚠ **partly** | *borrowed — Foundation.* AppKit exercises the **M3** component (every chez AppKit file's export set is computed before its import line) but not the M1 branch: no AppKit export collides with `(chezscheme)`. `Foundation.Date` → `make-date` is the named collision (`chez_builtins.rs:11-13`). |
| **E6** | **as a contributor only** | AppKit's instance-surface selectors join the corpus-wide union; the shard count is a whole-corpus property with no AppKit-local existence |
| **E7** | **yes, twice** | `NSAlert.beginSheetModalForWindow:completionHandler:` is the sole entry in `ADMITTED_COMPLETION_HANDLER_SELECTORS`, and is present in AppKit's `annotations.apiw` with `block-param 1 invocation=async_copied` + `threading main_thread_only`. `NSGraphicsContext.CGContext` is the sole entry in `ADMITTED_OPAQUE_POINTER_METHODS`. Both are the bare-selector partial keys of [§3](#e7--curated-per-symbol-admissions-and-suppressions) — walking them against a real framework is what shows the key is *underspecified for exactly this corpus*, since the compensation is a panic and a stale grep. |
| **soft escapes** (all four) | **yes** | AppKit's protocol graph, its `NSView`/`NSControl`/`NSButton` inheritance chain (superclass-before-subclass), and racket's per-class disambiguation over derived names |
| **statefulness** §3.1/§3.2/§3.3 | **yes, every class** | AppKit is a dependency root for much of the corpus, so it exercises the ownership registries, the enum two-pass plan, the barrel/facade, and all three per-file accumulators |

**What the walk establishes.** Every mechanism the tuples name is reachable by real declarations,
and the two ordering constraints that matter — E2 before E1, E4 before collision resolution — are
both *visible* in a real site rather than argued: `WebPage.load` cannot be suppressed without the
hash, and racket's `swift_native.exclude(&objc_names)` (`emit_class.rs:415`) cannot run before the
derived names exist.

**What it also establishes, unhelpfully.** ⚠ **The escape hatch is not a per-framework tax.** Four
of seven hard escapes are invisible in the largest framework in the corpus. A pilot scoped to a
framework subset would exercise almost none of them and would report an escape-hatch share near
zero — the exact direction of error Q1b warns about, since the estimate is already suspected 2–4×
low. **The pilot must run the full 153-family corpus for its escape-hatch measurement to mean
anything**, which reinforces Q6 layer 0 (materialise `resolved.kdl`) from *prerequisite* to
*load-bearing*.

---

## 8. Q5 — what the racket pilot exercises, and what it does not

k4 Q7's standing requirement: *"racket exercises M1/M2/M3/M4 but **not M5** — gerbil's E6 sharding
is the repo's only M5 site, and the handoff doc must say so explicitly."*

⚠ **Both halves need correcting, in opposite directions.**

**racket does exercise M5 (list).** `emit-racket/src/emit_framework.rs:49-152` makes the output file
set data-dependent five ways: one file per class (`:60-68`); struct files only where
`generate_struct_file` returns `Some`, with a `-struct` rename driven by a `used_filenames`
accumulator on collision (`:74-87`); `enums.rkt` / `constants.rkt` / `functions.rkt` each
residual-gated (`:90-112`); protocols filtered to those with ≥1 method (`:116-131`); and `main.rkt`
generated *from the complete file set* (`:134-143`, and `generate_main_file` at `:155` takes the
file lists as parameters). k2 §5.1 already said this — *"Every aggregate file is residual-gated …
which makes the file set itself data-dependent in all five targets, not just gerbil"* — so this is a
correction to k4 Q7 that k2's own text supports.

**racket does not exercise M4** — but neither does anything else
([§2.3](#23-m4-has-zero-sites-in-this-repo)), so this is not a property of the pilot choice.

**racket exercises no M1 table-mode site.** Its only authored table in production is
`KNOWN_UNBINDABLE` (declaration-keyed override); there is no `include_str!` anywhere in
`emit-racket/src/`, and it uses `camel_to_kebab` (E4a, tableless) rather than sbcl's
`acronym_aware_kebab` (E4b). Its type-keyed data — `map_param_contract`/`map_return_contract`,
`GeoStruct` — is Rust match arms, which is exactly the form the re-cut converts to `.apiw`, so
racket does test the *type-keyed* externalisation. Table mode it does not test at all.

**Corrected coverage table.** ✓ exercised, ✗ not.

| mechanism | racket (pilot) | where it is exercised instead |
|---|:--:|---|
| M1 override, declaration-keyed | ✓ | E1 (51), `is_libdispatch_unexported` (5) |
| M1 type-keyed | ✓ | contract mappers, `GeoStruct`, `RacketFfiTypeMapper` |
| **M1 table mode** | **✗** | chez (E5, 1,715) · sbcl (E4b, 27) · typescript (E3, 6) |
| M2 | ✓ | E2 both hashes, E4a, contract/predicate name derivation |
| M3 (incl. `ascent`) | ✓ | global signature dedup, per-file export contracts, class ordering, disambiguation set algebra |
| **M4** | **✗** | **nowhere — no site in the repo** |
| M5 (list) | ✓ | five ways in `emit_framework.rs` |
| **M5 (reconcile)** | **✗** | gerbil only (E6's `remove_dir_all`) |

**The sentence the handoff doc should carry**, replacing k4 Q7's:

> The racket pilot exercises M1 in its override and type-keyed forms, M2, M3 (including `ascent`),
> and M5 (list). It does **not** exercise M1's table mode — chez's 1,715-entry `chez_builtins.txt`
> is the largest instance and sbcl's `KNOWN_TOKENS` the other — nor M5 (reconcile), which is
> gerbil's E6 alone. It does not exercise M4 because **no site in the repo does**; M4 is reserved
> and unexercised, and whether it stays in the repertoire is an open choice.

**The consequence, stated as k4 Q7's standing requirement demands** — *"whichever target pilots, the
mechanisms it lacks must be covered by paper analysis rather than discovered during migration
four."* Two now need that paper coverage rather than one:

- **M1 table mode.** The design question is where a 1,715-line authored table *lives* and in what
  format. ADR-0046 makes authored artifacts `.apiw` KDL, but `chez_builtins.txt` is a regenerated
  flat identifier list with a documented recipe (`chez_builtins.rs:26-32`), and KDL-ifying a
  machine-regenerated word list buys nothing. The handoff doc should name this as the build grove's
  first authored-layer question rather than let it surface at migration two.
- **M5 (reconcile).** The reclamation contract must be designed at the renderer/driver seam
  *before* the racket pilot, because retrofitting it after four targets have shipped append-only
  writers is the sixth-emitter tax again. It is one clause, and it is cheap now.

---

## 9. Where this check disagrees with k2, k3 or k4

Recorded per the leaf's instruction — a disagreement is a finding, not an error to paper over.

1. ⚠ **k3 §10.1 and k4 Q7: racket's `provide/contract` is an M4 site.** It is not; nothing in the
   repo is. Verified structurally (`CodeWriter` is append-only) and site by site
   ([§2.3](#23-m4-has-zero-sites-in-this-repo)). **Affects k4 Q7's ground (ii) for choosing racket
   as the pilot.** Grounds (i), (iii) and (iv) — the contract layer as Q3's hardest test, a
   mid-range residual, working committed goldens, and the `ffi_type_mapping.rs` cleanup — are
   unaffected, so **the pilot choice stands on three grounds instead of four**. No re-decision is
   proposed here.
2. ⚠ **k4 Q7: "racket exercises … not M5; gerbil's E6 sharding is the repo's only M5 site."**
   racket's file set is data-dependent five ways; k2 §5.1 says so for all five targets. What is
   gerbil-only is M5 (reconcile). ([§8](#8-q5--what-the-racket-pilot-exercises-and-what-it-does-not))
3. ⚠ **k3 §10.1's method: "against one real framework."** Not satisfiable — four of seven hard
   escapes are unreachable from AppKit or Foundation, and E1 is absent from both entirely.
   ([§1](#1-method-and-the-one-place-it-had-to-deviate))
4. **k2 §2.1 E4 presents identifier formation as one site with a 23-entry `KNOWN_TOKENS`.** It is
   two sites — `split_camel_case` (tableless, four targets) and `acronym_aware_kebab` (sbcl only) —
   and the table has **27** entries, not 23 (counted at `_shared/emit/naming.rs`). The split changes
   the pilot's table-mode coverage; the count is a footnote.
5. **k2 §3.3 cites `build_export_contracts:400` / `collect_predicate_class_names:420`; k2 §6.2
   cites `:838` / `:776`.** The first pair are call sites, the second definitions. Both real; noted
   so the discrepancy is not re-chased.

Three claims this check **confirms** and strengthens, worth recording alongside:

- **k3 §9 Q14 (E1 is not per-target data)** — upgraded from principle to measurement: the four
  tables' keys are byte-identical once the target prefix is stripped
  (`4b78965e8b2096a00890fc8d14c1bafb` ×4), so the overload hash is target-independent and a single
  shared table is mechanically achievable.
- **k3 §9 Q3 (derived identifiers are host-computed, first-class model nodes)** — confirmed by E2,
  E3, E4a/E4b and the collision-resolution site, all of which are unexpressible without it.
- **k3 §9 Q7's answer #1 (compute the header in the transform)** — this repo has already converged
  on it in all three of its per-file accumulator sites, independently, which is why M4 is empty.

---

## 10. What this check did not settle

Recorded as residual rather than folded into the verdict.

1. **The `CGContext` corpus-uniqueness claim was not re-verified.** `method_filter.rs:355-359`
   asserts one occurrence across *"all 252 frameworks'"* `extracted.kdl`; this workspace has 153
   families and both `extracted.kdl` and `resolved.kdl` are gitignored and absent. The claim may
   still hold; it is untested here, and it is the load-bearing justification for a partial key.
2. **Whether E7's bare-selector keys currently collide was not measured**, for the same reason. The
   design consequence ([§3](#e7--curated-per-symbol-admissions-and-suppressions)) does not depend on
   the answer — a key that needs a runtime panic to be safe is underspecified whether or not it has
   collided yet — but the empirical question is open and cheap once layer 0 lands.
3. **The five `bundle-*` crates (9,575 LOC) were not walked.** Outside k2's `emit-*` subject and
   outside this leaf's site list, but inside Q5's adapter scope; `bundle-sbcl` has no `bundle.rs` at
   all. k4 Q5 already carries this as a build-grove open question; nothing here changes it.
4. **`emit-ocaml` was not walked.** A sixth emitter under the old architecture in a live workspace
   would be the best available test of whether the M-list is complete for a *new* target rather than
   the five it was derived from — but reading a half-finished tree as evidence is exactly the error
   k2 §9.6 declined to make.
5. **Whether the M-tuples' *orderings* are consistent with a single pipeline staging was not
   checked.** Each site's tuple is internally ordered, but no attempt was made to topologically sort
   all ~35 tuples into a global pass order. That is a design exercise for the build grove, and it is
   the natural first use of the per-stage model-diff instrument (Q3/Q6 layer 1) rather than a paper
   exercise.
6. **The escape hatch's *share* was not estimated** and this check is not evidence about it. Q1b's
   ~40% and the pre-registered kill criterion stand on k3 §9 Q5's measurements of SWIG and gtk-rs.
   Mapping a site to a mechanism says nothing about how many lines that mechanism costs.

---

## 11. Scope note

Per the charter's Q6 this leaf mints **no ADR** and makes **no change to `CONTEXT.md`**; per
`plan-k1` Q5 it writes no production code and no prototype. It **decides nothing** — the three
amendments in [§2](#2-the-repertoire-as-tested-and-the-three-amendments-it-forces) state what the
repertoire's wording must cover, and the disposition of M4 in particular is left open;
`write-handoff-doc-k5` settles the wording.

The document is durable and outlives the grove: it is a claim about this repository's escape sites,
true whether or not the re-cut is ever built, and it is re-runnable — every measurement is a
one-liner in [§1](#1-method-and-the-one-place-it-had-to-deviate) and every classification names the
line it was read from.
