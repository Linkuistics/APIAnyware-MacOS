### Session 20 (2026-04-18T07:47:49Z) — Self-contained bundle distributability hardening

- **Attempted:** Complete the "Self-Contained App Bundling (Swift Stub Launcher)" backlog
  task by closing two distributability gaps: `compiled/` leakage into bundles, and
  dylib install-name still pointing at build-tree `@rpath`.

- **What worked:**
  - `copy_dir_recursive` in `bundle.rs` now skips any directory named `compiled/`,
    preventing Racket's `.zo` bytecode cache (which bakes host-absolute paths into
    linklets) from leaking into distributable bundles.
  - New `normalize_dylib_install_names` function runs `install_name_tool -id
    @executable_path/../Resources/racket-app/lib/<name>` on every `.dylib` in the
    bundled `lib/` directory. Non-fatal if `install_name_tool` is absent (logs a
    warning). Verified via `otool -D`: `libAPIAnywareRacket.dylib` now carries the
    correct bundle-relative identity.
  - Three new integration tests added to `bundle_file_lister.rs`:
    `bundle_lib_copy_excludes_compiled_subdirectory` (unit-level: creates a `lib/compiled/`
    directory with a poison `.zo` and asserts it is absent from the bundle),
    `bundle_has_no_compiled_directories_anywhere` (walks the full bundle tree of the
    real file-lister app and fails on any `compiled/` directory), and
    `bundle_dylib_install_name_is_bundle_relative` (uses `otool -D` to assert the
    bundled dylib starts with `@executable_path/`).
  - All 34 `bundle-racket-oo` integration tests pass; full workspace (548 tests) and
    the runtime-load harness (7 apps, ~73s) both green.
  - Backlog task "Self-Contained App Bundling" marked `done` with detailed results.
  - Three stale `done` tasks verified correct (no safety-net flips needed).

- **What didn't work / was deferred:**
  - Bundling the Racket runtime itself (not required — stub `execv`s into
    `/opt/homebrew/bin/racket`).
  - Info.plist customization and stable signing identity split into separate backlog tasks.

- **What to try next:**
  - Start a sample app (Note Editor or Mini Browser) — no blocking dependencies remain.
  - Or tackle Info.plist customization to let Modaliser-Racket migrate from `bundle/build.sh`.

- **Key learnings:**
  - Racket `.zo` linklets are not relocatable — any `compiled/` tree must be excluded from
    distributable artifacts; the emitter's walker already ignores them implicitly but the
    `lib/` copy path needed an explicit guard.
  - `install_name_tool -id` on a bundled dylib is a lightweight operation (no re-link)
    that makes the bundle self-describing; Racket's `ffi-lib` is indifferent but future
    direct-link consumers and `dyld` introspection tools require it.
