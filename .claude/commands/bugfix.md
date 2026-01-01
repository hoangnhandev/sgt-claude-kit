---
description: Handles bug fixes through an intelligent routing system. It assesses complexity to choose between a direct quick fix path or a deep investigation path (Parallel Phase with 'senior-developer' and 'test-engineer'). Ensures reproduction tests are created for complex bugs before implementation.
---

# Bugfix Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Triage & Analysis

**Agent**: `bug-handler`
**Input**: Issue description / Error log.
**Task**: Analyze issue severity and determine complexity (Simple/Complex).
**Output**: `bug-handler` must clearly state if the bug is **Simple** or **Complex** in its final report.

## 2. Strategy Execution

Based on the **Complexity** determined in Step 1:

- **IF SIMPLE**: Proceed directly to **Step 3 (Implementation)**.
- **IF COMPLEX**: execute the following sub-steps (Parallel Execution allowed):
  - **2a. Root Cause Analysis**: Run `senior-developer` to perform deep analysis.
  - **2b. Reproduction**: Run `test-engineer` to create a **Failing Reproduction Test**.
  - **Resume**: Proceed to Step 3 only after the test is created and fails.

## 3. Implementation

**Agent**: `senior-developer`
**Input**: Analysis Report and (if Complex) the Failing Test.
**Task**: Apply fix with minimal changes.
**Constraint**: Perform MINIMAL changes. Strict no refactoring of unrelated code.

## 4. Verification

**Command**: `/test`
**Task**: Verify the fix.

- If **Complex**: The specific reproduction test must PASS.
- **Global**: The full regression suite must PASS.
- **Failure Handling**: If tests fail, Return to **Step 3** with the failure log.

## 5. Finalization

**Agent**: `documentation-writer`
**Task**: Create commit with format `fix(...)` and update documentation if necessary.
