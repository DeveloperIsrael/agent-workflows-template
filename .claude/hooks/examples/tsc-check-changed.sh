#!/usr/bin/env bash
# PostToolUse hook: type-checks the project after Edit/Write/MultiEdit.
#
# Runs with a timeout so a stuck tsc doesn't hang the Claude session. Only
# prints a summary (first 15 lines) of errors to keep terminal output small.
#
# Exits 0 always — PostToolUse should never block the session. tsc errors are
# surfaced as informational output for Claude to react to if needed.
#
# To activate: register in .claude/settings.json under hooks.PostToolUse for tools
# Edit/Write/MultiEdit.
# Requires: a TypeScript project with `tsc` available (via pnpm/npm or globally).
# Adjust WORKSPACE if your tsconfig lives in a sub-directory (e.g. `apps/web`).

set -u

# Read and discard stdin (Claude Code sends JSON payload; we don't need it)
if [ ! -t 0 ]; then
    cat > /dev/null
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

# Default to repo root. Override per project (uncomment one line):
WORKSPACE="$REPO_ROOT"
# WORKSPACE="$REPO_ROOT/apps/web"
# WORKSPACE="$REPO_ROOT/packages/core"

cd "$WORKSPACE" 2>/dev/null || exit 0

# Skip if there's no tsconfig in this workspace.
if [ ! -f tsconfig.json ]; then
    exit 0
fi

# Pick package manager.
if command -v pnpm >/dev/null 2>&1 && [ -f pnpm-lock.yaml -o -f "$REPO_ROOT/pnpm-lock.yaml" ]; then
    PM="pnpm --silent exec"
elif command -v npm >/dev/null 2>&1; then
    PM="npx --silent"
else
    exit 0
fi

# Lightweight: cap at 20s, show only first errors.
OUTPUT=$(timeout 20 $PM tsc --noEmit 2>&1 | head -15)
EXIT=$?

if [ $EXIT -eq 0 ]; then
    exit 0
fi

if [ $EXIT -eq 124 ]; then
    echo "[tsc-check] skipped (timed out after 20s)"
    exit 0
fi

echo "[tsc-check] type errors after edit:"
echo "$OUTPUT"
exit 0
