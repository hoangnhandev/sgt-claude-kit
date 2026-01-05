---
description: Orchestrates a robust bug fix pipeline. 'bug-handler' performs deep diagnosis and planning, followed by 'senior-developer' which implements the fix, and 'code-reviewer' validates the changes before final sign-off.
---

# Bugfix Workflow

## 📊 Severity & Complexity Criteria

### Severity Levels

| Level             | Description                             | Response Time |
| ----------------- | --------------------------------------- | ------------- |
| **P0 (Critical)** | System down, data loss, security breach | Immediate     |
| **P1 (High)**     | Major feature broken, no workaround     | < 4 hours     |
| **P2 (Medium)**   | Feature impaired, workaround exists     | < 24 hours    |
| **P3 (Low)**      | Minor issue, cosmetic, edge case        | Next sprint   |

### Complexity Classification

| Criteria       | Simple                         | Complex                       |
| -------------- | ------------------------------ | ----------------------------- |
| **Scope**      | Single file, typo, CSS, config | Multiple files, logic changes |
| **Root Cause** | Obvious (typo, missing import) | Requires investigation        |
| **Testing**    | Manual verification sufficient | Automated tests needed        |

> **Note**: Simple bugs skip deep investigation. Complex bugs require full Phase 2 analysis.

## 🔄 Execution Flow

**Step 1: Analysis & Diagnose**

- **Agent**: `bug-handler`
- **Input**: Issue description / Error log.
- **Action**:
  1. **Triage**: Assess severity (P0-P3) and complexity (Simple/Complex).
  2. **Reproduction**: Determine detailed steps or create a reproduction script.
  3. **Root Cause Analysis**: Identify the specific logic or data causing the issue.
  4. **Fix Plan**: Propose a concrete solution strategy.
- **Memory Output**: Create/Update `bug-analysis` entity containing:
  - Bug Summary & Severity
  - Complexity Verdict (Simple/Complex)
  - Root Cause & Fix Options

**Step 2: Implementation**

- **Agent**: `senior-developer`
- **Memory Input**: Read `bug-analysis` entity from Memory.
- **Action**: Implement the fix following the proposed solution. Validate with lint/build.
- **Memory Output**: Create/Update `implementation-summary` entity containing:
  - Files Changed
  - Validation Results (Lint/Build)
  - Fix Description

**Step 3: Code Review**

- **Agent**: `code-reviewer`
- **Memory Input**: Read `bug-analysis` and `implementation-summary` from Memory.
- **Action**: Review the implementation against the bug analysis and conventions.
- **Verdict**: ✅ APPROVED or 🚫 CHANGES REQUESTED

## Memory Consistency Rules

- **Source of Truth**: The Memory Graph is the primary context carrier.
- **Mandatory Read**: Every agent MUST call `read_graph` or `search_nodes` at the start of their turn.
- **Structured Handoff**: Agents pass information via specific Entities (`bug-analysis`, `implementation-summary`) rather than just chat history.

## ⚠️ Error Handling

| Failure Point                | Action                                                                                          | Responsible Agent  |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | ------------------ |
| **Step 2 - Build/Lint Fail** | Fix errors and re-validate. Max 3 retry attempts.                                               | `senior-developer` |
| **Step 3 - Review Rejected** | Return to Step 2 with reviewer feedback. Update `implementation-summary` with rejection reason. | `senior-developer` |
| **Missing Context**          | If required Memory entities are missing, STOP and notify user.                                  | Any agent          |

### Rollback Procedure

If fix causes regression or critical issues:

1. **Revert**: `git checkout -- .` to discard uncommitted changes
2. **Log**: Store failure reason in Memory entity `failure-log`
3. **Notify**: Report to user with clear explanation of what went wrong
