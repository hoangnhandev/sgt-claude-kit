# 🚀 Kira Agent - Feature Development Workflow

> **Mục tiêu:** Xây dựng workflow phát triển tính năng mới tận dụng tối đa tài nguyên Claude Code với điểm số 10/10

---

## 📋 Tổng Quan

### Workflow hỗ trợ 2 chế độ input:

| Mode            | Input Source              | Output            | Use Case           |
| --------------- | ------------------------- | ----------------- | ------------------ |
| **GitHub Mode** | Issue từ GitHub (via MCP) | PR + Comments     | Team collaboration |
| **Local Mode**  | File `.md` local          | File `.md` output | Solo development   |

### Các thành phần Claude Code được sử dụng:

- ✅ **Subagents** - Phân chia công việc theo chuyên môn
- ✅ **Skills** - Kiến thức domain-specific
- ✅ **Hooks** - Automation tại các checkpoint
- ✅ **MCP Servers** - Mở rộng capabilities
- ✅ **Custom Slash Commands** - Trigger workflow nhanh

---

## 🏗️ Cấu Trúc Project

```
project/
├── .claude/
│   ├── settings.json              # Hooks + Permissions
│   │
│   ├── agents/                    # Subagents (Workers)
│   │   ├── requirement-analyst.md      # Phân tích yêu cầu
│   │   ├── codebase-scout.md           # Khám phá codebase
│   │   ├── solution-architect.md       # Thiết kế solution
│   │   ├── senior-developer.md         # Triển khai code
│   │   ├── test-engineer.md            # Viết và chạy tests
│   │   ├── code-reviewer.md            # Review code
│   │   └── documentation-writer.md     # Viết docs
│   │
│   ├── skills/                    # Skills (Knowledge Base)
│   │   ├── project-conventions/
│   │   │   └── SKILL.md
│   │   ├── testing-strategy/
│   │   │   └── SKILL.md
│   │   ├── git-workflow/
│   │   │   └── SKILL.md
│   │   └── feature-development/
│   │       └── SKILL.md
│   │
│   └── commands/                  # Custom Slash Commands
│       ├── feature.md                  # /feature - Main workflow
│       ├── analyze.md                  # /analyze - Phân tích requirement
│       ├── implement.md                # /implement - Triển khai code
│       └── review.md                   # /review - Review code
│
├── .kira/                         # Kira Agent Workspace
│   ├── inputs/                    # Input requirements (Local Mode)
│   │   └── feature-xxx.md
│   ├── plans/                     # Implementation plans
│   │   └── plan-xxx.md
│   ├── reviews/                   # Code review reports
│   │   └── review-xxx.md
│   └── logs/                      # Workflow logs
│       └── session-xxx.md
│
└── [your-project-files]
```

---

## 🔄 Sơ Đồ Workflow Chính

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           FEATURE DEVELOPMENT WORKFLOW                       │
└─────────────────────────────────────────────────────────────────────────────┘

                    ┌──────────────────────────────────────┐
                    │           📥 INPUT SOURCE            │
                    │  ┌────────────┐    ┌────────────┐   │
                    │  │  GitHub    │ OR │   Local    │   │
                    │  │  Issue     │    │   .md File │   │
                    │  └────────────┘    └────────────┘   │
                    └──────────────┬───────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 1: ANALYSIS                                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  🔍 Requirement Analyst (Subagent)                                      │  │
