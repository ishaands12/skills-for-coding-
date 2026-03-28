#!/bin/bash
# auto-ralph.sh — UserPromptSubmit hook
# Auto-triggers Ralph Loop when the prompt contains --loop flag.
#
# Usage in your prompt:
#   build a REST API --loop --completion-promise "DONE" --max-iterations 20
#   fix all failing tests --loop --max-iterations 15
#   refactor the auth module --loop  (runs forever until you cancel)
#
# Strips --loop (and related flags) from the state file prompt so Ralph
# only sees the clean task description on each iteration.

set -euo pipefail

HOOK_INPUT=$(cat)
PROMPT=$(echo "$HOOK_INPUT" | jq -r '.prompt // ""')

# Only activate if --loop flag is present
if ! echo "$PROMPT" | grep -qE '(^| )--loop( |$)'; then
  exit 0
fi

# Find the active setup script (resolve 'unknown' symlink first, then any hash)
SETUP_SCRIPT=$(find "$HOME/.claude/plugins/cache/claude-plugins-official/ralph-loop/unknown/scripts" \
  -name "setup-ralph-loop.sh" 2>/dev/null | head -1)

if [[ -z "$SETUP_SCRIPT" ]]; then
  SETUP_SCRIPT=$(find "$HOME/.claude/plugins/cache/claude-plugins-official/ralph-loop" \
    -name "setup-ralph-loop.sh" 2>/dev/null | head -1)
fi

if [[ -z "$SETUP_SCRIPT" ]]; then
  echo "⚠️  auto-ralph: Could not find Ralph Loop setup script. Is the plugin installed?" >&2
  exit 0
fi

# Extract --completion-promise value (double-quoted, single-quoted, or unquoted single word)
COMPLETION_PROMISE=""
if echo "$PROMPT" | grep -qE -- '--completion-promise'; then
  # Double-quoted: --completion-promise "some text"
  COMPLETION_PROMISE=$(echo "$PROMPT" | sed -n 's/.*--completion-promise[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
  # Single-quoted fallback
  if [[ -z "$COMPLETION_PROMISE" ]]; then
    COMPLETION_PROMISE=$(echo "$PROMPT" | sed -n "s/.*--completion-promise[[:space:]]*'\([^']*\)'.*/\1/p" | head -1)
  fi
  # Unquoted single word fallback
  if [[ -z "$COMPLETION_PROMISE" ]]; then
    COMPLETION_PROMISE=$(echo "$PROMPT" | sed 's/.*--completion-promise[[:space:]]*//' | awk '{print $1}')
  fi
fi

# Extract --max-iterations value
MAX_ITERATIONS=""
if echo "$PROMPT" | grep -qE -- '--max-iterations'; then
  MAX_ITERATIONS=$(echo "$PROMPT" | sed 's/.*--max-iterations[[:space:]]*//' | awk '{print $1}' | grep -E '^[0-9]+$' || true)
fi

# Strip all Ralph-specific flags from the task description
# Handle quoted multi-word values (e.g. --completion-promise "ALL PASSING")
CLEAN_PROMPT=$(echo "$PROMPT" | \
  sed 's/--completion-promise[[:space:]]*"[^"]*"//g' | \
  sed "s/--completion-promise[[:space:]]*'[^']*'//g" | \
  sed 's/--completion-promise[[:space:]]*[^ ]*//g' | \
  sed 's/--max-iterations[[:space:]]*[0-9]*//g' | \
  sed 's/--loop//g' | \
  sed 's/  */ /g' | \
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [[ -z "$CLEAN_PROMPT" ]]; then
  echo "⚠️  auto-ralph: Prompt is empty after stripping Ralph flags. Skipping." >&2
  exit 0
fi

# Build args array
ARGS=("$CLEAN_PROMPT")
[[ -n "$COMPLETION_PROMISE" ]] && ARGS+=(--completion-promise "$COMPLETION_PROMISE")
[[ -n "$MAX_ITERATIONS" ]]    && ARGS+=(--max-iterations "$MAX_ITERATIONS")

echo "🔄 auto-ralph: Detected --loop flag, activating Ralph Loop..." >&2
bash "$SETUP_SCRIPT" "${ARGS[@]}"
