---
description: Full feature development workflow with automatic complexity routing.
---

# Feature Workflow

## 🧠 Dynamic Execution Logic

This workflow automatically adapts to task complexity based on the Analysis phase.

### Complexity Gate

After **Analysis**, the agents will categorize the task:

- **LITE**: (Change < 50 LOC, 1-2 files, no architecture change).
  - **Path**: Analysis -> Implementation -> Review -> Git.
  - **Auto-Skip**: `solution-architect`, `test-engineer` (if non-critical), `documentation-writer`.
- **FULL**: (New features, schema changes, heavy refactor).
  - **Path**: Analysis -> Planning -> Implementation -> Testing -> Review -> Documentation -> Git.

## 1. Analysis (Required)

**Agent**: `requirement-analyst`
**Support**: `codebase-scout`
**Task**: Analyze specs and output **Complexity Verdict (LITE/FULL)**.

## 2. Planning (Conditional)

**Agent**: `solution-architect`
**Action**: **SKIP** if Verdict is **LITE**.
**Gate**: User Approval (Required for FULL features).

## 3. Implementation & Verification

**Agent**: `senior-developer`
**Testing**: `test-engineer` (Mandatory for FULL, Optional for LITE).
**Review**: `code-reviewer` (Mandatory for ALL).

## 4. Finalization

**Agent**: `documentation-writer` (**SKIP** if LITE).
**Task**: Update documentation and prepare Git commits.

## 🔄 Recovery Strategy

If any step (Lint/Build/Test/Review) fails, the flow returns to `senior-developer` for fixing until all quality gates are passed.
