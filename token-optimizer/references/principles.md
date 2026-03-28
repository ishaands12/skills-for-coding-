# Token Optimizer — Core Principles

Source: 8 principles for reducing Claude token usage.

## The 8 Rules

### 1. Chat Lifespan Limit
Claude re-reads the entire conversation every single turn. Long conversations get progressively slower and more expensive. **Hard limit: start a fresh chat every 15–20 messages.** Never let a single thread run indefinitely.

### 2. Context Handoff via Summary
When ending a chat, do not just abandon context. Summarize what was decided, what was built, and what comes next — then paste that summary at the top of the new chat. You keep the important context without carrying the full weight of conversation history.

### 3. Batch Related Questions
Asking three related questions in three separate messages costs 3x the context load. **Combine related questions into one message.** Claude can answer holistically, and the context is only loaded once.

### 4. Upload Files to Projects Once
Re-uploading the same PDF, brief, or document in each new chat pays tokens for the same content repeatedly. Upload once to a Project (or workspace). Reference it from there.

### 5. Configure Memory and Preferences
Do not waste messages re-explaining who you are, what you're working on, or how you like responses. Configure memory and user preferences so Claude already knows this at the start of every chat.

### 6. No Micro-Prompts
Avoid tiny single-purpose prompts that each load the full context. "Fix this", "Now add X", "What about Y" in rapid succession is expensive. **Batch edits, reviews, and ideas into fewer, denser turns.**

### 7. Respect the 5-Hour Rolling Window
Claude usage runs on a rolling 5-hour window. Burning all messages in one long session wastes capacity. **Split work into 2–3 sessions spaced through the day** to get more effective usage across the window.

### 8. Turn Off Unused Features
Web search, research mode, connectors, and extended thinking all add tokens to every response — even when you don't need them. **Only enable what the current task actually requires.** Toggle off everything else.

---

## Violation Severity

| Violation | Severity | Impact |
|-----------|----------|--------|
| Chat > 20 messages | High | Exponentially increasing cost per turn |
| Micro-prompts (< 3 word sends) | High | Full context load for near-zero value |
| Re-uploading files | Medium | Duplicate token cost |
| Unused features on | Medium | Invisible per-response overhead |
| Not batching related questions | Medium | 2–3x unnecessary context loads |
| No memory/preferences set | Low | Repeated onboarding tokens |
| Single long session | Low | Rolling window inefficiency |
