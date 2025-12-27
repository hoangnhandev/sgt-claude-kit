---
name: e2e-testing
description: End-to-End testing strategy using Playwright MCP. Apply when performing browser-based UI testing and validation.
---

# E2E Testing with Playwright MCP

> Sử dụng Playwright MCP để thực hiện kiểm thử End-to-End trực tiếp trên trình duyệt.

---

## 🎯 When to Use E2E Testing

| Scenario                    | Use E2E? | Reason                   |
| --------------------------- | -------- | ------------------------ |
| Verify UI renders correctly | ✅ Yes   | Visual validation        |
| Test user login flow        | ✅ Yes   | Multi-step interaction   |
| Form submission with API    | ✅ Yes   | Integration with backend |
| Test responsive design      | ✅ Yes   | Viewport-based testing   |
| Unit logic testing          | ❌ No    | Use unit tests instead   |
| API-only testing            | ❌ No    | Use integration tests    |

---

## 🔧 Playwright MCP Tools

### Core Navigation & Interaction

#### `navigate`

Navigate browser to a URL.

```
navigate({ url: "http://localhost:3000/login" })
```

**Use cases:**

- Start E2E test by opening target page
- Navigate between pages during test flow
- Test deep links and routing

#### `click`

Click on page elements.

```
click({ selector: "button[type='submit']" })
click({ selector: "#login-button" })
click({ selector: "[data-testid='submit-btn']" })
```

**Selector strategies (priority order):**

1. `data-testid` attributes (most reliable)
2. Accessible roles: `button`, `link`, `textbox`
3. ID selectors: `#element-id`
4. CSS selectors: `.class-name`

#### `type`

Type text into input fields.

```
type({ selector: "input[name='email']", text: "user@example.com" })
type({ selector: "#password", text: "securePassword123" })
```

**Best practices:**

- Clear field before typing if needed
- Use realistic test data
- Test special characters and unicode

#### `screenshot`

Capture current page state.

```
screenshot({ name: "login-page-initial" })
screenshot({ name: "after-form-submit" })
screenshot({ name: "error-state" })
```

**When to screenshot:**

- Before and after critical actions
- When errors occur
- For visual regression documentation

---

### Advanced Tools

#### `playwright_expect_response`

Wait for specific HTTP response.

```
playwright_expect_response({
  urlPattern: "**/api/auth/login",
  status: 200
})
```

**Use cases:**

- Verify API calls complete successfully
- Wait for async data loading
- Assert specific API responses

#### `start_codegen_session`

Record user actions to generate test selectors.

```
start_codegen_session()
```

**When to use:**

- Learning selectors for complex UIs
- Generating test boilerplate
- Exploring dynamic elements

#### `playwright_resize`

Test responsive design.

```
// Mobile
playwright_resize({ width: 375, height: 667 })

// Tablet
playwright_resize({ width: 768, height: 1024 })

// Desktop
playwright_resize({ width: 1920, height: 1080 })
```

**Common viewport presets:**

| Device        | Width | Height |
| ------------- | ----- | ------ |
| iPhone SE     | 375   | 667    |
| iPhone 12 Pro | 390   | 844    |
| iPad          | 768   | 1024   |
| iPad Pro      | 1024  | 1366   |
| Desktop HD    | 1920  | 1080   |
| Desktop 4K    | 3840  | 2160   |

---

## 📋 E2E Test Workflow

### Phase 1: Setup

```markdown
1. Ensure dev server is running

   - Run: `npm run dev` or equivalent
   - Verify: http://localhost:3000 is accessible

2. Clear browser state (if needed)
   - Fresh session for each test
   - No cached credentials
```

### Phase 2: Execute Test Scenario

```markdown
1. Navigate to target page
   navigate({ url: "http://localhost:3000" })

2. Take initial screenshot
   screenshot({ name: "step-1-initial" })

3. Perform user actions

   - Click, type, select
   - Wait for responses

4. Verify expected state

   - Check UI elements
   - Validate API responses

5. Take final screenshot
   screenshot({ name: "step-final-result" })
```

