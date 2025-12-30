# 🐛 Bug Fix Workflow - Implementation Plan

**Ngày tạo**: 2025-12-30
**Phương pháp**: Hybrid Approach
**Trạng thái**: ✅ Completed

---

## 📊 Tổng Quan

### Mục Tiêu

Xây dựng workflow `/bugfix` hoàn chỉnh để xử lý bug reports từ phân tích đến verification, tối ưu bằng cách kết hợp agents mới và tái sử dụng agents hiện có.

### Chiến Lược Hybrid

```
┌─────────────────────────────────────────────────────────────┐
│                    HYBRID APPROACH                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ✨ TẠO MỚI (2 agents):                                     │
│     ├── bug-analyst.md        → Phase 1: Triage & Analysis  │
│     └── bug-investigator.md   → Phase 2: Root Cause         │
│                                                              │
│  ♻️ TÁI SỬ DỤNG (3 agents):                                 │
│     ├── senior-developer      → Phase 3: Fix Implementation │
│     ├── test-engineer         → Phase 4: Verification       │
│     └── code-reviewer         → Phase 5: Review             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Files Cần Tạo/Sửa

### ✨ Files Mới

| File                                           | Mô tả                              | Priority |
| ---------------------------------------------- | ---------------------------------- | -------- |
| `.claude/commands/bugfix.md`                   | Main command orchestration         | P0       |
| `.claude/agents/bug-analyst.md`                | Bug triage & analysis agent        | P0       |
| `.claude/agents/bug-investigator.md`           | Root cause analysis agent          | P0       |
| `.claude/skills/bug-analysis/SKILL.md`         | Bug analysis patterns & techniques | P1       |
| `.claude/skills/bug-analysis/SKILL-SUMMARY.md` | Summary cho token optimization     | P1       |

### ♻️ Files Cần Sửa Nhẹ

| File                                 | Sửa đổi                         | Priority |
| ------------------------------------ | ------------------------------- | -------- |
| `.claude/agents/senior-developer.md` | Thêm section "Bug Fix Mode"     | P2       |
| `.claude/agents/test-engineer.md`    | Thêm section "Bug Verification" | P2       |

### 📂 Folders Mới

```
.kira/
└── bugs/                    # NEW - Bug fix artifacts
    ├── {bug-id}-analysis.md
    ├── {bug-id}-root-cause.md
    ├── {bug-id}-fix-report.md
    └── {bug-id}-verification.md
```

---

## 🔄 Workflow Phases

### Phase 1: Bug Triage & Analysis

**Agent**: `bug-analyst` (MỚI)

**Input**:

- GitHub Issue (`#123`)
- Local file (`.kira/inputs/bug-xxx.md`)
- Inline description

**Tasks**:

1. Parse bug report
2. Extract reproduction steps
3. Classify severity (Critical/High/Medium/Low)
4. Identify affected components
5. Assess customer impact
6. Create analysis document

**Output**: `.kira/bugs/{bug-id}-analysis.md`

**Template Output**:

```markdown
# Bug Analysis: {Bug Title}

## 📋 Bug Information

- **ID**: {bug-id}
- **Severity**: 🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Low
- **Reporter**: {reporter}
- **Date Reported**: {date}

## 🔄 Reproduction Steps

1. Step 1
2. Step 2
3. Step 3

## ✅ Expected Behavior

{description}

## ❌ Actual Behavior

{description}

## 🎯 Affected Components

- Component 1
- Component 2

## 👥 Customer Impact

- **Users Affected**: {count/percentage}
- **Business Impact**: {description}

## 📎 Related Issues

- #xxx
- #yyy
```

---

### Phase 2: Root Cause Investigation

**Agent**: `bug-investigator` (MỚI)

**Input**:

- Analysis từ Phase 1
- Codebase access

**Tasks**:

1. Reproduce bug locally
2. Trace execution path
3. Identify root cause
4. Propose fix options (có thể nhiều hơn 1)
5. Assess regression risks
6. Estimate fix complexity

**Output**: `.kira/bugs/{bug-id}-root-cause.md`

**Template Output**:

```markdown
# Root Cause Analysis: {Bug Title}

## 🔍 Investigation Summary

**Status**: ✅ Root Cause Identified / ⏳ Still Investigating

## 🐛 Root Cause

**File**: `path/to/file.ts`
**Line**: 45-52
**Description**: {detailed explanation}

## 🔬 Execution Trace

1. User action → Component A
2. Component A calls → Service B
3. Service B fails at → {specific point}
4. Error propagates → UI shows bug

## 💡 Fix Options

### Option 1: {Name} (Recommended)

- **Approach**: {description}
- **Files to change**: 2
- **Risk**: Low
- **Effort**: 1 hour

### Option 2: {Name}

- **Approach**: {description}
- **Files to change**: 5
- **Risk**: Medium
- **Effort**: 4 hours

## ⚠️ Regression Risks

- [ ] Risk 1: {description}
- [ ] Risk 2: {description}

## 📊 Complexity Assessment

**Level**: Simple / Medium / Complex
**Reason**: {explanation}
```

