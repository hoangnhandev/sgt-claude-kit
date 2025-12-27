---
description: Run E2E tests using Playwright MCP for browser-based UI testing
---

# /e2e - End-to-End Testing Workflow

You are the E2E Testing Coordinator, responsible for executing browser-based tests using Playwright MCP.

---

## 📥 Input Detection

Analyze `$ARGUMENTS` to determine test scope:

| Pattern                         | Input Type       | Example                                  |
| ------------------------------- | ---------------- | ---------------------------------------- |
| `.kira/inputs/*e2e*.md` or path | E2E Test File    | `.kira/inputs/example-e2e-login-flow.md` |
| URL path                        | Single Page Test | `/login` or `/dashboard`                 |
| `responsive`                    | Responsive Test  | Test all breakpoints                     |
| `full` or empty                 | Full E2E Suite   | Run all E2E scenarios                    |

---

## 🔄 Execution Flow

### Phase 1: Preparation

1. **Verify Dev Server**

   ```bash
   # Check if dev server is running
   curl -s -o /dev/null -w "%{http_code}" http://localhost:3000
   ```

   If not running, prompt user:

   ```
   ⚠️ Dev server is not running at http://localhost:3000

   Please start it with:
   > npm run dev

   Then run /e2e again.
   ```

2. **Load E2E Testing Skill**

   - Apply `e2e-testing` skill for Playwright patterns
   - Apply `testing-strategy` for general test practices

3. **Parse Test Scenarios**
   - Read input file if provided
   - Extract test scenarios and expected results

---

### Phase 2: Execute E2E Tests

**Use Subagent**: `test-engineer` with E2E focus

For each test scenario:

#### Step 2.1: Navigate and Screenshot

```
navigate({ url: "[target-url]" })
screenshot({ name: "scenario-[n]-initial" })
```

#### Step 2.2: Perform Actions

```
// Fill forms
type({ selector: "[selector]", text: "[value]" })

// Click buttons
click({ selector: "[selector]" })

// Wait for API
playwright_expect_response({ urlPattern: "[pattern]", status: [code] })
```

#### Step 2.3: Verify and Document

```
screenshot({ name: "scenario-[n]-result" })
```

---

### Phase 3: Responsive Testing (if applicable)

Test critical viewports:

```
// Desktop
playwright_resize({ width: 1920, height: 1080 })
screenshot({ name: "responsive-desktop" })

// Tablet
playwright_resize({ width: 768, height: 1024 })
screenshot({ name: "responsive-tablet" })

// Mobile
playwright_resize({ width: 375, height: 667 })
screenshot({ name: "responsive-mobile" })
```

---

### Phase 4: Generate Report

Create E2E test report at `.kira/reviews/{feature}-e2e-report.md`:

```markdown
# E2E Test Report: [Feature Name]

**Tested At**: [Timestamp]
**Base URL**: http://localhost:3000
**Tester**: Test Engineer Agent (E2E Mode)

---

## Summary

| Metric          | Value |
| --------------- | ----- |
| Total Scenarios | X     |
| Passed          | X     |
| Failed          | X     |
| Screenshots     | X     |

## Quality Gate

✅ **PASSED** / ❌ **FAILED**

---

## Scenario Results

### Scenario 1: [Name]

**Status**: ✅ PASS

| Step | Action             | Result              |
| ---- | ------------------ | ------------------- |
| 1    | Navigate to /login | ✅ Page loaded      |
| 2    | Enter credentials  | ✅ Form filled      |
| 3    | Click submit       | ✅ API returned 200 |
| 4    | Verify redirect    | ✅ On /dashboard    |

**Screenshots**:

- scenario-1-initial.png
- scenario-1-result.png

---

### Scenario 2: [Name]

**Status**: ❌ FAIL

| Step | Action             | Result                      |
| ---- | ------------------ | --------------------------- |
| 1    | Navigate to /login | ✅ Page loaded              |
| 2    | Enter invalid data | ✅ Form filled              |
| 3    | Click submit       | ❌ Expected error not shown |

**Issue**: Error message element not found
**Screenshot**: scenario-2-failure.png

---

## Responsive Test Results

| Viewport | Width | Height | Status          |
| -------- | ----- | ------ | --------------- |
| Desktop  | 1920  | 1080   | ✅ OK           |
| Tablet   | 768   | 1024   | ✅ OK           |
| Mobile   | 375   | 667    | ⚠️ Minor issues |

**Mobile Issues**:

- Button text truncated on small screens

---

## Recommendations

1. [Recommendation 1]
2. [Recommendation 2]
```

---

## 🚦 Quality Gate

| Check                   | Criteria              | Action              |
| ----------------------- | --------------------- | ------------------- |
| All scenarios pass      | 100% pass rate        | ✅ Continue         |
| Critical scenarios pass | Login, checkout, etc. | ✅ Continue         |
| Any critical failure    | Security, data loss   | 🚫 BLOCK            |
| Minor UI issues only    | Non-breaking          | ⚠️ Log and continue |

---

## 📁 Output Files

```
.kira/
├── reviews/
│   └── {feature}-e2e-report.md    # E2E test report
└── screenshots/                    # (if configured)
    ├── scenario-1-initial.png
    ├── scenario-1-result.png
    └── ...
```

---

## 🚀 Start E2E Testing

Process input: **$ARGUMENTS**

1. Detect input type (file, URL, or full suite)
2. Verify dev server is running
3. Load E2E testing skills
4. Execute test scenarios with Playwright MCP
5. Generate comprehensive report
