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

**Subagent**: `bug-analyst`

```
Task: Analyze bug report and store in memory
Input: Read bug from $ARGUMENTS
Output: Store using create_entities - entities: bug_info, severity, reproduction_steps, affected_components
Critical:
  - Store in memory (NOT file)
  - MUST include severity classification (P0-P3) with justification
  - MUST include reproduction steps
  - Confirm: "✅ Bug analyzed, severity: {level}, stored in memory"
```

**Severity Matrix**: 🔴 Critical (P0) | 🟠 High (P1) | 🟡 Medium (P2) | 🟢 Low (P3)

---

### 🚦 DECISION GATE: Severity Routing

Check **Severity** field:

| Severity        | Mode     | Action                                                |
| --------------- | -------- | ----------------------------------------------------- |
| 🔴 **Critical** | HOTFIX   | Auto-approve Phase 2, fast-track, skip non-essentials |
| 🟠 **High**     | PRIORITY | Checkpoint before Phase 2                             |
| 🟡 **Medium**   | NORMAL   | Standard workflow, option to defer                    |
| 🟢 **Low**      | BACKLOG  | Batched/deferred fix, valid to stop here              |

**Routing Logic**:

1. **Critical**: Log "🔴 HOTFIX MODE ACTIVATED" → Auto-continue to Phase 2
2. **High/Medium**: Log details → Ask user (Continue / Discuss / Defer)
3. **Low**: Log details → Ask user (Continue / Defer / Auto-fix Later)

---

### Phase 2: Root Cause Investigation

**Subagent**: `bug-investigator`

```
Task: Investigate bug, identify root cause and fix options
Input: Bug Analysis (memory)
Skills: .claude/skills/project-conventions/SKILL-SUMMARY.md
Output: Store in memory - entities: root_cause, fix_options, regression_risks, recommended_approach, complexity
Critical:
  - Trace execution path
  - Provide 2+ fix options with trade-offs
  - Assess complexity: Simple / Medium / Complex
  - Confirm: "✅ Root cause identified, complexity: {level}, stored in memory"
```

### 🚦 DECISION GATE: Fix Complexity Review

Check **Complexity** field:

- **Simple**: ✅ AUTO-APPROVE → Phase 3
- **Medium/Complex**: ⏸️ USER REVIEW → Show Root Cause, Fix Options, Risks

**User Review Options**:

1. **Approve Option X** → Phase 3 with Option X
2. **Approve Option Y** → Phase 3 with Option Y
3. **Discuss** → Discuss trade-offs

---

### Phase 3: Fix Implementation

**Subagent**: `senior-developer`

```
Task: Implement bug fix according to root cause analysis
Mode: 🐛 BUG FIX MODE (Minimal Changes Only, No Refactoring)
Input: Root cause & Bug info (memory)
Output: Store fix summary in memory - entities: files_changed, validation_results, fix_description
Critical:
  - Follow recommended fix EXACTLY
  - MINIMAL changes to fix the bug (No scope creep)
  - Add comment: // Fix for bug {bug-id}: {description}
  - Run validation: lint, type-check, build
  - Confirm: "✅ Fix implemented, summary stored in memory"
```

---

### Phase 4: Bug Verification

**Subagent**: `test-engineer`

```
Task: Verify bug fix with tests
Mode: 🧪 BUG VERIFICATION (Reproduction -> Fix Verify -> Regression)
Input: Fix summary & Root cause (memory)
Skills: .claude/skills/testing-strategy/SKILL-SUMMARY.md
Output: Store test results in memory - entities: reproduction_test, regression_results, quality_gate_status
Critical:
  - Create reproduction test that FAILS without fix
  - Verify test PASSES with fix
  - Run full test suite for regression check
  - Confirm: "✅ Bug fix verified, results stored in memory"
```

**Quality Gate**: Block if Reproduction Test fails OR Regressions found.

---

### Phase 5: Code Review

**Subagent**: `code-reviewer`

```
Task: Review bug fix for quality and correctness
Mode: 🔍 BUG FIX REVIEW (Minimal Diff, Root Cause Fixed)
Input: Fix summary, Verification, Root cause (memory)
Skills: .claude/skills/security-guidelines/SKILL-SUMMARY.md
Output: MUST create .kira/reviews/{bug-id}-review.md using Write tool
Critical:
  - Verify minimal diff principle
  - Verify root cause addressed (not just symptoms)
  - Check security
  - Verdict: ✅ APPROVED or 🚫 CHANGES REQUESTED
  - Confirm: "✅ Review saved: [path]"
```

**Quality Gate**: No CRITICAL issues + Minimal diff verified + Root cause addressed.

---

### Phase 6: Finalization

#### Step 6.1: Git Operations

**Executed by**: Main Agent

1. Stage changes: `git add -A`
2. Commit with conventional format:

   ```bash
   git commit -m "fix({scope}): {description}

   Fixes #{bug-id}
   - Root cause: {brief root cause}
   - Fix: {brief fix description}"
   ```

#### Step 6.2: Output Summary

Generate summary:

- **Status**: ✅ Completed
- **Files**: `.kira/reviews/{bug-id}-review.md`
- **Git**: Commit `{hash}` (Fixes #{bug-id})

---

## 📊 Workflow Summary

| Phase             | Agent            | Output  | Check             |
| ----------------- | ---------------- | ------- | ----------------- |
| 1. Analysis       | bug-analyst      | Memory  | Severity Check    |
| 2. Investigation  | bug-investigator | Memory  | Complexity Check  |
| 3. Implementation | senior-developer | Memory  | Lint/Build        |
| 4. Verification   | test-engineer    | Memory  | Reproduction Test |
| 5. Review         | code-reviewer    | File ✅ | Minimal Diff      |
| 6. Finalization   | Main Agent       | Commit  | -                 |

**Key Output**: `.kira/reviews/{bug-id}-review.md`

## ⚠️ Important Rules

- ✅ **DO**: Enforce minimal change principle, require reproduction tests
- ❌ **DON'T**: Allow scope creep, skip verification, approve without review
