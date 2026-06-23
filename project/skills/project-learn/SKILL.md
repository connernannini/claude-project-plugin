---
name: "project-learn"
description: >
  Knowledge capture engine. Two modes: (1) User invokes /project-learn for
  comprehensive journal sweep across all categories. (2) Auto-triggers for
  real-time capture when: user corrects an assumption, tool reveals reusable
  knowledge, workflow succeeds, data quality pattern noticed, or instruction
  file found wrong or incomplete.
---

# Project Learn

Captures knowledge from project work and persists it to shared files. Two modes — comprehensive sweep or real-time single-finding capture.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Mode Selection

- User invoked `/project-learn` or called by another skill (save, resume, complete) → **Sweep**
- Auto-triggered during active project work → **Capture**
- When in doubt → **Capture** (smaller scope, less disruptive)

---

## Sweep Mode

### 1. Gather context
- Read `journal.md` — check for `learned_through` timestamp in frontmatter. Entries after that timestamp are the scan scope. If missing, treat all entries as unscanned.
- Read `project-plan.md` and project `CLAUDE.md` for scope and systems
- Build a list of all files read, modified, or referenced this session — this is the dedup source for Step 2
- Scan current session for events matching journal write triggers (per CLAUDE.md) that have no journal entry. Backfill silently, then confirm: "Backfilled {N} journal entries: {summary}"

### 2. Scan & present
- Read `references/taxonomy.md` and walk every category (1-15). For each: "Did anything happen this session that fits?"
- Dedup each finding against: every file from the gather list + the target knowledge file
- Skip findings where the substance is already captured (even if worded differently), or where a fix made during the session already addressed it
- Group findings by destination file and present:

> **For `~/.claude/skills/{system}/references/domain.md`:**
> 1. {what was learned} — {proposed content}
>
> **Nothing found for**: tools.md, enums.md — already up to date.
>
> Approve all, or tell me which to skip.

If nothing found: "Sweep complete — everything from this session is already captured."

### 3. Write approved
For each approved finding:
- Read target file, find insertion point
- **Size cap**: 12K chars → warn before adding. 15K chars → stop. Offer prune, split, or promote.
- **Consolidation**: If 2+ existing entries cover the same topic as the new finding, propose merging into one clearer entry instead of appending
- Write content, update section timestamp (`*Last updated: {date}*`) on the specific section modified
- **File-level timestamp**: Update `*Last verified: {date}*` at the top of the file. If missing, add it after the H1 heading.
- If a new file was created under a skill's `references/` directory, add it to that skill's `SKILL.md` References section

### 4. Confirm
- Advance `learned_through` in journal frontmatter to the latest scanned entry (even if no findings)
- Summary: "Done. Backfilled {N} journal entries. {M} learnings captured across {files}. `learned_through` advanced to {date}."

---

## Capture Mode

### 1. Classify
- Match the finding against `references/taxonomy.md` — identify the category and destination file

### 2. Present & approve
- Surface the finding conversationally: what was learned, where it belongs, proposed content
- Wait for explicit approval before writing

### 3. Write
- Dedup against target file — skip if substance already captured
- Size cap check (same thresholds as sweep)
- Write content, update section timestamp (`*Last updated: {date}*`) and file-level timestamp (`*Last verified: {date}*`)
- If a new file was created under a skill's `references/` directory, add it to that skill's `SKILL.md` References section
- Advance `learned_through` in journal frontmatter
- One-line confirmation

---

## Shared Rules

- ALWAYS dedup before writing — check target file and all files referenced this session
- NEVER auto-persist knowledge without user approval. Journal backfills are auto-written (triggers are well-defined).
- Size cap: 12K warn, 15K stop. Offer prune, split, or promote.
- `learned_through` timestamp: always advance after scanning, even if nothing found
- Concrete findings only — "{system} status codes changed" not "{system} data may be stale"

## References
- `references/taxonomy.md` — 15 knowledge categories with triggers, routing, and special rules

## What This Skill Does NOT Do
- Write checkpoint or summary journal entries (that's project-save)
- Replace real-time knowledge capture triggers in CLAUDE.md — it's the safety net, not the primary mechanism
- Scan entries before the `learned_through` timestamp (already reviewed)
- Make decisions about what to persist — user approves all knowledge writes
