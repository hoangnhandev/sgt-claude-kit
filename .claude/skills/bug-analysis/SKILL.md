# Bug Analysis Skill

## Overview

This skill provides patterns, techniques, and best practices for analyzing and investigating software bugs.

---

## 1. Bug Severity Classification

### Severity Matrix

| Severity        | Priority | Criteria                                    | Response Time | Examples                                                |
| --------------- | -------- | ------------------------------------------- | ------------- | ------------------------------------------------------- |
| 🔴 **Critical** | P0       | System unusable, data loss, security breach | Immediate     | Auth bypass, data corruption, payment failures          |
| 🟠 **High**     | P1       | Major feature broken, no workaround         | < 24 hours    | Core feature fails, API errors, performance degradation |
| 🟡 **Medium**   | P2       | Feature impacted, workaround exists         | < 1 week      | UI issues with workaround, edge case failures           |
| 🟢 **Low**      | P3       | Minor issue, cosmetic, edge case            | Next sprint   | Typos, minor UI glitches, rare edge cases               |

### Classification Decision Tree

```
Is the system completely unusable?
├── Yes → 🔴 Critical (P0)
└── No → Does it affect security or cause data loss?
    ├── Yes → 🔴 Critical (P0)
    └── No → Is a major feature completely broken?
        ├── Yes → Is there a workaround?
        │   ├── No → 🟠 High (P1)
        │   └── Yes → 🟡 Medium (P2)
        └── No → Does it affect user experience significantly?
            ├── Yes → 🟡 Medium (P2)
            └── No → 🟢 Low (P3)
```

---

## 2. Bug Reproduction Patterns

### Standard Reproduction Template

```markdown
## Environment

- **OS**: {operating system and version}
- **Browser/Client**: {browser name and version}
- **App Version**: {application version}
- **User Role**: {user type/permissions}

## Prerequisites

1. {Any required setup}
2. {Required data/state}

## Steps to Reproduce

1. {First action}
2. {Second action}
3. {Continue until bug manifests}

## Expected Result

{What should happen}

## Actual Result

{What actually happens}

## Frequency

- Always / Often (>50%) / Sometimes (10-50%) / Rarely (<10%)

## Workaround (if any)

{Steps to work around the issue}
```

### Common Reproduction Issues

| Issue                         | Solution                                                      |
| ----------------------------- | ------------------------------------------------------------- |
| Bug doesn't reproduce locally | Check environment differences (data, config, version)         |
| Intermittent bug              | Look for race conditions, timing issues, data-dependent flows |
| User-specific bug             | Check user permissions, data, locale settings                 |
| Environment-specific          | Check for config differences, feature flags, A/B tests        |

---

## 3. Root Cause Analysis Techniques

### 5 Whys Method

Ask "why" repeatedly to drill down to root cause:

```
1. Why did the page crash?
   → Because JavaScript threw an uncaught exception.

2. Why was there an uncaught exception?
   → Because the code tried to access a property of undefined.

3. Why was the variable undefined?
   → Because the API returned null for non-existent users.

4. Why wasn't null handled?
   → Because the code assumed user always exists.

5. Why was this assumption made?
   → Because the original requirement didn't consider deleted users.

ROOT CAUSE: Missing null check for edge case of deleted users.
```

### Execution Tracing

```markdown
## Trace Template

Entry Point: {where user action starts}
↓
Step 1: {component/function}

- Input: {what came in}
- Process: {what happened}
- Output: {what went out}
  ↓
  Step 2: {next component}
- Input: {what came in}
- Process: {what happened}
- ❌ ERROR HERE: {where bug occurs}
  ↓
  Error Propagation: {how error manifests to user}
```

### Root Cause Categories

| Category              | Description                   | Common Signs                            |
| --------------------- | ----------------------------- | --------------------------------------- |
| **Logic Error**       | Incorrect algorithm/condition | Wrong calculations, unexpected behavior |
| **State Error**       | Invalid state transition      | UI out of sync, stale data              |
| **Data Error**        | Unexpected/malformed data     | Null/undefined errors, type mismatches  |
| **Race Condition**    | Timing/async issues           | Intermittent failures, order-dependent  |
| **Integration Error** | API contract mismatch         | Failed external calls, wrong responses  |
| **Edge Case**         | Unhandled boundary            | Empty inputs, max values, special chars |
| **Config Error**      | Wrong settings/env vars       | Environment-specific failures           |

---

## 4. Bug Investigation Tools & Techniques

### Codebase Search Patterns

```bash
# Find error messages
grep_search(Query="specific error message")

# Find related functions
grep_search(Query="functionName", IsRegex=false)

# Find TODO/FIXME comments
grep_search(Query="TODO|FIXME", IsRegex=true)

# Find error handling
grep_search(Query="catch.*Error", IsRegex=true)

# Find similar patterns
grep_search(Query="pattern.*you\\s*found", IsRegex=true)
```

### Git Investigation

```bash
# Recent changes to file
git log --oneline -10 -- path/to/file.ts

# Find when bug was introduced
git bisect start HEAD <known-good-commit>

# Who changed this line
git blame path/to/file.ts

# Find related commits
git log --grep="related keyword"
```

### Debugging Strategies

