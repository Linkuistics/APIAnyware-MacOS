# TODO

## Next Step: Migrate to Mnemosyne

**Priority:** High
**Status:** Ready to plan

### What

Replace the hand-rolled `~/.claude/plugins/observational-memory/` plugin with Mnemosyne (`../Mnemosyne`), which was derived from our observational-memory framework and provides a superset of its capabilities.

### Why

Mnemosyne adds:
- Global knowledge store (`~/.mnemosyne/`) with cross-project learnings
- Rust CLI for querying, promoting, curating, and evolving knowledge
- Additional skills: `/curate-global`, `/explore-knowledge`, `/promote-global`
- Language detection, context mappings, tag indexing
- Knowledge entry format with provenance, confidence, and cross-references

### What Already Exists

The matrix restructure is complete. These are already in place:
- `knowledge/` directory with 5 axes (pipeline, testanyware, apps, targets, matrix)
- `.observational-memory.yml` config (may need renaming/updating for Mnemosyne)
- CLAUDE.md routing files in `generation/targets/racket-oo/`
- `LLM_CONTEXT/project-workflow.md` referencing the plugin skills
- `.claude/skills/add-app.md` and `.claude/skills/add-target.md` (project-level)

### Action

1. Start a new session
2. Read `../Mnemosyne/README.md` and `../Mnemosyne/docs/` for full Mnemosyne docs
3. Create an implementation plan for the migration:
   - Install Mnemosyne Claude Code adapter (replace `~/.claude/plugins/observational-memory/`)
   - Update `.observational-memory.yml` to match Mnemosyne's expected config format
   - Update `LLM_CONTEXT/project-workflow.md` skill references for new Mnemosyne skills
   - Update `CLAUDE.md` skill references
   - Initialize `~/.mnemosyne/` global knowledge store
   - Seed global knowledge with cross-project learnings from `knowledge/targets/racket-oo.md`
   - Verify `/begin-work racket-oo` still works end-to-end
4. Execute the plan
