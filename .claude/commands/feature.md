---
description: Full feature development workflow (Analyze -> Plan -> Implement).
---

# Feature Workflow

## Global Rules

- **Code Convention**: Strictly follow existing project conventions. Do NOT create new styles or conventions.

## 1. Analysis

**Command**: `/analyze`
**Agents**: `requirement-analyst`, `codebase-scout`
**Task**: Analyze requirements and feasibility.

## 2. Planning

**Command**: `/plan`
**Agent**: `solution-architect`
**Gate**: User Approval (Required for Complex features).

## 3. Implementation & Verification

**Command**: `/implement`
**Agents**: `senior-developer`, `test-engineer`, `code-reviewer`, `documentation-writer`
**Gate**: Test Coverage > 80%, Review Approved.

## 4. Recovery Strategy

**If Test Fails**: Re-run `senior-developer` to fix, then `test-engineer`.
**If Review Fails**: Re-run `senior-developer` to fix, then `code-reviewer`.

## Variants

- `feature [name]`: Standard flow.
- `feature --quick`: Skip formal planning (for simple changes).
