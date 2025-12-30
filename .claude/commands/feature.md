---
description: Full feature development workflow - from requirement analysis to implementation and documentation
---

# /feature - Feature Development Workflow

You are the Main Agent coordinating the complete development workflow for new features.

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

### Phase 1: Analysis (⚡ PARALLEL EXECUTION)

**Mode**: Run 2 subagents SIMULTANEOUSLY to reduce duration by ~30%

#### Step 1.1: Parallel Analysis

**Subagent A: `requirement-analyst`** (PARALLEL)

```
Task: Analyze feature requirement and store in memory
Input: Read requirement from $ARGUMENTS
Output: Store using create_entities - key entities: user_stories, functional_requirements, acceptance_criteria, scope
Critical: Store in memory (NOT file), confirm with "✅ Requirements analyzed and stored in memory"
```

**Subagent B: `codebase-scout`** (PARALLEL)

```
Task: Analyze codebase context for feature implementation
Input: Read requirement from $ARGUMENTS
Skills: .claude/skills/project-conventions/SKILL-SUMMARY.md
Output: Store using create_entities - key entities: relevant_files, patterns, dependencies, impact_areas
Critical: Store in memory (NOT file), confirm with "✅ Codebase analyzed and stored in memory"
```

#### Step 1.2: Merge & Validate

**Executed by**: Main Agent

1. Wait for both subagents to complete
2. Validate memory entities exist: `{feature-slug}-requirements` and `{feature-slug}-codebase`
3. Verify scope from requirements aligns with files found
4. Proceed to Phase 2 if both valid

**Summary Display**:

```
⚡ Phase 1 Complete (Parallel Execution)
- requirement-analyst: ✅ (Xm)
- codebase-scout: ✅ (Xm)
- Total time: Xm (vs ~2x if sequential)
```

---

### Phase 2: Planning

#### Step 2.1: Solution Architecture

**Subagent**: `solution-architect`

```
Task: Design solution architecture and create implementation plan
Input: Read from memory - search_nodes for "{feature-slug}-requirements" and "{feature-slug}-codebase"
Skills:
  - .claude/skills/project-conventions/SKILL-SUMMARY.md
  - .claude/skills/frameworks-and-cloud/SKILL-SUMMARY.md
Output: MUST create .kira/plans/{feature-slug}-architecture.md using Write tool
Critical:
  - MUST include "Complexity" field: Simple / Medium / Complex / Critical
  - Confirm: "✅ Architecture saved: [path]"
```

---

### 🚦 DECISION GATE: Auto-Approve vs User Review

Check **Complexity** field from architecture document:

| Complexity   | Criteria                                                         | Action                      |
| ------------ | ---------------------------------------------------------------- | --------------------------- |
| **Simple**   | 1-2 files, no breaking changes, existing patterns                | ✅ AUTO-APPROVE             |
| **Medium**   | 3-5 files, new components, 1-2 integration points                | ⏸️ USER REVIEW              |
| **Complex**  | 5+ files, new patterns, multiple modules affected, DB changes    | ⏸️ USER REVIEW + Discussion |
| **Critical** | Core architecture, security/auth, breaking changes, irreversible | 🛑 MANDATORY REVIEW         |

#### Branch A: AUTO-APPROVE (Simple)

```
✅ Assessed Complexity: Simple
📝 Auto-approval reason: [Summary]
➡️ Moving to Phase 3: Implementation
```

Log to `.kira/logs/current-session.log` and continue to Phase 3.

#### Branch B: USER REVIEW (Medium/Complex/Critical)

```
⏸️ CHECKPOINT: Confirmation needed

Complexity: [Medium/Complex/Critical]

Chosen Approach: [2-3 sentence summary]
Main Changes: [List]
Main Risks: [List with mitigations]
Estimated Effort: [X hours/days]

Full details: .kira/plans/{feature-slug}-architecture.md

Options:
1. Approve - Continue implementation
2. Modify - Request plan adjustment
3. Reject - Cancel workflow
4. Discuss - Discuss approach further

⏳ Waiting for your response...
```

**Response Handling**:

- **Approve/OK/Continue**: Log approval → Continue to Phase 3
- **Modify/Adjust**: Get feedback → Re-call solution-architect → Repeat Decision Gate
- **Reject/Cancel**: Log rejection → Stop workflow
- **Discuss**: Answer questions → Ask "Ready to approve?"

---

