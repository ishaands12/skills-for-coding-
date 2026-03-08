# n8n Expression Reference

## Core Syntax

All dynamic values in n8n node parameters use double-brace syntax:
```
{{ expression }}
```

**Exception**: Code nodes (JavaScript/Python) use direct variable access — no `{{ }}`.

---

## Core Variables

### $json — Current node's output data
```
{{ $json.fieldName }}
{{ $json['field with spaces'] }}
{{ $json.nested.object.value }}
{{ $json.array[0] }}
{{ $json.array[0].name }}
```

### $json.body — Webhook input data (CRITICAL)
Webhook nodes wrap ALL incoming data in a `.body` object:
```
{{ $json.body.name }}          // incoming JSON field
{{ $json.body.user.email }}    // nested field
{{ $json.headers['x-api-key'] }} // request header
{{ $json.query.page }}         // query parameter
```
**Never** write `{{ $json.name }}` for webhook data — it won't work.

### $node — Reference another node's output
```
{{ $node["Node Name"].json.fieldName }}
{{ $node["HTTP Request"].json.data.items[0].id }}
```
Node names are case-sensitive and must match exactly.

### $now — Current timestamp
```
{{ $now.toISO() }}                          // 2025-01-15T09:00:00.000Z
{{ $now.toFormat('yyyy-MM-dd') }}           // 2025-01-15
{{ $now.toFormat('dd/MM/yyyy HH:mm') }}     // 15/01/2025 09:00
{{ $now.plus({ days: 7 }).toISO() }}        // 7 days from now
{{ $now.minus({ hours: 24 }).toISO() }}     // 24 hours ago
{{ $now.startOf('day').toISO() }}           // start of today
```

### $env — Environment variables
```
{{ $env.MY_API_KEY }}
{{ $env.BASE_URL }}
```

### $vars — n8n workflow variables (set in Settings → Variables)
```
{{ $vars.myVariable }}
```

---

## String Operations
```
{{ $json.firstName + ' ' + $json.lastName }}
{{ $json.text.toUpperCase() }}
{{ $json.text.toLowerCase() }}
{{ $json.text.trim() }}
{{ $json.text.includes('keyword') }}
{{ $json.text.replace('old', 'new') }}
{{ $json.url.split('/').pop() }}            // last segment of URL
```

## Number Operations
```
{{ $json.price * 1.2 }}                    // 20% markup
{{ Math.round($json.value * 100) / 100 }}  // round to 2 decimals
{{ parseInt($json.stringNumber) }}
{{ parseFloat($json.stringFloat) }}
```

## Conditional Expressions
```
{{ $json.status === 'active' ? 'yes' : 'no' }}
{{ $json.count > 0 ? $json.count : 0 }}
{{ $json.name ?? 'Unknown' }}              // null coalescing
```

## Array Operations
```
{{ $json.items.length }}
{{ $json.items[0].name }}
{{ $json.items.map(i => i.name).join(', ') }}
{{ $json.items.filter(i => i.active).length }}
```

---

## Code Node Variable Access (NO double braces)

In JavaScript Code nodes:
```javascript
// Access input data
const item = $input.first().json;
const allItems = $input.all();

// Access specific fields
const name = $input.first().json.name;
const email = $input.first().json.body.email; // webhook data

// Access another node
const prevData = $node["Previous Node"].json;

// Return data (required)
return [{ json: { result: "value" } }];

// Return multiple items
return items.map(item => ({ json: { ...item.json, processed: true } }));
```

In Python Code nodes:
```python
# Access input data
item = _input.first().json
all_items = _input.all()

# Return data (required)
return [{"json": {"result": "value"}}]
```

---

## Common Patterns

**Format date from timestamp:**
```
{{ DateTime.fromMillis($json.timestamp).toFormat('yyyy-MM-dd') }}
```

**Combine fields:**
```
{{ $json.firstName }} {{ $json.lastName }} <{{ $json.email }}>
```

**Conditional message:**
```
{{ $json.count > 0 ? `Found ${$json.count} results` : 'No results found' }}
```

**Safe nested access:**
```
{{ $json.user?.address?.city ?? 'Unknown city' }}
```

**URL encoding:**
```
{{ encodeURIComponent($json.searchQuery) }}
```

---

## Common Mistakes

| Wrong | Right | Why |
|---|---|---|
| `{{ $json.name }}` in webhook | `{{ $json.body.name }}` | Webhook wraps in `.body` |
| `{{ $json.name }}` in Code node | `$input.first().json.name` | Code nodes use direct JS |
| `{{ $node.NodeName.json }}` | `{{ $node["Node Name"].json }}` | Must use bracket notation |
| `{{ {{$json.id}} }}` | `{{ $json.id }}` | Never nest double braces |
| `$json.items[0]` (Code node) | `$input.first().json.items[0]` | Different syntax in Code |
