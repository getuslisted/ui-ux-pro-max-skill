---
name: quality-gate
description: "Use as a final pre-ship pass on UI work. Runs eight sequential checks (preflight, security, industry reasoning, design laws, accessibility & performance, hardening, streamline, pre-delivery checklist) against pending changes or a named target. Synthesizes claude-code-security-review, impeccable, and ui-ux-pro-max-skill into one gate. Blocks ship when a P0 or P1 finding is unmitigated. Use after the feature is functionally complete; not a substitute for running impeccable's polish or harden during build."
argument-hint: "[target] [--phase <1-8>] [--strict]"
user-invocable: true
allowed-tools:
  - Bash(git diff:*)
  - Bash(git status:*)
  - Bash(git log:*)
  - Bash(git show:*)
  - Bash(node *)
  - Bash(npx *)
  - Read
  - Glob
  - Grep
license: Apache 2.0. Synthesizes patterns from claude-code-security-review (MIT), impeccable (Apache 2.0), and ui-ux-pro-max-skill (MIT). See each upstream for attribution.
---

A final pre-ship pass. Runs eight phases against the changed code (or a named target), assigns severity and confidence to every finding, and decides ship-or-block. Designed to be the last thing run before a feature ships.

## When to invoke

- After functional completion, before opening the PR.
- Before merging, on every push to a release branch.
- After a security-relevant change (auth, deserialization, file IO, query construction).
- After a UI-visible change.

## The eight phases

| # | Phase | What it checks |
|---|---|---|
| 1 | **Preflight** | Context gates, register, stack, target inventory |
| 2 | **Security** | High-confidence vulnerability scan with hard exclusions |
| 3 | **Reasoning** | Industry pattern / style / color / typography fit (uses ui-ux-pro-max's 161 product-type rules) |
| 4 | **Design laws** | Shared laws + absolute bans + AI slop test |
| 5 | **A11y & performance** | WCAG AA, focus path, Core Web Vitals, responsive |
| 6 | **Harden** | Text overflow, i18n, errors, edge cases, network |
| 7 | **Streamline** | Design system alignment, drift root-cause, distill |
| 8 | **Pre-delivery checklist** | Final gate (synthesizes ui-ux-pro-max's pre-delivery checklist) |

The full reference files (one per phase) live in `quality-gate/reference/phases/` in the canonical repo (`claude-code-security-review` on the same branch).

## Severity and confidence

**Severity:**
- **P0**: Block ship now. Exploitable vuln (conf ≥ 8), broken core flow, complete a11y failure.
- **P1**: Block ship before release. WCAG AA violation, absolute ban present, missing required state.
- **P2**: Fix in next pass. Token drift, minor responsive break, copy inconsistency.
- **P3**: Polish. Pixel alignment, micro-interaction tuning.

**Confidence:**
- **9–10**: Direct evidence cited. Report and act.
- **7–8**: Strong pattern. Report.
- **4–6**: Surface as a question, not a finding.
- **1–3**: Drop.

The hard rule: never report under confidence 7.

## Phase 3: the reasoning engine

This skill's reasoning rules drive phase 3. The phase scores four dimensions (each 0–4):

- **Pattern fit**: page structure matches conversion logic for the product type.
- **Color mood fit**: palette matches industry's emotional register.
- **Typography mood fit**: type pairing matches voice.
- **Effect register fit**: motion and interaction effects appropriate for register.

Then runs the category-reflex check at two altitudes to catch the AI default. A surface that passes both altitudes is recognizably itself, not a category template.

## Phase 8: the pre-delivery checklist

Direct synthesis of this skill's pre-delivery checklist plus impeccable's polish checklist. Walk the boolean list; any unchecked item is a P1 blocker.

## Routing

| Argument | Behavior |
|---|---|
| (none) | Scope to `git diff --merge-base origin/HEAD`. Run all 8 phases. |
| `<target>` | Scope to a path, component name, or feature label. |
| `--phase <n>` | Run only the named phase (1–8). |
| `--strict` | Block on P2 in addition to P0/P1. |
| `--no-security` | Skip phase 2. |

## Block recipes

When a finding's recommendation says "use the canonical pattern," the canonical patterns live in `quality-gate/reference/block-recipes.md` (in claude-code-security-review on the same branch). Covers buttons, inputs, cards, alerts, empty/error/loading states, modals, forms, navigation.
