# n8n-workflow-builder

End-to-end n8n workflow creation — from a plain-English description of an automation to a validated, importable workflow JSON.

## When to use

- You know what you want to automate but not how to wire it in n8n
- You have a working workflow that needs to be extended or debugged
- You're building a multi-step automation with conditional logic, error handling, or external APIs

## What it produces

- Complete n8n workflow JSON, ready to import via n8n UI (Settings → Import)
- Node-by-node explanation of what each step does
- Flagged gotchas (rate limits, auth requirements, expression quirks)

## Example prompt

```text
System: [paste SKILL.md contents]

User:
Build an n8n workflow that:
- Trigger: webhook POST from a form submission (fields: name, email, company)
- Step 1: Check if the email already exists in a Postgres table called `contacts`
- Step 2a: If new — insert the row, then send a welcome email via SendGrid
- Step 2b: If existing — update the `last_seen` timestamp only
- Step 3: In both cases, post a summary to a Slack channel #new-signups

Return the full workflow JSON.
```

## The n8n skill stack

This folder is the orchestrator. Use these specialists for deeper problems:

| Problem | Use this skill |
|---|---|
| Expression `{{ }}` syntax errors | `n8n-expression-syntax` |
| Node won't configure correctly | `n8n-node-configuration` |
| Validation errors after building | `n8n-validation-expert` |
| JavaScript in a Code node | `n8n-code-javascript` |
| Python in a Code node | `n8n-code-python` |
| Choosing the right n8n node | `n8n-mcp-tools-expert` |
| Structural workflow patterns | `n8n-workflow-patterns` |

## Import instructions

1. Copy the JSON output
2. In n8n: **Settings → Import Workflow** (or drag into the canvas)
3. Add credentials for any service nodes
4. Run with **Test Workflow** before activating
