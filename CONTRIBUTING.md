# Contributing to skills-for-coding

Thanks for your interest. This repo is primarily Ishaan's personal AI dev rig, but well-structured contributions are welcome.

## What belongs here

- Skills that solve a **real, recurring problem** in engineering, product, or automation work
- Skills that produce **structured, usable output** — not generic advice
- Skills that have been tested against at least one real task

## What doesn't belong here

- Prompt wrappers with no domain knowledge
- Skills that duplicate existing folders without meaningfully improving them
- Anything untested or speculative

## Skill structure

Every skill is a single directory containing `SKILL.md`:

```
your-skill-name/
└── SKILL.md
```

`SKILL.md` frontmatter:

```yaml
---
name: your-skill-name
description: One sentence — what problem it solves and when to trigger it.
---
```

Body should include:
- **When to use** — specific triggers, not "use when you need help with X"
- **What it produces** — concrete output format
- **Step-by-step workflow** — how the model should approach the task
- **Example prompt** — a realistic usage example

## Submitting a PR

1. Fork the repo, create a branch: `skill/your-skill-name`
2. Add your skill directory with `SKILL.md`
3. Update the table in `README.md` under the relevant capability group
4. Open a PR with: skill name, the problem it solves, and a sample output

## Code of conduct

Be direct, specific, and useful. Vague is the enemy.
