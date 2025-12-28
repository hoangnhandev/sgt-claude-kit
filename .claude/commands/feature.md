---
description: Full feature development workflow - from requirement analysis to implementation plan
---

# /feature - Feature Development Workflow

You are the Main Agent coordinating the development workflow for new features.

---

## 📥 Input Detection

Analyze `$ARGUMENTS` to determine input type:

| Pattern                           | Input Type         | Example                                  |
| --------------------------------- | ------------------ | ---------------------------------------- |
| `#[0-9]+`                         | GitHub Issue       | `#123`                                   |
| `http(s)://...`                   | GitHub URL         | `https://github.com/org/repo/issues/123` |
| `.kira/inputs/*.md` or path `.md` | Local File         | `.kira/inputs/feature-auth.md`           |
| Plain Text                        | Inline Requirement | "Add Google login functionality"         |

---

## 🔄 Execution Flow

### Phase 1: Requirement Analysis

**Subagent**: `requirement-analyst`

**Steps**:

1. Read and analyze input requirement
2. Extract user stories, acceptance criteria
3. Identify scope and constraints
4. **🚨 MUST use `Write` tool** to save output

**Subagent Task** (copy this exact prompt when calling):

```
🎯 TASK: Analyze the feature requirement and create a requirements document.

📄 INPUT: Read and analyze the requirement from: $ARGUMENTS

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-requirements.md

⚠️ CRITICAL INSTRUCTIONS:
1. You MUST call `Write` tool to create the output file
2. DO NOT just output markdown content as a response
3. Your task is NOT complete until the file is created
4. After creating the file, confirm: "✅ File created: [path]"
```

---

### Phase 2: Codebase Analysis

**Subagent**: `codebase-scout`

**Steps**:

1. Explore codebase to understand context
2. Find relevant files and patterns
3. Assess impact
4. **🚨 MUST use `Write` tool** to save output

**Subagent Task** (copy this exact prompt when calling):

```
🎯 TASK: Analyze the codebase to understand context for the feature implementation.

📄 INPUT: Read the requirement document from: .kira/plans/{feature-slug}-requirements.md

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-codebase-analysis.md

⚠️ CRITICAL INSTRUCTIONS:
1. You MUST call `Write` tool to create the output file
2. DO NOT just output markdown content as a response
3. Your task is NOT complete until the file is created
4. After creating the file, confirm: "✅ File created: [path]"
```

---

### Phase 3: Solution Architecture

**Subagent**: `solution-architect`

**Steps**:

1. Design technical solution
2. Evaluate different approaches
3. Create detailed implementation plan
4. Assess **Complexity**: Simple / Medium / Complex / Critical
5. **🚨 MUST use `Write` tool** to save output

**Subagent Task** (copy this exact prompt when calling):

```
🎯 TASK: Design the solution architecture and create an implementation plan.

📄 INPUT:
- Requirements: .kira/plans/{feature-slug}-requirements.md
- Codebase Analysis: .kira/plans/{feature-slug}-codebase-analysis.md

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-architecture.md

⚠️ CRITICAL INSTRUCTIONS:
1. You MUST call `Write` tool to create the output file
2. DO NOT just output markdown content as a response
3. Your task is NOT complete until the file is created
4. After creating the file, confirm: "✅ File created: [path]"
```

---

## 🚦 DECISION GATE: Auto-Approve vs User Review

> ⚠️ **CRITICAL**: This is a mandatory checkpoint after Phase 3.

### Classification Rules

After `solution-architect` completes, check the **Complexity** field in the output:

| Complexity   | Action                      | Reason                                    |
| ------------ | --------------------------- | ----------------------------------------- |
| **Simple**   | ✅ AUTO-APPROVE             | Small changes, low risk, easy to rollback |
| **Medium**   | ⏸️ USER REVIEW              | Need approach confirmation before coding  |
| **Complex**  | ⏸️ USER REVIEW + Discussion | Multiple trade-offs, requires discussion  |
| **Critical** | 🛑 MANDATORY REVIEW         | Core impact, mandatory approval           |

### Complexity Evaluation Criteria

**Simple** (Auto-approve):

- Only 1-2 files changed
- No changes to interfaces/contracts
- Pattern already exists in the codebase
- No impact on other modules
- Can be reverted in 1 commit

**Medium** (User Review):

- 3-5 files changed
- New functions/components added but no core changes
- New tests required
- 1-2 integration points

**Complex** (User Review + Discussion):

