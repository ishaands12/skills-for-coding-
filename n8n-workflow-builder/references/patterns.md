# n8n Workflow Patterns — Node Sequences

## Pattern 1: Webhook Processing

**Use when**: Receiving HTTP requests from external services (Stripe webhooks, GitHub events, Typeform submissions, etc.)

**Node sequence:**
```
Webhook → [optional: IF/Switch for routing] → Process/Transform → Output (Slack/Email/DB/HTTP)
         ↓ (error path)
         Error Handler → Notify
```

**Webhook node config:**
```json
{
  "type": "n8n-nodes-base.webhook",
  "parameters": {
    "httpMethod": "POST",
    "path": "my-webhook-path",
    "responseMode": "onReceived",
    "responseData": "allEntries"
  }
}
```

**Accessing webhook data in expressions:**
- Body: `{{ $json.body.fieldName }}` — NOT `{{ $json.fieldName }}`
- Headers: `{{ $json.headers['content-type'] }}`
- Query params: `{{ $json.query.param }}`

**Webhook URL after creation:** `http://localhost:5678/webhook/my-webhook-path`

---

## Pattern 2: HTTP API Integration

**Use when**: Fetching from or pushing to REST APIs, often on a schedule or triggered by another event.

**Node sequence:**
```
Schedule Trigger (or Manual/Webhook) → HTTP Request → [optional: Code node to transform] → Output
```

**Schedule Trigger config:**
```json
{
  "type": "n8n-nodes-base.scheduleTrigger",
  "parameters": {
    "rule": {
      "interval": [{ "field": "hours", "hoursInterval": 1 }]
    }
  }
}
```

**HTTP Request node config:**
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "GET",
    "url": "https://api.example.com/data",
    "authentication": "genericCredentialType",
    "genericAuthType": "httpBearerAuth",
    "sendHeaders": true,
    "headerParameters": {
      "parameters": [{ "name": "Accept", "value": "application/json" }]
    }
  }
}
```

---

## Pattern 3: Database Operations

**Use when**: Reading/writing structured data to Postgres, MySQL, SQLite, etc.

**Node sequence:**
```
Trigger → [optional: transform input] → Database Node → [optional: transform output] → Output
```

**Postgres node config:**
```json
{
  "type": "n8n-nodes-base.postgres",
  "parameters": {
    "operation": "insert",
    "schema": "public",
    "table": "my_table",
    "columns": "name,email,created_at",
    "additionalFields": {}
  }
}
```

Operations: `select`, `insert`, `update`, `delete`, `executeQuery`

**For dynamic queries, use `executeQuery`:**
```json
{
  "operation": "executeQuery",
  "query": "SELECT * FROM users WHERE email = '{{ $json.body.email }}'"
}
```

---

## Pattern 4: AI Agent Workflow

**Use when**: Building LLM-powered automations, chatbots, content generation, RAG pipelines.

**Node sequence:**
```
Trigger (Chat/Webhook/Schedule)
  → AI Agent
    ├── [ai_languageModel] → OpenAI/Anthropic Chat Model
    ├── [ai_memory] → Window Buffer Memory (optional)
    └── [ai_tool] → Tools (HTTP Request Tool, Code Tool, etc.)
  → Output
```

**AI Agent node:**
```json
{
  "type": "@n8n/n8n-nodes-langchain.agent",
  "parameters": {
    "agentType": "toolsAgent",
    "text": "={{ $json.body.message }}",
    "options": { "systemMessage": "You are a helpful assistant." }
  }
}
```

**OpenAI Chat Model (connected via ai_languageModel):**
```json
{
  "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
  "parameters": {
    "model": "gpt-4o",
    "options": { "temperature": 0.7 }
  }
}
```

**AI connection example:**
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

---

## Pattern 5: Scheduled Task

**Use when**: Recurring jobs — daily reports, data sync, cleanup, monitoring.

**Node sequence:**
```
Schedule Trigger → Fetch Data → Transform → Send Report/Update DB/Notify
```

**Common schedules:**
```json
// Every day at 9am
{ "rule": { "interval": [{ "field": "cronExpression", "expression": "0 9 * * *" }] } }

// Every hour
{ "rule": { "interval": [{ "field": "hours", "hoursInterval": 1 }] } }

// Every Monday at 8am
{ "rule": { "interval": [{ "field": "cronExpression", "expression": "0 8 * * 1" }] } }
```

---

## Data Flow Patterns

**Linear**: A → B → C → D (most common)

**Branching** (IF node):
```
A → IF → [true]  → B → merge point
       → [false] → C → merge point
```

**Parallel** (same node connects to multiple):
```
A → B (both run simultaneously)
  → C
```

**Loop** (for processing arrays):
Use the `SplitInBatches` node or Code node with loop logic. Avoid infinite loops — always have a termination condition.

**Error handler** (catch failures):
```json
{
  "operation": "update_settings",
  "settings": { "errorWorkflow": "error-handler-workflow-id" }
}
```
