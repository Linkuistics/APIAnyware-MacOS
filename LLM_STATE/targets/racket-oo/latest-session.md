### Session N (2026-04-15T04:53:46Z) — File Lister polish + sample-app bundling

- **Attempted:** Polish the File Lister app that landed earlier this day
  (structural-only), then generalise the bundling story so every sample
  app ships as a proper macOS `.app` with the right menu-bar identity
  and the standard About/Hide/Quit menu items. Also wire up
  GUIVisionVMDriver (successor to TestAnyware) for interactive VM
  verification with OCR-capable VNC.

- **Worked:**
  - **File Lister polish iterations (all verified visually in the VM):**
    - Row height 20pt + `nstablecolumn-set-editable! #f` per column
      → clean read-only list rendering, no double-click-to-edit.
    - `NSStackView` horizontal + `NSLayoutAttributeFirstBaseline` for
      the toolbar → button title and path label baselines pin via
      Auto Layout instead of manual y-arithmetic (which kept landing
      half a pixel off across font sizes).
    - Scroll view flush to window edges (`(0,0,600,348)`, NSNoBorder);
      table autoresizing mask + `NSTableViewFirstColumnOnlyAutoresizingStyle`
      so the Name column absorbs horizontal growth on resize.
    - Autoresizing masks on the stack view (`NSViewWidthSizable |
      NSViewMinYMargin`) so the toolbar pins to the top during
      window resize.
  - **New crate `apianyware-macos-bundle-racket-oo`** at
    `generation/crates/bundle-racket-oo/`:
    - `AppSpec::from_script_name("file-lister")` → derives display
      name via kebab→title, or reads `knowledge/apps/<script>/spec.md`
      first H1 for canonical capitalisation (fixes
      `ui-controls-gallery` → `UI Controls Gallery`, not `Ui…`).
    - `collect_dependencies(entry, source_root)` — pure-Rust BFS
      walker over `.rkt` `(require "...rkt")` forms with a state-
      machine string literal scanner; rejects require targets
      outside `source_root`; handles cycles and escaped quotes.
    - `bundle_app(spec, source_root, output_dir)` — calls
      `stub-launcher::create_app_bundle` for the `.app` skeleton,
      then copies discovered files into
      `Resources/racket-app/<rel>` preserving the source layout so
      relative requires resolve at runtime. Optional
      `lib/libAPIAnywareRacket.dylib` is copied if present.
    - CLI: `cargo run --example bundle_app -p
      apianyware-macos-bundle-racket-oo -- <script>` or `-- --all`.
      `--all` walks `apps/` and bundles every entry.
    - 19 unit tests + 4 integration tests (including
      `bundles_every_sample_app` which auto-discovers new apps).
  - **Shared `runtime/app-menu.rkt` helper** exposing
    `install-standard-app-menu!`. Every sample app now calls it with
    its display name to install the standard About / Hide / Hide
    Others / Show All / Quit menu with the expected ⌘Q, ⌘H, ⌥⌘H
    keyboard equivalents. Uses raw typed `objc_msgSend` (not `tell`)
    because `tell` fails its `_id` coercion on SEL arguments like
    the `action:` slot of `addItemWithTitle:action:keyEquivalent:`.
  - **Latent `as-id` bug fixed** in `runtime/objc-base.rkt`. The
    `(objc-object? obj)` branch was returning the raw cpointer
    instead of `(cast … _pointer _id)`, making the function useless
    for its stated purpose. Surfaced when `install-standard-app-menu!`
    tried to pass the NSApplication wrapper through `as-id` and
    crashed the launch with `id->C: argument is not 'id' pointer`.
  - **All four sample apps bundle and run correctly:** hello-window
    (Hello Window.app), counter (Counter.app), ui-controls-gallery
    (UI Controls Gallery.app), file-lister (File Lister.app). Each
    has the correct `CFBundleName`, `app:"<Display Name>"` in the
    accessibility tree, and the full standard menu confirmed via
    VNC click + OCR screenshot of Counter's open menu.
  - **Testing:** `cargo test --workspace --no-fail-fast` → exit 0,
    484 passes, 0 failures. `RUNTIME_LOAD_TEST=1 cargo test -p
    apianyware-macos-emit-racket-oo --test runtime_load_test` green.
    `runtime/app-menu.rkt` added to `RUNTIME_FILES` in the harness;
    `APPS` now includes all 4 sample apps.
  - **Docs:** README updated with a new two-tier "App Bundling"
    section (stub-launcher language-agnostic primitive vs
    bundle-racket-oo racket-oo convention), GUI Testing section
    rewritten around GUIVisionVMDriver, workspace structure listing
    updated. `knowledge/targets/racket-oo.md` gets sections on
    sample-app bundling, delegate-callback type caveats (NSInteger
    return via arm64 x0 smuggle, raw-cpointer args), toolbar
    baseline alignment, and 2026-04-15 dated discoveries.
  - **Memory:** new entries for bundling, `app-menu.rkt` raw
    msgSend approach, `as-id` cast bug, accessibility menu
    drill-down via VNC click, GUIVisionVMDriver VNC password
    recovery.
  - **`.gitignore`:** `generation/targets/*/apps/*/build/` added
    (built bundles are regenerable via the CLI).