- More than 5 files changed
- New patterns or abstractions added
- Impact on multiple modules
- Multiple feasible approaches with different trade-offs
- Requires migration or database changes

**Critical** (Mandatory Review):

- Changes to core architecture
- Impact on security or authentication
- Breaking changes for API consumers
- Performance-critical paths
- Irreversible data changes

---

## 🔀 Branching Logic

### Branch A: AUTO-APPROVE (Complexity = Simple)

```markdown
✅ Assessed Complexity: **Simple**
📝 Reason for auto-approval: [Summary from architecture document]

➡️ Automatically moving to Phase 4: Implementation
Call subagent: senior-developer
```

**Action**:

1. Log to `.kira/logs/current-session.log`:
   ```
   [TIMESTAMP] ✅ AUTO-APPROVED: Feature {name} - Complexity: Simple
   [TIMESTAMP] 📋 Reason: {specific reason}
   [TIMESTAMP] ➡️ Proceeding to Implementation Phase
   ```
2. **CONTINUE** to call `senior-developer` subagent

---

### Branch B: USER REVIEW (Complexity = Medium/Complex/Critical)

```markdown
⏸️ **CHECKPOINT: Confirmation needed from you**

📊 Assessed Complexity: **[Medium/Complex/Critical]**

## Plan Summary

### Chosen Approach:

[2-3 sentence summary of the approach]

### Main Changes:

1. [Change 1]
2. [Change 2]
3. [Change 3]

### Main Risks:

- [Risk 1]: [Mitigation]
- [Risk 2]: [Mitigation]

### Estimated Effort: [X hours/days]

---

📄 **Full details**: `.kira/plans/{feature-slug}-architecture.md`

---

## 🎯 What do you want to do next?

1. **Approve** - Agree and continue implementation
2. **Modify** - Request plan adjustment
3. **Reject** - Cancel and return to analysis
4. **Discuss** - Discuss approach further

⏳ _Waiting for your response..._
```

**Action**:

1. Log to `.kira/logs/current-session.log`:
   ```
   [TIMESTAMP] ⏸️ PAUSED: Waiting for user review
   [TIMESTAMP] 📊 Complexity: {level}
   [TIMESTAMP] 📄 Plan: .kira/plans/{feature-slug}-architecture.md
   ```
2. **STOP** and display the above message
3. **WAIT** for user input

---

## 📝 Handling User Response

### Response: "Approve" / "Agree" / "OK" / "Continue"

```markdown
✅ Approval received.
📝 Note: User approved plan at [TIMESTAMP]
➡️ Moving to Phase 4: Implementation
```

**Action**:

- Log approval
- Call `senior-developer` subagent

---

### Response: "Modify" / "Adjust" / "Edit"

```markdown
📝 What would you like to adjust in the plan?

Please describe:

- What needs to be changed?
- Which approach would you like to try instead?
- Are there any specific concerns?
```

**Action**:

- Get user feedback
- Call `solution-architect` again with additional context
- Repeat Decision Gate

---

### Response: "Reject" / "Cancel"

```markdown
🛑 Workflow cancelled.
📝 Note: User rejected plan at [TIMESTAMP]

Do you want to:

1. Start again with a different requirement?
2. Return to Phase 1 for re-analysis?
```

**Action**:

- Log rejection with reason (if any)
- Stop workflow

---

### Response: "Discuss" / "Discussion"

```markdown
💬 What point would you like to discuss?

Some topics for discussion:

1. Compare approach alternatives
2. Details of risks and mitigation
3. Explain technical decisions
4. Trade-offs between options

Please ask your question or state your concern.
```

**Action**:

- Answer questions based on the architecture document
- May call `webSearchPrime` for further research if needed
- After the discussion, ask: "Are you ready to approve?"

---

## ⛔ STOP POINT

> **IMPORTANT**: Workflow STOPS here.
>
> Phase 4 (Implementation) will be triggered separately when:
>
> 1. User approves in the Decision Gate, OR
> 2. User calls the `/implement` command separately

---

## 📁 Output Files

After completing Phases 1-3, the following files will be available:

```
.kira/
├── plans/
│   ├── {feature-slug}-requirements.md      # Phase 1 output
│   ├── {feature-slug}-codebase-analysis.md # Phase 2 output
│   └── {feature-slug}-architecture.md      # Phase 3 output
└── logs/
    └── current-session.log                  # Workflow log
```

---

## 🚀 Start Workflow

Process input: **$ARGUMENTS**

1. Determine input type
2. Create feature-slug from input
3. Start Phase 1 with `requirement-analyst`
