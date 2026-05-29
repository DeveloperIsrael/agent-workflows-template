---
description: "Close a task using the canonical closure flow."
model: sonnet
effort: medium
---

# /sdd:close

Load and follow the canonical skill `task-flow`.

Do not duplicate the skill phases here. This command is only a thin entry point for the workflow semantics maintained in `.agents/skills/task-flow/SKILL.md`.

Safety boundary:

- `task-flow` orchestrates closure by invoking sub-skills via the `Skill` tool: `git-commit` → `update-docs` → `pre-pr-checks` (+ `codex-review` when triggers match) → tracker status/comment (optional).
- If the task went through `/sdd:spec` or `/sdd:execute`, run `/sdd:review` (→ `PASS`) before closing, unless the user explicitly skips it.
- Tracker steps (status → in_review, summary comment) are optional — without a tracker, the summary goes in the PR body.
- Do not mark a task `done`/`finished` without explicit confirmation — closure sets `in_review` (awaiting QA/review).
