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

> **🚀 PERFORMANCE OPTIMIZATION**: Phase 1 runs 2 subagents **SIMULTANEOUSLY** to reduce duration by ~30%.

#### Step 1.1: Parallel Analysis (Requirement + Codebase)

**Mode**: ⚡ **PARALLEL EXECUTION**

**Simultaneous Subagents**:
| Subagent | Task | Output File |
|----------|------|-------------|
| `requirement-analyst` | Requirement Analysis | `{feature-slug}-requirements.md` |
| `codebase-scout` | Codebase Exploration | `{feature-slug}-codebase-analysis.md` |

---

##### 🔀 Subagent A: Requirement Analyst (PARALLEL)

**Subagent**: `requirement-analyst`

**Steps**:

1. Read and analyze input requirement
2. Extract user stories, acceptance criteria
3. Identify scope and constraints
4. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Analyze the feature requirement and create a requirements document.

⚡ MODE: Running in PARALLEL with codebase-scout

📄 INPUT: Read and analyze the requirement from: $ARGUMENTS

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-requirements.md

⚠️ CRITICAL INSTRUCTIONS:
1. You MUST call `Write` tool to create the output file
2. DO NOT just output markdown content as a response
3. Your task is NOT complete until the file is created
4. After creating the file, confirm: "✅ File created: [path]"
5. ⚡ NOTE: codebase-scout is running simultaneously - no need to wait
```

---

##### 🔀 Subagent B: Codebase Scout (PARALLEL)

**Subagent**: `codebase-scout`

**Steps**:

1. Explore codebase to understand context
2. Find relevant files and patterns
3. Assess impact
4. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Analyze the codebase to understand context for the feature implementation.

⚡ MODE: Running in PARALLEL with requirement-analyst

📄 INPUT:
- Read the requirement from: $ARGUMENTS (same input as requirement-analyst)
- Focus on: Finding relevant files, patterns, and impact areas

📚 SKILLS FOR CODEBASE-SCOUT ROLE:
- Read `.claude/skills/project-conventions/SKILL-SUMMARY.md` - Understand naming/structure conventions

💡 NOTE: This role focuses on exploration, not implementation. Framework details not needed.

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-codebase-analysis.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE analyzing
2. You MUST call `Write` tool to create the output file
3. DO NOT just output markdown content as a response
4. Your task is NOT complete until the file is created
5. After creating the file, confirm: "✅ File created: [path]"
6. ⚡ NOTE: requirement-analyst is running simultaneously - no need to wait
```

---

#### Step 1.2: Merge & Validate Results

**Executed by**: Main Agent

**Steps**:

1. **Wait for both subagents** to complete
2. **Validate outputs exist**:
   - Check: `.kira/plans/{feature-slug}-requirements.md`
   - Check: `.kira/plans/{feature-slug}-codebase-analysis.md`
3. **Quick cross-reference**:
   - Verify scope from requirements aligns with files found by scout
   - Flag any conflicts or gaps
4. **Proceed to Phase 2** if both valid

**Validation Check**:

```markdown
## 🔍 Phase 1 Parallel Execution Summary

| Subagent            | Status | Output File | Duration |
| ------------------- | ------ | ----------- | -------- |
| requirement-analyst | ✅/❌  | {path}      | Xm       |
| codebase-scout      | ✅/❌  | {path}      | Xm       |

**Total Phase 1 Time**: Xm (vs ~2x if sequential)

### Cross-Reference Check:

- [ ] Scope matches relevant files found
- [ ] No conflicting assumptions
- [ ] Ready for Phase 2
```

**🪝 Hook**: Log checkpoint after Phase 1 completion.

---

### Phase 2: Planning

#### Step 2.1: Solution Architecture

**Subagent**: `solution-architect`

**Steps**:

1. Design technical solution
2. Evaluate different approaches
3. Create detailed implementation plan
4. Assess **Complexity**: Simple / Medium / Complex / Critical
5. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Design the solution architecture and create an implementation plan.

📄 INPUT:
- Requirements: .kira/plans/{feature-slug}-requirements.md
- Codebase Analysis: .kira/plans/{feature-slug}-codebase-analysis.md

📚 SKILLS FOR SOLUTION-ARCHITECT ROLE:
- Read `.claude/skills/project-conventions/SKILL-SUMMARY.md` - Architecture aligns with standards
- Read `.claude/skills/frameworks-and-cloud/SKILL-SUMMARY.md` - Framework best practices