│  │  ├─ Parse requirement từ input                                         │  │
│  │  ├─ Xác định scope và acceptance criteria                             │  │
│  │  ├─ Liệt kê unknowns và assumptions                                   │  │
│  │  └─ Output: requirement-summary.md                                     │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                                   ▼                                          │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  🗺️ Codebase Scout (Subagent)                                          │  │
│  │  ├─ Tìm files liên quan đến feature                                   │  │
│  │  ├─ Phân tích dependencies và impacts                                 │  │
│  │  ├─ Xác định patterns đang được sử dụng                               │  │
│  │  └─ Output: codebase-analysis.md                                       │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼ [Hook: Log checkpoint]
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 2: PLANNING                                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  📐 Solution Architect (Subagent)                                       │  │
│  │  ├─ Thiết kế technical solution                                       │  │
│  │  ├─ Xác định implementation steps                                     │  │
│  │  ├─ Đánh giá risks và mitigations                                     │  │
│  │  ├─ Estimate effort cho từng step                                     │  │
│  │  └─ Output: implementation-plan.md                                     │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                          ┌───────┴───────┐                                  │
│                          ▼               ▼                                  │
│                   [AUTO-APPROVE]    [USER REVIEW]                           │
│                   (Simple tasks)    (Complex tasks)                         │
│                          │               │                                  │
│                          └───────┬───────┘                                  │
│                                  │                                          │
│                                  ▼ [Hook: Notify user]                      │
└──────────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 3: IMPLEMENTATION                                                     │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  💻 Senior Developer (Subagent)                                         │  │
│  │  ├─ Triển khai theo plan                                              │  │
│  │  ├─ Áp dụng project conventions (via Skills)                          │  │
│  │  ├─ Handle errors và edge cases                                       │  │
│  │  └─ [Hook: Auto-format code after each file]                          │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                                   ▼ [Hook: Run linter]                       │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  🧪 Test Engineer (Subagent)                                            │  │
│  │  ├─ Viết unit tests cho code mới                                      │  │
│  │  ├─ Chạy test suite                                                   │  │
│  │  ├─ Verify coverage                                                   │  │
│  │  └─ [Hook: Block nếu tests fail]                                       │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 4: QUALITY ASSURANCE                                                  │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  🔎 Code Reviewer (Subagent)                                            │  │
│  │  ├─ Review code changes (git diff)                                    │  │
│  │  ├─ Check security vulnerabilities                                    │  │
│  │  ├─ Verify best practices                                             │  │
│  │  ├─ Output: review-report.md                                          │  │
│  │  └─ [Hook: Block nếu có CRITICAL issues]                              │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                          ┌───────┴───────┐                                  │
│                          ▼               ▼                                  │
│                    [PASS]           [ISSUES FOUND]                          │
│                      │                   │                                  │
│                      │            ┌──────┴──────┐                           │
│                      │            ▼             ▼                           │
│                      │      [AUTO-FIX]    [MANUAL FIX]                      │
│                      │      (Minor)       (Major)                           │
│                      │            │             │                           │
│                      │            └──────┬──────┘                           │
│                      │                   │                                  │
│                      │                   ▼                                  │
│                      │            [RE-REVIEW] ──────────────────────────┐   │
│                      │                                                  │   │
│                      ▼                                                  │   │
│               [APPROVED]◄───────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 5: FINALIZATION                                                       │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  📝 Documentation Writer (Subagent)                                     │  │
│  │  ├─ Update relevant docs                                              │  │
│  │  ├─ Add inline code comments                                          │  │
│  │  ├─ Update CHANGELOG nếu cần                                          │  │
│  │  └─ [Hook: Validate markdown syntax]                                   │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                                   ▼                                          │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  📦 Git Operations                                                      │  │
│  │  ├─ Stage changes                                                     │  │
│  │  ├─ Create commit với conventional message                            │  │
│  │  └─ [GitHub Mode] Create PR với description                           │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                   │                                          │
│                                   ▼ [Hook: Log completion]                   │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  📄 Output Summary (Local Mode)                                         │  │
│  │  ├─ Generate: .kira/plans/plan-{feature}.md                           │  │
│  │  ├─ Generate: .kira/reviews/review-{feature}.md                       │  │
│  │  └─ Generate: .kira/logs/session-{timestamp}.md                       │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Chi Tiết Triển Khai

### 1️⃣ Subagents

#### **`.claude/agents/requirement-analyst.md`**

````markdown
---
name: requirement-analyst
description: Chuyên gia phân tích yêu cầu. Tự động sử dụng khi cần phân tích issue/feature request.
tools: Read, Grep, Glob, WebSearch
model: sonnet
---

Bạn là Requirement Analyst chuyên nghiệp với nhiệm vụ:

## Quy Trình Phân Tích:

1. **Parse Input**: Đọc kỹ requirement từ GitHub issue hoặc file .md
2. **Extract Key Info**:
   - User story / Feature description
   - Acceptance criteria
   - Technical constraints
   - Non-functional requirements
3. **Identify Gaps**: Liệt kê những thông tin còn thiếu hoặc mơ hồ
4. **Define Scope**: Xác định rõ in-scope và out-of-scope

## Output Format:

```md
# Requirement Analysis: [Feature Name]

## 1. Summary

[Tóm tắt 2-3 câu]

## 2. User Stories

- As a [user], I want [feature], so that [benefit]

## 3. Acceptance Criteria

- [ ] Criteria 1
- [ ] Criteria 2

## 4. Technical Constraints

- Constraint 1
- Constraint 2

## 5. Unknowns & Assumptions

| Question | Assumption (if any) |
| -------- | ------------------- |
| ...      | ...                 |

## 6. Scope

### In-scope:

- Item 1

### Out-of-scope:

- Item 1
```
````

````

---

#### **`.claude/agents/codebase-scout.md`**
```markdown
---
name: codebase-scout
description: Chuyên gia khám phá codebase. Tự động sử dụng khi cần hiểu existing code.
tools: Read, Grep, Glob, Bash
model: sonnet
---

Bạn là Codebase Scout với nhiệm vụ khám phá và hiểu codebase hiện tại.

## Quy Trình Scout:
1. **Find Related Files**: Sử dụng Grep + Glob để tìm files liên quan
2. **Analyze Dependencies**: Trace imports và dependencies
3. **Identify Patterns**: Nhận diện patterns đang được sử dụng
4. **Map Impact**: Xác định files sẽ bị ảnh hưởng

## Output Format:
```md
# Codebase Analysis: [Feature Context]

## 1. Related Files
| File | Purpose | Impact Level |
|------|---------|--------------|
| path/to/file.ts | Description | High/Medium/Low |

## 2. Key Dependencies
- Dependency 1: Purpose
- Dependency 2: Purpose

## 3. Patterns Identified
- **Pattern Name**: Description + Example location

## 4. Impact Analysis
### Files to Modify:
1. `path/file1.ts` - Changes needed
2. `path/file2.ts` - Changes needed

### Files to Create:
1. `path/new-file.ts` - Purpose

## 5. Risks
- Risk 1: Description + Mitigation
````

````

---

#### **`.claude/agents/solution-architect.md`**
```markdown
---
name: solution-architect
description: Kiến trúc sư giải pháp. Tự động sử dụng khi cần thiết kế solution.
tools: Read, Grep, Glob, WebSearch
model: sonnet
---

Bạn là Solution Architect với nhiệm vụ thiết kế technical solution.

## Quy Trình Thiết Kế:
1. **Review Inputs**: Đọc requirement analysis và codebase analysis
2. **Design Solution**: Thiết kế kiến trúc và approach
3. **Plan Steps**: Chi tiết các bước implementation
4. **Estimate Effort**: Đánh giá effort cho từng step

## Output Format:
```md
# Implementation Plan: [Feature Name]

## 1. Technical Approach
[Mô tả approach đã chọn và lý do]

## 2. Architecture Changes
[Diagram nếu cần]

## 3. Implementation Steps
### Step 1: [Name]
- **Effort**: [S/M/L]
- **Description**: What to do
- **Files**: List of files
- **Dependencies**: Prerequisites

### Step 2: [Name]
...

## 4. Testing Strategy
- Unit tests: Description
- Integration tests: Description

## 5. Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| ... | High/Medium/Low | ... |

## 6. Rollback Plan
[Steps to rollback if needed]
````

````

---

#### **`.claude/agents/senior-developer.md`**
```markdown
---
name: senior-developer
description: Senior Developer triển khai code. BẮT BUỘC sử dụng khi implement features.
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Bạn là Senior Developer với nhiệm vụ triển khai code chất lượng cao.

## Nguyên Tắc:
1. **Follow the Plan**: Tuân thủ implementation plan đã được approve
2. **Apply Conventions**: Sử dụng coding conventions của project (via Skills)
3. **Write Clean Code**: Code phải readable, maintainable
4. **Handle Errors**: Xử lý tất cả edge cases và errors
5. **Self-Review**: Tự review trước khi submit

## Checklist Trước Khi Hoàn Thành:
- [ ] Code follows project conventions
- [ ] All edge cases handled
- [ ] Error messages are helpful
- [ ] No console.log/print statements left
- [ ] Imports are organized
- [ ] No unused code/variables
````

---

#### **`.claude/agents/test-engineer.md`**

````markdown
---
name: test-engineer
description: Test Engineer viết và chạy tests. Tự động sử dụng sau khi code được implement.
tools: Read, Write, Edit, Bash, Grep
model: sonnet
---

Bạn là Test Engineer với nhiệm vụ đảm bảo code quality qua testing.

## Quy Trình Testing:

1. **Analyze Changes**: Đọc git diff để hiểu code mới
2. **Write Unit Tests**: Viết tests cho functions mới/modified
3. **Run Test Suite**: Chạy full test suite
4. **Report Results**: Báo cáo coverage và failures

## Testing Standards:

- Minimum 80% coverage cho code mới
- Test cả happy path và error cases
- Sử dụng mocking khi thích hợp
- Test names phải descriptive

## Output Format:

```md
# Test Report: [Feature Name]

