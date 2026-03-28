#!/bin/bash
# auto-ruflo.sh — UserPromptSubmit hook
# Auto-triggers Ruflo swarm/hive-mind when prompt contains --swarm or --hive flags.
#
# Usage in your prompt:
#   build a full REST API with tests --swarm
#   refactor the entire auth system --swarm --agents 8
#   build the dashboard UI --hive 5
#
# Flags:
#   --swarm              Start a Ruflo development swarm (default 3 agents)
#   --swarm --agents N   Start swarm with N agents
#   --hive N             Spawn N-agent hive-mind with queen coordination (default 5)
#   --strategy S         Swarm strategy: development (default), research, testing, refactoring
#
# The clean task (flags stripped) becomes the swarm objective.
# Ruflo MCP server is auto-started if not already running.

set -euo pipefail

HOOK_INPUT=$(cat)
PROMPT=$(echo "$HOOK_INPUT" | jq -r '.prompt // ""')

# Only activate if --swarm or --hive flag is present
if ! echo "$PROMPT" | grep -qE '(^| )--(swarm|hive)( |$| [0-9])'; then
  exit 0
fi

# Check ruflo is installed
if ! command -v ruflo &>/dev/null; then
  echo "⚠️  auto-ruflo: ruflo not found. Install with: npm install -g ruflo@latest" >&2
  exit 0
fi

# --- Parse flags ---

MODE="swarm"
AGENT_COUNT=3
STRATEGY="development"

# --hive N mode
if echo "$PROMPT" | grep -qE '(^| )--hive( |$)'; then
  MODE="hive"
  AGENT_COUNT=5
  # Extract count after --hive if it's a number
  HIVE_COUNT=$(echo "$PROMPT" | sed 's/.*--hive[[:space:]]*//' | awk '{print $1}' | grep -E '^[0-9]+$' || true)
  [[ -n "$HIVE_COUNT" ]] && AGENT_COUNT="$HIVE_COUNT"
fi

# --agents N (overrides default count for --swarm)
if echo "$PROMPT" | grep -qE '(^| )--agents[[:space:]]+[0-9]'; then
  AGENT_COUNT=$(echo "$PROMPT" | sed 's/.*--agents[[:space:]]*//' | awk '{print $1}' | grep -E '^[0-9]+$' || echo "$AGENT_COUNT")
fi

# --strategy S
if echo "$PROMPT" | grep -qE '(^| )--strategy[[:space:]]'; then
  STRATEGY=$(echo "$PROMPT" | sed 's/.*--strategy[[:space:]]*//' | awk '{print $1}' | tr -cd '[:alnum:]_-')
fi

# --- Strip all Ruflo flags from prompt to get clean objective ---
OBJECTIVE=$(echo "$PROMPT" | \
  sed 's/--hive[[:space:]]*[0-9]*//g' | \
  sed 's/--swarm//g' | \
  sed 's/--agents[[:space:]]*[0-9]*//g' | \
  sed 's/--strategy[[:space:]]*[[:alnum:]_-]*//g' | \
  sed 's/  */ /g' | \
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [[ -z "$OBJECTIVE" ]]; then
  echo "⚠️  auto-ruflo: Prompt is empty after stripping Ruflo flags. Skipping." >&2
  exit 0
fi

# --- Ensure Ruflo MCP server is running ---
MCP_STATUS=$(ruflo mcp status 2>/dev/null | grep -i 'running\|active\|started' || true)
if [[ -z "$MCP_STATUS" ]]; then
  echo "🔌 auto-ruflo: Starting Ruflo MCP server..." >&2
  ruflo mcp start &>/dev/null &
  sleep 1
fi

# --- Launch swarm or hive-mind ---
if [[ "$MODE" == "hive" ]]; then
  echo "🐝 auto-ruflo: Spawning hive-mind ($AGENT_COUNT agents)..." >&2
  echo "   Objective: $OBJECTIVE" >&2
  ruflo hive-mind spawn -n "$AGENT_COUNT" -o "$OBJECTIVE" &>/tmp/ruflo-hive.log &
  RUFLO_PID=$!
  echo ""
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║  Ruflo Hive-Mind Activated                               ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  Mode:       Hive-Mind (queen + $AGENT_COUNT workers)"
  echo "  Objective:  $OBJECTIVE"
  echo "  PID:        $RUFLO_PID"
  echo "  Logs:       tail -f /tmp/ruflo-hive.log"
  echo ""
  echo "  Monitor:    ruflo hive-mind status"
  echo "  Stop:       ruflo hive-mind shutdown"
  echo ""
else
  echo "🌊 auto-ruflo: Starting development swarm ($AGENT_COUNT agents, strategy: $STRATEGY)..." >&2
  echo "   Objective: $OBJECTIVE" >&2
  ruflo swarm start -o "$OBJECTIVE" -s "$STRATEGY" &>/tmp/ruflo-swarm.log &
  RUFLO_PID=$!
  # Scale to requested agent count if > default
  if [[ "$AGENT_COUNT" -gt 1 ]]; then
    sleep 1
    ruflo swarm scale "$AGENT_COUNT" &>/dev/null || true
  fi
  echo ""
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║  Ruflo Swarm Activated                                   ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  Mode:       Swarm ($AGENT_COUNT agents, $STRATEGY)"
  echo "  Objective:  $OBJECTIVE"
  echo "  PID:        $RUFLO_PID"
  echo "  Logs:       tail -f /tmp/ruflo-swarm.log"
  echo ""
  echo "  Monitor:    ruflo swarm status"
  echo "  Stop:       ruflo swarm stop"
  echo ""
fi
