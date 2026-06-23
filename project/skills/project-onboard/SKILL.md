---
name: "project-onboard"
description: >
  First-run setup for the project-management framework. Establishes the project
  root, installs the trigger-layer instructions and the starter project index,
  registers detected systems, and pre-approves read-only tools. TRIGGER when the
  user says "set me up", "onboard", "get started", or on first run.
---

# Project Onboarding

Sets up the project-management framework in the user's chosen folder: establishes
where projects live, installs the trigger-layer instructions, and creates the
starter project index. Purely structural — it does NOT store personal role or
communication-style profiles, and never touches the user's global `~/.claude/CLAUDE.md`.

> Paths below use `{CLAUDE_PROJECT_ROOT}` = your projects folder (it directly holds each project's subfolder and a `context/` folder — never append `/projects/`). Resolve it as:
> `$CLAUDE_PROJECT_ROOT` env var → else the path in `~/.claude/project-root` → else run `/project-onboard` (not set up yet).

## Already onboarded?
If `~/.claude/project-root` exists (or `$CLAUDE_PROJECT_ROOT` is set), setup already ran.
Tell the user where it points and ask whether they want to re-run before proceeding.

## Step 0: Establish the project root
1. **If `$CLAUDE_PROJECT_ROOT` is set** (Cowork/container): use it, confirm, and skip the
   pointer file — the environment already provides the location.
2. **Otherwise, ASK FIRST**: "Do you already have a folder where you keep your projects or
   work? If so, give me the path and I'll set the framework up there. Otherwise I'll create one."
   - **Existing folder** → use that path as the root.
   - **None** → create one, default `~/claude-projects` (let them confirm/rename).
3. Create the root if needed, plus a `context/` subfolder — skipping either if it already
   exists. (The root IS the projects folder; individual project subfolders are created later,
   by kickoff.) Never delete or overwrite.
4. Write the absolute root path (one line) to `~/.claude/project-root`. This pointer is how
   every skill finds "home."

## Step 1: Scan the environment (optional, absence-tolerant)
Launch the **environment-scanner** agent (by name) in the foreground with `model: "sonnet"`.
- Useful signal → use it for systems (Step 3) and permissions.
- Little/nothing → say so plainly and continue. The scan is a convenience, not a requirement.

## Step 2: Confirm detected systems
Briefly list detected systems/tools; ask the user to confirm or add. One round only.
Do NOT ask about role, title, or communication style.

## Step 3: Install the framework  (check-then-create; nothing overwritten)

### Trigger-layer instructions
Copy the bundled template `references/projects-CLAUDE.template.md` to
`{CLAUDE_PROJECT_ROOT}/CLAUDE.md` **only if one isn't already there**. (This is the
framework's project-context ruleset — journal triggers, knowledge capture, delegation routing.)
If a `CLAUDE.md` already exists there, leave it and tell the user — their own instructions are
never clobbered.

**Secrets location**: ask the user where they keep API keys / environment variables
(default `~/.config/{system}/.env`). Do two things with their answer — it is a path only,
never the secret values:
1. Record it in the freshly-copied CLAUDE.md's Credentials section (the `Secrets location:`
   line). The `data-fetch` / `data-modify` agents read this to know where to source credentials.
2. Write it as a glob (one line) to the pointer file `~/.claude/project-secrets-path`,
   replacing any system-name placeholder with `*` (e.g. `~/.config/{system}/.env` →
   `~/.config/*/.env`). The bundled secret-blocking hooks read this pointer to know which
   files to protect from being read directly; if it is absent they fall back to the
   `~/.config/*/.env` convention.

### Starter bookkeeping file  (from `references/bookkeeping-templates.md`, only if missing)
- `{CLAUDE_PROJECT_ROOT}/context/project-index.md`

### Knowledge skills
For each confirmed system, check `~/.claude/skills/{system}/SKILL.md`: has content → skip;
stub → note, don't modify (kickoff fills it); missing → create a minimal stub (correct
frontmatter, one-line description, empty `references/`) so kickoff can find and fill it later.

### Permissions
Per `references/permissions-template.md`: if `~/.claude/settings.local.json` does NOT exist,
create it pre-approving read-only MCP tools; if it exists, merge new read-only permissions
without overwriting existing entries.

## Step 4: Wrap up
Tell the user:
> "You're set up. Your projects live under `{CLAUDE_PROJECT_ROOT}/`. To start your
> first project, create a folder there and run `/project-kickoff` from it."

No frontmatter self-mutation — the `~/.claude/project-root` pointer's existence marks onboarding
complete (see "Already onboarded?").

## Intermediate state persistence
If the conversation runs long (~15+ exchanges) or the scan finished before setup completed,
write progress to `~/.claude/_onboard-progress.md`; delete it once setup is done.

## Dependencies
**Writes** (user-scope pointers, outside the projects folder): `~/.claude/project-root` (Step 0,
the projects-folder location) and `~/.claude/project-secrets-path` (Step 3, the secrets glob the
bundled secret-blocking hooks read). Both hold paths only — never secrets.
**Delegates to**: the `environment-scanner` agent (environment scan).
**References**: `references/projects-CLAUDE.template.md` (generic trigger-layer dropped at
`{root}/CLAUDE.md`), `references/bookkeeping-templates.md` (starter files),
`references/permissions-template.md` (permission classification), `references/discovery-sources.md`
(scanner source inventory).

## What this skill does NOT do
- Touch the user's global `~/.claude/CLAUDE.md` (ever).
- Store role, title, or communication-style preferences.
- Overwrite an existing trigger-layer `CLAUDE.md`, bookkeeping file, or `settings.local.json` — merge or skip only.
- Set up or test tool connections (that's kickoff's job).
- Store secrets or sensitive data.
