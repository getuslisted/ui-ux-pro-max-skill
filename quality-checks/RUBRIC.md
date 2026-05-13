# Rubric

## Audit Health Score

Five dimensions, 0-4 each. Total /20. No double-counting.

| Dimension | Source phase | 0 | 1 | 2 | 3 | 4 |
|-----------|--------------|---|---|---|---|---|
| Anti-Pattern | 2 | AI slop gallery | Heavy AI aesthetic | Some tells | Mostly clean | No AI tells |
| Design System | 3 | Hard-coded | Mostly hard-coded | Tokens inconsistent | Tokens, minor drift | Full token system |
| Accessibility | 4 | Fails WCAG A | Major gaps | Partial | WCAG AA mostly | WCAG AA fully met |
| Performance | 5 | Layout thrash | Major problems | Some optimization | Mostly optimized | Fast, lean |
| Resilience | 6 | Happy-path only | Most states missing | Some states | All states | Hardened |

(v1.1 fixes the v1.0 double-count: Theming was listed as both a sub-component of Design System and a separate dimension. Theming folded into Design System; Resilience promoted.)

## Bands

18-20 Excellent. 14-17 Good. 10-13 Acceptable. 6-9 Poor. 0-5 Critical.

## Severity census

P0 blocking. P1 major. P2 minor. P3 polish. Reported as `P0=0 P1=2 P2=4 P3=7`.

## Security verdict

Fail if any HIGH or any MEDIUM ≥ 0.85. Pass otherwise. Overrides band.

## Deterministic-gate verdict

`scripts/check.sh` pass / fail.

## Sign-off rule

| Band | Security | Gate | P0 | P1 | Verdict |
|------|----------|------|----|----|---------|
| Excellent | Pass | Pass | 0 | ≤ 5 | **Ready to ship** |
| Good | Pass | Pass | 0 | ≤ 5 | **Ready to ship** |
| Good | Pass | Pass | 0 | 6-10 | **Ship with exception** |
| Acceptable | Pass | Pass | 0 | ≤ 5 | **Ship with exception** |
| any | Fail | any | any | any | **Hold** |
| any | any | Fail | any | any | **Hold** |
| any | any | any | ≥ 1 | any | **Hold** |
| Poor/Critical | any | any | any | any | **Hold** |

## Report template

```markdown
# Quality Checks — [branch / target]

**Verdict:** Ready to ship | Ship with exception | Hold
**Audit Health Score:** xx / 20 (Band)
**Security:** Pass | Fail
**Deterministic gate:** Pass | Fail
**Severity census:** P0=x P1=x P2=x P3=x

## 1. Verdict

## 2. Composite score

| Dimension | Score | Top finding |
|-----------|-------|-------------|
| Anti-Pattern | x / 4 | |
| Design System | x / 4 | |
| Accessibility | x / 4 | |
| Performance | x / 4 | |
| Resilience | x / 4 | |

## 3. Top issues

## 4. Drift map

## 5. Recommended commands

## 6. Positive findings

## 7. Skipped phases
```

## Exception protocol

`Ship with exception` requires a one-paragraph note in the PR description.
