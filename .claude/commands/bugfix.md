---
description: Full bug fix workflow - from bug analysis to fix verification and documentation
---

# /bugfix - Bug Fix Workflow

You are the Main Agent coordinating the complete bug fix workflow from analysis to verification.

---

## 📥 Input Detection

Analyze `$ARGUMENTS` to determine input type:

| Pattern                           | Input Type   | Example                                  |
| --------------------------------- | ------------ | ---------------------------------------- |
| `#[0-9]+`                         | GitHub Issue | `#456`                                   |
| `http(s)://...`                   | GitHub URL   | `https://github.com/org/repo/issues/456` |
| `.kira/inputs/*.md` or path `.md` | Local File   | `.kira/inputs/bug-login-error.md`        |
| Plain Text                        | Inline Bug   | "Login fails with error 500"             |

---

## 🔄 Execution Flow

### Phase 1: Bug Triage & Analysis

#### Step 1.1: Bug Analysis

**Subagent**: `bug-analyst`

**Steps**:

1. Parse bug report from input
2. Extract reproduction steps
3. Classify severity (Critical/High/Medium/Low)
4. Identify affected components
5. Assess customer impact
6. **Store analysis in memory** (not file)

**Subagent Task**:

```
🎯 TASK: Analyze the bug report and store analysis in memory.

📄 INPUT: Read and analyze the bug from: $ARGUMENTS

📁 OUTPUT: Store in memory using create_entities
Key entities: bug_info, severity, reproduction_steps, affected_components

⚠️ CRITICAL INSTRUCTIONS:
1. Store findings in memory, NOT as markdown file
2. MUST include severity classification with justification
3. MUST include reproduction steps
4. After storing, confirm: "✅ Bug analyzed, severity: {level}, stored in memory"

🔍 SEVERITY MATRIX:
- 🔴 Critical (P0): System unusable, data loss, security breach
- 🟠 High (P1): Major feature broken, no workaround
- 🟡 Medium (P2): Feature impacted, workaround exists
- 🟢 Low (P3): Minor issue, cosmetic, edge case
```

**🪝 Hook**: Log checkpoint after analysis completion.

---

### 🚦 DECISION GATE 1: Severity-Based Routing

> ⚠️ **CRITICAL**: This is a mandatory checkpoint after Phase 1.

After `bug-analyst` completes, check the **Severity** field:

| Severity        | Mode     | Action                            |
| --------------- | -------- | --------------------------------- |
| 🔴 **Critical** | HOTFIX   | Auto-approve Phase 2, fast-track  |
| 🟠 **High**     | PRIORITY | User review at Phase 2 checkpoint |
| 🟡 **Medium**   | NORMAL   | Standard workflow                 |
| 🟢 **Low**      | BACKLOG  | User can choose to defer          |

#### Branch: HOTFIX Mode (Critical Severity)

```markdown
🔴 **HOTFIX MODE ACTIVATED**

**Severity**: Critical (P0)
**Reason**: {reason from analysis}

⚡ Fast-tracking bug fix process:

- Auto-approving investigation phase
- Skipping non-essential steps
- Priority: IMMEDIATE

➡️ Automatically proceeding to Phase 2: Root Cause Investigation
```

**Action**: Auto-continue to Phase 2.

---

#### Branch: PRIORITY Mode (High Severity)

```markdown
🟠 **PRIORITY MODE**

**Severity**: High (P1)
**Reason**: {reason from analysis}

📄 **Analysis Summary**:

- **Bug**: {title}
- **Impact**: {customer impact}
- **Components**: {affected components}

📄 **Full Analysis**: `.kira/bugs/{bug-id}-analysis.md`

## 🎯 Options:

1. **Continue** - Proceed to root cause investigation
2. **Discuss** - Need more context before proceeding

⏳ _Waiting for your response..._
```

**Action**: Wait for user confirmation.

---

#### Branch: NORMAL Mode (Medium Severity)

```markdown
🟡 **NORMAL MODE**

**Severity**: Medium (P2)
**Reason**: {reason from analysis}

📄 **Analysis Complete**: `.kira/bugs/{bug-id}-analysis.md`

## 🎯 Options:

1. **Continue** - Proceed to root cause investigation
2. **Defer** - Add to backlog for later
3. **Discuss** - Need more context

⏳ _Waiting for your response..._
```

**Action**: Wait for user confirmation.

---

#### Branch: BACKLOG Mode (Low Severity)

```markdown
🟢 **BACKLOG MODE**

**Severity**: Low (P3)
**Reason**: {reason from analysis}

📄 **Analysis Complete**: `.kira/bugs/{bug-id}-analysis.md`

This low-priority bug can be:

- Batched with feature work
- Scheduled for next sprint
- Fixed when touching related code

## 🎯 Options:

1. **Continue Anyway** - Proceed to fix now
2. **Defer** - Add to backlog
3. **Auto-fix Later** - Tag for opportunistic fix

⏳ _Waiting for your response..._
```

**Action**: Wait for user confirmation.

---

### Phase 2: Root Cause Investigation

#### Step 2.1: Root Cause Analysis

