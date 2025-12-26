---
description: Review current code changes (Phase 4) - Use to review uncommitted changes or specific files
---

# /review - Code Review Only

You are the Main Agent running Phase 4 of the workflow: **Code Review**.

---

## 📥 Input

`$ARGUMENTS` can be:

| Input Type   | Example                       | Description                         |
| ------------ | ----------------------------- | ----------------------------------- |
| Empty        | (none)                        | Review all uncommitted changes      |
| Feature slug | `user-auth`                   | Review changes for specific feature |
| File path(s) | `src/services/UserService.ts` | Review specific file(s)             |
| Commit range | `HEAD~3..HEAD`                | Review specific commits             |

---

## 🔄 Execution Flow

### Step 1: Gather Changes

Determine what to review:

```bash
# If no arguments - review all uncommitted changes
git diff --name-only
git diff

# If feature slug - find related changes
git diff --name-only | grep {feature-pattern}

# If specific files
git diff {file-path}

# If commit range
git diff {range}
```

---

### Step 2: Code Review

**Subagent**: `code-reviewer`

```
📋 Call subagent: code-reviewer
📄 Input: git diff output
📁 Output: .kira/reviews/review-{timestamp}.md
```

**Review Checklist**:

1. **Code Quality**

   - [ ] Readable and maintainable
   - [ ] No code duplication (DRY)
   - [ ] Functions are focused and small
   - [ ] Proper error handling

2. **Security**

   - [ ] No SQL injection vulnerabilities
   - [ ] No XSS vulnerabilities
   - [ ] No hardcoded secrets
   - [ ] Proper authentication/authorization

3. **Performance**

   - [ ] No obvious N+1 queries
   - [ ] No memory leaks
   - [ ] No blocking operations in async context

4. **Testing**

   - [ ] Adequate test coverage
   - [ ] Edge cases tested
   - [ ] Error cases tested

5. **Documentation**
   - [ ] Public APIs documented
   - [ ] Complex logic commented

---

### Step 3: Issue Classification

Classify found issues:

| Severity     | Symbol | Action                |
| ------------ | ------ | --------------------- |
| **CRITICAL** | 🔴     | MUST fix before merge |
| **WARNING**  | 🟡     | SHOULD fix            |
| **INFO**     | 🔵     | Nice to have          |

---

## 📊 Review Report

Generate report in `.kira/reviews/review-{timestamp}.md`:

```markdown
# Code Review Report

**Date**: YYYY-MM-DD HH:MM
**Reviewer**: Code Reviewer Agent
**Changes Reviewed**: X files, +XXX/-XXX lines

---

## Summary

| Metric          | Count |
| --------------- | ----- |
| Files Reviewed  | X     |
| Critical Issues | X     |
| Warnings        | X     |
| Suggestions     | X     |

---

## Quality Gate

| Check                   | Status  |
| ----------------------- | ------- |
| No CRITICAL issues      | ✅ / ❌ |
| Security scan passed    | ✅ / ❌ |
| Code quality acceptable | ✅ / ❌ |

**VERDICT**: ✅ APPROVED / 🚫 CHANGES REQUESTED

---

## Issues

### Critical Issues 🔴

[List of critical issues with file:line and suggested fixes]

### Warnings 🟡

[List of warnings]

### Suggestions 🔵

[List of suggestions]

---

## Files Reviewed

| File              | Status                            | Issues |
| ----------------- | --------------------------------- | ------ |
| `path/to/file.ts` | ✅ OK / 🟡 Warnings / 🔴 Critical | X      |
```

---

## ✅ Completion

After review, display:

```markdown
## ✅ Code Review Complete

### Summary

- **Files Reviewed**: X
- **Issues Found**: X (Critical: X, Warning: X, Info: X)

### Verdict: [✅ APPROVED / 🚫 CHANGES REQUESTED]

### Report

📄 `.kira/reviews/review-{timestamp}.md`

---

## 🎯 Next Steps

### If APPROVED:

1. Proceed with commit/merge
2. Run `/implement` to continue workflow

### If CHANGES REQUESTED:

1. Fix the critical issues listed above
2. Run `/review` again after fixes
```

---

## 🚨 Quality Gate Blocking

If CRITICAL issues found:

```markdown
## 🚫 QUALITY GATE BLOCKED

**Reason**: X critical issues found

### Critical Issues:

1. **🔴 [Issue Title]**

   - **File**: `path/to/file.ts:45`
   - **Issue**: Description of the problem
   - **Fix**: Suggested solution

2. **🔴 [Issue Title]**
   - **File**: `path/to/file.ts:89`
   - **Issue**: Description
   - **Fix**: Suggested solution

---

**Action Required**:

1. Fix all critical issues above
2. Run `/review` again

**Tip**: Use the suggested fixes as guidance
```

---

## 🔍 Quick Security Scan

Run these patterns automatically:

```bash
# Hardcoded secrets
grep_search(Query="password.*=.*['\"]|api_key.*=.*['\"]|secret.*=.*['\"]", IsRegex=true)

# SQL injection
grep_search(Query="execute.*\\$|query.*\\$", IsRegex=true)

# XSS
grep_search(Query="innerHTML|dangerouslySetInnerHTML", IsRegex=true)

# Eval usage
grep_search(Query="\\beval\\(|\\bexec\\(", IsRegex=true)
```

---

## 🚀 Start Review

Process input: **$ARGUMENTS**

1. Determine scope (all changes / specific files / commit range)
2. Gather git diff
3. Call `code-reviewer` subagent
4. Generate review report
5. Display summary with verdict
