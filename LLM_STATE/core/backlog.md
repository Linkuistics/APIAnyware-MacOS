# Core Pipeline

The shared pipeline that feeds all language targets: collection, analysis, and enrichment
of macOS API metadata. Supports ObjC class/protocol/enum extraction and C function/enum/
constant extraction including function pointer typedefs.

All major pipeline capabilities are complete. The core is in maintenance mode — new tasks
emerge reactively as target app development reveals edge cases or gaps.

## Task Backlog

The core pipeline is in maintenance mode. Tasks below are reactive — each one
was surfaced either by a runtime failure in a language target or by a memory
entry triaged during a prior cycle. Provenance is recorded per-task in the
"Surfaced by" / "Promoted from" field. Priority ordering at the top of a
pending cluster is `high → medium → low`; within a priority band, the
listing order is a suggested work order, not a hard constraint.

_No pending tasks — the three follow-up cleanup / testing items were
bundled and shipped together on 2026-04-15. Next tasks will come from
reactive discovery by target app development._

## Completed Tasks

### Remove legacy POC serde aliases from `Framework` `[cleanup]`
- **Completed:** 2026-04-15
- **Surfaced by:** Memory entry "Legacy POC serde aliases have no production consumers"
- **Summary:** Dropped all three POC-era serde annotations from
  `collection/crates/types/src/ir.rs::Framework`: removed
  `#[serde(alias = "ir_version", default)]` from `format_version` (kept
  plain `default`), removed `#[serde(rename = "framework")]` from `name`,
  and removed the `ir_level: Option<i32>` field entirely along with its
  13 `ir_level: None,` struct-literal call sites across
  collection/extract-{objc,swift}, analysis/{resolve,annotate,enrich},
  generation/{cli,emit,emit-racket-oo}, and two test files. Rewrote
  `collection/crates/types/tests/deserialize_ir.rs` to use a
  `MINIMAL_FRAMEWORK_JSON` literal with modern keys (`format_version`,
  `name`) — 5 tests covering format_version/name deserialization, post-
  minimum default behaviour, depends_on round-trip, and modern-to-modern
  re-serialise round-trip. Updated design-doc JSON example in
  `docs/specs/2026-03-26-macos-workspace-design.md` and the
  `foundation_serializes_to_json` assertion in
  `collection/crates/extract-objc/tests/extract_foundation.rs` which was
  pinning the old on-the-wire `"framework":` key directly. Full pipeline
  regenerated end-to-end (collect + analyze) across all 283 frameworks —
  Foundation.json confirmed writing `"name": "Foundation"` at top of
  file. Workspace green at 451/451 tests. Retires the "Legacy POC serde
  aliases have no production consumers" memory entry.

### Qualify Swift overload names with parameter labels `[collection]`
- **Completed:** 2026-04-15
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** Changed the `Func` arm in
  `collection/crates/extract-swift/src/declaration_mapping.rs::map_abi_to_framework`
  to record `child.printed_name.clone()` instead of `child.name.clone()`
  when pushing into `fw.skipped_symbols`. `fw.functions[]` remains
  unchanged to preserve FFI compatibility — the qualification only
  affects observability in the skipped_symbols audit list. The `Var`
  arm was not touched because Swift constants do not overload and
  `printed_name == name` for vars. Blast radius: synthetic
  `createDefaultWidget` test fixture now shows as
  `"createDefaultWidget(name:)"`; 4 existing synthetic filter tests
  (swift-native/macro/anon-enum Func arms, Foundation overlay regression)
  updated to use `"swiftNative()"`, `"MIN()"`, `"anon_enum_func_a()"`,
  `"pow()"`, `"NSLocalizedString()"` shapes. Real-SDK pipeline
  regenerated: `(name, kind)` duplicate groups in `skipped_symbols`
  across all frameworks dropped from **18 → 12**. The 12 remaining are
  true type-based Swift overloads that share parameter labels but
  differ only in types (e.g. CoreML `pointwiseMin(_:_:)`×3 with
  different tensor element types, TabularData `/(_:_:)`×4 for numeric
  operator variants, Network `withNetworkConnection(to:using:_:)`×4).
  Full signature disambiguation is out of scope for this task — the
  task description explicitly specified the `printed_name` form
  (e.g. `pointwiseMin(_:_:)`) and my fix implements exactly that.
- **Follow-ups:**
  - 12 type-based Swift overload collisions in `skipped_symbols`
    still present. Disambiguating would require embedding the mangled
    Swift type signature or the parameter type list into the name —
    both deviate from the task's "printed_name matches objc owner.selector"
    design. Defer unless a concrete consumer actually reads these
    entries and cares about the duplication.