## Summary

- Tests Added: X
- Tests Modified: X
- Coverage: X%

## Test Results

✅ All tests passed

## Coverage Report

| File | Coverage |
| ---- | -------- |
| ...  | X%       |
```
````

````

---

#### **`.claude/agents/code-reviewer.md`**
```markdown
---
name: code-reviewer
description: Code Reviewer đánh giá chất lượng code. Tự động sử dụng sau implementation.
tools: Read, Grep, Glob, Bash
model: sonnet
---

Bạn là Senior Code Reviewer với nhiệm vụ đảm bảo code quality.

## Review Checklist:
1. **Code Quality**: Readable, maintainable, DRY
2. **Security**: No vulnerabilities, proper sanitization
3. **Performance**: No obvious bottlenecks
4. **Error Handling**: Comprehensive error handling
5. **Testing**: Adequate test coverage
6. **Documentation**: Code comments where needed

## Output Format:
```md
# Code Review: [Feature Name]

## Summary
- Files Reviewed: X
- Issues Found: X (Critical: X, Warning: X, Info: X)

## Critical Issues 🔴
> Phải fix trước khi merge

1. **[File:Line]** Issue description
   - **Vấn đề**: ...
   - **Fix đề xuất**: ...

## Warnings 🟡
> Nên fix

1. **[File:Line]** Issue description

## Suggestions 🔵
> Nice to have

1. **[File:Line]** Suggestion

## Verdict
- [ ] APPROVED
- [ ] CHANGES REQUESTED
````

````

---

#### **`.claude/agents/documentation-writer.md`**
```markdown
---
name: documentation-writer
description: Technical Writer cập nhật documentation. Sử dụng sau khi code được approve.
tools: Read, Write, Edit, Grep
model: haiku
---

Bạn là Technical Writer với nhiệm vụ maintain documentation.

## Responsibilities:
1. Update README nếu có API changes
2. Add JSDoc/TSDoc cho public APIs
3. Update CHANGELOG
4. Create inline comments cho complex logic

## Standards:
- Docs phải clear và concise
- Include code examples khi cần
- Keep CHANGELOG format consistent
````

---

### 2️⃣ Skills

#### **`.claude/skills/project-conventions/SKILL.md`**

```markdown
---
name: project-conventions
description: Coding conventions và standards của project. Áp dụng khi viết code mới.
---

# Project Conventions

## Code Style

- Use Prettier for formatting
- ESLint for linting
- Tab size: 2 spaces

## Naming Conventions

- Files: kebab-case.ts
- Components: PascalCase
- Functions: camelCase
- Constants: UPPER_SNAKE_CASE

## Git Conventions

- Commit message: Conventional Commits
- Branch naming: feature/xxx, fix/xxx, chore/xxx

## Import Order

1. External packages
2. Internal aliases (@/...)
3. Relative imports
4. Style imports
```

---

#### **`.claude/skills/feature-development/SKILL.md`**

```markdown
---
name: feature-development
description: Complete workflow cho feature development. Trigger với /feature command.
---

# Feature Development Workflow

## Prerequisites

- Requirement document hoặc GitHub issue
- Access to codebase
- Development environment ready

## Workflow Steps

### Phase 1: Analysis (Subagents: requirement-analyst, codebase-scout)

1. Parse và phân tích requirement
2. Scout codebase để hiểu context
3. Output: requirement-summary.md, codebase-analysis.md

### Phase 2: Planning (Subagent: solution-architect)

1. Thiết kế technical solution
2. Tạo implementation plan
3. [Checkpoint] User approval nếu complex

### Phase 3: Implementation (Subagent: senior-developer, test-engineer)

1. Implement theo plan
2. Viết tests
3. [Hook] Auto-format after each file

### Phase 4: Quality Assurance (Subagent: code-reviewer)

1. Review code changes
2. Fix issues nếu có
3. [Checkpoint] Re-review nếu có changes

### Phase 5: Finalization (Subagent: documentation-writer)

1. Update docs
2. Create commit
3. [Local Mode] Generate output files

## Commands

- `/feature <requirement>` - Start full workflow
- `/analyze <requirement>` - Chỉ Phase 1
- `/implement <plan>` - Chỉ Phase 3
- `/review` - Chỉ Phase 4
```

