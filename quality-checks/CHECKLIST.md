# Pre-Delivery Checklist

The flat, copy-pasteable version of the pipeline.

## Hard gates

### Security

- [ ] No HIGH finding. No MEDIUM with confidence ≥ 0.85.
- [ ] No SQL / command / XXE / NoSQL / path-traversal / template injection.
- [ ] No AuthN / AuthZ bypass, privilege escalation, missing IDOR guard.
- [ ] No hardcoded API keys, passwords, tokens.
- [ ] No weak crypto or improper key storage.
- [ ] No deserialization RCE.
- [ ] No XSS via `dangerouslySetInnerHTML`, `v-html`, `[innerHTML]`, `bypassSecurityTrustHtml`, `{@html ...}` with user content.
- [ ] No PII or secrets in logs.

### Anti-Pattern absolutes

- [ ] No `border-left` / `border-right` > 1px as colored accent.
- [ ] No `background-clip: text` with gradient.
- [ ] No glassmorphism by default.
- [ ] No hero-metric template.
- [ ] No identical card grids.
- [ ] No modal as first thought.
- [ ] No `#000` / `#fff`.
- [ ] No bounce / elastic easing.
- [ ] No animation on layout properties.
- [ ] No nested cards.
- [ ] No first-order category reflex.
- [ ] No second-order category reflex.

### Accessibility

- [ ] Body contrast ≥ 4.5:1.
- [ ] Large text contrast ≥ 3:1.
- [ ] Focus indicators ≥ 3:1.
- [ ] Every interactive element keyboard-reachable.
- [ ] Tab order matches visual order.
- [ ] No keyboard traps.
- [ ] No `outline: none` without replacement.
- [ ] Touch targets ≥ 44 × 44 px.
- [ ] Adjacent interactive elements ≥ 8 px apart.
- [ ] Every form input has a programmatic label.
- [ ] Required fields marked visually and via `aria-required`.
- [ ] Errors associated via `aria-describedby` / `aria-errormessage`.
- [ ] Validation errors persist in DOM.
- [ ] Heading hierarchy monotone.
- [ ] Landmarks present.
- [ ] Decorative images `alt=""`.
- [ ] Live regions on dynamic content.
- [ ] `<button>` for buttons, `<a>` for links.
- [ ] `prefers-reduced-motion` respected.
- [ ] No flashing > 3 Hz.
- [ ] Color independence.
- [ ] Forced-colors mode does not break layout.

### Design system

- [ ] Every color from a token.
- [ ] New colors in OKLCH.
- [ ] Every spacing on the project scale.
- [ ] Every radius matches controlled vocabulary.
- [ ] Hierarchy contrast ≥ 1.25 between adjacent type steps.
- [ ] Body line length 65-75ch.
- [ ] Italic is voice, not emphasis.
- [ ] Headings `clamp()`, body fixed `rem`.
- [ ] No gray on color.
- [ ] Surfaces flat at rest.
- [ ] Strongest shadow blur ≤ 0.15 alpha.
- [ ] Tinted shadows reserved for accent-glow.
- [ ] Animation duration matches project scale.
- [ ] Easing from project curve set.
- [ ] Shared components used.

## Should-pass (any unchecked → P1)

### Performance

- [ ] No layout thrashing.
- [ ] Filter / blur / shadow paint areas bounded.
- [ ] Off-screen images `loading="lazy"`.
- [ ] Hero preloaded.
- [ ] Critical CSS < 14 KB.
- [ ] Web fonts `font-display: swap` + preload.
- [ ] Images carry explicit `width` / `height`.
- [ ] Layout shift < 0.1.
- [ ] Critical API calls parallel.
- [ ] Search debounced 200-400ms.
- [ ] Scroll throttled 50-100ms.
- [ ] Expensive components memoized.

### Resilience

- [ ] Long text renders without breaking layout.
- [ ] Ellipsis or clamp where needed.
- [ ] Flex / grid items `min-width: 0`.
- [ ] Empty state for every list / search / dataset.
- [ ] Loading state for every async action.
- [ ] Error state for every async action.
- [ ] 4xx and 5xx have distinct treatments.
- [ ] Validation errors render near input.
- [ ] Error messages specific.
- [ ] Long translations fit (30-40% expansion).
- [ ] Logical CSS properties.
- [ ] RTL reverses correctly.
- [ ] Direction-implying icons flip via `[dir="rtl"]`.
- [ ] Date / number formatting via `Intl.*`.
- [ ] Pluralization handled by i18n library.
- [ ] Double-submit prevented.
- [ ] Concurrent requests handled.

### Editorial

- [ ] No em dashes.
- [ ] No double-hyphen substitute.
- [ ] No banned diction.
- [ ] No throat-clearing openers.
- [ ] No banned closers.
- [ ] No banned transitions.
- [ ] Triadic everything checked.
- [ ] Five-paragraph essay shape avoided.
- [ ] Synthetic balance avoided.
- [ ] Hollow confidence replaced with concrete fact.
- [ ] Interchangeable-copy test passed.

### Stack

- [ ] React: Server vs Client classified.
- [ ] Next.js: `next/image`, `next/font`, `next/link`.
- [ ] Vue: composables `use*`.
- [ ] Astro: `client:*` only when needed.
- [ ] SwiftUI: `@StateObject` vs `@ObservedObject` correct.
- [ ] React Native: `Pressable`, `FlatList`.
- [ ] Flutter: `const`, `Semantics`, `textScaleFactor`.
- [ ] Tailwind: short class strings or extracted.
- [ ] shadcn: from `@/components/ui/*`.

## Polish

- [ ] Pixel-perfect alignment.
- [ ] Optical alignment for icons.
- [ ] No widows / orphans.
- [ ] Consistent capitalization.
- [ ] Icons from same family.
- [ ] No debug `console.log`.
- [ ] No commented-out dead code.
- [ ] No unused imports.
- [ ] No TypeScript `any` or ignored errors.

## Sign-off

- [ ] All hard gates checked.
- [ ] Audit Health Score ≥ 14 / 20.
- [ ] Security: pass.
- [ ] P0 count: 0.
- [ ] P1 count: ≤ 5.
- [ ] Verdict band recorded.
- [ ] Recommended commands listed in priority order.
