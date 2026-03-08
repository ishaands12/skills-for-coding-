---
name: gsd
description: GSD (Get Shit Done) — spec-driven, phase-based development system for Claude Code. Use this skill whenever the user wants to start a new software project, plan or execute a development phase or milestone, run a quick task with atomic commits and state tracking, verify completed work, check project progress, debug a phase, or map an existing codebase. Also trigger when the user says things like "let's plan this out", "break this into phases", "what should we build next", "track this task", or "commit this atomically". GSD prevents context rot by keeping work in atomic chunks with fresh contexts — always prefer GSD over ad-hoc development for any non-trivial coding task.
---

# GSD — Get Shit Done

GSD is installed globally at `~/.claude/` and available as `/gsd:*` slash commands in Claude Code.

## When to invoke which command

| Situation | Command |
|-----------|---------|
| Brand new project (greenfield) | `/gsd:new-project` |
| Existing codebase, need to map it | `/gsd:map-codebase` |
| Discuss a phase before planning | `/gsd:discuss-phase` |
| Research a phase | `/gsd:research-phase` |
| Plan a phase into atomic tasks | `/gsd:plan-phase` |
| Execute a planned phase | `/gsd:execute-phase` |
| Quick ad-hoc task (no full ceremony) | `/gsd:quick` |
| Verify completed work | `/gsd:verify-work` |
| Check project progress | `/gsd:progress` |
| Check open TODOs | `/gsd:check-todos` |
| Add a TODO | `/gsd:add-todo` |
| Debug a failing phase | `/gsd:debug` |
| Start a new milestone | `/gsd:new-milestone` |
| Complete a milestone | `/gsd:complete-milestone` |
| Add a phase to the roadmap | `/gsd:add-phase` |
| Remove a phase | `/gsd:remove-phase` |
| Insert a phase at a position | `/gsd:insert-phase` |
| Audit milestone completeness | `/gsd:audit-milestone` |
| Pause work (save state) | `/gsd:pause-work` |
| Resume work (restore state) | `/gsd:resume-work` |
| Project health check | `/gsd:health` |
| Show all commands | `/gsd:help` |

## How to use this skill

**Do not execute GSD commands yourself.** GSD commands are slash commands — they run as full Claude Code prompts with their own agent context. Your job is to:

1. **Identify the right command** for the user's intent using the table above.
2. **Tell the user to run it** — e.g. "Run `/gsd:new-project` in your project directory."
3. **Explain why** that command fits their situation in 1-2 sentences.

For quick tasks where the user has a clear, small request (a bug fix, a small feature, a refactor), lean toward `/gsd:quick`. For anything involving planning, phases, or multi-step work, start with `/gsd:discuss-phase` or `/gsd:plan-phase`.

## Core philosophy

- Work is broken into **atomic tasks**, each with a fresh 200k-token context — no context rot.
- Every task gets an **atomic git commit** with a clean message.
- State is tracked in `.planning/` files (`STATE.md`, `ROADMAP.md`, `CONTEXT.md`) so work is resumable across sessions.
- `--discuss` flag: add lightweight discussion before planning (surfaces assumptions).
- `--full` flag on `/gsd:quick`: adds plan-checking + verification for quality guarantees.

## Project files (created by GSD)

| File | Purpose |
|------|---------|
| `.planning/STATE.md` | Current phase, completed tasks, quick tasks log |
| `.planning/ROADMAP.md` | All milestones and phases |
| `.planning/CONTEXT.md` | Decisions, constraints, tech choices |
| `.planning/quick/` | Quick task specs |

## Notes

- GSD works best when Claude Code is opened **in the project directory**.
- For brand-new projects with no directory yet, the user should create and `cd` into the directory first, then run `/gsd:new-project`.
- GSD is designed for solo developers and small teams — no sprint ceremonies, no story points.