📖 FULL REFERENCE (read framework section matching your tech stack):
- `.claude/skills/frameworks-and-cloud/SKILL.md` → Laravel/Java/Next.js/Node.js/AWS section

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-architecture.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE designing
2. You MUST call `Write` tool to create the output file
3. DO NOT just output markdown content as a response
4. Your task is NOT complete until the file is created
5. MUST include "Complexity" field: Simple / Medium / Complex / Critical
6. After creating the file, confirm: "✅ File created: [path]"
```

**🪝 Hook**: Notify user about plan completion.

---

### 🚦 DECISION GATE: Auto-Approve vs User Review

> ⚠️ **CRITICAL**: This is a mandatory checkpoint after Phase 2.

#### Classification Rules

After `solution-architect` completes, check the **Complexity** field in the output:

| Complexity   | Action                      | Reason                                    |
| ------------ | --------------------------- | ----------------------------------------- |
| **Simple**   | ✅ AUTO-APPROVE             | Small changes, low risk, easy to rollback |
| **Medium**   | ⏸️ USER REVIEW              | Need approach confirmation before coding  |
| **Complex**  | ⏸️ USER REVIEW + Discussion | Multiple trade-offs, requires discussion  |
| **Critical** | 🛑 MANDATORY REVIEW         | Core impact, mandatory approval           |

#### Complexity Evaluation Criteria

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

### 🔀 Branching Logic

#### Branch A: AUTO-APPROVE (Complexity = Simple)

```markdown
✅ Assessed Complexity: **Simple**
📝 Reason for auto-approval: [Summary from architecture document]

➡️ Automatically moving to Phase 3: Implementation
```

**Action**:

1. Log to `.kira/logs/current-session.log`:
   ```
   [TIMESTAMP] ✅ AUTO-APPROVED: Feature {name} - Complexity: Simple
   [TIMESTAMP] 📋 Reason: {specific reason}
   [TIMESTAMP] ➡️ Proceeding to Implementation Phase
   ```
2. **CONTINUE** to Phase 3: Implementation

---

#### Branch B: USER REVIEW (Complexity = Medium/Complex/Critical)

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

### 📝 Handling User Response

#### Response: "Approve" / "Agree" / "OK" / "Continue"

```markdown
✅ Approval received.
📝 Note: User approved plan at [TIMESTAMP]
➡️ Moving to Phase 3: Implementation
```

**Action**:

- Log approval
- Continue to Phase 3: Implementation

---

#### Response: "Modify" / "Adjust" / "Edit"

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

#### Response: "Reject" / "Cancel"

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

#### Response: "Discuss" / "Discussion"

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

## Phase 3: Implementation

### Step 3.1: Code Implementation

**Subagent**: `senior-developer`

**Steps**:

1. Read and follow the architecture plan
2. Implement code changes step by step
3. Apply project conventions via Skills
4. Handle errors and edge cases
5. Run self-validation (lint, type-check, build)
6. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Implement the feature according to the architecture plan.

📄 INPUT:
- Architecture Plan: .kira/plans/{feature-slug}-architecture.md
- Codebase Analysis: .kira/plans/{feature-slug}-codebase-analysis.md

📚 SKILLS FOR SENIOR-DEVELOPER ROLE:
- Read `.claude/skills/project-conventions/SKILL-SUMMARY.md` - Naming, formatting, code patterns
- Read `.claude/skills/frameworks-and-cloud/SKILL-SUMMARY.md` - Framework-specific patterns

📖 FULL REFERENCE (read only the sections you need):
- `.claude/skills/project-conventions/SKILL.md` → If unclear on TypeScript/React patterns
- `.claude/skills/frameworks-and-cloud/SKILL.md` → Only your framework section

💡 NOTE: git-workflow and testing-strategy NOT needed for implementation. Focus on CODE.

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-implementation-report.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE implementing
2. Follow the architecture plan exactly
3. Run validation commands after implementation (lint, type-check, build)
4. You MUST call `Write` tool to create the output file
5. After creating the file, confirm: "✅ File created: [path]"
```

**🪝 Hook**: Auto-format code after each file. Run linter after implementation.

---

### 🚦 CHECKPOINT: Testing Decision

> ⚠️ **CHECKPOINT**: After implementation, ask user about testing.

Display to user:

```markdown
⏸️ **CHECKPOINT: Testing Phase**

✅ Implementation completed by Senior Developer.

## 🧪 Do you want to run the Testing phase?

The Test Engineer will:

- Write unit tests for new code
- Write integration tests if needed
- Verify code coverage >= 80%
- Report test results

---

## 🎯 Options:

1. **Yes / Run Tests** - Execute Test Engineer (recommended)
2. **Skip / No** - Skip testing and go directly to Code Review
3. **Manual** - I will write tests myself, then continue

⏳ _Waiting for your response..._
```

**Action**:

1. Log to `.kira/logs/current-session.log`:
   ```
   [TIMESTAMP] ⏸️ CHECKPOINT: Waiting for testing decision
   [TIMESTAMP] 📄 Implementation: .kira/plans/{feature-slug}-implementation-report.md
   ```
2. **STOP** and display the above message
3. **WAIT** for user input

---

### 📝 Handling Testing Decision

#### Response: "Yes" / "Run Tests" / "Test" / "OK"

```markdown
✅ Running Test Engineer...
➡️ Proceeding to Step 3.2: Testing
```

**Action**: Continue to Step 3.2 (Test Engineer)

---

#### Response: "Skip" / "No" / "Skip Tests"

```markdown
⏭️ Skipping Testing phase.
📝 Note: Tests skipped by user at [TIMESTAMP]
⚠️ Warning: Code will be reviewed without automated test verification.
➡️ Moving directly to Phase 4: Code Review
```

**Action**:

- Log skip decision
- Create minimal test report noting tests were skipped:

  ```markdown
  # Test Report: {Feature Name}

  **Status**: ⏭️ SKIPPED BY USER
  **Date**: [TIMESTAMP]
  **Reason**: User chose to skip automated testing

  ## Note

  Code review will proceed without automated test verification.
  ```

- Save to `.kira/plans/{feature-slug}-test-report.md`
- **SKIP** to Phase 4: Code Review

---

#### Response: "Manual" / "I'll write tests"

```markdown
📝 Manual testing selected.

Please write your tests and let me know when you're ready to continue.

When done, type: **"Continue"** or **"Done"**
```

**Action**:

- Wait for user to complete manual testing
- When user confirms, continue to Phase 4: Code Review

---

### Step 3.2: Testing (If Not Skipped)

**Subagent**: `test-engineer`

**Steps**:

1. Analyze implementation changes
2. Write unit tests for new code
3. Write integration tests if needed
4. Run test suite and verify coverage
5. **🚨 Quality Gate**: Block if tests fail or coverage < 80%
6. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Write and execute tests for the implemented feature.

📄 INPUT:
- Implementation Report: .kira/plans/{feature-slug}-implementation-report.md
- Architecture Plan: .kira/plans/{feature-slug}-architecture.md

📚 SKILLS FOR TEST-ENGINEER ROLE:
- Read `.claude/skills/testing-strategy/SKILL-SUMMARY.md` - AAA pattern, coverage targets, test naming

📖 FULL REFERENCE (read if writing E2E tests):
- `.claude/skills/testing-strategy/SKILL.md` → Detailed mocking, edge cases
- `.claude/skills/e2e-testing/SKILL.md` → Only if E2E tests needed

💡 NOTE: project-conventions and frameworks NOT primary focus. Testing patterns are priority.

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/plans/{feature-slug}-test-report.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE writing tests
2. Write comprehensive unit tests for all new code
3. Achieve minimum 80% code coverage
4. Test both happy paths and error cases
5. Run test suite with coverage: npm run test -- --coverage
6. QUALITY GATE: If tests fail or coverage < 80%, report and BLOCK workflow
7. You MUST call `Write` tool to create the output file
8. After creating the file, confirm: "✅ File created: [path]"
```

**🪝 Hook**: Block workflow if tests fail.

**Quality Gate Check**:

```markdown
## 🚦 Test Quality Gate

| Check           | Result | Action         |
| --------------- | ------ | -------------- |
| All tests pass  | ✅/❌  | Continue/BLOCK |
| Coverage >= 80% | ✅/❌  | Continue/BLOCK |
```

If Quality Gate **FAILED**:

```markdown
🚫 **QUALITY GATE BLOCKED**

**Reason**: [Tests failing / Coverage insufficient]

**Action Required**:

- Senior Developer must fix issues
- Re-run tests after fixes

