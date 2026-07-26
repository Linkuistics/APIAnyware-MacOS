# Alien-target meta-schema check — SWI-Prolog against root-brief Q3

**Status:** research finding (grove `language-model-transforms`, leaf
`alien-target-meta-schema-check-k8`). Consumed by `write-handoff-doc-k5`.
**Date:** 2026-07-27.
**Input:** [`2026-07-26-model-transform-codegen-prior-art.md`](./2026-07-26-model-transform-codegen-prior-art.md)
§9 Q12 sets the check and supplies the precedent (§2.6 wit-bindgen's fork, §3.7 SWIG's reach);
§10.4 names the exercise. [`2026-07-26-emitter-anatomy-audit.md`](./2026-07-26-emitter-anatomy-audit.md)
§4.1 / §5.1 / §6.3 supplies the shipped targets' input and output surfaces and the shared-substrate
measurement §5.3 builds on. Root brief Q3 is the proposition under test; `plan-k1` Q1 supplies the
node-kind enumeration; `plan-mechanism-k4` Q2/Q4/Q5 bound what "expressible" means (authored data
read at generation time; computation-free templates; adapter sources in scope).
**Method:** paper exercise plus read-only static inspection of `targets/_shared/tools/{emit,target-model}`,
the five `emit-*` crates, `schemas/spec-format/idioms.kdl-schema`, and the committed `TestKit`
goldens, on the `language-model-transforms` jj workspace at `zlwqnnlqyokx 81c3e897`. No code, test
or dependency changed; no ADR minted; `CONTEXT.md` untouched (charter Q6).

