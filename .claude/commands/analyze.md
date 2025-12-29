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

## 🔄 Execution Flow (⚡ PARALLEL)

> **🚀 PERFORMANCE**: Both subagents run **SIMULTANEOUSLY** for ~30% faster analysis.

### Step 1: Parallel Analysis

**Mode**: ⚡ **PARALLEL EXECUTION**

| Subagent              | Task                 | Output File                           |
| --------------------- | -------------------- | ------------------------------------- |
| `requirement-analyst` | Requirement Analysis | `{feature-slug}-requirements.md`      |
| `codebase-scout`      | Codebase Exploration | `{feature-slug}-codebase-analysis.md` |

---

#### 🔀 Subagent A: Requirement Analyst (PARALLEL)

**Subagent**: `requirement-analyst`

```
📋 Call subagent: requirement-analyst
⚡ Mode: PARALLEL (runs simultaneously with codebase-scout)
📄 Input: $ARGUMENTS
📁 Output: .kira/plans/{feature-slug}-requirements.md
```

**Tasks**:

1. Parse and analyze the requirement
2. Extract user stories and acceptance criteria
3. Identify scope, constraints, and unknowns
4. Generate structured requirement document

---

#### 🔀 Subagent B: Codebase Scout (PARALLEL)

**Subagent**: `codebase-scout`

```
📋 Call subagent: codebase-scout
⚡ Mode: PARALLEL (runs simultaneously with requirement-analyst)
📄 Input: $ARGUMENTS (same input, independent analysis)
📁 Output: .kira/plans/{feature-slug}-codebase-analysis.md
```

**Tasks**:

1. Explore directory structure
2. Find related files and patterns
3. Identify dependencies and impact areas
4. Map existing code that needs modification

---

### Step 2: Merge & Validate

**Executed by**: Main Agent

1. Wait for both subagents to complete
2. Validate both output files exist
3. Cross-reference results for consistency

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
3. **⚡ Launch PARALLEL execution**:
   - Start `requirement-analyst` subagent with $ARGUMENTS
   - Start `codebase-scout` subagent with $ARGUMENTS (simultaneously)
4. Wait for both to complete
5. Validate & merge results
6. Display completion summary
