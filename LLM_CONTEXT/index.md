# LLM Context

Project-wide instructions for Claude sessions working on APIAnyware-MacOS.

## Start here

- `project-workflow.md` — master reference: how the project is organised, the knowledge
  system, skills, adding targets/apps, testing workflow
- `coding-style.md` — Rust coding conventions and project-specific style rules

## The observational-memory plugin

This project uses the observational-memory Claude Code plugin for structured knowledge
capture. The plugin provides:
- `/begin-work`, `/reflect`, `/create-plan` skills
- Reference docs on the technique, plan format, and coding conventions

Project-specific conventions in `coding-style.md` extend (and in some cases override)
the plugin's universal conventions.
