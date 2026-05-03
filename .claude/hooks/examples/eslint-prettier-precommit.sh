#!/usr/bin/env bash
# PreToolUse hook: when Claude runs `git commit`, lint staged JS/TS files with
# ESLint and check formatting with Prettier.
#
# Same pattern as biome-precommit.sh but for projects that use eslint+prettier.
# Exits 0 to allow, 2 to block. Silent for non-commit bash calls.
#
# To activate: register in .claude/settings.json under hooks.PreToolUse for tool "Bash".
# Requires: eslint and prettier installed in the project (`pnpm add -D eslint prettier`).

set -u

PAYLOAD=""
if [ ! -t 0 ]; then
    PAYLOAD=$(cat)
fi

if [ -z "$PAYLOAD" ]; then
    exit 0
fi

COMMAND=$(node -e "
try {
    const p = JSON.parse(process.argv[1] || '{}');
    const cmd = (p.tool_input && p.tool_input.command) || '';
    process.stdout.write(cmd);
} catch (_) { process.exit(0); }
" "$PAYLOAD" 2>/dev/null)

case "$COMMAND" in
    *"git commit"*) ;;
    *) exit 0 ;;
esac

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

cd "$REPO_ROOT" || exit 0

STAGED=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\.(ts|tsx|js|jsx|mjs|cjs)$' || true)
if [ -z "$STAGED" ]; then
    exit 0
fi

if command -v pnpm >/dev/null 2>&1; then
    PM="pnpm --silent exec"
elif command -v npm >/dev/null 2>&1; then
    PM="npx --silent"
else
    exit 0
fi

ESLINT_OUT=$(echo "$STAGED" | xargs -r $PM eslint 2>&1)
ESLINT_EXIT=$?

PRETTIER_OUT=$(echo "$STAGED" | xargs -r $PM prettier --check 2>&1)
PRETTIER_EXIT=$?

if [ $ESLINT_EXIT -eq 0 ] && [ $PRETTIER_EXIT -eq 0 ]; then
    exit 0
fi

echo "[eslint-prettier-precommit] Blocking commit — issues in staged files:"
[ $ESLINT_EXIT -ne 0 ] && { echo "--- eslint ---"; echo "$ESLINT_OUT" | head -20; }
[ $PRETTIER_EXIT -ne 0 ] && { echo "--- prettier ---"; echo "$PRETTIER_OUT" | head -10; }
echo ""
echo "Fix with: eslint --fix <files>  &&  prettier --write <files>"
exit 2