**Subagent**: `bug-investigator`

**Steps**:

1. Read analysis from Phase 1
2. Trace execution path
3. Identify root cause
4. Propose fix options (2+)
5. Assess regression risks
6. Estimate fix complexity
7. **Store root cause in memory** (not file)

**Subagent Task**:

```
🎯 TASK: Investigate the bug and identify root cause with fix options.

📄 INPUT (from memory):
- Bug Analysis: search_nodes for "{bug-id}-analysis"

📚 SKILLS:
- Read `.claude/skills/project-conventions/SKILL-SUMMARY.md`

📁 OUTPUT: Store in memory using create_entities
Key entities: root_cause, fix_options, regression_risks, recommended_approach, complexity

⚠️ CRITICAL INSTRUCTIONS:
1. Trace execution path from user action to bug
2. Provide at least 2 fix options with trade-offs
3. Assess complexity: Simple / Medium / Complex
4. Recommend one option clearly
5. After storing, confirm: "✅ Root cause identified, complexity: {level}, stored in memory"
```

**🪝 Hook**: Log checkpoint after investigation.

---

### 🚦 DECISION GATE 2: Fix Complexity Review

> ⚠️ **CHECKPOINT**: Review fix complexity before implementation.

After `bug-investigator` completes, check **Complexity** field:

| Complexity  | Action                      | Reason                       |
| ----------- | --------------------------- | ---------------------------- |
| **Simple**  | ✅ AUTO-APPROVE             | Low risk, straightforward    |
| **Medium**  | ⏸️ USER REVIEW              | Need approach confirmation   |
| **Complex** | ⏸️ USER REVIEW + Discussion | Multiple trade-offs, discuss |

#### Branch: AUTO-APPROVE (Simple Complexity)

```markdown
✅ **Fix Complexity: Simple**

**Root Cause**: {summary}
**Recommended Fix**: Option {X} - {name}
**Files to Change**: {count}
**Risk Level**: Low

➡️ Automatically proceeding to Phase 3: Fix Implementation
```

**Action**: Continue to Phase 3.

---

#### Branch: USER REVIEW (Medium/Complex)

```markdown
⏸️ **CHECKPOINT: Fix Approach Review**

📊 **Complexity**: {Medium/Complex}

## Root Cause Summary

**Location**: `{file}:{line}`
**Cause**: {brief description}

## Recommended Fix: Option {X}

**Approach**: {description}
**Files**: {count} files
**Risk**: {level}
**Effort**: {estimate}

## Alternative: Option {Y}

**Approach**: {description}
**Trade-off**: {pros/cons}

---

📄 **Full Analysis**: `.kira/bugs/{bug-id}-root-cause.md`

## 🎯 Options:

1. **Approve Option X** - Proceed with recommended fix
2. **Approve Option Y** - Use alternative approach
3. **Discuss** - Need to understand trade-offs better

⏳ _Waiting for your response..._
```

**Action**: Wait for user selection.

---

### Phase 3: Fix Implementation

#### Step 3.1: Implement Fix

**Subagent**: `senior-developer`

**Special Instructions for Bug Fix Mode**:

1. **Minimal Change Principle** - Only fix the bug, no refactoring
2. **No Scope Creep** - Resist "while I'm here" changes
3. **Document Fix** - Add inline comment explaining fix
4. **Focus on Root Cause** - Address cause, not symptoms

**Subagent Task**:

```
🎯 TASK: Implement the bug fix according to the root cause analysis.

🐛 BUG FIX MODE - Special rules:
1. MINIMAL CHANGES ONLY - Fix the bug, nothing more
2. NO REFACTORING - Save improvements for later
3. ADD COMMENT - // Fix for bug {bug-id}: {description}

📄 INPUT (from memory):
- Root cause: search_nodes for "{bug-id}-root-cause"
- Bug info: search_nodes for "{bug-id}-analysis"

📁 OUTPUT: Store fix summary in memory
Key entities: files_changed, validation_results, fix_description

⚠️ CRITICAL INSTRUCTIONS:
1. Follow the recommended fix option EXACTLY
2. Make MINIMAL changes to fix the bug
3. Run validation: lint, type-check, build
4. After storing, confirm: "✅ Fix implemented, summary stored in memory"
```

**🪝 Hook**: Run lint and type-check after implementation.

---

### Phase 4: Bug Verification

#### Step 4.1: Create & Run Verification Tests

**Subagent**: `test-engineer`

**Special Instructions for Bug Verification**:

1. **Reproduction Test First** - Create test that FAILS without fix
2. **Verify Fix Works** - Same test must PASS after fix
3. **Regression Tests** - Run full test suite
4. **Edge Cases** - Test related edge cases

**Subagent Task**:

