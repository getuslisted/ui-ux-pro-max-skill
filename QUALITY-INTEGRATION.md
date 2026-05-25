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

1. Open the page in dev at 1024 px (or use `.quality/runner.html` served via `python3 -m http.server` to preview blocks at four widths).
2. For each fold, count primary CTAs. If more than one orange-gradient button, flag.
3. Count card grids on the page. If more than two with the same shape (icon + heading + text), flag.
4. Look for the hero-metric template (big number + small label + supporting stats + gradient accent). If present and not the only stats strip, flag.
5. Walk forms. If any has more than 5 visible fields, flag and ask whether trust has been earned.
6. Confirm the phone number is reachable above the fold on every page.

The reviewer notes findings in the PR body under "Phase 4". The runner does not produce them.

## Block library coverage

The block library at `getuslisted-website-v3/.quality/blocks/` now covers 16 of the patterns this skill catalogues for the "digital agency landing" product type:

| Block | Product-type pattern from `landing.csv` |
| --- | --- |
| 01 hero-split | Split hero with copy + visual |
| 02 services-grid | 4-up service tiles |
| 03 package-cards | 3-tier pricing strip |
| 04 feature-row | Alternating image + copy |
| 05 stats-strip | Number proof points |
| 06 cta-band | Strong conversion band |
| 07 faq | Accordion FAQ |
| 08 testimonial | Single quote card |
| 09 form-capture | Lead form (5 fields max) |
| 10 footer | Multi-column footer |
| 11 nav-mega | Fixed nav + mega menu + drawer |
| 12 location-grid | Local-SEO surface |
| 13 breadcrumb | aria-labelled breadcrumb with microdata |
| 14 schema-jsonld | LocalBusiness + WebPage + FAQPage |
| 15 blog-teaser | 3-up post grid |
| 16 trust-strip | Badge row |

A Phase 4 reviewer compares the page being shipped against these patterns. If a page introduces a NEW pattern not in the library, the reviewer asks: should we add a block, or is this one-off justified?

## Stack catalogue cross-reference

The block library is plain HTML + CSS + JS. The stack-specific guidelines under `src/ui-ux-pro-max/data/stacks/` are not consumed there. They become relevant when the team rebuilds a section in React, Next.js, Astro, or another stack listed in this skill's `--stack` flag.

When that happens, copy the equivalent block, adapt to the framework, and run the stack-specific guideline check from this skill's CLI as a preflight.

## Operational surfaces

Phase 4 has no CI gate (it is human-driven by definition). What CI does provide:

- **Per-phase status checks**: even though Phase 4 has no automated check, the other six phases (`quality / security`, `code`, `design`, `a11y`, `perf`, `prose`) each get a status. A reviewer who notices a fold-level issue can still merge the rest of the gate green and flag Phase 4 in the PR body.
- **Admin dashboard**: `.quality/admin/index.html` does not display Phase 4 counts (always 0), but the trend graph and noisy-files table surface the indirect signals (lots of new generic CTAs in one file, drift in design.hardcoded-hex, etc.) that often correlate with a UX heuristic issue.

## Updating the integration

When this skill adds a new product type, style, or anti-pattern:

1. Land the change in `src/ui-ux-pro-max/data/*.csv` here.
2. If the change adds a new anti-pattern that could be machine-checked: open an issue on `getuslisted-website-v3` to propose a new manifest check. The runner cannot reason about UX intent; only mechanical patterns (e.g. "more than one `<a class=\"btn--primary\">` per `.fold`") qualify.
3. If the change adds a new product type that the website should treat as canonical: document the fit in the website's `PRODUCT.md` (when one exists) or in `.quality/PHASES.md` Phase 4.
4. If the change is judgment-based: add a one-line bullet under Phase 4 in `getuslisted-website-v3/.quality/PHASES.md` so reviewers know to apply it.

Branch convention: `claude/code-review-quality-checks-*`.
