---
name: feature-development
description: Complete feature development workflow orchestration. This is the master skill that coordinates all phases and subagents.
---

# Feature Development Workflow

> Master skill cho việc phát triển feature từ đầu đến cuối.

---

## 🎯 Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    FEATURE DEVELOPMENT FLOW                     │
└─────────────────────────────────────────────────────────────────┘

 📥 INPUT                    🔄 PROCESSING                    📤 OUTPUT
 ───────                    ──────────────                    ────────

 ┌─────────────┐           ┌─────────────────┐           ┌──────────────┐
 │ Requirement │           │ Phase 1: Analysis│           │ Working Code │
 │ (Issue/File)│    ───▶   │ Phase 2: Planning│    ───▶   │ Tests        │
 └─────────────┘           │ Phase 3: Implement│          │ Documentation│
                           │ Phase 4: QA       │           │ Git Commit   │
                           │ Phase 5: Finalize │           └──────────────┘
                           └─────────────────┘
```

---

## 📋 Phase Details

### Phase 1: Analysis

**Subagents**: `requirement-analyst`, `codebase-scout`

| Step | Agent               | Input           | Output                           |
| ---- | ------------------- | --------------- | -------------------------------- |
| 1.1  | Requirement Analyst | Issue/File/Text | `{feature}-requirements.md`      |
| 1.2  | Codebase Scout      | Requirements    | `{feature}-codebase-analysis.md` |

**Skills Used**:

- None (analysis only)

**Checkpoint**: None (auto-proceed)

---

### Phase 2: Planning

**Subagent**: `solution-architect`

| Step | Agent              | Input                            | Output                      |
| ---- | ------------------ | -------------------------------- | --------------------------- |
| 2.1  | Solution Architect | Requirements + Codebase Analysis | `{feature}-architecture.md` |

**Skills Used**:

- `project-conventions` (for architecture decisions)

**Checkpoint**:

- ✅ Auto-approve if **Simple** complexity
- ⏸️ User review if **Medium/Complex/Critical**

---

### Phase 3: Implementation

**Subagents**: `senior-developer`, `test-engineer`

| Step | Agent            | Input             | Output                                      |
| ---- | ---------------- | ----------------- | ------------------------------------------- |
| 3.1  | Senior Developer | Architecture Plan | `{feature}-implementation-report.md` + Code |
| 3.2  | Test Engineer    | Implementation    | `{feature}-test-report.md` + Tests          |

**Skills Used**:

- `project-conventions` (coding standards)
- `testing-strategy` (test writing)

**Quality Gate**:

- ❌ Block if tests fail
- ❌ Block if coverage < 80%

---

### Phase 4: Quality Assurance

**Subagent**: `code-reviewer`

| Step | Agent                        | Input         | Output                |
| ---- | ---------------------------- | ------------- | --------------------- |
| 4.1  | Code Reviewer                | All changes   | `{feature}-review.md` |
| 4.2  | Senior Developer (if needed) | Review issues | Fixed code            |
| 4.3  | Code Reviewer (re-review)    | Fixed code    | Updated review        |

**Skills Used**:

- `project-conventions` (code quality)
- `testing-strategy` (test review)

**Quality Gate**:

- ❌ Block if CRITICAL issues found
- ⚠️ Warning if WARNINGS found (can proceed)

---

### Phase 5: Finalization

**Subagent**: `documentation-writer`

| Step | Agent                | Input       | Output       |
| ---- | -------------------- | ----------- | ------------ |
| 5.1  | Documentation Writer | All reports | Updated docs |
| 5.2  | Documentation Writer | -           | Git commit   |
| 5.3  | Documentation Writer | -           | Session log  |

**Skills Used**:

- `git-workflow` (commit conventions)
- `project-conventions` (doc standards)

**Output Files**:

- `.kira/plans/plan-{feature}.md`
- `.kira/reviews/review-{feature}.md`
- `.kira/logs/session-{timestamp}.md`

---

## 🔄 Subagent Coordination

### Handoff Protocol

Each subagent should:

1. **Read previous outputs** before starting
2. **Validate inputs** are complete
3. **Generate structured output** for next agent
4. **Log progress** to session log

### Data Flow

```
requirement-analyst
        │
        ▼ requirements.md
