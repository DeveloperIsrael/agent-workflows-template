---
description: "Review a completed spec execution, branch diff, or PR before closure."
argument-hint: "[.specs/<slug> | branch | PR | --dry-run]"
model: opus
effort: high
---

# /sdd:review

Use `$ARGUMENTS` to resolve the review target (spec package, branch, or PR).

Load and follow the canonical skill `sdd-review`.

Do not duplicate the skill phases here. This command is only a thin entry point for the workflow semantics maintained in `.agents/skills/sdd-review/SKILL.md`.

Safety boundary:

- This command is read-only. It may read specs/diffs/code/docs/tests and run read-only commands (`git diff`, `git status`, `git show`, VCS-host CLI in read-only mode).
- This command must not edit files, mutate the tracker, create/switch branches, commit, push, open/approve PRs, post review comments without an explicit user request, or read secrets.
- If `$ARGUMENTS` include `--dry-run`, `teste seco`, `dry run`, `diagnostico`, or `check`, produce a readiness diagnostic only — no subagents, no expensive commands, no posting.