- **Didn't work first time / corrected:**
  - **First attempt at app-menu.rkt used `tell`** with SEL
    arguments. Failed at runtime with `id->C: argument is not 'id'
    pointer` on `addItemWithTitle:action:keyEquivalent:`. Rewrote
    using raw typed `objc_msgSend` — works cleanly.
  - **First bundling attempt hardcoded the Resources layout**
    incorrectly (`Resources/racket-app/<everything>`), which broke
    relative requires. Fixed by placing runtime and generated as
    siblings of `racket-app/` → script at
    `Resources/racket-app/apps/<name>/<name>.rkt`, deps at
    `Resources/racket-app/runtime/` and
    `Resources/racket-app/generated/oo/…`.
  - **First `AppSpec::from_script_name` used kebab→title conversion**
    and produced `Ui Controls Gallery`. Fixed by reading
    `knowledge/apps/<script>/spec.md`'s first H1 — spec.md is now
    the source of truth for canonical display names.
  - **`NSProcessInfo setProcessName:` hack didn't work** (modern
    macOS filters it). The bundling story is the only working fix
    for the menu-bar app name — that's why bundle-racket-oo exists
    at all.
  - **Bundle integration test assertions drifted** twice as the
    require tree changed (first when `nsstring.rkt` turned out not
    to be statically required, then when the app-menu helper stopped
    pulling in `nsmenu.rkt`/`nsmenuitem.rkt`). Each correction
    tightened the test with a positive "this IS pulled in" + a
    negative "this is NOT pulled in" assertion, which makes the
    test both a structural check and a change detector.

- **Suggests trying next:**
  - **Auto-bundling from the generate CLI:** teach
    `apianyware-macos-generate -- --lang racket-oo` to bundle the
    sample apps as a post-emission step. Currently opt-in via the
    bundle-racket-oo example. Out of scope this session but the
    primitive is in place.
  - **Menu Bar Tool app is next in the declared order** (now that
    all existing apps are polished and bundled). The shared menu
    helper will apply cleanly; the open challenge is the
    no-main-window status-bar lifecycle.
  - **Per-language bundle convention crates for chez/gerbil/etc.**
    follow the same split as bundle-racket-oo: dependency-walker
    tailored to the language's require semantics, plus a layout
    convention that keeps relative imports working inside the
    bundle. The stub-launcher primitive is language-agnostic.

- **Key learnings / discoveries:**
  - **The bundling story is non-optional** for a polished Mac sample
    app. `NSProcessInfo setProcessName:` doesn't work. Main-menu
    submenu titles handle the menu items but not the bold app-name
    slot. `CFBundleName` in `Info.plist` is the only path. That
    makes `bundle-racket-oo` a load-bearing crate, not a nicety.
  - **`tell` can't be used with SEL parameters**, period — raw
    typed `objc_msgSend` is the escape hatch, and the generated
    framework bindings already use it for every non-id parameter.
    Runtime-side helper code that needs SEL args must follow the
    same pattern.
  - **`as-id` had a silent bug for a long time** because nothing
    important was calling it with a wrapped `objc-object`. All the
    hot paths go through `coerce-arg` which has its own cast. The
    `install-standard-app-menu!` integration surfaced it by being
    the first runtime-side code to call `as-id` on an application
    handle. Lesson: utility functions with "always returns X"
    docstrings need unit tests, because callers trust the
    docstring.
  - **GUIVisionVMDriver agent + VNC split** is the right shape for
    this kind of verification. Agent snapshots give structural
    guarantees (the app's identity, what's in the accessibility
    tree). VNC `click` + `screenshot` fills the gaps (submenu
    contents, pixel alignment). The VNC password ephemerality is
    the main friction — source the vm-start script once with
    output to a file, persist the creds to `/tmp/gv_*` for
    subsequent calls.
  - **Spec.md as source of truth for display names** is a small
    but load-bearing convention. It means adding a new sample app
    is: create `apps/<kebab>/<kebab>.rkt`, create
    `knowledge/apps/<kebab>/spec.md` starting with `# <Display
    Name>`, and the bundler handles the rest. The integration
    test auto-discovers via directory walk, so no test edits are
    needed for a new app.
