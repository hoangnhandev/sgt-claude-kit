---
description: Orchestrates the complete feature development lifecycle. Automatically routes tasks based on complexity (LITE vs FULL), utilizing requirement-analyst, solution-architect, senior-developer, and code-reviewer agents to deliver high-quality code.
---

# Feature Workflow

## � Complexity Criteria

| Criteria                   | LITE          | FULL                      |
| -------------------------- | ------------- | ------------------------- |
| **Files Affected**         | ≤ 3 files     | > 3 files                 |
| **Lines of Code**          | < 100 LOC     | ≥ 100 LOC                 |
| **API/DB Changes**         | None          | Schema/Endpoint changes   |
| **New Dependencies**       | None          | New libraries required    |
| **Cross-cutting Concerns** | Single module | Multiple modules/services |

> **Note**: If ANY criteria qualifies as FULL, the entire task is classified as **FULL**.

## �🔄 Execution Flow

**Step 1: Requirement Analysis**

- **Agent**: `requirement-analyst`
- **Action**: Analyze the user request to define scope and complexity.
- **Memory Output**: Create/Update `feature-requirements` entity containing:
  - User Goals & Core Logic
  - Complexity Verdict (**LITE** vs **FULL**)

**Step 2: Codebase Exploration**

- **Agent**: `codebase-scout`
- **Memory Input**: Read `feature-requirements` from Memory.
- **Action**: Map the project structure and find reusable patterns.
- **Memory Output**: Create/Update `codebase-context` entity containing:
  - Relevant Files List
  - Existing Patterns to Reuse
  - Dependency Impact Analysis

**Step 3: Planning (Conditional)**

- **Rule**: Execute ONLY if Complexity Verdict is **FULL**.
- **Agent**: `solution-architect`
- **Memory Input**: Read `feature-requirements` and `codebase-context` from Memory.
- **Action**: Design the technical solution.
- **Artifact**: Produce `.temp/plans/implementation-plan.md`.

**Step 4: Implementation**

- **Agent**: `senior-developer`
- **Memory Input**: Read `feature-requirements`, `codebase-context`, and `.temp/plans/implementation-plan.md` (if exists).
- **Action**: Implement the feature and verify functionality.
- **Memory Output**: Create/Update `implementation-summary` entity containing:
  - Files Changed
  - Validation Results (Lint/Build)
  - Implementation Description

**Step 5: Review**

- **Agent**: `code-reviewer`
- **Memory Input**: Read `feature-requirements` and `implementation-summary` from Memory.
- **Action**: Review the implementation against the requirements and conventions.

## Memory Consistency Rules

- **Source of Truth**: The Memory Graph is the primary context carrier.
- **Mandatory Read**: Every agent MUST call `read_graph` or `search_nodes` at the start of their turn.
- **Structured Handoff**: Agents pass information via specific Entities (`feature-requirements`, `codebase-context`) rather than just chat history.

## ⚠️ Error Handling

| Failure Point                | Action                                                                                          | Responsible Agent  |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | ------------------ |
| **Step 4 - Build/Lint Fail** | Fix errors and re-validate. Max 3 retry attempts.                                               | `senior-developer` |
| **Step 5 - Review Rejected** | Return to Step 4 with reviewer feedback. Update `implementation-summary` with rejection reason. | `senior-developer` |
| **Missing Context**          | If required Memory entities are missing, STOP and notify user.                                  | Any agent          |

### Rollback Procedure

If implementation causes critical issues:

1. **Revert**: `git checkout -- .` to discard uncommitted changes
2. **Log**: Store failure reason in Memory entity `failure-log`
3. **Notify**: Report to user with clear explanation of what went wrong
