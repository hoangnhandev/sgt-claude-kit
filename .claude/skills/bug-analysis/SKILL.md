---
name: bug-analysis
description: Techniques for identifying, reproducing, and fixing bugs.
---

# Bug Analysis

## 1. Severity

- **P0/Critical**: System down, Data loss, Security. (Immediate)
- **P1/High**: Major feature broken, no workaround. (<24h)
- **P2/Medium**: Feature impacted, has workaround. (<1 week)
- **P3/Low**: Cosmetic, Edge case. (Next Sprint)

## 2. Reproduction

Template:

1. **Env**: OS, Browser, Version.
2. **Steps**: 1... 2... 3... (until bug).
3. **Expected vs Actual**.
   _Note_: If not reproducible, check races/data/env-vars.

## 3. Root Cause Analysis (5 Whys)

Ask "Why?" until you find the logic/state/data error.

- **Logic**: Wrong condition/algorithm.
- **State**: UI/Data sync issue.
- **Race**: Async timing.
- **Integration**: API mismatch.

## 4. Fix Strategy

- **Minimal Change**: Fix ONLY the root cause.
- **Defensive**: Add null checks/validation.
- **Test**: Add reproduction test (Fail -> Fix -> Pass).
