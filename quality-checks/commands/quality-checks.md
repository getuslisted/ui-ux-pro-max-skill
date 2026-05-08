---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(node:*), Bash(python3:*), Bash(rg:*), Read, Glob, Grep, LS, Task
description: Final-line-of-defense quality pipeline. Nine phases. Composes security, design, and UI/UX intelligence.
argument-hint: "[phase=N|N,N,N] [target=path]"
---

You are running Quality Checks, the nine-phase pipeline defined in this repo's `quality-checks/` folder.

## Inputs

```
!`git status`
!`git diff --name-only origin/HEAD...`
!`git log --no-decorate origin/HEAD...`
!`git diff --merge-base origin/HEAD`
```

## Argument parsing

- `phase=N` runs only phase N (1-9).
- `phase=N,M,P` runs only those phases.
- `target=<path>` scopes to a path or `<paste>` for raw HTML.
- No arguments runs all nine phases on the current branch diff.

## Reference loading

Load `quality-checks/PIPELINE.md`, `RUBRIC.md`, `CHECKLIST.md`, `ANTIPATTERNS.md`, `COPY-DENYLIST.md`. Load `BLOCKS.md` only when verdict suggests paste-replacement.

If any reference is missing, halt.

## Discovery (Phase 0)

1. **Register**. Task cue, surface, then `PRODUCT.md`. First match wins.
2. **Design system map**. Walk for tokens.
3. **Stack**. From `package.json`, framework configs, file extensions.
4. **Industry**. Match against this repo's 161 reasoning rules (`data/products.csv`).
5. **Anti-references**. Pull from `PRODUCT.md`.

If `PRODUCT.md` is missing or trivial, halt and instruct user to run `/impeccable teach`.

## Phase execution

Per `PIPELINE.md`. State each phase. Run checks. Record findings (P0-P3). Score 0-4 where applicable.

Use Task sub-tasks where parallelism helps:
- Phase 1: identify findings, then parallel false-positive sub-tasks. Confidence ≥ 8.
- Phase 4: parallel per file.
- Phase 8: per stack-relevant file.

## Composite & sign-off

1. Audit Health Score /20. Map to band.
2. Severity census: P0 / P1 / P2 / P3.
3. Security verdict: pass if zero HIGH, zero MEDIUM ≥ 0.85.
4. Verdict: per `RUBRIC.md`.
5. Recommended commands in priority order.

## Output

The report from `RUBRIC.md`'s template. Markdown only.

If **Hold**, end with the next command. If **Ready to ship**, end with the literal text `Ready to ship.`

Begin discovery now.
