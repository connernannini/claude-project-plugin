---
name: "project-scaffold"
description: >
  Create project directory structure from an approved plan. Generates CLAUDE.md,
  settings.local.json, and output stubs. Called by project-kickoff after plan approval.
user-invocable: false
---

# Project Scaffold

Creates the project directory and files after a plan is approved. Pure execution — no user interaction.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Steps

### 1. Create directory structure
- Read `references/directory-template.md` for the standard layout
- Create `{CLAUDE_PROJECT_ROOT}/{project-name}/` with: `inputs/`, `outputs/`, `data_raw/`, `data_manipulated/`, `research/`, `scripts/`, `audit-logs/`, `.claude/`

### 2. Generate project CLAUDE.md
- Write CLAUDE.md per the template in `references/directory-template.md`:
  - Objective (1 sentence)
  - Which systems are involved (system knowledge auto-loads when relevant)
  - Compressed plan: checkboxes, first phase marked `<- ACTIVE`, directive to read project-plan.md
  - Key constraints (only things that affect every session)

### 3. Generate settings.local.json
- Whitelist only MCP tools needed for this project
- If `.claude/settings.local.json` already exists, merge permissions into the existing file

### 4. Finalize
- Append a "Scaffolding Complete" journal entry to `journal.md`:
  - Files created, key decisions preserved from discovery/planning, first next steps from the plan

## References
- `references/directory-template.md` — standard directory layout, CLAUDE.md content format, settings.local.json format
