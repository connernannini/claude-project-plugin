---
name: "project-resume"
description: >
  Resume work on an existing project. Rebuilds context from project files
  and briefs the user. TRIGGER when user says "resume", "continue the project",
  "pick up where we left off", "let's work on [project]", "back to [project]",
  or references starting work on an existing project.
  If user wants a report without starting work, use project-status instead.
---

# Project Resume

Rebuilds context from project files so the user can pick up where they left off.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Steps

### 1. Load & assess
- **Identify the project**: if cwd has `CLAUDE.md`/`journal.md`, use it. Otherwise look up the name the user gave in `{CLAUDE_PROJECT_ROOT}/context/project-index.md` and read from that project's folder. If neither resolves, ask the user.
- Read project `CLAUDE.md`, `journal.md`, and `project-plan.md` (active phase only, per compressed plan)
- Identify: last session date, current phase, pending next steps, any blockers
- **Interrupted kickoff**: If `journal.md` exists but `CLAUDE.md` does not, the kickoff was interrupted (CLAUDE.md is written last, during scaffolding; a draft `project-plan.md` may be present from an interruption after planning). Suggest: "This project's kickoff was interrupted during {phase}. Want to run `/project-kickoff` to pick up where you left off?"
- **Unsaved last session**: If the last journal entry lacks clear next steps, looks incomplete, or the session context suggests work happened after the last entry — write a brief recovery journal entry capturing what was accomplished and where things stand (a catch-up note so the Step 2 learnings sweep has complete context — this is not a full /project-save checkpoint).

### 2. Surface learnings
- Check `learned_through` timestamp in journal frontmatter
- If unprocessed entries exist, run project-learn (sweep mode)
- If caught up, skip silently

### 3. Brief & continue
- Present status:

> **Project**: {name}
> **Last worked on**: {datetime}
> **Current phase**: {phase} — {description}
> **What was done last time**: {summary}
> **Next steps**: {list}
> **Blockers**: {if any}

- If >7 days since last session, flag: "It's been a while — connections may need re-validating. I'll test them when we start working."
- Ask: "Want to continue with the next steps, or has anything changed since last time?"

## What This Skill Does NOT Do

- Does not just report status without rebuilding context (use `/project-status` for a quick overview)
- Does not start new projects (use `/project-kickoff`)
- Does not save progress or checkpoint (use `/project-save`)
