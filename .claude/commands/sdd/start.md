---
description: "Start a task workflow from a description (tracker optional)."
argument-hint: "[task description]"
model: sonnet
effort: medium
---

# /sdd:start

Use `$ARGUMENTS` as the description of the work to start.

Load and follow the canonical skill `task-start`.

Do not duplicate the skill phases here. This command is only a thin entry point for the workflow semantics maintained in `.agents/skills/task-start/SKILL.md`.

Safety boundary:

- This command runs the real task-start ritual and **may perform mutations** allowed by `task-start` (create a branch; sync/create a tracker task and start a timer only if the project uses a tracker). For a dry-run / wiring check, use `/sdd:doctor` instead.
- Tracker steps are optional — if the project has no tracker, the unit of work is the branch; do not invent one.
- After init, the skill points to `architecture-rules` / `workflow-governance`, and recommends `/sdd:spec` when the work is risky, ambiguous, multi-file, or architectural.
