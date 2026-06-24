---
name: "project-kickoff"
description: >
  Start a new project. Guides through discovery, planning, and setup.
  TRIGGER when user says "new project", "start a project", "kick off",
  "set up a new", or describes a new initiative to work on.
---

# Project Kickoff

Guides the user through defining a project, creating a plan, and scaffolding the directory.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Steps

### 1. Discover
- **Directory check**: Verify cwd is under `{CLAUDE_PROJECT_ROOT}/` and is a clean directory (no existing `CLAUDE.md` or `project-plan.md`). If it has both, suggest `/project-resume`. If it has `journal.md` but no `CLAUDE.md`, a prior kickoff was interrupted — read journal and pick up where it left off. If not in a project dir, offer to create `{CLAUDE_PROJECT_ROOT}/{name}/` and tell the user to start a new session from there.
- Ask 3-5 tailored discovery questions (skip what's obvious from context):
  1. What are you trying to accomplish? What does success look like?
  2. What systems are involved? Where does the data live?
  3. What are the inputs and outputs?
  4. Who is this for? How often will it run?
- After answers, synthesize back to the user. Check any knowledge skills the user already has under `~/.claude/skills/` for the systems they named.
- **Prior projects scan**: Now that systems and goals are known, read `{CLAUDE_PROJECT_ROOT}/context/project-index.md` and find ALL projects (active, completed, archived, backlog) that share systems or domain. For matches:
  1. Read their `CLAUDE.md` and `project-plan.md` for scope and key decisions
  2. If relevant to the new project, scan their journal for specific gotchas, patterns, and reusable context
  3. Surface anything useful: "A past project on {system} found X — worth knowing here"
- Ask for a project name: "What should we call this project? Pick a short name — something like `sales-dashboard` or `vendor-audit`."

**Journal capture**: Create `journal.md` as soon as the directory is confirmed. Append discovery answers, systems, and decisions incrementally — don't wait until the phase is complete.

**Add to project-index.md** with status "Kickoff in progress" as soon as the directory is created.

Do not proceed to Step 2 until the user confirms the discovery summary.

### 2. Plan
- **Simple projects**: Objective (1 sentence), input, output, steps (3-5 bullets). Confirm the deliverable format and destination — don't assume.
- **Medium/complex projects**: Numbered plan with objective, data sources, process steps, outputs, checkpoints at critical moments (after data gathering, before external writes, before finalizing).
- If external systems were identified, validate access during planning — run a simple test query per system. Report failures and offer to skip or reconnect.
- **Persist immediately**: Write `project-plan.md` as a draft (`**Status: DRAFT — awaiting user approval**`) before asking for approval. This ensures the plan exists even if the session ends.

Do not proceed until the user explicitly approves the plan.

**On approval** (do all immediately):
1. Update `project-plan.md` — remove draft header, mark `**Status: Approved — {datetime}**`
2. Synthesize journal — clean kickoff summary at top (objective, systems, key decisions, approved plan). Keep raw entries below.
3. Update project-index.md — status "Plan approved" and current phase

**Timestamp format**: write `{datetime}` stamps as `YYYY-MM-DD HH:MM` (local) — run `date "+%Y-%m-%d %H:%M"` to get the current time; never guess it.

### 3. System Prep
- For each system in the plan, read its knowledge skill (`~/.claude/skills/{system}/SKILL.md`) and assess: does the existing content cover what this project needs?
- Report findings to the user:
  - Which systems have good coverage
  - Which systems have no skill or gaps relevant to this project
- If gaps exist: ask if they want online research to fill them. If yes, launch system-scout agent with the systems needing research and the approved plan. On return:
  1. Create or update knowledge skills from agent findings (SKILL.md + references/) — the knowledge skill is how a new system is registered
  2. Add any project-specific notes to the journal
- If all systems are sufficiently covered: confirm and proceed to Step 4.

### 4. Scaffold + Handoff
- Invoke project-scaffold to create the directory structure, CLAUDE.md, and settings.local.json
- Brief the user: what was set up, where the project lives, first next steps from the plan
- Ask whether to begin Phase 1 now.

Do not start execution until the user explicitly says to proceed.