| Strategy          | When to Use                      | How                                    |
| ----------------- | -------------------------------- | -------------------------------------- |
| **Binary Search** | Large codebase, unknown location | Narrow down by halving                 |
| **Rubber Duck**   | Complex logic                    | Explain code line by line              |
| **Time Travel**   | Recent regression                | Find when it last worked               |
| **Isolation**     | Complex system                   | Remove components until bug disappears |
| **Reproduction**  | Unreproducible                   | Vary conditions systematically         |

---

## 5. Fix Strategy Patterns

### Minimal Change Principle

```markdown
## DO:

- Fix only the root cause
- Add defensive coding where needed
- Add inline comment explaining fix
- Add regression test

## DON'T:

- Refactor unrelated code
- "Improve" while fixing
- Add features
- Change coding style
```

### Common Fix Patterns

| Bug Type             | Fix Pattern                                         |
| -------------------- | --------------------------------------------------- |
| Null/undefined error | Add null check with appropriate fallback            |
| Race condition       | Add proper synchronization (mutex, queue, debounce) |
| State inconsistency  | Ensure atomic state updates                         |
| Missing validation   | Add input validation at boundary                    |
| Error not caught     | Add try-catch with proper error handling            |
| API mismatch         | Align with contract, add versioning if needed       |

### Fix Validation Checklist

```markdown
Before considering fix complete:

- [ ] Root cause addressed (not just symptom)
- [ ] No unrelated changes in diff
- [ ] Inline comment added explaining fix
- [ ] Existing tests still pass
- [ ] New test reproduces bug (fails without fix)
- [ ] New test passes with fix
- [ ] No new warnings introduced
```

---

## 6. Regression Risk Assessment

### Risk Levels

| Level      | Criteria                                | Examples                           |
| ---------- | --------------------------------------- | ---------------------------------- |
| **High**   | Shared code, many callers, external API | Utility functions, public APIs     |
| **Medium** | Limited scope, some integration         | Feature modules, internal services |
| **Low**    | Isolated, single use                    | Component-specific logic           |

### Mitigation Strategies

```markdown
## High Risk Fix

- Comprehensive test suite update
- Manual testing of all callers
- Staged rollout with monitoring
- Rollback plan ready

## Medium Risk Fix

- Unit tests for changed code
- Integration test for affected flows
- Light manual testing

## Low Risk Fix

- Unit test for the fix
- Regression test suite passes
```

---

## 7. Bug Documentation Templates

### Bug Analysis Document

```markdown
# Bug Analysis: {Title}

## Quick Info

| Field    | Value                                          |
| -------- | ---------------------------------------------- |
| Bug ID   | {id}                                           |
| Severity | {🔴/🟠/🟡/🟢} {level}                          |
| Priority | P{0-3}                                         |
| Status   | Analyzing / Investigating / Fixing / Verifying |

## Reproduction Steps

1. {step}
2. {step}

## Investigation Notes

{findings during analysis}

## Affected Components

- {component 1}
- {component 2}
```

### Root Cause Document

```markdown
# Root Cause: {Title}

## Summary

**Root Cause**: {one-line description}
**Category**: {Logic/State/Data/Race/Integration/Edge/Config}
**Confidence**: {High/Medium/Low}

## Technical Details

**Location**: `{file}:{line}`
**Function**: `{functionName}`

## Explanation

{detailed explanation of why bug occurs}

## Fix Recommendation

**Approach**: {description}
**Complexity**: {Simple/Medium/Complex}
**Risk**: {Low/Medium/High}
```

---

## 8. Common Anti-Patterns

### Investigation Anti-Patterns

| Anti-Pattern          | Problem                            | Better Approach          |
| --------------------- | ---------------------------------- | ------------------------ |
| **Symptom Fixing**    | Addresses visible issue, not cause | Trace to root cause      |
| **Shotgun Debugging** | Random changes hoping to fix       | Systematic investigation |
| **Tunnel Vision**     | Focusing on one hypothesis         | Consider alternatives    |
| **Blame Game**        | Looking for who, not what          | Focus on technical cause |

### Fix Anti-Patterns

| Anti-Pattern         | Problem                         | Better Approach       |
| -------------------- | ------------------------------- | --------------------- |
| **Kitchen Sink Fix** | Fixing + refactoring + features | Minimal change only   |
| **Bandaid Fix**      | Hiding symptoms                 | Address root cause    |
| **No Test**          | Can't verify fix works          | Add reproduction test |
| **Magic Numbers**    | Unexplained constants           | Use named constants   |

---

## 9. Communication Templates

### Status Update

```markdown
## Bug Status Update: {Bug ID}

**Current Status**: {Analyzing/Investigating/Fixing/Verifying/Done}
**Progress**: {percentage}%

**Latest Finding**: {what we learned}
**Next Step**: {what we're doing next}
**ETA**: {estimated completion}
**Blockers**: {any blockers}
```

### Escalation

```markdown
## Bug Escalation: {Bug ID}

**Reason for Escalation**:

- [ ] Cannot reproduce
- [ ] Root cause unclear
- [ ] Fix requires architecture change
- [ ] Security implications
- [ ] Other: {specify}

**Current Understanding**: {what we know}
**Help Needed**: {specific request}
```

---

_This skill should be applied in conjunction with project-specific conventions and frameworks._
