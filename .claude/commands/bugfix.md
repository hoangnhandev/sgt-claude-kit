---
description: Fix bugs with efficient routing (Quick Fix vs Deep Investigation).
---

# Bugfix Workflow

## 1. Triage & Analysis

**Agent**: `bug-handler`
**Input**: Issue description / Error log.
**Task**: Analyze issue severity and determine complexity (Simple/Complex).

## 2. Decision Gate

**Condition**: Complexity check.
**If Simple**: Proceed directly to **Implementation**.
**If Complex**: Continue **Deep Investigation** (Root Cause Analysis).

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
