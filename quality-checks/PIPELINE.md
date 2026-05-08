# Pipeline

Nine phases. Run them in order. Each phase has explicit inputs, checks, outputs, and exit criteria.

Version: **v1.0.0**.

---

## Phase 0 — Discovery & Context

The pipeline cannot grade what it cannot read.

### Inputs

- The current branch diff.
- Repo root scanned for `PRODUCT.md`, `DESIGN.md`, `design-system/MASTER.md`, `package.json`, framework configs.

### Checks

1. **Register**. Task cue, surface in focus, then `register` field in `PRODUCT.md`. First match wins. Cache `brand` or `product`.
2. **Design system map**. Walk for tokens (CSS variables, theme files, tokens JSON). Record presence or absence of: color, type, spacing, radius, shadow, motion, dark-mode variants.
3. **Stack identification**. From `package.json`, frame configs, file extensions. One of: `html-tailwind`, `react`, `nextjs`, `astro`, `vue`, `nuxtjs`, `svelte`, `swiftui`, `react-native`, `flutter`, `shadcn`, `jetpack-compose`, `angular`, `laravel`.
4. **Industry classification**. Match against the 161 reasoning rules in this repo's `data/products.csv`. Eight macro categories: Tech & SaaS, Finance, Healthcare, E-commerce, Services, Creative, Lifestyle, Emerging Tech. The classification feeds Phase 2's industry anti-references.
5. **Anti-references**. Pull `PRODUCT.md`'s anti-references list.

### Output

Discovery JSON kept in scope:

```json
{
  "register": "brand|product",
  "stack": "react",
  "industry": "saas|fintech|healthcare|...",
  "design_system": {
    "tokens": { "color": true, "type": true, "spacing": true, "motion": false },
    "dark_mode": false,
    "master": "design-system/MASTER.md"
  },
  "anti_references": ["dark mode with purple gradients", "hero metric template"],
  "diff_files": [ ... ]
}
```

### Exit criterion

`PRODUCT.md` exists and is non-trivial (≥ 200 chars, no `[TODO]`). Otherwise halt and run `/impeccable teach`.

---

## Phase 1 — Security Lockdown

Verbatim from `claude-code-security-review`. Reports HIGH-confidence vulnerabilities only.

### Sub-phases

**1A** Repository Context Research. Identify existing security frameworks, libraries, sanitization patterns.

**1B** Comparative Analysis. Compare new code against existing patterns. Flag deviations.

**1C** Vulnerability Assessment across Input Validation, AuthN / AuthZ, Crypto & Secrets, Injection & Code Execution, Data Exposure.

### Categories

- **Input Validation**: SQL injection, command injection, XXE, template injection, NoSQL injection, path traversal.
- **AuthN / AuthZ**: bypass, privilege escalation, session flaws, JWT, IDOR.
- **Crypto & Secrets**: hardcoded keys, weak algorithms, improper key storage, randomness, cert validation.
- **Injection & Code Execution**: deserialization RCE, pickle, YAML, eval, XSS (reflected, stored, DOM).
- **Data Exposure**: PII handling, API leakage, debug exposure, sensitive logs.

### False-positive filter (hard exclusions)

Do not report: DoS, on-disk secrets if otherwise secured, rate-limiting concerns, memory / CPU exhaustion, generic input-validation gaps, GitHub Action workflow issues without concrete trigger, general lack of hardening, theoretical race conditions, outdated libraries, memory safety in memory-safe languages, test files, log spoofing from un-sanitized input, path-only SSRF, user content in AI prompts, regex injection / regex DoS, doc files, lack of audit logs.

### Precedents

Logging URLs is safe. UUIDs are unguessable. Env vars and CLI flags are trusted. React, Angular, Vue are XSS-safe by default (only flag `dangerouslySetInnerHTML`, `bypassSecurityTrustHtml`, `v-html`, equivalents). Client-side auth checks aren't vulnerabilities. Logging non-PII is not a vulnerability. Shell-script command injection requires a concrete attack path.

### Confidence threshold

8-10: report. 4-7: report only with concrete attack path. 1-3: drop.

### Exit criterion

Zero HIGH findings. Zero MEDIUM with confidence ≥ 0.85. Single qualifying finding fails the entire pipeline.

---

## Phase 2 — Anti-Pattern Audit

The AI-slop test, two altitudes.

