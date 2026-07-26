# prior-art-model-transform-codegen-k3

**Kind:** research

## Goal

Survey how existing multi-language binding generators handle the architecture the root brief
proposes — *source model → per-language instance model → template rendering* — and report
**what went wrong after years of real use**. The audience is `plan-mechanism-k4`, which must
settle the transform engine, the template engine, the projection model's artifact status, and
the escape-hatch design.

**Bias the search toward post-mortems, not surveys.** "What has been tried" produces broad,
shallow coverage. "What broke after five years of production use, and what did the maintainers
say about it" produces the evidence `plan-mechanism-k4` actually needs.

## Context

Beyond the brief chain:

- **`emitter-anatomy-audit-k2`'s "Questions for k3" section is this leaf's primary input.**
  Read it first; it names the escape-hatch cases and stateful-emission sites found in our own
  emitters. Bias every system section toward those specific cases.
- `adr/0047-convention-heuristics-as-datalog-rules.md` — our datalog precedent, and its
  explicit parking of a *runtime-loadable* rule DSL as out of scope. Whether that parking
  should be reversed is a k4 decision this survey must inform.
- `adr/0011-targets-hermetically-isolated.md` — the paradigm-diversity argument. Systems that
  span paradigmatically alien languages are the relevant ones; a generator covering only
  C-family targets is weak evidence for us.

## Systems to cover

Not exhaustive, and not all equally weighted. The starred ones are closest to our shape.

- **★ GObject-Introspection (GIR)** — the closest analogue: a machine-readable model of a C API
  from which many language bindings are generated, ~20 years in production. Its
  transfer-ownership / `(transfer none|full|container)` annotation model is the direct analogue
  of our ownership facet (ADR-0047's producer cascade), so its known pain there is
  high-value evidence.
- **★ uniffi** (Mozilla) — UDL/proc-macro → per-language backends using **Askama templates**
  plus substantial hand-written per-language runtime glue. The template/handwritten boundary is
  exactly our question.
- **★ wit-bindgen** / the WIT IDL — per-language generators written as **imperative Rust**, not
  templates. If the maintainers considered and rejected templates, find the primary source: it
  is direct evidence against our thesis and must be confronted, not omitted.
- **★ SWIG** — decades old, spans very alien targets. Its escape hatch (typemaps and inline
  target-language blocks in the interface file) is the most battle-tested answer to Q-escape.
  What fraction of real SWIG interface files use it, and what did that cost?
- **protoc plugins** — `CodeGeneratorRequest` is literally a serialised model handed to an
  arbitrary program. Why did the design stop at "model + arbitrary plugin" rather than
  supplying a declarative transform?
- **Djinni** (Dropbox) — IDL → C++/Java/ObjC. Now largely unmaintained; if there is a stated
  reason, that is a post-mortem.
- **The MDA / QVT / ATL / Eclipse Xtend-Xpand lineage** — the most thoroughly *declarative*
  model-transformation tradition, and the one with the best-documented industrial retreat.
  Why did fully-declarative model transformation lose to code-first generation? This is the
  cautionary literature for our exact proposal and should be treated seriously, not dismissed.
- Secondary, if time allows: Kotlin/Native `cinterop`, CsWinRT / WinRT projections, Emscripten's
  WebIDL binder, `cbindgen`, PyO3, JNI generator families, Rust `bindgen`.

## Questions each system section must answer

1. **Is there an explicit per-language instance model**, or does the generator go straight from
   the source IDL to text? If a model exists, is it *committed and inspectable*, or in-memory?
2. **If templates: which engine, and did logic leak into them over time?** Find evidence of
   drift — templates growing conditionals, loops, helper calls, or embedded code.
3. **The escape hatch.** What is it, how is it invoked, and how heavily is it used in practice?
   Was it designed in, or retrofitted after the declarative layer hit a wall?
4. **Walk-away check** (per system, required): with the tool uninstalled, is the *generated
   output* legible and maintainable by hand? And separately — is the *intermediate model*
   legible on its own, or only meaningful to the generator?
5. **Post-mortem.** What went wrong after years of real multi-language use? Primary sources
   only: issue links, maintainer comments, design docs, commit messages, conference talks.
6. **Paradigm reach.** How alien are the most-alien two targets it supports, and did the shared
   model constrain them toward a lowest common denominator (our ADR-0011 fear, tested against
   someone else's experience)?

## Done when

- `targets/_shared/docs/research/<YYYY-MM-DD>-model-transform-codegen-prior-art.md` exists,
  with one section per system, each ending in a **takeaway for k4**.
- A closing **Synthesis** section answers `k2`'s "Questions for k3" in one place, and states
  what evidence would settle the **escape-hatch question** — the risk the charter's design-only
  scope cannot test empirically.
- **Every failure-mode claim carries a primary-source citation** (URL to issue, thread, doc, or
  commit) with a short quote. A claim without one is mood, not evidence, and must be dropped or
  labelled as such.
- Where a search found **silence**, that is recorded as a finding ("no primary source found for
  X") — the absence is a confidence signal and stops a future session repeating the search.

## Notes

Do not recommend a mechanism. This leaf supplies evidence; `plan-mechanism-k4` decides with a
human in the loop.

Weight recency and scale: a 2015 blog post about a toy generator is weaker than a 2024 issue
thread on a generator shipping to millions of users. Say which you have.

Mint no ADR and touch `CONTEXT.md` not at all (charter Q6). The research doc itself is durable
and stays after the grove ends — it is evidence about the world, true regardless of whether
this design is ever built.
