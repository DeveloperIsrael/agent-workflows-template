#!/usr/bin/env bash
# PostToolUse hook: lints Python files after Edit/Write/MultiEdit using ruff.
#
# Same philosophy as tsc-check-changed.sh: informational, non-blocking,
# capped at 20s. Surfaces ruff diagnostics so Claude can react.
#
# To activate: register in .claude/settings.json under hooks.PostToolUse for tools
# Edit/Write/MultiEdit.
# Requires: ruff installed (`uv tool install ruff` or `pip install ruff`).

set -u

if [ ! -t 0 ]; then
    cat > /dev/null
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

cd "$REPO_ROOT" || exit 0

if ! command -v ruff >/dev/null 2>&1; then
    exit 0
fi

# Skip if no Python project markers.
if [ ! -f pyproject.toml ] && [ ! -f setup.py ] && [ ! -f requirements.txt ]; then
    exit 0
fi

OUTPUT=$(timeout 20 ruff check . 2>&1 | head -15)
EXIT=$?

if [ $EXIT -eq 0 ]; then
    exit 0
fi

if [ $EXIT -eq 124 ]; then
    echo "[ruff-check] skipped (timed out after 20s)"
    exit 0
fi

echo "[ruff-check] lint errors after edit:"
echo "$OUTPUT"
exit 0