See [`ANTIPATTERNS.md`](./ANTIPATTERNS.md) for the full catalog.

### Cross-register absolute bans

Side-stripe borders > 1px. Gradient text. Glassmorphism by default. Hero-metric template. Identical card grids. Modal as first thought. Pure black or white. Bounce / elastic easing. Layout-property animation. Nested cards.

### First-order category reflex

Guess the theme + palette from category alone? Observability → dark blue + neon. Healthcare → white + teal. Banking → navy + gold. Crypto → neon on black. AI tool → purple-pink. Wellness → soft pink + sage.

### Second-order category reflex

Anti-cliche cliche. "AI tool, not purple-pink" → editorial-typographic on warm cream. "Fintech, not navy-gold" → terminal-native dark mode. "SaaS, not gradient-on-dark" → brutalist black-and-white.

### Industry-specific anti-patterns

From this repo's 161 reasoning rules. For the industry detected in Phase 0, load and check the corresponding anti-references. Banking should not use AI purple-pink gradients. Healthcare should not use brutalism. Wellness should not use harsh animations.

### Scoring

0 — AI slop gallery. 1 — Heavy AI aesthetic. 2 — Some tells. 3 — Mostly clean. 4 — No AI tells.

### Exit criterion

Score ≥ 3, zero absolute-ban hits.

---

## Phase 3 — Design System Conformance

Drift kills design systems quietly.

### Checks

**Color**: tokens only. OKLCH for new colors. Chroma reduces toward extremes. No `#000` / `#fff`. No gray on color.

**Typography**: hierarchy contrast ≥ 1.25 between steps. Body 65-75ch. Headings `clamp()`, body fixed `rem`. Italic is voice, not emphasis.

**Spacing**: scale-only.

**Radius**: controlled vocabulary. No single rounded-lg default.

**Shadow**: flat at rest. Strongest blur ≤ 0.15 alpha. Tinted only for accent-glow.

**Motion**: durations from scale. Ease-out exponential family. Honour `prefers-reduced-motion`.

**Component reuse**: shared primitives, not one-off reimplementations.

### Drift classification

Missing token. One-off implementation. Conceptual misalignment. Each fix differs.

### Scoring

0 — Hard-coded everything. 4 — Full token system, dark mode works.

### Exit criterion

Score ≥ 3, zero P0 drift, ≤ 3 P1 drift items.

---

## Phase 4 — Accessibility Hardening

WCAG AA is the floor.

### Checks

Contrast ≥ 4.5:1 (3:1 large). Semantic HTML (button, a, h1→h2→h3, landmarks). ARIA names on interactive. Keyboard reachable, no traps, focus indicators always visible. Touch targets ≥ 44 × 44 px. Forms with labels, `aria-required`, `aria-invalid`, `aria-describedby`. `prefers-reduced-motion`. No flashing > 3 Hz. Color independence.

### Severity

P0: WCAG A failures. P1: WCAG AA failures. P2: minor a11y polish. P3: AAA enhancement.

### Scoring

0 — Inaccessible. 4 — WCAG AA fully met, approaches AAA.

### Exit criterion

Score ≥ 3, zero P0.

---

## Phase 5 — Performance Audit

### Checks

Animation: `transform` and `opacity` only. No layout-property animation. Bound `filter` / `backdrop-filter` / `box-shadow` paint areas.

Render: memoize expensive components. Avoid layout thrashing.

Loading: `loading="lazy"` on off-screen images. Hero preloaded. Critical CSS < 14 KB. Fonts use `font-display: swap` + preload.

Bundle: no unused dependencies. Code-split routes.

Layout shift: explicit image dimensions. Skeleton matches loaded content.

Network: parallel critical calls. Debounce search 200-400ms. Throttle scroll 50-100ms.

### Scoring

0 — Severe issues. 4 — Fast, lean, well-optimized.

### Exit criterion

Score ≥ 3, zero P0.

---

## Phase 6 — Resilience & Edge Cases

### Checks

Text overflow: clamp / ellipsis / wrap. Flex / grid items `min-width: 0`.

Empty states: every list, search, dataset.

Error states: 4xx and 5xx distinct. Specific actionable messages.

Loading states: skeletons, inline spinners.

i18n: 30-40% expansion budget. Logical CSS properties. RTL reverses. `Intl.*` for dates and numbers.

Concurrency: double-submit prevented. Race conditions handled.

