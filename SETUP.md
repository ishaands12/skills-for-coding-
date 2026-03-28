# Setup Guide — AI Dev Rig

Everything you need to replicate this full Claude Code workflow system from scratch.

---

## Prerequisites

- **macOS** (hooks use bash/zsh; Windows needs minor path adjustments)
- **Node.js 20+** and **npm 9+**
- **Claude Code CLI** installed: `npm install -g @anthropic-ai/claude-code`
- **Python 3.10+** for CCNotify and Dippy

---

## 1. Install Skills

Copy skill folders into `~/.claude/skills/`:

```bash
# Clone this repo
git clone https://github.com/ishaands12/skills-for-coding-.git
cd skills-for-coding-

# Copy all skills
for skill in algorithmic-art architect-review brand-guidelines brand-voice canvas-design \
  doc-coauthoring docx firecrawl-scraper frontend-design humanise-text internal-comms \
  lead-magnet-launcher market-research-reports mcp-builder n8n-code-javascript n8n-code-python \
  n8n-expression-syntax n8n-mcp-tools-expert n8n-node-configuration n8n-validation-expert \
  n8n-workflow-builder n8n-workflow-patterns new-project pdf pptx prd self-anneal \
  skill-creator slack-gif-creator theme-factory transcribe web-artifacts-builder \
  webapp-testing xlsx youtube-description ai-agents-exam-builder gsd; do
  cp -r "$skill" ~/.claude/skills/
done
```

Skills auto-activate based on what you ask — no slash command needed (though `/skill-name` also works).

---

## 2. Install GSD (Get Shit Done)

Spec-driven, phase-based development system. Adds 55 slash commands (`/gsd:*`) and 18 specialized sub-agents.

```bash
npx get-shit-done-cc@latest --claude --global
```

To update: `/gsd:update`

---

## 3. Install Ruflo (Multi-Agent Orchestration)

```bash
npm install -g ruflo@latest
ruflo init        # in your project directory
ruflo mcp start   # start MCP server for Claude Code integration
```

---

## 4. Install Hooks

Copy hooks into `~/.claude/hooks/`:

```bash
cp hooks/*.js ~/.claude/hooks/
cp hooks/auto-ralph.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/auto-ralph.sh
```

**What each hook does:**

| Hook | Event | Purpose |
|------|-------|---------|
| `gsd-check-update.js` | SessionStart | Checks npm for GSD updates silently |
| `gsd-prompt-guard.js` | PreToolUse (Write/Edit) | Validates file writes against the plan |
| `gsd-context-monitor.js` | PostToolUse | Tracks context usage, warns before limits |
| `gsd-statusline.js` | StatusLine | Shows GSD phase/status in Claude's status bar |
| `gsd-workflow-guard.js` | PreToolUse | Additional workflow safety checks |
| `auto-ralph.sh` | UserPromptSubmit | Auto-triggers Ralph Loop when `--loop` is in prompt |

---

## 5. Install CCNotify (Desktop Notifications)

Sends macOS native notifications when Claude finishes tasks.

```bash
pip3 install terminal-notifier  # or: brew install terminal-notifier
mkdir -p ~/.claude/ccnotify
cp ccnotify/ccnotify.py ~/.claude/ccnotify/
```

---

## 6. Install Dippy (Safe Bash Execution)

Auto-approves safe bash commands, prompts for destructive ones.

```bash
git clone https://github.com/ldayton/Dippy.git /tmp/Dippy
pip3 install /tmp/Dippy
```

---

## 7. Install Recall (Session Search)

Full-text search across all Claude Code sessions.

```bash
# Download binary from: https://github.com/BerriAI/recall
# Place at ~/bin/recall and chmod +x
mkdir -p ~/bin
# then add ~/bin to PATH in ~/.zshrc
```

---

## 8. Install Ralph Loop Plugin

Self-referential iteration loop — Claude keeps working until done.

```bash
claude plugins install ralph-loop
```

Or copy from `plugins/ralph-loop/` in this repo into:
`~/.claude/plugins/cache/claude-plugins-official/ralph-loop/`

**Auto-trigger usage** (via `auto-ralph.sh` hook):
```
fix all failing tests --loop --completion-promise "ALL PASSING" --max-iterations 15
build a REST API --loop --completion-promise "DONE" --max-iterations 30
```

---

## 9. Wire Up settings.json

Copy `settings.example.json` as your base and add to `~/.claude/settings.json`:

```bash
cp settings.example.json ~/.claude/settings.json
```

The settings file wires all hooks into Claude Code's lifecycle events:
- **SessionStart** → GSD update check
- **PreToolUse (Bash)** → Dippy safety check
- **PreToolUse (Write/Edit)** → GSD prompt guard
- **PostToolUse** → GSD context monitor
- **UserPromptSubmit** → CCNotify + auto-ralph
- **Stop** → CCNotify
- **Notification** → CCNotify

---

## 10. MCP Servers

Add these to your project's `.mcp.json` or global MCP config:

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": ["n8n-mcp"],
      "env": {
        "N8N_API_URL": "http://localhost:5678/api/v1",
        "N8N_API_KEY": "YOUR_N8N_API_KEY"
      }
    }
  }
}
```

For Notion, Figma, and Canva MCP: connect via `claude.ai` integrations panel.

---

## Full Stack Summary

```
Claude Code
├── Skills (~38)         — task-specific expert modules, auto-trigger on intent
├── GSD                  — phase-based project management + 18 sub-agents
├── Ruflo                — multi-agent swarm orchestration (60+ agents, WASM acceleration)
├── Hooks (6)            — always-on background automation and safety
├── Ralph Loop           — iterative self-correction loop (--loop flag anywhere)
├── CCNotify             — macOS desktop notifications
├── Dippy                — bash command safety interceptor
├── Recall               — full-text search across all sessions
└── MCP Servers          — live access to n8n, Notion, Figma, Canva
```
