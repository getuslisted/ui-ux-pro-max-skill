# Pipeline

Nine phases. Version: **v1.1.0** (2026-05-13).

Changelog from v1.0:
- Rubric dimension double-count fixed.
- `PRODUCT.md` no longer hard-gates.
- Removed undefined `target=<paste>`.
- Phase 1 composes with `/security-review`.
- Deterministic gate added (`scripts/check.sh`).

---

## Phase 0 — Discovery & Context

Inputs: branch diff; root scanned for `PRODUCT.md`, `DESIGN.md`, `design-system/MASTER.md`, configs.

Checks: register; design system map; stack; industry (via this repo's `search.py` when present); anti-references.

### Graceful degradation

- `PRODUCT.md` present and non-trivial: full pipeline.
- Present but trivial: pipeline runs; report nudges.
- Missing: pipeline runs every phase EXCEPT register-specific and industry-specific checks; report nudges.

Never halts.

---

## Phase 1 — Security Lockdown

Preferred: invoke `/security-review` from `claude-code-security-review`. Fallback: inline prompt.

Sub-phases: 1A Repository Context. 1B Comparative Analysis. 1C Vulnerability Assessment.

Categories: Input Validation, AuthN / AuthZ, Crypto & Secrets, Injection & Code Execution, Data Exposure.

False-positive filter: DoS, on-disk secrets if otherwise secured, rate-limiting, memory exhaustion, generic input-validation, GitHub Actions without concrete trigger, theoretical races, outdated libs, memory safety in safe langs, test files, log spoofing, path-only SSRF, user content in AI prompts, regex injection / DoS, doc files, lack of audit logs.

Confidence: 8-10 report; 4-7 with attack path; 1-3 drop.

Exit: zero HIGH; zero MEDIUM ≥ 0.85.

---

## Phase 2 — Anti-Pattern Audit

Deterministic subset: `qc-001`, `qc-002`, `qc-007`, `qc-009`.

LLM-judgment subset: `qc-003` glassmorphism, `qc-004` hero-metric, `qc-005` identical card grids, `qc-006` modal-first, `qc-008` bounce easing, `qc-010` nested cards. First / second-order category reflexes. Industry-specific anti-patterns from this repo's 161 reasoning rules.

Scoring: 0 AI slop gallery. 4 No AI tells.

Exit: score ≥ 3, zero absolute-ban hits.

---

## Phase 3 — Design System Conformance

Checks: color (tokens, OKLCH, no `#000`/`#fff`, no gray on color); typography (≥ 1.25 contrast, 65-75ch); spacing (scale-only); radius (controlled); shadow (flat at rest, ≤ 0.15 alpha); motion (durations from scale, ease-out, `prefers-reduced-motion`); component reuse.

Drift classification: missing token / one-off / conceptual.

Scoring: 0 hard-coded. 4 full token system.

Exit: score ≥ 3, zero P0 drift, ≤ 3 P1 drift.

---

## Phase 4 — Accessibility Hardening

Deterministic subset: `qc-042`, `qc-043` (P0).

LLM-judgment subset: contrast ≥ 4.5:1, semantic HTML, ARIA names, keyboard reachable, touch targets ≥ 44 × 44, form labels, `prefers-reduced-motion`, color independence.

Scoring: 0 inaccessible. 4 WCAG AA fully met.

Exit: score ≥ 3, zero P0.

---

## Phase 5 — Performance Audit

Animation: `transform`/`opacity` only. Render: memoize, no layout thrash. Loading: lazy, preload hero, critical CSS < 14 KB. Bundle: no unused deps. Layout shift: explicit dimensions. Network: parallel, debounced, throttled.

Scoring: 0 severe. 4 fast, lean.

Exit: score ≥ 3, zero P0.

---

## Phase 6 — Resilience & Edge Cases

Text overflow. Empty / error / loading states. i18n (30-40% expansion, logical CSS, RTL, `Intl.*`). Concurrency. Permission states. Browser compatibility.

Scoring: 0 happy-path only. 4 hardened.

(v1.1 promotes Resilience to its own dimension.)

Exit: zero P0.

---

## Phase 7 — Editorial & Copy

Deterministic subset: `qc-070`, `qc-071`, `qc-072`. See [`COPY-DENYLIST.md`](./COPY-DENYLIST.md).

LLM-judgment subset: negation pivot, triadic everything, five-paragraph essay shape, uniform paragraph length, synthetic balance, hollow confidence, hedging stacks, interchangeable copy.

Exit: zero P0. ≤ 3 P1.

---

## Phase 8 — Cross-Stack Verification

Deterministic subset: `qc-080`, `qc-081` (P0).

LLM-judgment subset (pulls from this repo's 15 stack guides): React / Next.js, Vue / Nuxt, Astro, Svelte, SwiftUI, React Native, Flutter, HTML + Tailwind, shadcn/ui, Angular, Laravel, Jetpack Compose.

Exit: zero P0. ≤ 3 P1.

---

## Phase 9 — Sign-Off

Audit Health Score /20: Anti-Pattern + Design System + Accessibility + Performance + Resilience.

Bands: 18-20 Excellent. 14-17 Good. 10-13 Acceptable. 6-9 Poor. 0-5 Critical.

Verdict:
- Ready to ship: Excellent / Good, Security pass, gate pass, zero P0, ≤ 5 P1.
- Ship with exception: Acceptable, Security pass, gate pass, zero P0, exception documented.
- Hold: Poor / Critical, OR Security fail, OR gate fail, OR any P0.

Output: report per [`RUBRIC.md`](./RUBRIC.md).

## Deterministic gate timing

`scripts/check.sh` runs BEFORE Phase 1: CI mode and slash-command mode. Idempotent.

## Skipping phases

Phases 1-4 mandatory. Phases 5-8 skippable.