### Test `depends_on` / `extract_imports` output in extract-swift `[testing]`
- **Completed:** 2026-04-15
- **Surfaced by:** Follow-up from "Real-SDK integration test harness" (2026-04-14)
- **Summary:** Added four assertions to the existing real-SDK
  integration harness: `coretext_depends_on_contains_foundation` and
  `coretext_depends_on_excludes_private_imports` in
  `tests/extract_coretext.rs`;
  `network_depends_on_contains_foundation_and_dispatch` and
  `network_depends_on_excludes_private_imports` in
  `tests/extract_network.rs`. Together they pin that
  `extract_imports` actually produces non-empty output end-to-end
  (Foundation for CoreText; Foundation + Dispatch for Network) and
  that the `_`-prefixed private-import filter inside `extract_imports`
  is honoured. These are the first real-SDK assertions on
  `depends_on` — the synthetic fixture tests cover filter shape, these
  pin the digester's actual `Import`-node output. Full workspace
  count: 455/455 tests green (+4 from this task), clippy clean, fmt
  clean.

### Rewrite `deserialize_ir.rs` as synthetic schema-evolution test `[testing]`
- **Completed:** 2026-04-14
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** Replaced 16 fixture-coupled assertions (244 lines, all
  loading `APIAnyware/ir/level1/Foundation.json` which no longer
  exists) with 6 focused tests (88 lines) driven by one inline
  `LEGACY_POC_JSON` literal in `collection/crates/types/tests/deserialize_ir.rs`.
  Pins the load-bearing schema-evolution contract: `ir_version` →
  `format_version` serde alias, `framework` → `name` rename via
  `#[serde(rename)]`, `ir_level` legacy field preserved on
  deserialisation, and `serde(default)` behaviour for every post-POC
  field (`sdk_version`, `collected_at`, `checkpoint`, `skipped_symbols`,
  `class_annotations`, `api_patterns`, `enrichment`, `verification`).
  Adds a legacy→modern→legacy round-trip that confirms re-serialised
  output drops `ir_level` per `skip_serializing` and re-parses cleanly.
  Workspace test count went 437 → 452 (+15: 6 from this rewrite, 9 from
  the prior real-SDK integration work which had not appeared in the
  earlier baseline). The "Prefer synthetic tests over SDK-dependent
  tests" memory rule is now actually enforced for this file.
- **Correction to task framing:** The pending-task description said
  the test "silently skips → false-green CI". The actual code was
  `unwrap_or_else(|e| panic!(...))` — the test was loudly failing on
  main, not silently passing. The fix is the same regardless of the
  mechanism, but future triage should not assume "stale fixture"
  implies silent-skip — read the load helper. Reinforces the
  "Backlog task descriptions are hypotheses" memory rule.

### Fix formatting drift in `extract_network.rs` `[testing]`
- **Completed:** 2026-04-14
- **Surfaced by:** Follow-up from "Surface ObjC silent-filter decisions" (2026-04-14)
- **Summary:** `cargo +nightly fmt -- collection/crates/extract-swift/tests/extract_network.rs`
  cleared the pre-existing fmt drift on main. Workspace
  `cargo +nightly fmt --check` now passes clean. Bundled into the same
  work cycle as the `deserialize_ir.rs` rewrite — both are tiny
  collection-tree hygiene fixes from the same follow-up triage cluster,
  share the same evidence trail, and want to ship together.

### Surface ObjC silent-filter decisions into `skipped_symbols` `[observability]`
- **Completed:** 2026-04-14
- **Summary:** New `apianyware_macos_types::skipped_symbol_reason` module
  centralises five tagged `&'static str` constants — `internal_linkage`,
  `platform_unavailable_macos`, `swift_native`, `preprocessor_macro`,
  `anonymous_enum_member`. Each reason string starts with its tag so
  downstream audit tooling can match via `reason.contains("<tag>")`.
  extract-objc now threads a `&mut Vec<ir::SkippedSymbol>` through
  `extract_class`, `extract_protocol`, `extract_method`, `extract_property`,
  `extract_category`, `extract_function`, `extract_constant` via a new
  `record_skip` helper. Methods and properties qualify the recorded name
  as `"{owner}.{selector|property}"` so class-level context survives. The
  dead-code `"extraction failed"` outer record for classes was removed.
  extract-swift now references the same constants instead of inline
  strings. 12 new regression tests added across the two filter test
  files (internal linkage: +3, platform unavailability: +9). Pipeline
  re-collected end-to-end — 3,927 skipped symbols now recorded across
  283 frameworks: 2,528 `platform_unavailable_macos` (65 frameworks,
  top: AVFoundation 633 / Intents 372 / ARKit 367 / SensorKit 250),
  1,016 `internal_linkage` (newly visible; AppKit alone 390), 205
  `anonymous_enum_member`, 148 `swift_native`, 30 `preprocessor_macro`.
  Canonical double-count cases (NSLog, NSApplicationMain) verified
  single-entry: both land once in `fw.functions` from extract-objc and
  once in `fw.skipped_symbols` as `swift_native` from extract-swift,
  with no objc-side skip record since they're externally linked and
  macOS-available. The 30 duplicate (name, kind) pairs that do exist
  in `collected/*.json` are all CoreML/CreateML Swift overloads with
  the same printed simple name (`pointwiseMin`, `show`,
  `maximumAbsoluteError`) — a pre-existing extract-swift behaviour,
  not introduced by this change. Retires the "Silent filters create an
  observability gap vs skipped_symbols" memory entry.