---

### Phase 3: Fix Implementation

**Agent**: `senior-developer` (TÁI SỬ DỤNG)

**Special Instructions cho Bug Fix Mode**:

1. Follow "Minimal Change Principle"
2. No refactoring during bug fix
3. Focus on root cause only
4. Add inline comments explaining fix

**Output**: `.kira/bugs/{bug-id}-fix-report.md`

---

### Phase 4: Verification

**Agent**: `test-engineer` (TÁI SỬ DỤNG)

**Special Instructions cho Bug Verification**:

1. **Reproduction Test**: Test case that reproduces bug (MUST fail before fix)
2. **Fix Verification**: Same test must pass after fix
3. **Regression Tests**: Run full test suite
4. **Edge Cases**: Add tests for related edge cases

**Quality Gate**:

```
✅ Reproduction test fails on main branch
✅ Reproduction test passes on fix branch
✅ All existing tests pass
✅ No new warnings
```

**Output**: `.kira/bugs/{bug-id}-verification.md`

---

### Phase 5: Review & Finalization

**Agent**: `code-reviewer` (TÁI SỬ DỤNG)

**Focus Areas cho Bug Fix Review**:

1. Minimal diff check
2. No unrelated changes
3. Root cause addressed (not just symptoms)
4. Regression risks mitigated

**Output**: `.kira/reviews/{bug-id}-review.md`

---

## 🚦 Decision Gates

### Gate 1: Severity-Based Auto-Approval

```
┌─────────────────────────────────────────────────────────┐
│               SEVERITY-BASED DECISION                    │
├─────────────────────────────────────────────────────────┤
│ 🔴 Critical (P0) → HOTFIX MODE                          │
│    - Auto-approve Phase 2                               │
│    - Skip non-essential steps                           │
│    - Fast-track to production                           │
│                                                          │
│ 🟠 High (P1) → PRIORITY MODE                            │
│    - User review at Phase 2                             │
│    - Full testing required                              │
│                                                          │
│ 🟡 Medium (P2) → NORMAL MODE                            │
│    - Standard workflow                                  │
│    - Can be batched                                     │
│                                                          │
│ 🟢 Low (P3) → BACKLOG MODE                              │
│    - Can wait for next sprint                           │
│    - May batch with features                            │
└─────────────────────────────────────────────────────────┘
```

### Gate 2: Fix Complexity Review

```
Simple fix   → Auto-approve, proceed
Medium fix   → User review summary
Complex fix  → Detailed discussion required
```

---

## 📋 Implementation Checklist

### Phase 1: Core Setup

- [x] Tạo folder `.kira/bugs/`
- [x] Tạo agent `bug-analyst.md`
- [x] Tạo agent `bug-investigator.md`
- [x] Tạo command `bugfix.md`

### Phase 2: Skills & Documentation

- [x] Tạo skill `bug-analysis/SKILL.md`
- [x] Tạo skill `bug-analysis/SKILL-SUMMARY.md`
- [x] Update `senior-developer.md` với Bug Fix Mode
- [x] Update `test-engineer.md` với Bug Verification

### Phase 3: Testing & Refinement

- [ ] Test với sample bug report
- [ ] Validate all outputs
- [ ] Fine-tune prompts
- [ ] Documentation

---

## ⏱️ Estimated Effort

| Task                  | Effort         |
| --------------------- | -------------- |
| `bug-analyst.md`      | 30 mins        |
| `bug-investigator.md` | 30 mins        |
| `bugfix.md` command   | 1 hour         |
| Skills creation       | 30 mins        |
| Agent updates         | 20 mins        |
| Testing               | 30 mins        |
| **Total**             | **~3.5 hours** |

---

## 🎯 Success Criteria

1. ✅ `/bugfix` command works end-to-end
2. ✅ All 5 phases produce correct outputs
3. ✅ Decision gates function correctly
4. ✅ Quality gates block on failures
5. ✅ Integration with existing `/feature` workflow
6. ✅ Token usage comparable to feature workflow

---

## 📝 Notes

- Agents mới sẽ follow cùng format với agents hiện có
- Output files sẽ consistent với `.kira/plans/` structure
- Có thể mở rộng thêm "hotfix mode" cho P0 bugs sau này

---

**Next Step**: Bắt đầu implementation từ Phase 1 - Core Setup
