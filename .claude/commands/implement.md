---
description: Implement feature from existing plan (Phase 3-5) - Use when you have an approved architecture plan
---

# /implement - Implementation Workflow

You are the Main Agent running Phases 3-5 of the workflow: **Implementation, Testing, Review, and Finalization**.

---

## 📥 Input

`$ARGUMENTS` can be:

| Input Type         | Example                                 | Description                                        |
| ------------------ | --------------------------------------- | -------------------------------------------------- |
| Feature slug       | `user-auth`                             | Uses existing `.kira/plans/{slug}-architecture.md` |
| Plan file path     | `.kira/plans/user-auth-architecture.md` | Direct path to plan                                |
| Inline requirement | "Add login button"                      | Will run quick analysis first                      |

---

## 🔄 Pre-flight Check

Before implementation, verify:

```bash
# Check if architecture plan exists
view_file(.kira/plans/{feature-slug}-architecture.md)
```

**If plan exists**: Proceed to Implementation
**If plan doesn't exist**: Run `/feature $ARGUMENTS` first or do quick planning

---

## 🔄 Execution Flow

### Phase 3: Implementation

**Subagent**: `senior-developer`

```
📋 Call subagent: senior-developer
📄 Input: Architecture plan from .kira/plans/{feature-slug}-architecture.md
📁 Output: .kira/plans/{feature-slug}-implementation-report.md
```

**Tasks**:

1. Read and follow the architecture plan
2. Implement code changes step by step
3. Apply project conventions (from memory/skills)
4. Self-review before completion
5. Run lint and type-check

---

### Phase 3b: Testing

**Subagent**: `test-engineer`

```
📋 Call subagent: test-engineer
📄 Input: Implementation report + git diff
📁 Output: .kira/plans/{feature-slug}-test-report.md
```

**Tasks**:

1. Analyze code changes
2. Write unit tests for new code
3. Run test suite
4. Verify coverage >= 80%
5. Report results

**⚠️ QUALITY GATE**: If tests fail, STOP and report to user.

---

### Phase 4: Code Review

**Subagent**: `code-reviewer`

```
📋 Call subagent: code-reviewer
📄 Input: All changes (git diff) + test report
📁 Output: .kira/reviews/{feature-slug}-review.md
```

**Tasks**:

1. Review all code changes
2. Check for security issues
3. Verify best practices
4. Classify issues (Critical/Warning/Info)
5. Provide verdict

**⚠️ QUALITY GATE**: If CRITICAL issues found, STOP and request fixes.

---

### Phase 4b: Fix Issues (If Needed)

If Code Reviewer found issues:

```
📋 Call subagent: senior-developer (Phase 4 mode)
📄 Input: Review report with issues
📁 Action: Fix issues, then re-trigger code-reviewer
```

**Loop until**: No CRITICAL issues remain

---

### Phase 5: Documentation & Finalization

**Subagent**: `documentation-writer`

```
📋 Call subagent: documentation-writer
📄 Input: Implementation report + Review report
📁 Output: Updated README, CHANGELOG, JSDoc
```

**Tasks**:

1. Add JSDoc/TSDoc to new public APIs
2. Update README if needed
3. Add CHANGELOG entry
4. Stage changes with git
5. Create commit with conventional message
6. Generate session log

---

## 📁 Output Files

After completion:

```
.kira/
├── plans/
│   ├── {feature-slug}-implementation-report.md
│   └── {feature-slug}-test-report.md
├── reviews/
│   └── {feature-slug}-review.md
└── logs/
    └── session-{timestamp}.md

# Code changes
src/...  (modified/created files)

# Git
git log -1  (new commit)
```

---

## ✅ Completion Summary

After all phases complete, display:

```markdown
## ✅ Implementation Complete

### Feature: {feature-name}

### Summary

| Metric         | Value       |
| -------------- | ----------- |
| Files Created  | X           |
| Files Modified | X           |
| Lines Added    | +XXX        |
| Lines Removed  | -XXX        |
| Test Coverage  | XX%         |
| Review Status  | ✅ APPROVED |

### Commit
```

{commit-hash} - {commit-message}

```

### Generated Documents
- `.kira/plans/{feature-slug}-implementation-report.md`
- `.kira/plans/{feature-slug}-test-report.md`
- `.kira/reviews/{feature-slug}-review.md`
- `.kira/logs/session-{timestamp}.md`

---

## 🎯 Next Steps

1. **Push changes**: `git push origin {branch}`
2. **Create PR**: `gh pr create` (GitHub Mode)
3. **Manual review**: Review the changes before merging
```

---

## 🚨 Error Handling

### Tests Failed

```markdown
🚫 **QUALITY GATE BLOCKED**: Tests Failed

**Failed Tests**:

- test-name-1: Error message
- test-name-2: Error message

**Action Required**:

1. Fix the failing tests
2. Run `/implement {feature-slug}` again

Or manually: `npm run test`
```

### Critical Review Issues

```markdown
🚫 **QUALITY GATE BLOCKED**: Critical Issues Found

**Issues**:

1. [File:Line] Issue description

**Action Required**:

1. Fix the critical issues
2. Run `/review` to re-check

See: `.kira/reviews/{feature-slug}-review.md`
```

---

## 🚀 Start Implementation

Process input: **$ARGUMENTS**

1. Detect input type and find/create architecture plan
2. Call `senior-developer` subagent
3. Call `test-engineer` subagent
4. Call `code-reviewer` subagent
5. If issues: Call `senior-developer` to fix, then re-review
6. Call `documentation-writer` subagent
7. Display completion summary
