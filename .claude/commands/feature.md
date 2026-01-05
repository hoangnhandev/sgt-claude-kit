---
description: Orchestrates the complete feature development lifecycle. Automatically routes tasks based on complexity (LITE vs FULL), utilizing requirement-analyst, solution-architect, senior-developer, and code-reviewer agents to deliver high-quality code.
---

# Feature Workflow

## 🧠 Dynamic Execution Logic

This workflow automatically adapts to task complexity based on the Analysis phase.

### Complexity Gate

After **Analysis**, the agents will categorize the task:

- **LITE**: (Change < 50 LOC, 1-2 files, no architecture change).
  - **Path**: Analysis -> Implementation -> Review.
  - **Auto-Skip**: `solution-architect`.
- **FULL**: (New features, schema changes, heavy refactor).
  - **Path**: Analysis -> Planning -> Implementation -> Review.

## 1. Analysis (Required)

**Agent**: `requirement-analyst`
**Support**: `codebase-scout`
**Task**: Analyze specs and output **Complexity Verdict (LITE/FULL)**.

## 2. Planning (Conditional)

**Agent**: `solution-architect`
**Input**: Retrieves `feature-requirements` entity from Memory.
**Action**: **SKIP** if Verdict is **LITE**.
**Gate**: User Approval (Required for FULL features).

## 3. Implementation & Verification

**Agent**: `senior-developer`
**Input**: Retrieves `feature-requirements` (LITE) or Architecture Plan (FULL) from Memory/File.

## 4. Review

**Agent**: `code-reviewer`
**Input**: Implementation changes.

## 🔄 Recovery Strategy

If any step (Lint/Build/Review) fails, the flow returns to `senior-developer` for fixing until all quality gates are passed.
