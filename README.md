# project — a project-management framework for Claude Code

A portable Claude Code plugin that gives Claude durable memory and a workflow for multi-session
work: guided kickoff, automatic journaling, knowledge capture, and save/resume across sessions.

Full documentation: [`project/README.md`](project/README.md).

## Install

```
claude plugin marketplace add connernannini/claude-project-plugin
claude plugin install project@claude-project-plugin
```

Then run `/project-onboard` to set up, and `/project-kickoff` to start your first project.

New here? Follow the [getting-started walkthrough](project/docs/getting-started.md).

## What's inside

- **9 lifecycle skills** — onboard, kickoff, scaffold, save, resume, status, complete, learn, journal-write
- **4 agents** — data-fetch, data-modify, environment-scanner, system-scout (optional, for data-heavy work)
- **Secret-protection hooks** — keep API-key files from being read into the conversation
- A single Markdown **project index** plus per-project plan and journal files as durable memory

See [`project/README.md`](project/README.md) for the full picture.

## License

Source-available under the **MIT License with the [Commons Clause](https://commonsclause.com/)** —
see [LICENSE](LICENSE). Free to use, modify, and share (including inside a commercial
organization), but you may **not sell it** or offer it as a paid product or service whose value
derives substantially from this software without a commercial license. For commercial licensing,
open an issue on this repository.