> **How to read this doc.** The check had to disambiguate "meta-schema" before it could test
> anything — [§1](#1-what-the-meta-schema-is--the-disambiguation-the-check-had-to-make-first)
> does that, and the verdict is different for the two readings. Every claim about this repo names
> the file and line it was read from. Claims about SWI-Prolog, Mercury, Pharo, Idris2 and Zig are
> language-reference facts, not measurements; the two that a build grove should re-verify against
> a live toolchain are flagged ⚠**verify**. The places this check **disagrees** with k1, k3 or k4
> are collected in [§7](#7-where-this-check-disagrees-with-k1-k3-or-k4).
> This document **decides nothing** — the wording that lands is `write-handoff-doc-k5`'s.

---

## Verdict

**Root-brief Q3 holds.** Written out against the most alien planned target, every construct a
SWI-Prolog binding needs is expressible as per-target authored data over a shared meta-schema.
Nothing in the Prolog construct set requires the shared layer to learn a Prolog concept, and
nothing in it is inexpressible as authored data.

**`plan-k1` Q1, as worded, does not hold.** Q1 says the model is "one node per emitted thing
(**compilation unit, callable, parameter, type reference**, …)". Read as a *shared* spine of node
kinds — which is how it reads — three of those four fail against Prolog: there is no compilation
unit in the language's sense, no callable in the params-in/result-out sense, and **no type
reference anywhere in the emitted Prolog source at all**. Q1's enumeration is a description of a
Racket binding promoted to a shared vocabulary, and promoting it is precisely uniffi's General IR
pressure (k3 §9 Q12). The fix is a restatement, not a redesign: those four are *repertoire members
racket authors*, not node kinds `targets/_shared` owns.

The verdict therefore turns on a distinction Q3 does not currently draw, and the check's first
job was to draw it ([§1.1](#11-two-readings-of-meta-schema)):

- **MS-A — the meta-schema is the schema by which a target *declares* its constructs.** Shared
  layer owns the declaration form and the engines; it names no target-language construct. Q3 holds
  under MS-A.
- **MS-B — the meta-schema is a shared spine of node kinds targets populate.** Shared layer owns
  `callable`, `parameter`, `type-ref`. Q3 does not hold under MS-B, and MS-B is what `plan-k1` Q1
  describes and what `targets/_shared` implements today.

Q3 holding under MS-A is **not free**. Five amendments are forced by the Prolog write-out, four of
them by constructs no shipped target has ([§4](#4-expressibility--where-the-gaps-are-precisely)):

1. **The identifier slot must be structured, not a string.** A Prolog predicate's identity is
   `Name/Arity`, and the arity is *computed by the projection*; Pharo's `initWithParent:` splits
   into keyword parts co-indexed with the argument list; Mercury shares one name across several
   mode declarations. Today it is `pub name: String` (`idioms/model.rs:86`).
2. **A construct must be able to carry zero type references, and an argument must be able to carry
   a non-type qualifier.** Prolog source contains no types; the type fans out to three other
   constructs in two languages. Prolog arguments carry a **mode**, predicates a **determinism**,
   Idris2 binders a **multiplicity** — none of which is a type.
3. **A construct's body must be able to be source text in another language, rendered by a nested
   template.** Mercury's `pragma foreign_proc` embeds C *inside* the Mercury source; Pharo's uFFI
   call is a pragma in the method body. k4 Q4's `Vec<(path, content)>` renderer contract has no
   nesting.
4. **Sibling ordering must be declared per construct as semantic or presentational.** Clause order
   within a Prolog predicate is program meaning; method order in a Pharo Tonel file is
   presentation. k4 Q3's per-stage diff treats sibling order uniformly, so the same reordered diff
   is a no-op in one target and a behaviour change in another.
5. **The model is a DAG, not a tree** — one construct may contribute to a unit it does not live in
   (Prolog `:- multifile` clauses). ⚠ This one is **not alien-specific**: gerbil's `generics.ss`
   shards and sbcl's per-framework `generics.lisp` already do it (k2 §5.1). The alien check
   surfaces it; it was always a requirement.

**The drift question (Q4) does not need a forecast — the drift is already measurable in this
repo** ([§5](#5-does-the-meta-schema-drift-target-side--q4)):

- **k2 §6.3 already measured half of it:** *"143 of its 263 production lines are one target's
  semantics inside the shared substrate"* — `RacketFfiTypeMapper` / `RacketFfi2TypeMapper` in
  `targets/_shared/tools/emit/src/ffi_type_mapping.rs:118-262`, emitting `_int64` / `_pointer` /
  `_NSRect`. The `FfiTypeMapper` *trait* above it (lines 18-55) is correct shared mechanism. **What
  this check adds is the other side: the four later targets did not conform, they forked.** Chez,
  Gerbil, SBCL and TypeScript each implement that trait **in their own crate** (233 / 409 / 170 /
  400 production lines) and none imports the shared mappers. Target #1's vocabulary sat in the
  shared home; targets #2–#5 wrote their own. Read against k3 §2.6 that is wit-bindgen's shape in
  miniature, at target count five — k2 classified it as misplaced-domain duplication, which it also
  is, but it is **evidence about the meta-schema's prospects**, not only about tidiness.
- **`EmitConstruct` is a shared *closed* enum of seven target-side construct tokens**
  (`idioms/model.rs:103-120`; `idioms.kdl-schema:127`). `plan-k1` called
  `pattern_dispatch` "the nucleus of the proposed architecture" and Q1 proposes widening
  `EmitConstruct` to "the target language's full construct repertoire". ⚠ **A shared closed enum
  holding five paradigms' full repertoires is the lowest-common-denominator straitjacket ADR-0011
  rejected by name, so the build grove must *invert* the nucleus, not extend it** — the enum has to
  leave `_shared`, and the schema `enum` at `idioms.kdl-schema:127` has to become a per-target
  declared set. Today's nucleus implements the option Q3 rejected.

**The fallback is available and costs exactly one of the five claimed gains**
([§6](#6-the-swig-fallback-costed)). SWIG's source-only shared layer, transposed, is: shared IR
plus shared *mechanism* (pass framework, template engine, file-set assembler, diff tool), with each
target's repertoire as **per-target Rust node types** instead of authored `.apiw`. It is not a
different architecture — it is Q3 with the authoring layer deleted. The one thing it costs is the
contributor-filter gain (a target expert editing data and templates without reading Rust), which is
k3 §2.4c's benefit and the root brief's "a generator a target expert can edit without reading
Rust". Everything else survives.

---

## 1. What "the meta-schema" is — the disambiguation the check had to make first

### 1.1 Two readings of "meta-schema"

Q3's sentence is: *"`targets/_shared` owns the meta-schema (how a construct is declared) and the
engines; each target authors its own construct repertoire."* The parenthetical says **MS-A**. The
rest of the settled design says **MS-B**.

| | **MS-A — declaration meta-schema** | **MS-B — shared node-kind spine** |
|---|---|---|
| What `_shared` owns | the form of a *construct declaration*: a construct has a name, slots, slot types, a containment rule, a template binding | a fixed set of node kinds — `compilation-unit`, `callable`, `parameter`, `type-ref` — with fixed fields |
| What a target authors | its whole repertoire: every construct kind it emits, with its slots | *instances* of the shared kinds, plus per-target extension fields |
| Three levels | meta-schema (shared) → repertoire (target, authored) → projection model (derived) | schema (shared) → projection model (derived) |
| Analogue in the survey | SWIG's `Lib/` + typemap mechanism (k3 §3.7) | uniffi's General IR; wit-bindgen's 34-instruction ABI (k3 §9 Q12) |
| Paradigm reach in the survey | **crossed** | **did not cross** |

MS-A is a *schema language*, and schema languages are paradigm-neutral by construction — this is
why the verdict under MS-A is unsurprising once the reading is pinned. MS-B is a *lowering*, and a
lowering encodes the paradigm of whatever it was first written against.

### 1.2 Which reading the design describes today

Three artifacts read MS-B, one reads MS-A:

- **MS-B** — `plan-k1` Q1: "One node per emitted thing (compilation unit, callable, parameter,
  type reference, …), per target×platform." The parenthetical is a shared enumeration; nothing
  says a target may decline `type reference`.
- **MS-B** — `EmitConstruct` (`targets/_shared/tools/target-model/src/idioms/model.rs:103`): a
  closed seven-variant enum of *target-side* constructs, in `targets/_shared`, mirrored as a schema
  `enum` at `schemas/spec-format/idioms.kdl-schema:127`. Its own doc comment says "the closed
  taxonomy of idiomatic constructs the per-language emitters render".
- **MS-B** — `RacketFfiTypeMapper` (`targets/_shared/tools/emit/src/ffi_type_mapping.rs:121`):
  a target's type spellings in the shared crate. See [§5.3](#53-the-measurement).
- **MS-A** — Q3's own parenthetical, and the precedent Q3 cites: one shared `target-model` crate
  *parsing* per-target authored `.apiw`, which is a declaration mechanism, not a vocabulary.

⚠ **The design is currently on both sides of the line it draws.** That is not a contradiction to
resolve by argument; it is the drift k3 §9 Q12 predicted, caught before a pilot, which is exactly
what this check was commissioned to do.

### 1.3 The seven structural assumptions the current shape embeds

These are the propositions the alien target is tested against. Each is traceable.

| # | Assumption | Where it comes from |
|---|---|---|
| **S1** | An emitted thing has exactly **one** identifier, a single string | `Projection.name: String` (`idioms/model.rs:86`); `idioms.kdl-schema:132`; every golden identifier (`tkview-set-title!`) |
| **S2** | Emitted things group into **compilation units that are files at paths** | `plan-k1` Q1; k4 Q4's `Vec<(path, content)>`; k2 §5.1's per-target file sets |
| **S3** | A callable has an **ordered parameter list and one return type** | k2 §4.1: `Method.{params, return_type}` read by all five emitters |
| **S4** | There is a **`type reference`** node kind | `plan-k1` Q1; the `FfiTypeMapper` trait's `map_type` (`ffi_type_mapping.rs:22`) |
| **S5** | The model is a **containment tree with a total sibling order** | k4 Q3 (golden stability); k3 §9 Q8 (datalog yields sets where `ordered_classes` needs a total order) |
| **S6** | Dispatch is **receiver + selector**, and the class is the container | every golden; `Class.methods` / `Method.selector` (k2 §4.1) |
| **S7** | The repertoire is **finite, enumerable and authored ahead of generation** | Q3 ("authored `.apiw` data read at generation time"); k4 Q2 |

---

## 2. Which target is most alien, and why

### 2.1 The scoring

Five candidates (the leaf's list: ADR-0011's Haskell, Idris2, Prolog/Mercury, plus Pharo and Zig
from `README.md:24` and `website/index.md:27`) against §1.3's seven assumptions. ✓ holds,
~ strained, ✗ breaks, ✗✗ breaks deeply (no site in the target at all).

| | S1 identifier | S2 unit=file | S3 params/return | S4 type-ref | S5 tree+order | S6 dispatch | S7 finite repertoire | net |
|---|---|---|---|---|---|---|---|---|
| **Zig** | ✓ | ✓ | ✓ | ✓ | ✓ | ~ | ✓ | ~0 |
| **Haskell** | ~ | ✓ | ~ | ✓ | ✓ | ✗ | ✓ | ~1 |
| **Idris2** | ~ | ✓ | ~ | ✗ *(types are terms)* | ✓ | ✗ | ✓ | ~2 |
| **Pharo** | ✗✗ *(keyword selector)* | ~ *(image; Tonel rescues)* | ✓ | ✗ *(untyped)* | ~ | ✓✓ | ~ | ~3 |
| **SWI-Prolog** | ✗ *(Name/Arity)* | ✓ | ✗✗ *(modes, no return)* | ✗✗ *(no site)* | ~ *(clause order is semantics)* | ✗✗ | ~ *(directive family)* | **~5** |

**The pick is SWI-Prolog**, with **Mercury as the control** ([§3.4](#34-mercury-the-control)).

### 2.2 Why Prolog over Pharo

Pharo is the strongest rival and the argument against it is worth stating, because the intuitive
answer ("Smalltalk looks nothing like Racket") is the wrong axis.

**Pharo breaks the *spelling* of constructs; Prolog breaks their *shape*.** Pharo's keyword
selector is a hard break — `copyFrom:to:` is one selector whose parts interleave with the argument
list, so S1's single string is genuinely insufficient and the parts must be co-indexed with
parameters — but it is *local*: one slot type changes and everything else stands. Prolog dissolves
three assumptions at once, and each dissolution removes a *site* rather than changing a shape.

And decisively: **Pharo's object model is closer to ObjC's than any target this repo ships.**
Objective-C is Smalltalk's object model on C — message send, receiver, selector, class-side and
instance-side methods, categories. S6 is not merely satisfied by Pharo, it is satisfied *better*
than by Racket, where `tkview-set-title!` has flattened a message send into a procedure call
(`tkview.rkt`). Testing the meta-schema against Pharo tests its syntax handling. It does not test
whether the shared layer has encoded a paradigm, because Pharo shares our source paradigm.

Pharo's one deep contribution — the co-indexed identifier — is carried into amendment A1
([§4.1](#41-a1--the-identifier-must-be-structured)) rather than discarded.

### 2.3 Why Prolog over Idris2

k3 §10.4 offered "Prolog or Idris2". Idris2 stresses S4 hard: with dependent types a type
reference can be an application of a type constructor to a *term* (`Vect n a`), so `type-ref` stops
being a name-plus-arguments tree and becomes an expression; QTT adds a multiplicity
(`0 |`, `1 |`, unrestricted) to every binder; `%foreign "C:…"` attaches a string specifier to a
declaration; totality (`total` / `covering` / `partial`) is a per-declaration annotation. The
website's plan for the target is literally "Dependently-typed wrappers", so this is not a
hypothetical surface.

But **absence stresses a schema harder than richness.** A schema can always carry *more* — an
opaque expression slot absorbs `Vect n a`, and an extra enum slot absorbs multiplicity and
totality; both are additive and neither questions whether the node kind belongs. A schema that
*requires* a slot for which the target has no rendering site forces a choice between a null and a
lie, and forces the transform to decide where information the target cannot express should go
instead. Prolog does that to S3, S4 and S6 simultaneously.

Idris2's contributions — a non-type qualifier on a parameter (multiplicity) and a non-type
annotation on a declaration (totality) — join Prolog's mode and determinism in amendment A2
([§4.2](#42-a2--zero-type-refs-and-non-type-qualifiers)), which is stronger evidence for A2 than
either target alone.

### 2.4 Why Zig and Haskell are not candidates

**Zig** breaks nothing structural. `extern fn`, `*anyopaque`, `@import` namespaces, struct methods
— every one of S1–S7 holds. Zig's difficulty is *manual memory and error unions*, which is a
representability-ladder question (ADR-0051's capability profile,
`CONTEXT.md` §"Representability ladder") and a type-mapping question, not a construct-vocabulary
question. Zig would pass this check trivially and prove nothing, which is k3 §10.4's "doing it
against a near neighbour proves nothing" in a different disguise.

**Haskell** breaks S6 only. A typeclass method declaration is still a name plus a signature; a
module is still a file with an export list; `foreign import ccall` is still a declaration with a
type. Monadic sequencing and instance heads are template concerns under k4 Q4's
computation-free/branching-allowed contract, not schema concerns. Haskell is where the *type*
mapping gets interesting and where the schema gets easy.

### 2.5 The pick, stated as a test

The check is sharper for having a control. Prolog and Mercury are the **same paradigm** — Horn
clauses, modes, determinism, backtracking — and take **opposite positions on types**: Prolog has
none, Mercury has a full declaration set (`:- type`, `:- pred`, `:- mode`, `:- inst`,
`:- typeclass`). If the meta-schema fits Mercury and not Prolog, the break is about type
*absence*, not about logic programming — and the finding transfers to every dynamically typed
target we might add, not just to Prolog.

---

## 3. The construct set — SWI-Prolog

### 3.1 A worked unit

The Prolog counterpart of `targets/racket/tools/emit-racket/tests/golden/tkview.rkt`, written
against the same `TestKit` fixture. This is the artifact the check operates on; the projection
decisions in it are argued in [§3.3](#33-four-source-concepts-with-no-prolog-construct).

```prolog
%   Generated binding for TKView (TestKit) — do not edit; regenerate from the resolved IR.

:- module(testkit_tkview,
          [ tkview/1,                     % ?Term                     (semidet)
            tkview_new/1,                 % -View                     (det)
            tkview_init_with_parent/3,    % +View, +Parent, -View2     (semidet)
            tkview_title/2,               % +View, -Title              (semidet)
            tkview_set_title/2,           % +View, +Title              (det)
            tkview_hidden/1,              % +View                      (semidet)
            tkview_set_hidden/2,          % +View, +Bool               (det)
            tkview_frame/2,               % +View, -Rect               (det)
            tkview_add_subview/2,         % +View, +Subview            (det)
            tkview_superview/2,           % +View, -Superview          (semidet)
            tkview_subview/2,             % +View, -Subview            (nondet)
            tkview_refresh/1,             % +View                      (det)
            with_tkview/2                 % +Spec, :Goal               (nondet)
          ]).

:- use_module(library(apianyware/objc)).
:- use_module(library(apianyware/testkit/tkobject), []).   % load-only: inheritance, no imports
:- use_foreign_library(foreign(apianyware_prolog)).

:- objc_class('TKView', tkview, [ superclass(tkobject), conforms(['TKRefreshing']) ]).

:- meta_predicate with_tkview(+, 0).
:- multifile objc_protocol_method/4.

%!  tkview(@Term) is semidet.
%
%   True when Term is a live TKView handle.
tkview(T) :- objc_instance_of(T, 'TKView').

%!  tkview_new(-View:tkview) is det.
tkview_new(View) :-
    objc_alloc('TKView', Raw),
    objc_send(Raw, init, [], Init),
    objc_own(Init, View).

%!  tkview_title(+View:tkview, -Title:nsstring) is semidet.
%
%   Property `title` (readwrite, copy). Fails when the property is nil.
tkview_title(View, Title) :-
    must_be(tkview, View),
    objc_send(View, title, [], Raw),
    objc_wrap_retained(Raw, Title).

%!  tkview_set_title(+View:tkview, +Title:nsstring) is det.
tkview_set_title(View, Title) :-
    must_be(tkview, View),
    objc_send(View, 'setTitle:', [Title], _).

%!  tkview_hidden(+View:tkview) is semidet.
%
%   Property `hidden` (readwrite, BOOL) projected as a *test*, not a getter.
tkview_hidden(View) :-
    must_be(tkview, View),
    objc_send(View, hidden, [], true).

%!  tkview_frame(+View:tkview, -Frame:ns_rect) is det.
%
%   Struct return: crosses as a compound term, not a handle.
tkview_frame(View, ns_rect(ns_point(X,Y), ns_size(W,H))) :-
    must_be(tkview, View),
    objc_send_struct(View, frame, [], ns_rect, [X,Y,W,H]).

%!  tkview_subview(+View:tkview, -Subview:tkview) is nondet.
%
%   Enumeration: `subviews` + `count` projected as a generator, on backtracking.
tkview_subview(View, Subview) :-
    must_be(tkview, View),
    objc_send(View, subviews, [], Array),
    objc_array_member(Array, Subview).

%!  with_tkview(+Spec, :Goal) is nondet.
%
%   `bracketed-use`: acquire, call, release even on a non-local exit.
with_tkview(Spec, Goal) :-
    setup_call_cleanup(tkview_new_from(Spec, V), call(Goal, V), tkview_release(V)).

objc_protocol_method('TKRefreshing', required, refresh, 0).
```

Two supporting units, because they are different construct kinds and not variants of the above:

```prolog
%   enums.pl — an "enum" is a predicate whose clauses are the values.
%!  tk_alignment(?Name:atom, ?Value:integer) is nondet.
tk_alignment(left,   0).
tk_alignment(center, 1).
tk_alignment(right,  2).

%   constants.pl — a "constant" is a unit fact, populated at load.
:- initialization(load_testkit_constants, now).
%!  tk_default_timeout(-Seconds:float) is det.
tk_default_timeout(30.0).
```

### 3.2 The construct table

The leaf asks for the constructs "today's five targets carry as classes, methods, properties,
protocols, enums, constants, functions, structs, trampolines, and the adapter-side entries",
written out for the alien target and marked expressible or not. **MS-A** and **MS-B** are §1.1's
two readings.

| # | Construct | Projects the source concept | MS-A | MS-B | Note |
|---|---|---|---|---|---|
| PC1 | banner comment | provenance | ✓ | ✓ | |
| PC2 | `:- module(Name, Exports)`, `Exports` a list of `Name/Arity` terms | framework + class → module | ✓ | ⚠ | the export list is identifiers **with arity**, not names — S1 |
| PC3 | `:- use_module/2`, with import list or `[]` for load-only | cross-class reference; inheritance | ✓ | ✓ | |
| PC4 | `:- use_foreign_library(foreign(…))` | adapter linkage | ✓ | ✓ | |
| PC5 | `:- op(Priority, Type, Name)` | none — a pure idiom choice | ✓ | ✗ | no node kind; and it changes how *client* units parse |
| PC6 | `:- meta_predicate Head` | `bracketed-use`, `callback` | ✓ | ✗ | a declaration *about* another construct |
| PC7 | `:- multifile` / `:- discontiguous` / `:- dynamic` / `:- table` | protocol tables, registries | ✓ | ✗ | a family of directives, none a callable |
| PC8 | `:- initialization(G, now)` | framework load | ✓ | ✓ | |
| PC9 | `:- objc_class(ObjCName, Functor, Attrs)` | class | ✓ | ~ | a registration directive, not a callable |
| PC10 | **predicate**, identity `Name/Arity` | method, property, function | ⚠ **A1** | ✗ | identity is a *pair*, and the arity is computed by the projection |
| PC11 | **clause** (ordered; order is program meaning) | method body | ⚠ **A4** | ✓ | |
| PC12 | head argument with a **mode** (`+ - ? @ !`) | param, return, out-param | ⚠ **A2** | ✗ | a mode is not a type and not a direction on a type |
| PC13 | **determinism** (`det` `semidet` `nondet` `multi` `failure` `erroneous`) | nullability, `error-out`, enumeration | ⚠ **A2** | ✗ | no slot exists; derived, not sourced |
| PC14 | PlDoc structured comment `%! Head is Det.` | doc comment **+ type + mode** | ✓ | ⚠ | the **only** site in the Prolog source where a type is written |
| PC15 | several modes for one predicate (Mercury `:- mode`) | one method, several call shapes | ⚠ **A1** | ✗ | one identifier, N signatures |
| PC16 | `must_be(Type, Arg)` runtime guard | parameter type | ✓ | ⚠ | the type appears as a **call**, not a type reference |
| PC17 | nondet generator predicate | `enumeration` (`iteration-adapter`) | ✓ | ✓ | the idiom exists; its Prolog shape is determinism, not a wrapper |
| PC18 | `setup_call_cleanup/3` wrapper + PC6 | `bracketed-use` (`scoped-resource`, `scoped-guard`) | ✓ | ⚠ | one idiom, **two** emitted constructs in different places in the unit |
| PC19 | `throw(error(Formal, Context))` ISO error term | `error-side-channel` (`result-wrapper`) | ✓ | ✓ | |
| PC20 | fact table — N clauses of one predicate | **enum** | ✓ | ⚠ | there is no enum construct; an enum *is* a predicate |
| PC21 | unit fact, or a fact populated at `initialization` | **constant** | ✓ | ✓ | |
| PC22 | compound-term convention + accessor predicates | **struct** (`foreign-struct`) | ✓ | ✓ | `ns_rect(ns_point(X,Y), ns_size(W,H))` |
| PC23 | clause contributed to a `multifile` predicate **declared in another unit** | **protocol** conformance | ⚠ **A5** | ✗ | breaks containment — but see [§4.5](#45-a5--the-model-is-a-dag-and-always-was) |
| PC24 | protocol conformance fact table | **protocol** | ✓ | ⚠ | no protocol construct; a fact table stands in |
| PC25 | facade module using `:- reexport/2` | framework facade (`main.rkt`) | ✓ | ✓ | |
| PC26 | `install_<lib>()` C entry point | adapter bootstrap | ✓ | ✓ | adapter side |
| PC27 | `PL_register_foreign(…)` per exported foreign predicate | dispatch table | ✓ | ✓ | adapter side; the counterpart of `define-aw-msg` |
| PC28 | `foreign_t f(term_t …)` C wrapper | **trampoline** | ⚠ **A3** | ✓ | adapter side, separate file — expressible today |
| PC29 | `PL_register_blob_type(&objc_blob)` descriptor | object handle | ✓ | ✓ | adapter side |
| PC30 | Swift adapter trampoline | trampoline | ✓ | ✓ | unchanged from today (k4 Q5) |
| PC31 | *(Mercury)* `:- pragma foreign_proc("C", Head, Attrs, "…C…")` | every direct method | ⚠ **A3** | ✗ | **C embedded inside the Mercury source file** |
| PC32 | *(Mercury)* `:- type` / `:- inst` / `:- mode` / `:- pred` | types | ✓ | ✓ | the control: types come back and everything fits |
| PC33 | *(Mercury)* `:- typeclass` / `:- instance` | protocol | ✓ | ✓ | |

**Totals.** 33 constructs. Under **MS-A**: 28 expressible as authored data with no amendment,
5 requiring one of A1–A5 — **0 inexpressible**. Under **MS-B**: 11 have no shared node kind at all
and 6 more are strained.

⚠**verify** — two claims a build grove should confirm against a live toolchain rather than take
from this document: (i) whether SWI-Prolog's core FFI (`PL_register_foreign` + a compiled foreign
library, PC26–PC29) is the route taken or whether a dlopen-style dynamic FFI pack is used instead;
(ii) the exact `pragma foreign_proc` attribute set Mercury requires for these calls
(`will_not_call_mercury`, `promise_pure`, `thread_safe` and their interaction with the main-thread
bounce of ADR-0014). Neither affects the check: on either FFI route the Prolog source carries no
type, which is the finding.

### 3.3 Four source concepts with no Prolog construct

These are the projections the table's ✗ marks come from. Each is a source fact that must land
*somewhere*, and in Prolog it lands somewhere structurally different.

**(a) The static type has no site in the emitted Prolog.** ISO and SWI Prolog have no type
declarations. The whole output of the `FfiTypeMapper` layer — 1,070 shared lines plus 350–849 per
target (k2 §6.1) — fans out into **three different constructs in two languages**: the PlDoc
annotation (PC14), the `must_be/2` call (PC16), and the C shim's `term_t` marshalling (PC28). One
source fact, three destinations, none of them a type reference.

**(b) The return value becomes an argument, and its position is a projection decision.**
`-[TKView superview]` becomes `tkview_superview(+View, -Superview)`. Where the output argument
goes — last by convention, but not for `objc_send_struct/5` — is a per-target decision that must be
resolved before rendering, exactly as `plan-k1` Q1 requires.

**(c) Nullability becomes determinism, not an optional type.** `tkview_title/2` is `semidet`: it
*fails* when the property is nil rather than binding a null. Compare the Racket golden, where the
same fact is a contract `(or/c nsstring? objc-nil?)`. **Nullability is a type in Racket and a
control-flow property in Prolog** — the same source fact projecting into two categorically
different slots. No shared `type-ref` node can hold both.

**(d) Dispatch becomes a naming convention plus a first argument.** There is no receiver. And the
BOOL property shows the sharpest consequence: `hidden` projects to `tkview_hidden/1`, a
**semidet test**, not `tkview_hidden/2`, a getter. **The projection decision changes the
identifier's arity, and the arity is half the identifier** — which is A1 stated as a consequence
rather than as a requirement.

A fifth, smaller: **inheritance has no construct.** Prolog has no subtyping. `TKView`'s inherited
`TKObject` surface must be either re-exported (`:- reexport(tkobject, [...])`, duplicating every
ancestor predicate into every descendant module) or resolved dynamically through a
`objc_subclass/2` fact table. That is a genuine projection-policy choice
(`CONTEXT.md` §"Projection policy"), not a schema gap — but it is invisible in every shipped
target, all five of which have inheritance in the language.

### 3.4 Mercury, the control

Mercury is the same paradigm with types restored, and the result is clean: **PC32 and PC33 bring
back `type-ref`, and S4 stops failing.** Modes and determinism stay first-class (they are *more*
prominent in Mercury — `:- pred` and `:- mode` are separate declarations), so A1 and A2 survive.
So does A4 — Mercury clause order still matters.

The control therefore isolates the finding: **S4's failure is about type absence, not about logic
programming.** That generalises the amendment beyond Prolog to any dynamically typed target — the
next one on the list being Pharo, where the same three-way fan-out happens (PC14's analogue is a
class comment, PC16's is a Pharo `assert:`, PC28's is the uFFI pragma's type spec).

Mercury also produces the check's one construct that fails on the *renderer* rather than the
schema: **PC31 embeds C inside the Mercury source.** Not in a sibling file, as every shipped target
does with its Swift adapter — inside the same file, inside the declaration. That is A3.

---

## 4. Expressibility — where the gaps are, precisely

The leaf asks that where a construct is not expressible, the check say *"precisely what is missing
and whether the gap is in the meta-schema, in the `EmitConstruct` taxonomy's widening, or in the
`.apiw`/KDL-Schema authoring form."* Each amendment below carries that attribution.

### 4.1 A1 — the identifier must be structured

**Missing:** the identifier slot is a single string.
`targets/_shared/tools/target-model/src/idioms/model.rs:86` is `pub name: String`;
`schemas/spec-format/idioms.kdl-schema:132-140` is a `node "name"` with one string value.

**What needs it:** a Prolog predicate is `Name/Arity` and the arity is computed by the projection
(PC10, §3.3(d)); Mercury shares one name across several `:- mode` declarations (PC15); Pharo's
`initWithParent:` splits into keyword parts **co-indexed with the argument list**, and under k4
Q4's computation-free template contract that zip must be precomputed in the transform, not in the
template.

**Where the gap is:** all three. The **meta-schema** needs an identifier slot type that is a
structure rather than a scalar; the **authoring form** needs to express it in KDL; and the
`EmitConstruct` **widening** inherits the problem because its `name` is the same scalar.

**Not a gap:** the authored value being a *rule* rather than a literal. The repertoire authors how
a name is formed; the instance-level model carries the resolved literal (`plan-k1` Q1). That split
already works — it is M1 (authored data) feeding M2 (a host function) in the closure check's
repertoire, and racket's `selector_to_kebab_name` (`naming.rs:76`) is the shipped instance.

### 4.2 A2 — zero type refs, and non-type qualifiers

**Missing:** two things. A construct cannot carry *zero* type references if `type-ref` is a shared
node kind a callable must populate. And there is no slot for a per-argument or per-declaration
qualifier that is not a type.

**What needs it:** Prolog arguments carry a **mode** (PC12) and predicates a **determinism**
(PC13); Idris2 binders carry a **multiplicity** and declarations a **totality**; none is a type,
none is derivable from one, and determinism is *derived by the transform* from nullability plus
`error-out` rather than read from the IR — k2 §4.1's field list has no failure-mode field.

**Where the gap is:** the **meta-schema**, squarely. This is the amendment that decides the MS-A /
MS-B question: under MS-A a target declares an `argument` construct with whatever slots it needs
and the question does not arise; under MS-B `parameter` and `type-ref` are shared and every alien
qualifier is an extension field on a shared node — **which is uniffi's General IR accreting
concepts that suit its four similar targets, restated in our vocabulary** (k3 §9 Q12).

### 4.3 A3 — a construct body may be another language

**Missing:** nested rendering. k4 Q4 settled the renderer's output contract as
`Vec<(path, content)>` — one template produces one file's text.

**What needs it:** Mercury's `pragma foreign_proc` embeds generated C **inside** a generated
Mercury declaration (PC31); Pharo's uFFI call is a typed C signature inside a method-body pragma.
Both are one construct whose slot value is itself rendered output, in a different language, with a
different template.

**Where the gap is:** the **meta-schema** needs a slot type meaning "rendered fragment", and the
**renderer** needs to resolve it. Askama supports includes, so the engine choice is unaffected —
but the *contract* is: a construct's slot may be the output of rendering a nested construct, so
rendering is a fold over the model rather than one pass per file.

⚠ **This amends k4 Q4**, which stated the renderer's output contract as flat. It does not
contradict the engine decision.

### 4.4 A4 — ordering is semantic or presentational, and must say which

**Missing:** a per-construct declaration of what sibling order *means*.

**What needs it:** clause order within a Prolog predicate is program meaning — first-solution
semantics and cut both depend on it (PC11). Method order in a Pharo Tonel file is presentation
only; methods are a set. Racket's `provide/contract` entries are presentation. Today's design
treats order uniformly, for one reason: golden stability (k4 Q3; k3 §9 Q8's note that datalog
yields sets where `ordered_classes` needs a total order).

**Where the gap is:** the **meta-schema**, and consequentially the **diff instrument**. k4 Q3 made
per-stage model diffing the pilot's first deliverable and the equivalence proof. A diff that
reports "these siblings were reordered" is a cosmetic finding for racket and a **behaviour change**
for Prolog. The instrument must be able to say which, and it can only do so if the repertoire
declares it.

### 4.5 A5 — the model is a DAG, and always was

**Missing:** a construct may contribute to a unit it does not live in.

**What needs it:** Prolog's `:- multifile` clause contributions (PC23) — a method in
`testkit_tkview.pl` contributing a clause to `objc_protocol_method/4` declared elsewhere.

⚠ **But this is not an alien-target finding.** Gerbil's global `generics.ss` plus its
`generics/NNN.ss` shards, and sbcl's per-framework `generics.lisp`, are both exactly this shape and
both shipped (k2 §5.1). The alien write-out *surfaced* the requirement; the requirement was always
there and the shipped targets already violate a pure containment tree. Recorded here so the build
grove does not design a tree and discover the DAG at gerbil.

### 4.6 What did *not* break

Stated because a check that only reports failures is not a check.

- **S2 (unit = file) held**, including for Pharo. Prolog modules are files; Pharo's Tonel format
  writes one `.st` per class in a package directory, so k4 Q4's `Vec<(path, content)>` has a
  target. ⚠ Pharo's *loading* is Metacello into an image rather than compilation, but that is a
  bundler concern (`bundle-*`, the root brief's horizon item), not a renderer concern.
- **S5's total-order requirement held** — strengthened, not broken. Prolog needs order to be
  *more* significant, never less.
- **S7 held.** Prolog's directive family (PC5–PC9) is larger than any shipped target's but it is
  finite and enumerable, which is all S7 claims.
- **Every §21 idiom category that projects an `EmitConstruct` has a Prolog realisation.**
  `bracketed-use` → `setup_call_cleanup/3` (PC18); `error-side-channel` → an ISO error term
  (PC19); `enumeration` → a nondet generator (PC17); `factory-cluster` → a family of
  `*_new_*` predicates. The seven-token taxonomy is not *wrong* for Prolog — it is *far too small*,
  which is a different problem and is §5's.
- **k4 Q2's engine choice is untouched.** Nothing here argues for or against typed Rust passes with
  `ascent` admitted narrowly; the amendments are about what the *nodes* can say, not about what
  computes them.

---

## 5. Does the meta-schema drift target-side? — Q4

k3 §9 Q12 names the two observable pressures elsewhere (uniffi's General IR accreting FFI-shaped
concepts that suit its four similar targets; wit-bindgen's 34-instruction ABI encoding a memory
model no interpreted language shares) and notes **no primary source found** measuring creep in a
shared meta-schema. This repo can supply one.

### 5.1 The deletion test

A checkable rule, in the shape of k3 §9 Q14's forcing mechanism for the source side:

> **A `targets/_shared` artifact is legitimate if deleting any single target from the repo would
> not shrink it.**

A token that would disappear with one target is that target's, and belongs in its repertoire. The
rule is mechanical enough to be a build-time lint, which makes it the target-side counterpart of
k3 §10.3's longitudinal escape-hatch metric: cheap to add at the start, impossible to backfill.

### 5.2 Four pressures, three already present

| pressure | artifact | deletion test | severity |
|---|---|---|---|
| **P1 — a shared closed construct taxonomy** | `EmitConstruct`, 7 variants (`idioms/model.rs:103-120`), mirrored as a schema `enum` (`idioms.kdl-schema:127`) | **fails** — delete every Lisp-family target and the seven tokens go | **hard.** A target needing an eighth construct must edit `_shared` *and* the KDL schema |
| **P2 — one target's vocabulary in the shared home** | `RacketFfiTypeMapper` / `RacketFfi2TypeMapper` / `racket_ffi_type_for_primitive` (`ffi_type_mapping.rs:118-262`) | **fails** — delete racket and ~145 of 263 production lines go (k2 §6.3 counts 143 by a tighter span) | **observed drift**, see §5.3 |
| **P3 — a shared catalogue of target-side conventions** | `camel_to_kebab` (`naming.rs:58`), `camel_to_snake` (`naming.rs:122`) and their selector variants | **fails weakly** — each convention belongs to a family, not one target | **mild.** It *offers* answers rather than forcing one; a third convention still means editing `_shared` |
| **P4 — a shared spine of node kinds** | `plan-k1` Q1's "compilation unit, callable, parameter, type reference" | **fails** — the list is a Racket binding's anatomy | **hard, and prospective.** This is the uniffi General IR shape, not yet built |

The counter-case matters too: `split_camel_case` (`naming.rs:10`) and `is_mutating_selector`
(`naming.rs:97`) **pass** — they parse ObjC selectors, which is source truth, and would survive
deleting every target. So does the `FfiTypeMapper` trait itself (`ffi_type_mapping.rs:18-55`): its
five methods ask questions about the *IR* (`is_object_type`, `is_block_type`, `is_void`,
`is_struct_type`) and only `map_type` returns a target string, which is the target's to implement.
**The shared substrate's mechanism layer is correctly drawn; its data layer is not.**

### 5.3 The measurement

**k2 already measured the first half of this and this check adds the second.** k2 §6.3 reports:
*"`_shared/emit/ffi_type_mapping.rs` holds `RacketFfiTypeMapper` and `RacketFfi2TypeMapper` — **143
of its 263 production lines are one target's semantics inside the shared substrate**"*, listed as
one bullet among misplaced-domain duplication. k4 Q6 repeats it. Confirmed by inspection: the file
is 1,071 lines, tests begin at 264, and lines **118–262** are `racket_ffi_type_for_primitive`,
`RacketFfiTypeMapper`, `ffi_unsafe_to_ffi2` and `RacketFfi2TypeMapper`, emitting `_bool`, `_int8`,
`_int64`, `_pointer`, `_NSRect`, `ptr_t`. Lines 1–116 — the `FfiTypeMapper` trait and the IR-shape
helpers (`normalize_primitive_name`, `is_known_geometry_struct`, `map_geometry_struct_alias`,
`is_generic_type_param`) — are correct shared mechanism and pass the deletion test.

**What this check adds is the other side of it: the four later targets did not conform, they
forked.** Every one of them implements the shared `FfiTypeMapper` trait **in its own crate**:

| target | `FfiTypeMapper` impl | file lines (incl. tests) | production |
|---|---|---:|---:|
| racket | `targets/_shared/tools/emit/src/ffi_type_mapping.rs:151` | *in `_shared`* | 143 of 263 (k2 §6.3) |
| chez | `targets/chez/tools/emit-chez/src/ffi_type_mapping.rs:106` | 350 | 233 |
| gerbil | `targets/gerbil/tools/emit-gerbil/src/ffi_type_mapping.rs:324` | 665 | 409 |
| sbcl | `targets/sbcl/tools/emit-sbcl/src/ffi_type_mapping.rs:33` | 418 | 170 |
| typescript | `targets/typescript/tools/emit-typescript/src/ffi_type_mapping.rs:94` | 849 | 400 |

**No target other than racket imports `RacketFfiTypeMapper` or `RacketFfi2TypeMapper`.** Outside
`emit-racket` there is exactly one consumer, and it is per-target too:
`run_racket_native_dispatch` at `targets/_shared/tools/generate-cli/src/generate.rs:294-309` — a
racket-named global pass living in the shared CLI, which is the same shape one layer up.

⚠ **Read against k3, that is wit-bindgen's §2.6 shape, in this repo, at target count five and
without a paradigm boundary in sight.** The shared layer encoded target #1's vocabulary; targets
#2–#5 each authored their own rather than conform — and unlike ComponentizeJS they could not leave,
so the shared file still carries racket's, privileging it structurally. k2 classified this as
misplaced-domain duplication, which it also is; the point k3 makes available is that **it is
evidence about the meta-schema's prospects, not only about tidiness.** If four *Lisp-family and
TypeScript* targets declined to share a **type** vocabulary, the prior odds that Haskell, Idris2,
Prolog, Pharo and Zig will share a **construct** vocabulary are worse, not better.

### 5.4 `EmitConstruct` — the nucleus implements the option Q3 rejected

`plan-k1`'s survey called `pattern_dispatch` "the nucleus of the proposed architecture", on good
grounds: it already reads authored `.apiw` data at generation time and renders from it, exactly the
mechanism k4 Q2 settled on. But the *vocabulary* it renders is a **closed seven-variant enum owned
by `targets/_shared`**, with a schema `enum` to match, and its own doc comment describes it as "the
closed taxonomy of idiomatic constructs the per-language emitters render".

Q3 rejected "one shared closed vocabulary" by name, on the grounds that it "directly contradicts
ADR-0011's chosen option and its paradigm-diversity rationale". `plan-k1` Q1 then proposes widening
`EmitConstruct` "from its 8 emit-relevant pattern kinds to the target language's full construct
repertoire". Those two moves are in opposite directions: **the widening either moves the taxonomy
out of `_shared` or it makes `_shared` own five paradigms' full repertoires.**

§3.2's table sizes the gap. Prolog alone needs constructs for which no token exists and no token
plausibly could: `operator-declaration`, `mode-declaration`, `determinism-annotation`,
`multifile-contribution`, `meta-predicate-declaration`, `fact-table`, `blob-registration`,
`foreign-predicate-registration`. These are not idiom *projections* — they are the structural
furniture of the language, the Prolog counterparts of `#lang racket/base`, `require`, `provide` and
`define-aw-msg`, none of which has an `EmitConstruct` token either because none of them is a
pattern-kind projection. **The widening changes the artifact's category, from "seven idiom
projections" to "everything the target emits", and at that category a shared closed enum cannot
survive.**

So the prescription for the build grove is **invert the nucleus, not extend it**: the taxonomy
leaves `targets/_shared`, the `enum` at `idioms.kdl-schema:127` becomes a per-target declared set,
and what stays shared is the *declaration form* — MS-A. That is a change to shipped ws6 artifacts
(`CONTEXT.md` §ws6 decision D3), which is inside this grove's proposition but outside its charter
to make.

---

## 6. The SWIG fallback, costed

The leaf asks for the fallback "so a failure hands over a route rather than only a problem". The
verdict is that Q3 holds under MS-A, so the fallback is not needed — but it is cheap to cost, and
the costing produces a useful result: **the fallback is not a different architecture.**

**SWIG's answer** (k3 §3.7): the shared layer models *only the source* — the C++ type system and
the `Node` parse tree — and supplies mechanism (typemap matching, fragment insertion, `%feature`)
with **no target vocabulary whatsoever**. Guile's module is 1,634 lines and Java's is 5,145; they
share the parse tree and nothing else. 21 targets, the widest paradigm reach in the survey.

**Transposed here:**

| layer | Q3 under MS-A | SWIG fallback |
|---|---|---|
| shared IR | the resolved semantic model | same — unchanged, and ADR-0011 already says this is the only shared thing |
| shared mechanism | pass framework, template engine, file-set assembler, per-stage diff tool | same |
| **construct repertoire** | **per-target authored `.apiw` over a shared declaration meta-schema** | **per-target Rust node types, no meta-schema at all** |
| transform passes | per-target Rust | per-target Rust — same |
| templates | per-target Askama files | per-target Askama files — same |

**What it costs.** Exactly one of the root brief's five claimed gains: *"a generator a target expert
can edit without reading Rust"*. Under the fallback the repertoire is Rust source, so a Racket
expert adding a construct writes a struct, not KDL. The witness for the size of that loss is k3
§2.4c's — a C# interop expert on wit-bindgen issue #1265: *"I'm unfortunately not familiar with
Rust at all … the current code is somewhat overwhelming."*

**What it does not cost.** Everything else survives, which is the point worth carrying:

- **Per-stage model diffing survives** (k4 Q3's equivalence instrument, and the only technique the
  prior art reports as catching real migration bugs). The diff tool consumes the dumped `.kdl`
  structurally; it does not need the node types to be shared. uniffi's `pipeline peek` works this
  way over per-language IRs.
- **Templates survive**, and so does the contract — they were always per-target.
- **The derive-macro pass framework survives.** uniffi's `#[derive(Node, MapNode)]` is generic over
  the *user's* node types; the shared General IR is not what makes it work.
- **The provenance and mass arguments survive** unchanged.
- **ADR-0011 is satisfied by construction** rather than by argument, which is the fallback's real
  attraction: there is no line to drift across because there is no shared target-side artifact.

**The honest summary:** the fallback is Q3 with the authoring layer deleted. Because the two differ
by one layer rather than by an architecture, **the build grove can defer the choice**: build the
repertoire as Rust node types first, and lift it to authored `.apiw` when a second target of the
same family arrives and the duplication is visible. That ordering also matches k3 §9 Q13's
unanimous finding — *the authored layer must be optional, layered over defaults that already
work* — and it means an alien target that will not fit the meta-schema costs nothing, because it
never had to.

---

## 7. Where this check disagrees with k1, k3 or k4

| # | claim | where | this check |
|---|---|---|---|
| 1 | "One node per emitted thing (compilation unit, callable, parameter, type reference, …)" | `plan-k1` Q1; root brief *Settled design* | ⚠ **Does not hold as a shared spine.** Three of the four have no Prolog counterpart. They are repertoire members racket authors. §1.2, §3.2 |
| 2 | `pattern_dispatch` / `EmitConstruct` is "the nucleus of the proposed architecture" | `plan-k1` survey | ⚠ **Half right.** The *mechanism* is the nucleus; the *vocabulary* is a shared closed enum, which is the option Q3 rejected. Invert, do not extend. §5.4 |
| 3 | Q3's meta-schema is "the right side of that line in principle" but "easy to drift across", with creep unmeasured | k3 §9 Q12 | **Confirmed.** Not a disagreement — an upgrade. k2 §6.3 had already measured 143 of 263 shared lines as one target's; this check adds that the four later targets **forked** rather than conform, which is what makes it drift evidence rather than untidiness. §5.3 |
| 4 | The renderer's output contract is `Vec<(path, content)>` | k4 Q4 | ⚠ **Needs nesting.** Mercury's `pragma foreign_proc` and Pharo's uFFI pragma put rendered text of another language inside a construct. §4.3 |
| 5 | Sibling order is a golden-stability concern | k4 Q3; k3 §9 Q8 | ⚠ **Also a correctness concern.** Prolog clause order is program meaning; the diff instrument must distinguish. §4.4 |
| 6 | The alien check should be run against "Prolog **or** Idris2" | k3 §10.4 | **Prolog, with Mercury as the control.** Absence stresses a schema harder than richness, and the Prolog/Mercury pair isolates type-absence from logic programming. §2.3, §3.4 |
| 7 | Pharo is a candidate for "most alien" | leaf brief Q1 | **Rejected as the primary.** Pharo shares ObjC's object model; it tests syntax, not paradigm. Its one deep finding (co-indexed keyword identifiers) is carried as A1. §2.2 |

**The root brief's *Settled design* section was edited in place this session**, per this grove's
practice (current state, not a changelog): Q1's node-kind enumeration is restated as repertoire
members rather than a shared spine (row 1); Q3's meta-schema is pinned to the declaration-form
reading and gains a third qualification carrying this check's verdict and its five amendments; and
a *Two consequences of the meta-schema check* bullet carries §5's measured drift and §5.4's
nucleus-inversion prescription. Rows 4 and 5 amend `plan-mechanism-k4` Q4 and Q3 and are recorded
here for `write-handoff-doc-k5` rather than back-edited into a retired leaf's running log.

---

## 8. What this check did not settle

- **The size of the repertoire.** The check establishes that Prolog's constructs are *expressible*;
  it does not estimate how many constructs a real target's repertoire has, or what a repertoire
  file costs to author. k3 §9 Q13's two datapoints bracket it widely — haskell-gi's eleven
  directives against gtk-rs's 4,092-line typed config schema, ~13% of that generator. **Budget for
  the repertoire as a real component** and measure it in the racket pilot.
- **Whether the meta-schema is the right cost at all.** §6 shows the fallback differs by one layer.
  Which layer to build first is a build-grove decision informed by the pilot, not settled here.
- **The Swift adapter under an alien target.** k4 Q5 keeps the Swift adapter in scope, and PC30
  assumes it is unchanged. Prolog additionally needs a C shim (PC26–PC29) *between* Prolog and the
  Swift adapter, because SWI's FFI is registration-based. Whether that shim is generated, and by
  which target's templates, is unexamined — and it is the first place a target would need two
  adapter languages.
- **Pharo's bundler.** §4.6 parks image-based delivery as a `bundle-*` concern. The root brief
  already flags the five `bundle-*` crates (9,575 LOC) as unclassified; an image-based target is
  the case that would test them hardest.
- **Nothing was measured about Prolog, Mercury, Pharo, Idris2 or Zig.** Every claim about those
  languages is a language-reference fact used to reason about our schema. The two worth
  re-verifying against a live toolchain are flagged ⚠**verify** in §3.2.

---

## 9. Scope note

Paper exercise only, per the charter and `plan-k1` Q5: **no production code and no prototype**. No
ADR minted (charter Q6); `adr/` untouched. `CONTEXT.md` untouched — the terms `meta-schema`,
`repertoire`, `MS-A`/`MS-B` and the deletion test are this document's and the handoff doc's, not
the repo's ubiquitous language, and stay out of the glossary until a build grove commits to them.
`targets/_shared` and the five `emit-*` crates were read, never written. The Prolog and Mercury
listings in §3 are illustrative artifacts written for this check; they are not committed anywhere
and no `emit-prolog` crate exists or is proposed here.
