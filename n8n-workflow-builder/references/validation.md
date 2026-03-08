# Validation & Error Fixing Reference

## The Validation Loop

Always run validation before activating a workflow. The typical cycle:

```
n8n_validate_workflow(workflowId, profile: "runtime")
  → read errors
  → fix with n8n_update_partial_workflow
  → re-validate
  → repeat until clean (usually 2-3 iterations)
```

If errors persist and seem wrong, try `n8n_autofix_workflow` with `confidence: "high"` — it catches structural issues automatically.

---

## Validation Profiles

| Profile | When to use | What it checks |
|---|---|---|
| `minimal` | During active editing | Required fields only |
| `runtime` | Before final deploy | Standard + execution requirements |
| `ai-friendly` | AI-built workflows | Reduces false positives |
| `strict` | Production systems | Maximum enforcement |

Default to `runtime` for most workflows. Use `ai-friendly` if you're getting false-positive errors on a well-structured workflow.

---

## Common Errors and Fixes

### "Required parameter missing: X"
The node needs a field that wasn't set. Get the node's requirements:
```
get_node(nodeType: "nodes-base.slack", detail: "standard")
```
Then add the missing parameter via `n8n_update_partial_workflow` with `operation: "update_node"`.

### "Node type not found: X"
Wrong nodeType format. Check:
- Workflow operations need FULL prefix: `n8n-nodes-base.slack`
- Search/validation needs SHORT prefix: `nodes-base.slack`

### "Invalid expression: {{ $json.field }}"
Check if this is a Code node — Code nodes don't use `{{ }}` syntax.
Or the field path is wrong — use `get_node` in docs mode to see expected data structure.

### IF Node: "singleValue" error
Binary operators (`equals`, `contains`, `greaterThan`, etc.) must NOT have `singleValue: true`.
Unary operators (`isEmpty`, `isNotEmpty`) REQUIRE `singleValue: true`.

The auto-sanitizer usually fixes this automatically. If it persists:
```json
// Binary operator (comparison) — no singleValue
{
  "operator": { "type": "string", "operation": "equals" },
  "leftValue": "={{ $json.status }}",
  "rightValue": "active"
}

// Unary operator (existence check) — requires singleValue
{
  "operator": { "type": "string", "operation": "isEmpty" },
  "leftValue": "={{ $json.email }}",
  "singleValue": true
}
```

### "Stale connections detected"
A connection references a node that was renamed or deleted.
```
n8n_update_partial_workflow({ operation: "clean_stale_connections", workflowId: "..." })
```

### "Credential not found"
The node references a credential that doesn't exist. Guide user to add it:
1. Open n8n at http://localhost:5678
2. Go to Settings → Credentials → Add Credential
3. Select the service type and fill in the details
4. Come back and retry

### "Workflow has no trigger node"
Every workflow needs exactly one trigger (Webhook, Schedule Trigger, Manual Trigger, etc.).
If testing without a real trigger, add a Manual Trigger node.

### "Circular connection detected"
A connection creates a loop. Check the connections and remove the cycle.
Valid loops use dedicated loop nodes (`SplitInBatches`, `Loop Over Items`).

---

## Auto-Sanitization

n8n-mcp automatically fixes these on every workflow update — you don't need to handle them manually:
- Binary operator with incorrect `singleValue` field
- Unary operator missing `singleValue: true`
- IF node structural issues
- Switch node case numbering

Trust the auto-sanitizer. If you see these errors in validation after an update, run the update again — it usually resolves on the next pass.

---

## Checking Executions After Test

```
n8n_executions({ workflowId: "...", limit: 5 })
```

Look at:
- `status`: "success" | "error" | "running"
- `data.resultData.error`: error message if failed
- `data.resultData.runData`: output of each node

For detailed debugging, open the execution in n8n UI:
`http://localhost:5678/workflow/{workflowId}/executions/{executionId}`
