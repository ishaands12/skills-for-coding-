#!/usr/bin/env bash
# self-anneal/run.sh
# Writes the PRD, then opens a new Terminal window running Ralphy on it.
#
# Usage: run.sh <prd-file> [project-dir]
#   prd-file    — path to the markdown PRD Claude already wrote (default: .tmp/self-anneal.md)
#   project-dir — project root (default: current directory)

set -euo pipefail

PRD_FILE="${1:-.tmp/self-anneal.md}"
PROJECT_DIR="${2:-$(pwd)}"

# Resolve to absolute paths so osascript can use them from any cwd
PRD_ABS="$(cd "$(dirname "$PRD_FILE")" && pwd)/$(basename "$PRD_FILE")"
PROGRESS_ABS="$PROJECT_DIR/.ralphy/progress.txt"

# Guard: PRD file must exist before we launch Ralphy
if [[ ! -f "$PRD_ABS" ]]; then
    echo "Error: PRD file not found at $PRD_ABS" >&2
    echo "Claude should write the PRD before calling this script." >&2
    exit 1
fi

# Ensure .ralphy dir exists so progress.txt has a home
mkdir -p "$PROJECT_DIR/.ralphy"

# Pick ralphy binary (global install preferred, npx fallback)
if command -v ralphy &>/dev/null; then
    RALPHY_CMD="ralphy"
else
    RALPHY_CMD="npx ralphy-cli"
fi

# Open a new Terminal.app window and run Ralphy inside it
osascript <<APPLESCRIPT
tell application "Terminal"
    activate
    set w to do script "cd '$PROJECT_DIR' \
&& echo '' \
&& echo '╔══════════════════════════════════╗' \
&& echo '║       self-anneal via Ralphy     ║' \
&& echo '╚══════════════════════════════════╝' \
&& echo '' \
&& echo '  PRD:      $PRD_ABS' \
&& echo '  Progress: $PROGRESS_ABS' \
&& echo '' \
&& $RALPHY_CMD --prd '$PRD_ABS'"
end tell
APPLESCRIPT

# Print watch instructions back to the Claude session
echo ""
echo "Ralphy is running in a new Terminal window."
echo ""
echo "Files to watch:"
echo "  PRD (task list):  $PRD_ABS"
echo "  Progress log:     $PROGRESS_ABS"
echo ""
echo "The PRD shows [ ] → [x] as each task completes."
echo "The progress log has Ralphy's detailed output."