## Phase 3: Implementation

### Pre-flight Check

Verify `.kira/plans/{feature-slug}-architecture.md` exists and memory entities accessible.

### Step 3.1: Code Implementation

**Subagent**: `senior-developer`

```
Task: Implement feature according to architecture plan
Input:
  - Architecture: .kira/plans/{feature-slug}-architecture.md
  - Codebase context: search_nodes for "{feature-slug}-codebase"
Skills:
  - .claude/skills/project-conventions/SKILL-SUMMARY.md
  - .claude/skills/frameworks-and-cloud/SKILL-SUMMARY.md
Output: Store implementation summary in memory - entities: files_changed, validation_results, deviations, known_issues
Critical:
  - Follow architecture plan exactly
  - Run validation: lint, type-check, build
  - Confirm: "✅ Implementation complete, summary stored in memory"
```

---

### 🚦 CHECKPOINT: Testing Decision

```
⏸️ CHECKPOINT: Testing Phase

✅ Implementation completed

Do you want to run the Testing phase?
Test Engineer will: write tests, verify coverage >= 80%, report results

Options:
1. Yes/Run Tests - Execute Test Engineer (recommended)
2. Skip/No - Skip to Code Review
3. Manual - I'll write tests myself

⏳ Waiting for your response...
```

**Response Handling**:

- **Yes/Run Tests**: Continue to Step 3.2
- **Skip/No**: Log skip → Create minimal test report with SKIPPED status → Skip to Phase 4
- **Manual**: Wait for user to type "Continue/Done" → Phase 4

---

### Step 3.2: Testing (If Not Skipped)

**Subagent**: `test-engineer`

```
Task: Write and execute tests for implemented feature
Input:
  - Architecture: .kira/plans/{feature-slug}-architecture.md
  - Implementation: search_nodes for "{feature-slug}-implementation"
Skills: .claude/skills/testing-strategy/SKILL-SUMMARY.md
Output: Store test results in memory - entities: test_count, coverage_percentage, failed_tests, quality_gate_status
Critical:
  - Write comprehensive unit tests
  - Achieve minimum 80% coverage
  - Run: npm run test -- --coverage
  - QUALITY GATE: Block if tests fail or coverage < 80%
  - Confirm: "✅ Tests passed, results stored in memory"
```

**Quality Gate**: All tests pass + Coverage >= 80%

**If FAILED**:

1. Increment `test_retry_count` (Max: 3)
2. If count < 3: Show retry message → Loop back to Step 3.1 with fix request
3. If count >= 3:

   ```
   🛑 MAX RETRIES EXCEEDED (3 attempts)

   Options:
   1. Manual Fix - You fix, then we continue
   2. Skip Tests - Proceed with known failures (NOT RECOMMENDED)
   3. Abort - Cancel workflow
   ```

---

## Phase 4: Quality Assurance

### Pre-flight Check

Verify `{feature-slug}-implementation` in memory. Verify `{feature-slug}-test` if testing was run.

### Step 4.1: Code Review

**Subagent**: `code-reviewer`

```
Task: Review code for quality, security, best practices
Input:
  - Architecture: .kira/plans/{feature-slug}-architecture.md
  - Implementation: search_nodes for "{feature-slug}-implementation"
  - Test results: search_nodes for "{feature-slug}-test"
Skills:
  - .claude/skills/security-guidelines/SKILL-SUMMARY.md
  - .claude/skills/project-conventions/SKILL-SUMMARY.md
Output: MUST create .kira/reviews/{feature-slug}-review.md using Write tool
Critical:
  - Review git diff changes
  - Check security (SQL injection, XSS, hardcoded secrets)
  - QUALITY GATE: Block if CRITICAL issues found
  - Include verdict: ✅ APPROVED or 🚫 CHANGES REQUESTED
  - Confirm: "✅ Review saved: [path]"
```

**Quality Gate**: No CRITICAL issues + Security scan clean

**If CRITICAL Issues Found**:

1. Increment `review_retry_count` (Max: 3)
2. If count < 3:

   ```
   🚫 CODE REVIEW BLOCKED (Attempt {count}/3)
   CRITICAL Issues: [List issues with File:Line]
   ```

   Determine fix type → Auto-fix (call senior-developer) OR Manual fix (request user) → Loop to Step 4.1

3. If count >= 3:

   ```
   🛑 MAX RETRIES EXCEEDED

   Options:
   1. Manual Fix - You fix manually, type "Fixed"
   2. Abort - Cancel workflow
   ```

