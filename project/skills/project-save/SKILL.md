---
name: "project-save"
description: >
  Checkpoint the active project — write a summary journal entry and update the
  project index. Two modes: quick (default, ~5s) writes journal + index; full
  (`/project-save full`) also runs the knowledge sweep via project-learn.
  TRIGGER when user says "save", "checkpoint", "save my progress", "let's save",
  or wants to preserve state mid-work. Do NOT use for completing a project
  (use project-complete) or for standalone knowledge sweeps (use project-learn).
---

# Project Save Skill

You save the current state of an active project so nothing is lost. This is the user's manual "save button" — they call it whenever they want to checkpoint progress.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Core Principles

- **Fast by default.** Quick mode runs in seconds — journal + index, done. Don't re-analyze the project.
- **Comprehensive when asked.** Full mode adds the knowledge sweep. Opt-in, not implicit.
- **Non-disruptive.** Save and keep going. There are no session ends — the user keeps working.

## Mode Selection

Read the user's args:
- **No args, or `quick`** → Quick mode (default). Steps 1, 2, 4, 5, 6. Skip Step 3.
- **`full`, `+learn`, or any arg containing "learn"** → Full mode. All steps including knowledge sweep.

If you can't tell, default to quick. Quick is cheap; full is expensive.

## Step 1: Identify the Project

Identify the active project: check cwd for CLAUDE.md → check `{CLAUDE_PROJECT_ROOT}/context/project-index.md` → ask the user.

## Step 2: Gather Current State

Read in parallel:
1. `journal.md` — To find the last saved entry, session number, and `learned_through` timestamp from frontmatter
2. `project-plan.md` — To identify current phase

If `journal.md` has no frontmatter or no `learned_through` field, treat all entries as unscanned.

## Step 3: Knowledge Capture (FULL MODE ONLY — skip in quick mode)

Run `/project-learn`. It will:
1. Backfill any missed journal entries from the session (auto-written, no approval needed)
2. Scan for un-captured knowledge learnings, present findings, write approved ones
3. Advance the `learned_through` timestamp

In quick mode, the knowledge sweep is the user's responsibility — they run `/project-learn` separately when they want it.

## Step 4: Write Summary Journal Entry

Write a summary checkpoint entry — a high-level "where things stand" bookmark. Gather what's happened since the last entry from the conversation (check `data_raw/`, `data_manipulated/`, and `outputs/` for new files), then append to `journal.md` using the journal-write skill (checkpoint variant), which owns the entry format and field list.

## Step 5: Update Project Index

Update phase and last-activity date in `{CLAUDE_PROJECT_ROOT}/context/project-index.md`. **Keep the phase column terse — 1–3 words ("Phase 4", "Plan approved", "Validation", "Blocked on review"). The index is a manifest, not a status report.** Detailed phase context lives in the project's CLAUDE.md and journal; do not duplicate it here. If a status flips (Active ↔ Complete, Backlog → Active), update that too.

## Step 6: Confirm

Keep it brief.

**Quick mode**:
> "Saved (quick). {1-line summary of what was journaled}. Run `/project-save full` when you want a knowledge sweep."

**Full mode**:
> "Saved (full). Journal updated. {N} learnings captured across {files}. Ready to keep going."

If shared files were also updated outside the index and journal, mention which ones.

## What This Skill Does NOT Do

- Does not run the full project-complete distillation
- Does not re-read or re-analyze the entire project history
- Does not ask for approval before writing the journal (it's the user's save action — just do it)
- Does not update shared files without flagging what's being added
- Does not run the knowledge sweep in quick mode — opt-in via the `full` arg

## Dependencies

**Depends on**: project-learn (invoked in Step 3 for full mode only), journal-write (entry format), projects CLAUDE.md (directory check).
