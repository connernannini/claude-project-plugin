# Discovery Sources Reference

Complete inventory of local data sources the environment scanner checks during onboarding. Organized by priority. Not every user will have all sources — the scanner skips silently if a source doesn't exist.

## Path Constants

- `DESKTOP_DATA`: `~/Library/Application Support/Claude/`
- `CODE_HOME`: `~/.claude/`
- `COWORK_SESSIONS`: `~/Library/Application Support/Claude/local-agent-mode-sessions/`

The Cowork session directory uses org and user UUIDs as path segments. These vary per user. Use glob patterns (e.g., `local-agent-mode-sessions/*/*/`) to discover them dynamically.

---

## Priority A: Direct Reads (Single Parallel Batch)

All of these are small files read in one parallel round trip.

### A1. Global CLAUDE.md
- **Path**: `~/.claude/CLAUDE.md`
- **Extract**: Role, name, title, company, responsibilities, tech stack, communication preferences, working style, domain knowledge
- **Notes**: Richest single source if it exists. Code users often have this well-populated. Cowork-only users likely won't have it.

### A2. Claude Desktop Config
- **Path**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Extract**:
  - `mcpServers` — Locally configured MCP servers (shows systems connected outside built-in connectors)
  - `preferences.localAgentModeTrustedFolders` — Folders granted to Cowork (reveals working directories)
  - `preferences.sidebarMode` — Default surface: "code", "cowork", or "chat"
  - Feature flags: `coworkScheduledTasksEnabled`, `coworkWebSearchEnabled`, `bypassPermissionsModeEnabled` (power-user signals)

### A3. Installed Desktop Extensions
- **Path**: `~/Library/Application Support/Claude/extensions-installations.json`
- **Extract**: Extension names, descriptions, tool lists from manifests. Map to systems (e.g., a {system} extension → they use {system}).

### A4. Claude Code Settings
- **Path**: `~/.claude/settings.json` and `~/.claude/settings.local.json`
- **Extract**: Permissions, hooks (show automated workflows), environment variables.

### A5. Claude Code Stats Cache
- **Path**: `~/.claude/stats-cache.json`
- **Extract**: Daily activity counts (messages, sessions, tool calls). Shows usage frequency and trends.

### A6. Cowork Skills Manifest
- **Path**: `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/*/*/manifest.json`
- **Extract**: Skill names, `creatorType` (user-created skills are especially informative — show automated workflows).

### A7. Cowork Installed Plugins
- **Path**: `~/Library/Application Support/Claude/local-agent-mode-sessions/*/*/cowork_plugins/installed_plugins.json`
- **Extract**: Plugin names and versions.

---

## Priority B: Cowork Session Metadata (Batch-Processed)

This is the highest-volume source. Extracted via a single python3 script running in parallel with Priority A reads.

### B1. Cowork Sessions
- **Path pattern**: `~/Library/Application Support/Claude/local-agent-mode-sessions/*/*/local_*.json`
- **Format**: JSON (one file per session, 50KB-500KB each — do NOT read individually)
- **Extraction method**: Single python3 script that globs all files and extracts only lightweight metadata fields:
  - `title` — Auto-generated session title
  - `initialMessage` — First user prompt (truncated to 200 chars)
  - `model` — Which model was used
  - `createdAt` — When the session happened
  - `enabledMcpTools` — What tools were active
  - `remoteMcpServersConfig` — MCP server names
  - `userSelectedFolders` — Folders they gave access to
- **Aggregation**: Task categories from titles, model frequency, tool frequency, usage date range, session count

---

## Priority C: Low-Priority (Only if A+B are sparse)

### C1. Code Project Memory
- **Path**: `~/.claude/projects/*/memory/MEMORY.md`
- **Extract**: Memory indexes and referenced files for role/preference signals

### C2. Code History Index
- **Path**: `~/.claude/history.jsonl`
- **Extract**: Project paths and timestamps (shows what directories they work in)

### C3. Shell History
- **Path**: `~/.zsh_history` or `~/.bash_history`
- **Extract**: Lines containing "claude" only. Shows how they invoke Claude Code.
- **Privacy**: Only extract claude-related lines.

---

## Deduplication Rules

Same information often appears in multiple sources. Priority order:
1. **User's explicit statements** (from conversation) — always wins
2. **`~/.claude/CLAUDE.md`** — curated, intentional
3. **Cowork session metadata** — recent actual usage
4. **Desktop config / extensions** — configured but may not reflect current usage
5. **Auto-memory files** — may be stale

For systems/tools, merge all sources into a single deduplicated list. Use friendly names (e.g., "{system}" not "mcp__uuid__{system}").

## What NOT to Scan

- `IndexedDB/` — Binary LevelDB, not parseable
- `Cookies`, `DIPS`, `Trust Tokens` — Browser internals
- `sentry/` — Crash reports
- `~/.claude/debug/`, `shell-snapshots/`, `session-env/`, `telemetry/` — Transient/noisy
- macOS Keychain — Sensitive, not useful
- Full conversation content from Cowork sessions — Too large, metadata is sufficient
