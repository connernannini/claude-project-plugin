# Project Directory Template

## Structure
All projects live under `{CLAUDE_PROJECT_ROOT}/`. Create:

```
{CLAUDE_PROJECT_ROOT}/{project-name}/
├── CLAUDE.md                    # Project-specific instructions and guardrails
├── project-plan.md              # The approved plan from kickoff
├── journal.md                   # Auto-maintained session log
├── inputs/                      # Source data, uploaded files, exports
├── outputs/                     # Deliverables, reports, formatted results
├── data_raw/                        # Raw data pulled from external systems
├── data_manipulated/           # Data you transformed or derived locally (not a raw pull)
├── research/                   # Summarized research findings with source links
├── scripts/                     # Generated scripts (per projects CLAUDE.md convention)
├── audit-logs/                  # Audit trail of external-system writes (data-modify agent + inline writes)
└── .claude/
    └── settings.local.json      # MCP tool permissions for this project
```

Note: Per-project Reference.md files are no longer created. System and domain knowledge auto-loads when relevant. Project CLAUDE.md should note which systems are involved.

## CLAUDE.md Content
Generate a project-specific CLAUDE.md that includes:
- Project objective (one sentence)
- Which systems are involved (system knowledge auto-loads when relevant)
- Compressed plan: phase checklist with checkboxes, active phase marked with <- ACTIVE, and a directive to read project-plan.md for the active phase's details before starting work
- Key constraints (irreversibility, rate limits, etc. — only things that affect every session)
- User context: "The user is experienced with SaaS tools but is not a software developer. Use plain language. Never show raw code unless asked. Confirm before any action that modifies external systems."

Example compressed plan format:
```
## Plan (see project-plan.md for details)
- [x] Phase 1: Research & Design
- [ ] Phase 2: Build Detection Logic  <- ACTIVE
- [ ] Phase 3: Human-in-the-Loop Merge
Read project-plan.md Phase 2 before starting work.
```

During execution, update the checkboxes and active marker as phases complete. This keeps CLAUDE.md as the always-loaded progress tracker while project-plan.md holds the detailed instructions.

## settings.local.json
Generate a permissions file that whitelists only the MCP tools needed for this project:
```json
{
  "permissions": {
    "allow": [
      "mcp__{UUID}__{tool_name}"
    ]
  }
}
```

## Journal Initialization
`journal.md` is created during kickoff's Step 1 (Discover) — as soon as the project directory is confirmed — and updated at each phase transition. By the time scaffolding runs, the journal already contains discovery answers, tool validation results, and the project plan.

During scaffolding, append a "Scaffolding Complete" entry:
```markdown
## Scaffolding Complete — {date} {time}
**Phase**: Project Setup
**Summary**: Plan approved. Directory scaffolded. Ready for execution.
**Key decisions to preserve**:
- [list key decisions from discovery and planning — include the reasoning, not just the choice]
**Next Steps**:
- [first actionable items from the project plan]
```

## Output Stubs
Create the `inputs/`, `outputs/`, `data_raw/`, `data_manipulated/`, `research/`, `scripts/`, and `audit-logs/` directories. Do not create placeholder files — deliverables will be added during project execution.

## Important: Persist State Proactively
Journal write triggers (per CLAUDE.md) apply throughout scaffolding. Capture decisions as they happen.
