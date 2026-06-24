# Contributing

Thanks for your interest in improving the **`project`** plugin! Contributions are welcome.

## How to contribute

The `main` branch is protected, so all changes go through a pull request:

1. **Fork** this repository to your own GitHub account.
2. **Create a branch** for your change: `git checkout -b my-change`.
3. Make your edits.
4. **Validate** before submitting:
   - `claude plugin validate --strict project` (the plugin)
   - `claude plugin validate --strict .` (the marketplace manifest)
5. **Push** to your fork and **open a pull request** against `main` here.
6. A maintainer will review and merge.

For anything substantial, please **open an issue first** to discuss the approach.

## Project layout

- `project/` — the plugin itself (`.claude-plugin/plugin.json`, `skills/`, `agents/`, `hooks/`).
- `.claude-plugin/marketplace.json` — marketplace manifest so the plugin is installable.

See [`project/README.md`](project/README.md) for how the framework works.

## Guidelines

- Keep each pull request focused on one logical change.
- Match the existing style and structure of the skills/agents you touch.
- Bump the `version` in `project/.claude-plugin/plugin.json` when you change plugin behavior — the install cache is version-keyed.
- Never commit secrets, API keys, or personal absolute paths.

## Reporting issues

Open an issue describing the bug (with steps to reproduce) or the enhancement you'd like.

## License

By contributing, you agree that your contributions are licensed under this project's license: **MIT with the [Commons Clause](https://commonsclause.com/)** (see [LICENSE](LICENSE)). The software is free to use, modify, and share — including inside a commercial organization — but may not be sold or offered as a paid product or service without a commercial license. For commercial licensing, open an issue.
