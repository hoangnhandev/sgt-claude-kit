---
description: Full feature development workflow (Analyze -> Plan -> Implement).
---

# Feature Workflow

## 🔄 Flow

1. **Analyze**: `/analyze`
   - Agent: `requirement-analyst`, `codebase-scout`
2. **Plan**: `/plan`
   - Agent: `solution-architect`
   - **Gate**: User Approval (if Complex)
3. **Implement**: `/implement`
   - Agent: `senior-developer`
   - Agent: `test-engineer` (Gate: Cov > 80%)
   - Agent: `code-reviewer` (Gate: Approved)
   - Agent: `documentation-writer`

## 🕹️ Variants

- `/feature new-login`: Run full flow.
- `/feature --quick`: Skip formal planning (for simple features).

## ⚠️ Recovery

- If **Test Fails**: Re-run `senior-developer` to fix, then `test-engineer`.
- If **Review Fails**: Re-run `senior-developer` to fix, then `code-reviewer`.
