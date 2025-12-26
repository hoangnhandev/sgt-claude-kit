---
description: Analyze requirement only (Phase 1) - Use when you want to understand a requirement without implementing
---

# /analyze - Requirement Analysis Only

You are the Main Agent running Phase 1 of the workflow: **Requirement & Codebase Analysis**.

---

## 📥 Input

`$ARGUMENTS` can be:

| Input Type   | Example                               |
| ------------ | ------------------------------------- |
| GitHub Issue | `#123`                                |
| Local File   | `.kira/inputs/feature-auth.md`        |
| Inline Text  | "Add user authentication with OAuth2" |

---

## 🔄 Execution Flow

### Step 1: Requirement Analysis

**Subagent**: `requirement-analyst`

```
📋 Call subagent: requirement-analyst
📄 Input: $ARGUMENTS
📁 Output: .kira/plans/{feature-slug}-requirements.md
```

**Tasks**:

1. Parse and analyze the requirement
2. Extract user stories and acceptance criteria
3. Identify scope, constraints, and unknowns
4. Generate structured requirement document

---

### Step 2: Codebase Analysis

**Subagent**: `codebase-scout`

```
📋 Call subagent: codebase-scout
📄 Input: Requirement document from Step 1
📁 Output: .kira/plans/{feature-slug}-codebase-analysis.md
```

**Tasks**:

1. Explore directory structure
2. Find related files and patterns
3. Identify dependencies and impact areas
4. Map existing code that needs modification

---

## 📁 Output Files

After completion:

```
.kira/plans/
├── {feature-slug}-requirements.md      # Requirement analysis
└── {feature-slug}-codebase-analysis.md # Codebase exploration
```

---

## ✅ Completion

After analysis, display:

```markdown
## ✅ Analysis Complete

### Requirement Summary

[Brief summary from requirement-analyst]

### Codebase Impact

- **Files to modify**: X
- **Files to create**: X
- **Complexity estimate**: Simple / Medium / Complex

### 📁 Generated Documents

- `.kira/plans/{feature-slug}-requirements.md`
- `.kira/plans/{feature-slug}-codebase-analysis.md`

---

## 🎯 Next Steps

1. **Continue to planning**: Run `/plan {feature-slug}` to generate architecture
2. **Full workflow**: Run `/implement {feature-slug}` to implement directly
3. **Review analysis**: Open the generated documents for manual review
```

---

## 🚀 Start Analysis

Process input: **$ARGUMENTS**

1. Detect input type (GitHub/Local/Inline)
2. Generate feature-slug from input
3. Call `requirement-analyst` subagent
4. Call `codebase-scout` subagent
5. Display completion summary
