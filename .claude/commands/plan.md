---
description: Create architecture plan from analysis (Phase 2) - Use when you have requirement analysis ready
---

# /plan - Architecture Planning Only

You are the Main Agent running Phase 2 of the workflow: **Solution Architecture**.

---

## 📥 Input

`$ARGUMENTS` can be:

| Input Type         | Example                                 | Description                                |
| ------------------ | --------------------------------------- | ------------------------------------------ |
| Feature slug       | `user-auth`                             | Uses existing analysis from `.kira/plans/` |
| Requirement file   | `.kira/plans/user-auth-requirements.md` | Direct path                                |
| Inline requirement | "Add OAuth2 login"                      | Will run quick analysis first              |

---

## 🔄 Pre-flight Check

Verify analysis documents exist:

```bash
# Check for requirement analysis
view_file(.kira/plans/{feature-slug}-requirements.md)

# Check for codebase analysis
view_file(.kira/plans/{feature-slug}-codebase-analysis.md)
```

**If analysis exists**: Proceed to Architecture
**If analysis missing**: Run `/analyze $ARGUMENTS` first

---

## 🔄 Execution Flow

### Step 1: Solution Architecture

**Subagent**: `solution-architect`

```
📋 Call subagent: solution-architect
📄 Input: Requirements + Codebase Analysis documents
📁 Output: .kira/plans/{feature-slug}-architecture.md
```

**Tasks**:

1. Review requirement and codebase analysis
2. Evaluate different architectural approaches
3. Select optimal approach with justification
4. Create detailed implementation plan
5. Identify risks and mitigations
6. Estimate effort and complexity

---

### Step 2: Complexity Assessment

Evaluate and document complexity:

| Complexity   | Criteria                                        |
| ------------ | ----------------------------------------------- |
| **Simple**   | 1-2 files, existing patterns, easy rollback     |
| **Medium**   | 3-5 files, new components, tests needed         |
| **Complex**  | 5+ files, new patterns, multi-module impact     |
| **Critical** | Core changes, security impact, breaking changes |

---

## 📊 Architecture Output

Generate `.kira/plans/{feature-slug}-architecture.md`:

```markdown
# Architecture Plan: [Feature Name]

**Created**: YYYY-MM-DD HH:MM
**Complexity**: [Simple/Medium/Complex/Critical]

---

## 1. Overview

[Brief description of the solution]

## 2. Technical Approach

### Chosen Approach

[Description of selected approach]

### Alternatives Considered

| Approach | Pros | Cons | Why Not |
| -------- | ---- | ---- | ------- |
| Alt 1    | ...  | ...  | ...     |
| Alt 2    | ...  | ...  | ...     |

## 3. Implementation Plan

### Step 1: [Name]

- **Effort**: S/M/L
- **Files**: List of files
- **Description**: What to do

### Step 2: [Name]

...

## 4. Changes Summary

### Files to Create

| File             | Purpose     |
| ---------------- | ----------- |
| `path/to/new.ts` | Description |

### Files to Modify

| File                  | Changes     |
| --------------------- | ----------- |
| `path/to/existing.ts` | Description |

## 5. Testing Strategy

- Unit tests: Description
- Integration tests: Description
- Edge cases: List

## 6. Risks & Mitigations

| Risk   | Impact          | Mitigation    |
| ------ | --------------- | ------------- |
| Risk 1 | High/Medium/Low | How to handle |

## 7. Rollback Plan

[Steps to rollback if needed]

---

**Estimated Effort**: X hours/days
```

---

## ✅ Completion

After planning, display:

```markdown
## ✅ Architecture Plan Complete

### Feature: {feature-name}

### Complexity: {Simple/Medium/Complex/Critical}

### Summary

- **Approach**: [Brief description]
- **Files to modify**: X
- **Files to create**: X
- **Estimated effort**: X hours

### Key Decisions

1. [Decision 1]
2. [Decision 2]

### Risks

- [Risk 1]: [Mitigation]

📄 **Full plan**: `.kira/plans/{feature-slug}-architecture.md`

---

## 🎯 Next Steps

### For Simple complexity:

➡️ Auto-approved. Run `/implement {feature-slug}` to start coding.

### For Medium/Complex/Critical:

⏸️ Review the plan above, then:

1. **Approve**: "OK" or "Approve" to continue
2. **Modify**: Request changes to the plan
3. **Discuss**: Ask questions about the approach
```

---

## 🚀 Start Planning

Process input: **$ARGUMENTS**

1. Verify analysis documents exist
2. If missing, prompt to run `/analyze` first
3. Call `solution-architect` subagent
4. Generate architecture document
5. Display completion summary with next steps
