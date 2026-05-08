# Quality Verification

Maps the UI/UX Pro Max taxonomy (161 palettes, 57 font pairings, 99 UX guidelines, 25 chart types, 67 styles) to a verifiable 8-gate quality pipeline. Use this doc when you need **evidence-backed sign-off** on a design — before commit, before PR, before deploy.

This is the consumer-facing checklist for the same pipeline implemented by:

- the [`quality-checks`](https://github.com/getuslisted/claude-code/tree/main/plugins/quality-checks) plugin (claude-code) — `/quality-checks`
- the [`verify`](https://github.com/getuslisted/impeccable/blob/main/skill/reference/verify.md) command (impeccable) — `npx impeccable verify`
- the [`quality-checks-pipeline`](https://github.com/getuslisted/superpowers/tree/main/skills/quality-checks-pipeline) skill (superpowers)

If any of those tools are available, prefer them — they emit structured findings. Use this doc as the human-readable checklist or when none of the tools are installed.

## Why a verification gate, not a review

Reviews tell you what *might* be wrong. Verification tells you what *is* wrong, with a file path, a line number, and a measured value. Eight gates with explicit evidence let you ship with confidence and revert with precision.

## The Eight Gates

Each gate has:

- **What it checks** — the dimension being verified
- **From this skill** — which palette / font / guideline applies
- **Evidence required** — what counts as \"green\"
- **Common failures** — the patterns this gate catches

A gate is **GREEN** only with cited evidence. A gate is **RED** with one or more issues, each with file:line, the violated rule, and a fix. A gate is **SKIPPED** if the necessary tooling isn't available — and SKIPPED is **not** GREEN.

---

### Gate 1 — Security

**What it checks**: code-level vulnerabilities introduced by UI work — XSS sinks in markdown renderers, `dangerouslySetInnerHTML` with unsanitized input, inline `eval`, unsafe deserialization.

**From this skill**: not applicable directly; the skill's UI guidance must not introduce sinks.

**Evidence required**:

- Pattern scan against the 9 high-risk smells (eval, new Function, dangerouslySetInnerHTML, .innerHTML =, document.write, child_process.exec, os.system, pickle, yaml.load without SafeLoader)
- Secret scan over the diff
- Dependency audit when the project ships a `package.json` and a lockfile

**Common failures**:

- Rendering Markdown via `dangerouslySetInnerHTML` without DOMPurify
- Embedding user-supplied SVG without sanitization
- `iframe` `src` constructed from user input

---

### Gate 2 — Code correctness

**What it checks**: the implementation compiles, types check, lints, builds, tests, and resolves all imports.

**From this skill**: not applicable directly; this is generic engineering hygiene.

**Evidence required**:

```
typecheck: ok (exit 0)
lint:      ok (exit 0)
build:     ok (exit 0)
tests:     N/N (exit 0)
```

If a command doesn't exist for the project, write `<check>=skipped:no-command`. SKIPPED is not GREEN.

**Common failures**:

- A type error introduced by a refactor that the watcher missed
- A new component that lints clean locally but trips a CI rule
- Tests passing on the previous run but failing now

---

### Gate 3 — UI craft (style + palette + typography)

**What it checks**: the visual design conforms to one of the 67 supported styles, uses one of the 161 palettes (or a defensible derivative), and pairs fonts from the 57 vetted pairings.

**From this skill**:

- **Style declared**: glassmorphism, claymorphism, minimalism, brutalism, neumorphism, bento grid, dark mode, responsive, skeuomorphism, flat — *or* an explicit declaration of \"custom\" with reasoning.
- **Palette referenced**: cite the palette name from the catalog, or document the deviation. The catalog's 161 palettes are tested for contrast and harmony — freelancing usually loses both.
- **Font pairing referenced**: cite the pairing from the 57 vetted ones, or document the deviation.
- **Color strategy** (Restrained / Committed / Full / Drenched per impeccable's framework): one of the four, declared in DESIGN.md or the token file.

**Evidence required**:

- A reference to the palette / pairing / style by name in DESIGN.md or in a comment at the top of the relevant file.
- Static scan reports zero hits on the absolute bans (gradient text, side-stripe borders, glassmorphism as default chrome, hero-metric template, identical card grids, modal-as-default).
- No hard-coded `#000` / `#fff` / `rgb(0,0,0)` / `rgb(255,255,255)`.
- No em-dashes in user-facing copy strings.

**Common failures**:

- Picking a palette without naming it (\"a kind of blueish gray\")
- Combining two pairings that look similar at a glance but break hierarchy
- Defaulting to a glassmorphism look on every surface

---

### Gate 4 — Accessibility (WCAG 2.2 AA)

**What it checks**: every user can use this. Real users on real assistive tech.

**From this skill**: the 99 UX guidelines that address contrast, naming, focus, motion, and form ergonomics.

**Evidence required**:

- **Contrast** ≥ 4.5:1 (body) / ≥ 3:1 (large or non-text). Cite the smallest measured pair.
- **Accessible names** present on every interactive element. Cite the count: \"names=12/12.\"
- **Visible focus** on every interactive element — no naked `outline: none` without a replacement.
- **Touch targets** ≥ 44×44 CSS px including padding.
- **Motion**: every animation > 200 ms or moving across the screen has a `prefers-reduced-motion` peer rule.
- **Forms**: labels programmatically associated; errors `aria-describedby` linked; required fields indicated for both sighted and AT users.
- **Heading order**: monotonic; one `h1` per landmark.

**Common failures**:

- Icon-only buttons missing `aria-label`
- A focus ring removed for aesthetics with no replacement
- Body text below 4.5:1 contrast on the primary surface
- Touch targets < 44×44 in mobile nav
- `<div>` masquerading as a button

---

### Gate 5 — Performance

**What it checks**: the design feels fast on a real user's device, not just on the developer's MacBook.

**From this skill**: the responsive and motion guidelines from the 99 UX rules.

**Evidence required**:

- **No layout-property animation**: zero hits for `animation:` / `transition:` involving `width`, `height`, `top`, `left`, `right`, `bottom`, `margin`, `padding`, `border-width`. Use `transform` and `opacity`.
- **No unbounded blur/filter** on full-viewport elements.
- **All `<img>` and `<video>` have explicit dimensions or `aspect-ratio`** (no CLS).
- **Below-the-fold images use `loading=\"lazy\"`**; the LCP image does *not*.
- **No layout thrash** in `for` / `while` / `requestAnimationFrame` callbacks.
- **Bundle within budget**: any new dep > 50 KB minified+gzipped lands in a route-level lazy chunk, not the initial bundle.
- **Charts** (when from the 25 supported chart types) lazy-load the renderer; recharts/chart.js are not in the initial bundle for non-chart pages.

**Common failures**:

- Animating `width` for a slide-in (use `transform: translateX`)
- A backdrop blur on the full viewport that drops frames
- An LCP image with `loading=\"lazy\"`
- Importing a chart library at the top level on every page

---

### Gate 6 — Responsive display

**What it checks**: the UI works at every viewport this skill targets, in every theme it offers, in every state.

**From this skill**: the responsive guideline (1 of 99) plus dark-mode guidance plus the interaction-states catalog.

**Evidence required**:

- Renders without horizontal scroll at **320, 768, 1024, 1440** CSS px.
- Body text ≥ 16 px on viewports < 768.
- All **seven interactive states** present per element: default / hover / focus-visible / active / disabled / loading / error.
- Theme switching unbroken — no hard-coded colors that ignore the theme variable.
- Touch targets ≥ 44×44 at the smallest breakpoint.
- Container queries (when used) have a fallback for older Safari, or the project's browser support matrix excludes those versions.

**Common failures**:

- A two-column dashboard that overflows on iPad
- A toggle that has no `:focus-visible` state
- A dark-theme card with hard-coded `#fff` text
- Touch targets that hit 40 px after padding shrinks at the smallest breakpoint

---

### Gate 7 — Streamlining (drop-in friendliness)

**What it checks**: this block can drop into another website with minimal edits. The pay-off of every design-system convention this skill encodes.

**From this skill**: the design-token model and the 161 palettes (which exist precisely so a block carries its color contract with it).

**Evidence required**:

- **Tokens only**: every color, spacing, radius, font-size, font-weight, line-height, shadow comes from a token (CSS variable, Tailwind class with the project's theme, design-token import). No literals beyond `1px` borders, `0` resets, `100%` widths.
- **No nested cards.**
- **Scoped CSS**: CSS Modules, scoped style block, namespaced class prefix, `data-*` attribute selector, `:scope` / `@scope`, or shadow DOM. **Zero new global selectors** introduced by a component file.
- **Relative units** for typography (`rem` / `em` / `%` / `ch`) and outer spacing.
- **Parent-aware**: `color: inherit` by default on the root; logical properties (`margin-inline-start` not `margin-left`) for RTL safety.
- **Optional override surface**: a `data-*` API for behavior (`data-variant`, `data-tone`) and CSS-variable surface (`--qc-card-radius`) so the host re-skins without editing the source.
- **No project-only globals imported** in presentational components (no app-store reads, no route hard-codes, no analytics calls inside leaf components).

**Common failures**:

- A card with `bg-zinc-900` literal where a `--surface-2` token exists
- A button that reaches into a global Redux store
- A nav component whose CSS rule names collide with the host site's `.title`
- A component that breaks when the parent uses `dir=\"rtl\"`

---

### Gate 8 — Verification (final, fresh)

**What it checks**: every Gate 2 command, re-run *now*, in this turn. Not a stale earlier-in-session result.

**Evidence required**:

```
typecheck: ok (exit 0)
lint:      ok (exit 0)
build:     ok (exit 0)
tests:     N/N (exit 0)
```

**Why this is its own gate**: between Gate 2 and Gate 8, you may have fixed issues found in Gates 3–7. Those fixes can re-break Gate 2 in subtle ways. Always re-run.

---

## Verdict

```
gate-1 security:    GREEN  evidence: 0 hits across 9 patterns; deps audit=0 high
gate-2 code:        GREEN  evidence: tsc=0 lint=0 build=0 tests=42/42
gate-3 ui-craft:    GREEN  evidence: palette=Marine Cobalt; pairing=Inter+Source Serif; bans=0
gate-4 a11y:        GREEN  evidence: contrast min 4.7:1; names 12/12; focus ok; touch ≥ 44
gate-5 perf:        GREEN  evidence: layout-anim=0; unbounded-blur=0; cls=0
gate-6 responsive:  GREEN  evidence: viewports 320/768/1024/1440 ok; states 7/7
gate-7 streamline:  GREEN  evidence: literal-colors=0; global-selectors=0; scoping=modules
gate-8 verify:      GREEN  evidence: tsc=0 lint=0 build=0 tests=42/42 (re-run)

VERDICT: SHIP
```

If any gate is RED, the report must list each issue with file:line, the violated rule (cite from this doc when relevant), and a one-sentence fix. **VERDICT: BLOCK** until the gate flips to GREEN.

If a gate is **SKIPPED**, the report must say so explicitly. SKIPPED is not GREEN; SHIP requires either GREEN or an explicit user waiver written into the report. *\"I didn't have axe-core so I skipped Gate 4\"* is a SKIPPED, not a GREEN.

## Calibration: how strict is too strict?

This pipeline is calibrated for **shipping**, not for prototypes. A spike, a sketch, a Friday-afternoon proof-of-concept doesn't need eight gates. The threshold is: **anything a real user sees**. Internal admin used by engineers? Partially. A throwaway demo? No. The marketing site? Yes. The signup flow? Yes, twice.

In `--strict` mode (used by `/quality-checks --strict`), P1 issues are also blocking. Use this for hero flows: hero pages, payments, auth, anything where a small flaw compounds into a big trust loss.

## Calibration: when to deviate from the catalogs

The 161 palettes, 57 font pairings, and 67 styles are *defaults that work*. Deviating is fine; **undocumented deviation is not**. Document the deviation in DESIGN.md or in a comment at the top of the relevant file:

```css
/* Palette: derivative of \"Marine Cobalt\" with a custom warm-50 added\n   for the marketing-only success surface. Reasoning: the canonical\n   green-50 reads cold next to the brand orange. */
```

Now Gate 3 can verify against the documented deviation, not the canonical palette.

## How to invoke

If your harness has the [quality-checks plugin](https://github.com/getuslisted/claude-code/tree/main/plugins/quality-checks) installed:

```
/quality-checks                    # full 8-gate run on the current branch
/quality-checks --strict           # P1 issues are also blocking
/quality-checks --scope=staged     # audit staged changes only
/quality-checks --phases=3,4,7     # only specific gates (0 and 8 always run)
/quality-quick                     # ~30s hot-pattern scan during development\n```

If your harness has [impeccable](https://github.com/getuslisted/impeccable) installed:

```bash
npx impeccable verify           # 8-gate pipeline\nnpx impeccable audit            # gates 3 + 4 only (UI craft + a11y)\nnpx impeccable polish           # post-fix cleanup\n```

If neither is installed: this document is the manual checklist. Walk each gate; emit the evidence block at the end; do not declare \"ship\" until the block is green.

## Bottom line

Eight gates. Eight pieces of evidence. No shortcuts.

The 161 palettes, 57 font pairings, 99 UX guidelines, 25 chart types, and 67 styles in this skill exist so designs are *built on a foundation*. This document exists so designs are *verified against that foundation* before they ship.

Run the commands. Read the output. Quote the lines. Then claim ready.
