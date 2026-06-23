# Knowledge Capture Taxonomy

The authoritative reference for all knowledge categories. Used by:
- **Capture mode** — read on demand when a knowledge finding surfaces during project work
- **Sweep mode** — read during Step 2 for the comprehensive scan across all categories

## Contents

**Meta rules:**
- [Routing Principles](#routing-principles) — where each finding type goes by default
- [Before Persisting](#before-persisting) — dedup check + new-system detection
- [Section-Level Timestamps (MANDATORY)](#section-level-timestamps-mandatory) — `*Last updated:*` convention for staleness detection

**Knowledge categories:**
- [Category 1: Reference Data / Enumerations](#category-1-reference-data--enumerations) — ID-to-label mappings, stable lookup values
- [Category 2: Tool Execution Patterns](#category-2-tool-execution-patterns) — API approaches, numeric limits, side effects
- [Category 3: System Relationships](#category-3-system-relationships) — entity chains, lookup patterns, cross-system dependencies
- [Category 4: Business Rules](#category-4-business-rules) — how the business or a system works
- [Category 5: Process Refinements](#category-5-process-refinements) — repeatable procedures found incomplete, ambiguous, or wrong
- [Category 6: Anti-Patterns / Gotchas](#category-6-anti-patterns--gotchas) — tool/system quirks discovered through execution
- [Category 7: Workflow Patterns](#category-7-workflow-patterns) — multi-step/multi-tool approaches that work well
- [Category 8: Instruction Gaps](#category-8-instruction-gaps) — gaps in CLAUDE.md, context files, skill definitions
- [Category 9: User Preferences](#category-9-user-preferences) — how the user wants Claude to behave
- [Category 10: Referenced File Accuracy](#category-10-referenced-file-accuracy) — file contradicts what the session proved
- [Category 11: Cross-Project Attribution](#category-11-cross-project-attribution) — work outside current project's scope
- [Category 12: Assumptions Corrected](#category-12-assumptions-corrected) — user corrects something Claude assumed
- [Category 13: Data Quality Observations](#category-13-data-quality-observations) — recurring data quality issues
- [Category 14: Decision Rationale](#category-14-decision-rationale) — trade-offs explicitly discussed
- [Category 15: Technical Methods](#category-15-technical-methods) — reusable methodology across systems

## Routing Principles

- Facts about how a system works (data model, naming, field behavior, relationships) → **domain file** as the primary reference. Other files should reference, not duplicate.
- Execution knowledge (API approaches, workarounds, tool behavior) → **tools file**
- Repeatable procedures → kept in the project; if broadly reusable, graduated into a **skill** (no shared runbook store)
- Reusable technical methodologies (not system-specific, not business-domain-specific) → **techniques file**
- When capturing time-sensitive facts (rate limits, API behaviors, pricing), include "*(as of {datetime})*"

### SKILL.md vs references/ — default to references/

SKILL.md is the always-loaded entry point for a skill. It must stay stable and small. Findings go to `references/` files, not SKILL.md.

- **ALWAYS** route new findings (gotchas, code examples, query patterns, enums, macro quirks, tool behaviors) to `references/{tools,domain,enums}.md` per the category routing below.
- **ONLY edit SKILL.md when**:
  - Adding a pointer line to the References section because a new reference file was created, OR
  - The finding is universal (affects every session, not tactical), AND it fits an existing top-level rule list, AND no references file would be a better home.
- **NEVER** add new code blocks, new sections, new gotchas, or new examples to SKILL.md as a default destination. If unsure, route to references.
- If a SKILL.md already has tactical content (e.g., a "Top Gotchas" section with macro-specific entries), that's a structural debt — flag it, don't expand it.

## Before Persisting

Check the target file first — don't propose something already captured. If a file doesn't exist yet (e.g., first time working with a system), create it following existing patterns.

### New System Detection

When a finding routes to `~/.claude/skills/{system}/` and that skill directory doesn't exist:
- Create the skill directory with a stub SKILL.md + `references/tools.md` following the standard knowledge skill pattern (see any existing system skill for the template) — the knowledge skill is how a new system is registered

When a finding involves a system you don't yet have a knowledge skill for, and it contains enough reusable knowledge to justify one, propose creating it.

## Section-Level Timestamps (MANDATORY)

Every H2 section (`##`) in a knowledge file must have a `*Last updated: {datetime}*` line immediately after the heading. When `/project-learn` or real-time capture writes to a section, update that section's timestamp. When creating a new section, add the timestamp. This enables granular staleness detection — staleness checks can flag individual stale sections, not just stale files. Format:
```
## Known Gotchas
*Last updated: 2026-03-24 14:30*
```
Applies to all knowledge files: `~/.claude/skills/{s}/references/tools.md`, `~/.claude/skills/{s}/references/domain.md`, `~/.claude/skills/{s}/references/enums.md`.

---

## Category 1: Reference Data / Enumerations
- **Trigger**: Lookup values pulled from external systems (status codes, category labels, stage names, type IDs, or any stable ID-to-meaning mapping)
- **Route to**: `~/.claude/skills/{system}/references/enums.md`
- **Special rules**: For additions (a new value), update automatically and notify. For changes or removals (a renamed or deactivated value), flag to the user first — may signal a business process change.

## Category 2: Tool Execution Patterns
- **Trigger**: Non-obvious API approaches used (batch endpoints, specific parameters, workarounds); numeric limits discovered (rate limits, pagination caps, batch sizes, timeouts); unexpected side effects from external system actions (triggered workflows, sent notifications, changed related records)
- **Route to**: `~/.claude/skills/{system}/references/tools.md`
- **Routing distinction**: Facts about how to *query or interact* with the system (API patterns, pagination, batch sizes, rate limits) → `tools.md`. Facts about what the *product itself* does or doesn't support (features, AI models used, plan limitations) → `domain.md`.
- **Capture specifics**: The exact numbers, not just "use pagination"
- **Boundary**: Single-tool patterns only. Multi-step or multi-tool workflows belong in Category 7.

## Category 3: System Relationships
- **Trigger**: Relationship chains or lookup patterns discovered (e.g., "go through X to find Y"); entity relationship semantics clarified; cause-and-effect relationships between systems discovered ("When X changes, Y breaks", "Z depends on W being run first", "updating A triggers workflow B")
- **Route to**: `~/.claude/skills/{system}/references/domain.md` (structural relationships) or `~/.claude/skills/{system}/references/tools.md` (behavioral dependencies that affect execution)
- **Note**: Covers both structural relationships (entity chains, data model) and behavioral dependencies (triggers, side effects across systems).

## Category 4: Business Rules
- **Trigger**: User proactively states how something should work ("never do X", "always do Y"); user clarifies a process that applies beyond this one task
- **Route to**:
  - System-specific rule → `~/.claude/skills/{system}/references/domain.md`
  - Cross-system rule → `~/.claude/skills/{domain}/references/domain.md`
  - Project-specific process or procedure → keep it in the project's own files; if it becomes broadly reusable, propose turning it into a skill
- **Boundary**: How the *business or system* works. If the user is correcting a specific mistake Claude made, that's Category 12. If the user is expressing a preference for how Claude should behave, that's Category 9.

## Category 5: Process Refinements
- **Trigger**: A repeatable procedure is found to be incomplete, ambiguous, or wrong; actual execution deviates from a documented process; new lessons learned while running a procedure
- **Route to**: If the procedure is project-specific, update it in the project's own files. If it is broadly reusable across projects, propose turning it into a skill (see [New System Detection](#new-system-detection)) rather than a shared procedure doc.
- **Note**: This framework keeps no shared runbook store — reusable procedures graduate into skills.

## Category 6: Anti-Patterns / Gotchas
- **Trigger**: A tool or system behaves unexpectedly — quirks, undocumented behavior, things that don't work the way you'd expect. Discovered through execution, not user correction.
- **Route to**: `~/.claude/skills/{system}/references/tools.md` under the "Known Gotchas" section. For cross-system failures, route to the most relevant system's tools file.
- **Routing distinction**: Gotchas in *tool execution* (unexpected API behavior, parameter quirks, query failures) → `tools.md`. Product-level limitations discovered during execution (feature doesn't exist, capability not available on plan tier) → `domain.md`.
- **Capture**: What was tried, why it failed, what to do instead
- **Boundary**: Quirks discovered by *doing*. If the *user* tells you something is wrong, that's Category 12 (Assumptions Corrected).

## Category 7: Workflow Patterns
- **Trigger**: A multi-step or multi-tool approach works particularly well; a procedure involved 4+ steps worth capturing for reuse
- **Route to**: System-specific execution patterns (including batch read/write patterns) → `~/.claude/skills/{system}/references/tools.md` under "Execution Patterns" — the data-fetch and data-modify agents read these at run time; refer to those agents by name, never write into their definition files. Detailed repeatable procedures → if project-specific, document in the project; if broadly reusable, propose a new skill.
- **Boundary**: Multi-step or multi-tool workflows only. Single-tool patterns belong in Category 2.

## Category 8: Instruction Gaps
- **Trigger**: Gaps found in CLAUDE.md files, context files, or skill definitions; new rules added during the session that other files should reference
- **Route to**: The file with the gap
- **Note**: Instruction improvements already made during the session should be verified as complete, not re-proposed

## Category 9: User Preferences
- **Trigger**: User expresses a preference for how data should be presented, how work should be done, or how tools should be used
- **Route to**: `~/.claude/CLAUDE.md` (Communication Preferences or Working Style)
- **Boundary**: How the *user wants Claude to behave*. If the user is stating how the business works, that's Category 4.

## Category 10: Referenced File Accuracy
- **Trigger**: The session *actually revealed* that a referenced file contains outdated or incorrect information — not just that a file was read and might be stale
- **Route to**: The affected file
- **Note**: Only fire when there's a concrete contradiction between what the file says and what the session proved. Do not speculatively scan all referenced files for potential staleness.

## Category 11: Cross-Project Attribution
- **Trigger**: Work done this session that falls outside the current project's scope — changes to skill definitions, global CLAUDE.md rules, shared infrastructure not driven by the current project, or new initiatives that emerged mid-session
- **Action**:
  - Check `{CLAUDE_PROJECT_ROOT}/context/project-index.md` for an existing project it belongs to
  - If found, propose adding a journal entry to that project
  - If not found, recommend `/project-kickoff` in a new session

## Category 12: Assumptions Corrected
- **Trigger**: The user corrects something Claude assumed — about a tool, a process, a data model, or anything else. "No, that field means Y not X." "That's not how we do it."
- **Route to**: `~/.claude/skills/{system}/references/domain.md` (data model facts) or `~/.claude/skills/{system}/references/tools.md` (tool behavior)
- **Capture**: What was assumed, what was actually true, why the assumption was wrong
- **Boundary**: The *user* tells you something is wrong. If the *system* proves you wrong during execution (API error, unexpected result), that's Category 6.

## Category 13: Data Quality Observations
- **Trigger**: Recurring data quality issues (fields frequently null, records duplicated, values inconsistent, data not matching expectations)
- **Route to**: `~/.claude/skills/{system}/references/domain.md` under a "Data Quality Notes" section
- **Capture specifics**: What field, what frequency, what workaround is needed

## Category 14: Decision Rationale
- **Trigger**: Trade-offs explicitly discussed between approaches; a non-obvious choice made that a future session might question or re-evaluate
- **Route to**: `~/.claude/skills/{system}/references/tools.md` (execution decisions) or `~/.claude/skills/{system}/references/domain.md` (data model decisions)
- **Capture as**: "Chose {approach} over {alternatives} because {constraints}. Revisit if {conditions change}."
- **Note**: Different from anti-patterns — this captures things *considered and deliberately chosen*, not things *tried and failed*

## Category 15: Technical Methods
- **Trigger**: Reusable methodology discovered or refined that applies across systems and projects — algorithms, scoring frameworks, analytical approaches, data processing techniques, statistical methods
- **Route to**: `~/.claude/skills/{domain}/references/{topic}.md` — a cross-cutting techniques/methods knowledge skill you maintain (create one per [New System Detection](#new-system-detection) if it doesn't exist)
- **Boundary**: How to solve a *class of problem*, not tied to a specific system. System-specific execution patterns stay in `~/.claude/skills/{system}/references/tools.md`. Business rules stay in `~/.claude/skills/{system}/references/domain.md`. If the method only applies to one system, it belongs in that system's `references/tools.md` instead.
- **Note**: Cross-cutting techniques live under your methods/techniques skill's references. Add a row to that skill's techniques table when creating a new one.
