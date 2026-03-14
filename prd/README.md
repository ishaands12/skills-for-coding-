# prd

Generates structured Product Requirement Documents from raw ideas, user problems, or feature requests. Output is exec-ready and engineering-handoff-ready.

## When to use

- Turning a vague feature idea into a spec before writing any code
- Aligning a team on scope, success metrics, and non-goals before a sprint
- Creating documentation for a project retrospective or portfolio

## What it produces

- **Problem statement** — the user pain, not the solution
- **Success metrics** — specific, measurable (e.g., "reduce time-to-first-value from 5 min to <60 sec")
- **User stories** — in `As a / I want / So that` format
- **Functional requirements** — numbered, unambiguous
- **Non-goals** — explicit scope exclusions
- **Technical requirements** — stack constraints, API contracts, data models
- **Open questions** — what still needs a decision

## Example prompt

```text
System: [paste SKILL.md contents]

User:
I'm building a Chrome extension that lets users highlight any text on a webpage,
right-click, and get a one-sentence AI summary in a tooltip.

Target users: researchers and students doing literature review.
Constraint: must work offline for already-cached pages, online otherwise.
Budget: Claude API, free tier to start.

Generate the full PRD.
```

## Pairs well with

- `internal-comms` — turn the PRD into a team launch brief or leadership update
- `architect-review` — feed the PRD into an architecture review of the proposed system
- `market-research-reports` — run a market analysis before writing the PRD
- `escalation` — if the feature unblocks a customer escalation, structure that brief first
