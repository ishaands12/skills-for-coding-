---
name: n8n-workflow-builder
description: End-to-end n8n workflow builder. Use this skill whenever the user wants to create, build, automate, or set up an n8n workflow — even if they just describe an automation goal without mentioning n8n directly (e.g., "automate my Slack notifications", "send emails when a form is submitted", "sync data between two apps", "schedule a daily report"). This skill orchestrates the full lifecycle: interviewing the user, picking the right pattern, discovering nodes via n8n-mcp MCP tools, creating and editing the workflow, writing expressions, validating, testing, and activating. Trigger whenever the user mentions n8n, automation workflows, connecting apps, or building any kind of automated pipeline. Always use this skill rather than improvising — it prevents the common mistakes that break n8n workflows.
---

# n8n Workflow Builder

You are building a production-ready n8n workflow. Your job is to guide the user from a vague automation goal to a live, tested, activated workflow — using the n8n-mcp MCP tools to do the actual work inside n8n.

The user's n8n is running at **http://localhost:5678**. You have full access to it via n8n-mcp tools.

---

## Phase 1: Interview First, Build Second

Before touching any MCP tool, understand what the user actually needs. Ask:

1. **Trigger**: What starts this workflow? (a webhook, a form submission, a schedule, an email, a button, a new row in a spreadsheet...)
2. **Goal**: What should happen as a result? Be specific — "send a Slack message" needs a channel, message format, conditions.
3. **Data**: What data flows through? Where does it come from, what needs to transform?
4. **Error handling**: What should happen if something fails? (For production workflows, always add error paths.)
5. **Credentials**: What services are involved? Do they already have credentials set up in n8n?

Keep it conversational — don't dump all 5 questions at once if you already have answers from context. The goal is to understand enough to pick the right pattern and not have to re-architect mid-build.

---

## Phase 2: Pick a Pattern

Match the automation to one of these proven patterns. Read `references/patterns.md` for full node sequences for each.

| Pattern | Use when |
|---|---|
| **Webhook processing** | Receiving data from external apps (Stripe, GitHub, Typeform, etc.) |
| **HTTP API integration** | Fetching or pushing data to REST APIs on a schedule or trigger |
| **Database operations** | Reading/writing Postgres, MySQL, or other databases |
| **AI agent** | Natural language processing, LLM calls, RAG pipelines |
| **Scheduled task** | Recurring jobs (daily reports, sync, cleanup) |

Tell the user which pattern you're using and why before building.

---

## Phase 3: Discover Nodes

Use `search_nodes` to find the right nodes. The search tool is fast (~20ms) and returns relevant matches.

```
search_nodes(query: "slack send message")
search_nodes(query: "HTTP request")
search_nodes(query: "postgres insert")
```

Then get configuration details with `get_node` using **standard detail** (the default — covers 95% of cases):
```
get_node(nodeType: "nodes-base.slack", detail: "standard")
```

**Critical format rule**: Search and validation tools use the SHORT prefix (`nodes-base.slack`). Workflow creation/update tools require the FULL prefix (`n8n-nodes-base.slack`). Mixing these up causes "node not found" errors. Read `references/mcp-tools.md` for the full tool reference.

---

## Phase 4: Create the Workflow

Start with `n8n_create_workflow` to scaffold the structure, then add nodes iteratively with `n8n_update_partial_workflow`. Never try to build everything in one call — build incrementally, validate as you go.

**Workflow creation pattern:**
```
1. n8n_create_workflow({ name: "...", nodes: [trigger_node] })
2. n8n_update_partial_workflow({ operation: "add_node", ... })  // add one node at a time
3. n8n_validate_workflow(...)  // validate after each meaningful addition
4. Fix errors, re-validate
5. Repeat until complete
```

The `n8n_update_partial_workflow` tool is your primary building tool — use it for everything after the initial creation. Always include the `intent` parameter to describe what you're doing (e.g., `intent: "adding Slack notification after HTTP request"`).

For IF nodes, use semantic branch names instead of numeric indices:
```json
{ "branch": "true" }  // instead of sourceIndex: 0
{ "branch": "false" } // instead of sourceIndex: 1
```

For Switch nodes, use `case: 0`, `case: 1`, etc.

---

## Phase 5: Expressions

n8n uses `{{ expression }}` double-brace syntax for dynamic values everywhere except Code nodes.

**Most common variables:**
- `{{ $json.fieldName }}` — current node's output data
- `{{ $json.body.fieldName }}` — webhook data (webhook wraps everything in `.body`)
- `{{ $node["Node Name"].json.fieldName }}` — reference another node's output
- `{{ $now.toFormat('yyyy-MM-dd') }}` — current timestamp

**The #1 mistake**: Webhook data is NOT at `$json.name` — it's at `$json.body.name`. The webhook node wraps incoming data in a `.body` object to preserve headers, query params, etc.

Read `references/expressions.md` for the full expression reference including date math, array access, and cross-node patterns.

---

## Phase 6: Validate and Fix

Run `n8n_validate_workflow` with the `runtime` profile before finalizing:
```
n8n_validate_workflow({ workflowId: "...", profile: "runtime" })
```

Profiles:
- `minimal` — fast check during editing (required fields only)
- `runtime` — pre-deployment standard (use this for final check)
- `ai-friendly` — reduces false positives when you built with AI assistance
- `strict` — production-grade, maximum enforcement

The auto-sanitizer automatically fixes common structural issues (binary/unary operator mismatches, IF node repairs) on every update — trust it, don't manually fight it.

Typical validation loop: validate → read errors → fix with `n8n_update_partial_workflow` → re-validate. Usually takes 2-3 iterations. Read `references/validation.md` for the full error catalog and fixes.

---

## Phase 7: Test and Activate

Test with `n8n_test_workflow` — it auto-detects your trigger type and runs appropriately:
```
n8n_test_workflow({ workflowId: "..." })
```

Check executions with `n8n_executions` to see what ran and debug failures.

Once the test looks good, activate with:
```
n8n_update_partial_workflow({ operation: "activate", workflowId: "..." })
```

Show the user the workflow URL: `http://localhost:5678/workflow/{id}`

---

## Common Mistakes to Avoid

- **Wrong nodeType prefix**: Use `n8n-nodes-base.X` (full prefix) in workflow operations, `nodes-base.X` (short prefix) in search/validate
- **Skipping validation**: Always validate before activating — silent misconfigurations will fail at runtime
- **Webhook data access**: Always `$json.body.field`, never `$json.field` for webhook inputs
- **Expressions in Code nodes**: Code nodes use plain JS (`$input.first().json.field`), not `{{ }}` syntax
- **Single large creation**: n8n workflows need iterative building — add nodes one or a few at a time
- **Ignoring credentials**: If a node needs credentials, check they exist in n8n first or guide the user to add them via Settings → Credentials

---

## Reference Files

Load these when you need deeper detail — don't load all at once:

- `references/mcp-tools.md` — Full MCP tool reference, parameters, and correct usage patterns
- `references/patterns.md` — Complete node sequences for all 5 workflow patterns
- `references/expressions.md` — Full expression syntax, variables, date math, Code node patterns
- `references/validation.md` — Error catalog, validation profiles, fix patterns

Also available as separate installed skills for detailed guidance:
- `n8n-mcp-tools-expert` — MCP tool selection and parameters
- `n8n-workflow-patterns` — Architectural patterns
- `n8n-node-configuration` — Node-specific configuration
- `n8n-expression-syntax` — Expression debugging
- `n8n-validation-expert` — Validation error interpretation
- `n8n-code-javascript` — JavaScript in Code nodes
- `n8n-code-python` — Python in Code nodes
