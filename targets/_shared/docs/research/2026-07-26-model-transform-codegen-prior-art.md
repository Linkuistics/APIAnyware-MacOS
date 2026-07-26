# Model-transform code generation — prior art and post-mortems

**Status:** research finding (grove `language-model-transforms`, leaf
`prior-art-model-transform-codegen-k3`). Audience is `plan-mechanism-k4`, which must settle
the transform engine, the template engine, the projection model's artifact status, and the
escape hatch. Its question list is [§9](#9-synthesis--k2s-fourteen-questions-answered).
**Date:** 2026-07-26.
**Input:** [`2026-07-26-emitter-anatomy-audit.md`](./2026-07-26-emitter-anatomy-audit.md) §10
("Questions for k3") is this document's brief; every system section is biased toward the
escape-hatch inventory (audit §2) and the statefulness list (audit §3).

> **How to read this doc.** It **recommends no mechanism** — k4 decides, with a human in the
> loop. Every failure-mode claim carries a primary source: a repository at a named commit, an
> issue or PR with a date, a maintainer's own words, or a project's own documentation. Where a
> search found nothing, that is recorded as a finding, and the consolidated list is
> [§11](#11-where-the-search-found-silence). Claims that **contradict or sharply refine the
> audit or the charter** are flagged ⚠ where they appear.
>
> **Measurements are mine unless attributed.** Where a number was taken by measuring a
> repository, the rule is stated so it can be re-run and disputed. Where a number comes from a
> project's own reporting, it is cited.

---

## Headline

**The architecture is convergent, the mechanism questions are answered, and the *quantity*
estimates in the charter and the audit are the things this survey most disturbs.**

1. **Our proposed architecture is not speculative — a peer is publicly mid-migration to it.**
   Mozilla's uniffi models bindings generation as *"a compiler pipeline"* — metadata → initial
   IR → general IR → **per-language IR** → templates — and recommends new external bindings
   authors adopt it ([§1.1](#11-the-architecture-uniffi-is-moving-to-is-ours)). k4 need not
   re-argue the shape.
2. **But budget by uniffi's clock: 20 months, one of four backends migrated, the model still
   "unstable", the last mile "not yet implemented", and the old model still in tree beside the
   new one.** ⚠ This is the strongest available argument for a single-target pilot with a
   pre-registered kill criterion rather than a fleet migration.
3. **The escape hatch will be ~40% of each target, not 10–20%.** SWIG's source-generating
   backends settle at 41–43% imperative across 25 years (§3.2); gtk-rs binding crates at ~36%
   hand-written (§4.3). ⚠ **The audit's §8 estimate is low by 2–4×**, which roughly halves the
   projected leverage. This is the correction the handoff doc most needs to carry.
4. **Templates are the cheapest and least valuable part of the proposal, and the survey
   quantifies why.** By an identical measurement, wit-bindgen's template-free generators carry
   ~40% emitted-text payload while our emitters carry 12.2% ([§2.3](#23-why-no-templates-does-not-transfer-they-are-33-more-text-dense-than-we-are)).
   Their `format!` calls *are* their templates; we are in a different regime, where the
   transform carries the whole prize. ⚠ k4 should resist any framing that sells the re-cut on
   templating.
5. **Expect *computation*-free templates, not *logic*-free ones.** uniffi's migrated Python
   backend has 6–15× fewer computations in its templates than its unmigrated siblings, but only
   ~25% fewer branches ([§1.2](#12-the-natural-experiment-python-migrated-the-other-three-did-not)) —
   a clean natural experiment inside one codebase.
6. **The escape hatch splits into two kinds, and three systems agree on the split**:
   *corrections to model facts* are authored declarative data keyed by path or declaration
   identity (haskell-gi `set-attr`, uniffi `exclude`, gtk-rs `Gir.toml`); only *computations*
   need host functions. Our E1/E5/E7 are the first kind; E2/E3/E4/E6 the second (§4.2).
7. **Five mechanisms cover every escape observed in seven systems** (M1–M5,
   [§10](#10-what-evidence-would-settle-the-escape-hatch-question)), and provisionally every
   site in the audit's inventory maps into them. ⚠ **Nothing in the audit appears to require a
   sixth mechanism** — the single most reassuring result here, and a paper check away from
   being assertable.
8. **Paradigm reach is decided by where the shared/target boundary sits, and there is a
   near-controlled comparison.** GIR models only the source → reached Haskell in 13 years.
   wit-bindgen's shared layer encodes a target-side lowering → never crossed the
   compiled/interpreted line in five years, and the interpreted targets **forked into separate
   projects** (§2.6, §4.6, §9 Q12). ⚠ Root brief Q3's shared *meta-schema* is a target-side
   commitment; the two systems that made one have either failed that crossing or never
   attempted it.
9. **Nobody commits a projection model.** Five of seven systems export a serialised model, all
   for debugging or interchange, none as a reviewed diff surface; the two shipped models (GIR,
   WinMD) describe the *source*, not a projection. uniffi's authors hit the volume problem at a
   far smaller scale than ours (§9 Q9).
10. **Two silences matter more than most of the findings.** ⚠ **No system reported a formal
    equivalence proof for a transform migration** — the technique that demonstrably caught bugs
    was per-stage *model* diffing, not output goldens, which is unexpectedly good news given
    the audit's §5.3 (goldens inert, chez has none at all). And ⚠ **no system anywhere reports
    test mass before and after such a migration**, leaving the charter's biggest unquantified
    risk exactly where the audit left it.

---

## Method and source quality

**Systems examined at depth (★ = closest to our shape):** ★ uniffi, ★ wit-bindgen, ★ SWIG,
★ GObject-Introspection (with PyGObject, gtk-rs and haskell-gi as its consumers), ★ the
MDA/QVT/ATL/Xpand lineage, protoc plugins, Djinni. Secondary: WinRT/WinMD, rust-bindgen, PyO3,
Kotlin/Native `cinterop`, Emscripten's WebIDL binder, `cbindgen` (§8).

**Repositories measured**, shallow-cloned and read at these commits:

| repo | commit | date |
|---|---|---|
| `mozilla/uniffi-rs` | `67134079` | 2026-07-20 |
| `bytecodealliance/wit-bindgen` | `7c48901` | 2026-07-24 |
| `swig/swig` | `5107343` | 2026-07-24 |
| `gtk-rs/gir` | `b4ad84f` | 2026-07-22 |
| `GNOME/gobject-introspection` | `429c7f1` | 2026-06-25 |
| `dropbox/djinni` | `4f3aa69` | 2020-03-25 (archived) |
| `GNOME/pygobject`, `gtk-rs/gtk-rs-core`, `haskell-gi/haskell-gi` | HEAD | 2026-07-26 |

**Measurement rules.** Line counts are raw `wc -l` over the named paths. The literal-payload
measure (§2.3) counts all Rust string and raw-string literals as a share of source bytes, after
truncating each file at its first `#[cfg(test)]`; it is deliberately **coarser** than the
audit's §2.2 rule (which excluded `use`/attribute lines and counted only target-syntax
literals), so the two are not interchangeable — **the audit's 6.1% and this document's 12.2%
are the same corpus under different rules, and only the 12.2% is comparable to the
wit-bindgen column beside it.** Template logic density (§1.2) counts `{% if/for/match/call/let %}`
directives, `{{ x.f( }}` expression calls, and `|filter` uses.

**Reproducing the numbers.** Each measurement is a one-liner over a shallow clone.

```sh
# §1.2 uniffi template logic density, per backend
for b in kotlin python swift ruby; do d=uniffi_bindgen/src/bindings/$b/templates
  echo "$b files=$(find $d -type f|wc -l) lines=$(find $d -type f -exec cat {} +|wc -l)" \
   "ctrl=$(find $d -type f -exec grep -o '{%-\? *\(if\|for\|match\|call\|let\) ' {} +|wc -l)" \
   "exprcalls=$(find $d -type f -exec grep -o '{{[^}]*\.[a-zA-Z_]*(' {} +|wc -l)"; done

# §1.3 declarative/imperative split of uniffi's shared `general` pass
wc -l uniffi_bindgen/src/pipeline/general/nodes.rs                    # 710  declarations
find uniffi_bindgen/src/pipeline/general -name '*.rs' ! -name nodes.rs \
     ! -name context.rs ! -name mod.rs | xargs cat | wc -l            # 2858 hand-written
grep -c '^\s*pub \w* *:' uniffi_bindgen/src/pipeline/general/nodes.rs # 177 fields
grep -c '#\[map_node(' uniffi_bindgen/src/pipeline/general/nodes.rs   # 70 attrs

# §2.3 literal payload (run over both wit-bindgen crates/*/src and targets/*/tools/emit-*)
python3 - <<'PY'
import re,glob,sys
t=l=0
for f in glob.glob(sys.argv[1] if len(sys.argv)>1 else '**/*.rs', recursive=True):
    if '/tests/' in f: continue
    s=open(f,encoding='utf8',errors='replace').read(); i=s.find('#[cfg(test)]')
    if i>0: s=s[:i]
    t+=len(s)
    for m in re.finditer(r'r#*"(?:[^"]|"(?!#))*"#*|"(?:\\.|[^"\\])*"',s): l+=len(m.group(0))
print(f'src={t} lit={l} ({100*l/t:.1f}%)')
PY

# §3.2 SWIG declarative (Lib/) vs imperative (Source/Modules/) per language
for l in java csharp python ruby go c; do
  echo "$l decl=$(cat Lib/$l/* 2>/dev/null|wc -l) imp=$(wc -l < Source/Modules/$l.cxx)"; done
grep -rho '%typemap' Lib/java | wc -l          # 895

# §4.2 haskell-gi overrides corpus
find bindings -name '*.overrides' -exec cat {} + | grep -oE '^[a-z-]+' | sort | uniq -c | sort -rn

# §4.3 gtk-rs generated (src/auto/) vs hand-written, per crate
for c in gio pango graphene gdk-pixbuf glib; do
  a=$(find $c/src -path '*/auto/*' -name '*.rs'|xargs cat|wc -l)
  h=$(find $c/src -name '*.rs' -not -path '*/auto/*'|xargs cat|wc -l)
  echo "$c auto=$a hand=$h"; done
```

**Source quality, stated honestly.** Evidence here is unevenly strong and is labelled as such
throughout:

- **Strongest:** code and documentation in shipping repositories at a named commit, and
  maintainers' own words in dated PRs and issues. uniffi PR #2333, PyGObject's
  `override_guidelines.rst`, SWIG's typemap manual and wit-bindgen issue #1265 are the four
  richest primary sources found.
- **Weaker, and flagged where used:** SWIG typemap-usage percentages are measured over SWIG's
  *own* test corpus, which is not a sample of production interface files (§3.5); the MDE
  literature is interview- and survey-shaped rather than incident-shaped, and its own largest
  study reports that its central claims are unsubstantiated (§7.2b).
- **Scale and recency** are noted per claim. A 2026 measurement of a generator shipping to
  millions of users is weighted above a 2011 survey finding, and both above a blog post.

---

## 1. ★ uniffi (Mozilla) — the closest living analogue, mid-migration

**Why it matters most.** uniffi is the one surveyed system that has *independently
arrived at the root brief's architecture* and is **half-way through adopting it in
public**, with the design argument conducted in reviewable PRs. Everything below is
from the repository at `67134079` (2026-07-20) and its own docs and PRs.

### 1.1 The architecture uniffi is moving to is ours

`docs/manual/src/internals/bindings_ir.md` states it as a compiler pipeline:

> UniFFI models foreign bindings generation as a compiler pipeline:
> `Rust + proc-macros / UDL → Metadata → Initial IR → General IR → {Kotlin,Swift,Python,Ruby} IR → generated code`
>
> 4. The general IR is transformed into a language-specific IR. This adds information like concrete type names.
> 5. The final step uses the language-specific IR and to generate the bindings code.

— [`docs/manual/src/internals/bindings_ir.md`](https://github.com/mozilla/uniffi-rs/blob/main/docs/manual/src/internals/bindings_ir.md)

That is the root brief's Q1 and Q2 almost word for word: a **per-language,
instance-level model** produced by a transform, rendered by templates. The doc's own
mermaid diagram, however, boxes the *language-IR → generated code* arrows under
**"Not yet implemented"** for Kotlin, Swift, Python and Ruby, and the page opens with:

> **Note:** The Bindings IR is still unstable and subject to breaking changes.

The companion page is blunter:

> **Note:** the Bindings IR is currently an experiment. It's checked in so that we can use it for the gecko-js external binding generator. Our current recommendation for other external bindings authors is to avoid using it for now since we haven't fully committed to this new system and expect it to change.

— [`bindings_ir_pipeline.md`](https://github.com/mozilla/uniffi-rs/blob/main/docs/manual/src/internals/bindings_ir_pipeline.md)

**Timeline.** The design PR [#2333 "Bindings render pipeline"](https://github.com/mozilla/uniffi-rs/pull/2333)
opened 2024-11-27 and was closed 2025-02-22 in favour of a reworked approach; pipeline
work has been landing since ([#2688](https://github.com/mozilla/uniffi-rs/pull/2688)
2025-10, [#2787 "Improved pipeline mappings"](https://github.com/mozilla/uniffi-rs/pull/2787)
2026-01, [#2890 "Pipeline visit lifetimes"](https://github.com/mozilla/uniffi-rs/pull/2890)
2026-05, [#2919 "Pipeline IDs"](https://github.com/mozilla/uniffi-rs/pull/2919) 2026-06).
**Twenty months in, one of four in-tree backends has migrated.** ⚠ This is the single
most calibrating number in this survey.

### 1.2 The natural experiment: Python migrated, the other three did not

Python runs on the pipeline (`bindings/python/mod.rs:38` — `pipeline().execute(initial_root)`);
Kotlin, Swift and Ruby still build from `ComponentInterface` (`bindings/kotlin/mod.rs:8`).
All four use the same Askama engine and the same repo conventions, so the difference is
attributable to the pipeline and little else. Measured over
`uniffi_bindgen/src/bindings/<lang>/templates/` at `67134079`:

| backend | on pipeline? | tpl files | tpl lines | control directives¹ | method calls in `{{…}}`² | filter uses | per-language Rust³ |
|---|---|---:|---:|---:|---:|---:|---:|
| **python** | **yes** | 43 | 2,191 | 239 | **14** | **27** | 1,742 |
| kotlin | no | 43 | 2,714 | 350 | 87 | 163 | 1,904 |
| swift | no | 38 | 2,376 | 310 | 92 | 136 | 2,133 |
| ruby | no | 21 | 2,536 | 406 | **204** | 223 | 967 |

¹ `{% if/for/match/call/let %}` occurrences.  ² `{{ … .foo( }}` — computation invoked from
the template.  ³ all `.rs` under the backend dir (pipeline passes + filters for Python;
`gen_<lang>/` helper modules for the rest).

**Two findings, and the second is the uncomfortable one.**

- **Computation left the templates.** Python invokes 14 method calls from template
  expressions against Kotlin's 87 and Ruby's 204 — a **6×–15× reduction** — and 27 filter
  uses against 136–223. The transform layer demonstrably absorbs the *computation*.
- **Branching did not.** Control-flow directives fell only ~25% (406→239 vs Ruby;
  350→239 vs Kotlin), i.e. from one directive per 6.2 template lines to one per 9.2.
  **A logic-free template did not emerge, and uniffi never claimed one would.**

The house rule they wrote down is *computation-free*, not *logic-free*:

> In general, prefer adding fields using a pipeline pass to writing filters. That's allows devs to use the `pipeline` command to follow what's going on.
>
> We currently only use filter functions when we want to implement somewhat complex display logic, like in the `docstring` filter. Implementing this as a pipeline pass means the pass would need to know how much each docstring gets indented, which doesn't seem right.

— [`bindings/python/filters.rs:7-12`](https://github.com/mozilla/uniffi-rs/blob/main/uniffi_bindgen/src/bindings/python/filters.rs)

Note the stated *reason* a filter survives: **indentation is a rendering concern the model
should not carry**. That is a principled boundary, not a leak, and it is worth stealing.

### 1.3 The transform engine is typed Rust with derive macros — not a rule language

`MapNode` converts node-to-node between IR stages; `#[derive(Node, MapNode)]` generates the
recursive walk; per-field attributes override it:

```rust
#[derive(Node, MapNode)]
#[map_node(from(prev_ir::Namespace))]
#[map_node(update_context(context.set_namespace_name(&self.name)))]
pub struct Namespace {
    #[map_node(generate_ffi_definitions(&self, context)?)]
    ffi_definitions: Vec<FfiDefinition>,
    name: String,
    functions: Vec<Function>,
}
```

and the doc names its own escape hatch as such:

> // When the type itself has the `#[map_node([path-to-function])]` attribute, then that function will be used for the entire mapping logic. […]
> // **Use this as an escape hatch for mappings that can't be auto-generated.**

**The measured declarative/imperative split.** In the shared `general` pass:

| | lines |
|---|---:|
| `general/nodes.rs` — node declarations + derive attributes | 710 |
| `general/*.rs` — hand-written pass functions | **2,858** |
| `uniffi_pipeline` — the engine itself | 707 |
| `uniffi_bindgen/src/interface` — the *old* `ComponentInterface`, still present | 6,244 |

At field granularity `general/nodes.rs` has **177 `pub` fields and 70 `#[map_node(…)]`
attributes, of which 20 are pure renames** (`from(…)`). So **~72% of fields ride the
derived recursion for free; the ~28% that do not consume ~80% of the transform's code.**
That ratio is the honest shape of "declarative transform with an escape hatch", measured
on a shipping system.

### 1.4 The escape hatches, one by one — and they map onto our E-list

| ours (k2 §2.1) | uniffi's answer | evidence |
|---|---|---|
| **E1** `KNOWN_UNBINDABLE` — what the downstream compiler rejects | **`exclude`: an authored TOML set per language**, keyed `Name` or `Type.method`, applied as a pipeline pass | [`pipeline/general/exclude.rs`](https://github.com/mozilla/uniffi-rs/blob/main/uniffi_bindgen/src/pipeline/general/exclude.rs) — `should_exclude_toplevel_item`, `should_exclude_method` |
| **E4** identifier formation | **host Rust functions in a pass**, `heck` + a keyword table, results become model fields | [`bindings/python/pipeline/names.rs`](https://github.com/mozilla/uniffi-rs/blob/main/uniffi_bindgen/src/bindings/python/pipeline/names.rs) — `fixup_keyword`, `type_name`, `var_name`, 35-entry `KEYWORDS` |
| **§3.1** whole-corpus accumulation | **`Node::visit()`** — walk descendants to populate an ancestor's field | `bindings_ir_pipeline.md`: *"useful when you want to populate a node field using it's descendants. For example, building up the FFI definitions by visiting all functions/methods inside a namespace."* |
| **§3.2/3.3** context flowing down | **`Context` type**, threaded through `map_node` | *"Passing the crate name down so it can be used to derive FFI function names. Passing the namespace name down…"* |
| renaming | **`rename` pass over an authored TOML map** | `pipeline/general/rename.rs`; 6 `#[map_node(rename…)]` sites |

**`exclude` is the finding that most directly de-risks our E1.** It is *the same
mechanism* the audit said E1 would need — "authored per-target data keyed on an identifier
the transform computes" — shipped, in a generator with millions of downstream users, and
implemented as an ordinary pipeline pass rather than a special case. Note also **where it
reads from: `uniffi.toml`, per crate**, i.e. authored data lives beside the source, not in
the generator.

**No primary source found** for uniffi having a *feedback* channel from a downstream
compiler back into the model (the thing our `swift build`-derived table really is). Searched
the repo docs, the ADR set, and issues for compiler-error-driven suppression; `exclude` is
manual and stays manual. **This is a silence, and it is informative**: nobody in this
neighbourhood has automated that loop either.

### 1.5 The model's artifact status — inspectable, diffable, *not* committed

uniffi's model is in-memory, but they built a first-class inspection tool for it, and the
design PR named that as a primary motivation:

> One nice feature of this system is that you can inspect the data at any stage of the pipeline, run it through diffs, etc. I think this will really help both new and experienced devs to understand what's going on during bindings generation.
> — [bendk, PR #2333 description](https://github.com/mozilla/uniffi-rs/pull/2333)

> I got the `peek` and `diff` working. I've been having fun playing around with them by calling `diff-save`, making some changes to an example crate, then calling `diff [metadata|ir|python-ir]` to see how those changes affect the pipeline.
> — [bendk, 2024-11-29](https://github.com/mozilla/uniffi-rs/pull/2333)

It shipped as `uniffi-bindgen pipeline --library … <language>`, which "print[s] out: the
initial IR, **the diff after each pass**, and the final IR", with `--pass`, `--type` and
`--name` filters because "This is a lot of data." **The reviewable-diff-surface benefit the
charter claims was real enough to build a tool for, and was realised as a debugging CLI, not
a committed artifact.** The volume caveat is stated by its authors, at a corpus far smaller
than ours.

### 1.6 The design fork they took, and why — directly relevant to k4

bendk's first implementation mutated a shared IR in place via a `VisitMut` trait plus a
`lang_data` bag; he replaced it with explicit IR-to-IR conversion and duplicated structs:

> Rather than using the `VisitMut` trait and the `LanguageData` field, models this as more of a regular conversion from `BindingsIr` to `PythonBindingsIr`.
>
> I like this approach because it seems more straight forward. Before the conversion was handled by a combination of mutating fields, filling in the `lang_data` field (technically also a mutation, but it felt much different than the other ones), and also collecting new items in the `BindingsIrVisitor` fields. It worked, but it seemed a bit strange.
>
> The main downside of this new approach is we need to duplicate some structs. However, I don't really mind it […] The Python structs are significantly different than the ones in `interface::ir`.
> — [bendk, 2024-12-23](https://github.com/mozilla/uniffi-rs/pull/2333)

**A separate node type per stage, accepting struct duplication, beat one mutable model with
a per-language side-bag.** They tried our "one model, annotated per target" shortcut first
and moved off it.

The reviewer's independent read is the strongest external corroboration of the charter's
thesis in this survey:

> On the whole, I very much like the compiler metaphor: **moving more logic out of the templates, having a principled approach for imports and once per type and once per type of type would be super helpful, especially for newer bindgens.**
>
> I'd also applaud having an escape hatch: I agree that there absolutely must be at least one upgrade path that has minimal breaking changes […] I'm happy to switch to a new way, but don't make me do it immediately :)
> — [jhugman, 2024-12-19](https://github.com/mozilla/uniffi-rs/pull/2333)

Two things to extract. **"A principled approach for imports"** is named unprompted by a
bindgen author as a top-three benefit — that is our §3.3 per-file accumulator problem, and
an outside party independently rates it as a main prize. And **"especially for newer
bindgens"**: the benefit is framed as accruing to *new* targets, not to the mature ones —
which is exactly the shape of an argument for piloting on a new target rather than migrating
a mature one.

### 1.7 Walk-away check

- **Generated output:** legible. The doc's worked example is ordinary readable Python
  (`_UniffiConverterUInt64.check_lower(a)` …). Output survives the tool's removal.
- **Intermediate model:** *not* independently legible. It exists only as Rust types printed
  by a debug CLI; there is no serialised schema, no on-disk form, and no consumer outside
  `uniffi_bindgen`. Delete uniffi and the IR is gone. ⚠ The charter should not assume a
  transform's model is automatically a durable artifact — uniffi's is not.

### 1.8 Paradigm reach

Weak on this axis: Kotlin, Swift, Python and Ruby in-tree, plus community C#, Go, Dart, and
Mozilla's gecko-js. All are object-oriented, garbage-collected, exception-carrying
imperative languages. **uniffi has never had to serve a Scheme, a Prolog, or a dependently
typed target**, so it is *no evidence at all* on ADR-0011's lowest-common-denominator fear.
Take its mechanism lessons; discount its vocabulary-boundary lessons.

### 1.9 Governance: the plugin boundary

ADR-0007 (2022-04-07) moved binding generators out of the core crate behind a
`BindingGenerator` trait taking `ComponentInterface` + config, driven by these problems:

> All the bindings live in the `uniffi` repository, so the `uniffi` team has to maintain them […] Any change to a specific binding generator requires a new `uniffi_bindgen` release […] Some bindings require complex build systems to test.

and accepting this cost:

> Bad, because it's easier to accidentally have a version mismatch. […] Bad, because testability increases in complexity. We are required to publish fixtures and examples we have.

— [`docs/adr/0007-enable-implementing-bindings-separately.md`](https://github.com/mozilla/uniffi-rs/blob/main/docs/adr/0007-enable-implementing-bindings-separately.md)

For us this is a *confirmation of ADR-0011 by a different route*: the pressure that split
uniffi's targets apart was maintenance and CI ownership, not paradigm diversity — and it
still pointed the same way. It also warns that **publishing a model as a public interface
buys a versioning problem**, which they needed a second ADR to handle.

### Takeaway for k4

1. **The architecture is not speculative — it is convergent.** A generator shipping to
   millions of users independently re-derived *resolved model → per-language IR → templates*
   and is publicly executing the migration. k4 should not spend its budget re-arguing the
   shape.
2. **Budget by uniffi's clock, and be honest about it.** Twenty months, one of four
   backends, model still "unstable", last mile "not yet implemented", and the *old* model
   (6,244 lines) still in tree beside the new one. Our five-plus emitters are far larger and
   more divergent. **This is the strongest available argument for the handoff doc proposing
   a single-target pilot with an explicit kill criterion, not a fleet migration.**
3. **Expect computation-free templates, not logic-free ones.** Measured: 6–15× fewer
   computations, ~25% fewer branches. k4 should set the template contract as *no computation,
   branching allowed* and adopt uniffi's stated exception (pure display concerns like
   indentation stay filters).
4. **Prefer a typed per-stage model with duplicated node types over one model with
   per-target annotations.** They tried the latter first and abandoned it, in writing.
5. **`exclude` retires our E1 risk from "unknown" to "known and ordinary".** Authored
   per-target suppression data, keyed on a transform-computed identifier, applied as a pass,
   living beside the source. Adopt the shape.
6. **Identifier formation as host functions in a pass, feeding first-class model fields, is
   the settled answer** (E4). No surveyed system made naming declarative.
7. **`visit()` + `Context` is the shipped answer to statefulness** — descendant-walk for
   accumulation upward, context for propagation downward. Both are ordinary host code, which
   is why they work.
8. **Build the pipeline-diff CLI early, not late.** Its authors cite it as the thing that
   made the migration reviewable, and used it to find their own porting bugs. But do not
   confuse it with a committed artifact — theirs is neither serialised nor durable.

---

## 2. ★ wit-bindgen — the counter-evidence, and why it is a different regime

The brief flags this system as *"direct evidence against our thesis [that] must be
confronted, not omitted."* Measured at `7c48901` (2026-07-24); repo created 2021-02-23.

### 2.1 Confirmed: eight backends, zero template engines

`grep` over every `Cargo.toml` in the repo finds **no** `askama`, `tera`, `handlebars`,
`minijinja`, `liquid` or `tinytemplate` dependency. All eight in-tree generators
(`c`, `cpp`, `csharp`, `go`, `rust`, `moonbit`, `markdown`, plus `guest-rust`) build output
by appending to a string buffer.

The renderer they built instead is **222 lines**: `crates/core/src/source.rs`, a
`Files` map plus an indentation-tracking `Source` buffer, driven by `uwrite!`/`uwriteln!`
macros. That is the whole of their "template engine".

### 2.2 But the shared layer is not a data model either — it is an instruction stream

This is the finding that makes wit-bindgen genuinely interesting rather than merely
contrary. Its shared `core` crate is **3,966 lines, of which `abi.rs` is 2,731 (69%)**, and
`abi.rs` does not define a projection model. It compiles each function's Canonical-ABI
lowering into a **stack-machine instruction sequence**, which each language backend
interprets:

> Types implementing `Bindgen` are incrementally fed `Instruction` values to generate code for. Instructions operate like a stack machine where each instruction has a list of inputs and a list of outputs (provided by the `emit` function).

```rust
pub trait Bindgen {
    type Operand: Clone + fmt::Debug;
    fn emit(&mut self, resolve: &Resolve, inst: &Instruction<'_>,
            operands: &mut Vec<Self::Operand>, results: &mut Vec<Self::Operand>);
    fn return_pointer(&mut self, size: ArchitectureSize, align: Alignment) -> Self::Operand;
    fn push_block(&mut self);
    // …
}
```

— [`crates/core/src/abi.rs:726-774`](https://github.com/bytecodealliance/wit-bindgen/blob/main/crates/core/src/abi.rs)

So there are **three** architectures in play across this survey, not two:

| shared artifact | systems | per-target work |
|---|---|---|
| a **per-language data model**, then render | uniffi (in progress), **our proposal** | write transform passes + templates |
| an **instruction stream / visitor interface** | **wit-bindgen** | implement `emit` for 34 instruction kinds |
| **nothing but the parsed IDL** | protoc plugins, SWIG (partly) | write a whole generator |

wit-bindgen's split is *by tractability*, not by layer: the part that is **mechanically
derivable from the type** (memory layout, lifting/lowering, ownership transfer) is shared as
an instruction program; the part that is **idiomatic surface** (what a record, resource or
function *declaration* looks like) has no shared structure at all and is free-form
imperative string appending per backend.

### 2.3 Why "no templates" does not transfer: they are 3.3× more text-dense than we are

Running the *same* literal-payload measurement over both codebases (all string and raw
string literals, production regions, as a share of source bytes — a slightly coarser rule
than the audit's §2.2, so both columns move together):

| wit-bindgen backend | src bytes | literal bytes | **literal %** |
|---|---:|---:|---:|
| c | 162,901 | 98,080 | **60.2%** |
| go | 112,773 | 52,842 | 46.9% |
| rust | 240,690 | 109,370 | 45.4% |
| csharp | 213,346 | 94,454 | 44.3% |
| cpp | 159,740 | 51,358 | 32.2% |
| moonbit | 209,856 | 49,891 | 23.8% |
| `core` (shared, no emission) | 151,737 | 1,500 | 1.0% |

| our emitter | src bytes | literal bytes | **literal %** |
|---|---:|---:|---:|
| racket | 288,726 | 63,253 | 21.9% |
| chez | 203,388 | 26,713 | 13.1% |
| gerbil | 303,733 | 32,853 | 10.8% |
| typescript | 568,155 | 55,561 | 9.8% |
| sbcl | 262,234 | 19,581 | 7.5% |
| **total** | **1,626,236** | **197,961** | **12.2%** |

**wit-bindgen's generators average ~40% emitted text; ours average 12.2%.** By mass,
wit-bindgen's imperative backends *are already templates* — long multi-line literals with
`{}` interpolation, written in Rust instead of in a `.tmpl` file. They did not reject
templating; they inlined it. A template engine would have bought them syntax, not structure.

Our emitters sit in the opposite regime, exactly as the audit found: the text is a small
minority and the mass is decision logic. **The lesson to carry is therefore not "templates
are unnecessary" but "a template engine pays only in proportion to your text share" — and
ours is low, which is the audit's headline (§2.2) restated from outside.** The corollary is
uncomfortable and should be said plainly in the handoff doc: *templates are the least
valuable part of the proposed re-cut.* The transform is the whole prize.

**No primary source found** for wit-bindgen having *considered and rejected* a template
engine. Searched the repo's `README.md`, `crates/*/DESIGN.md`, `crates/*/README.md`, the
`crates/moonbit/docs/adr/` set, and issue/PR text across the `bytecodealliance` org. There is
no ADR, design note, or thread arguing the point — **the absence of templates appears to be
an unexamined default inherited from the first backend, not a considered rejection.** That
materially weakens wit-bindgen as counter-evidence: it is a system that never asked our
question.

### 2.4 The post-mortem: what breaks without a principled model

[Issue #1265, "C#: Generated code contains compilation errors (+ lots of other opinionated
problems)"](https://github.com/bytecodealliance/wit-bindgen/issues/1265) (2025-04-08, closed
2025-05-13) is a real user's first-contact report against a shipping generator. Three of its
findings land directly on our question list.

**(a) A missing import shipped, because nothing accumulates imports.**

> The main problem is a generated file containing some `Result`-related definitions. In the code, two `ArgumentException`s are thrown. There is no reference to the `System` namespace, such that compiling the library results in `error CS0246: The type or namespace name 'ArgumentException' could not be found`.

and the reason it was never caught:

> The reason the main issue has not been caught until now is likely because all testing has been done with `ImplicitUsings` set to `true`, which globally includes `System`. Removing `ImplicitUsings` […] results in the missing reference.
> — ero-qt, 2025-04-08

This is our §3.3 per-file accumulator failing in the wild, in the architecture that has no
mechanism for it — and masked for months by a fixture that happened to set a flag hiding it.
⚠ Note the shape of the test blind spot: *the golden compiled, so nobody looked.*

**(b) The fix chosen was to abolish the accumulator, not to build one.**

> I can get started on using the **fully qualified type name for all the types used in the generator and removing the generation of `using`s**. It's a fairly simple PR and would close this issue.
> — ero-qt, 2025-04-16

That is a fifth option for k2's Q7, and it is not on the audit's list: **make every reference
absolute so no file-level import block is needed at all.** Cheap, mechanical, and it costs
output idiom — which is precisely the trade ADR-0005 forbids us from making silently, but it
belongs on the table as the honest baseline.

**(c) The imperative-Rust-per-target architecture locks out target experts.**

> I'm unfortunately not familiar with Rust at all. Though I am very familiar with C#, auto-generated C# code, common practices, low level code and interop. I would love to help, but **the current code is somewhat overwhelming**.
> — ero-qt, 2025-04-08

This is the strongest *pro*-thesis evidence in the survey, and it comes from a hostile
witness in the counter-evidence system. The person best placed to fix the C# backend — a C#
interop expert — was blocked by the *implementation language of the generator*, not by the
problem. A per-target repertoire of declarative rules plus templates is legible to exactly
that person. The root brief's leverage claim ("declarative rules + templates in place of
~14k LOC of imperative Rust per target") has an independent witness.

### 2.5 The type-mapping table that stayed a document

`crates/cpp/DESIGN.md` is a projection-policy matrix keyed on a three-axis code
(guest/host × import/export × argument/result/in-struct), mapping each WIT type to a Rust
type, a C++ type and a lowering. It is **prose no code reads** — the same species as our
`targets/_shared/docs/emitter-contract.md`, which the root brief cites as the motivating
artifact. Two independent projects wrote their projection policy into markdown because there
was no data layer to put it in. That is the charter's premise, corroborated.

### 2.6 Paradigm reach — the boundary they have not crossed

All eight in-tree backends are **statically compiled, imperative languages**: C, C++, C#,
Go, Rust, MoonBit (plus a markdown doc generator). The README says what happens at the edge:

> Other languages such as Ruby, etc, are hoped to be supported one day with `wit-bindgen` or with components in general. […] It's worth noting, however, that **turning an interpreted language into a component is significantly different from how compiled languages currently work** (e.g. Rust or C/C++). It's expected that the first interpreted language will require a lot of design work, but once that's implemented the others can ideally relatively quickly follow suit and stay within the confines of the first design.
> — [`README.md` §"Guest: Other Languages"](https://github.com/bytecodealliance/wit-bindgen/blob/main/README.md)

And in practice the alien paradigms did not wait: **JavaScript and Python are supported by
separate projects** — [ComponentizeJS](https://github.com/bytecodealliance/ComponentizeJS)
and [componentize-py](https://github.com/bytecodealliance/componentize-py) — outside
`wit-bindgen` entirely.

⚠ **This is ADR-0011's fear observed in the wild, and it is the survey's clearest instance
of it.** A shared substrate designed around one paradigm family did not stretch to another;
the alien target left and built its own generator rather than conform. Five years, zero
interpreted languages in tree. Our corpus is *worse* on this axis — Racket, Chez, Gerbil,
SBCL, TypeScript today; Haskell, Idris2, Prolog, Pharo, Zig named in the charter.

### 2.7 Walk-away check

- **Generated output:** legible, and this is a design goal — the C/C++ headers and Rust
  modules are meant to be read and included by hand. Output survives.
- **Intermediate model:** *there is none to be legible.* The only shared intermediate is a
  transient instruction stream consumed inside one function call. Nothing is inspectable,
  diffable, or dumpable. Compare uniffi, which at least built a `pipeline` peek CLI. ⚠ The
  architecture forecloses the charter's "reviewable model as the diff surface" gain
  entirely.

### Takeaway for k4

1. **Do not read wit-bindgen as a rejection of our thesis.** No primary source shows the
   question was ever asked, and the codebase sits in a different regime — ~40% emitted-text
   density against our 12.2%. Their `format!` calls *are* their templates.
2. **The honest corollary for the handoff doc: templates are the cheapest, least valuable
   part of the proposal.** Our text share is low; the transform carries the leverage. k4
   should resist any framing that sells the re-cut on templating.
3. **A third shared-layer shape exists and should be considered explicitly**: share an
   *instruction stream / visitor interface* for the mechanically-derivable part rather than a
   data model. For us the analogue would be sharing the marshalling/trampoline lowering while
   leaving the declaration surface per-target. It is worth k4 stating why it is rejected —
   chiefly that it re-creates the "each target implements 34 callbacks in imperative Rust"
   problem that #1265's witness could not penetrate.
4. **"Fully-qualified everything" is a real answer to per-file imports** and belongs on
   k2 Q7's option list, with its idiom cost priced.
5. **Paradigm reach is the risk with the most external evidence.** wit-bindgen never crossed
   the compiled/interpreted line in five years, and the interpreted targets forked. Any
   shared meta-schema we design must be tested against the *most* alien planned target on
   paper before the pilot, not after.
6. **A generator's implementation language is a contributor filter.** Target expertise and
   Rust expertise rarely coincide; the declarative form is what lets them separate.

---

## 3. ★ SWIG — 30 years, 21 targets, and the only measured declarative/imperative ratio

Measured at `5107343` (2026-07-24). Repo mirrored to GitHub 2012; the project dates to 1995.
**This is the survey's most calibrating system**, because SWIG has run the exact split our
proposal contemplates — declarative per-target data beside imperative per-target host code —
for three decades across paradigmatically diverse targets, and both halves are countable.

### 3.1 The architecture maps onto ours almost term-for-term

| SWIG | ours (proposed) |
|---|---|
| `Source/CParse` + `Source/Swig` — parse C/C++ into a typed `Node` tree | the resolved semantic model (`semantic/`) |
| `Source/Modules/<lang>.cxx` — a `Language` subclass, imperative C++ | the per-target **transform** host code |
| `Lib/<lang>/*.swg`, `*.i` — typemaps + fragments, declarative | the per-target **rules + templates** |
| `%typemap` pattern matching on type | rule premises over IR facts |
| `-debug-module 1,2,3,4` / `-xmlout` | the projection model, dumped |

SWIG's model **is** dumpable: `main.cxx` exposes `-debug-top <n>` and `-debug-module <n>`
where *"<n> is a csv list of stages 1-4"*, plus `-xmlout <file>` — *"Write XML version of the
parse tree to <file> after normal processing"* and `-debug-typemap`.

⚠ **Two independent systems built stage-wise model dumping.** SWIG has had a four-stage
dump for decades; uniffi built `pipeline --pass` in 2024–25 (§1.5). Neither *commits* the
model. **The convergent answer to k2's Q9 is: make the model dumpable per stage, not
committed.**

### 3.2 The measured split: ~61% declarative / ~39% imperative, across 21 targets

Per-language line counts, `Lib/<lang>/**` (declarative) against
`Source/Modules/<lang>.cxx` (imperative):

| language | `Lib/` (declarative) | `Modules/*.cxx` (imperative) | declarative % |
|---|---:|---:|---:|
| scilab | 7,078 | 1,225 | 85.2% |
| octave | 4,974 | 1,665 | 74.9% |
| ruby | 8,683 | 3,512 | 71.2% |
| javascript | 7,820 | 3,199 | 71.0% |
| guile | 3,917 | 1,634 | 70.6% |
| tcl8 | 3,219 | 1,342 | 70.6% |
| lua | 5,724 | 2,932 | 66.1% |
| python | 10,385 | 6,132 | 62.9% |
| ocaml | 3,115 | 1,921 | 61.9% |
| perl5 | 4,181 | 2,639 | 61.3% |
| csharp | 7,152 | 5,055 | 58.6% |
| java | 6,716 | 5,145 | 56.6% |
| r | 3,560 | 2,801 | 56.0% |
| php | 3,302 | 2,763 | 54.4% |
| d | 3,499 | 4,921 | 41.6% |
| go | 2,105 | 5,767 | 26.7% |
| c | 991 | 3,076 | 24.4% |
| **total (17 measured)** | **86,421** | **55,729** | **60.8%** |

**Honest caveat, and it matters.** `Lib/<lang>/` is not purely typemaps: it also carries
target-language and C *runtime* support that gets injected into the wrapper
(`Lib/python/pyrun.swg` alone is 1,930 lines). So 60.8% is an **upper bound** on the
declarative share. The typemap-directive census makes the composition visible:

| language | `%typemap` directives | `%fragment` | raw code blocks |
|---|---:|---:|---:|
| java | **895** | 18 | 292 |
| csharp | **813** | 12 | 368 |
| lua | 256 | 1 | 145 |
| ruby | 191 | 70 | 50 |
| python | 153 | 71 | 93 |

⚠ **The pattern in that table is the single most useful thing SWIG tells us.** The backends
that generate *target-language source* — Java (895 typemaps) and C# (813) emit proxy classes
in Java/C# — push their work into **declarative typemaps**. The backends that generate a
*C extension module* — Python, Lua — push it into a **hand-written C runtime** instead
(python: 153 typemaps but 1,930 lines of `pyrun.swg`).

**We are in the Java/C# regime, not the Python regime.** Our targets emit Racket/Chez/
Gerbil/SBCL/TypeScript *source* plus a Swift dylib. That is exactly where SWIG's declarative
share is highest and most load-bearing. This is the strongest transferable evidence that the
charter's thesis fits our shape specifically.

**Against our own estimate.** The audit (§8) estimated **10–20%** of each emitter would
remain hand-written Rust. SWIG's 30-year settled answer for source-generating targets is
**~40–45%** imperative (java 43.4%, csharp 41.4%). ⚠ **k4 should plan against 40%, not
10–20%, and the handoff doc should carry that correction explicitly** — it roughly halves
the projected leverage and is the most likely place our estimate is wrong.

### 3.3 The escape hatch is three mechanisms, split by *keying* — the transferable insight

SWIG's manual documents the boundary of its declarative layer directly, in a section titled
**"What can't be done with typemaps?"**:

> Typemaps can't be used to define properties that apply to **C/C++ declarations as a whole**. For example, suppose you had a declaration like this, `Foo *make_Foo(int n);` and you wanted to tell SWIG that `make_Foo(int n)` returned a newly allocated object […] this property […] is not a property that would be associated with the datatype `Foo *` by itself. Therefore, a **completely different SWIG customization mechanism (`%feature`)** is used for this purpose.
>
> Typemaps also **can't be used to rearrange or transform the order of arguments**. […] If you want to change the calling conventions of a function, **write a helper function instead**.

— [`Doc/Manual/Typemaps.html` §14.1.6](https://www.swig.org/Doc4.4/Typemaps.html)

So the battle-tested escape hatch is a **layered set of three, separated by what they key
on**:

| mechanism | keys on | nature | scale in `Lib/` |
|---|---|---|---|
| `%typemap` | a **type** (pattern-matched, with typedef reduction and default rules) | declarative code fragment | ~3,000 directives |
| `%feature` | a **declaration** (function, class, method) | declarative property | 238 uses |
| `%inline` / `%extend` / `%pythoncode` | nothing — arbitrary code | imperative | ubiquitous |

⚠ **This resolves an ambiguity in our own E-list.** In SWIG's taxonomy, `KNOWN_UNBINDABLE`
(E1) and the curated admissions/suppressions (E7) key on a **declaration**, so they are
`%feature`-shaped, not typemap-shaped — and uniffi independently agrees (`exclude` keys on
`Name` / `Type.method`, §1.4). Two systems, 25 years apart, both found that **type-keyed and
declaration-keyed authored data need separate mechanisms.** A design that offers only one
will grow the other badly. k4 should carve this at the joint from the start.

The manual also frames the whole thing as aspect-oriented, which is a useful mental model
for the renderer contract:

> Cross-cutting concerns: […] primarily marshalling of types from/to the target language and C/C++. **Advice:** The typemap body contains code which is executed whenever the marshalling is required. **Pointcut:** the positions in the wrapper code that the typemap code is generated into. **Aspect:** […] each typemap is an aspect.

### 3.4 The type-substitution table our `emitter-contract.md` asks authors to hand-copy

`Lib/java/java.swg` opens with parallel keyed tables:

```
%typemap(jni)    int, const int &  "jint"      // the JNI C type
%typemap(jtype)  int, const int &  "int"       // the Java primitive
%typemap(jstype) int, const int &  "int"       // the Java proxy type
```

**Three parallel projections of one source type, as data.** The root brief's motivating
complaint is that `targets/_shared/docs/emitter-contract.md` *"ends by telling the next
emitter author to hand-copy a type substitution, naming the raw-pointer spelling in Haskell,
OCaml, Zig and Idris2 for them to pick from."* SWIG turned that exact artifact into a
keyed table around 2000 and has maintained it for 21 targets since. ⚠ **This is the
charter's premise validated at the finest grain available**, and it is also a warning that
one projection per type is not enough — Java needs three because the type appears in three
positions (JNI boundary, primitive, proxy). Our transform will need the analogous multi-slot
shape.

### 3.5 How heavily is the escape hatch used in practice?

The brief asks for the *fraction of real interface files* using typemaps. Measured over
SWIG's own corpus — the best proxy available here, and a weak one:

| corpus | `.i` files | with `%typemap` | with `%extend` | with target-lang code injection |
|---|---:|---:|---:|---:|
| all `Examples/` | 1,397 | 121 (9%) | 101 (7%) | 101 (7%) |
| `Examples/test-suite/` | 949 | 97 (10%) | — | — |

⚠ **Source-quality warning:** this is SWIG's *own* test and example corpus, deliberately
minimal per file and biased toward isolated features; it is **not** a sample of production
interface files, and I found **no primary source** measuring typemap usage across real-world
`.i` files in the wild. Read the 10% only as "the shipped library covers the common cases
well enough that most files add no typemap of their own." (A raw `%{ … %}` block appears in
85% of files, but that is the ordinary `#include` idiom, not an escape hatch — counting it
would be dishonest.)

The reading that *is* safe: **the escape hatch is rare in user files precisely because the
project ships 86,421 lines of per-target library absorbing it.** That cost is borne by the
generator's maintainers, not its users — which is the trade our build grove would be making.

### 3.6 The declarative layer's own complexity — the honest cost

SWIG's manual opens its typemap chapter with a disclaimer:

> let's start with a short disclaimer that "typemaps" are an **advanced customization feature that provide direct access to SWIG's low-level code generator**. Not only that, they are an integral part of the SWIG C++ type system (a non-trivial topic of its own). Typemaps are generally **not a required part of using SWIG**.

And the chapter's own table of contents is the post-mortem: the mini-language accreted
**pattern matching with typedef reduction**, **default matching rules**, **multi-argument
typemaps**, **"Matching rules compared to C++ templates"**, **special variables** (`$1`,
`$input`, `$result`, `$descriptor(type)`), **special variable *macros***
(`$typemap(method, typepattern)`, `$typemap(method:attribute, typepattern)`), **typemap
attributes**, **fragments with type specialization**, **typemap warnings**, and a dedicated
section on **"Debugging typemap pattern matching"** backed by a `-debug-typemap` CLI flag.

⚠ **This is the drift Q2 asks about, and it is unambiguous.** A logic-free substitution table
did not stay logic-free for 30 years: it grew a pattern-matching semantics complex enough to
need a comparison with C++ templates, a macro layer that lets one typemap invoke another, and
a debugger. **k4 must assume the same pressure and decide in advance where the rule/template
language stops** — with a written stop-rule, not good intentions. The `%feature`/`%inline`
layering above is what absorbed the pressure SWIG *did* refuse.

### 3.7 Paradigm reach — the survey's best evidence, and it is encouraging

SWIG's 21 targets span the widest paradigm range of any system here: **C, C++, C#, D, Go,
Java, Javascript, Lua, OCaml, Octave, Perl 5, PHP, Python, R, Ruby, Scheme (Guile), Scilab,
Tcl**. The two most alien pair — **Guile (Scheme, functional, s-expressions)** and **Java
(class-based, static, JVM)** — is a wider gap than any pair we currently ship, and
comparable to our planned Prolog/Haskell/Idris2 reach.

Did the shared model force a lowest common denominator? **The evidence says no, because
SWIG's shared layer stops at the C++ type system and the `Node` tree — it never modelled the
target side at all.** Everything target-facing is per-language `Lib/` + `Modules/`. Guile's
module is 1,634 lines and Java's is 5,145; they share the parse tree and nothing else.

⚠ **This is direct external support for root brief Q3 and ADR-0011.** The system with the
widest paradigm reach in this survey is the one whose shared layer models *only the source*,
with a per-target vocabulary above it. It is also a caution against a shared *meta-schema*
that reaches too far: SWIG's shared layer would fail our Q3 test in the other direction — it
supplies a *mechanism* (typemap matching, fragment insertion, `%feature`) and no target
vocabulary whatsoever.

### 3.8 Walk-away check

- **Generated output:** legible in the Java/C# sense (the proxy classes are ordinary readable
  Java), much less so for the C-extension backends (`pyrun.swg`-laden wrapper C is famously
  unreadable). ⚠ **Output legibility tracks the same axis as declarative share** — the
  source-generating targets score well on both. Encouraging for us.
- **Intermediate model:** genuinely legible and *externally consumable* — `-xmlout` writes
  the parse tree to XML, and `-debug-module` prints it per stage. SWIG is the **only**
  surveyed system whose intermediate model has a documented serialised form. It is still not
  committed to VCS, and no evidence was found of anyone reviewing it as a diff surface.

### Takeaway for k4

1. **Plan for ~40% imperative host code per target, not 10–20%.** SWIG's source-generating
   backends (Java 43%, C# 41%) are our closest analogue and have had 25 years to settle. This
   is the correction the handoff doc most needs to carry.
2. **Split authored data by keying, from day one: type-keyed vs declaration-keyed.** SWIG
   (`%typemap` vs `%feature`) and uniffi (typemap-ish passes vs `exclude`) converged here
   independently. Our E1/E7 are declaration-keyed; our type substitutions are type-keyed.
3. **Expect the rule/template language to accrete, and write the stop-rule now.** Thirty
   years produced pattern-match precedence, macros, attributes, fragments, warnings and a
   debugger. Decide in advance what goes to the host-function escape hatch instead.
4. **Multi-slot type projection.** One target type per source type is insufficient; Java
   needs three (`jni`/`jtype`/`jstype`) because the type appears at three positions. Design
   the projection model for N slots per type per position.
5. **Ship a per-stage model dump early.** SWIG (`-debug-top`, `-xmlout`) and uniffi
   (`pipeline --pass`) both have one; neither commits the model. Serialised-but-not-committed
   is the convergent answer.
6. **Paradigm diversity is survivable when the shared layer models only the source.** SWIG
   reaches Guile and Java from one substrate because it shares no target semantics at all —
   ADR-0011's carve-out, validated at the largest scale available.

---

## 4. ★ GObject-Introspection — the only shipped, multi-consumer model, and its four bindings

~20 years in production. GIR is the closest analogue to our whole pipeline: a machine-readable
model of a C API, from which many independent language bindings are generated. Uniquely in
this survey, **the model is a committed, versioned, installed artifact** — `.gir` XML in
`/usr/share/gir-1.0/` plus a binary `.typelib` — consumed by projects that share no code.
That makes GIR the best available evidence on k2's Q9 (was the model committed?) and on what
happens when a shared model is *wrong*.

Measured across four independent consumers: **PyGObject** (`GNOME/pygobject`), **gtk-rs
`gir`** (`gtk-rs/gir` @ `b4ad84f`, 2026-07-22) and **`gtk-rs-core`**, and **haskell-gi**
(created 2013-04-10, last pushed 2026-03-31).

### 4.1 What the model can and cannot say

Annotations are written as C comment tags and target six entity kinds — GI's own
`AttributeTargets` enum is `function | type | param | value | signal | property`
(`docs/metadata-annotations-proposal.txt`). The ownership facet, our direct analogue of
ADR-0047's producer cascade, has four values:

> **none**: the recipient does not own the value · **container**: the recipient owns the container, but not the elements · **full**: the recipient owns the entire value. For a refcounted type, this means the recipient owns a ref on the value · **floating**: alias for none, can be used for floating objects

— [gi.readthedocs.io, annotations](https://gi.readthedocs.io/en/latest/annotations/giannotations.html)

The documented **inexpressible** set is short and specific:

> The scanner does not support **C macros** as API. · **Inline functions** cannot be loaded from a dynamic library. · **varargs** can be convenient for C, but they are difficult to bind. · **Callbacks** are hard to support for introspection bindings because of their complex life-cycle. · [`const char *` with a negative length to auto-compute length] are hard to bind, and **require manual overrides**.

— [gi.readthedocs.io, Writing Bindable APIs](https://gi.readthedocs.io/en/latest/writingbindableapis.html)

⚠ Note the last phrase — **"require manual overrides"** is in the official guidance. After
twenty years, GI's answer to its own expressiveness gap is still per-target hand-authored
data. That is our E1/E7 posture, endorsed by the system with the most experience of it.

### 4.2 The correction mechanism: haskell-gi's `.overrides` — a *model patch language*

This is the survey's cleanest solution to "per-target authored data", and it is worth
copying. haskell-gi ships **56 `.overrides` files totalling 6,419 lines**, and the directive
census is startlingly narrow:

| directive | uses |
|---|---:|
| `set-attr` | **5,775 (90%)** |
| `ignore` | 31 |
| `namespace` | 27 |
| `delete-attr` | 18 |
| `if` / `endif` | 8 / 8 |
| `add-node` / `delete-node` | 4 / 3 |
| `pkg-config-name`, `namespace-version`, `alloc-info` | 6 |

Eleven directive kinds bind the entire GNOME stack to Haskell. A `set-attr` is an
XPath-shaped address into the shared model plus an attribute assignment, and **almost every
entry is a correction of a wrong upstream annotation, with the reason in a comment**:

```
# The introspection annotation marks the parameters as
# (inout transfer=full), but it is just a pointer to a GtkTreeIter.
set-attr Gtk/TreeModel/iter_next/@parameters/iter direction in
set-attr Gtk/TreeModel/iter_next/@parameters/iter transfer-ownership none

# The returned value is nullable, but it is not marked as such in the
# introspection data.
set-attr Gtk/PrintOperation/get_default_page_setup/@return-value nullable 1

# It is useful to expose these class structs when deriving new types
set-attr Gtk/WidgetClass haskell-gi-force-visible 1
```

— [`bindings/Gtk-4.0/Gtk.overrides`](https://github.com/haskell-gi/haskell-gi/blob/master/bindings/Gtk-4.0/Gtk.overrides)

Three things to take:

1. **The escape hatch is data, addressed by a stable path into the model** — not code, and
   not a hook. `Gio.overrides` alone is 2,359 lines and still purely declarative.
2. **Targets need to write *into* the shared model, not just read it.** The last example adds
   a target-private attribute (`haskell-gi-force-visible`) to a shared node. A projection
   model that is read-only from the target's side would have forced that into host code.
3. **Even this DSL grew conditionals** — 8 `if`/`endif` pairs. Small, but the drift is
   nonzero after 13 years; report it as such rather than as a clean win.

⚠ **This carves our escape-hatch inventory at a joint the audit did not name.** k2 §2.1
treats E1–E7 as one class ("no declarative form exists"). GIR's consumers show two:

| class | needs | our sites |
|---|---|---|
| **corrections / suppressions / additions to model facts** | authored declarative data, keyed by a path or identity into the model | **E1** `KNOWN_UNBINDABLE`, **E5** import table, **E7** admissions & `is_libdispatch_unexported` |
| **computations over model content** | a host function during transform | **E2** FNV-1a hashes, **E3** `case_tag` bit-packing, **E4** identifier formation, **E6** shard partitioning |

Three systems agree independently on the first row — haskell-gi `set-attr`, uniffi `exclude`
+ `rename`, gtk-rs `Gir.toml` — and all four agree the second row is host code.

### 4.3 The measured escape-hatch share, from three consumers

| consumer | mode | generated / declarative | hand-written | hand-written share |
|---|---|---:|---:|---:|
| **gtk-rs-core**, binding crates (`gio`, `pango`, `graphene`, `gdk-pixbuf`) | codegen | 55,113 (`src/auto/`) | 31,118 | **36%** |
| gtk-rs-core, all crates incl. `glib` runtime | codegen | 63,514 | 81,203 | 56% |
| **PyGObject** `gi/` Python layer | runtime projection | 3,980 | **5,903 overrides** | **60%** |
| haskell-gi | codegen | (whole GNOME stack) | 6,419 overrides | small, but declarative |

Per gtk-rs crate: `pangocairo` 80.5% generated, `pango` 74.2%, `graphene` 63.4%, `gio`
62.6%, `gdk-pixbuf` 60.8%. `glib` is only 12.4% generated because it is the runtime/substrate
crate, hand-written by design — excluding it is the fair comparison.

⚠ **Triangulation.** SWIG's source-generating backends settle at ~40% imperative (§3.2);
gtk-rs binding crates settle at ~36% hand-written; PyGObject at 60% (though it is a *runtime*
binding, not a generator, so its overrides absorb work our transform would do). **Our audit
(§8) estimated 10–20% would remain hand-written. Three independent long-lived systems say
35–45%.** This is the survey's most consequential quantitative correction.

Note also **what stayed hand-written is not random**: it is the runtime/substrate
(`glib` at 87.6% hand-written), which in our terms is the Swift dylib and the per-target
runtime — code the charter does not propose to generate anyway. The *binding surface* is
what reaches 60–80% generated.

### 4.4 The governance artifact: PyGObject's override guidelines

PyGObject ships `docs/devguide/override_guidelines.rst` — a written stop-rule for the escape
hatch, which is precisely the artifact §3.6 says k4 must produce. Its escalation ladder:

> In general, **overrides should be minimized** and preference should always be placed on **updating the underlying API to be more bindable**, adding features to **GI** to support the requirement, or adding **mechanical features to PyGObject which can apply generically to all overrides**.

That is four rungs, cheapest-fix-furthest-upstream first: **fix the source API → extend the
annotation vocabulary → add a generic mechanism to the generator → only then author a
per-target override.**

And the named rot mechanism — the direct answer to k2's Q1 ("did the suppression table rot,
and how was that detected?"):

> if an override is added, then later a bindable version of the API is added which takes a list, **there is a good chance we have to live with the override forever which masks a working version implemented by GI**.

> If a GI feature or more bindable API for a library is in the works, it is a good idea to **avoid the temptation to add temporary short term workarounds in overrides**. The reason is this can creaste unnecessary conflicts when the bindable API becomes a reality.

— [`docs/devguide/override_guidelines.rst`](https://github.com/GNOME/pygobject/blob/main/docs/devguide/override_guidelines.rst)

⚠ **The failure mode is masking, not staleness.** An override that is no longer needed does
not fail loudly — it silently shadows the now-correct generated result, forever. Our
`KNOWN_UNBINDABLE` has exactly this shape: an entry whose underlying swiftc limitation is
lifted keeps suppressing a declaration that would now compile, and nothing tells us. **No
primary source found** in any surveyed system for an automated mechanism that detects a
*stale* suppression. Every project relies on human review. ⚠ This is a genuine gap in the
prior art, and it is one we are unusually well placed to close, because our suppressions were
derived by *running the compiler* — the same run that produced them can re-test them. k4
should treat "prove each `KNOWN_UNBINDABLE` entry still fails" as a build-time assertion, not
a comment.

The guidelines also price the escape hatch in performance terms — *"Class overrides incur a
load time performance penalty"*, *"add an additional level to the method resolution order"* —
a cost specific to runtime projection that does not transfer to us.

### 4.5 gtk-rs `gir`: a four-phase generator with authored config as a first-class layer

The most architecturally detailed GIR consumer. **30,350 lines of Rust, no template engine**:

| phase | lines | role |
|---|---:|---|
| `parser` + `library*` | 3,726 | `.gir` XML → in-memory library model |
| **`analysis`** | **8,395** | the transform |
| `chunk` | 200 | a small **target-code AST** (`Chunk::UnsafeSmart`, `BlockHalf`, `Comment`) |
| `codegen` | 12,291 | the renderer (24.6% string-literal payload) |
| `writer` | 417 | output |
| **`config`** | **4,092** | the *schema* for per-crate authored `Gir.toml` data |

Two structural lessons. **First, 4,092 lines of config schema** — `functions.rs`,
`gobjects.rs`, `properties.rs`, `signals.rs`, `virtual_methods.rs`, `members.rs`,
`child_properties.rs`, `derives.rs`, `constants.rs`, `ident.rs`, `parameter_matchable.rs` —
means the authored per-target vocabulary is ~13% of the generator and is *typed and
validated*, not a free-form bag. Whatever we author in `.apiw`, its schema will be a real
component with real cost.

**Second, `Chunk` is a fourth rendering strategy** the audit did not consider: emit through a
tiny AST of code fragments rather than through strings or templates. At 200 lines it is
cheaper than a template engine and gives structural correctness (balanced blocks, correct
`unsafe` nesting) for free. Worth k4 naming and rejecting explicitly rather than by default.

### 4.6 Paradigm reach — the survey's strongest positive result

From one C/GObject model, in active production: **Python** (PyGObject), **JavaScript**
(gjs), **Rust** (gtk-rs), **Vala**, **Haskell** (haskell-gi, 13 years, still maintained),
Perl, Lua. The most-alien pair — **Haskell** (pure, lazy, typeclass-based) against **C**
(the source) — is a wider gap than anything we ship today and comparable to our planned
Haskell/Idris2/Prolog reach.

Did the shared model force a lowest common denominator? ⚠ **No — and the reason is precisely
root brief Q3.** GIR models only the *source* API (C declarations plus ownership/nullability/
array facets). It contains **no target vocabulary at all**: no notion of a Python class, a
Rust trait, or a Haskell typeclass. Every target-shaped decision lives in that target's own
generator plus its own overrides. Haskell could adopt GIR *because* GIR never tried to
describe what a binding should look like.

⚠ **The contrast with wit-bindgen (§2.6) is the sharpest result in this survey.** GIR's
shared layer models the source only → reached Haskell. wit-bindgen's shared layer models the
*lowering* (a Canonical-ABI instruction stream, i.e. a target-side commitment) → never
crossed the compiled/interpreted line in five years, and the interpreted targets forked into
separate projects. **Same question, opposite answers, and the difference is exactly where the
shared/target boundary was drawn.**

### 4.7 Walk-away check

- **Generated output:** legible across all consumers — gtk-rs `src/auto/` is ordinary
  readable Rust that ships in the published crates and is read by users daily.
- **Intermediate model:** ⚠ **the strongest walk-away result in the survey.** `.gir` XML is
  installed, versioned, distro-packaged, and consumed by projects that share no code with one
  another. Delete every binding generator and the model is still there, still meaningful, and
  still documented by an RNC schema (`docs/gir-1.2.rnc`). It is also the only surveyed model
  that outlived the tool that made it in any practical sense.

**The cost of that, stated honestly:** a committed public model becomes an API. GIR's
annotation errors propagate to *every* consumer simultaneously, which is why haskell-gi needs
6,419 lines of corrections and PyGObject 5,903 lines of overrides — **the shared model being
wrong is a per-target tax paid N times.** Vala's own guidance ("better to fix the GObject
introspection annotations in the source file so that all bindings can benefit") is the
counter-pressure. Both facts are true at once, and k4 should carry both.

### Takeaway for k4

1. **Split the escape hatch by *kind*, not by difficulty: model corrections (declarative,
   path-keyed data) vs computations (host functions).** Our E1/E5/E7 fall in the first class,
   E2/E3/E4/E6 in the second. Three systems converge on this; it is the survey's most
   directly actionable structural result.
2. **Adopt a `set-attr`-shaped patch DSL for authored per-target corrections.** haskell-gi
   binds the whole GNOME stack with eleven directives. Design for the target to *write into*
   the model (target-private attributes), not merely read it.
3. **Budget 35–45% hand-written, and expect it to be the runtime/substrate.** Corroborates
   §3.2. The binding *surface* reaches 60–80% generated; the runtime does not, and the
   charter is not proposing to generate it anyway.
4. **Write the escape-hatch stop-rule as a governance document, with the escalation ladder**:
   fix the source model → extend the annotation vocabulary → add a generic transform
   mechanism → author a per-target override. PyGObject's is a ready-made template.
5. **Suppression tables rot by *masking*, and nobody in the prior art detects it
   automatically.** This is a gap, not a solved problem. Because our `KNOWN_UNBINDABLE` was
   derived by running `swift build`, we can make re-validation a build-time assertion —
   proposing that is a genuine contribution, not a copy.
6. **Model only the source in the shared layer if you want paradigm reach.** GIR reached
   Haskell by describing no target semantics whatsoever; wit-bindgen never reached an
   interpreted language because its shared layer encodes a lowering. This is ADR-0011's
   carve-out with a controlled comparison behind it.
7. **A committed model is achievable and its costs are known**: it becomes a versioned public
   API, and its errors are taxed once per target. Serialised-and-inspectable (SWIG `-xmlout`,
   uniffi `pipeline`) is the cheaper point on that curve.
8. **Consider `Chunk`-style rendering** — a 200-line target-code AST — as an alternative to
   templates, and say why it is rejected.

---

## 5. protoc plugins — the model as a wire protocol, and named insertion points

`protoc` stops at "serialised model + arbitrary program": a `CodeGeneratorRequest` is written
to a plugin's stdin, a `CodeGeneratorResponse` comes back on stdout
([`plugin.proto`](https://github.com/protocolbuffers/protobuf/blob/main/src/google/protobuf/compiler/plugin.proto)).
The brief asks why the design stopped there rather than supplying a declarative transform.
The protocol itself answers, in three details.

**(1) What is shared is the *source* model only, fully qualified and pre-ordered.**

> FileDescriptorProtos for all files in files_to_generate and everything they import. **The files will appear in topological order**, so each file appears before any file that imports it.
>
> Type names of fields and extensions in the FileDescriptorProto are **always fully qualified**.

⚠ Two of our §3.1/§3.3 statefulness sites are answered here by *model preparation* rather
than by generator machinery. Framework ordering (our `topological_sort` over
`Framework.depends_on`, `generate.rs:74`) is delivered as **model order**; name resolution is
eliminated by **full qualification**, the same answer wit-bindgen's C# backend reached under
duress (§2.4). Neither is a transform *feature*; both are properties the model is required to
have before any target sees it. That is a cheap and transferable design rule: **push order and
qualification into the model, not into the transform.**

**(2) The extension mechanism is a named, in-band insertion point in the *output*.**

> If non-empty, indicates that the named file should already exist, and the content here is to be inserted into that file at a defined insertion point. This feature allows a code generator to **extend the output produced by another code generator**. The original generator may provide insertion points by placing special annotations in the file that look like: `@@protoc_insertion_point(NAME)`
>
> […] Note that if the line containing the insertion point begins with whitespace, **the same whitespace will be added to every line of the inserted text**. This is useful for languages like Python, where indentation matters.
>
> The code generator that generates the initial file and the one which inserts into it **must both run as part of a single invocation of protoc**.

⚠ **This is a shipped answer to k2's Q7 (deferred regions), and the audit's option list does
not contain it.** Rather than accumulating a header in the transform, the renderer emits a
*named hole* and a later pass fills it. It handles our racket `provide/contract` case
(a block that must precede the definitions it names) and our `imports.rs` grouping directly.
Note the indentation rule — the same concern uniffi kept as a template filter (§1.2) — and
the ordering constraint that makes it work at all.

**(3) Streaming and chunking are first-class in the response.**

> If the name is omitted, the content will be appended to the previous file. This allows the generator to **break large files into small chunks**, and allows the generated text to be streamed back to protoc so that large files need not reside completely in memory at one time.

That is E6's variable output file set (gerbil's 256-selector generics shards) treated as an
ordinary capability of the response protocol rather than a special case. Both protoc and our
gerbil emitter arrived at "one logical unit, N physical files" for the same reason: a
downstream toolchain's limits.

**Why no declarative transform?** Because protoc never modelled the target side at all — the
same reason GIR reaches Haskell (§4.6). A declarative transform requires a target vocabulary
to transform *into*; protoc deliberately has none, so there is nothing to be declarative
about. ⚠ **This is the survey's cleanest statement of the trade the root brief's Q3 is
making**: a per-target authored vocabulary over a shared meta-schema is precisely what buys
the ability to be declarative, and precisely what protoc gave up in exchange for unlimited
plugin freedom.

**Walk-away check.** Output: legible, and read by millions daily. Intermediate model:
**strongly legible and durable** — a `FileDescriptorSet` is an ordinary protobuf message with
a published schema, routinely written to `.desc` files and consumed by tools that never see
`protoc` itself (buf, grpc reflection, schema registries). Second only to GIR on this axis,
and unlike GIR it is a *self-describing* format.

### Takeaway for k4

1. **Make topological order and full qualification properties of the model, not jobs for the
   transform.** Two of our whole-corpus passes disappear if the model guarantees them.
2. **Named insertion points are a real fifth answer to per-file accumulators** — emit a hole,
   fill it later — and they are absent from k2 §3.3's option list. Cheap for the renderer,
   and they keep the transform from having to see the whole file.
3. **A data-dependent output file set is unremarkable** if the renderer's output contract is
   "a list of (name, content)" rather than "one template, one file". E6 is not exotic.
4. **The freedom/declarativeness trade is explicit.** protoc bought maximal plugin freedom by
   modelling no target vocabulary. Our Q3 buys declarativeness by authoring one. k4 should
   state this as the trade it is.

---

## 6. Djinni (Dropbox) — archived, and the post-mortem is about everything except the generator

Repo created 2014-09-08, **archived**, last commit 2020-03-25 (`4f3aa69`).

### 6.1 Architecture: 5,325 lines for six output languages, no templates

| component | lines |
|---|---:|
| `JavaGenerator` | 657 |
| `generator` (shared traversal) | 447 |
| `ObjcGenerator` / `JNIGenerator` / `ObjcppGenerator` / `CppGenerator` | 426 / 416 / 401 / 367 |
| `parser` + `resolver` + `ast` | 771 |
| `YamlGenerator` | 230 |
| the five `*Marshal` classes | 105–236 each |
| **total** | **5,325** |

⚠ **Calibration warning before anything else is drawn from this.** Djinni is 5,325 lines for
*six* targets; our five emitters are 71,719. The difference is not competence — it is that
Djinni's IDL describes what *its users* declare (records, interfaces, enums, primitives),
while ours describes **153 Apple frameworks, ~6,500 selectors, ~40,000 methods** of API we do
not control. **Generator size tracks the richness and untidiness of the source model, not the
number of targets.** Any leverage estimate borrowed from a small-IDL system will be wrong for
us in the optimistic direction.

### 6.2 The `Marshal` abstraction independently re-derives SWIG's multi-slot typemap

```scala
// Generate code for marshalling a specific type from/to C++ including header and type names.
// This only generates information relevant to a single language interface.
// As a consequence a typical code generator needs two Marshals: one for C++ and one for
// the destination, e.g. JNI.
abstract class Marshal(spec: Spec) {
  def typename(tm: MExpr): String       ;  def fqTypename(tm: MExpr): String
  def paramType(tm: MExpr): String      ;  def fqParamType(tm: MExpr): String
  def returnType(ret: Option[TypeRef]): String ; def fqReturnType(...): String
  def fieldType(tm: MExpr): String      ;  def fqFieldType(tm: MExpr): String
  def toCpp(tm: MExpr, expr: String): String
  def fromCpp(tm: MExpr, expr: String): String
}
```

— [`src/source/Marshal.scala`](https://github.com/dropbox/djinni/blob/master/src/source/Marshal.scala)

**Eight name slots** (four syntactic positions × qualified/unqualified) **plus two
conversion-expression slots**, per target. This is SWIG's `jni`/`jtype`/`jstype` triple
(§3.4) reinvented independently, one level richer. Two more points fall out:

- **Projection is pairwise, not per-target**: *"a typical code generator needs **two**
  Marshals: one for C++ and one for the destination."* Our shape is the same — every emitted
  thing is projected into *both* the target language and the Swift adapter, and the two must
  agree. A projection model with one slot per type per target would not express that.
- The `toCpp`/`fromCpp` slots return **expressions, not declarations** — the conversion is
  data, produced by the transform, consumed positionally by the renderer.

### 6.3 A serialised model export, again

`YamlGenerator.scala` writes a YAML description of the interface, stamped
`# AUTOGENERATED FILE - DO NOT MODIFY!`, so that one Djinni project can reference another's
types as external types. ⚠ **Five of the surveyed systems export a serialised model** — SWIG
(`-xmlout`), uniffi (`pipeline` peek/diff), GIR (`.gir`, shipped), protoc (`FileDescriptorSet`),
Djinni (YAML). **None commits it to VCS as the reviewed diff surface the charter imagines.**
Where the export exists, its purpose is *interchange or debugging*, never review.

### 6.4 The post-mortem — and what it is actually about

Dropbox's 2019 retrospective is the primary source, and its findings are almost entirely
*outside* the generator:

> we also had to invest time in building tools that would support C++ code sharing. Most importantly, we needed a **custom build system** that created libraries containing C++ code as well as Java and Objective-C wrappers […] This system was a **big drag on our resources** as it needed to be constantly updated to support changes in two build systems.

> debugging multi-threaded code running back and forth between C++ and Java — **it took weeks to nail down!**

> **mobile developers simply did not want to work on a C++ project.** This caused a lot of talented mobile engineers to leave the project

> By writing code in a non-standard fashion, we took on overhead that we would have not had to worry about had we stayed with the widely used platform defaults. **This overhead ended up being more expensive than just writing the code twice.**

— [Eyal Guthmann, "The (not so) hidden cost of sharing code between iOS and Android", 2019-08-14](https://dropbox.tech/mobile/the-not-so-hidden-cost-of-sharing-code-between-ios-and-android)

⚠ **Be careful with this citation; it is easy to over-claim.** Dropbox was sharing
*application logic* across two platforms, where "write it twice" is a genuine alternative. We
generate *bindings* to 153 frameworks that nobody would hand-write at all, so their headline
conclusion does not transfer. **No primary source found** stating that Djinni's IDL or
generator design was itself the problem, or giving a technical reason for the archival.

Two findings *do* transfer, and both are corroborated elsewhere in this survey:

1. **Debugging across a generated boundary is expensive** — "weeks" for one deadlock. Our
   equivalent is a bug that could live in the rules, the model, the template, the Swift
   adapter, or the target runtime. The audit's §5.3 finding (goldens inert for the real
   corpus) means we currently have *fewer* instruments than Dropbox had, not more.
2. **The implementation language of the generator layer is a staffing filter.** "Mobile
   developers simply did not want to work on a C++ project" is the same failure as
   wit-bindgen's C# expert who was "not familiar with Rust at all" and found the generator
   "somewhat overwhelming" (§2.4). ⚠ Two independent systems, same lesson, and it is the
   clearest *organisational* argument for the declarative re-cut: a Racket or Haskell expert
   should be able to fix a Racket or Haskell projection without learning our Rust.

### Takeaway for k4

1. **Do not borrow leverage estimates from small-IDL generators.** Djinni does six targets in
   5,325 lines because its source model is tiny. Ours is not.
2. **Design type projection as multi-slot *and* pairwise** — target language *and* Swift
   adapter, in every syntactic position, qualified and unqualified. Djinni needed ten slots;
   SWIG needed three per position. One "target type name" field will not survive contact.
3. **Conversion fragments are model data**, produced by the transform as expressions, not
   assembled by the renderer.
4. **Cite Dropbox for the boundary-debugging and staffing costs only** — and pair the
   staffing point with wit-bindgen #1265, because together they are the strongest
   non-technical case for the re-cut.
5. **The handoff doc should name the debugging story explicitly.** A five-layer pipeline needs
   an answer to "where did this wrong line come from", and ADR-0047's derivation-trace
   provenance is the asset to point at.

---

## 7. ★ The MDA / QVT / ATL / Xpand lineage — the cautionary tradition, read carefully

This is the most thoroughly *declarative* model-transformation tradition and the one the
brief says to take seriously rather than dismiss. Doing that properly means separating three
different claims that are usually run together, because **only one of them is bad news for
us.**

### 7.1 The taxonomy that decides how much of this applies

The MTL literature classifies transformation languages on an axis that turns out to be
decisive (Höppner et al. 2022, Table 1):

| axis | **internal** (embedded in a host language) | **external** (standalone language + compiler/VM) |
|---|---|---|
| examples | FunnyQT (Clojure), RubyTL (Ruby), NMF Synchronizations (C#) | **ATL, QVT, Henshin** |
| rules are | a repurposed host construct (macros, classes) | an explicit dedicated syntax construct |
| navigation | host language | dedicated syntax (OCL) |

⚠ **Our proposal is an *internal* MTL.** ADR-0047 already commits to `ascent` — datalog as a
Rust macro, compiled with the pipeline, rules in version control — and explicitly parks a
runtime-loadable rule DSL as out of scope. **The industrial retreat documented below is
overwhelmingly a retreat from *external* MTLs.** That is not a technicality: it is the single
most important framing point in this section, and k4 should not let the cautionary literature
be cited against a design it does not describe.

### 7.2 What actually happened: three findings, ranked by how much they should worry us

**(a) Eclipse's own model-to-text stack retreated from a dedicated template language to a
general-purpose language with template expressions. — Should worry us most.**

Xpand was *the* declarative M2T template language of the openArchitectureWare lineage:
polymorphic template dispatch over metamodel types, a dedicated expression language, no host
language. It lost to Xtend, a general-purpose statically-typed JVM language whose only
templating feature is rich multi-line string literals with interpolation.

> **Xtext 2.9.0** (released on **16.11.2015**) has introduced a new (Xtend-based) code generator infrastructure. In favor of this new generator, the old (Xpand-based) generator has been **deprecated since Xtext 2.11.0** (released on **24.01.2017**).
> — [eclipse/xtext-core issue #1485](https://github.com/eclipse-archived/xtext-core/issues/1485), opened 2020-05-11, closed 2023-04-17

And migration was not mechanical:

> One reason why migration scripts are not published is that **Xpand code cannot be completely translated to Xtend**. Xtend is not as powerful as Xpand, especially when using UML. In Xpand, the UML type system adapter analyzed applied profiles of a model to create virtual types for stereotypes, but in Xtend, there is only the Java type system.

⚠ The direction matters and is easy to misread. **They kept templating and dropped the
dedicated language around it** — and they accepted a real capability loss (metamodel-aware
virtual types) to get IDE support, debugging, and host-language interop. That is precisely
the trade uniffi made (Askama templates + ordinary Rust passes, §1.3) and precisely what
ADR-0047 already chose. **The lesson is not "declarative loses"; it is "the declarative layer
must live inside a host language with real tooling, and expect to pay for that in
expressiveness."**

**(b) The claimed benefits of dedicated MTLs are, after twenty years, largely
unsubstantiated. — Should worry us moderately.**

The largest empirical study of the question interviewed **56 researchers and practitioners**:

> A recent literature study of us revealed, that while a large number of such advantages and also disadvantages are claimed in literature, **there exist only a few studies investigating to what extent these claims actually hold.**
>
> Our study also revealed, that **most claims in literature are made broadly and without much explanation as to where the claim originates.** […] Regardless of the concrete reasons, a result of this practice is a **lack of cause and effect relations** […] **Claims are thus easily dismissed based on anecdotal evidence.**
>
> Our data suggests, that **much needs to be done in order to convey the viability of model transformation languages.** Efforts to provide more empirical substance need to be undergone and **lackluster language capabilities and tooling need to be improved upon.**
> — Höppner, Haas, Tichy, Juhnke, *Advantages and Disadvantages of (Dedicated) Model Transformation Languages: A Qualitative Interview Study*, [arXiv:2201.13348](https://arxiv.org/abs/2201.13348), 2022-01-31 (final 2022-07-04)

⚠ **This is a finding about the evidence, and it is the honest headline for this whole
section.** The tradition closest to our proposal cannot, after two decades, produce
substantiated evidence that its central claim is true. k4 should therefore treat "declarative
rules will be more legible / more productive / more maintainable" as **an assumption to be
tested by the pilot, not a premise the survey has established.** ADR-0047's own worked example
(1,236 lines of classifiers → rules, with provenance) is stronger local evidence than
anything the MDE literature offers, precisely because it is measured in our repo.

**(c) In industry, MDE tooling was mostly used for documentation and up-front design, with
little code generation at all. — Should worry us least.**

Hutchinson, Whittle et al.'s ICSE 2011 industrial assessment and its 2014 follow-up found
that *"modeling tools are primarily used to create documentation and for up-front design with
little code generation"*, and that the decisive factors were social and organisational rather
than technical — notably *the disparity between those who benefit from a system and those who
must do extra work to support it*.

⚠ This is a finding about **MDA as a software-development methodology** — hand-drawn UML
models as the primary artefact, PIM→PSM refinement, round-tripping — and it barely touches
us. Our source model is **extracted mechanically from headers**, not authored by humans; there
is no round-trip; nobody is being asked to draw diagrams. **k4 should say so explicitly**,
because "MDA failed" will otherwise be offered as an objection, and the reasons MDA failed are
mostly reasons that do not obtain here. The one that *does* obtain is the last clause: the
people who must author rules and templates (target experts) should be the people who benefit
(target experts) — which §2.4 and §6.4 say is exactly the case for us, and is the strongest
organisational argument in the survey.

### 7.3 The one unambiguous positive: automatic trace links

ATL and QVT both provide **automatic tracing** — a maintained correspondence between source
and target model elements, produced by the engine rather than by the transformation author
(Höppner et al., Table 1: *Tracing — Automatic: ATL, QVT; Manual: NMF Synchronizations*).

⚠ **This is ADR-0047's "provenance falls out of the derivation trace" claim, validated as a
standard achieved property of the declarative approach across a twenty-year tradition, not a
hopeful extrapolation from one repo.** It is also the property the *internal* MTLs listed in
the table most often *lack* (NMF is manual) — so it is worth k4 confirming that `ascent` gives
us automatic tracing at the projection layer as it does at the analysis layer, rather than
assuming it.

### 7.4 Walk-away check

- **Generated output:** varies; the tradition's practice of generating skeletons for humans to
  fill in (protected regions) is a recognised smell and produced the round-trip problem MDA is
  best known for failing at. ⚠ Relevant to us as a thing to *avoid*: never generate code a
  human is expected to edit in place. Our pipeline already regenerates aggressively.
- **Intermediate model:** legible in principle — EMF/Ecore models are XMI, self-describing
  via a MOF metamodel. In practice XMI's reputation for unreadability and merge-hostility is
  itself part of why the tradition lost ground. ⚠ A cautionary note for any proposal to commit
  our projection model: **a committed model that humans cannot diff usefully is worse than a
  dumpable one.**

### 7.5 Where the search found silence

- **No primary source found** for a post-mortem of a *specific* industrial ATL or QVT
  code-generation deployment at a scale comparable to ours (hundreds of source modules, tens
  of thousands of operations). The MDE literature's empirical base is interview- and
  survey-shaped, not incident-shaped.
- **No primary source found** for anyone measuring the escape-hatch share of an ATL/QVT
  deployment — the number §3.2 and §4.3 supply for SWIG and gtk-rs has no counterpart here.
- **No primary source found** stating why QVT-R (the *declarative*, bidirectional half of the
  OMG standard) failed to gain implementations while QVT-O (the *imperative* half) did. This
  would be the most directly relevant post-mortem in the tradition and I could not find one;
  a future session should not repeat this search without a better instrument than web search.

### Takeaway for k4

1. **Insist on the internal/external distinction whenever this tradition is cited.** `ascent`
   is an internal MTL in a host language with real tooling — the configuration the retreat
   moved *toward*, not away from. ADR-0047 already made the choice the history endorses.
2. **Do not claim legibility/productivity benefits as established.** Twenty years of a
   declarative-transformation tradition cannot substantiate them. Frame them as the pilot's
   hypothesis, and say what measurement would falsify them.
3. **Reject "MDA failed" as a blanket objection, on the record and with reasons.** Our model
   is machine-extracted, single-direction, never round-tripped, and never hand-edited. The
   handoff doc should carry this rebuttal so the build grove does not re-litigate it.
4. **Expect to pay expressiveness for tooling.** Xpand→Xtend cost metamodel-aware virtual
   types and bought debuggers and interop. Name the equivalent price for `ascent` + templates
   before committing.
5. **Never generate code intended for human editing.** Protected regions are the tradition's
   signature failure; our regenerate-aggressively habit already avoids it, and the handoff doc
   should state it as a constraint rather than leave it implicit.
6. **Confirm automatic trace links at the projection layer.** They are the tradition's one
   solidly evidenced win and ADR-0047's headline benefit; do not assume they carry over from
   the analysis layer for free.

---

## 8. Secondary systems — three points they add that the primary seven do not

Covered at lower depth, and included only where they add something the ★ systems do not.

### 8.1 WinRT / WinMD — the second existence proof for a committed multi-consumer model

Windows Runtime metadata (`.winmd`) is an ECMA-335 metadata file describing the API surface,
**shipped by the platform vendor** and consumed by mutually independent projections: C++/WinRT,
C#/CsWinRT, Python/WinRT, and Microsoft's own Rust binding
[`windows-rs`](https://github.com/microsoft/windows-rs), whose `windows-bindgen` crate
generates from that metadata and is offered to users as a supported way to *"generate a
minimal, project-specific binding […] for any additional APIs you need."*

This matters for one reason: ⚠ **it is the second existence proof, alongside GIR (§4.7), that
a committed, versioned, vendor-shipped API model can support many independent per-language
projections over decades.** Two is not many, but it moves "the model is a durable artifact"
from speculative to demonstrated. Both cases share the property that the model describes the
*source* platform only, with no target vocabulary — the same boundary GIR, protoc and SWIG
all drew (§4.6, §5, §3.7).

It is also the survey's clearest example of *per-user* generation: `windows-bindgen` exists
because the full projection is too large to ship whole, so users generate the subset they
need. Our corpus (153 frameworks) has the same scale property, and the audit's E6 sharding
(§2.1) is a symptom of it.

### 8.2 rust-bindgen — every mature generator ships an override catalogue

`rust-bindgen`'s manual has a chapter called *"Customizing the Generated Bindings"* whose
table of contents is, in effect, the escape-hatch inventory:

> Allowlisting · Blocklisting · Treating a Type as an Opaque Blob of Bytes · Replacing One Type with Another · Preventing the Derivation of `Copy` and `Clone` · Preventing the Derivation of `Debug` · Preventing the Derivation of `Default` · Annotating Types with `#[must-use]` · Field Visibility · Code Formatting

— [`book/src/SUMMARY.md`](https://github.com/rust-lang/rust-bindgen/blob/main/book/src/SUMMARY.md)

Nine documented override kinds, specifiable **either** through the builder API **or** as
annotations in the C source (`/** <div rustbindgen opaque></div> */`) — the same dual siting
GIR uses (§4.1).

⚠ **This is the survey's most repeated single pattern, and it is worth stating as a law:
every mature multi-target generator ships a documented catalogue of authored per-target
overrides — SWIG `%typemap`/`%feature`/`%extend`, GIR annotations + haskell-gi `set-attr` +
PyGObject overrides, uniffi `exclude`/`rename`, gtk-rs `Gir.toml`, bindgen's ten, Kotlin/Native
`cinterop` `.def` files.** Six systems, six independent designs, zero exceptions. Our
`KNOWN_UNBINDABLE` and `ADMITTED_*` tables are not a defect of our emitters; they are the
normal, expected shape of this problem, currently expressed as Rust constants instead of as
data. ⚠ **k4 should stop treating the escape hatch as a risk to be minimised and start
treating it as a component to be designed.**

Note also the *kinds* that recur: allow/block (E1, E7), opaque-blob (a representability
fallback — our ADR-0051 ladder), type replacement (§3.4's multi-slot substitution), and
derive/trait suppression. Four of bindgen's nine have direct analogues in our audit.

### 8.3 PyO3 and the honest baseline: nobody generates the runtime

PyO3, C++/WinRT's hand-written support library, `glib`'s 87.6% hand-written share (§4.3),
SWIG's `pyrun.swg` (§3.2) and uniffi's per-language runtime templates all say the same thing:
⚠ **the runtime/substrate layer is hand-written everywhere, in every system surveyed, without
exception.** No surveyed project generates its own marshalling runtime.

This is directly relevant to the charter's scope. Our per-target Swift dylib and target-language
runtime are in that category, and the audit already found the shared substrate is only 866 live
lines (§1.2). **The re-cut's addressable surface is the 36,421 lines of production emitter
code, not the runtime** — and the handoff doc should say so, because "42:1 shared-to-per-target"
invites the reader to imagine a larger prize than exists.

### 8.4 Systems examined and dropped

- **Emscripten WebIDL binder** — thin, single-target-family, no post-mortem material found.
- **Kotlin/Native `cinterop`** — `.def` files are another authored-per-target-data instance
  (§8.2) and add nothing new.
- **`cbindgen`** — single direction (Rust→C), no per-language projection problem.
- **JNI generator families** — superseded as evidence by SWIG's Java backend (§3.2), which is
  larger, older and measurable.

### Takeaway for k4

1. **A committed, vendor-shipped API model is demonstrated, not speculative** — GIR and WinMD
   are two independent instances spanning decades and many consumers. Both describe the
   *source* platform only.
2. **Design the authored-override layer as a first-class catalogue, not as a regrettable
   escape.** Six systems, six independent designs, zero exceptions; four of rust-bindgen's
   nine override kinds have direct analogues in our audit.
3. **Do not count the runtime in the addressable surface.** Every surveyed system hand-writes
   its marshalling runtime, without exception. The prize is the 36,421 lines of production
   emitter code, and the handoff doc should say so rather than let "42:1" imply more.

---

## 9. Synthesis — k2's fourteen questions, answered

Each answer names the systems it rests on and, where the evidence is thin, says so. Question
numbers are k2 §10's.

### On the escape hatch (the crux)

**Q1 — How do shipped systems handle "what the downstream compiler rejects"? Is there a
feedback channel from the compiler back into the model? Did the suppression table rot, and how
was that detected?**

*Mechanism:* **authored suppression data, universally.** uniffi `exclude` in `uniffi.toml`,
keyed `Name` or `Type.method`, applied as a pipeline pass (§1.4); haskell-gi `ignore` +
`set-attr` (§4.2); rust-bindgen blocklisting (§8.2); SWIG `%ignore`/`%feature` (§3.3);
PyGObject overrides (§4.3). Six systems, one answer.

*Feedback channel:* **none exists. No primary source found, in any surveyed system, for an
automated loop from a downstream compiler's errors back into the model.** Every one is
manually curated. Our E1 is therefore *normal*, not anomalous — and our provenance for it
(derived by running `swift build`) is unusually good by comparison.

*Rot:* documented, and the failure mode is **masking, not staleness** — PyGObject's
governance doc: *"there is a good chance we have to live with the override forever which masks
a working version implemented by GI"* (§4.4). ⚠ **Detection is human review everywhere.
Nobody automates it.**

⚠ **This is the survey's clearest opportunity.** Because our 51 `KNOWN_UNBINDABLE` entries
were *produced* by running the Swift compiler, the same run can re-test them. "Every
suppression entry must still fail to compile, or the build fails" is a mechanism no surveyed
system has, and it is cheap for us specifically. k4 should propose it.

**Q2 — What escape-hatch shape survived contact with a real corpus? Rank (a) host-function
registry, (b) general-purpose expression language in the rule engine, (c) staged pipeline with
imperative passes between declarative ones, (d) compute it upstream in the fact base.**

Ranked by observed outcome:

1. **(c) staged pipeline with imperative passes — the winner, unanimously.** uniffi's
   `MapNode` passes with `#[map_node(expr)]` per-field overrides, the doc calling it *"an
   escape hatch for mappings that can't be auto-generated"* (§1.3); gtk-rs's `analysis` phase
   (§4.5); SWIG's four dumpable stages (§3.1). Every system that has an intermediate model
   also has imperative passes over it, and that is where the hard cases live.
2. **(a) host functions — universal for *computation*, and settled** (Q3 below).
3. **(d) compute it upstream in the fact base — used deliberately for a narrow, valuable
   class**: ordering and name qualification (protoc, §5), platform truth (GIR annotations,
   Q14). Cheap where it applies; not general.
4. **(b) a general-purpose expression language inside the rule engine — nobody shipped this,
   and the nearest thing is a cautionary tale.** SWIG's `$typemap(method, typepattern)`
   special-variable macros are the closest approach, and they are precisely the feature that
   drove the typemap layer into needing pattern-match precedence rules, a comparison with C++
   templates, and a `-debug-typemap` flag (§3.6). ⚠ **Treat (b) as the anti-pattern.**

⚠ The audit's six hard escapes split across (a), (c) and (d) — **none of them needs (b).**
That is a genuinely de-risking result.

**Q3 — Where did systems put derived-identifier computation?**

**Settled, unanimously: host functions running in a transform pass, whose results become
first-class fields on the model.** uniffi `bindings/python/pipeline/names.rs` — `heck` casing
plus a 35-entry keyword table, exposed as `type_name`/`var_name`/`function_name` and stored on
nodes (§1.4); gtk-rs `nameutil.rs` + `case.rs`; Djinni's per-target ident styles carried on
`Spec` (§6.2); SWIG's naming in `Lib/` plus `%rename`.

⚠ **No surveyed system made naming declarative.** The audit's load-bearing observation at E4
— *"derived identifiers must be first-class nodes in the projection model"* — is exactly what
every system does. Consider this question closed.

**Q4 — Did any system tolerate a data-dependent output file set?**

**Yes, and it is unremarkable.** protoc's `CodeGeneratorResponse` is a list of
`File{name, insertion_point, content}` with explicit support for chunking a large file and
streaming (§5); `windows-bindgen` generates a per-user subset of the Windows surface (§8.1);
SWIG's Java backend emits one proxy file per class.

The enabling condition is stated most clearly by protoc: **the renderer's output contract must
be "a list of (name, content)", not "one template → one file".** Template engines assume the
latter; nobody who needed the former used a template engine for that layer. ⚠ E6 (gerbil's
256-selector shards) is not exotic — it is a constraint on the *renderer's interface*, and
costs nothing if designed in.

**Q5 — What was the escape hatch's measured share, and did it grow?**

⚠ **The survey's most consequential number, and it contradicts our estimate.**

| system | measure | hand-written / imperative share |
|---|---|---:|
| SWIG java | `Modules/java.cxx` vs `Lib/java/` | **43.4%** |
| SWIG csharp | ditto | **41.4%** |
| SWIG, 17 targets | aggregate | 39.2% |
| gtk-rs-core binding crates | hand-written vs `src/auto/` | **~36%** |
| PyGObject `gi/` | overrides vs rest | 60% (runtime binding, less comparable) |
| uniffi `general` pass | hand-written pass fns vs node declarations | 80% by LOC; 28% of fields |
| **our audit §8 estimate** | | **10–20%** |

**Three independent, long-lived, source-generating systems land at 35–45%. Our estimate is
low by roughly a factor of two to four.** k4 must plan against 40%, and the handoff doc must
carry the correction explicitly — it roughly halves the projected leverage.

*Growth over time:* **no primary source found** that measures escape-hatch share
longitudinally in any system. The absence is worth recording: nobody tracks this, so nobody
can say whether it grows. ⚠ Since "a system whose escape hatch grew to 50% is the failure mode
this design must be able to see coming" (k2's own words), **k4 should propose measuring it
per-target per-release from day one** — the metric does not exist in the prior art and would
have to be ours.

*One consolation:* what stays hand-written is not random. It concentrates in the
**runtime/substrate** (`glib` 87.6% hand-written, SWIG's `pyrun.swg`, every system in §8.3) —
which the charter does not propose to generate. The *binding surface* reaches 60–80%
generated.

### On statefulness

**Q6 — How were whole-corpus passes expressed? Is "the transform is a whole-corpus function;
the renderer is per-node" the standard shape, or do systems stage global-then-local
explicitly?**

**Both, and the distinction is the useful part.** The standard shape *is* "whole-corpus
transform, per-node renderer" — but the systems that do it well **stage it explicitly** and
give the staging two distinct mechanisms:

- **downward propagation** — uniffi's `Context`, threaded through `map_node`: *"Passing the
  crate name down so it can be used to derive FFI function names. Passing the namespace name
  down so it can be used to determine which types are external"* (§1.3).
- **upward accumulation** — uniffi's `Node::visit()`: *"useful when you want to populate a node
  field using it's descendants. For example, building up the FFI definitions by visiting all
  functions/methods inside a namespace."*

Plus a third that removes the need entirely: **push it into the model** (protoc guarantees
topological order and full qualification *before* any plugin runs, §5).

⚠ Our nine whole-corpus passes (§3.1) map cleanly: the three ownership registries and the
protocol closure are upward accumulation; framework ordering and full qualification should be
model properties, not passes.

**Q7 — How were per-file accumulators handled? Deferred region / two-pass emit, or is "compute
the header in the transform" universal?**

**Not universal — there are five distinct shipped answers, and the audit's option list has
two of them.**

| answer | who | note |
|---|---|---|
| **compute the header in the transform** | uniffi (imports as a pipeline pass) | the *stated ideal*: jhugman named *"a principled approach for imports"* as a top-three benefit of the pipeline, unprompted (§1.6) |
| **named insertion point in the emitted text** | protoc `@@protoc_insertion_point(NAME)` | ⚠ absent from k2 §3.3; handles racket's `provide/contract`-before-definitions case directly; carries the indentation rule with it (§5) |
| **fully-qualify everything, abolish the import block** | wit-bindgen C# (as the fix for a shipped bug), protoc descriptors | ⚠ absent from k2 §3.3; cheapest, costs output idiom (§2.4) |
| **append to an already-written file** | wit-bindgen `Files::push` | mechanical, no model support needed |
| **authored per-target import spec** | our E5 (`chez_builtins.txt`) | still needed where the answer depends on the *target runtime's* export set |

⚠ **The honest read: this is the one statefulness question the prior art has not converged
on**, and it is the one an outside bindgen author independently rates as the main prize. k4
should pick per site rather than seek one mechanism.

**Q8 — How was deterministic total ordering guaranteed? Did anyone get bitten by
non-determinism in review diffs?**

*Mechanism:* protoc guarantees topological order **as a property of the model** and documents
it (§5); gtk-rs and uniffi use ordered collections; SWIG follows parse order.

*Bitten in review diffs:* ⚠ **no primary source found, in any system — and the reason is
itself the finding.** No surveyed system commits its projection model or reviews generated
output diffs as its primary correctness instrument (Q9, Q10). There are no review diffs to be
bitten by. **Our ordered_classes tie-breaking-for-golden-stability has no counterpart in the
prior art because our goldens-as-truth habit has no counterpart either.** That is a
distinguishing strength, not a gap — but it means k4 gets no external guidance here, and
should treat total-ordering-by-construction as our own requirement.

### On the model and its verification

**Q9 — What did the projection model look like on disk, and was it committed? Did its size
become a problem at corpus scale?**

**Five of seven systems export a serialised model; none commits it as a reviewed diff
surface.**

| system | serialised form | committed? | purpose |
|---|---|---|---|
| GIR | `.gir` XML + `.typelib`, installed to `/usr/share/gir-1.0/` | **shipped by the platform** | multi-consumer interchange |
| WinMD | ECMA-335 metadata | **shipped by the vendor** | multi-consumer interchange |
| protoc | `FileDescriptorSet` (self-describing protobuf) | often, as `.desc` | interchange, tooling |
| SWIG | `-xmlout`, `-debug-top 1,2,3,4` | no | debugging |
| uniffi | `pipeline` CLI: initial IR, **diff after each pass**, final IR | no | debugging |
| Djinni | YAML export, `# AUTOGENERATED - DO NOT MODIFY` | as an input to other projects | interchange |
| wit-bindgen | none | — | — |

⚠ **Crucial distinction: GIR and WinMD ship the *source* model, not a *projection* model.**
Nobody ships a per-target projection model. So the charter's "reviewable model as the diff
surface" gain is **unattested** — it was *claimed* by uniffi's author as a motivation and
realised as a **debugging CLI**, and that CLI's authors immediately hit the volume problem:
*"This is a lot of data. Use CLI flags to reduce it to a reasonable amount"* — with `--pass`,
`--type` and `--name` filters, on a corpus vastly smaller than 153 frameworks / ~40,000
methods.

**Recommendation for k4: dumpable per stage, diffable per pass, filterable by type and name —
not committed.** And note MDA's warning: a committed model humans cannot diff usefully (XMI)
is worse than a dumpable one (§7.4).

**Q10 — How was equivalence proven during a transform-and-template migration?**

⚠ **The largest substantive silence in the survey. No system reported a formal equivalence
proof, and no system reported golden-output diffing as the instrument that caught the
regressions.**

What is on the record instead:

- uniffi migrated Python using its **existing cross-language test fixtures**, plus the
  pipeline-diff tool, which its author credits with finding his own porting bugs: *"I had a
  few errors when re-implementing all of the code and `peek` came in very handy to fix them"*
  (§1.5). ⚠ **The instrument that worked was per-stage model diffing, not output comparison.**
- wit-bindgen's C# backend shipped a **non-compiling output** for months because the fixture
  set `ImplicitUsings=true`, which masked a missing import (§2.4). Compile-the-output was the
  test, and it passed for the wrong reason.
- Nobody attempted differential execution or round-trip proofs.

**For us this is unexpectedly good news, and k4 should say so plainly.** The audit's most
uncomfortable finding (§5.3 — corpus goldens inert, chez has no snapshot mechanism at all)
looked like a blocker for an equivalence-proof strategy. The prior art says **no such strategy
existed anywhere**; the technique that actually caught bugs was **per-stage model diffing**,
which (i) is cheap, (ii) is independent of goldens, and (iii) **works for chez**, where
goldens-as-truth cannot. ⚠ **The pipeline-diff tool is therefore not a nice-to-have but the
proposed equivalence instrument, and it answers the charter's chez problem** (root brief, "On
the horizon"). Build it first.

The residual honest gap: model-diffing proves *the transform* did not change, not that the
*emitted text* is unchanged. For that we still need at least one target with working corpus
goldens, and the audit says we currently have none. k4 must name materialising them as
prerequisite work.

**Q11 — How much test code did the rewritten systems carry, before and after?**

⚠ **Complete silence. No primary source found, in any system, reporting test mass before and
after a transform-and-template migration.** uniffi's migration is the only live one and is
incomplete (one of four backends), so no before/after pair exists even in principle.

This remains the charter's **biggest unquantified risk**, exactly as the audit flagged: 49.2%
of today's 71,719 lines is test code, and neither our repo nor the prior art says whether
rules and templates need fewer tests, the same, or more. ⚠ **k4 cannot resolve this and should
not pretend to.** The honest move is to make it the pilot's primary instrumented measurement:
count test LOC per bucket before and after on one target, and publish it — because if we do,
we will be the first.

One weak signal, offered as such: uniffi's migrated Python backend carries 1,742 lines of
pipeline+filters against Kotlin's 1,904 lines of `gen_kotlin` helpers (§1.2) — i.e. **the
non-template per-language code did not shrink**. Templates shed computation; the code that
used to compute it moved rather than vanished. That is consistent with the audit's own §2.2
conclusion and inconsistent with a large test reduction.

### On the vocabulary boundary

**Q12 — Where did systems draw the shared-meta-schema / per-target-vocabulary line, and did
it hold?**

⚠ **This is the survey's sharpest result, and it comes from a near-controlled comparison.**

| shared layer models… | system | most-alien pair reached | held? |
|---|---|---|---|
| **the source only** | GIR | C → **Haskell** (13 yrs, live) | **yes** |
| **the source only** | SWIG | C++ → **Guile** vs **Java** | **yes** (21 targets) |
| **the source only** | protoc | anything | **yes** |
| **a target-side lowering** | wit-bindgen | C → MoonBit (all compiled) | ⚠ **no** — never crossed compiled→interpreted in 5 years; JS and Python **forked** into ComponentizeJS / componentize-py |
| **a target-side model** | uniffi (General IR) | Kotlin / Swift / Python / Ruby | **untested** — all one paradigm family |

**Every system that reached a paradigmatically alien target shares only source-side facts.
The two systems with a shared target-side layer have either failed to cross a paradigm
boundary (wit-bindgen) or never attempted one (uniffi).**

⚠ **This is a real caution for root brief Q3, and it should be surfaced rather than
softened.** Q3 proposes a *shared meta-schema* over which each target authors its construct
repertoire. A meta-schema for **target constructs** is a target-side commitment — the
category that has no successful alien-paradigm precedent in this survey. The charter's
reasoning (ADR-0011 permits shared mechanism, forbids shared target semantics) is sound, and
"meta-schema, not vocabulary" is the right side of that line in principle. But the evidence
says the line is **easy to drift across**, and that the drift is only detected when an alien
target arrives.

*Did the shared core creep, and what pulled on it?* **No primary source found** measuring
creep in a shared meta-schema — but the two observable pressures are: uniffi's General IR
accreting FFI-shaped concepts that suit its four similar targets, and wit-bindgen's ABI
instruction set (34 instructions) encoding a memory model no interpreted language shares.
⚠ **k4's practical answer should be a test, not an argument:** before the pilot, write the
meta-schema's construct set out on paper against the *most* alien planned target (Prolog or
Idris2, not OCaml), and check whether every construct it needs is expressible. Doing this on
paper is within the charter's design-only scope and is the single highest-value paper exercise
available.

**Q13 — How was authored per-target data wired into generation, and what about staleness and
a target that never got its authored layer?**

*Siting:* two choices, both shipped. **Beside the source** — GIR annotations in C comments,
bindgen's in-header `<div rustbindgen opaque>`, uniffi's `uniffi.toml` per crate. **Beside the
target's generator** — haskell-gi `bindings/<Module>/*.overrides`, gtk-rs `Gir.toml` per
crate, SWIG `Lib/<lang>/`. ⚠ The split is principled: **facts about the source platform go
beside the source (Q14); facts about the target's projection go beside the target.**

*Shape:* the best-engineered instance is haskell-gi's — **eleven directives, 90% of uses being
one `set-attr` verb, addressing nodes by path** (§4.2). The most heavyweight is gtk-rs's —
**4,092 lines of typed config schema**, i.e. ~13% of the generator (§4.5). ⚠ Whatever we author
in `.apiw`, its schema is a real component with real cost; budget for it.

*Staleness:* PyGObject's masking hazard (Q1), detected by human review only.

*A target with no authored layer:* ⚠ **the prior art is unanimous and reassuring — the authored
layer must be optional, layered over defaults that already work.** SWIG, bindgen, protoc and
uniffi all generate usable output with zero user overrides; overrides only correct and refine.
Our §4.2 finding (the 1,491-line `.apiw` target model has **zero** emitter readers, and
TypeScript has no `.apiw` at all) is therefore not the blocker it looks like: design the
transform to work with an empty authored layer, and TypeScript stays viable while its
repertoire is written.

**Q14 — What happened to facts that were neither shared mechanism nor target semantics?**

⚠ **GIR answers this squarely, and the answer is: they belong in the source model, and the
forcing mechanism is making the shared model the *only* place a target can read platform facts
from.**

GIR's annotation vocabulary is exactly this category — `(transfer none|full|container|
floating)`, `(nullable)`, `(optional)`, `(array length=)` are neither generator mechanism nor
target semantics; they are **platform truth about the C API**, annotated at the source and
consumed by every binding. The community's stated rule, from Vala's guidance, is *"better to
fix the GObject introspection annotations in the source file so that all bindings can
benefit"*, and PyGObject's escalation ladder puts *"updating the underlying API to be more
bindable"* on the **first** rung, above extending the annotation vocabulary and far above
authoring an override (§4.4).

Applied to §6.3's findings:

| our duplicated fact | category | belongs |
|---|---|---|
| `is_libdispatch_unexported` (5 symbols, byte-identical ×4) | platform truth | the IR, at the **Extraction** tier — this is a fact about a dylib's export table, discoverable mechanically |
| the `/System/Library/Frameworks/{0}.framework/{0}` convention | platform truth | the IR / platform layer |
| `is_generic_type_param`, `is_family_match`, the geometry set | analysis-tier heuristics | the analysis layer, as ADR-0047 rules |
| `KNOWN_UNBINDABLE` | *target-toolchain* truth (what swiftc rejects) | ⚠ **neither** — it is a fact about the **Swift adapter's compiler**, shared by all targets that use a Swift adapter, and duplicated four times today. It belongs in a shared authored layer keyed by declaration identity, not per target. |

⚠ That last row is a finding this survey produces that the audit did not: **E1 is not
per-target data at all.** The table is *byte-identical* in four emitters (§2.1) because the
rejecting compiler is the same compiler. Under SWIG's keying taxonomy it is
declaration-keyed authored data; under GIR's siting rule it belongs beside the *Swift
adapter*, once. k4 should not design E1 as per-target vocabulary.

---

## 10. What evidence would settle the escape-hatch question

The charter forbids code and prototypes, so the escape-hatch risk cannot be tested empirically
here. This section states precisely what *would* settle it, ordered cheapest-first, so the
handoff doc can hand the build grove a decision procedure rather than a worry.

**(1) A paper closure check over the audit's E-list — doable now, within the design-only
scope, and it is the highest-value remaining paper exercise.**

The survey establishes a **closed set of five mechanisms** that between them cover every
escape observed in seven systems:

| M1 | authored declarative data, keyed by a path or declaration identity into the model | uniffi `exclude`, haskell-gi `set-attr`, SWIG `%feature`, bindgen blocklist |
| M2 | a host function invoked from a transform pass, whose result becomes a model field | uniffi `names.rs`, gtk-rs `nameutil`, Djinni `Marshal` |
| M3 | an imperative pass staged between declarative ones | uniffi `MapNode` + `#[map_node(expr)]`, gtk-rs `analysis`, SWIG's 4 stages |
| M4 | a named insertion point / deferred region in the emitted text | protoc `@@protoc_insertion_point` |
| M5 | a data-dependent output file list from the renderer | protoc `CodeGeneratorResponse`, `windows-bindgen` |

**The check:** for each of E1–E7 and each soft escape in §2.3, name which of M1–M5 expresses
it, on paper, against one real framework. **If every site maps into M1–M5, the escape-hatch
risk is retired to "engineering", because all five are shipped mechanisms with known costs.
If any site maps to none of them, that site is the design's genuine open problem and must be
named as such in the handoff doc.** Provisionally, from §2.1: E1/E5/E7 → M1; E2/E3/E4 → M2;
E6 → M5; §2.3's collision resolution → M2 then rules; racket's `provide/contract` → M4.
⚠ **Nothing in the audit currently appears to require a sixth mechanism, and that is the most
reassuring single sentence this survey can offer k4** — but it needs the site-by-site check
before it can be asserted rather than sketched.

**(2) The escape-hatch share, measured on one target, against a pre-registered threshold.**

The prior art gives a benchmark our own estimate does not: **35–45% imperative for
source-generating multi-target binding generators** (§3.2, §4.3). The pilot should therefore
measure, for one target and the full 153-framework corpus, the ratio of hand-written host code
to rules-plus-templates — and the handoff doc should **pre-register the number that means
stop**. A defensible kill criterion, given the evidence: *if the pilot's imperative share
exceeds ~50%, or exceeds the pre-pilot estimate by more than 1.5×, the re-cut is not paying
for itself.* Pre-registering it is what makes the pilot falsifiable rather than a commitment.

**(3) Longitudinal escape-hatch share — a metric that does not exist in the prior art.**

No surveyed system measures whether its escape hatch grew (Q5). Since k2 names a hatch growing
to 50% as *"the failure mode this design must be able to see coming"*, the instrument has to be
ours: emit the ratio as a build artifact, per target, per release. Cheap to add at the start,
impossible to backfill.

**(4) The alien-target expressiveness check for the shared meta-schema.**

Per Q12: write the proposed meta-schema's construct set against the **most** alien planned
target — Prolog or Idris2, not OCaml — and verify every construct it needs is expressible.
This is a paper exercise, within scope, and it targets the one failure mode with a documented
precedent (wit-bindgen's fork, §2.6). Doing it against a near neighbour proves nothing.

**(5) The pipeline-diff tool, built first, as the equivalence instrument.**

Per Q10, per-stage model diffing is the only technique the prior art reports as actually
catching migration bugs, and it is the only one that **works for chez**, which has no golden
mechanism at all. It is also what makes (1)–(4) observable. ⚠ **k4 should treat it as the
pilot's first deliverable, not its tooling afterthought** — and the handoff doc should say
that this is what answers the charter's chez problem.

**What would *not* settle it:** a prototype of the easy 80%. Every system surveyed handles the
mechanical majority; all seven differ only in how they handle the residue. A pilot that
generates plausible output for the common case and defers E1–E7 would produce no evidence
about the only question that matters.

---

## 11. Where the search found silence

Recorded so a future session does not repeat the search, and because in several cases the
absence is itself the finding. Each entry names what was searched.

1. **No automated feedback channel from a downstream compiler back into a generator's model
   exists in any surveyed system.** *(Searched: uniffi repo docs + ADR set + issues;
   gobject-introspection docs; SWIG manual chapters on customization; rust-bindgen book;
   wit-bindgen repo.)* Every "what the toolchain rejects" table is hand-curated. ⚠ The silence
   is load-bearing: our E1 is normal, and automating its re-validation would be novel.

2. **No system automatically detects a *stale* suppression / override entry.** *(Searched: the
   same set, plus PyGObject's devguide.)* PyGObject documents the hazard in prose
   (*"we have to live with the override forever which masks a working version"*) and relies on
   human review. Nobody has a tripwire.

3. **No primary source shows wit-bindgen considered and rejected a template engine.**
   *(Searched: `README.md`, `crates/*/DESIGN.md`, `crates/*/README.md`, `crates/moonbit/docs/adr/`,
   and issue/PR text across the `bytecodealliance` org.)* ⚠ This materially weakens
   wit-bindgen as counter-evidence — it is a system that never asked our question (§2.3).

4. **No longitudinal measurement of escape-hatch share exists anywhere.** *(Searched: all
   seven systems' docs and release notes.)* Nobody tracks whether the hand-written share grows,
   so nobody can report that it did or did not. The metric k2 most wants would have to be ours
   (§10.3).

5. **No system reported a formal equivalence proof for a transform-and-template migration**,
   and none reported golden-output diffing as the instrument that caught regressions.
   *(Searched: uniffi PR #2333 and the pipeline PR series #2688/#2787/#2890/#2919; Xtext's
   Xpand→Xtend migration issues; gtk-rs regeneration practice.)* Per-stage model diffing is the
   only technique on the record as having found real porting bugs (§9 Q10).

6. **No system reports test mass before and after such a migration.** *(Searched: uniffi
   CHANGELOG and PR series; SWIG release notes; gtk-rs.)* ⚠ The charter's biggest unquantified
   risk remains unquantified by the world as well as by us (§9 Q11).

7. **No measurement of typemap usage across real-world SWIG interface files.** *(Searched:
   SWIG docs, issues, and the web.)* The 9–10% figure in §3.5 is over SWIG's own
   examples/test-suite and is a weak proxy; treat it as an order of magnitude, not a rate.

8. **No stated technical reason for Djinni's archival, and no primary source blaming its IDL
   or generator design.** *(Searched: repo, README, issues, Dropbox's 2019 retrospective.)* The
   published post-mortem is about build systems, cross-boundary debugging and staffing — not
   about code generation (§6.4).

9. **No post-mortem of a specific industrial ATL or QVT code-generation deployment at a scale
   comparable to ours**, and **no measurement of the escape-hatch share in any ATL/QVT
   deployment.** *(Searched: the MDE empirical literature via web search, Höppner et al. 2022,
   Hutchinson/Whittle 2011.)* The tradition's empirical base is interview-shaped.

10. **No primary source explaining why QVT-R (declarative, bidirectional) failed to gain
    implementations while QVT-O (imperative) did.** *(Searched: web.)* ⚠ This would be the most
    directly relevant post-mortem in the tradition. A future session should not repeat this
    search with web search alone — it needs the OMG/Eclipse mailing-list archives or the
    Eclipse M2M project history.

11. **No measurement of shared-meta-schema creep in any system.** *(Searched: uniffi pipeline
    PRs, wit-bindgen `abi.rs` history — unavailable in a shallow clone.)* The two pressures are
    observable structurally (§9 Q12) but nobody has quantified them.

---

## 12. Scope note

This document supplies evidence. It **recommends no mechanism**: the transform engine, the
template engine, the projection model's artifact status and the escape hatch are
`plan-mechanism-k4`'s decisions, with a human in the loop.

Per the charter's Q6, this leaf mints **no ADR** and makes **no change to `CONTEXT.md`**. The
document itself is durable and outlives the grove — it is evidence about the world, true
regardless of whether this design is ever built.
