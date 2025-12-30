---
description: Implement code based on architecture plan.
---

# Implement Workflow

## 1. Implementation

**Agent**: `senior-developer`
**Input**: Architecture Plan (from `/plan`).
**Task**: Write code, strictly following the plan. Output Implementation Report.

## 2. Testing

**Agent**: `test-engineer`
**Input**: Implementation Report + Code.
**Task**: Add/Run tests. Verify coverage > 80%.

## 3. QA Review

**Agent**: `code-reviewer`
**Input**: Code + Test Report.
**Task**: Review quality & security.
**Gate**: Must approve (No Critical Issues).

## 4. Finalize

**Agent**: `documentation-writer`
**Input**: All reports.
**Task**: Update docs, changelog, create commit.
