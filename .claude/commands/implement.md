---
description: Executes the implementation phase of a task. It directs the 'senior-developer' to write code according to the architecture plan or specifications, followed by testing and review. Enforces minimal changes and strict adherence to conventions. Note: You must use the subagents specified in this command.
---

# Implement Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Implementation

**Agent**: `senior-developer`
**Input**: Architecture Plan (from `/plan`) or Specifications.
**Task**: Write code, strictly following the plan. Output Implementation Report.
**Constraint**: Perform MINIMAL changes. Do not refactor unrelated code unless necessary.

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
