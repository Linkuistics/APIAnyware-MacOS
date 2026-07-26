# TODO — the language-model-transforms re-cut

**Status:** design handoff. **On paper only — never built, never prototyped.**
**Date:** 2026-07-27. **Supersedes nothing; commits nothing.** No ADR was minted and
`CONTEXT.md` was not touched (deliberately — see [§2.4](#24-why-none-of-this-is-in-contextmd-yet)).

This document is the **sole deliverable** of a design-only investigation into re-cutting the
pipeline's `generate` half. It exists so a *new* grove can `root-init` against it and start work
without re-deriving anything settled here. It is self-contained: every load-bearing decision,
rejected alternative and correction is *in this file*. The durable evidence it rests on is four
dated research documents under `targets/_shared/docs/research/`, cited by path
([§4.4](#44-the-evidence-documents-and-how-to-read-their-shorthand)).

> **How to read this.** [§0](#0-read-this-first) is the whole thing in one page for a reader
> deciding whether to start. §1–§3 are what was settled and why, with rejected options, because a
> decision without its rejected alternatives gets re-opened. §4 is the evidence. **§5 is the part
> to read if you only read one section after §0.** §6–§8 are what is still open, what ADR work is
> owed, and a proposed shape — the last being a proposal the build grove may reject.
>
> Claims that **correct or contradict** something an earlier stage of this investigation asserted
> are flagged ⚠ where they appear. There are seven of them and they are not cosmetic.

---

## 0. Read this first

**The proposal.** Replace *resolved semantic model → per-target emitter → binding source* with
*resolved semantic model → **model transform** → **projection model** → **template** rendering →
binding source + Swift adapter + doc comments*. The transform is typed Rust node-to-node passes;
the projection model is derived and dumpable, not committed; the templates are Askama files a
target expert can edit without reading Rust.

**The motivating measurement**, re-verified 2026-07-27 on this workspace: **71,719 lines** of
per-target emit crates against **4,092 lines** of shared substrate — of which only **866 lines are
live shared machinery**, so the like-for-like ratio is **42:1**.

**The honest headline, and it is not the one the investigation started with.** ⚠ Half the 71,719
is test code (35,298 lines, 49.2%); production is 36,421. At the prior art's measured escape-hatch
share (~40%, not the 10–20% first estimated), 37,287 production lines fall to ~14,900 residual
Rust — a **2.5× reduction, not 4.3–6.3×**. With test mass unquantified, the defensible headline is
**71,719 → ~50,200 lines of Rust, roughly 30%** — plus ~3,000–6,000 lines of authored rules and
data and ~70 KB of templates. **Not an order of magnitude.**

**So the case does not rest on mass.** It rests on **form**: declarative authored data plus
templates in place of imperative Rust; provenance out of the derivation trace; a reviewable model
as the diff surface; the end of the sixth-emitter tax (one defect found once, then N fixes, N
golden re-blessings, N VM verifications — measured, [§4.2](#42-the-form-argument-measured)); and a
generator a target expert can edit without reading Rust. **Any argument of the shape "and then all
targets can share X" contradicts the architecture and must say so explicitly. Any argument that
sells the re-cut on mass, or on templating, contradicts the evidence.**

**The first-order risk, stated without softening.** The design was never built or prototyped —
a pilot was recommended during planning and a design-only charter was chosen instead, so **this
document hands over an untested thesis.** The specific untested claim is the **escape hatch**: a
declarative transform plus computation-free templates covers most of a surface, then meets cases
needing arbitrary computation, at which point templates grow logic and the architecture silently
reverts. What *is* settled, on paper: every escape site in this repo maps into a closed
five-mechanism repertoire, so **the risk is retired to engineering rather than to research**
([§5.1](#51-r1--the-escape-hatch-first-order)). What is *not* settled: its **share**, and the
prior art says to plan against ~40%, not the ~15% this repo's own audit estimated.

**The three risks that outrank the LOC argument** ([§5](#5-risks-honestly-ranked)):

1. **Test mass is unmeasured and unmeasurable from here.** 49.2% of the headline is tests; no
   in-repo evidence and **no system anywhere in the surveyed prior art** reports test mass before
   and after such a migration. Make it the pilot's primary instrumented measurement.
2. **The goldens gap is five targets, not one.** Four of five corpus snapshot tests silently take
   a `SKIPPED` path because `resolved.kdl` is gitignored and absent; chez has no snapshot target at
   all; the only goldens that run cover a synthetic five-class `TestKit`. The equivalence
   instrument is **inert by default everywhere**.
3. **The authored target model is unwired from generation.** No `emit-*` crate depends on
   `apianyware-target-model`; 1,491 lines of authored `.apiw` have **zero** emitter readers, and
   TypeScript has no target model at all. A transform reading authored per-target vocabulary would
   be that layer's **first generation-side consumer** — a wiring cost and a staleness question the
   design has not priced.

**Where to start.** A single-target pilot on **racket**, full 153-family corpus, with a
**pre-registered kill criterion**, and the **per-stage model-diff tool as its first deliverable,
not its tooling afterthought**. Proposed decomposition in [§8](#8-a-proposed-decomposition-for-the-build-grove).

---

## 1. Charter and scope

### 1.1 What the build grove is being asked to do

Re-cut the `generate` half of the pipeline so that:

- a **model transform** (typed Rust passes over the resolved semantic model) produces an
  **instance-level projection model** — one node per emitted thing, per target × platform;
- **templates** render that model to text, doing no computation;
- the **construct vocabulary** each target emits is **authored per target** as `.apiw` data over a
  shared *declaration* meta-schema, not hard-coded in Rust and not shared across targets;
- the outputs are **binding source + Swift adapter sources + doc comments in generated source**.

### 1.2 What this is not

⚠ **Nothing here was built, and nothing was prototyped.** Every claim in §3 is a paper decision
from evidence in §4. The investigation that produced it wrote no production code, added no
dependency, and minted no ADR. A pilot was recommended during planning, on the explicit ground
that the escape-hatch question *"looks solved in prose and fails on contact with a real API
surface"*; a design-only charter was chosen instead. The mitigation for that choice is this
document naming the risk and what would settle it — [§5.1](#51-r1--the-escape-hatch-first-order) —
rather than a future session rediscovering it.

Consequently: **treat §3 as a well-evidenced starting position, not as a specification.** The kill
criterion in §5.1 exists so the pilot can falsify it.

### 1.3 Explicitly out of scope

- **Standalone `.md` documentation files stay authored prose.** Doc *comments in generated source*
  are in scope (they fall out of templates); generating the 1,834 lines of hand-written binding
  docs is a new capability, not a re-cut, and has no "before" to prove anything against.
- **The in-flight OCaml target is left alone.** `APIAnyware.add-ocaml-target` is a separate,
  unmerged workstream building a sixth emitter (`emit-ocaml`, 15,153 LOC across 20 modules, as
  measured 2026-07-26) under the *current* architecture. It lands as-is and migrates as one of the
  N after the pilot. Redirecting it would discard in-flight work and manufacture a coordination
  dependency that does not exist; OCaml is also not paradigmatically alien enough to be the
  meta-schema's test case. Meanwhile it keeps supplying the duplication-tax evidence the form
  argument rests on.
- **Runtime substrate.** No surveyed system generates its runtime; the prior art's hand-written
  share concentrates there (glib 87.6% hand-written). The *binding surface* is what reaches 60–80%
  generated, and that is what this re-cut targets.

---

## 2. Vocabulary

Three new terms. They are **not yet in `CONTEXT.md`** — §2.4 says why, and the build grove lands
them there when it builds.

### 2.1 `projection model`

**The instance-level model the transform produces: one node per emitted thing, per target ×
platform.** Being instance-level is what makes templates *sufficient*: every projection decision is
resolved before rendering, so the renderer only renders.

- **Why this name.** `CONTEXT.md` already calls `semantic/` the "projection-**independent**
  semantic model", so this is its projected counterpart in vocabulary the repo already has; and
  ADR-0044 independently names the shared `emit` crate "the shared **projection** substrate",
  making the projection model the model that substrate produces. "Projection" also already carries
  the placement rule (`CONTEXT.md` §45.10, *"projection lives in `targets/`, never `platforms/`"*),
  so the name answers *where it belongs* for free.
- **_Avoid_: "target API model".** It sits one adjective from the existing **target model**
  (ADR-0051, refactor workstream 6), which is the *capability / idiom / policy knowledge* layer —
  i.e. what the projection model is **not**. Using it retroactively ambiguates every brief and ADR
  citing "the target model", which is exactly the drift `CONTEXT.md` exists to prevent.
- **_Avoid_: "binding model"** (ADR-0010 makes the native library *the* binding) and **"surface
  model"** ("surface" already names the source surface).

### 2.2 `model transform`

**The staged pipeline of typed Rust passes from the resolved semantic model to the projection
model.** Separate node types per stage (not one shared IR mutated in place). `ascent` datalog is
admitted as **one pass kind** for genuinely relation-shaped derivations — never as the engine.

- **_Avoid_: "the rule tier".** No surveyed system uses a rule engine for a projection transform,
  and calling it one re-opens a question §3.5 closes.

### 2.3 `construct vocabulary` (a target's **repertoire**)

**The set of constructs a given target emits, authored by that target as `.apiw` data and read at
generation time.** `targets/_shared` owns the **declaration meta-schema** — *how* a target declares
a construct, its slots and their types — and the engines. It names **no target-language construct
token**.

- Two readings of "meta-schema" were distinguished during the alien-target check and only one
  survives it:
  - **MS-A — the declaration meta-schema.** Shared layer owns the *form* of a construct
    declaration. **This is the design.**
  - **MS-B — a shared spine of node kinds** (`compilation-unit`, `callable`, `parameter`,
    `type-ref`) targets populate. ⚠ **This is what `targets/_shared` implements today, and it does
    not survive the alien case.** See [§3.4](#34-a3--the-construct-vocabulary-is-authored-per-target-over-a-shared-declaration-meta-schema).
- **_Avoid_: "shared construct taxonomy".** A single closed vocabulary spanning
  Haskell/Idris2/Prolog/Pharo/Zig is the lowest-common-denominator straitjacket ADR-0011 rejects by
  name.

### 2.4 Why none of this is in `CONTEXT.md` yet

`CONTEXT.md` is the repo's *current* ubiquitous language. Under a design-only charter these terms
name a pipeline stage that does not exist, so a future session would find glossary entries with no
code behind them. The entries **were** written during planning and then **deliberately reverted**
(`CONTEXT.md` verified back to 2,413 lines with no diff — still 2,413 lines as of 2026-07-27).
Same reasoning for `adr/`: ADRs bind future work and this repo reworks them **in place** rather
than superseding (ADR-0024), so minting ADRs for an unbuilt design creates rework debt for the
build grove.

**The build grove owes both**: glossary entries when the terms have code behind them, ADRs per
[§7](#7-adr-work-the-build-grove-owes).

---

## 3. The settled architecture

Each decision carries **what was rejected and why**. That is the load-bearing part: without it the
build grove re-opens settled ground.

### 3.1 The shape

```
resolved semantic model  (semantic/, unchanged — the only shared thing, per ADR-0011)
        │
        ├── model transform : staged typed-Rust passes, separate node types per stage,
        │                     ascent admitted as one pass kind          §3.5
        ▼
projection model  (derived, dumpable per stage, diffable per pass, NOT committed)   §3.6
        │
        ├── construct repertoire : per-target authored .apiw over the shared
        │                          declaration meta-schema (MS-A)        §3.4
        ▼
templates  (Askama, external per-target files, computation-free / branching-allowed) §3.7
        │
        ▼
binding source + Swift adapter sources + doc comments in generated source    §3.8
```

### 3.2 A1 — the transform produces an **instance-level** model

**Decision.** One node per emitted thing, per target × platform. Consequences accepted:
(i) templates *render only* — every projection decision is resolved in the model before rendering,
which is what makes a template engine sufficient rather than a program; (ii) the natural golden
surface moves from emitted text to the projected model; (iii) the construct vocabulary becomes a
first-class, much-widened artifact.

⚠ **Correction carried forward.** This decision was originally worded *"one node per emitted thing
(compilation unit, callable, parameter, type reference, …)"*. **Read as a shared spine of node
kinds — which is how it reads — that enumeration does not hold.** Three of the four have no
counterpart in a SWI-Prolog binding: no compilation unit in the language's sense, no callable in
the params-in/result-out sense, and **no type reference anywhere in the emitted Prolog source at
all** (the type fans out to three other constructs in two languages). The list is a *Racket
binding's anatomy* promoted to a shared vocabulary, which is precisely the drift pressure the
survey identified in uniffi's General IR. **The fix is a restatement, not a redesign: those four
are repertoire members racket authors, not node kinds `targets/_shared` owns.**
(`2026-07-27-alien-target-meta-schema-check.md` §1.2, §3.2, §7 row 1.)

**Rejected.**
- *Richer projection decisions while keeping imperative emitters* — the smallest change, but it
  rules out templating and keeps the 71.7k LOC.
- *A separately-authored per-target metamodel as a second new entity* — deferred rather than
  dismissed, since the existing idiom catalogue already covers part of that ground. Revisit if the
  transform proves untypable without it.

### 3.3 A2 — that model is the **projection model**

Settled naming; rationale and the `_Avoid_` set are in [§2.1](#21-projection-model).

### 3.4 A3 — the construct vocabulary is **authored per target over a shared declaration meta-schema**

**Decision.** `targets/_shared` owns the meta-schema (**MS-A** — the declaration *form*) and the
engines; each target authors its own construct repertoire as `.apiw` **data** read at generation
time — **not** as loadable rules.

**Why this is inside ADR-0011 with no rework.** ADR-0011 states, verbatim: *"The emitter framework
may share **mechanism** (code-writing utilities) but not target **semantics**."* ADR-0044 confirms
hermetic isolation *"governs runtime/output, not emitter **code**"* and makes `targets/_shared/`
*"the established home for any future cross-target **machinery**"*. A declaration meta-schema plus
engines is mechanism; a construct repertoire is semantics and stays per target. The precedent is
exact: one shared `target-model` crate parsing per-target authored `.apiw` data, already shipped.

**⚠ Three qualifications, each forced by later evidence.**

**(i) Swift-adapter-compiler facts are not per-target data at all.** `KNOWN_UNBINDABLE` is 51
entries recording *what swiftc rejects*, discovered by running `swift build` and reading the
errors, and it is **byte-identical in four emitters** — the keys hash to
`4b78965e8b2096a00890fc8d14c1bafb` in all four once the target prefix is stripped — because the
rejecting compiler is the same compiler. It is Swift-adapter-toolchain truth, belongs in a shared
authored layer keyed by declaration identity, **once**, and must not be designed as per-target
vocabulary.

**(ii) This is the category with no successful alien-paradigm precedent.** A meta-schema for
*target constructs* is a **target-side** commitment. The survey's sharpest result, from a
near-controlled comparison: every system that reached a paradigmatically alien target shares only
**source-side** facts (GIR: C → Haskell, 13 years, live; SWIG: C++ → Guile *and* Java, 21 targets;
protoc). The two with a shared **target-side** layer either failed the crossing (wit-bindgen never
crossed compiled→interpreted in five years; JavaScript and Python **forked** into ComponentizeJS
and componentize-py) or never attempted one (uniffi — four targets, one paradigm family).

**(iii) Q3 nevertheless HOLDS against the alien case — with five amendments.** The check was run
against **SWI-Prolog** (with Mercury as the type-restored control), chosen over Pharo and Idris2
because *absence* stresses a schema harder than richness. Its 33-construct binding surface is fully
expressible as authored data over MS-A. **The five amendments the build grove must design in from
day one** (`2026-07-27-alien-target-meta-schema-check.md` §4):

| # | Amendment | Forced by |
|---|---|---|
| **A1** | **The identifier slot is structured, not a string.** A Prolog predicate's identity is `Name/Arity` with the arity *computed by the projection*; Pharo's `initWithParent:` splits into keyword parts co-indexed with the argument list; Mercury shares one name across several mode declarations. Today: `pub name: String` (`targets/_shared/tools/target-model/src/idioms/model.rs:86`). | Prolog, Pharo, Mercury |
| **A2** | **A construct may carry zero type references, and an argument may carry a non-type qualifier.** Prolog source contains no types at all. Arguments carry a **mode**, predicates a **determinism**, Idris2 binders a **multiplicity** — none of which is a type. | Prolog, Mercury, Idris2 |
| **A3** | **A construct body may be source text in another language, rendered by a nested template.** Mercury's `pragma foreign_proc` embeds C *inside* Mercury; Pharo's uFFI call is a pragma in the method body. ⚠ The renderer's `Vec<(path, content)>` contract (§3.7) **has no nesting** and must gain it. | Mercury, Pharo |
| **A4** | **Sibling ordering is declared per construct as semantic or presentational.** Clause order within a Prolog predicate is *program meaning*; method order in a Pharo Tonel file is presentation. ⚠ The per-stage diff (§3.6) treats sibling order uniformly, so the same reordered diff is a no-op in one target and a behaviour change in another. Order is **also a correctness concern**, not only a golden-stability one. | Prolog |
| **A5** | **The model is a DAG, not a tree** — one construct may contribute to a unit it does not live in (Prolog `:- multifile`). ⚠ **Not alien-specific**: gerbil's `generics.ss` shards and sbcl's per-framework `generics.lisp` already do this. The alien check surfaced it; it was always a requirement. | Prolog — and this repo |

**Two consequences of that check, both build-grove work.**

**(a) ⚠ The drift is already present and measured, so the build grove inherits it rather than
risking it.** `targets/_shared/tools/emit/src/ffi_type_mapping.rs` is 1,071 lines; lines **118–262**
are `RacketFfiTypeMapper` / `RacketFfi2TypeMapper` / `ffi_unsafe_to_ffi2` — **143 of 263 production
lines are one target's semantics inside the shared substrate**, emitting `_int64`, `_pointer`,
`_NSRect`. That is half of it. The other half: chez, gerbil, sbcl and typescript each implement the
shared `FfiTypeMapper` trait **in their own crate** (233 / 409 / 170 / 400 production lines) and
**none imports the shared mappers**. Target #1's vocabulary sat in the shared home; targets #2–#5
**forked** rather than conform — wit-bindgen's shape in miniature, at target count five, with no
paradigm boundary crossed. *If four Lisp-family-and-TypeScript targets declined to share a **type**
vocabulary, the prior odds that Haskell, Idris2, Prolog, Pharo and Zig share a **construct**
vocabulary are worse, not better.*
  **The proposed countermeasure is a checkable rule, cheap now and impossible to backfill:**
  > **The deletion test — a `targets/_shared` artifact is legitimate if deleting any single target
  > from the repo would not shrink it.**
  Mechanical enough to be a build-time lint. Under it, the `FfiTypeMapper` *trait* and the IR-shape
  helpers (`split_camel_case`, `is_mutating_selector`, `normalize_primitive_name`,
  `is_known_geometry_struct`) **pass**; `EmitConstruct`, the Racket mappers, and the shared
  kebab/snake conventions **fail**. *The shared substrate's mechanism layer is correctly drawn; its
  data layer is not.*

**(b) ⚠ The nucleus must be INVERTED, not extended.** `emit/pattern_dispatch` was identified as the
architecture's nucleus, and its *mechanism* is: it already reads authored `.apiw` data at
generation time and renders from it. But its **vocabulary** — `EmitConstruct`, a **closed
seven-variant enum in `targets/_shared`** (`target-model/src/idioms/model.rs:103-120`), mirrored as
a schema `enum` at `schemas/spec-format/idioms.kdl-schema:127` — **is the option A3 rejected.**
Widening it to "the target language's full construct repertoire" changes the artifact's *category*,
from seven idiom projections to everything the target emits, and at that category a shared closed
enum cannot survive: Prolog alone needs `operator-declaration`, `mode-declaration`,
`determinism-annotation`, `multifile-contribution`, `meta-predicate-declaration`, `fact-table`,
`blob-registration`, `foreign-predicate-registration` — structural furniture, not idiom
projections. **So the taxonomy leaves `targets/_shared`, the `enum` at `idioms.kdl-schema:127`
becomes a per-target declared set, and what stays shared is the declaration form.** That is a
change to shipped workstream-6 artifacts (`CONTEXT.md` §ws6 decision D3) and is build-grove work.

**Rejected (A3).**
- *One shared closed vocabulary* — maximum leverage, but it directly contradicts ADR-0011's chosen
  option and its paradigm-diversity rationale, forcing an in-place ADR-0011 rework.
- *A shared "universal core + per-target extensions" spine* — the spine is exactly where the
  straitjacket forms, and the planned targets are the ones ADR-0011 names as paradigmatically
  alien, so they test it hardest.

**The fallback, costed, and available.** If the meta-schema proves too expensive, SWIG's answer
transposes cleanly: shared IR plus shared *mechanism* (pass framework, template engine, file-set
assembler, diff tool), with each target's repertoire as **per-target Rust node types** instead of
authored `.apiw`. **It is not a different architecture — it is A3 with the authoring layer
deleted.** It costs exactly **one** of the five claimed gains: *a generator a target expert can
edit without reading Rust*. Per-stage model diffing, the templates, the derive-macro pass
framework, the provenance and mass arguments all survive; ADR-0011 becomes satisfied by
construction rather than by argument. ⚠ **Because the two differ by one layer, the build grove can
defer the choice**: build the repertoire as Rust node types first and lift it to authored `.apiw`
when a second same-family target makes the duplication visible. That ordering also matches the
survey's unanimous finding that *the authored layer must be optional, layered over defaults that
already work* — SWIG, bindgen, protoc and uniffi all generate usable output with zero user
overrides.

### 3.5 M1 — the transform is **typed Rust node-to-node passes**, `ascent` admitted as one pass kind

**Decision.** A staged pipeline of typed Rust passes, **separate node types per stage**, with
`ascent` datalog admitted as *one* pass kind for genuinely relation-shaped derivations. **Not** as
the engine.

**⚠ The ADR-0047 tension, and why it dissolves rather than resolves.** ADR-0047 decision 2 fixes
rules as **compile-time** — *"They live in version-controlled Rust … a runtime-loadable rule DSL is
a possible later enhancement (would need a runtime datalog engine — out of scope)"* — while A3 says
a target's construct vocabulary is its own semantics, authored per target. Those look like they
pull in opposite directions, and this was called the design's sharpest unresolved point. **The
premise both horns share — that the transform tier is a *rule* tier — is not supported by the
evidence: no surveyed system uses a rule engine for the projection transform.** uniffi uses typed
Rust node types plus `#[derive(Node, MapNode)]` with hand-written pass functions; gtk-rs uses an
imperative `analysis` phase; SWIG pairs pattern-matched typemaps (declarative *data*) with
imperative C++ per target; wit-bindgen interprets an instruction stream; and in the MDA lineage the
declarative QVT-R never gained implementations while the imperative QVT-O did. The survey ranks
*"a staged pipeline with imperative passes between declarative ones"* the unanimous winner.

And per-target authoring needs authored **data**, read at generation time by compiled Rust — not a
loadable rule language. That is already shipped here: `emit/pattern_dispatch::classify_pattern`
reads the authored `.apiw` idiom catalogue and renders from it, golden-neutral. **So ADR-0047
decision 2 stands untouched, its parked runtime-loadable rule DSL stays parked, and this design
triggers no ADR-0047 rework.**

**Where `ascent` still earns its place.** Genuinely relation-shaped sites, today duplicated 3–5×
at Jaccard 1.00: transitive protocol reachability with cycle guard; `conformance_closure` (15
production lines, **identical** in gerbil `protocol_registry.rs:85`, sbcl `:108`, typescript
`protocol_graph.rs:201`); the three ownership registries. A whole-corpus transform additionally
**deletes** `emit_protocol.rs`'s `is_known_protocol` scope-limit fallback — which is a deliberate
output change and belongs on the deviation list (§3.9).

**Rider — separate node types per stage, accepting struct duplication.** uniffi's *first*
implementation was one shared IR mutated in place via `VisitMut` plus a per-language `lang_data`
bag — our tempting shortcut — and its author replaced it with explicit IR-to-IR conversion, in
writing: *"The main downside of this new approach is we need to duplicate some structs. However, I
don't really mind it … The Python structs are significantly different."* **Adopt the shape they
landed on, not the one they tried first.**

**Cost recorded honestly.** uniffi's shared `general` pass is **710 lines of node declarations
against 2,858 lines of hand-written pass functions**; ~72% of fields ride the derived recursion
free, and the ~28% that do not consume ~80% of the transform's code. Consistent with the ~40%
escape-hatch share.

**Rejected.**
- *`ascent` as the transform engine* — no surveyed precedent; content hashing, bit-packing,
  character-level scanning and total ordering all fall outside what datalog expresses (datalog
  yields **sets** where `ordered_classes` needs a **total** order for golden determinism).
- *Typed Rust passes with no datalog at all* — gives up provenance on the derivations where the
  repo already has an engine that supplies it.
- *A runtime-loaded per-target rule DSL* — reverses ADR-0047 decision 2 and forces an in-place
  rework, for a mechanism nobody shipped, and whose nearest approach (SWIG's special-variable
  macros) is the survey's accretion cautionary tale.

### 3.6 M2 — the projection model is **derived and uncommitted**, dumpable per stage, diffable per pass

**Decision.** Not committed. Dumped per stage as machine-artifact `.kdl`, diffable per pass,
filterable by `--pass` / `--type` / `--name` and per framework. **Model goldens are committed at
fixture scale only** (today's synthetic five-class `TestKit` is already that shape).

**⚠ Two corrections to the framing this decision was posed under, both verified.**
(i) `resolved.kdl` is **not** committed — `.gitignore:10-11` excludes `extracted.kdl` and
`resolved.kdl`, and there are **zero** tracked `resolved.kdl` against **152** tracked
`annotations.apiw`. **The repo's precedent is one-way: derived artifacts are gitignored, authored
artifacts are committed**, and `CONTEXT.md` §ws6 gives the reason on the representability entry —
*"derivable → rots against SDK/binding drift"*. (ii) A dumped model is a **machine** artifact, so
`.kdl` through the non-preserving JiK codec in `semantic/tools/spec-format` — **not** `.apiw`,
which ADR-0046 §2 reserves for the *authored* overlay on the format-preserving `kdl` crate.

**The prior art is unanimous:** five of seven surveyed systems serialise a model; **none commits a
projection model as a reviewed diff surface.** GIR and WinMD ship the *source* model, not a
projection. uniffi's is in-memory behind a `pipeline` peek/diff CLI; SWIG has `-xmlout` and
`-debug-top 1,2,3,4`. uniffi's authors hit the volume wall — *"This is a lot of data. Use CLI flags
to reduce it to a reasonable amount"* — at a corpus vastly smaller than 153 frameworks × ~40,000
methods × five targets.

**What replaces the review-surface benefit is stronger than what it replaces.** **Per-stage model
diffing is the only technique the prior art reports as having actually caught migration bugs**
(uniffi's author: *"I had a few errors when re-implementing all of the code and `peek` came in very
handy to fix them"*). It is independent of goldens and **works for chez**, which has no golden
mechanism at all — so it answers the chez problem rather than deferring it. **Build it first.**

**Rejected.** *Committing the full-corpus model* (no surveyed precedent; rots against SDK drift for
exactly the reason `CONTEXT.md` gives for representability; uniffi hit the volume wall far below
our scale). *In-memory with no dump* (gives up the only equivalence instrument the prior art
reports as working, and the only one available to chez). *Committing a fixture-scale model as the
primary review artifact* (inverts which instrument does the work).

### 3.7 M3 — templates are **Askama, external per-target files**, computation-free / branching-allowed

**Stated plainly, because it inverts the intuition: templates are the cheapest and least valuable
part of this proposal.** The emitted-text payload is **4.4%** of production emitter source under a
strict rule (2,273 target-syntax literals, 70,852 bytes of 1,627,518) and **12.2%** under a coarser
one. By that same coarser rule, wit-bindgen's *template-free* generators measure **~40%** — their
`format!` calls **are** their templates. **We are in the opposite regime, where the transform
carries the whole prize. Any framing that sells the re-cut on templating is wrong.**

**The contract is `computation-free, branching allowed`** — set by what was measured, not by what
was hoped. uniffi's migrated Python backend has **6–15× fewer computations** in templates than its
unmigrated siblings (14 method calls in expressions vs Kotlin 87, Ruby 204) but only **~25% fewer
branches** (406 → 239 control directives, one per 9.2 template lines). A logic-free template did not
emerge and uniffi never claimed one would. Their principled exception is adopted with it: pure
*display* concerns stay filters, because *"implementing this as a pipeline pass means the pass
would need to know how much each docstring gets indented, which doesn't seem right."*

**Engine: `askama`** — verified against crates.io during planning (2026-07-26): **0.16.0, published
2026-04-29, 41M downloads**, actively maintained; the `rinja` fork that existed during askama's
maintenance gap is `0.4.0+deprecated`, i.e. merged back. Compile-time, typed, and proven at exactly
this job in uniffi. ⚠ **Re-check currency before adopting** — this is the one dependency claim with
a shelf life.

**External per-target files is the load-bearing choice, not the engine.** It is what buys the
contributor-filter benefit: a Racket expert edits `targets/racket/templates/<x>` and runs
`cargo build`, rather than reading 14k lines of imperative Rust. The witness is hostile and
specific — a C# interop expert on wit-bindgen issue #1265: *"I'm unfortunately not familiar with
Rust at all … the current code is somewhat overwhelming."*

**Compile-time vs runtime, resolved by principle.** M1 puts per-target authored *data* at
generation time; templates are per-target too, so runtime loading (minijinja) looks consistent.
**The split is by what the artifact is, not by who authors it**: authored *data* the transform
consults is read at generation time; templates are *code-shaped* — they carry control flow — so
they compile. uniffi splits exactly this way. Compile-time additionally type-checks templates
against the projection model's node types, which matters precisely because target experts rather
than Rust experts author them.

**Two things needing no engine support.** The data-dependent file set is satisfied by making the
renderer's output contract **`Vec<(path, content)>`** rather than one-template-one-file — costs
nothing if designed in. And `emit/code_writer.rs`'s `CodeWriter`/`FileEmitter` (211 lines) survives
*beneath* the engine as file-set assembly. ⚠ Amendment **A3** (§3.4) adds one requirement the
contract does not have: **nesting**, for a construct body that is source text in another language.

**Rejected.** *A purpose-built renderer over the model* — given a fair hearing (70 KB of templates,
no new dependency, and `code_writer.rs` at 211 lines is already almost exactly wit-bindgen's whole
222-line `source.rs`), but it fails on the **branching** number: control flow that lives in
surrounding Rust today *moves into the template*, so a renderer supporting `{% if %}`/`{% for %}`
**is** a template engine, built in-house, without SWIG's 30 years of hardening or its debugger.
*minijinja* — gives up template type-checking for a consistency the principle above shows is false.
*No engine at all* — honest given our text share, but preserves the contributor filter and
forecloses external templates entirely.

### 3.8 M4 — scope is **binding source + Swift adapter sources + doc comments in generated source**

**What is generated today, measured.** ⚠ **The Swift adapter sources are already generated** — nine
global CLI passes write into each target's Swift package, and all five `Generated/` directories are
gitignored, confirming it (racket: `Dispatch.swift` + `Trampolines.swift`; chez/gerbil/sbcl:
`Trampolines.swift`; typescript: four `.swift` tables). So the "dylib side" is in scope today, not
aspirational. **The docs are not generated** — zero `.md` writes in the emitters; all 1,834 lines
across 20 files are authored prose.

**Why the adapter is in, and close to mandatory.** (i) It is the same drift problem
`emit-typescript/src/class_surface.rs` already solves one level down — one resolved surface, two
renderers, *"so the two artifacts provably cannot drift"*. Excluding it means the transform resolves
method dispositions and the adapter re-resolves them separately: today's duplication, preserved.
(ii) `KNOWN_UNBINDABLE` is Swift-adapter-toolchain truth keyed by the `@_cdecl` entry name, and with
the adapter outside the model that authored data has nowhere principled to live (§3.4 qualification
(i)). (iii) It does not strain the model's shape — the adapter is per-target Swift, so "one
projection model per target × platform" already covers it.

**Doc comments are in; standalone `.md` docs are out** — two things wearing one word. Doc comments
in generated source (deprecation notices, `Method.doc_refs`) are emitted text and a template
concern, and **the machinery already exists dead**: `doc_rendering.rs` is 209 lines with **zero
callers workspace-wide**, `Method.doc_refs` appears in production only as `doc_refs: None`, and a
sister workstream independently found **226 IR-deprecated declarations** in Foundation + AppKit that
all five targets say nothing about. Templates supply this free. Standalone `.md` files stay authored
prose (§1.3).

**Rejected.** *Bindings + adapter without doc comments* (keeps the equivalence comparison exact, but
leaves shipped-and-dead machinery dead for no gain). *Bindings only* (preserves the duplicate
resolution the re-cut exists to remove, and strands `KNOWN_UNBINDABLE`). *All three including
standalone `.md` docs* (no equivalence baseline exists; converts a re-cut into a re-cut plus a new
capability).

### 3.9 M5 — the bar is **golden-INTENTIONAL**, proved by a four-layer instrument stack

**Equivalence is not the bar, and it is already false.** Adding doc comments changes output by
construction; so does fixing the property-getter selector defect (74 of Foundation's 1,259 and 264
of AppKit's 2,634 properties rename their getter — `NSView.hidden`, `NSControl.enabled`,
`NSWindow.visible`, `NSTextField.editable` — each a binding that builds clean and fails at the
call); so does surfacing the 226 deprecated declarations; so does deleting the `is_known_protocol`
fallback, which changes how cross-framework protocol ancestors resolve. The repo's own vocabulary
already names this: `CONTEXT.md` §ws6 distinguishes **golden-neutral** from
**golden-INTENTIONAL**. The enforceable bar:

> **Every output diff is either on a pre-enumerated deviation list, or it is a regression.**

Stronger than "equivalence" (already false) and than "better" (unfalsifiable).

**The four-layer stack.**

| layer | instrument | what it proves |
|---|---|---|
| **0 — prerequisite** | materialise `resolved.kdl`; re-bless the stale corpus goldens | that a baseline exists at all |
| **1 — primary** | per-stage model diff, **built first** (§3.6) | the transform's decisions — chez included |
| **2 — secondary** | corpus output goldens on ≥1 target | the emitted *text*, which layer 1 cannot see |
| **3 — tertiary** | compile the output under **strictest** settings + existing per-target VM-verify | that it works |

⚠ **Layer 0 is load-bearing, not merely prerequisite.** See [§5.3](#53-r3--the-goldens-gap-is-five-targets-not-one) — and note the escape sites are **sparse and framework-specific**, so a pilot scoped to a framework subset would measure an escape-hatch share near zero. **The pilot must run the full 153-family corpus.**

Layer 3's "strictest settings" is a direct countermeasure to a documented failure: wit-bindgen's C#
backend shipped **non-compiling output for months** because a fixture set `ImplicitUsings=true`,
masking a missing import. The golden compiled, so nobody looked.

**⚠ Consequence: chez stops being special.** With per-stage model diffing primary for *all* targets,
the asymmetry disappears — chez is not a gap in the strategy, it is the target that makes the
strategy's shape obvious.

**Deviation list — seeded from evidence, to be enumerated exhaustively by the build grove:** doc
comments in generated source; the property-getter selector defect; the 226 deprecated declarations;
naming corrections in the `case_tag` neighbourhood; the protocol-resolution changes that follow
from deleting the `is_known_protocol` fallback.

**Rejected.** *Byte-equivalence first, deviations as a follow-on* (contradicts §3.8's scope and
re-blesses goldens twice). *Model diff alone* (proves the transform did not change, not that emitted
*text* is unchanged). *Building chez a golden mechanism first* (restores the familiar instrument,
but doubles down on the technique the prior art says did **not** catch migration bugs).

### 3.10 M6 — the escape hatch is the closed repertoire **M1–M5**

**Decision.** The escape hatch is not one thing; it is five, closed across seven surveyed systems.

| | mechanism | shipped instances |
|---|---|---|
| **M1** | authored declarative data, **either** keyed into the model by path or declaration identity (**override mode**) **or** consulted as a set/table by a host function (**table mode**) | uniffi `exclude`, haskell-gi `set-attr`, SWIG `%feature`, bindgen blocklist; uniffi's 35-entry keyword table |
| **M2** | a host function invoked from a transform pass, whose result becomes a model field | uniffi `names.rs`, gtk-rs `nameutil`, Djinni `Marshal` |
| **M3** | an imperative pass staged between declarative ones (an `ascent` pass is a flavour of M3) | uniffi `MapNode` + `#[map_node(expr)]`, gtk-rs `analysis`, SWIG's four stages |
| **M4** | a named insertion point / deferred region in emitted text | protoc `@@protoc_insertion_point` |
| **M5** | the renderer returns the **complete** `Vec<(path, content)>` for an output directory, and the driver **reconciles** the directory to it — writing, overwriting, and **removing** what is no longer in the set | protoc `CodeGeneratorResponse`, `windows-bindgen` (both list-only; the reconcile clause is ours) |

**Closure is settled, not provisional.** A site-by-site check against every hard escape, every soft
escape and every statefulness site in this repo found that **every site maps into M1–M5; no site
maps to none of them; no sixth mechanism is required.** *(`2026-07-27-escape-hatch-closure-check.md`,
Verdict.)* **The escape-hatch risk is therefore retired to engineering** — all five are shipped
mechanisms with known costs. What is *not* retired is its **share** ([§5.1](#51-r1--the-escape-hatch-first-order)).

**⚠ That verdict cost three amendments, already folded into the table above and each mandatory.**

1. **M1 has two modes and the original definition named only one.** "Keyed by path or declaration
   identity" covers `KNOWN_UNBINDABLE` and the curated admission tables. It does **not** cover
   chez's **1,715-entry** `chez_builtins.txt`, the **27-entry** `KNOWN_TOKENS`, or typescript's
   6-entry `RESERVED_MODULE_STEMS` — three authored tables keyed on the **emitted identifier**,
   not on any model node, consumed as an *operand of an M2 host function*. Without table mode,
   three of the seven hard escapes map to nothing. It matters because table-mode data is a property
   of the **target language or its runtime**, is regenerable by running the target's own toolchain,
   and must be authorable by a target expert who does not read Rust — which is the whole
   contributor-filter argument. **A design that externalises only override-mode data leaves 1,748
   entries baked into Rust.**
2. **M5 must be desired-state, not append-only.** protoc and `windows-bindgen` return files to
   *write*; neither has a delete verb, because neither owns its output tree. Gerbil's generics
   sharding does (`remove_dir_all` at `emit_generics.rs:148`, *"so a regeneration with fewer shards
   leaves no stale `generics/NNN.ss` behind"*). A stale shard is not inert — the facade re-exports
   shards `000..N-1`. Two grades are worth distinguishing: **M5 (list)** — the file set is
   data-dependent; present in **all five targets**. **M5 (reconcile)** — cardinality fixed by a
   non-model fact (a downstream toolchain's performance limit) and the previous run's output must be
   reclaimed; **gerbil only**. The `Vec<(path, content)>` contract is the hard half and is already
   decided; the amendment is one clause on what the *driver* does with it — and **retrofitting it
   after four targets have shipped append-only writers is the sixth-emitter tax again**.
3. **⚠ M4 has ZERO sites in this repo — including the two the prior art nominated.** Proved
   structurally, not by enumeration: `CodeWriter` (`targets/_shared/tools/emit/src/code_writer.rs`)
   is `buffer: String` plus indent state, and its entire mutating API appends — no marker type, no
   `insert`, no splice, no handle into the buffer. **An append-only writer cannot express a deferred
   region.** Confirmed by measurement: zero occurrences of `replace_range`, `insert_str`,
   `String::splice`, `PLACEHOLDER` or `insertion_point` in any production region across all five
   `emit-*` crates, the shared substrate and the `generate` CLI. All three candidate sites —
   racket's `provide/contract`, chez's `(except (chezscheme) …)`, typescript's import blocks —
   **compute the header in the transform**, which is uniffi's *stated ideal* and the answer the
   prior art rates highest. This repo has already converged on it independently in all three of its
   accumulator sites; that is a property worth recording, not a gap.
   **Disposition, settled here:** **keep M4 in the repertoire, explicitly marked *reserved and
   unexercised*.** Dropping it loses the record that compute-in-transform was *achieved*, and the
   pressure toward a deferred region reappears the moment a target needs a trailer whose content
   depends on the body (a `#lang` reader extension, a module footer, a C-style forward-declaration
   block). Should that arrive, M4 is protoc's shipped mechanism and adopting it is not new research.

**Two riders that survive unchanged.**
- **M1 splits by keying — and the split is three-way, not two.** SWIG (`%typemap` vs `%feature`) and
  uniffi (typemap-ish passes vs `exclude`) converged independently, 25 years apart, on **type-keyed**
  and **declaration-keyed** authored data needing *separate* mechanisms. **Table mode is the third.**
  A design offering one will grow the others badly. (If one keying vocabulary is wanted rather than a
  growing list, haskell-gi's *address nodes by path* generalises over the first two — eleven
  directives, 90% of uses one `set-attr` verb — with table mode as the explicit exception that is not
  a path at all.)
- **A general-purpose expression language inside the rule engine is the named anti-pattern** — the
  only one of four candidate shapes nobody shipped. SWIG's `$typemap(method, typepattern)`
  special-variable macros are the nearest approach, and they are precisely what drove the typemap
  layer into pattern-match precedence rules, a documented comparison with C++ templates, and a
  `-debug-typemap` debugger.
- **Sites are M-*combinations*, not M-assignments.** `KNOWN_UNBINDABLE` is `M2 → M1(override,
  declaration-keyed) → M3` — the content hash must exist before the table can be keyed. A closure
  check must let a site name an **ordered tuple**.

**Rejected.** *Asserting closure on the survey's sketch* (asserted more than the evidence carried —
the site-by-site check is what made it assertable, and it turned up three amendments). *Collapsing
to host functions alone* (discards the keying split two systems found necessary, and has no answer
for a data-dependent file set). *Deferring the repertoire to the pilot* (hands over less than the
evidence supports).

---

## 4. The evidence base

### 4.1 The measurements the argument rests on

**Re-verified 2026-07-27** on this workspace (each is a one-liner; the commands are in §9):

| measurement | value | note |
|---|---:|---|
| per-target emit crates, total | **71,719** | racket 14,732 · chez 8,186 · gerbil 12,162 · sbcl 11,152 · typescript 25,487 |
| shared `emit` substrate | **4,092** | of which **866 live**, 244 dead, 1,177 test-infra, 1,805 in-file `#[cfg(test)]` — like-for-like ratio **36,421 : 866 = 42:1** |
| authored `.apiw` target model | **1,491** | 24 files, racket/chez/gerbil/sbcl only — **TypeScript has none** |
| `bundle-*` crates | **9,575** | racket 2,787 · chez 1,767 · gerbil 2,327 · sbcl 1,190 · typescript 1,504 — **unclassified** |
| framework families in the corpus | **153** | `platforms/macos/api/` |
| `resolved.kdl` committed? | **no** | `.gitignore:10-11` |
| any `emit-*` crate depending on `apianyware-target-model`? | **no** | zero |
| workspace template engine? | **none** | no askama/tera/handlebars/minijinja/liquid/mustache |
| `ascent` in the workspace? | **yes, 0.7** | used only *upstream* of the IR — the whole generation half is imperative Rust |
| `CONTEXT.md` | **2,413 lines** | unchanged; the vocabulary of §2 was reverted out of it |

**Measured 2026-07-26** and attributed rather than re-run (source:
`2026-07-26-emitter-anatomy-audit.md`, whose per-number rules are stated inline there):

| measurement | value | § |
|---|---:|---|
| test share of the 71,719 | **35,298 (49.2%)**; production **36,421** | §1.1 |
| emitted-text payload, strict rule | **2,273 literals / 70,852 bytes = 4.4%** of 1,627,518 bytes | §2.2 |
| emitted-text payload, coarse rule (comparable to wit-bindgen's ~40%) | **12.2%** | prior-art §2.3 |
| cross-target redundancy | **9.6%–25%** (three methods, three answers, all reported) | §6.1 |
| `trampoline.rs` racket↔chez line identity | **88.4%**; ~20 named functions at Jaccard **1.00** | §6.1 |
| dead shared machinery | `doc_rendering.rs` 209 lines / **0 callers**; `pattern_dispatch.rs` 313 lines / **0 production callers** | §1.2 |
| golden coverage | racket 11 files/484 lines · gerbil 13/732 · sbcl 11/234 · typescript 21/714 · **chez 0** — all one synthetic 5-class `TestKit` | §5.3 |
| residual-Rust estimate (superseded — see §5.1) | ~5,900–8,700 of 37,287 = **10–20%** | §8 |
| `emit-ocaml` (the in-flight sixth emitter) | **15,153 LOC / 20 modules** | §6.4 |

### 4.2 The form argument, measured

Two independent pieces of evidence, and they are what the case actually rests on:

- **The sixth-emitter tax.** Building a sixth emitter under the current architecture surfaced three
  *sister-target* defects — defects all five shipped emitters share. The property-getter one is
  sized in its own words as *"one line per emitter"* — **times four emitters, four golden
  re-blessings, four VM re-verifications**. One defect discovered once, then N fixes, N golden
  movements, N verifications. That is the duplication cost measured rather than argued.
- **The contributor filter.** A C# interop expert, blocked from fixing wit-bindgen's C# backend by
  the *generator's* implementation language: *"I'm unfortunately not familiar with Rust at all …
  the current code is somewhat overwhelming."* (wit-bindgen issue #1265.) The witness testifies
  from inside the system that is otherwise this design's strongest counter-evidence.

### 4.3 The prior art, in five sentences

Mozilla's **uniffi** is publicly mid-migration to exactly this architecture (metadata → initial IR
→ general IR → per-language IR → templates) and recommends new bindings authors adopt it — **so the
shape need not be re-argued** — but budget by its clock: **20 months, one of four backends migrated,
the model still documented "unstable", the last mile boxed "not yet implemented", and the old
6,244-line model still in tree beside the new one.** **SWIG**'s 25-year, 21-target record supplies
the only measured declarative/imperative ratio (java 43.4% imperative, csharp 41.4%, 17-target
aggregate 39.2%) and the keying split. **GIR** is the 20-year existence proof that a shared model
reaching a paradigmatically alien target (C → Haskell) models only the **source**. **wit-bindgen**
is the counter-case — eight backends, zero template engines — but it is a different regime (~40%
emitted-text payload against our 12.2%, so its `format!` calls *are* its templates) and **no primary
source shows it ever considered and rejected a template engine**, which materially weakens it as
counter-evidence. The **MDA/QVT/ATL** lineage is the cautionary tradition, and its own empirical base
is interview-shaped: notably, the *declarative* QVT-R never gained implementations while the
*imperative* QVT-O did.

### 4.4 The evidence documents, and how to read their shorthand

These four **survive** this grove and are the citable record. Read them for anything §3–§5
summarises.

| document | what it is |
|---|---|
| `targets/_shared/docs/research/2026-07-26-emitter-anatomy-audit.md` (918 lines) | What the 71,719 LOC is *made of*: the four-bucket classification, the seven hard escapes E1–E7, the soft escapes, the statefulness inventory, the input/output surfaces, the duplication matrix, the TypeScript breakdown, the residual estimate, and eight explicitly-unclassified residuals. |
| `targets/_shared/docs/research/2026-07-26-model-transform-codegen-prior-art.md` (2,009 lines) | Seven systems at depth with primary-source citations, a synthesis answering the audit's fourteen questions, the M1–M5 definition, what evidence would settle the escape-hatch question, and **eleven recorded silences** — searches that found nothing, so a future session does not repeat them. |
| `targets/_shared/docs/research/2026-07-27-escape-hatch-closure-check.md` (727 lines) | The site-by-site E×M check. Verdict, the three amendments, the AppKit walk, and what the racket pilot does and does not exercise. |
| `targets/_shared/docs/research/2026-07-27-alien-target-meta-schema-check.md` (789 lines) | SWI-Prolog written out against the meta-schema, with Mercury as control. Verdict, the five amendments, the MS-A/MS-B disambiguation, the measured drift, the deletion test, and the costed SWIG fallback. |

**⚠ Decoding their internal shorthand.** Those documents cite each other as `k2`, `k3`, `k7`, `k8`
and cite two planning stages as `k1` and `k4`. The mapping — **the planning stages no longer exist
as readable files; their content is transcribed into §2, §3 and §6 of this document**:

| shorthand | is |
|---|---|
| `k1` / `plan-k1` | the architecture grilling — **§2, §3.2–§3.4** here |
| `k2` | `2026-07-26-emitter-anatomy-audit.md` |
| `k3` | `2026-07-26-model-transform-codegen-prior-art.md` |
| `k4` / `plan-mechanism-k4` | the mechanism grilling — **§3.5–§3.10** here |
| `k7` | `2026-07-27-escape-hatch-closure-check.md` |
| `k8` | `2026-07-27-alien-target-meta-schema-check.md` |

Where those documents say "the handoff doc must carry X", X is carried here. Where they say "the
root brief", that is this document's §3.

---

## 5. Risks, honestly ranked

Ordered by *what could invalidate the design*, not by likelihood.

### 5.1 R1 — the escape hatch (first-order)

**The claim under test.** A declarative transform plus computation-free templates covers most of a
target's surface, then meets cases needing arbitrary computation, at which point templates grow
logic and the architecture silently reverts to imperative code wearing a template's clothes.

**What is settled.** Its **shape**. Every escape site in this repo maps into M1–M5; no sixth
mechanism is needed; the risk is **retired to engineering** (§3.10). That is a real de-risking and
it should be claimed.

**What is not settled, and this is the risk.** Its **share**. ⚠ **The in-repo estimate of 10–20%
residual Rust is low by roughly 2–4×.** Three independent, long-lived, *source-generating* systems
land at 35–45%:

| system | measure | imperative share |
|---|---|---:|
| SWIG java | `Modules/java.cxx` vs `Lib/java/` | **43.4%** |
| SWIG csharp | ditto | **41.4%** |
| SWIG, 17 targets | aggregate | 39.2% |
| gtk-rs-core binding crates | hand-written vs `src/auto/` | **~36%** |
| uniffi `general` pass | hand-written pass fns vs node declarations | 80% by LOC; 28% of fields |
| **this repo's own estimate** | | **10–20%** |

Two features of that evidence make it *harder* to discount, not easier. The 60.8%-declarative figure
for SWIG is an **upper** bound (its `Lib/<lang>/` carries target-language runtime support as well as
typemaps), so ~39% imperative is a **lower** bound. And our shape sits in SWIG's **Java/C# regime** —
generating target-language *source* — which is precisely where its declarative share is *highest*.
The one genuine consolation is narrow: hand-written code concentrates in the **runtime/substrate**
(glib 87.6%), which this re-cut does not propose to generate; the binding surface itself reaches
60–80% generated.

**⚠ A second, independent sizing hazard.** The escape sites are **sparse and framework-specific**,
not a per-framework tax. `KNOWN_UNBINDABLE`'s 51 entries span **17 frameworks and neither AppKit nor
Foundation is one of them**; `case_tag` exists because of **Matter**'s 17 ALL-CAPS acronym classes;
the generics sharding is a whole-corpus union with no per-framework existence at all. **A pilot
scoped to a framework subset would measure an escape-hatch share near zero** — the exact direction
of error, given the estimate is already suspected 2–4× low. **The pilot must run the full
153-family corpus**, which promotes materialising `resolved.kdl` (§3.9 layer 0) from prerequisite to
load-bearing.

**What would settle it — three instruments, all cheap now.**

1. **A pre-registered kill criterion**, so the pilot is falsifiable rather than a commitment:
   > **If the pilot's imperative share exceeds ~50%, or exceeds its own pre-pilot estimate by more
   > than 1.5×, the re-cut is not paying for itself.**
2. **A longitudinal escape-hatch ratio**, emitted as a build artifact per target per release.
   ⚠ **No surveyed system measures whether its hatch grew**, so the metric has to be ours. It is
   cheap at the start and **impossible to backfill**. (This repo already has four working
   precedents for the shape: `degradation_report`, `renamed_protocols`, `slot_report` and the
   deferral counters are whole-corpus accounting passes emitting build artifacts.)
3. **The full-corpus run** described above.

### 5.2 R2 — test mass is unmeasured, and outranks the LOC argument

**49.2% of the 71,719 headline is test code.** Whether rules + templates need fewer tests, the same,
or more is **unknown**: no in-repo evidence bears on it, and ⚠ **the search found complete silence in
the prior art — no system anywhere reports test mass before and after such a migration.** uniffi's
migration is the only live one and is incomplete, so no before/after pair exists even in principle.

One weak signal, offered as such: uniffi's migrated Python backend carries 1,742 lines of
pipeline + filters against Kotlin's 1,904 lines of `gen_kotlin` helpers — i.e. **the non-template
per-language code did not shrink**. Templates shed computation; the code that used to compute it
*moved* rather than vanished. That is consistent with the 4.4% emitted-text payload and
inconsistent with a large test reduction.

**What would settle it:** make it the pilot's **primary instrumented measurement** — count test LOC
per bucket before and after on one target, and publish it. If we do, we will be the first.

### 5.3 R3 — the goldens gap is five targets, not one

⚠ **The equivalence instrument is inert by default everywhere.** Four of five targets' corpus
snapshot tests silently take a `SKIPPED` path because `resolved.kdl` is gitignored and absent
(`.gitignore:10-11`, re-verified 2026-07-27; the test short-circuits on `!framework_path.exists()`).
**chez has no `snapshot_test` target at all.** The only goldens that actually run cover a synthetic
five-class `TestKit` (`TKObject`, `TKView`, `TKButton`, `TKManager`, `TKHelper` + two protocols).

And they do not describe today's output either: a sister workstream **materialised `resolved.kdl`
and re-ran**, finding racket 2 failures, gerbil 1, sbcl 1, typescript 1, plus two non-snapshot
`apianyware-generate` failures.

**Mitigation, already in the design.** Per-stage model diffing is primary for all targets (§3.6),
which is independent of goldens and works for chez. Layer 0 — materialise `resolved.kdl`, re-bless
the stale goldens — is **prerequisite work the pilot must do first**, and R1's full-corpus
requirement makes it load-bearing rather than hygienic.

### 5.4 R4 — the authored target model is unwired from generation

⚠ **No `emit-*` crate depends on `apianyware-target-model`** (re-verified 2026-07-27). The 1,491
lines of authored `.apiw` (ADR-0051) have **zero emitter readers**; the shared `emit` crate depends
on it only for the **dead** `pattern_dispatch.rs`. **TypeScript has no target model at all** — it was
built after workstream 6 and never got one.

**So a transform reading authored per-target vocabulary (§3.4) would be that layer's first
generation-side consumer.** That is a wiring cost the design has not priced, plus a staleness
question: the prior art documents the hazard (PyGObject: *"there is a good chance we have to live
with the override forever which masks a working version implemented by GI"*) and ⚠ **detection is
human review everywhere — nobody automates it.**

**Two mitigations the evidence supplies.**
- **Design the transform to work with an empty authored layer.** The prior art is unanimous and
  reassuring: SWIG, bindgen, protoc and uniffi all generate usable output with **zero** user
  overrides; overrides only correct and refine. TypeScript stays viable while its repertoire is
  written.
- **Automate the staleness check we uniquely can.** Because the 51 `KNOWN_UNBINDABLE` entries were
  *produced* by running the Swift compiler, the same run can re-test them: *"every suppression entry
  must still fail to compile, or the build fails."* ⚠ **No surveyed system has this**, and it is
  cheap for us specifically.

### 5.5 R5 — meta-schema drift, and the nucleus that implements the rejected option

The full statement is §3.4. Ranked here because it is the risk the design's *compatibility* argument
depends on: if the shared meta-schema drifts into a shared vocabulary, ADR-0011's carve-out is
breached and the design needs an ADR-0011 rework it currently claims it does not.

⚠ **This is not prospective — it is measured and already present** (the forked `FfiTypeMapper`
implementations; 143 of 263 shared lines being racket's). The build grove inherits the drift rather
than risking it. **Countermeasures:** the deletion test as a build-time lint, and inverting the
`EmitConstruct` nucleus out of `targets/_shared` rather than extending it.

### 5.6 R6 — the ADR-0047 tension (named, and resolved — recorded so it is not re-opened)

ADR-0047 decision 2 fixes rules as compile-time Rust and parks a runtime-loadable rule DSL as out of
scope; §3.4 makes a target's repertoire its own semantics. §3.5 shows the tension **dissolves**: the
transform tier is not a rule tier, per-target authoring needs authored *data* rather than a loadable
rule language, and **ADR-0047 needs no rework**. Recorded here because it was called the design's
sharpest unresolved point, and because a build grove that re-opens it should re-open it *knowingly*,
against the evidence in §3.5, rather than by rediscovery.

### 5.7 R7 — the TypeScript outlier is not bloat, which is worse for the thesis

`emit-typescript` is 25,487 total / 11,387 production — roughly 2× racket. ⚠ **The excess is not
waste.** Its Lisp-comparable core is **3,517 production lines — smaller than every Lisp target's
production total** (chez 5,048 · sbcl 5,955 · racket 6,938 · gerbil 7,093). The 2× headline is
5,835 production lines of genuinely *new capability*: a typed `.d.ts` surface (ADR-0055) and a
four-table Swift bridge, neither of which has a Lisp analogue — plus a self-declared "third copy of
the ownership-registry family".

**Why this is a risk and not a footnote.** It means a target's mass is dominated by *what its
binding surface is*, not by emitter boilerplate — so the re-cut's leverage on the next
capability-rich target is smaller than the headline ratio implies. It also means **TypeScript is a
bad pilot**: its residual is the largest (~1,800–2,600) but does not generalise.

### 5.8 R8 — the strongest case *against* this architecture

Stated here so the build grove meets it deliberately rather than in month six.

1. **The closest thing to a fair trial is 20 months in and one-quarter done.** uniffi is migrating
   four *similar* targets in one paradigm family, and its model is still "unstable", its last mile
   "not yet implemented", and its old model still in tree. Our five-plus emitters are larger and far
   more divergent. A reasonable engineer can read that as evidence the migration never finishes and
   the repo carries two architectures indefinitely. **The answer this design offers is the pilot
   plus the kill criterion — not a claim that we would go faster.**
2. **wit-bindgen chose imperative generators for eight backends and does not appear to regret it.**
   The rebuttal is regime (12.2% vs ~40% text payload) — but note ⚠ **no primary source shows they
   ever considered and rejected templates**, which cuts both ways: it weakens them as counter-
   evidence *and* removes any record of a reasoned choice we could learn from.
3. **The most declarative tradition in this space retreated.** In the MDA/QVT lineage the
   declarative QVT-R never gained implementations while the imperative QVT-O did, and ⚠ **no primary
   source explaining why was found** — a search a future session should not repeat with web search
   alone (it needs the OMG/Eclipse mailing-list archives). The design's answer is that it is *not*
   proposing declarative transformation: §3.5 puts imperative typed passes at the centre and admits
   datalog only where the relation shape is genuine. **That answer is only as good as the discipline
   holding it.**
4. **The gains are mostly unattested.** ⚠ **Nobody ships a projection model as a reviewed diff
   surface** — the "reviewable model" gain was *claimed* by uniffi's author as a motivation and
   *realised* as a debugging CLI whose authors immediately hit the volume wall. Our version of that
   gain is therefore a hypothesis with one supporting anecdote.
5. **The cheapest honest alternative was never fully costed here**: fix the sister-target defect
   class with better shared *mechanism* (a whole-corpus pre-pass, a shared disposition classifier)
   and leave the emitters imperative. That buys some of the sixth-emitter-tax reduction at a
   fraction of the risk. **This document does not argue against it, and a build grove should price
   it before committing.**

---

## 6. Open questions

Each with what would settle it. A design-only investigation is allowed to hand over open questions;
it is not allowed to hide them.

| # | Question | What would settle it |
|---|---|---|
| **Q1** | **Where does M1 table-mode data live, and in what format?** ADR-0046 makes authored artifacts `.apiw` KDL, but `chez_builtins.txt` is a **machine-regenerated flat identifier list with a documented recipe**, and KDL-ifying a regenerated word list buys nothing. | A build-grove decision, taken **before migration two**, not discovered at it. This is the build grove's *first* authored-layer question. |
| **Q2** | **Test mass**: do rules + templates need fewer tests, the same, or more? | The pilot's instrumented before/after count (R2). Nothing else can. |
| **Q3** | **The five `bundle-*` crates (9,575 LOC) are unclassified.** Outside the emitter audit's subject but inside the adapter scope. `bundle-sbcl` has **no `bundle.rs` at all** (`dump.rs`/`stub.rs`/`vendor.rs`), suggesting the bundler surface is at least as divergent as the emitter surface. | Classify them the way the emitters were classified. Cheap, and it belongs early because it may enlarge the scope of §3.8. |
| **Q4** | **How big is a target's repertoire, and what does a repertoire file cost to author?** The two datapoints bracket it very widely: haskell-gi's **eleven directives** against gtk-rs's **4,092-line typed config schema (~13% of that generator)**. | Measure it on the racket pilot. Budget for the repertoire as a real component either way. |
| **Q5** | **Meta-schema (`.apiw` repertoire) or the SWIG fallback (per-target Rust node types)?** They differ by one layer (§3.4). | Deferrable by construction: build Rust node types first; lift to `.apiw` when a second same-family target makes the duplication visible. Decide with the pilot's authoring cost in hand. |
| **Q6** | **Is the M-tuple ordering globally consistent?** Each site's tuple is internally ordered, but no attempt was made to topologically sort all ~35 tuples into a single pass order. | A design exercise for the build grove, and **the natural first use of the per-stage model-diff instrument** rather than a paper exercise. |
| **Q7** | **Does an alien target need two adapter languages?** SWI-Prolog's FFI is registration-based, so it needs a **C shim between Prolog and the Swift adapter**. Whether that shim is generated, and by which target's templates, is unexamined. | Paper analysis when the first alien target is actually scheduled. Not a pilot blocker. |
| **Q8** | **Are the curated admission tables' keys currently colliding?** Three of the curated per-symbol tables use **bare-selector partial keys** whose safety rests on a corpus-uniqueness claim (*"one occurrence across all 252 frameworks"*) that could not be re-verified — this workspace has 153 families and both `extracted.kdl` and `resolved.kdl` are absent. A key needing a runtime panic to be safe is underspecified whether or not it has collided yet. | Cheap to measure **once layer 0 lands** (§3.9). |
| **Q9** | **Does the M-list hold for a *new* target rather than the five it was derived from?** `emit-ocaml` is the best available test and was deliberately not walked — reading a half-finished tree as evidence is the error the audit declined to make. | Walk `emit-ocaml` once its grove lands. |
| **Q10** | **Is `askama` still the right engine?** Verified current 2026-07-26 (0.16.0, 2026-04-29, 41M downloads). | Re-check at adoption time. The *external per-target files* decision does not depend on the answer; only the engine does. |

**Two things deliberately left unresolved rather than guessed:** the exact render/decision boundary
(measured as a **4.3%–17.0% bracket**, two rules, two answers — resolving it needs a per-line
judgement on ~4,000 mixed lines and the conclusion does not depend on where in the bracket the truth
sits), and the cross-target redundancy figure (a **9.6%–25% bracket**, three methods, three answers,
all reported).

---

## 7. ADR work the build grove owes

**Next free ADR number: 0062** (verified 2026-07-27 — 0018 and 0045 are absent; 0061 is the highest).
ADRs are `adr/NNNN-slug.md`, **globally numbered** (ADR-0024) — *not* `docs/adr/<slug>.md`. This
investigation minted none.

**Likely to mint** (each only if the when-to-write test holds at the time — do not mint speculatively):

- **The projection model and the model transform** — the architecture decision itself: instance-level,
  derived-and-uncommitted, staged typed-Rust passes with `ascent` as one pass kind. This is the one
  ADR the design clearly owes.
- **The template engine and the template contract** — Askama, external per-target files,
  computation-free/branching-allowed, with the display-concern filter exception. A new workspace
  dependency plus a contract that binds future authors.
- **The escape-hatch repertoire M1–M5** — including table mode, the reconcile clause, and M4's
  *reserved and unexercised* status. Worth an ADR because it is a **closed** repertoire: the
  decision being recorded is as much "no sixth mechanism without re-opening this" as it is the five.
- **The golden-INTENTIONAL bar and the four-layer stack** — it changes what "the tests pass" means.

**To rework in place — never supersede** (this repo edits ADRs in place per ADR-0024 and
`linkuistics:decision-records`):

- **ADR-0011** — *only if* the meta-schema is judged to be shared target semantics after all. Under
  §3.4's MS-A reading it is mechanism and **no rework is needed**; the SWIG fallback (§3.4) satisfies
  ADR-0011 by construction. **If the build grove drifts to MS-B, ADR-0011 must be reworked, and that
  is the tripwire.**
- **ADR-0047** — ⚠ **no rework needed** under §3.5; recorded here because the tension was real and a
  build grove that reverses the compile-time-rules decision **must** rework 0047 in place rather than
  appending a superseding ADR.
- **ADR-0051 / the workstream-6 target model** — reworked when the authored layer gains its first
  generation-side consumer (R4) and when `EmitConstruct` leaves `targets/_shared` (§3.4(b)). The
  latter is a change to shipped ws6 artifacts (`CONTEXT.md` §ws6 decision D3) and touches
  `schemas/spec-format/idioms.kdl-schema:127`.
- **ADR-0044** — touched only if the shared substrate's *contents* change category; its placement
  principle is unaffected and is in fact what the design relies on.

**Also owed, and not an ADR:** `CONTEXT.md` entries for `projection model`, `model transform` and
`construct vocabulary`, **plus a disambiguation clause on the existing `target model` entry's
`_Avoid_` line** — landed when the code exists (§2.4).

**Repo conventions that override grove defaults**, so a build grove does not fight them:

- ADRs: `adr/NNNN-slug.md`, globally numbered. Not `docs/adr/`.
- Human-facing agreement checkpoints: `prd/<date>-<slug>.md`. Not `docs/specs/`.
- Research: `<domain>/docs/research/<date>-<slug>.md`; cross-cutting research goes to
  `targets/_shared/docs/research/`.
- There is **no top-level `docs/` tree** — docs co-locate with their domain.

---

## 8. A proposed decomposition for the build grove

**A proposal, not a mandate.** The build grove may reject it. The two things that are *not*
negotiable if the design is followed are the **pre-registered kill criterion** and **layer 0 before
any measurement claim**.

**Shape: a single-target pilot on racket, full corpus, then one grove per remaining target.** Not a
fleet migration — uniffi is 20 months in at one of four, with *similar* targets.

**Why racket, on three grounds** (⚠ a fourth ground, *"it holds the repo's only clean M4 site"*, was
found to be **false** — §3.10 amendment 3 — and the pick stands on the other three):

1. **It tests the most contested claim hardest.** Racket's contract layer (`map_param_contract`,
   `map_return_contract`, `build_export_contracts` at 121 lines, `collect_predicate_class_names`) is
   *"the clearest per-target semantics in the repo … Nothing analogous exists in any other target"* —
   exactly a per-target rule set over a shared meta-schema.
2. **Its residual is mid-range (~700–1,100), so the measurement generalises**, and it has working
   committed goldens (11 files, 484 lines) so §3.9 layer 2 is available.
3. **Migrating it forces a real cleanup**: 143 of the shared `ffi_type_mapping.rs`'s 263 production
   lines are racket's — one target's semantics inside the shared substrate (§3.4(a)).

**Rejected pilots.** *typescript* — largest residual, but its groups A+B are capability no other
target has, so the number does not generalise (R7). *chez* — smallest residual (~600–900) and least
divergent, the easy case that produces no evidence about the only question that matters, and whose
residual would **underestimate** — the dangerous direction when the estimate is already suspected
2–4× low. *gerbil* — holds the only M5 (reconcile) site and the largest golden set, but trades away
the contract layer.

**⚠ What racket does NOT exercise — the corrected coverage, which the build grove must cover on
paper rather than discover at migration four:**

| mechanism | racket | exercised instead by |
|---|:--:|---|
| M1 override, declaration-keyed | ✓ | `KNOWN_UNBINDABLE` (51), `is_libdispatch_unexported` (5) |
| M1 type-keyed | ✓ | contract mappers, `GeoStruct`, `RacketFfiTypeMapper` |
| **M1 table mode** | **✗** | chez (1,715 entries) · sbcl (27) · typescript (6) |
| M2 | ✓ | both content hashes, identifier formation, contract/predicate derivation |
| M3 (incl. `ascent`) | ✓ | global signature dedup, per-file export contracts, class ordering, disambiguation set algebra |
| **M4** | **✗** | **nowhere — no site in the repo** (§3.10) |
| M5 (list) | ✓ | five ways in `emit-racket/src/emit_framework.rs:49-152` |
| **M5 (reconcile)** | **✗** | gerbil only |

So **two** mechanisms need paper coverage ahead of the pilot, not one: **M1 table mode** (Q1 above)
and **M5 (reconcile)** (one clause at the renderer/driver seam — cheap now, the sixth-emitter tax if
retrofitted).

**Proposed leaf sequence.** Evidence and instruments before commitment; each child a vertical slice
that stands demoable on its own.

| # | Leaf | Kind | Why here |
|---|---|---|---|
| 1 | **`materialise-corpus-baseline`** | work | §3.9 layer 0: materialise `resolved.kdl` for all 153 families, re-bless the stale goldens, give chez *something*. **Everything downstream measures against this**, and R1 makes it load-bearing rather than hygienic. |
| 2 | **`model-diff-instrument`** | work | The per-stage diff tool, with `--pass` / `--type` / `--name` and per-framework scoping designed in. **The pilot's first deliverable, not its tooling afterthought** — it is the equivalence instrument, the only one that works for chez, and the natural first use is Q6. |
| 3 | **`projection-model-and-pass-framework`** | work | Node types, the staged pass framework, `ascent` admitted as one pass kind, the `Vec<(path, content)>` renderer contract **with nesting (A3) and reconcile (M5)**. Repertoire as **Rust node types first** (Q5's deferral). |
| 4 | **`table-mode-and-reconcile-paper-check`** | planning | The two mechanisms racket will not exercise. Decide Q1's format-and-home question **before** it surfaces at migration two. |
| 5 | **`racket-pilot`** | work | Full 153-family corpus. **Pre-register the kill criterion before starting.** Instrument: escape-hatch share, test LOC per bucket before/after (R2), repertoire size (Q4). |
| 6 | **`pilot-verdict`** | planning | HITL. Against the pre-registered criterion, with a human, in those words: *continue*, *adjust*, or *stop*. This leaf is what makes the pilot falsifiable; a grove without it has merely committed. |
| 7 | **`deviation-list-and-adr-set`** | work | Enumerate the deviation list exhaustively (§3.9); mint §7's ADRs; land §2's `CONTEXT.md` entries; add the deletion-test lint and the longitudinal ratio artifact. |
| 8+ | **one leaf (or grove) per remaining target** | work | chez, gerbil, sbcl, typescript — and **OCaml last**, as one of the N, after its own grove lands. |

**Two standing requirements across the whole sequence.**

- **The escape-hatch measurement is only meaningful over the full corpus** (R1). Do not report a
  share from a framework subset.
- **The deletion test (§3.4(a)) applies to every new `targets/_shared` artifact from leaf 3 onward.**
  It is a build-time lint, cheap at the start, impossible to backfill — and it is the tripwire for
  R5.

---

## 9. Provenance

**How the re-verified numbers in §4.1 were taken** (2026-07-27, this workspace, working tree at
`main`):

```sh
for t in racket chez gerbil sbcl typescript; do                    # 71,719
  find targets/$t/tools/emit-$t -name '*.rs' -print0 | xargs -0 cat | wc -l; done
find targets/_shared/tools/emit -name '*.rs' -print0 | xargs -0 cat | wc -l      # 4,092
find targets -name '*.apiw' -print0 | xargs -0 cat | wc -l                       # 1,491
for t in racket chez gerbil sbcl typescript; do                    # 9,575
  find targets/$t/tools/bundle-$t -name '*.rs' -print0 | xargs -0 cat | wc -l; done
ls platforms/macos/api/ | wc -l                                                  # 153
grep -n 'resolved.kdl' .gitignore                                                # :10-11
grep -rn 'apianyware-target-model' targets/*/tools/emit-*/Cargo.toml             # (none)
grep -n 'ascent\|askama\|tera\|handlebars\|minijinja' Cargo.toml                 # ascent = "0.7"
wc -l CONTEXT.md                                                                 # 2,413
ls adr/ | tail -3                                                                # 0061 highest
```

**Everything else** is dated and attributed to the research document that measured it (§4.4); those
documents state their own measurement rules inline so each number is auditable and re-runnable.

**ADR quotations in §3.4 and §3.5 are verbatim**, checked against the ADR text 2026-07-27:
ADR-0011 Consequences — *"The emitter framework may share **mechanism** (code-writing utilities) but
not target **semantics**"*; ADR-0044 Consequences — *"it governs runtime/output, not emitter
**code**"* and *"`targets/_shared/` becomes the established home for any future cross-target
**machinery**"*; ADR-0047 decision 2 — *"**Compile-time** rules (not a runtime-loaded DSL). They live
in version-controlled Rust; … a runtime-loadable rule DSL is a possible later enhancement (would need
a runtime datalog engine — out of scope)."*

**One standing caveat for any session reading older prose in this repo:** the repo is mid-way through
a `structural-refactoring` workstream (`REFACTOR.md`, `TODO.md`). The domain tree is authoritative
for where things live, and some older prose still names pre-refactor paths. **Treat path strings in
older docs as suspect; verify against the tree.** Every path in *this* document was checked
2026-07-27.
