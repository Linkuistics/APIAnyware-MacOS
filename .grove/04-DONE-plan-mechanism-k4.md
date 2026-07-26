# plan-mechanism-k4

**Kind:** planning

## Goal

The second grilling. `plan-k1` deliberately left the mechanism unsettled pending evidence
(Q4); this leaf settles it, with the audit (`k2`) and the prior-art survey (`k3`) in hand.

Deliverable is **decisions, recorded in the running log below** — not code, not ADRs, not
glossary entries (charter Q5/Q6). `write-handoff-doc-k5` transcribes them.

## Context

Beyond the brief chain:

- `targets/_shared/docs/research/<date>-emitter-anatomy-audit.md` (from `k2`) — especially its
  escape-hatch inventory and statefulness list.
- `targets/_shared/docs/research/<date>-model-transform-codegen-prior-art.md` (from `k3`) —
  especially its Synthesis section.
- `adr/0047-convention-heuristics-as-datalog-rules.md` — decision 2 fixes rules as
  **compile-time** and parks a runtime-loadable rule DSL. Whether the transform tier reverses
  that is a question for this leaf, and reversing it means **reworking ADR-0047 in place** for
  the build grove, never appending a superseding ADR.
- `adr/0046-spec-interchange-format-kdl-everywhere.md` — if the projection model is a committed
  artifact, `.apiw` KDL is the presumptive format and this ADR says why.

## Questions to grill

Sequenced so foundational answers land before derived ones. Ask one at a time.

1. **The escape hatch — first, because it bounds everything else.** Given `k2`'s inventory of
   what rules-plus-templates cannot express, what is the escape hatch? Candidate shapes: a
   per-target Rust hook invoked from the transform; a template helper/filter registry; an
   `unsafe`-flavoured "hand-written region" in the projection model; or accepting that some
   fraction of each target stays imperative and scoping the architecture to the rest. **If the
   escape hatch has to be large, the thesis is weaker and the handoff doc must say so.**
2. **Transform mechanism.** `ascent` datalog (proven in five crates, all upstream of the IR),
   compile-time as ADR-0047 fixed? Or does per-target authoring (Q3) require runtime-loaded
   rules, since a target's rules are its own semantics? Note the tension: Q3 says rules are
   per-target authored data, while ADR-0047 says rules are version-controlled Rust — those pull
   in opposite directions and this is the sharpest unresolved point in the design.
3. **Projection model artifact status.** Committed `.apiw` (reviewable, diffable, becomes the
   golden surface, rots against SDK drift) or derived-in-memory (constraint-4 clean, cheap, but
   no review surface)? The repo has precedent both ways: `resolved.kdl` is committed and derived;
   representability status is derived-and-deliberately-uncommitted.
4. **Template mechanism.** Which engine, or none? The workspace currently has **no** template
   engine, so this is a new dependency. Weigh `k3`'s evidence on logic-leaking-into-templates.
   A serious option is a small purpose-built renderer over the projection model rather than a
   general engine — evaluate it rather than assuming a third-party crate.
5. **Output scope.** Does the projection model cover only the scripting-side bindings, or also
   the Swift adapter sources and the docs? `k2` Q5 establishes what is generated today; the
   charter names all three. Decide what the build grove targets.
6. **Equivalence-proof strategy.** How would a build grove prove the new path reproduces the
   old? Goldens-as-truth is the repo's instrument, but **chez has no golden mechanism at all**,
   so chez needs a different answer. Also decide whether equivalence is even the right bar, or
   whether the new path is permitted to produce *better* output and move goldens intentionally.
7. **Build-grove decomposition.** What shape does the follow-on grove take — pilot-plus-four,
   or grove-per-target? Which target pilots, and why? (`k2` Q7 and Q8 give the evidence: the
   pilot should be the target whose residual-Rust estimate is most informative, not necessarily
   the smallest.) Does the build grove absorb the in-flight OCaml target or leave it?

## Done when

- Each question above is settled and recorded in the running log with its rejected
  alternatives and the evidence that decided it — the same shape as `plan-k1`'s log, since
  `k5` transcribes from it.
- Any question the evidence **cannot** settle is recorded as an explicit open question with
  what would settle it, rather than being resolved by guesswork. A design-only grove is allowed
  to hand over open questions; it is not allowed to hide them.
