---
name: new-project
description: Scaffold a new 3-layer agent project following the directives/execution/orchestration architecture defined in AGENTS.md. Use this skill whenever a user wants to initialize, start, create, or bootstrap a new project — even if they just say "new project", "init a project", "start a project", "set up a project", or "create a project folder". Always use this skill for any new project setup, even if the user doesn't explicitly mention the 3-layer architecture.
---

# New Project Initializer

This skill scaffolds new projects using the 3-layer architecture from AGENTS.md:

- **Layer 1 (Directive)**: `directives/` — SOPs as Markdown files telling the AI what to do
- **Layer 2 (Orchestration)**: You (the AI) — intelligent routing and decision-making
- **Layer 3 (Execution)**: `execution/` — Deterministic Python scripts that do the actual work

## Step 1: Gather Info

If the user hasn't specified a project name and target directory, ask for them before proceeding. You need both:
- **Project name** — will become the directory name (use kebab-case)
- **Parent directory** — where to create the project folder (default: `~/projects` if they're unsure)

## Step 2: Run the Init Script

Once you have both pieces of info, run:

```bash
python /Users/ishaan/.claude/skills/new-project/scripts/init_project.py \
  --name <project-name> \
  --parent <parent-directory>
```

The script creates the full project at `<parent>/<project-name>/` with:

| What | Where | Purpose |
|------|-------|---------|
| Architecture docs | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` | Mirrored so any AI loads the same instructions |
| Directive folder | `directives/` | Where you'll write SOPs for the agent |
| Execution folder | `execution/` | Where deterministic Python scripts live |
| Scratch folder | `.tmp/` | Intermediate files (never committed) |
| Secrets | `.env` | API keys and environment variables |
| Git repo | `.git/` + `.gitignore` | Version control, sensitive files excluded |
| Python env | `.venv/` + `requirements.txt` | Isolated dependencies |

## Step 3: Confirm and Guide

After the script runs, tell the user:

1. The full path to the project
2. How to activate the venv: `cd <project-path> && source .venv/bin/activate`
3. To fill in `.env` with their API keys
4. Their first task is usually writing a directive in `directives/` — offer to help them create one if they'd like

## If the Script Fails

Common issues:
- **Python not found**: Try `python3` instead of `python`
- **Target dir exists**: Ask the user if they want to use the existing directory or pick a new name
- **Permission error**: The parent directory may need `sudo` or the path may be wrong — verify with the user
