---
name: claude-auditor
description: Structured audit of Claude/AI usage across 3 dimensions — prompt quality, codebase AI integration, and project AI scaffolding. Checklist evaluation runs via local qwen model to save Claude tokens. Trigger phrases: "audit my claude usage", "run a claude audit", "audit this project", "audit my prompts", "ai audit", "run an audit".
---

# Claude Auditor Skill

Run a structured audit of how Claude and AI are used in the current working directory. Covers 3 dimensions: prompt quality, codebase AI integration, and project AI scaffolding.

**Division of labour:** You (Claude) collect content, write temp files, invoke qwen, and synthesise the final report. qwen runs the checklists. If qwen output is garbled on an item, use your own judgment and note it.

---

## Step 1 — Collect Content

Scan the working directory. Read relevant files — signal over noise.

**Audit 1 input — prompt/instruction files:**
- `CLAUDE.md` (project-level + `~/.claude/CLAUDE.md` global)
- `SKILL.md`, `AGENTS.md`, any prompt templates or system prompt files
- `.planning/` directory contents

**Audit 2 input — code files:**
- Files importing `anthropic`, `@anthropic-ai/sdk`, `boto3`, `vertexai`, `openai`, `ollama`
- Files containing `messages=`, `system=`, `model=`, `tools=`
- MCP server files (`server.py`, `index.ts` with MCP patterns)

**Audit 3 input — scaffolding:**
- `~/.claude/settings.json`
- `~/.claude/skills/` directory listing
- Any test files adjacent to AI-integrated code
- `.planning/` directory (existence check)

If a category has no relevant files, skip that audit and say so.

---

## Step 2 — Run Audits via qwen

Write content + checklist to a temp file, pipe to qwen. Run sequentially.

```bash
cat /tmp/claude_audit_[1|2|3].txt | ollama run qwen2.5-coder:7b
```

If content exceeds ~500 lines, summarise or excerpt first — pass qwen what's relevant, not everything.

---

## Audit 1 — Prompt & Instruction Quality

**What qwen can actually verify from static files:** specificity of instructions, structure, scope, tool usage, skill reuse.

**Prompt template for qwen:**

```
You are a prompt quality auditor. Review the following instructions, CLAUDE.md files, and skill definitions. For each checklist item, output PASS, FLAG, or FAIL — one line each, with a concise reason.

--- CONTENT START ---
[INSERT COLLECTED PROMPT/INSTRUCTION CONTENT HERE]
--- CONTENT END ---

CHECKLIST:

P1. DELEGATION — Are the tasks delegated to Claude substantive? (not trivial busywork, not tasks that require irreplaceable human judgment)
P2. DESCRIPTION — Are instructions specific and unambiguous? Do they include role, format expectations, or constraints where needed?
P3. CONTEXT UPFRONT — Does context (background, constraints, tone) appear at the start of instructions, not buried at the end?
P4. SCOPE CONTROL — Are instructions scoped to one task at a time, or are they overloaded multi-task megaprompts?
P5. SYSTEM PROMPT SEPARATION — Are system-level instructions kept separate from user-turn content?
P6. EXAMPLES — For complex or ambiguous tasks, are examples or few-shot patterns provided?
P7. SKILLS USED — Are recurring task patterns encoded as reusable skills/templates rather than repeated inline?
P8. TOOLS INVOKED — When Claude needs external data, are tools specified rather than asking Claude to guess or hallucinate?
P9. DELEGATION RULES — If there are rules about when to delegate vs keep tasks, are they explicit and specific?

Output format — one line per item:
[P1] PASS/FLAG/FAIL — reason
```

---

## Audit 2 — Codebase AI Integration Quality

**What qwen can actually verify from static files:** API usage patterns, model selection, error handling, tool schemas, context management — all visible in code.

**Prompt template for qwen:**