- **Follow-ups:**
  - Swift overload printed-name collisions are now visible as duplicate
    entries in `skipped_symbols`. Consider qualifying the `name` field
    with parameter labels in extract-swift (e.g. `pointwiseMin(_:_:)`)
    for uniqueness, matching how extract-objc qualifies methods with
    their owner class.
  - Pre-existing workspace test failures unrelated to this task:
    `collection/crates/types/tests/deserialize_ir.rs` still points at
    the legacy `APIAnyware/ir/level1/Foundation.json` path that no
    longer exists. Fix or delete per the "Prefer synthetic tests over
    SDK-dependent tests" memory rule.
  - Pre-existing formatting drift in
    `collection/crates/extract-swift/tests/extract_network.rs` (fmt
    check fails on main, not touched by this task).

### Real-SDK integration test harness for extract-swift `[testing]`
- **Completed:** 2026-04-14
- **Summary:** Added `tests/extract_coretext.rs` (4 tests) and
  `tests/extract_network.rs` (5 tests) invoking `swift-api-digester`
  against the installed macOS SDK via the existing
  `extract_swift_framework` pipeline. CoreText canaries the `c:@macro@`
  filter (all 15 `kCTVersionNumber*` macros absent from `fw.constants`,
  recorded into `skipped_symbols` with "preprocessor macro cursor"
  reason) plus a `CTGetCoreTextVersion` positive control. Network
  canaries the `c:@Ea@`/`c:@EA@` filter (all 7
  `nw_browse_result_change_*` anonymous-enum members absent, ≥50
  anonymous-enum entries in `skipped_symbols`) plus >400 `nw_*`
  functions and `nw_parameters_create` positive controls. Production
  surface already existed; the gap was test coverage, not
  infrastructure. 14/14 extract-swift tests green, clippy clean.
  Retires memory entries "Real-SDK canary gap is extract-swift only"
  and "extract-swift tests use pre-captured fixtures only".
- **Follow-ups:** `depends_on` / `extract_imports` output untested;
  harness re-runs digester (~2s per framework) on every `cargo test`
  — watch cumulative cost if more frameworks are added.

### Platform-availability filter for ObjC methods, classes, protocols `[collection]`
- **Completed:** 2026-04-14
- **Summary:** Extended `is_unavailable_on_macos` to gate `extract_class`
  (wholesale drop), `extract_protocol` (wholesale drop), and
  `extract_method` (per-selector). Blast radius: 53 frameworks, −450
  classes, −151 protocols, −2,982 class methods, −414 protocol methods.
  15 regression tests added. Per-property filter deferred to separate task.

### Per-property availability filter for ObjC properties `[collection]`
- **Completed:** 2026-04-14
- **Summary:** Added `is_unavailable_on_macos` gate to `extract_property`,
  completing the ObjC platform-availability filter quartet (methods, classes,
  protocols, properties). Blast radius: 303 properties dropped across 31
  frameworks (AVFoundation −223, 74% of total). TDD: 4 tests on synthetic
  `MixedClass` fixture. Full workspace green (437/437). Not yet committed
  (pending alongside larger emitter rewrite WIP).

### Stale Foundation/AppKit golden snapshots `[testing]`
- **Completed:** 2026-04-14
- **Summary:** Updated `main.rkt` (−1 iOS-only class) and `constants.rkt`
  (−13 iOS/tvOS-only symbols) in the Foundation golden subset to match
  the availability-filter blast radius. AppKit goldens already clean.
  Workspace tests restored to green. Not yet committed (same WIP context).