---

## Phase 5: Finalization

### Step 5.1: Documentation

**Subagent**: `documentation-writer`

```
Task: Update documentation for completed feature
Input:
  - Implementation Report: .kira/plans/{feature-slug}-implementation-report.md
  - Test Report: .kira/plans/{feature-slug}-test-report.md
  - Review Report: .kira/reviews/{feature-slug}-review.md
Skills: .claude/skills/git-workflow/SKILL-SUMMARY.md (for CHANGELOG and commits)
Output:
  1. Update project docs (README.md, CHANGELOG.md, etc.)
  2. MUST create .kira/plans/plan-{feature-slug}.md using Write tool
Critical:
  - Update README if new features/APIs added
  - Add CHANGELOG entry (Keep a Changelog format)
  - Add JSDoc/TSDoc for new public APIs
  - Confirm: "✅ Files created: [paths]"
```

---

### Step 5.2: Git Operations

**Executed by**: Main Agent

1. Stage changes: `git add -A`
2. Commit with conventional message: `git commit -m "feat({scope}): {description}"`
3. [GitHub Mode Only] Create PR: `gh pr create --title "feat({scope}): {description}" --body-file .kira/plans/{feature-slug}-pr-description.md`

**Commit Format**: `<type>(<scope>): <description>\n\n<body>\n\nCloses #<issue>`
Types: feat, fix, docs, style, refactor, test, chore

---

### Step 5.3: Output Summary

**Generate session summary**:

```markdown
# Development Session: {Feature Name}

Date: YYYY-MM-DD HH:MM
Status: ✅ Completed

## Workflow Summary

| Phase          | Agent                | Status | Duration | Mode        |
| -------------- | -------------------- | ------ | -------- | ----------- |
| Analysis       | Requirement Analyst  | ✅     | Xm       | ⚡ PARALLEL |
| Analysis       | Codebase Scout       | ✅     | Xm       | ⚡ PARALLEL |
| Planning       | Solution Architect   | ✅     | Xm       | Sequential  |
| Implementation | Senior Developer     | ✅     | Xm       | Sequential  |
| Testing        | Test Engineer        | ✅     | Xm       | Sequential  |
| Review         | Code Reviewer        | ✅     | Xm       | Sequential  |
| Documentation  | Documentation Writer | ✅     | Xm       | Sequential  |

## Artifacts Generated

- .kira/plans/{feature-slug}-architecture.md
- .kira/plans/{feature-slug}-implementation-report.md
- .kira/plans/{feature-slug}-test-report.md
- .kira/reviews/{feature-slug}-review.md
- .kira/plans/plan-{feature-slug}.md

## Git Summary

Commit: {commit-hash} - {commit-message}
Branch: feature/{feature-slug}

## Quality Metrics

| Metric          | Value | Target | Status |
| --------------- | ----- | ------ | ------ |
| Test Coverage   | X%    | 80%    | ✅     |
| Critical Issues | 0     | 0      | ✅     |
| Documentation   | Done  | Done   | ✅     |
```

---

## 🎉 Workflow Complete

Display final summary:

```markdown
## ✅ Feature Development Complete!

### 📊 Summary

All phases completed: Analysis ✅ | Planning ✅ | Implementation ✅ | Testing ✅ | Review ✅ | Documentation ✅

### 📁 Generated Files

- Plan: .kira/plans/plan-{feature-slug}.md
- Review: .kira/reviews/{feature-slug}-review.md
- Session Log: .kira/logs/session-{timestamp}.md

### 🔗 Git

- Commit: {commit-hash}
- Branch: feature/{feature-slug}
- [GitHub Mode] PR: #{pr-number}

### 🎯 Next Steps

1. Review generated documentation
2. [GitHub Mode] Merge PR when ready
3. [Local Mode] Push: git push origin feature/{feature-slug}
```

---

## 🚀 Start Workflow

Process input: **$ARGUMENTS**

1. Determine input type (GitHub Issue / Local File / Inline Text)
2. Create feature-slug from input
3. ⚡ Start Phase 1 PARALLEL execution:
   - Launch `requirement-analyst` with $ARGUMENTS
   - Launch `codebase-scout` with $ARGUMENTS (simultaneously)
4. Wait for both to complete
5. Validate & merge results (Step 1.2)
6. Continue through remaining phases until completion