```
You are a code auditor specialising in Claude API and AI integration patterns. Review the following code files. For each checklist item, output PASS, FLAG, or FAIL — one line each, with a concise reason.

--- CODE START ---
[INSERT COLLECTED CODE CONTENT HERE]
--- CODE END ---

CHECKLIST:

C1. MODEL SELECTION — Is the model chosen appropriate for the task? (Opus for complex reasoning, Sonnet balanced, Haiku for speed/cost — not always defaulting to the most expensive)
C2. SYSTEM PROMPT SEPARATION — Is the system prompt in the `system` parameter, not stuffed into the first user message?
C3. STREAMING — Is streaming used for long or interactive outputs rather than blocking on full response?
C4. STRUCTURED OUTPUT — Is structured data extracted via JSON mode or tool use, not regex-parsed from raw text?
C5. ERROR HANDLING — Are API errors caught with retry/backoff logic, not silent failures or bare except?
C6. TOOL SCHEMAS — Are tool definitions specific? Do parameters have types and descriptions?
C7. AGENT ARCHITECTURE — Is the agent architecture appropriate? (deterministic flow for predictable tasks, flexible agent only where reasoning is needed)
C8. CONTEXT MANAGEMENT — Are long or parallel tasks split into subagents or separate context windows rather than bloating one context?
C9. RAG PATTERNS — When Claude needs external data, is retrieval used rather than stuffing raw docs into the context?
C10. MCP MODULARITY — If MCP servers exist, are tools/resources scoped narrowly (one concern per server)?
C11. PROMPT REUSE — Are reusable prompt patterns defined once (SKILL.md, config file) rather than duplicated across call sites?
C12. EVAL COVERAGE — Is there any automated testing or assertion on AI outputs? (even basic shape checks)

Output format — one line per item:
[C1] PASS/FLAG/FAIL — reason
```

---

## Audit 3 — Project AI Scaffolding

**What qwen can actually verify from static files:** whether the right scaffolding exists — CLAUDE.md, hooks, skills, tests near AI code, planning directory. These are concrete yes/no checks.

**Prompt template for qwen:**

```
You are an AI project setup auditor. Review the following scaffolding information about this project. For each checklist item, output PASS, FLAG, or FAIL — one line each, with a concise reason. Base your answers only on what is present in the content provided.

--- SCAFFOLDING START ---
[INSERT: settings.json content, skills directory listing, test file list near AI code, .planning/ existence]
--- SCAFFOLDING END ---

CHECKLIST:

S1. CLAUDE.MD EXISTS — Is there a project-level CLAUDE.md with substantive instructions (not empty or boilerplate)?
S2. DELEGATION RULES — Does CLAUDE.md define what to delegate vs keep for humans (e.g. a green/red list or equivalent)?
S3. HOOKS CONFIGURED — Are any Claude Code hooks set up in settings.json (preToolUse, postToolUse, stop, etc.)?
S4. SKILLS DEFINED — Are recurring task types encoded as skills rather than re-explained each session?
S5. AI CODE TESTED — Are there test files adjacent to or covering the AI-integrated code (even basic integration tests)?
S6. PLANNING DIRECTORY — Is there a .planning/ directory with structured phase specs or plans?
S7. MODEL EXPLICIT — Is the model selection explicit and justified somewhere, or is it just defaulting to whatever?
S8. SCOPE BOUNDED — Is AI usage limited to specific, justified parts of the project — or is it sprawling into everything?

Output format — one line per item:
[S1] PASS/FLAG/FAIL — reason
```

---

## Step 3 — Synthesise and Present the Report

```
# Claude Audit Report
Directory: [path]
Date: [today]

## Audit 1 — Prompt & Instruction Quality   [X/9 PASS]
[qwen results]

## Audit 2 — Codebase AI Integration        [X/12 PASS]
[qwen results]

## Audit 3 — Project AI Scaffolding         [X/8 PASS]
[qwen results]

## Priority Fixes
[FAIL items first, then FLAG items — one-line action each]

## Score
Overall: [total PASS / total applicable items]
```

---

## Notes

- If ollama is not running: `ollama serve`
- If model not pulled: `ollama pull qwen2.5-coder:7b`
- Skip any audit with no relevant files — don't manufacture inputs
- Temp files: `/tmp/claude_audit_1.txt`, `/tmp/claude_audit_2.txt`, `/tmp/claude_audit_3.txt`
- Do not read files outside the working directory and `~/.claude/`