**Next Step**: Loop back to Step 3.1 with fix request
```

---

## Phase 4: Quality Assurance

### Step 4.1: Code Review

**Subagent**: `code-reviewer`

**Steps**:

1. Review all code changes (git diff)
2. Check security vulnerabilities
3. Verify best practices compliance
4. Check performance issues
5. Classify issues: CRITICAL / WARNING / INFO
6. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Review the implemented code for quality, security, and best practices.

📄 INPUT:
- Implementation Report: .kira/plans/{feature-slug}-implementation-report.md
- Test Report: .kira/plans/{feature-slug}-test-report.md
- Architecture Plan: .kira/plans/{feature-slug}-architecture.md

📚 SKILLS FOR CODE-REVIEWER ROLE:
- Read `.claude/skills/security-guidelines/SKILL-SUMMARY.md` - Security best practices (PRIORITY)
- Read `.claude/skills/project-conventions/SKILL-SUMMARY.md` - Verify code follows conventions

📖 FULL REFERENCE (for detailed security checks):
- `.claude/skills/security-guidelines/SKILL.md` → Full security grep patterns

💡 NOTE: Focus on SECURITY first, then conventions. Testing-strategy only if reviewing test quality.

📁 OUTPUT FILE (MANDATORY):
You MUST use the `Write` tool to create: .kira/reviews/{feature-slug}-review.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE reviewing
2. Review all code changes using git diff
3. Check for security vulnerabilities (SQL injection, XSS, hardcoded secrets, etc.)
4. Verify best practices compliance against loaded skills
5. Classify issues: 🔴 CRITICAL / 🟡 WARNING / 🔵 INFO
6. QUALITY GATE: If CRITICAL issues found, report and BLOCK workflow
7. You MUST call `Write` tool to create the output file
8. After creating the file, confirm: "✅ File created: [path]"
```

**🪝 Hook**: Block if CRITICAL issues found.

---

### Step 4.2: Review Loop

**Quality Gate Check**:

```markdown
## 🚦 Review Quality Gate

| Check               | Result | Action         |
| ------------------- | ------ | -------------- |
| No CRITICAL issues  | ✅/❌  | Continue/BLOCK |
| Security scan clean | ✅/❌  | Continue/BLOCK |
```

#### Branch: PASS (No CRITICAL Issues)

```markdown
✅ **CODE REVIEW PASSED**

- Critical Issues: 0
- Warnings: X (addressed/noted)
- Suggestions: X

➡️ Moving to Phase 5: Finalization
```

**Action**: Continue to Phase 5

---

#### Branch: ISSUES FOUND (CRITICAL Issues Exist)

```markdown
� **CODE REVIEW BLOCKED**

**CRITICAL Issues Found**: X

### Issues to Fix:

1. 🔴 [Issue 1]: [File:Line] - [Description]
2. 🔴 [Issue 2]: [File:Line] - [Description]

**Action Required**:

- Senior Developer must fix CRITICAL issues
- Re-request code review after fixes
```

**Action**:

1. Determine fix type:
   - **AUTO-FIX** (Minor issues): Call `senior-developer` with fix instructions
   - **MANUAL FIX** (Major issues): Request user intervention
2. After fixes, loop back to Step 4.1 for RE-REVIEW
3. Repeat until all CRITICAL issues resolved

---

## Phase 5: Finalization

### Step 5.1: Documentation

**Subagent**: `documentation-writer`

**Steps**:

1. Update relevant documentation (README, API docs)
2. Add inline code comments where needed
3. Update CHANGELOG if applicable
4. **🚨 MUST use `Write` tool** to save output

**Subagent Task**:

```
🎯 TASK: Update documentation for the completed feature.

📄 INPUT:
- Implementation Report: .kira/plans/{feature-slug}-implementation-report.md
- Test Report: .kira/plans/{feature-slug}-test-report.md
- Review Report: .kira/reviews/{feature-slug}-review.md

📚 SKILLS FOR DOCUMENTATION-WRITER ROLE:
- Read `.claude/skills/git-workflow/SKILL-SUMMARY.md` - CHANGELOG and commit conventions (PRIORITY)

📖 FULL REFERENCE (only for commit message examples):
- `.claude/skills/git-workflow/SKILL.md` → Conventional Commits format

💡 NOTE: Focus on git-workflow for commits. project-conventions NOT needed for documentation.

📁 OUTPUT FILES (MANDATORY):
1. Update relevant project docs (README.md, CHANGELOG.md, etc.)
2. You MUST use the `Write` tool to create: .kira/plans/plan-{feature-slug}.md

⚠️ CRITICAL INSTRUCTIONS:
1. Read and apply all skills listed above BEFORE documenting
2. Update README if new features/APIs are added
3. Add CHANGELOG entry following Keep a Changelog format
4. Add JSDoc/TSDoc for new public APIs
5. You MUST call `Write` tool to create the plan summary file
6. After creating files, confirm: "✅ Files created: [paths]"
```

