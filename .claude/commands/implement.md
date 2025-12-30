---
description: Implement code based on architecture plan.
---

# Implement Workflow

## 1. Implementation

**Agent**: `senior-developer`
**Input**: Architecture Plan (from `/plan`) or Specifications.
**Task**: Write code, strictly following the plan. Output Implementation Report.

## 2. Testing

**Command**: `/test`
**Gate**: Pass > 80% Coverage.

## 3. QA Review

**Command**: `/review`
**Gate**: Approved (No Critical Issues).

## 4. Finalize

**Agent**: `documentation-writer`
**Input**: All reports.
**Task**: Update docs, changelog, create commit.

## 5. Recovery Strategy

**If Test Fails**: Re-run `senior-developer` to fix, then `/test`.
**If Review Fails**: Re-run `senior-developer` to fix, then `/review`.
