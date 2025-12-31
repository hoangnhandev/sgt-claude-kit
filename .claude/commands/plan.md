---
description: Create architecture plan for a feature.
---

# Plan Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Architecture Design

**Agent**: `solution-architect`
**Input**: Requirements & Codebase Analysis (from `/analyze`).
**Task**: Design solution, create implementation plan.

## 2. Plan Review (Optional)

**Agent**: `user` (Interactive)
**Condition**: If Complexity > Medium.
**Task**: Review and approve `.kira/plans/{feature}-architecture.md`.

## Output

- File: `.kira/plans/{feature}-architecture.md`
- Ready for: `/implement`
