# Getting started

A walkthrough of using **`project`** end to end — from first-time setup through finishing a
project. Assumes the plugin is installed (`claude plugin install project@claude-project-plugin`).

> **One idea to hold onto:** the framework figures out which project you're working on from the
> folder your session is open in. Start each session in the project's folder, and the right
> context loads automatically.

## 1. One-time setup

```
/project-onboard
```

It asks where you keep your projects (point it at an existing folder or let it create one), drops
the framework's always-on rules there, and creates a starter **project index** — the master list
of everything you'll work on. You only do this once per machine.

## 2. Start a project

Each project gets its **own folder** under your projects root. **Create the folder first, then open
a new session in it** and run kickoff there — that's what keeps everything in one session:

1. Make a new folder for the project under your projects root (for example, `sales-dashboard`).
   You can place it inside a category folder if you like — e.g. `clients/acme` — nested to any depth.
2. Open a new session in that folder.
3. Run `/project-kickoff`.

A project is simply wherever its own folder sits under the root; the index keeps the flat list
across all of them.

Kickoff then walks you through:

- **Discovery** — a few questions about what you're trying to do, which systems are involved, and
  the inputs and outputs.
- **A written plan** — it drafts a phased plan and waits for your approval before doing anything
  else.
- **Scaffolding** — on approval, it builds out the project's files (`CLAUDE.md`, `project-plan.md`,
  `journal.md`, and the working subfolders) right in that folder, and adds a row to the project
  index.

It also checks for **prior projects** that touched the same systems, so you start with whatever
they already learned.

## 3. Do the work

Open the project's folder and just work. As you go, the framework keeps state for you:

- **Journaling is automatic** — decisions, data pulls, errors, and milestones get logged to
  `journal.md` so a future session can rebuild context. You don't have to ask.
- **Knowledge capture** — when something reusable surfaces (a gotcha, a limit, a rule), Claude
  offers to save it for future projects. Nothing is saved without your OK.
- **Data work (optional)** — if you've connected external systems, bulk reads route through the
  `data-fetch` agent and writes through `data-modify`, which keeps an audit trail.

## 4. Save anytime

```
/project-save           # quick: writes a checkpoint journal entry + updates the index
/project-save full      # also runs a knowledge sweep
```

Save whenever you want a checkpoint — it's fast and non-disruptive. Save and keep going.

## 5. Come back later

Open a new session in the project's folder, then run:

```
/project-resume
```

It reads the plan and journal and briefs you: where you left off, what's next, and any blockers —
then you keep going.

Not sure where you are across everything?

```
/project-status         # a one-line status for every project
```

## 6. Finish

```
/project-complete
```

This distills the journal into a summary, captures any final reusable patterns, marks the project
**Complete** in the index, and archives it.

## A few tips

- **Work from the project's folder.** It's how every skill knows which project you mean. Run a
  skill from the wrong place and Claude warns you before writing anything.
- **One project per session.** Switching projects mid-session? Save first, then start a fresh
  session in the other folder.
- **Everything is plain Markdown** under your projects folder — you can read or edit any of it
  yourself.

---

For the full picture of how the framework is built, see the [README](../README.md).
