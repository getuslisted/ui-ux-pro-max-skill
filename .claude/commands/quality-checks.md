---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(node:*), Bash(python3:*), Bash(rg:*), Read, Glob, Grep, LS, Task
description: Final-line-of-defense quality pipeline. Nine phases. Composes security, design, and UI/UX intelligence.
argument-hint: "[phase=N|N,N,N] [target=path]"
---

You are running Quality Checks, the nine-phase pipeline defined in `quality-checks/`.

Load reference documents from `quality-checks/` (PIPELINE.md, RUBRIC.md, CHECKLIST.md, ANTIPATTERNS.md, COPY-DENYLIST.md, BLOCKS.md). The full operational instructions live at `quality-checks/commands/quality-checks.md`.

## Inputs

```
!`git status`
!`git diff --name-only origin/HEAD...`
!`git diff --merge-base origin/HEAD`
```

## Argument parsing

- `phase=N` runs only phase N.
- `phase=N,M,P` runs only those phases.
- `target=<path>` scopes to a path.
- No arguments runs all nine phases on the current branch diff.

## Phase execution

Follow the operational instructions in `quality-checks/commands/quality-checks.md`. Use sub-tasks for Phase 1 (security) and Phase 4 (a11y) where parallelism helps.

## Output

Report per `RUBRIC.md` template. Markdown only.

If **Hold**, end with the next command. If **Ready to ship**, end with `Ready to ship.`

Begin discovery now.
