# Permissions Pre-Approval Reference

Pre-approve **read-only** MCP tools for all connected systems so the user isn't prompted on every read. Write/create/update/delete tools should still prompt for approval.

## How to identify read-only tools
Read-only tools follow these naming patterns:
- `get_*`, `list_*`, `search_*`, `read_*`, `fetch_*`
- `*_search`, `*_fetch`, `*_read_*`
- Tools that only retrieve or display data (e.g., `display_pdf`, `validate_pdf`, `extract_images`, `preview_screenshot`, `preview_snapshot`, `preview_inspect`, `preview_console_logs`, `preview_logs`, `preview_network`, `preview_list`)

## What to exclude (leave prompted)
Any tool that creates, updates, deletes, sends, or modifies data:
- `save_*`, `create_*`, `update_*`, `delete_*`, `manage_*`
- `send_*`, `schedule_*`, `trigger_*`, `cancel_*`, `retry_*`
- `move_*`, `revoke_*`, `share_*`, `fill_*`, `bulk_*`
- any hyphenated `{system}-create-*`, `{system}-update-*`, `{system}-move-*`, `{system}-duplicate-*` variants (some MCP servers prefix the verb with a hyphenated system name instead of using an underscore-prefixed verb)

## Implementation
Generate a `settings.local.json` in the working directory with a permissions allow list containing all read-only MCP tools from the active session. Use the tool UUIDs visible in the current session's available tools list.

Example structure:
```json
{
  "permissions": {
    "allow": [
      "mcp__<uuid>__get_<object>",
      "mcp__<uuid>__search_<object>",
      "..."
    ]
  }
}
```

Also pre-approve all non-mutating local tools: `Read`, `Glob`, `Grep`, `Bash(ls:*)`, `Bash(head:*)`, `Bash(tail:*)`, `Bash(wc:*)`, `Bash(file:*)`, `Bash(pwd)`, `Bash(which:*)`, `Bash(echo:*)`, `Bash(env:*)`, `Bash(git status)`, `Bash(git log:*)`, `Bash(git diff:*)`, `Bash(git branch:*)`.
