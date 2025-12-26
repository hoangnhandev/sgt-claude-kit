---
description: Run tests and generate test report - Use to verify code quality
---

# /test - Testing Only

You are the Main Agent running the testing phase of the workflow.

---

## 📥 Input

`$ARGUMENTS` can be:

| Input Type   | Example                  | Description                  |
| ------------ | ------------------------ | ---------------------------- |
| Empty        | (none)                   | Run full test suite          |
| Feature slug | `user-auth`              | Run tests related to feature |
| File pattern | `src/services/*.test.ts` | Run specific test files      |
| Test name    | `UserService`            | Run tests matching name      |

---

## 🔄 Execution Flow

### Step 1: Analyze Changes (Optional)

If testing after implementation:

```bash
# Get list of changed files
git diff --name-only HEAD~1

# Identify test files needed
find_by_name(Pattern="*.test.*", SearchDirectory="src/")
```

---

### Step 2: Run Tests

**Subagent**: `test-engineer`

```
📋 Call subagent: test-engineer
📄 Input: Test scope from $ARGUMENTS
📁 Output: .kira/plans/{feature-slug}-test-report.md (if feature) or console output
```

**Tasks**:

1. Run test suite with coverage
2. Analyze results
3. Report failures and coverage gaps

---

### Step 3: Coverage Analysis

```bash
# Run with coverage
npm run test -- --coverage

# Expected output
# - Statement coverage
# - Branch coverage
# - Function coverage
# - Line coverage
```

**Minimum thresholds**:

- Overall: 80%
- Critical paths: 95%
- New code: 80%

---

## 📊 Test Report

Display results:

```markdown
## 🧪 Test Results

### Summary

| Metric       | Value | Target | Status |
| ------------ | ----- | ------ | ------ |
| Tests Run    | X     | -      | -      |
| Tests Passed | X     | 100%   | ✅/❌  |
| Tests Failed | X     | 0      | ✅/❌  |
| Coverage     | X%    | 80%    | ✅/❌  |

### Test Execution
```

✅ PASS src/services/UserService.test.ts (X tests)
✅ PASS src/components/LoginForm.test.tsx (X tests)
❌ FAIL src/utils/validator.test.ts (X tests)

```

### Failed Tests (if any)
```

❌ validator.test.ts > validateEmail > should reject invalid format
Expected: false
Received: true
at line 45

```

### Coverage Report
| File | Statements | Branches | Functions | Lines |
|------|------------|----------|-----------|-------|
| src/services/UserService.ts | 95% | 90% | 100% | 94% |
| src/utils/validator.ts | 75% | 60% | 80% | 72% |

### Uncovered Lines
- `src/utils/validator.ts:45-52` - Error handling not tested
```

---

## ✅ Completion

### If All Pass:

```markdown
## ✅ All Tests Passed

- **Tests**: X passed, 0 failed
- **Coverage**: X% (target: 80%)
- **Duration**: X seconds

🎯 Ready for code review. Run `/review` to continue.
```

### If Tests Fail:

```markdown
## ❌ Tests Failed

- **Tests**: X passed, Y failed
- **Coverage**: X%

### Failed Tests:

1. `test-name`: Error message
2. `test-name`: Error message

🔧 **Action Required**: Fix failing tests before continuing.

**Tips**:

- Check the error messages above
- Run `npm run test -- --watch` for interactive debugging
- Use `npm run test -- -t "test-name"` to run specific test
```

### If Coverage Low:

```markdown
## ⚠️ Coverage Below Threshold

- **Current**: X%
- **Required**: 80%
- **Gap**: Y%

### Files with Low Coverage:

| File           | Coverage | Lines Missing |
| -------------- | -------- | ------------- |
| `validator.ts` | 65%      | 45-52, 78-82  |

🔧 **Action Required**: Add tests for uncovered lines.
```

---

## 🚀 Start Testing

Process input: **$ARGUMENTS**

1. Determine test scope
2. Call `test-engineer` subagent or run tests directly
3. Analyze results
4. Display summary

**Quick run**: `npm run test -- --coverage`