- If the grilling changes anything settled in `plan-k1` (Q1–Q3), the root brief's
  "Settled design" section is **edited in place** to say what now holds — current-state, not a
  changelog.

## Decisions (running log)

**Q1 — the escape hatch is the closed five-mechanism repertoire M1–M5, provisionally.**
Settled 2026-07-26. k2 framed the hatch as one thing; k3 §10 establishes it as five, closed
across seven surveyed systems: **M1** authored declarative data keyed by path or declaration
identity (uniffi `exclude`, haskell-gi `set-attr`, SWIG `%feature`, bindgen blocklist);
**M2** a host function in a transform pass whose result becomes a model field (uniffi
`names.rs`, gtk-rs `nameutil`, Djinni `Marshal`); **M3** an imperative pass staged between
declarative ones (uniffi `MapNode` + `#[map_node(expr)]`, gtk-rs `analysis`, SWIG's four
stages); **M4** a named insertion point / deferred region in emitted text (protoc
`@@protoc_insertion_point`); **M5** a data-dependent output file list from the renderer
(protoc `CodeGeneratorResponse`, `windows-bindgen`). The brief's four candidate shapes all
collapse into these — "per-target Rust hook" is M2/M3, "template helper registry" is the
thing uniffi explicitly demotes (prefer a pass to a filter; filters only for pure display
concerns like indentation), "hand-written region in the model" is M4, and "accept some
fraction stays imperative" is the sizing question, split out as Q1b.

Three riders, all adopted:

- **M1 splits by keying, from day one.** SWIG (`%typemap` vs `%feature`) and uniffi
  (typemap-ish passes vs `exclude`) converged independently, 25 years apart, on type-keyed
  and declaration-keyed authored data needing *separate* mechanisms. Our E1/E7 are
  declaration-keyed; the type substitutions `emitter-contract.md` tells authors to hand-copy
  are type-keyed. A design offering one will grow the other badly.
- **A general-purpose expression language inside the rule engine is the named anti-pattern**
  (k3 §9 Q2 option (b) — the only one of four nobody shipped). Evidence: SWIG's
  `$typemap(method, typepattern)` special-variable macros drove the typemap layer into
  pattern-match precedence rules, a documented comparison with C++ templates, and a
  `-debug-typemap` debugger (k3 §3.6).
