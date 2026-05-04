#!/usr/bin/env bash
# PostToolUse hook: type-checks Python project after Edit/Write/MultiEdit using mypy.
#
# Informational, non-blocking. Capped at 20s. Pairs well with ruff-check.sh
# (ruff for lint, mypy for types).
#
# To activate: register in .claude/settings.json under hooks.PostToolUse for tools
# Edit/Write/MultiEdit.
# Requires: mypy installed (`uv tool install mypy` or `pip install mypy`).

set -u

if [ ! -t 0 ]; then
    cat > /dev/null
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

cd "$REPO_ROOT" || exit 0

if ! command -v mypy >/dev/null 2>&1; then
    exit 0
fi

if [ ! -f pyproject.toml ] && [ ! -f mypy.ini ] && [ ! -f setup.cfg ]; then
    exit 0
fi

OUTPUT=$(timeout 20 mypy . 2>&1 | head -15)
EXIT=$?

if [ $EXIT -eq 0 ]; then
    exit 0
fi

if [ $EXIT -eq 124 ]; then
    echo "[mypy-check] skipped (timed out after 20s)"
    exit 0
fi

echo "[mypy-check] type errors after edit:"
echo "$OUTPUT"
exit 0
