---
description: Perform code review.
---

# Review Workflow

## 1. Review

**Agent**: `code-reviewer`
**Input**: Git diff.
**Task**: Check Security, Logic, Style.
**Output**: Review Report.

## 2. Approval Gate

- **Approved**: Ready to merge.
- **Changes Requested**: Must fix critical issues.

## 3. Feedback Loop (If Rejected)

**Agent**: `senior-developer`
**Task**: Fix reported issues.
