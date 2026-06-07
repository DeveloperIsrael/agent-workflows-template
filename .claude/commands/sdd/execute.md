---
description: "Execute an approved spec package without reopening planning."
argument-hint: "[.specs/<slug> | task-id | --dry-run]"
model: sonnet
effort: high
---

# /sdd:execute

Use `$ARGUMENTS` to resolve the approved spec package to execute.

Load and follow the canonical skill `sdd-execute`.

Do not duplicate the skill phases here. This command is only a thin entry point for the workflow semantics maintained in `.agents/skills/sdd-execute/SKILL.md`.

Safety boundary:

- This command consumes only a package whose status is `Approved for Execution`. If no approved package exists, the next step is `/sdd:spec`.
- This command may write only inside the write scope declared in the package's `EXECUTION_PLAN.md`.
- This command must not create or update tracker tasks/comments/statuses/timers, create/switch branches, commit, push, open PRs, merge, rebase, deploy, or touch forbidden files.
- If `$ARGUMENTS` include `--dry-run`, `teste seco`, `dry run`, `diagnostico`, or `check`, run preflight/readiness checks only and do not edit files or dispatch subagents.
