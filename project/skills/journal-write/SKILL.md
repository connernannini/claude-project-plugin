---
name: "journal-write"
description: >
  How to write project journal entries. TRIGGER when a journal entry needs to be
  written — e.g., "write to journal", "log this", or when CLAUDE.md journal
  triggers fire. User "save"/"checkpoint" requests route to project-save, which
  calls this skill.
user-invocable: false
---

# Journal Write

How to write journal entries for project state persistence. Entries are the primary way future sessions rebuild context — without them, progress is lost.

Write immediately when triggered — don't batch entries to end of session.

## How to Write

Append to the project's `journal.md`. Keep user-facing output to a one-line confirmation — don't display the full entry in conversation.

If the entry marks a phase complete, flag that `project-plan.md` may need updating. Present the plan update for user approval before saving.

**Timestamp format**: write `{datetime}` stamps as `YYYY-MM-DD HH:MM` (local) — run `date "+%Y-%m-%d %H:%M"` to get the current time; never guess it.

### Standard Entry

```markdown
## {datetime} — {title}
**Phase**: {current phase from project-plan.md}
**Status**: {what's done, in progress, blocked}

**What was done**:
- {accomplishments}

**Key decisions**:
- {decisions that must survive context compaction — include reasoning, not just the choice}

**Files created/modified**:
- {list}

**Issues encountered**:
- {problems and resolutions, or "None"}

**Next steps**:
- {what to do next}
```

### Checkpoint Variant

Use when checkpointing mid-session (proactive persistence). Add `(checkpoint)` to the title:

```markdown
## {datetime} — Session checkpoint
```

Keep it lighter — focus on decisions, open questions or blockers, and state that would be lost if the session ended now.

### Completion Variant

Use when a project completes. Replace Next Steps with:

```markdown
**Patterns extracted**: {yes/no — which files}
**Gotchas captured**: {yes/no — which files}
**Tool knowledge updated**: {yes/no — which files}
```
