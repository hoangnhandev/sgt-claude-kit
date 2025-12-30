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

### Phase 1: Bug Analysis & Investigation (Unified)

**Subagent**: `bug-handler`

```
Task: Triage bug. If Simple, prepare Quick Fix. If Complex, investigate Root Cause.
Input: Read bug from $ARGUMENTS
Output: Store in memory (bug-analysis OR root-cause-analysis)
Critical:
  - Assess Complexity (Simple/Medium/Complex)
  - If Simple: Stop and return "Ready for Quick Fix"
  - If Complex: Investigate Root Cause and return "Root cause identified"
```

---

### 🚦 DECISION GATE: Workflow Routing

Check the output from `bug-handler`:

1.  **IF "Ready for Quick Fix" (Simple)**:

    - **Route**: 🚀 **QUICK FIX PATH**
    - **Action**: Jump to **Phase 2 (Fix Implementation)** immediately.
    - **Note**: Skip deep investigation and review.

2.  **IF "Root cause identified" (Medium/Complex)**:
    - **Route**: 🧪 **STANDARD PATH**
    - **Action**: Proceed to **Decision Gate: Fix Approval**.

---

### 🚦 DECISION GATE: Fix Approval (For Standard Path)

Check **Complexity** & **Risks**:

- **Medium**: ✅ AUTO-APPROVE → Phase 2
- **Complex/High Risk**: ⏸️ USER REVIEW → Show Root Cause & Options.

---

### Phase 2: Fix Implementation

**Subagent**: `senior-developer`

```
Task: Implement bug fix
Mode: 🐛 BUG FIX MODE
Input: Root cause (Standard) OR Analysis (Quick Fix) from memory
Output: Store fix summary in memory - entities: files_changed, validation_results, fix_description
Critical:
  - If Quick Fix: Use analysis findings directly
  - If Standard: Follow Root Cause fix options
  - Run validation: lint, type-check, build
  - Confirm: "✅ Fix implemented, summary stored in memory"
```

---

### Phase 3: Bug Verification (Optional in QUICK mode)

**Subagent**: `test-engineer`

- **QUICK Mode**: SKIPPED (Senior Developer validation is sufficient)
- **NORMAL/FULL Mode**: REQUIRED

```
Task: Verify bug fix with tests
Mode: 🧪 BUG VERIFICATION
Input: Fix summary & Root cause (memory)
Skills: .claude/skills/testing-strategy/SKILL-SUMMARY.md
Output: Store test results in memory - entities: reproduction_test, regression_results, quality_gate_status
Critical:
  - Create reproduction test that FAILS without fix
  - Verify test PASSES with fix
  - Confirm: "✅ Bug fix verified, results stored in memory"
```

---

### Phase 4: Code Review (Skipped in QUICK/NORMAL mode)

**Subagent**: `code-reviewer`

- **QUICK/NORMAL Mode**: SKIPPED (Self-review by previous agents + Main Agent)
- **FULL Mode**: REQUIRED (For complex/risky changes)

```
Task: Review bug fix for quality and correctness
Mode: 🔍 BUG FIX REVIEW
Input: Fix summary, Verification, Root cause (memory)
Skills: .claude/skills/security-guidelines/SKILL-SUMMARY.md
Output: MUST create .kira/reviews/{bug-id}-review.md using Write tool
Critical:
  - Verify minimal diff principle
  - Verdict: ✅ APPROVED or 🚫 CHANGES REQUESTED
  - Confirm: "✅ Review saved: [path]"
```

---

### Phase 5: Finalization

#### Step 5.1: Git Operations

**Executed by**: Main Agent

1. Stage changes: `git add -A`
2. Commit with conventional format:

   ```bash
   git commit -m "fix({scope}): {description}

   Fixes #{bug-id}
   [Quick Fix / Validated]"
   ```

#### Step 5.2: Output Summary

Generate summary:

- **Status**: ✅ Completed
- **Mode**: {Quick/Normal/Full}
- **Git**: Commit `{hash}`

---

## 📊 Workflow Summary

| Phase             | Agent            | Output  | Check             |
| ----------------- | ---------------- | ------- | ----------------- |
| 1. Analysis/Inv   | bug-handler      | Memory  | Complexity Check  |
| 2. Implementation | senior-developer | Memory  | Lint/Build        |
| 3. Verification   | test-engineer    | Memory  | Reproduction Test |
| 4. Review         | code-reviewer    | File ✅ | Minimal Diff      |
| 5. Finalization   | Main Agent       | Commit  | -                 |

**Key Output**: `.kira/reviews/{bug-id}-review.md`

## ⚠️ Important Rules

- ✅ **DO**: Enforce minimal change principle, require reproduction tests
- ❌ **DON'T**: Allow scope creep, skip verification, approve without review