**🪝 Hook**: Validate markdown syntax.

---

### Step 5.2: Git Operations

**Executed by**: Main Agent

**Steps**:

1. Stage all changes:

   ```bash
   git add -A
   ```

2. Create commit with conventional message:

   ```bash
   git commit -m "feat({scope}): {description}"
   ```

3. **[GitHub Mode Only]** Create PR with description:
   ```bash
   gh pr create --title "feat({scope}): {description}" --body-file .kira/plans/{feature-slug}-pr-description.md
   ```

**Commit Message Format** (Conventional Commits):

```
<type>(<scope>): <description>

<body - optional>

Closes #<issue-number>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

### Step 5.3: Output Summary

**Executed by**: Main Agent or `documentation-writer`

Generate comprehensive session summary:

**Files to Create/Update**:

```
.kira/
├── plans/
│   ├── {feature-slug}-requirements.md      # Phase 1.1 output
│   ├── {feature-slug}-codebase-analysis.md # Phase 1.2 output
│   ├── {feature-slug}-architecture.md      # Phase 2 output
│   ├── {feature-slug}-implementation-report.md # Phase 3.1 output
│   ├── {feature-slug}-test-report.md       # Phase 3.2 output
│   └── plan-{feature-slug}.md              # Final plan summary
├── reviews/
│   └── {feature-slug}-review.md            # Phase 4 output
└── logs/
    └── session-{timestamp}.md              # Session log
```

**Session Log Template** (.kira/logs/session-{timestamp}.md):

```markdown
# Development Session: {Feature Name}

**Date**: YYYY-MM-DD HH:MM
**Status**: ✅ Completed

---

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

---

## Artifacts Generated

- `.kira/plans/{feature-slug}-requirements.md`
- `.kira/plans/{feature-slug}-codebase-analysis.md`
- `.kira/plans/{feature-slug}-architecture.md`
- `.kira/plans/{feature-slug}-implementation-report.md`
- `.kira/plans/{feature-slug}-test-report.md`
- `.kira/reviews/{feature-slug}-review.md`
- `.kira/plans/plan-{feature-slug}.md`

---

## Git Summary

**Commit**: `{commit-hash}` - {commit-message}
**Branch**: feature/{feature-slug}

---

## Quality Metrics

| Metric          | Value | Target | Status |
| --------------- | ----- | ------ | ------ |
| Test Coverage   | X%    | 80%    | ✅     |
| Critical Issues | 0     | 0      | ✅     |
| Documentation   | Done  | Done   | ✅     |

---

_Session completed at YYYY-MM-DD HH:MM_
```

**🪝 Hook**: Log completion.

---

## 🎉 Workflow Complete

Display final summary to user:

```markdown
## ✅ Feature Development Complete!

### 📊 Summary

| Phase          | Status |
| -------------- | ------ |
| Analysis       | ✅     |
| Planning       | ✅     |
| Implementation | ✅     |
| Testing        | ✅     |
| Review         | ✅     |
| Documentation  | ✅     |

### 📁 Generated Files

- Plan: `.kira/plans/plan-{feature-slug}.md`
- Review: `.kira/reviews/{feature-slug}-review.md`
- Session Log: `.kira/logs/session-{timestamp}.md`

### 🔗 Git

- Commit: `{commit-hash}`
- Branch: `feature/{feature-slug}`
- [GitHub Mode] PR: #{pr-number}

### 🎯 Next Steps

1. Review the generated documentation
2. [GitHub Mode] Merge the PR when ready
3. [Local Mode] Push changes: `git push origin feature/{feature-slug}`
```

---

## 🚀 Start Workflow

Process input: **$ARGUMENTS**

1. Determine input type (GitHub Issue / Local File / Inline Text)
2. Create feature-slug from input
3. **⚡ Start Phase 1 PARALLEL execution**:
   - Launch `requirement-analyst` with $ARGUMENTS
   - Launch `codebase-scout` with $ARGUMENTS (simultaneously)
4. Wait for both subagents to complete
5. Validate & merge results (Step 1.2)
6. Continue through remaining phases until completion