Permission states: read-only mode visually distinct.

### Severity

P0: missing critical state. P1: long text breaks layout. RTL collapse.

### Exit criterion

Zero P0.

---

## Phase 7 — Editorial & Copy

See [`COPY-DENYLIST.md`](./COPY-DENYLIST.md) for the full denylist.

### Banned terms (P1 if hit, P0 in marketing hero)

`load-bearing`, `highest-leverage`, `biggest unlock`, `reflex defaults`, `collapses into monoculture`, `data-driven`, `seamless(ly)?`, `robust(ness)?`, `elevate[sd]?`, `empower[sd]?`, `underscore[sd]?`, `pivotal`, `tapestry`, `delve(s|d|ing)?`, `in today's`, `gone are the days`, `whether you're`, `let's dive in`, `in summary`, `in conclusion`, `moreover`, `furthermore`.

Em dash and substitutes banned in user-facing prose.

### Structural patterns

Negation pivot. Triadic everything. Five-paragraph essay shape. Uniform paragraph length. Synthetic balance. Hollow confidence. Hedging stacks. Interchangeable copy.

### Exit criterion

Zero P0. ≤ 3 P1.

---

## Phase 8 — Cross-Stack Verification

The right pattern in the wrong stack is the wrong pattern. This phase consults this repo's stack-specific guidelines (`data/stacks/*.csv`).

### Per stack

**React / Next.js**: Server vs Client classified. `next/image`, `next/font`, `next/link`. No `dangerouslySetInnerHTML` with user content.

**Vue / Nuxt**: composables `use*`. No `v-html` with user content. `<NuxtLink>` for routing.

**Astro**: `client:*` only when needed. Image component. Content collections typed.

**Svelte / SvelteKit**: `{@html ...}` only with sanitized content. Stores derived correctly.

**SwiftUI**: `@StateObject` vs `@ObservedObject` correct. Dynamic Type respected. `Accessibility*` modifiers.

**React Native**: Flexbox layout. `Pressable` over `TouchableOpacity`. `FlatList` for long lists. `accessibilityLabel`, `accessibilityRole`, `accessibilityHint`.

**Flutter**: `const` constructors. `Semantics` widgets. `MediaQuery.textScaleFactor`. `ThemeData` carries dark and light.

**HTML + Tailwind**: class strings under 80 chars. Arbitrary values only when no token fits.

**shadcn/ui**: components from `@/components/ui/*`. Theme variables in `:root` and `.dark`. `cn()` for className merging.

**Angular**: no template injection via `[innerHTML]`. `OnPush` change detection. Reactive forms.

**Laravel**: `{{ }}` for escaped output. CSRF tokens on forms. Livewire properties don't leak.

**Jetpack Compose**: `remember` and `rememberSaveable` correctly. `Modifier` order matters. `Material3` semantics.

### Severity

P0: stack-specific security or correctness. P1: stack-specific anti-pattern. P2: drift. P3: idiomatic improvement.

### Exit criterion

Zero P0. ≤ 3 P1.

---

## Phase 9 — Sign-Off

Composite the prior phases.

### Audit Health Score

Five dimensions, 0-4 each. Total /20.

- Anti-Pattern (Phase 2): 0-4
- Design System (Phase 3): 0-4
- Accessibility (Phase 4): 0-4
- Performance (Phase 5): 0-4
- Theming (sub-component of Phase 3): 0-4

### Bands

18-20 Excellent. 14-17 Good. 10-13 Acceptable. 6-9 Poor. 0-5 Critical.

### Verdict logic

- **Ready to ship**: Excellent or Good band, Security passes, zero P0, ≤ 5 P1.
- **Ship with exception**: Acceptable band, Security passes, zero P0, exception documented.
- **Hold**: Poor or Critical band, OR Security fails, OR any P0.

### Output

A single markdown report. See [`RUBRIC.md`](./RUBRIC.md) for the template.

---

## Phase ordering rationale

Discovery before judgment. Security before everything else. Anti-Patterns before Design System. Design System before Accessibility (tokens carry contrast guarantees). Accessibility before Performance. Performance before Resilience. Resilience before Editorial. Editorial before Stack. Stack before Sign-Off.

## Skipping phases

Phases 1, 2, 3, 4 are mandatory. Phases 5, 6, 7, 8 are skippable when the diff doesn't touch their domain.
