#!/bin/bash
# auto-compress.sh — UserPromptSubmit hook
# Compresses verbose prompts and injects brevity instructions into model context.
#
# Usage: add --tight to any prompt
#   "explain how JWT works --tight"
#   "could you please review this code and tell me what I should improve --tight"
#   "I was wondering if you could help me understand the difference between X and Y --tight"
#
# What it does:
#   1. Strips filler/verbose opener patterns via regex
#   2. Injects additionalContext into model context with compressed prompt + brevity rules
#   3. Shows a systemMessage to user confirming compression is active
#
# Add --full to any prompt to suppress the brevity injection entirely.

set -euo pipefail

HOOK_INPUT=$(cat)
PROMPT=$(echo "$HOOK_INPUT" | jq -r '.prompt // ""')

# --full flag: explicitly opt out of any compression
if echo "$PROMPT" | grep -qE '(^| )--full( |$)'; then
  exit 0
fi

# Only activate compression if --tight flag is present
if ! echo "$PROMPT" | grep -qE '(^| )--tight( |$)'; then
  exit 0
fi

# --- Strip --tight flag from prompt ---
CLEAN=$(echo "$PROMPT" | sed 's/--tight//g' | sed 's/  */ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# --- Rule-based compression ---
# Strip opener filler phrases (case-insensitive via multiple patterns)
COMPRESSED="$CLEAN"

# Opener phrases — longest match first to avoid partial stripping
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Cc]ould you please[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Cc]ould you[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Cc]an you please[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Cc]an you[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Pp]lease[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ww]ould you[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ww]ould you please[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ww]ould you be able to[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ii] want you to[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ii] need you to[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ii] would like you to[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ii] was wondering if you could[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ii] was wondering if[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ff]eel free to[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Hh]ey[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Hh]i[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Hh]ello[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/^[Ss]o[,]* //g')

# Verbose patterns to compress mid-sentence
COMPRESSED=$(echo "$COMPRESSED" | sed 's/explain to me in detail/explain/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/explain to me/explain/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/walk me through in detail/explain/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/give me a comprehensive overview of/overview:/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/give me a detailed explanation of/explain/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/what is the best way to/best way to/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/what would be the best way to/best way to/g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/in the context of this conversation[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/as we have discussed[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/as we discussed[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/as I mentioned[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/as mentioned[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/as previously mentioned[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/taking into account everything we.ve discussed[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/if possible[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/if you can[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/when you get a chance[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/do you think you could[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/I think[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/basically[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/essentially[,]* //g')
COMPRESSED=$(echo "$COMPRESSED" | sed 's/just[,]* //g')

# Capitalise first letter if opener was stripped and result starts lowercase
FIRST=$(echo "$COMPRESSED" | cut -c1)
if echo "$FIRST" | grep -q '[a-z]'; then
  REST=$(echo "$COMPRESSED" | cut -c2-)
  UPPER=$(echo "$FIRST" | tr '[:lower:]' '[:upper:]')
  COMPRESSED="${UPPER}${REST}"
fi

# Clean up double spaces
COMPRESSED=$(echo "$COMPRESSED" | sed 's/  */ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# --- Count tokens saved (rough: words removed) ---
ORIGINAL_WORDS=$(echo "$CLEAN" | wc -w | tr -d ' ')
COMPRESSED_WORDS=$(echo "$COMPRESSED" | wc -w | tr -d ' ')
SAVED=$((ORIGINAL_WORDS - COMPRESSED_WORDS))

# --- Build brevity instruction for model context ---
ADDITIONAL_CONTEXT="[PROMPT OPTIMIZER ACTIVE]
Compressed prompt (use this interpretation): ${COMPRESSED}

Response rules — strictly follow:
- Answer only what was asked. Nothing more.
- No preamble (do not restate the question or say 'Great question').
- No trailing summary or sign-off.
- No filler phrases ('Of course!', 'Certainly!', 'Sure!', 'Absolutely!').
- No unsolicited advice, caveats, or alternatives unless directly relevant.
- Use the minimum tokens needed to fully answer.
- If a one-sentence answer is complete, give one sentence."

# --- Build system message for user UI ---
if [[ "$SAVED" -gt 0 ]]; then
  SYS_MSG="⚡ --tight: ${SAVED} filler words stripped. Brevity mode active."
else
  SYS_MSG="⚡ --tight: Brevity mode active (prompt already clean)."
fi

# --- Output hook response ---
jq -n \
  --arg ctx "$ADDITIONAL_CONTEXT" \
  --arg msg "$SYS_MSG" \
  '{
    "additionalContext": $ctx,
    "systemMessage": $msg
  }'
