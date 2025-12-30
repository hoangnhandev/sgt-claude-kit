---
description: Fix bugs with efficient routing (Quick Fix vs Deep Investigation).
---

# Bugfix Workflow

## 1. Triage & Analyze

**Agent**: `bug-handler`
**Task**: Analyze issue. Determine complexity (Simple/Complex).

## 2. Decision Gate

- **If Simple (Quick Fix)**:
  - Skip Investigation. Goto **Step 3**.
- **If Complex**:
  - `bug-handler` continues Deep Investigation (Root Cause Analysis).

## 3. Implementation

**Agent**: `senior-developer`
**Task**: Apply fix (Minimal changes).
**Mode**: `Bug Fix` (Strict no refactoring).

## 4. Verification

**Agent**: `test-engineer`
**Task**: Verify fix (Reproduction Test).
**Gate**: Must pass reproduction test & regression suite.

## 5. Finalize

**Agent**: `documentation-writer`
**Task**: Commit `fix(...)`.
