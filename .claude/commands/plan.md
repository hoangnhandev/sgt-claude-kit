---
description: Generates a detailed architecture and implementation plan. It utilizes the 'solution-architect' to design the solution based on the analysis outputs, ensuring minimal disruption to the existing codebase. Required before complex implementation. Note: You must use the subagents specified in this command.
---

# Plan Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Architecture Design

**Agent**: `solution-architect`
**Input**: Requirements & Codebase Analysis (from `/analyze`).
**Task**: Design solution, create implementation plan.
**Constraint**: Perform MINIMAL changes. Do not refactor unrelated code unless necessary.

## 2. Plan Review (Optional)

**Agent**: `user` (Interactive)
**Condition**: If Complexity > Medium.
**Task**: Review and approve `.temp/plans/{feature}-architecture.md`.

## Output

- File: `.temp/plans/{feature}-architecture.md`
- Ready for: `/implement`