```
🎯 TASK: Verify the bug fix with tests.

🧪 BUG VERIFICATION MODE:
1. REPRODUCTION TEST - Must fail without fix, pass with fix
2. EDGE CASES - Test related boundary conditions
3. REGRESSION CHECK - Run full test suite

📄 INPUT (from memory):
- Fix summary: search_nodes for "{bug-id}-fix"
- Root cause: search_nodes for "{bug-id}-root-cause"

📚 SKILLS:
- Read `.claude/skills/testing-strategy/SKILL-SUMMARY.md`

📁 OUTPUT: Store test results in memory
Key entities: reproduction_test, regression_results, quality_gate_status, verdict

⚠️ CRITICAL INSTRUCTIONS:
1. Write reproduction test that captures the bug
2. Verify test passes with fix
3. Run full test suite for regressions
4. After storing, confirm: "✅ Bug fix verified, results stored in memory"
```

**Quality Gate**: Block if reproduction test doesn't pass or regressions found.

---

### Phase 5: Code Review

#### Step 5.1: Bug Fix Review

**Subagent**: `code-reviewer`

**Special Instructions for Bug Fix Review**:

1. **Minimal Diff Check** - Verify only bug-related changes
2. **No Unrelated Changes** - Flag any scope creep
3. **Root Cause Addressed** - Verify fix addresses cause, not symptoms
4. **Regression Risks Mitigated** - Check risk areas from investigation

**Subagent Task**:

```
🎯 TASK: Review the bug fix for quality and correctness.

🔍 BUG FIX REVIEW MODE:
1. MINIMAL DIFF - Only bug-related changes
2. ROOT CAUSE FIXED - Not just symptoms
3. NO SCOPE CREEP - No unrelated changes

📄 INPUT (from memory):
- Fix summary: search_nodes for "{bug-id}-fix"
- Verification: search_nodes for "{bug-id}-verification"
- Root cause: search_nodes for "{bug-id}-root-cause"

📚 SKILLS:
- Read `.claude/skills/security-guidelines/SKILL-SUMMARY.md`

📁 OUTPUT FILE (MANDATORY - key deliverable):
You MUST create: .kira/reviews/{bug-id}-review.md

⚠️ CRITICAL INSTRUCTIONS:
1. Review git diff for changes
2. Verify minimal diff principle followed
3. Check for security issues in fix
4. Include verdict: ✅ APPROVED or 🚫 CHANGES REQUESTED
5. Confirm: "✅ Review saved: [path]"
```

**Quality Gate Check**:

```markdown
## 🚦 Review Quality Gate

| Check                 | Result | Action         |
| --------------------- | ------ | -------------- |
| No CRITICAL issues    | ✅/❌  | Continue/BLOCK |
| Minimal diff verified | ✅/❌  | Continue/WARN  |
| Root cause addressed  | ✅/❌  | Continue/BLOCK |
| Security scan clean   | ✅/❌  | Continue/BLOCK |
```

---

### Phase 6: Finalization

#### Step 6.1: Documentation Update

**Optional**: Update relevant documentation if needed.

#### Step 6.2: Git Operations

**Executed by**: Main Agent

**Steps**:

1. Stage all changes:

   ```bash
   git add -A
   ```

2. Commit with conventional format:

   ```bash
   git commit -m "fix({scope}): {description}

   Fixes #{bug-id}

   - Root cause: {brief root cause}
   - Fix: {brief fix description}"
   ```

3. Generate final summary.

---

## 📊 Workflow Summary

### Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    /bugfix WORKFLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Phase 1: Bug Triage & Analysis                             │
│  └── bug-analyst → Memory                                   │
│  └── 🚦 Decision Gate: Severity Routing                     │
│                                                              │
│  Phase 2: Root Cause Investigation                          │
│  └── bug-investigator → Memory                              │
│  └── 🚦 Decision Gate: Fix Complexity                       │
│                                                              │
│  Phase 3: Fix Implementation                                │
│  └── senior-developer → Memory                              │
│                                                              │
│  Phase 4: Verification                                      │
│  └── test-engineer → Memory                                 │
│  └── 🚦 Quality Gate: Test Verification                     │
│                                                              │
│  Phase 5: Review                                            │
│  └── code-reviewer → .kira/reviews/{bug-id}-review.md ✅    │
│  └── 🚦 Quality Gate: Code Review                           │
│                                                              │
│  Phase 6: Finalization                                      │
│  └── Git commit with fix                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Output Summary

| Phase | Agent            | Output      |
| ----- | ---------------- | ----------- |
| 1     | bug-analyst      | Memory      |
| 2     | bug-investigator | Memory      |
| 3     | senior-developer | Memory      |
| 4     | test-engineer    | Memory      |
| 5     | code-reviewer    | **File** ✅ |

**Key Output File**: `.kira/reviews/{bug-id}-review.md` (final verdict)

---

## ⚠️ Important Rules

### DO:

1. ✅ Follow severity-based routing
2. ✅ Enforce minimal change principle
3. ✅ Require reproduction tests
4. ✅ Block on quality gate failures
5. ✅ Document all decisions

### DON'T:

1. ❌ Skip phases for non-Critical bugs
2. ❌ Allow scope creep during fixes
3. ❌ Skip verification tests
4. ❌ Approve without review
5. ❌ Commit without proper message

---

_Remember: A well-documented bug fix prevents the same bug from recurring and helps the team learn from issues._