---

### 3️⃣ Hooks Configuration

#### **`.claude/settings.json`**

```json
{
  "permissions": {
    "allow": [
      "Read(*)",
      "Grep(*)",
      "Glob(*)",
      "Bash(npm run lint:*)",
      "Bash(npm run test:*)",
      "Bash(git status)",
      "Bash(git diff*)",
      "Bash(git log*)"
    ],
    "deny": ["Bash(rm -rf *)", "Bash(git push --force*)"]
  },

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"📝 Modifying: $TOOL_INPUT\" >> .kira/logs/current-session.log 2>/dev/null || true"
          }
        ]
      }
    ],

    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "file=$(echo '$TOOL_INPUT' | jq -r '.file_path // .path // empty' 2>/dev/null); if [[ \"$file\" =~ \\.(ts|tsx|js|jsx)$ ]]; then npx prettier --write \"$file\" 2>/dev/null && echo \"✨ Formatted: $file\"; fi"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo '$TOOL_INPUT' | grep -q 'test'; then echo \"🧪 Tests executed\" >> .kira/logs/current-session.log 2>/dev/null; fi"
          }
        ]
      }
    ],

    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"\\n---\\n✅ Workflow step completed at $(date '+%Y-%m-%d %H:%M:%S')\" >> .kira/logs/current-session.log 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

---

### 4️⃣ Custom Slash Commands

#### **`.claude/commands/feature.md`**

```markdown
---
description: Bắt đầu full feature development workflow
---

# Feature Development Workflow

Bạn sẽ xử lý feature development theo workflow sau:

## Input Detection

$ARGUMENTS sẽ là một trong:

1. **GitHub Issue**: `#123` hoặc URL
2. **Local File**: Path đến file .md trong `.kira/inputs/`
3. **Inline Text**: Mô tả trực tiếp

## Execution Flow

### Step 1: Requirement Analysis

Sử dụng `requirement-analyst` subagent để phân tích input.
Output: Lưu vào `.kira/plans/{feature-name}-requirements.md`

### Step 2: Codebase Analysis

Sử dụng `codebase-scout` subagent để hiểu existing code.
Output: Append vào plan file

### Step 3: Solution Design

Sử dụng `solution-architect` subagent để tạo implementation plan.
Output: Lưu vào `.kira/plans/{feature-name}-plan.md`

**[CHECKPOINT]**: Nếu complexity > Medium, hỏi user confirm plan.

### Step 4: Implementation

Sử dụng `senior-developer` subagent để implement.
Tiếp theo dùng `test-engineer` để viết tests.

### Step 5: Code Review

Sử dụng `code-reviewer` subagent để review.
Output: Lưu vào `.kira/reviews/{feature-name}-review.md`

**[CHECKPOINT]**: Nếu có CRITICAL issues, yêu cầu fix.

### Step 6: Finalization

Sử dụng `documentation-writer` để update docs.
Tạo git commit với conventional message.

## Output (Local Mode)

Generate summary vào `.kira/logs/session-{timestamp}.md`

---

Bắt đầu xử lý: $ARGUMENTS
```

---

#### **`.claude/commands/analyze.md`**

```markdown
---
description: Chỉ phân tích requirement (Phase 1)
---

Thực hiện requirement analysis cho: $ARGUMENTS

1. Sử dụng `requirement-analyst` subagent
2. Sử dụng `codebase-scout` subagent
3. Output kết quả vào `.kira/plans/`

Không thực hiện implementation.
```

---

### 5️⃣ Input/Output Templates

#### **`.kira/inputs/TEMPLATE.md`**

```markdown
# Feature Request: [Tên Feature]

## 1. Mô Tả

[Mô tả chi tiết feature cần implement]

## 2. User Story

As a [role], I want [feature], so that [benefit].

## 3. Acceptance Criteria

- [ ] Criteria 1
- [ ] Criteria 2
- [ ] Criteria 3

## 4. Technical Notes (Optional)

