---
description: "Create or refresh an execution-ready spec package in .specs/."
argument-hint: "[task-id | branch | brief | --dry-run]"
model: opus
effort: high
---

# /sdd:spec

Use `$ARGUMENTS` as the planning input.

Load and follow the canonical skill `sdd-spec`.

Do not duplicate the skill phases here. This command is only a thin entry point for the workflow semantics maintained in `.agents/skills/sdd-spec/SKILL.md`.

Safety boundary:

- This command may read the tracker (if any), `context/`, and codebase when needed.
- This command may write only inside `.specs/<slug>/`.
- This command must not create or update tracker tasks, comments, statuses, timers, branches, commits, pushes, PRs, migrations, deployments, or external state.
- If `$ARGUMENTS` include `--dry-run`, `teste seco`, `dry run`, `diagnostico`, or `check`, produce the plan/report in chat only and do not edit files.