- **Sites are M-*combinations*, not M-assignments.** E5 is M1 (the 1,715-symbol
  `chez_builtins.txt`) *plus* M2/M3 (intersect-sort-dedup over the whole file's export set);
  E1 presupposes E2, since the suppression table is keyed by the FNV hash. A closure check
  must let a site name a tuple.

Closure is recorded as **provisional**: k3 §10.1 says nothing in the audit *appears* to need
a sixth mechanism but that the claim needs a site-by-site check before it can be asserted.
Rejected: asserting closure now on k3's sketch (asserts more than the evidence carries);
collapsing to host functions alone (discards the keying split two systems found necessary,
and has no answer for E6's data-dependent file set); deferring the repertoire to the pilot
(hands over less than the evidence supports).

**Carried into Q3/Q7 — E1 is not per-target data.** k3 §9 Q14 produces a finding k2 did not:
`KNOWN_UNBINDABLE` is byte-identical in four emitters because the rejecting compiler is the
same compiler. It is *Swift-adapter-toolchain* truth, not target semantics, and under GIR's
siting rule belongs beside the Swift adapter **once**, keyed by declaration identity — not in
each target's authored repertoire. This qualifies root-brief Q3 rather than contradicting it.

**Q1b — plan against a ~40% escape hatch; the thesis is *form*, with mass a secondary
effect.** Settled 2026-07-26. k2 §8 estimated 10–20% residual hand-written Rust (its own
table is 5,900–8,700 against 37,287 production lines ≈ 16–23%). k3 §9 Q5 measures three
independent, long-lived, source-generating systems at **35–45%**: SWIG java 43.4%, SWIG
csharp 41.4%, SWIG 17-target aggregate 39.2%, gtk-rs-core binding crates ~36%. Two features
of that evidence make it harder to discount, not easier: k3 §3.2's own caveat is that
`Lib/<lang>/` carries target-language runtime support as well as typemaps, so 60.8%
declarative is an **upper** bound and ~39% imperative a **lower** bound; and our shape sits
in SWIG's **Java/C# regime** (generating target-language *source*), which is precisely where
its declarative share is *highest*. The one genuine consolation is narrow: hand-written code
concentrates in the runtime/substrate (glib 87.6%, SWIG's `pyrun.swg`), which the charter
does not propose to generate — the binding surface itself reaches 60–80% generated.

**The recomputed headline the handoff doc must carry.** At 40%, 37,287 production lines →
~14,900 residual: a **2.5× reduction, not 4.3–6.3×**. Test mass (35,298 lines, 49.2% of the
71,719 headline) is unquantified here *and* silent in the entire prior art (k3 §9 Q11 — no
system anywhere reports test mass before and after such a migration). So the honest headline
is **71,719 → ~50,200 lines of Rust**, plus ~3,000–6,000 lines of authored rules and data,
plus ~70 KB of templates — roughly **30%**, not an order of magnitude.

**Consequence accepted: the thesis relocates onto form, and that is where `plan-k1` already
put it** ("the value is *not* cross-target reuse … it is the change of **form**"). Q1b makes
that framing mandatory rather than preferred. The form arguments carry independent evidence:
the sixth-emitter tax (k2 §6.4 — one defect found once, then four fixes, four golden
re-blessings, four VM verifications) and the contributor-filter finding (k3 §2.4c — a C#
interop expert blocked from fixing the C# backend by the *generator's* implementation
language, testifying from inside the counter-evidence system).

**Two instruments adopted with the number**, both from k3 §10:

- **A pre-registered kill criterion** (§10.2), so the pilot is falsifiable rather than a
  commitment: *if the pilot's imperative share exceeds ~50%, or exceeds its own pre-pilot
  estimate by more than 1.5×, the re-cut is not paying for itself.*
- **A longitudinal escape-hatch ratio** (§10.3), emitted as a build artifact per target per
  release. No surveyed system measures whether its hatch grew, so the metric would have to be
  ours; k2 named a hatch growing to 50% as "the failure mode this design must be able to see
  coming", and the instrument is cheap at the start and impossible to backfill.

Rejected: a 15–40% bracket (too wide to pre-register a meaningful kill criterion against);
40% without the reframing (leaves the charter's order-of-magnitude framing standing
uncorrected); holding 10–20% (argues against the survey's strongest evidence, and k3 §3.2's
caveat cuts the wrong way for that case).

**Q2 — the transform is typed Rust node-to-node passes, with `ascent` admitted as one narrow
pass kind. ADR-0047 needs no rework.** Settled 2026-07-26. The brief poses this as a binary —
datalog compile-time per ADR-0047, or runtime-loaded rules per Q3's per-target authoring —
and calls it the design's sharpest unresolved point. **The tension dissolves rather than
resolving**, because the premise both horns share (that the transform tier is a *rule* tier)
is not supported by the survey: **no surveyed system uses a rule engine for the projection
transform.** uniffi uses typed Rust node types plus `#[derive(Node, MapNode)]` with
hand-written pass functions (k3 §1.3); gtk-rs uses an imperative `analysis` phase; SWIG pairs
pattern-matched typemaps (declarative *data*) with imperative C++ per target; wit-bindgen
interprets an instruction stream; and in the MDA lineage the declarative QVT-R never gained
implementations while the imperative QVT-O did. k3 §9 Q2 ranks **(c) a staged pipeline with
imperative passes between declarative ones** the unanimous winner.

**Why datalog is the wrong shape for this tier specifically.** ADR-0047's domain is monotone
fact derivation over a relational fact base — datalog's home ground, where provenance falls
out of the derivation trace. Projection is *structural mapping*: one node per emitted thing,
with derived identifiers, total ordering, and accumulation. Datalog is weak at exactly our
hard escapes — E2 (FNV arithmetic), E3 (bit-packing), E4 (character-level scanning) all need
host functions — and k3 §9 Q8 notes datalog yields **sets** where `ordered_classes` needs a
**total** order for golden stability.

**Why Q3 does not require runtime-loaded rules.** Per-target authoring needs authored
**data**, read at generation time by compiled Rust — not a loadable rule language. That is
already shipped in this repo: `emit/pattern_dispatch::classify_pattern` reads the authored
`.apiw` idiom catalogue and renders a closed `EmitConstruct` taxonomy, golden-neutral, and is
the nucleus `plan-k1` identified. So **ADR-0047 decision 2 stands untouched** — it governs
the analysis tier, and its parked runtime-loadable rule DSL stays parked. This leaf therefore
mints no ADR *and* triggers no ADR rework, which is the outcome charter Q6 wanted.

**Where `ascent` still earns a place.** k2 §2.3's soft escapes are genuinely relation-shaped
and today duplicated 3–5× at Jaccard 1.00: transitive protocol reachability with cycle guard,
`conformance_closure` (15 lines, identical in gerbil/sbcl/typescript), the three ownership
registries. Admitting `ascent` as **one pass kind inside the staged pipeline** — not as the
engine — is k3's option (c) exactly, keeps ADR-0047's precedent working where it fits, and
k2 notes a whole-corpus transform additionally *deletes* `emit_protocol.rs`'s
`is_known_protocol` scope-limit fallback.

**Rider adopted — separate node types per stage, accepting struct duplication.** uniffi's
first implementation was one shared IR mutated in place via `VisitMut` plus a per-language
`lang_data` bag — our tempting shortcut — and bendk replaced it with explicit IR-to-IR
conversion, in writing (k3 §1.6): *"The main downside of this new approach is we need to
duplicate some structs. However, I don't really mind it … The Python structs are
significantly different."* Adopt the shape they landed on, not the one they tried first.

**Cost recorded honestly:** uniffi's shared `general` pass is 710 lines of node declarations
against **2,858 lines of hand-written pass functions**; ~72% of fields ride the derived
recursion free, and the ~28% that do not consume ~80% of the transform's code (k3 §1.3).
Consistent with Q1b's 40%.

Rejected: `ascent` as the transform engine (no surveyed precedent; E2/E3/E4 and total
ordering fall outside what datalog expresses); typed Rust passes with no datalog at all
(gives up provenance on the derivations where the repo already has an engine that supplies
it); a runtime-loaded per-target rule DSL (reverses ADR-0047 decision 2 and forces an
in-place rework, for a mechanism nobody shipped and whose nearest approach — SWIG's
special-variable macros — is the survey's accretion cautionary tale).

**Q3 — the projection model is derived and uncommitted, dumpable per stage and diffable per
pass.** Settled 2026-07-26.

**Two corrections to this leaf's own brief, both verified this session.** (i) The brief says
*"the repo has precedent both ways: `resolved.kdl` is committed and derived."* It is not
committed — `.gitignore:10-11` excludes `extracted.kdl` and `resolved.kdl`, and `jj file
list` finds **zero** tracked `resolved.kdl` against **152** tracked `annotations.apiw`. The
repo's precedent is **one-way: derived artifacts are gitignored, authored artifacts are
committed**, and `CONTEXT.md` §ws6 gives the reason on the representability entry —
*"derivable → rots against SDK/binding drift"*. (ii) The brief says "committed `.apiw` KDL";
ADR-0046 §2 splits these — `.apiw` is the **authored** overlay on the format-preserving `kdl`
crate, while machine artifacts are `.kdl` through the **non-preserving JiK codec** in
`semantic/tools/spec-format`. A dumped projection model is a machine artifact, so `.kdl`.

**The prior art is unanimous** (k3 §9 Q9): five of seven systems serialise a model; **none
commits a projection model as a reviewed diff surface.** GIR and WinMD ship the *source*
model, not a projection. uniffi's is in-memory behind a `pipeline` peek/diff CLI; SWIG has
`-xmlout` and `-debug-top 1,2,3,4`. uniffi's authors hit the volume wall — *"This is a lot of
data. Use CLI flags to reduce it to a reasonable amount"* — at a corpus vastly smaller than
153 frameworks × ~40,000 methods × five targets.

**What replaces the review-surface benefit — and it is stronger than what it replaces.**
k3 §9 Q10: **per-stage model diffing is the only technique the prior art reports as having
actually caught migration bugs** (bendk: *"I had a few errors when re-implementing all of the
code and `peek` came in very handy to fix them"*). It is independent of goldens and **works
for chez**, which has no golden mechanism at all — so it answers the charter's chez problem
(root brief, "On the horizon") rather than deferring it. Named as the pilot's **first
deliverable, not its tooling afterthought**, with `--pass` / `--type` / `--name` filters and
per-framework scoping designed in from day one.

**`plan-k1` Q1(ii) survives intact.** k1 accepted that "the natural golden surface moves from
emitted text to the projected model". Committing *goldens of the model over a bounded
fixture* is a different act from committing *the model for the real corpus*: today's
`TestKit` fixture (five classes, two protocols) is already that shape. Model goldens are
committed at fixture scale; the corpus-scale model stays derived, and the volume problem
evaporates.

Rejected: committing the full-corpus model (no surveyed precedent; rots against SDK drift for
exactly the reason `CONTEXT.md` gives for representability; uniffi hit the volume wall far
below our scale); in-memory with no dump (gives up the only equivalence instrument the prior
art reports as working, and the only one available to chez); committing a fixture-scale model
as the primary review artifact (inverts which instrument does the work — the diff tool
carries it, the fixture model is a golden).

**Q4 — Askama, with templates as external per-target files, under a computation-free
contract.** Settled 2026-07-26.

**Stated plainly, because the handoff doc must carry it: templates are the cheapest and least
valuable part of this proposal** (k3 headline #4). Our emitted-text payload is **4.4%** of
production source under k2 §2.2's strict rule (2,273 literals, 70,852 bytes of 1.63 MB) and
**12.2%** under k3 §2.3's coarser one; wit-bindgen's template-free generators measure **~40%**
by that same coarser rule — their `format!` calls *are* their templates. We are in the
opposite regime, where the transform carries the whole prize. Any framing that sells the
re-cut on templating is wrong.

**The template contract is `computation-free, branching allowed`** — set by what uniffi
measured (k3 §1.2), not by what the charter hoped. Their migrated Python backend has **6–15×
fewer computations** in templates than its unmigrated siblings (14 method calls in
expressions vs Kotlin 87, Ruby 204) but only **~25% fewer branches** (406→239 control
directives, one per 9.2 template lines). A logic-free template did not emerge and uniffi never
claimed one would. Their principled exception is adopted with it: pure *display* concerns stay
filters, because *"implementing this as a pipeline pass means the pass would need to know how
much each docstring gets indented, which doesn't seem right."*

**Engine: `askama`**, verified this session against crates.io — **0.16.0, published
2026-04-29, 41M downloads**, actively maintained; the `rinja` fork that existed during
askama's maintenance gap is now `0.4.0+deprecated`, i.e. merged back. Compile-time and typed,
and proven at this exact job in uniffi.

**Templates are external per-target files — that is the load-bearing choice, not the engine.**
It is what buys k3 §2.4c's contributor-filter benefit: a Racket expert edits
`targets/racket/templates/<x>` and runs `cargo build`, rather than reading 14k lines of
imperative Rust. The witness for that benefit is hostile and specific — a C# interop expert on
wit-bindgen issue #1265: *"I'm unfortunately not familiar with Rust at all … the current code
is somewhat overwhelming."*

**Compile-time vs runtime, and the Q2 consistency question, resolved by principle.** Q2 puts
per-target authored *data* at generation time; templates are per-target too, so runtime
loading (minijinja) would be the consistent-looking choice. Rejected: **the split is by what
the artifact is, not by who authors it.** Authored *data* the transform consults is read at
generation time; templates are *code-shaped* — they carry control flow — so they compile.
uniffi splits exactly this way (`uniffi.toml` excludes runtime-read, Askama templates
compiled). Compile-time additionally type-checks templates against the projection model's node
types, which matters precisely because target experts rather than Rust experts author them.

**Two things needing no engine support.** M5's data-dependent file set is satisfied by making
the renderer's output contract `Vec<(path, content)>` rather than one-template-one-file — k3
§9 Q4 says this costs nothing if designed in. And `emit/code_writer.rs`'s
`CodeWriter`/`FileEmitter` (211 lines) survives *beneath* the engine as file-set assembly.

Rejected: a purpose-built renderer over the model (given a fair hearing per the brief — 70 KB
of templates, no new dependency, and `code_writer.rs` at 211 lines is already almost exactly
wit-bindgen's whole 222-line `source.rs`; but it fails on the branching number, since control
flow that lives in surrounding Rust today *moves into the template*, so a renderer supporting
`{% if %}`/`{% for %}` **is** a template engine — built in-house, without SWIG's 30 years of
hardening or its debugger); minijinja (gives up template type-checking for a consistency the
principle above shows is false); no engine at all (honest given our text share, but preserves
the contributor filter and forecloses external templates entirely).

**Q5 — scope is binding source + Swift adapter sources + doc comments in generated source.
Standalone `.md` docs are out.** Settled 2026-07-26.

**What is generated today** (k2 §5.2, measured): the **Swift adapter sources are generated** —
nine global CLI passes write into each target's Swift package, and all five `Generated/`
directories are gitignored, confirming it (racket: `Dispatch.swift` + `Trampolines.swift`;
chez/gerbil/sbcl: `Trampolines.swift`; typescript: four `.swift` tables). The charter's
"dylib" output is therefore already in scope, not aspirational. The **docs are not
generated** — zero `.md` writes in the emitters; all 1,834 lines across 20 files are authored
prose.

**Why the adapter is in, and close to mandatory.** (i) It is the same drift problem
`emit-typescript/src/class_surface.rs` already solves — one resolved surface, two renderers,
*"so the two artifacts provably cannot drift"* — one level up. Excluding it means the
transform resolves method dispositions and the adapter re-resolves them separately, which is
today's duplication preserved. (ii) **Q1's rider needs it**: `KNOWN_UNBINDABLE` is
Swift-adapter-toolchain truth keyed by the `@_cdecl` entry name, and with the adapter outside
the model that authored data has nowhere principled to live. (iii) It does not strain the
model's shape — the adapter is per-target Swift, so "one projection model per target×platform"
already covers it.

**The docs question splits in two, because k2 shows two things wearing one word.** *Doc
comments in generated source* (deprecation notices, `Method.doc_refs`) are emitted text and a
template concern, and the machinery already exists **dead**: `doc_rendering.rs` is 209 lines
with zero callers workspace-wide, `Method.doc_refs` appears in production only as
`doc_refs: None`, and the OCaml grove's `deprecation-invisible-in-sister-targets-k31`
independently found **226 IR-deprecated declarations** all five targets say nothing about.
These are in scope — they fall out of templates. *Standalone `.md` documentation files* are
authored prose and stay out: generating them is a new capability rather than a re-cut, there
is no "before" to prove equivalence against, and it inflates the pilot's surface for no
evidence gain.

**Open question carried, not answered:** k2 §9.5 — the five `bundle-*` crates are **9,575 LOC,
unclassified**, outside the audit's `emit-*` subject but touched by the charter's adapter
scope; `bundle-sbcl` has no `bundle.rs` at all (`dump.rs`/`stub.rs`/`vendor.rs`), suggesting
the bundler surface is at least as divergent as the emitter surface. The handoff doc names
this as a build-grove open question with what would settle it (classify the bundlers the way
k2 classified the emitters).

Rejected: bindings + adapter without doc comments (keeps the equivalence comparison exact, but
leaves shipped-and-dead machinery dead for no gain when templates supply it free); bindings
only (preserves the duplicate resolution the re-cut exists to remove, and strands E1);
all three including standalone `.md` docs (no equivalence baseline exists, and it converts a
re-cut into a re-cut plus a new capability).

**Q6 — the bar is golden-INTENTIONAL with a pre-enumerated deviation list, proved by a
four-layer instrument stack.** Settled 2026-07-26.

**The baseline does not currently exist**, and this is worse than the brief assumed. k2 §5.3:
four of five targets' corpus snapshot tests silently take a `SKIPPED` path because
`resolved.kdl` is gitignored and absent; chez has no `snapshot_test` target at all; the only
goldens that run cover a synthetic five-class `TestKit`. And the OCaml grove's
`sister-target-goldens-stale-against-the-corpus-k29` **measured** what happens on
materialising `resolved.kdl`: racket 2 failures, gerbil 1, sbcl 1, typescript 1, plus two
non-snapshot `apianyware-generate` failures. The goldens are not merely inert — they do not
describe today's output either.

**The prior art removes the pressure rather than adding to it** (k3 §9 Q10): no system
reported a formal equivalence proof, and none reported golden-output diffing as the instrument
that caught regressions. What caught bugs was **per-stage model diffing**. wit-bindgen's C#
backend meanwhile shipped **non-compiling output for months** because a fixture set
`ImplicitUsings=true`, masking a missing import — the golden compiled, so nobody looked.

**Consequence: chez stops being special.** With per-stage model diffing primary for *all*
targets, the asymmetry the charter worried about disappears — chez is not a gap in the
strategy, it is the target that makes the strategy's shape obvious. This is the direct answer
to the root brief's "On the horizon" chez item.

**Equivalence is not the bar, and Q5 already settled that implicitly.** Adding doc comments
changes output by construction; so does fixing the property-getter defect (74 of Foundation's
1,259 and 264 of AppKit's 2,634 properties rename their getter — `NSView.hidden`,
`NSControl.enabled`, `NSWindow.visible`, each building clean and failing at the call); so does
surfacing the 226 IR-deprecated declarations; so does the whole-corpus transform **deleting**
`emit_protocol.rs`'s `is_known_protocol` scope-limit fallback, which changes how
cross-framework protocol ancestors resolve. The repo's own vocabulary already names this:
`CONTEXT.md` §ws6 distinguishes **golden-neutral** from **golden-INTENTIONAL**. The re-cut is
golden-INTENTIONAL, and the enforceable bar is:

> **Every output diff is either on a pre-enumerated deviation list, or it is a regression.**

Stronger than "equivalence" (already false) and stronger than "better" (unfalsifiable).

**The four-layer stack:**

| layer | instrument | what it proves |
|---|---|---|
| **0. Prerequisite** | materialise `resolved.kdl`; re-bless the stale corpus goldens | that a baseline exists at all |
| **1. Primary** | per-stage model diff, built first (Q3) | the transform's decisions — chez included |
| **2. Secondary** | corpus output goldens on ≥1 target | the emitted *text*, which layer 1 cannot see |
| **3. Tertiary** | compile-the-output under **strictest** settings + existing per-target VM-verify | that it works, with wit-bindgen's masking lesson applied |

Layer 0 is named as **prerequisite work** per k3 §9 Q10's residual gap ("k4 must name
materialising them as prerequisite work"). Layer 3's "strictest settings" is the direct
countermeasure to the `ImplicitUsings` failure.

**Deviation list — seeded here from evidence, enumerated exhaustively by the build grove:**
doc comments in generated source (Q5); the property-getter selector defect; the 226 deprecated
declarations; naming corrections in E3's `case_tag` neighbourhood; and the protocol-resolution
changes that follow from deleting the `is_known_protocol` fallback.

Rejected: byte-equivalence first, deviations as a follow-on (contradicts Q5's scope and
re-blesses goldens twice); model diff alone (k3 §9 Q10's own residual gap — model-diffing
proves the *transform* did not change, not that emitted *text* is unchanged); building chez a
golden mechanism first (restores the familiar instrument, but doubles down on the technique
the prior art says did *not* catch migration bugs).

**Q7 — a single-target pilot on racket with a pre-registered kill criterion, then one grove
per remaining target. OCaml is left alone.** Settled 2026-07-26.

**The shape is settled by the survey's most calibrating number** (k3 headline #2): uniffi is
**20 months in, one of four backends migrated**, its model still documented "unstable", the
last mile boxed "not yet implemented", and the old `ComponentInterface` (6,244 lines) still in
tree beside the new one. Our five-plus emitters are larger and more divergent. Pilot-plus-N,
not a fleet migration — and Q1b already supplied the criterion that makes the pilot
falsifiable.

**Which target pilots.** k2 Q8's criterion is *most informative residual*, not smallest. That
rules out both obvious picks, for opposite reasons: **typescript** has the largest residual
(~1,800–2,600) but its groups A+B (typed `.d.ts` surface, four-table Swift bridge) are
capability no other target has, so the number does not generalise — its Lisp-comparable core
is only 3,517 production lines, smaller than every Lisp target. **chez** is smallest
(~600–900) and least divergent (chez↔gerbil ≥0.95 Jaccard across many files); it is the easy
case k3 §10 warns produces no evidence about the only question that matters, and its residual
would **underestimate** — the dangerous direction when we already suspect the estimate is 2–4×
low.

**racket, on four grounds.** (i) It tests Q3's most contested claim hardest — the contract
layer (`map_param_contract`, `map_return_contract`, `build_export_contracts` at 121 lines,
`collect_predicate_class_names`) is what k2 §6.2 calls "the clearest per-target semantics in
the repo … Nothing analogous exists in any other target. Under root-brief Q3 this is exactly a
per-target rule set over a shared meta-schema." (ii) It holds the repo's only clean **M4**
site, the `provide/contract` block that must precede the definitions it names — k3 §10.1's own
worked example for the insertion-point mechanism. (iii) Its residual is mid-range
(~700–1,100) so the measurement generalises, and it has working committed goldens (11 files,
484 lines) so Q6 layer 2 is available. (iv) Migrating it forces a real cleanup: 143 of
`_shared/emit/ffi_type_mapping.rs`'s 263 production lines are `RacketFfiTypeMapper` +
`RacketFfi2TypeMapper` — one target's semantics inside the shared substrate.

**Standing requirement:** whichever target pilots, the mechanisms it **lacks** must be covered
by paper analysis rather than discovered during migration four. racket exercises M1/M2/M3/M4
but **not M5** — gerbil's E6 sharding is the repo's only M5 site, and the handoff doc must say
so explicitly.

**OCaml is left alone.** 15,153 LOC across 20 modules, mid-build, in a live 27-leaf grove,
under the old architecture. Redirecting it wastes that work and manufactures the coordination
cost the root brief says this grove does not have; it is also not paradigmatically alien
(k3 §10.4: "Prolog or Idris2, **not OCaml**"). It lands under the old architecture, continues
supplying the duplication-tax evidence the form argument rests on (k2 §6.4 — three
sister-target defect leaves), and migrates as one of the N after the pilot.

Rejected: gerbil as pilot (holds the only M5 site and the largest golden set, but trades away
racket's M4 site and the contract layer that tests Q3 hardest); chez as pilot (forces the
model-diff instrument to be built with no fallback — a real virtue — but is the simplest, most
duplicated-from emitter, so its measurement underestimates); redirecting the OCaml grove to be
the pilot (takes jhugman's "especially for newer bindgens" literally, but discards 15k LOC of
in-flight work and creates a coordination dependency that does not exist today).

## Tree grown

Two paper exercises surfaced that k3 §10 names as in-scope for a design-only charter and as
the highest-value remaining paper work. Externalized rather than absorbed, per this leaf's own
Notes — a decision session that starts doing research has stopped being one — and sequenced
ahead of `write-handoff-doc-k5` so the doc carries findings rather than hedges:

- **`escape-hatch-closure-check-k7`** (position 05) — the site-by-site E×M check that turns
  Q1's *provisional* closure into an assertion or a named open problem (k3 §10.1).
- **`alien-target-meta-schema-check-k8`** (position 06) — Q3's shared meta-schema written out
  against Prolog or Idris2, not OCaml (k3 §10.4, §9 Q12). Targets the one failure mode with a
  documented precedent: wit-bindgen's interpreted targets forked rather than conform.

`write-handoff-doc-k5` and `review-handoff-doc-k6` shift to positions 07 and 08 with their keys
unchanged. Both new leaves are `research` kind and AFK-safe. Strictly these exceed the
charter's "Done when", which asks only that the doc name *what would settle* the escape-hatch
risk — the scope was put to the human and taken deliberately.

## Root brief edited in place

Per this leaf's Done-when, the root `BRIEF.md` now states current-state rather than a
changelog. Q1 and Q2 of `plan-k1` are unchanged; **Q3 is qualified** (per-target authoring is
authored `.apiw` *data* read at generation time, not loadable rules — so ADR-0047 stands
untouched; and Swift-adapter-compiler facts are not per-target data at all); the **leverage
paragraph is rewritten** to make form primary and to carry the corrected arithmetic; the
mechanism decisions are added; the Decomposition list carries the two new leaves; and both
"On the horizon" items — build-grove shape, and chez's equivalence proof — are answered and
moved into Settled design, replaced by the test-mass and bundler open questions.

## Notes

HITL leaf: it needs a human. If the self-driving loop reaches it unattended, that is correct
behaviour — wait.

Grow the tree if the grilling surfaces work that does not fit `k5`/`k6` (`leaf-insert` to
sequence ahead of them). Externalize rather than absorbing: this leaf's goal is decisions, and
a decision session that starts drafting the handoff doc has stopped being one.

Mint no ADR, touch `CONTEXT.md` not at all (charter Q6) — including the vocabulary from
`plan-k1`, which was deliberately reverted out of the glossary and lives in the root brief
until the handoff doc carries it.
