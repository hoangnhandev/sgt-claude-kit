---
description: Fix bugs with efficient routing (Quick Fix vs Deep Investigation).
---

# Bugfix Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Triage & Analysis

**Agent**: `bug-handler`
**Input**: Issue description / Error log.
**Task**: Analyze issue severity and determine complexity (Simple/Complex).

## 2. Decision Gate & Strategy

**Condition**: Complexity check from Phase 1.

### Path A: Simple Fix

**Action**: Proceed directly to **Implementation**.

### Path B: Complex Fix (Parallel Phase)

**Strategy**: Run analysis and test creation concurrently.

1.  **Investigator**: `senior-developer` performs Root Cause Analysis.
2.  **Tester**: `test-engineer` creates a **Failing Reproduction Test**.

**Merge**: Ensure Root Cause is identified AND Repro Test exists before Implementation.

## 3. Implementation

**Agent**: `senior-developer`
**Input**: Analysis Report.
**Task**: Apply fix with minimal changes.
**Mode**: Bug Fix (Strict no refactoring).

## 4. Verification

**Command**: `/test`
**Gate**: Pass reproduction test & regression suite.

## 5. Finalization

**Agent**: `documentation-writer`
**Task**: Create commit with format `fix(...)`.

## 6. Recovery Strategy

**If Verification Fails**: Re-run `senior-developer` with failure context.
