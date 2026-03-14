# new-project

Scaffolds new applications and services using a 3-layer agent architecture — Directives, Orchestration, Execution. Produces an opinionated project structure with a working foundation, not just boilerplate.

## When to use

- Starting a new service, app, or tool from scratch
- Migrating from an ad-hoc codebase to a structured, maintainable architecture
- Setting up the scaffolding before handing a project to a team or AI agent

## What it produces

- Directory structure: `directives/`, `execution/`, `src/` with separation of concerns built in
- `AGENTS.md` (or `CLAUDE.md`) — agent operating instructions for the project
- `directives/` — task-specific SOPs the model will follow
- `execution/` — stub scripts for deterministic operations (API calls, DB ops, file handling)
- Starter config files: `.env.example`, `README.md`, `pyproject.toml` or `package.json`

## The 3-layer architecture

```
directives/          ← What to do (Markdown SOPs, living documents)
execution/           ← How to do it (deterministic Python/JS scripts)
src/ or app/         ← The actual product code
AGENTS.md            ← How the AI agent should behave in this repo
```

**Why it works:** 90% model accuracy per step → 59% end-to-end success over 5 steps. Deterministic scripts eliminate the compounding error problem.

## Example prompt

```text
System: [paste SKILL.md contents]

User:
Scaffold a new Python service that:
- Ingests webhook events from Stripe
- Stores them in Postgres
- Sends a Slack notification for failed payments
- Stack: FastAPI, Postgres (asyncpg), Python 3.12

Use the 3-layer architecture. Include directives for the ingestion and notification flows,
execution scripts for DB writes and Slack posts, and a working FastAPI stub.
```

## Pairs well with

- `gsd` — after scaffolding, use GSD for phased execution with roadmaps and task tracking
- `architect-review` — review the scaffold before building on it
- `prd` — write the PRD first, then scaffold the project from it