### Phase 3: Report Results

```markdown
## E2E Test Report

### Scenario: [Name]

**Status**: ✅ PASS / ❌ FAIL

### Steps Executed:

1. [Step 1] - ✅ Success
2. [Step 2] - ✅ Success
3. [Step 3] - ❌ Failed - [reason]

### Screenshots:

- `step-1-initial.png`
- `step-final-result.png`

### API Responses Verified:

- POST /api/login → 200 OK
- GET /api/user → 200 OK
```

---

## 🎭 Common E2E Patterns

### Login Flow

```
// 1. Navigate to login
navigate({ url: "http://localhost:3000/login" })
screenshot({ name: "login-page" })

// 2. Fill credentials
type({ selector: "input[name='email']", text: "test@example.com" })
type({ selector: "input[name='password']", text: "password123" })
screenshot({ name: "login-filled" })

// 3. Submit and wait
click({ selector: "button[type='submit']" })
playwright_expect_response({ urlPattern: "**/api/auth/login", status: 200 })

// 4. Verify redirect to dashboard
screenshot({ name: "dashboard-after-login" })
```

### Form Validation

```
// 1. Navigate to form
navigate({ url: "http://localhost:3000/register" })

// 2. Submit empty form (trigger validation)
click({ selector: "button[type='submit']" })
screenshot({ name: "validation-errors" })

// 3. Fill with invalid data
type({ selector: "input[name='email']", text: "invalid-email" })
click({ selector: "button[type='submit']" })
screenshot({ name: "email-validation-error" })

// 4. Fill with valid data
type({ selector: "input[name='email']", text: "valid@example.com" })
type({ selector: "input[name='password']", text: "StrongPass123!" })
click({ selector: "button[type='submit']" })
playwright_expect_response({ urlPattern: "**/api/register", status: 201 })
screenshot({ name: "registration-success" })
```

### Responsive Testing

```
// Desktop view
playwright_resize({ width: 1920, height: 1080 })
navigate({ url: "http://localhost:3000" })
screenshot({ name: "homepage-desktop" })

// Tablet view
playwright_resize({ width: 768, height: 1024 })
screenshot({ name: "homepage-tablet" })

// Mobile view
playwright_resize({ width: 375, height: 667 })
screenshot({ name: "homepage-mobile" })

// Verify mobile menu
click({ selector: "[data-testid='mobile-menu-toggle']" })
screenshot({ name: "mobile-menu-open" })
```

### Error Handling

```
// Test 404 page
navigate({ url: "http://localhost:3000/non-existent-page" })
screenshot({ name: "404-page" })

// Test API error
navigate({ url: "http://localhost:3000/dashboard" })
// Mock API failure scenario
playwright_expect_response({ urlPattern: "**/api/data", status: 500 })
screenshot({ name: "api-error-state" })
```

---

## ⚠️ Best Practices

### DO:

1. ✅ **Use data-testid attributes** for reliable selectors
2. ✅ **Wait for API responses** before asserting UI state
3. ✅ **Take screenshots** at critical points
4. ✅ **Test responsive breakpoints** for all critical pages
5. ✅ **Use realistic test data** that resembles production
6. ✅ **Clean state** between test runs

### DON'T:

1. ❌ **Use flaky selectors** like nth-child or text content
2. ❌ **Hard-code delays** - use proper wait mechanisms
3. ❌ **Skip error scenarios** - test unhappy paths too
4. ❌ **Test everything with E2E** - save for critical flows only
5. ❌ **Ignore mobile testing** - many users are on mobile

---

## 📊 E2E Test Checklist

Before completing E2E testing:

- [ ] Dev server is running and accessible
- [ ] Critical user flows tested (login, signup, checkout, etc.)
- [ ] Form validations verified
- [ ] Error states handled gracefully
- [ ] Responsive design tested (mobile, tablet, desktop)
- [ ] Screenshots captured for documentation
- [ ] API responses verified where applicable
- [ ] Test report generated

---

_E2E tests are the final validation layer. Use them wisely for critical user journeys._
