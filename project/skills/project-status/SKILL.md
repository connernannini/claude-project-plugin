---
name: "project-status"
description: >
  Quick status overview of one or all projects. Shows current phase, last
  activity, and next steps without starting work. TRIGGER when user says
  "status", "where are we", "what's the status", "what have we done",
  "catch me up", "how far along", "progress update", or asks about project state.
  If user wants to actively work on a project, use project-resume instead.
---

# Project Status

Read-only status overview. Does not start or resume work — just reports.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Steps

### 1. Determine scope
- **Current directory has a project** (has `journal.md` or `CLAUDE.md`): → Single Project
- **User asks for "all projects" / "overview" / "everything"**: → All Projects
- If user asks about a specific project from a different directory, note the mismatch but proceed (read-only is safe)

### 2a. Single Project
- Read `journal.md` (last entry) and `project-plan.md` (current phase, total phases)
- Present:

> **{Project Name}**
> Phase {X} of {Y}: {phase name}
> Last session: {datetime} — {one-line summary}
> Next steps: {bulleted list}
> Status: {On track / Blocked / Needs input / Stale}

### 2b. All Projects
- Read `{CLAUDE_PROJECT_ROOT}/context/project-index.md`
- For each active project, read `journal.md` (last entry) and `project-plan.md` (objective)
- Summary line: **{N} active, {N} completed, {N} archived**
- Detail table (active only — don't list archived unless asked):

> | Project | Phase | Last Active | Status | Next Step |
> |---------|-------|-------------|--------|-----------|
> | {name}  | {X/Y} | {datetime}     | {status} | {one-liner} |

- Ask: "Want to dive into any of these, or start something new?"

## Status Definitions
- **On track**: Last session completed with clear next steps, no blockers
- **Blocked**: Journal mentions unresolved blockers or missing dependencies
- **Needs input**: Next steps require user decision or external information
- **Stale**: No activity for 14+ days

## What This Skill Does NOT Do
- Modify project files
- Start or resume work (use project-resume for that)
- Run queries or test connections
