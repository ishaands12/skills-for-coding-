# architect-review

Reviews software systems like a Staff Engineer — scalability risks, API design, database schemas, service boundaries, and performance bottlenecks.

## When to use

- Before scaling a system past its current load
- When designing a new service and want a second opinion on the architecture
- When a codebase has grown organically and needs a structural audit
- Before a technical interview or design review

## What it produces

- Numbered list of findings ordered by severity
- Per-finding: the problem, why it matters at scale, and a concrete fix
- Optionally: a revised schema, API contract, or service diagram in Excalidraw

## Example prompt

```text
System: [paste SKILL.md contents]

User:
Stack: Next.js 14 app router, Postgres via Prisma, Redis for sessions, deployed on Vercel.
Problem: Dashboard queries are slow at ~300 concurrent users.

Schema: [paste relevant tables]
Slow query: [paste query + EXPLAIN output]

Review: indexing strategy, caching layer, and any service boundary changes worth making.
```

## Pairs well with

- `excalidraw-diagram-generator` — generate a revised architecture diagram from the review findings
- `webapp-testing` — test coverage audit to complement the architecture review
- `new-project` / `gsd` — if the review recommends a rebuild or major refactor
