# Connectors

## How tool references work

Plugin files use `~~category` as a placeholder for whatever tool the user connects in that
category. For example, `~~external system` means any tool — a project tracker, a CRM, a data
warehouse, a database, an internal API — that exposes an MCP server.

This plugin is **tool-agnostic**. The core project-management workflow (kickoff, journaling,
knowledge capture, save/resume) is pure Markdown and needs **no connectors at all** — install it
and it works immediately.

Connectors only matter for the *optional* data agents (`data-fetch`, `data-modify`), which read
from and write to external systems on your behalf. If you never connect an external system, you
can ignore or remove those two agents; the lifecycle skills are unaffected.

## Connectors for this plugin

| Category | Placeholder | Included servers | Other options |
|----------|-------------|------------------|---------------|
| External system (read) | `~~external system` | _none pre-configured_ | Any MCP server — a project tracker, CRM, data warehouse, messaging tool, doc store, a database, an internal API, etc. |
| External system (write) | `~~external system` | _none pre-configured_ | Same as above — used only by `data-modify`, with approval and an audit-log trail |

This plugin **does not bundle a `.mcp.json`** and pre-configures no specific servers. Connect
whatever systems you use through Claude's normal connector / MCP setup, and the data agents will
work against them generically.

## Credentials

The data agents never read secret values into the conversation. During `/project-onboard` you tell
the framework **where** your API keys live (a path only — e.g. `~/.config/<system>/.env`), and that
location is recorded in two places:

- your projects `CLAUDE.md` Credentials note (so the agents know where to source from), and
- `~/.claude/project-secrets-path` (so the bundled secret-blocking hooks know which files to keep
  out of plain reads).

Secrets are always **sourced**, never read — two PreToolUse hooks (`block-secret-read.sh`,
`block-secret-bash-read.sh`) enforce this so key values can't leak into context.
