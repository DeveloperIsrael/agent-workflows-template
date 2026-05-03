#!/usr/bin/env bash
# PreToolUse hook: when Claude runs `git commit`, lint staged files with Biome.
#
# Parses the tool-input JSON from stdin, detects bash commands that start
# with `git commit`, and runs `pnpm exec biome check` scoped to currently
# STAGED files only — never touching unrelated parts of the codebase.
#
# Exits 0 to allow the commit. Exits 2 to block (Claude Code surfaces the
# stdout as the block reason). Exits 0 silently for any non-commit bash call.
#
# To activate: register in .claude/settings.json under hooks.PreToolUse for tool "Bash".
# Requires: pnpm or npm with biome installed (`@biomejs/biome`).

set -u

PAYLOAD=""
if [ ! -t 0 ]; then
    PAYLOAD=$(cat)
fi

if [ -z "$PAYLOAD" ]; then
    exit 0
fi

# Extract tool_input.command field using node (avoids requiring jq).
COMMAND=$(node -e "
try {
    const p = JSON.parse(process.argv[1] || '{}');
    const cmd = (p.tool_input && p.tool_input.command) || '';
    process.stdout.write(cmd);
} catch (_) { process.exit(0); }
" "$PAYLOAD" 2>/dev/null)

# Only act on git commit invocations.
case "$COMMAND" in
    *"git commit"*) ;;
    *) exit 0 ;;
esac

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

cd "$REPO_ROOT" || exit 0

# Match TS/JS files anywhere in the repo. Adjust the regex if you want to
# scope to a specific workspace (e.g. '^apps/.*\.(ts|tsx)$').
STAGED=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\.(ts|tsx|js|jsx|mjs|cjs)$' || true)
if [ -z "$STAGED" ]; then
    exit 0
fi

# Pick package manager (prefer pnpm, fall back to npm).
if command -v pnpm >/dev/null 2>&1; then
    PM="pnpm --silent exec"
elif command -v npm >/dev/null 2>&1; then
    PM="npx --silent"
else
    exit 0
fi

OUTPUT=$(echo "$STAGED" | xargs -r $PM biome check 2>&1)
EXIT=$?

if [ $EXIT -eq 0 ]; then
    exit 0
fi

echo "[biome-precommit] Blocking commit — biome found issues in staged files:"
echo "$OUTPUT" | head -30
echo ""
echo "Fix with: biome check --write <files>  (only staged files)"
exit 2