codebase-scout
        │
        ▼ codebase-analysis.md
solution-architect
        │
        ▼ architecture.md
senior-developer
        │
        ▼ implementation-report.md + code
test-engineer
        │
        ▼ test-report.md + tests
code-reviewer
        │
        ▼ review.md
documentation-writer
        │
        ▼ docs + commit + session-log.md
```

---

## 🚦 Quality Gates

### Gate 1: Plan Approval

**Location**: After Phase 2
**Condition**: Complexity is Medium/Complex/Critical
**Action**: Pause and ask user to approve

### Gate 2: Tests Pass

**Location**: After Phase 3
**Condition**: Any test fails OR coverage < 80%
**Action**: Block and report, request fixes

### Gate 3: No Critical Issues

**Location**: After Phase 4
**Condition**: Code review has CRITICAL issues
**Action**: Block, request Senior Developer to fix, re-review

---

## 📁 Output Structure

```
.kira/
├── inputs/
│   └── {feature}.md              # Original requirement
├── plans/
│   ├── {feature}-requirements.md
│   ├── {feature}-codebase-analysis.md
│   ├── {feature}-architecture.md
│   ├── {feature}-implementation-report.md
│   ├── {feature}-test-report.md
│   └── plan-{feature}.md         # Summary
├── reviews/
│   └── {feature}-review.md
└── logs/
    └── session-{timestamp}.md
```

---

## 🎮 Commands

| Command             | Phases | Description                    |
| ------------------- | ------ | ------------------------------ |
| `/feature <req>`    | 1→2→3  | Full workflow to plan approval |
| `/analyze <req>`    | 1      | Analysis only                  |
| `/plan <slug>`      | 2      | Planning only                  |
| `/implement <slug>` | 3→4→5  | Implementation to completion   |
| `/review`           | 4      | Code review only               |
| `/test`             | 3b     | Testing only                   |

---

## ⚙️ Skill Integration Points

### When to Apply Skills

| Phase   | Skill                 | Applied By           |
| ------- | --------------------- | -------------------- |
| Phase 2 | `project-conventions` | Solution Architect   |
| Phase 3 | `project-conventions` | Senior Developer     |
| Phase 3 | `testing-strategy`    | Test Engineer        |
| Phase 4 | `project-conventions` | Code Reviewer        |
| Phase 4 | `testing-strategy`    | Code Reviewer        |
| Phase 5 | `git-workflow`        | Documentation Writer |

### How to Apply Skills

1. **Read skill file** at start of phase
2. **Apply rules** during execution
3. **Reference skill** in output when relevant

Example in Senior Developer:

```markdown
## Applied Conventions

- Following `project-conventions` naming standards
- Using TypeScript strict mode as per conventions
- Applied AAA pattern from `testing-strategy`
```

---

## 🔧 Error Recovery

### If Tests Fail

```
1. Senior Developer reviews failures
2. Fix code issues
3. Re-run Test Engineer
4. Continue if pass
```

### If Review Has Critical Issues

```
1. Senior Developer reads review
2. Fix critical issues
3. Re-run Code Reviewer
4. Continue if approved
```

### If User Rejects Plan

```
1. Get feedback from user
2. Re-run Solution Architect with feedback
3. Present new plan
4. Continue if approved
```

---

## ✅ Completion Checklist

Before declaring feature complete:

- [ ] All phases executed successfully
- [ ] Tests pass with coverage >= 80%
- [ ] Code review approved (no CRITICAL issues)
- [ ] Documentation updated
- [ ] Git commit created
- [ ] Session log generated
- [ ] Output files in `.kira/` directory

---

_This skill orchestrates the entire feature development workflow._
