---
name: "project-complete"
description: >
  Mark a project as complete. Distills journal into a summary, captures
  reusable patterns and gotchas, updates the project index, and archives.
  TRIGGER when user says "this project is done", "wrap this up",
  "mark complete", or wants to close out a finished project.
---

# Project Completion Skill

Wraps up a finished project by distilling what was learned into shared knowledge so future projects benefit.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Core Principles

- **Quick.** This is a 2-minute wrap-up, not a retrospective.
- **Additive.** Only add to shared files — never remove or overwrite existing entries.
- **User confirms.** Show what you plan to add to shared files and get approval before writing.

## Step 1: Identify the Project

Identify the active project: check cwd for CLAUDE.md → check `{CLAUDE_PROJECT_ROOT}/context/project-index.md` → ask the user.

## Step 2: Verify Completion

Read in parallel:
1. `journal.md` — Full session history
2. `project-plan.md` — Original plan and objectives

Compare the plan's phases against the journal. If any phases appear incomplete, flag it:
> "It looks like Phase {X} ({name}) may not be finished yet. Want to mark the project complete anyway, or wrap up that phase first?"

Only proceed if the user confirms.

## Step 3: Distill & Present

### Project Summary (for project-index.md)
3-5 sentences covering: what was done, what systems were involved, key outcome.

### Knowledge Capture
Run `/project-learn`. It will scan for un-captured learnings across the full project, present findings, write approved learnings, and advance the `learned_through` timestamp.

### Present to User
> "project-learn captured {M} learnings to shared files (above). Now to close out the project:
>
> **Summary** (for project-index.md): {3-5 sentences}
>
> Look good? I'll record the summary, write the completion journal entry, and mark this project complete."

## Step 4: Update Project Files (after user approval)

1. **project-index.md**: Move project from Active to Completed table. Add summary and completion date.
2. **journal.md**: Add final entry using the journal-write skill (completion variant).

## Step 5: Memory Curation (if applicable)

**Gate**: Only run this step if the project's auto-memory index exists at `~/.claude/projects/<project-path-slug>/memory/MEMORY.md` (directory named after the project's full path). If it doesn't, skip to Step 6.

1. Scan the project's `MEMORY.md` (and the memory files it indexes) for entries related to this project
2. Route any unpersisted learnings to shared files using project-learn's category routing
3. Flag entries that are now duplicates of what's in shared files, or are project-specific to the completed project — propose removal
4. Present all proposed changes (promotions and removals) to the user before executing

## Step 6: Archive

Move the project directory to `{CLAUDE_PROJECT_ROOT}/_archive/{project-name}/`. This keeps the active project list clean while preserving everything for reference. The project may be at the top level or inside a group folder — either way, it lands in `_archive/`.

If the user ever asks to unarchive or resume an archived project, move it back to its original location and update project-index.md accordingly — no dedicated skill needed.

## Step 7: Confirm

> "Done. This project is archived to `_archive/` and marked complete. The patterns and lessons are saved for future projects."

## Dependencies

**Depends on**: project-learn (invoked in Step 3 for knowledge capture), journal-write (entry format), projects CLAUDE.md (directory check).

## What This Skill Does NOT Do

- Does not delete the project directory (it moves it to `_archive/`)
- Does not modify project outputs
- Does not update shared files without user approval
- Does not force a retrospective — keeps it lightweight