- Note 1
- Note 2

## 5. References (Optional)

- Link 1
- Link 2

## 6. Priority

- [ ] Critical
- [ ] High
- [x] Medium
- [ ] Low
```

---

#### **`.kira/logs/SESSION-TEMPLATE.md`**

```markdown
# Session Log: [Feature Name]

**Date**: YYYY-MM-DD HH:MM
**Duration**: X minutes

## Workflow Summary

| Phase          | Status      | Duration | Notes |
| -------------- | ----------- | -------- | ----- |
| Analysis       | ✅ Complete | Xm       | -     |
| Planning       | ✅ Complete | Xm       | -     |
| Implementation | ✅ Complete | Xm       | -     |
| Review         | ✅ Complete | Xm       | -     |
| Finalization   | ✅ Complete | Xm       | -     |

## Changes Made

### Files Created:

- `path/to/file.ts`

### Files Modified:

- `path/to/file.ts`

## Commits

- `abc1234` - feat: description

## Review Summary

- Critical: 0
- Warnings: 2 (fixed)
- Suggestions: 3

## Lessons Learned

- Lesson 1
```

---

## 🚀 Cách Sử Dụng

### Local Mode (File-based)

```bash
# 1. Tạo requirement file
touch .kira/inputs/feature-user-auth.md
# Edit file với requirement details

# 2. Chạy workflow
claude
> /feature .kira/inputs/feature-user-auth.md

# 3. Xem output
cat .kira/plans/user-auth-plan.md
cat .kira/reviews/user-auth-review.md
cat .kira/logs/session-*.md
```

### GitHub Mode

```bash
# Với GitHub issue
> /feature #123

# Hoặc với URL
> /feature https://github.com/org/repo/issues/123
```

### Partial Workflows

```bash
# Chỉ phân tích
> /analyze .kira/inputs/feature-xyz.md

# Chỉ implement (khi đã có plan)
> /implement .kira/plans/xyz-plan.md

# Chỉ review
> /review
```

---

## 📊 Metrics & Quality Gates

### Quality Gates

| Gate          | Criteria           | Action if Failed      |
| ------------- | ------------------ | --------------------- |
| Plan Approval | Complex features   | Pause for user review |
| Test Coverage | >= 80%             | Block until fixed     |
| Code Review   | No CRITICAL issues | Re-implement          |
| Lint          | No errors          | Auto-fix or block     |

### Performance Metrics

- Measure thời gian mỗi phase
- Track số lần re-review
- Log các issues phát hiện

---

## 🔧 MCP Servers (Optional Enhancement)

| Server     | Purpose           | Usage                   |
| ---------- | ----------------- | ----------------------- |
| Context7   | Memory management | Lưu patterns, decisions |
| Playwright | E2E testing       | Browser testing         |
| Web Search | Research          | Tìm solutions, docs     |
| GitHub MCP | GitHub API        | Issues, PRs             |

---

## ✅ Checklist Triển Khai

### Bước 1: Setup Cấu Trúc

- [ ] Tạo `.claude/agents/` với tất cả subagent files
- [ ] Tạo `.claude/skills/` với skill files
- [ ] Tạo `.claude/commands/` với command files
- [ ] Tạo `.claude/settings.json` với hooks
- [ ] Tạo `.kira/` workspace folders

### Bước 2: Test Workflow

- [ ] Test từng subagent riêng lẻ
- [ ] Test hooks đang hoạt động
- [ ] Test full workflow với simple feature
- [ ] Test Local Mode output

### Bước 3: Fine-tune

- [ ] Adjust subagent prompts based on results
- [ ] Optimize hook commands
- [ ] Add project-specific conventions to skills

---

## 📝 Notes

### Ưu điểm của Architecture này:

1. **Modular**: Mỗi subagent có responsibility rõ ràng
2. **Traceable**: Logs và outputs được lưu local
3. **Flexible**: Hỗ trợ cả GitHub và Local mode
4. **Automated**: Hooks xử lý các tasks repetitive
5. **Quality-focused**: Multiple review checkpoints
6. **Iterative**: Dễ dàng thêm/bớt phases

### Khi nào KHÔNG nên dùng full workflow:

- Bug fixes đơn giản → Dùng `/fix` command riêng
- Refactoring → Dùng `/refactor` command riêng
- Hotfixes → Skip review phase

---

_Last Updated: 2025-12-26_
