# n8n-mcp Tool Reference

## Node Discovery (no API credentials needed)

### search_nodes
Find nodes by keyword. Fast (~20ms). Use this first.
```
search_nodes(query: "slack", limit: 5)
search_nodes(query: "HTTP request POST")
search_nodes(query: "postgres insert row")
```
Returns: nodeType (short format), display name, description.

### get_node
Get configuration details for a specific node.
```
get_node(nodeType: "nodes-base.slack", detail: "standard")   // 95% of cases
get_node(nodeType: "nodes-base.slack", detail: "minimal")    // quick metadata only
get_node(nodeType: "nodes-base.slack", detail: "full")        // debugging only
get_node(nodeType: "nodes-base.slack", mode: "docs")          // markdown usage guide
get_node(nodeType: "nodes-base.slack", mode: "search_properties", query: "channel")
```

**IMPORTANT**: `get_node` uses SHORT prefix (`nodes-base.slack`). Workflow tools use FULL prefix (`n8n-nodes-base.slack`).

---

## Workflow Management (requires N8N_API_URL + N8N_API_KEY)

### n8n_create_workflow
Create a new workflow. Returns workflow ID for subsequent operations.
```json
{
  "name": "My Workflow",
  "nodes": [
    {
      "type": "n8n-nodes-base.webhook",   // FULL prefix here
      "name": "Webhook",
      "parameters": { "httpMethod": "POST", "path": "my-path" },
      "position": [250, 300]
    }
  ],
  "connections": {}
}
```
Workflows are created **inactive** — you must activate explicitly.

### n8n_update_partial_workflow (most-used tool)
The primary editing tool. Always include `intent`.

**Add a node:**
```json
{
  "workflowId": "abc123",
  "intent": "adding Slack notification node",
  "operation": "add_node",
  "node": {
    "type": "n8n-nodes-base.slack",
    "name": "Send Slack Message",
    "parameters": {
      "resource": "message",
      "operation": "post",
      "channel": "#general",
      "text": "={{ $json.body.message }}"
    },
    "position": [500, 300]
  }
}
```

**Add a connection:**
```json
{
  "workflowId": "abc123",
  "intent": "connecting webhook to Slack node",
  "operation": "add_connection",
  "connection": {
    "source": "Webhook",
    "target": "Send Slack Message"
  }
}
```

**IF node connection (use branch names, not numeric indices):**
```json
{
  "operation": "add_connection",
  "connection": {
    "source": "IF",
    "target": "Success Handler",
    "branch": "true"
  }
}
```

**Switch node connection:**
```json
{
  "operation": "add_connection",
  "connection": {
    "source": "Switch",
    "target": "Handler A",
    "case": 0
  }
}
```

**Activate workflow:**
```json
{ "workflowId": "abc123", "operation": "activate" }
```

**Deactivate workflow:**
```json
{ "workflowId": "abc123", "operation": "deactivate" }
```

**Other operations:** `remove_node`, `update_node`, `move_node`, `enable_node`, `disable_node`, `remove_connection`, `rewire_connections`, `clean_stale_connections`, `update_settings`, `rename`, `add_tag`

### n8n_validate_workflow
```json
{ "workflowId": "abc123", "profile": "runtime" }
```
Profiles: `minimal` | `runtime` | `ai-friendly` | `strict`

### n8n_test_workflow
Auto-detects trigger type and runs the workflow.
```json
{ "workflowId": "abc123" }
```

### n8n_executions
Get execution history.
```json
{ "workflowId": "abc123", "status": "error", "limit": 5 }
```

### n8n_autofix_workflow
Auto-fix common structural issues.
```json
{ "workflowId": "abc123", "confidence": "high" }
```

---

## Template Library

### n8n_search_templates
```json
{ "query": "slack notification webhook", "limit": 5 }
```

### n8n_deploy_template
Deploy a template directly to your n8n instance with auto-fixes.
```json
{ "templateId": 1234, "activate": false }
```

---

## AI Connection Types (for AI agent workflows)

When connecting AI nodes, use `sourceOutput` to specify connection type:
- `ai_languageModel` — LLM connections
- `ai_tool` — Tool connections
- `ai_memory` — Memory connections
- `ai_outputParser` — Output parser connections
- `ai_embedding` — Embedding connections
- `ai_vectorStore` — Vector store connections
- `ai_document` — Document loader connections
- `ai_textSplitter` — Text splitter connections

Example:
```json
{
  "operation": "add_connection",
  "connection": {
    "source": "OpenAI Chat Model",
    "target": "AI Agent",
    "sourceOutput": "ai_languageModel"
  }
}
```
