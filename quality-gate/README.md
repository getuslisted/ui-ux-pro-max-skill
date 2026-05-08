# Quality Gate

A final-line-of-defense skill that runs eight sequential checks against pending changes before they ship. Built directly on ui-ux-pro-max-skill's reasoning vocabulary; synthesizes two complementary skills:

- **[claude-code-security-review](https://github.com/getuslisted/claude-code-security-review)**: high-confidence vulnerability scan, hard exclusions, confidence-gated findings.
- **[impeccable](https://github.com/getuslisted/impeccable)**: shared design laws, absolute bans, AI slop test, audit dimensions, hardening.
- **[ui-ux-pro-max-skill](https://github.com/getuslisted/ui-ux-pro-max-skill)** (this repo): industry pattern matching, color and typography moods, pre-delivery checklist.

## How it relates to ui-ux-pro-max-skill

This gate's **phase 3 (Reasoning)** is the direct synthesis of this skill's reasoning engine: 161 product-type rules, 67 UI styles, 161 color palettes, 57 font pairings, 25 chart types. Phase 3 scores the surface against four dimensions (pattern fit, color mood fit, typography mood fit, effect register fit), then runs the category-reflex check at two altitudes to catch the AI default reflex.

The gate's **phase 8 (Pre-delivery checklist)** also synthesizes this skill's pre-delivery checklist directly: no emojis as icons, cursor-pointer on all clickable elements, hover transitions 150–300ms, contrast 4.5:1 minimum, focus states visible for keyboard navigation, prefers-reduced-motion respected, responsive at 375 / 768 / 1024 / 1440px.

## What it does

Runs in eight phases against the diff (or a named target). Every finding gets a severity (P0–P3) and a confidence score (1–10). Findings under confidence 7 are dropped. Anything P0 or P1 blocks ship.

| # | Phase | Source | Blocks ship at |
|---|---|---|---|
| 1 | Preflight | impeccable setup gates | Missing PRODUCT.md/DESIGN.md, ambiguous register |
| 2 | Security | claude-code-security-review | HIGH-severity vuln with confidence ≥8 |
| 3 | **Reasoning** | **ui-ux-pro-max-skill** | Pattern/color/type mismatch with industry register |
| 4 | Design laws | impeccable shared laws + bans | Any absolute ban present, failed AI slop test |
| 5 | A11y & performance | impeccable audit + WCAG/CWV | WCAG AA contrast or focus failure |
| 6 | Hardening | impeccable harden | Unbounded text, missing error/empty/loading state |
| 7 | Streamline | impeccable polish + distill | Drift unaccounted for, dead code, hard-coded tokens |
| 8 | **Pre-delivery checklist** | **ui-ux-pro-max + synthesis** | Any unchecked item |

## The reasoning phase (this skill's contribution)

### Step 1: Identify product type

Maps the project to one of eight buckets, then to a specific category within (161 total). The category determines the conversion logic, color mood, typography mood, and effect register the gate expects.

### Step 2: Score the four reasoning dimensions (each 0–4)

- **Pattern fit**: page structure matches conversion logic for the product type.
- **Color mood fit**: palette matches industry's emotional register without being inappropriate.
- **Typography mood fit**: type pairing matches voice.
- **Effect register fit**: motion and interaction effects appropriate for register.

### Step 3: Category-reflex check (two altitudes)

The critical step. Separates "appropriate for the category" from "the AI default for the category."

**First-order reflex (BLOCK):**
- Observability → dark blue + neon green + terminal aesthetic
- Healthcare → white + teal + soft drop shadow
- Banking → navy + gold + geometric sans
- Crypto → neon on black + glitch + gradient meshes
- AI products → purple-to-blue gradient + glassmorphism + Inter
- Wellness → pastel pink + sage + Cormorant + soft shadows
- Children's → bright primaries + rounded squares + Quicksand

**Second-order reflex (BLOCK):**
- AI tool that's not SaaS-cream → editorial-typographic
- Fintech that's not navy-and-gold → terminal-native dark mode
- Wellness that's not pastel-pink → brutalist serif on cream
- Crypto that's not neon-on-black → Bauhaus geometry + primary colors
- Healthcare that's not white-teal → editorial newsprint

A surface that passes both altitudes is recognizably itself, not a category template.

## The pre-delivery checklist (this skill's contribution)

Phase 8 walks a single boolean list. Any unchecked item is a P1 blocker. Selected items the gate enforces:

- [ ] No emojis as icons (use SVG: Heroicons / Lucide / Phosphor)
- [ ] Cursor-pointer on all clickable elements
- [ ] Hover states with smooth transitions (150–300ms)
- [ ] Light mode: text contrast 4.5:1 minimum
- [ ] Focus states visible for keyboard navigation
- [ ] `prefers-reduced-motion` respected
- [ ] Responsive at 375 / 768 / 1024 / 1440px
- [ ] No fixed widths breaking on mobile
- [ ] Touch targets ≥ 44×44px on touch surfaces
- [ ] Tested at every breakpoint
- [ ] Empty state for every list / table / feed
- [ ] Loading state for every async action
- [ ] Error state for every async action
- [ ] User input preserved on validation error

The full checklist (54 items across 10 sections) is in `quality-gate/reference/phases/8-checklist.md` in the canonical repo.

## Canonical files

The full skill is in `claude-code-security-review` on the same branch (`claude/code-review-quality-checks-7BAJw`). The structure:

```
quality-gate/
├── SKILL.md                              # 8-phase orchestrator
├── reference/
│   ├── phases/
│   │   ├── 1-preflight.md
│   │   ├── 2-security.md
│   │   ├── 3-reasoning.md                # synthesizes this repo
│   │   ├── 4-design-laws.md
│   │   ├── 5-a11y-performance.md
│   │   ├── 6-harden.md
│   │   ├── 7-streamline.md
│   │   └── 8-checklist.md                # synthesizes this repo's checklist
│   ├── anti-patterns-catalog.md
│   ├── severity-and-confidence.md
│   └── block-recipes.md                  # canonical patterns that pass all 8 phases
└── README.md
```

## Severity and confidence

| Severity | Definition |
|---|---|
| **P0** | Blocks ship now. Exploitable vuln, broken core flow, complete a11y failure. |
| **P1** | Blocks ship before release. WCAG AA failure, absolute ban, missing required state. |
| **P2** | Fix in next pass. Token drift, minor responsive break. |
| **P3** | Polish. Pixel alignment, micro-interaction tuning. |

| Confidence | Action |
|---|---|
| **9–10** | Report and act. |
| **7–8** | Report. |
| **4–6** | Surface as a question. |
| **1–3** | Drop. |

## How this complements ui-ux-pro-max-skill

The reasoning engine in this skill is what the gate uses to make industry-appropriate calls. Without ui-ux-pro-max's vocabulary, phase 3 would be guessing. The gate is what the user runs to verify that the design system this skill recommended actually got applied correctly across the diff.

The persistence pattern (`design-system/MASTER.md` + `pages/<page>.md` overrides) from this skill is honored by the gate: phase 7 (Streamline) reads the design system files and uses them as the source of truth for drift detection.

## License

Apache 2.0. Synthesizes patterns from ui-ux-pro-max-skill (MIT), impeccable (Apache 2.0), and claude-code-security-review (MIT).
