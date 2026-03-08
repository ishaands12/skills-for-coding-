---
name: self-anneal
description: Guided recovery when something breaks — a script fails, an API errors, or the agent is stuck. Writes a PRD of fix tasks, then opens a new Terminal window running Ralphy autonomously on that PRD. Use when any tool, script, or API call fails, or when the agent hits a dead end and needs structured error recovery.
---

# Self-Anneal: Error Recovery via Ralphy

When something breaks, diagnose it, write a fix PRD, and hand it to Ralphy.
Ralphy runs in its own Terminal window. You watch the PRD and progress log.

---

## Step 0 — Classify the Error (Do This First)

**Fatal — escalate immediately, do NOT proceed:**
- Auth/credentials revoked or missing from `.env`
- External service is down (check status page)
- Quota fully exhausted with no reset window
- Fix would touch a protected path (`.ralphy/config.yaml` → `boundaries.never_touch`)

**Paid API exception:** If re-running will consume paid tokens or quota — stop and ask the user first.

**Retriable — proceed to Step 1:**
- HTTP 429 / rate limit, HTTP 5xx transient
- `ModuleNotFoundError`, `FileNotFoundError`
- Timeout, logic error, bad parsing, bad input
- Expired token with a refresh path

---

## Step 1 — Diagnose

Read the full error and state out loud:
- What failed (script name, function, line number)
- Root cause (not just the symptom)

---

## Step 2 — Write the PRD

Create `.tmp/self-anneal.md` with fix tasks in Ralphy's checkbox format.
Each line is one discrete, actionable fix. Be specific — this string goes directly to Claude Code.

```markdown
# Self-Anneal Fix — <date>

## Context
Script: <script_name>
Error: <error_type> — <specific message>
Root cause: <one sentence>

## Tasks
- [ ] <primary fix — e.g. "Add exponential backoff with 3 retries to execution/scrape_site.py for HTTP 429 responses">
- [ ] <verification — e.g. "Run execution/scrape_site.py with a single URL and confirm it completes without 429 error">
- [ ] <directive update — e.g. "Add note to directives/scrape_website.md: API rate-limits to 1 req/sec, batch endpoint available at /v2/batch">
```

Three tasks is the typical shape: fix → verify → document. Add more only if the fix has distinct sub-steps.

---

## Step 3 — Launch Ralphy

```bash
bash /Users/ishaan/.claude/skills/self-anneal/run.sh .tmp/self-anneal.md
```

This opens a new Terminal window running:
```
ralphy --prd .tmp/self-anneal.md
```

Ralphy handles retries (max 3), test execution, and auto-commit internally.

After running, Claude prints the paths of two files:
- **`.tmp/self-anneal.md`** — the PRD; watch `[ ]` tick to `[x]` as tasks complete
- **`.ralphy/progress.txt`** — Ralphy's detailed progress log

---

## Step 4 — Wait and Review

Do not intervene while Ralphy is running. When the Terminal window closes or shows completion:

1. Check that all PRD tasks are marked `[x]`
2. Review what changed — did the fix address the root cause or just suppress the error?
3. If Ralphy exhausted retries and a task is still `[ ]` → escalate

---

## Step 5 — Resume

With Ralphy's fix committed, continue the original task from where it broke.

---

## Escalate

Surface to the user when:
- Error is **fatal** (Step 0)
- A PRD task is still `[ ]` after Ralphy exhausted retries
- Fix requires **paid API calls / quota**
- Fix requires touching a **protected boundary**
- Root cause is **outside the codebase** (service down, key revoked)

When escalating, tell the user:
1. What failed and the root cause
2. Which PRD task Ralphy couldn't complete
3. What the user needs to do to unblock
