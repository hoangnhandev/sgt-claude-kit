---
description: Orchestrates a robust bug fix pipeline. 'bug-handler' performs deep diagnosis and planning, followed by 'senior-developer' which implements the fix, and 'code-reviewer' validates the changes before final sign-off.
---

# Bugfix Workflow

## 1. Analysis & Diagnose

**Agent**: `bug-handler`
**Input**: Issue description / Error log.
**Task**:

1.  **Triage**: Assess severity and complexity.
2.  **Reproduction**: Determine detailed steps or create a reproduction script if possible.
3.  **Root Cause Analysis**: Identify the specific logic or data causing the issue.
4.  **Fix Plan**: Propose a concrete solution strategy.

**Output**: A memory entity with the Analysis and proposed Fix Plan.

## 2. Implementation & Verification

**Agent**: `senior-developer`
**Input**: Retrieves the `bug-analysis` entity from Memory (created in Step 1).
**Task**: Implement the solution proposed by `bug-handler`.

## 3. Code Review

**Agent**: `code-reviewer`
**Input**: Implementation changes.
**Task**: Validate code quality, security, and logical correctness.

## 4. Final Review

**Actor**: User
**Task**: Review the changes and verify the fix manually if needed.
