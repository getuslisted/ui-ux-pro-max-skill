# Quality integration

This repo (`ui-ux-pro-max-skill`) supplies **Phase 4** of the unified `.quality/` pipeline at [`getuslisted-website-v3/.quality/`](https://github.com/getuslisted/getuslisted-website-v3/tree/claude/code-review-quality-checks-1deaY/.quality).

Phase 4 is the **human-driven UX heuristic review**. The runner cannot reason about whether a fold has too many CTAs or whether a card grid carries genuinely different content per cell, so the data layer here serves as the reviewer's reference rather than as machine-checkable rules.

## What feeds Phase 4

| Source | What the website reviewer pulls from it |
| --- | --- |
| [`src/ui-ux-pro-max/data/products.csv`](src/ui-ux-pro-max/data/) | Match the website to its closest product type (digital agency landing). The IA expectations for that product type set the bar. |
| `src/ui-ux-pro-max/data/styles.csv` | Confirm the dark + neon + glassmorphism family is well-scoped (no drift toward brutalism, claymorphism, or neumorphism mid-page). |
| `src/ui-ux-pro-max/data/colors.csv` | Validate the orange + cyan pairing reads as one strategy, not two. |
| `src/ui-ux-pro-max/data/typography.csv` | Confirm the Syne / Inter / Space Grotesk pairing is one of the catalogued combinations. |
| `src/ui-ux-pro-max/data/landing.csv` | Page structure: hero, services, packages, social proof, FAQ, CTA, footer. |
| `src/ui-ux-pro-max/data/ux.csv` | Anti-pattern catalogue: hero-metric template, identical card grids, modal-as-first-thought, etc. |

## How a Phase 4 review runs

1. Open the page in dev at 1024 px.
2. For each fold, count primary CTAs. If more than one, flag.
3. Count card grids on the page. If more than two with the same shape (icon + heading + text), flag.
4. Look for the hero-metric template (big number + small label + supporting stats + gradient accent). If present and not the only stats strip, flag.
5. Walk forms. If any has more than 5 visible fields, flag and ask whether trust has been earned.
6. Confirm the phone number is reachable above the fold on every page.

The reviewer notes findings in the PR body under \"Phase 4\". The runner does not produce them.

## Stack catalogue cross-reference

The unified blocks library at `getuslisted-website-v3/.quality/blocks/` is plain HTML + CSS + JS. The stack-specific guidelines under `src/ui-ux-pro-max/data/stacks/` are not consumed there. They become relevant when the team rebuilds a section in React, Next.js, Astro, or another stack listed in this skill's `--stack` flag.

When that happens, copy the equivalent block, adapt to the framework, and run the stack-specific guideline check from this skill's CLI as a preflight.

## Updating the integration

When this skill adds a new product type, style, or anti-pattern:

1. Land the change in `src/ui-ux-pro-max/data/*.csv` here.
2. If the change adds a new anti-pattern, add a one-line bullet under Phase 4 of `getuslisted-website-v3/.quality/PHASES.md`.
3. If the change adds a new product type that the website should treat as canonical, document the fit in the website's `PRODUCT.md` (when one exists) or in `.quality/PHASES.md` Phase 4.

Use the branch convention `claude/code-review-quality-checks-*` for cross-repo updates so the two diffs land together.
