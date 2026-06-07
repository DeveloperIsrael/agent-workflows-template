---
description: "Diagnose SDD workflow and skill wiring without mutations."
argument-hint: "[optional diagnostic note]"
model: haiku
effort: low
---

# /sdd:doctor

Use `$ARGUMENTS` only as optional context for the diagnostic report.

This command is read-only. It must not create or update tracker tasks, start/stop timers, create/switch/delete branches, commit, push, edit files, run formatters, change Git config, or perform any other mutation.

`teste seco` must not be used with `/sdd:start`: that command runs the real task-start workflow and may perform real mutations. Use `/sdd:doctor` for dry-run and wiring diagnostics.

Do not duplicate the phases from `task-start`, `sdd-spec`, `sdd-execute`, `sdd-review`, or `task-flow`. Only diagnose whether their entry points and dependencies appear ready.

## Checks

Run these read-only shell checks:

1. Current branch: `git branch --show-current`.
2. Working tree: `git status --short --branch`.
3. Hooks path: `git config --get core.hooksPath`. If the project ships a `.githooks/` directory and the config does not point to it, report `WARN` and recommend `git config core.hooksPath .githooks`, but do not run it. If there is no `.githooks/`, this check is `N/A`.
4. Skill files exist (provider mirror under `.claude/skills/`, source under `.agents/skills/`):
   - `task-start`, `task-flow`
   - `sdd-spec`, `sdd-execute`, `sdd-review`
   - `git-commit`, `update-docs`, `pre-pr-checks`
5. Skill loading — confirm each resolves:
   - `Skill(skill: "task-start")`, `Skill(skill: "task-flow")`
   - `Skill(skill: "sdd-spec")`, `Skill(skill: "sdd-execute")`, `Skill(skill: "sdd-review")`
   - `Skill(skill: "git-commit")`, `Skill(skill: "update-docs")`, `Skill(skill: "pre-pr-checks")`

If any skill load fails, report remediation: recreate the provider symlink to the canonical file, e.g. `ln -s ../../.agents/skills/<skill> .claude/skills/<skill>`, and inspect `.agents/skills/<skill>/SKILL.md`.

Check tracker availability in read-only mode only. If the project uses a tracker (MCP/CLI exposed) and a read-only discovery/search/listing tool is available, report which names are available. **If no tracker tool is available, report `WARN`, never `FAIL`** — the tracker is optional in this workflow. Do not create tasks, comments, updates, or time entries.

## Output

Return a concise table or checklist with `PASS`, `WARN`, `FAIL`, or `N/A`; evidence from the read-only check; and short remediation when needed.

End with a clear conclusion stating whether `/sdd:start`, `/sdd:spec`, `/sdd:execute`, `/sdd:review`, and `/sdd:close` appear safe for real use, or what must be fixed first.
