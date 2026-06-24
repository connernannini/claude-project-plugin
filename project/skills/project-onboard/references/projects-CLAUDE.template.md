# Project Context Rules

Always-loaded rules for working on projects under this folder: how to track state
(journals), capture knowledge, save progress, and manage the project lifecycle.

## Critical Rules
- **Working directory check**: Identify the project first (check cwd for CLAUDE.md →
  `{CLAUDE_PROJECT_ROOT}/context/project-index.md` → ask the user). If cwd doesn't match the
  project's path: read-only actions may proceed (note the mismatch); before any action that
  writes project state, confirm the target project and recommend resuming from the correct
  path so its CLAUDE.md and guardrails load. Don't re-warn once acknowledged.
- **Data fetching**: Delegate bulk, paginated, or multi-step external reads to the `data-fetch`
  agent. Single-record lookups, small filtered queries (a single page), and status/auth checks
  run inline in the main thread.
- **Data modification**: Delegate external system writes and local data-file modifications to the
  `data-modify` agent. Exception — single-record, low-risk writes (one record update, one comment
  or note, one message to a channel the user named this turn) run inline: show the change, confirm,
  and append one line to the project's audit log (`audit-logs/session-writes.log`). Deletions,
  money-moving operations, bulk changes, or anything touching more than one record ALWAYS go
  through `data-modify`. When in doubt, delegate.
- **Saving project state**: When the user says "save", "checkpoint", or wants to preserve
  progress, ALWAYS use the project-save skill — it handles journal writes and index updates
  (`/project-save full` also runs the knowledge sweep via project-learn).

## Journal Write Triggers
Journal entries are how future sessions rebuild context. Write one (via journal-write) when:
- Data is pulled from, or changes are made to, an external system
- A non-trivial decision is made — capture what was chosen, rejected, and why
- Plan or scope changes
- An error or failure is encountered
- A phase or milestone completes
- The conversation exceeds ~15 exchanges without a checkpoint
- State would be costly to re-derive

## Knowledge Capture Triggers
Surface the finding conversationally and wait for approval before writing (via project-learn) when:
- The user corrects an assumption, states a rule, or expresses a preference
- A tool interaction reveals reusable knowledge — enums, gotchas, limits, side effects
- A multi-step workflow succeeds or a documented procedure proves incomplete
- A data-quality pattern is noticed — frequent nulls, inconsistent values, duplicate records
- An instruction or knowledge file is found wrong or incomplete

## Research Capture
Research is only useful later if it's written down. When Claude does substantial research — web research, a deep-dive investigation, multi-source analysis, or a heavy scan/audit — save a summarized writeup to the project's `research/` folder, not just the chat:
- Write a synthesis with source links (URLs, file paths, ticket IDs), not a raw dump. Raw pulls belong in `data_raw/`; deliverables in `outputs/`.
- For heavy scans, audits, or builds run as subagents or workflows, return only a summary to the main thread — the full artifact lands in `research/`.
- Use a descriptive, dated filename (e.g., `vendor-landscape-2026-06-22.md`).

## Behavioral Rules
- **Task tracking**: Use TodoWrite for any work involving 3+ steps.
- **Scripts**: Save generated scripts in the project's `scripts/` folder, not temp directories.
- **Working data**: Raw external pulls go in `data_raw/`; data you transform or derive locally goes in `data_manipulated/`.
- **Plan management**: When a phase completes or scope changes, draft plan updates and present
  for approval before saving.
- **Knowledge file size cap**: 12K chars → warn before adding more. 15K → stop; offer prune,
  split, or promote.
- **Project creation**: Wait for user agreement before creating project dirs, journals, or
  plans. Suggest a project when work is multi-step or benefits from state persistence.
- **One project per session**: If the user asks to switch, save first, then recommend a new
  session. Exception: `/project-status` can report across projects.

## Credentials
Source secrets from your configured secrets location; never read API-key files directly with the
Read tool (this is often hook-enforced). Onboarding records your location below.
- **Secrets location**: `~/.config/{system}/.env`  <!-- onboarding updates this if you store keys elsewhere -->

**REMEMBER:**
- Route bulk/multi-step external reads through `data-fetch` and external writes through
  `data-modify`; small reads and confirmed single-record low-risk writes (audit-logged) run inline.
- "save"/"checkpoint" → project-save; don't hand-write journals or the index.
- Check the journal-write and knowledge-capture triggers after completing work or decisions.
- Verify the working directory matches the project before writing project state.
