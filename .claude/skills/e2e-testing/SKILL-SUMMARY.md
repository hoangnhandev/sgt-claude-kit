---
name: e2e-testing-summary
description: Quick reference for E2E testing with Playwright MCP. Read SKILL.md for full details.
---

# E2E Testing (Quick Reference)

> 📖 **Full details**: `.claude/skills/e2e-testing/SKILL.md`

---

## 🎯 When to Use E2E

| Use E2E For ✅              | Don't Use E2E For ❌  |
| --------------------------- | --------------------- |
| Verify UI renders correctly | Unit logic testing    |
| Multi-step user flows       | API-only testing      |
| Form submission with API    | Simple function tests |

---

## 🔧 Core Playwright MCP Tools

| Tool                | Purpose         | Example                                                  |
| ------------------- | --------------- | -------------------------------------------------------- |
| `navigate`          | Open URL        | `navigate({ url: "http://localhost:3000" })`             |
| `click`             | Click element   | `click({ selector: "button[type='submit']" })`           |
| `type`              | Type text       | `type({ selector: "input[name='email']", text: "..." })` |
| `screenshot`        | Capture state   | `screenshot({ name: "after-login" })`                    |
| `playwright_resize` | Test responsive | `playwright_resize({ width: 375, height: 667 })`         |

---

## 🎭 Selector Priority

1. `data-testid` attributes (most reliable)
2. Accessible roles: `button`, `link`, `textbox`
3. ID selectors: `#element-id`
4. CSS selectors: `.class-name`

---

## 📱 Common Viewports

| Device  | Width | Height |
| ------- | ----- | ------ |
| Mobile  | 375   | 667    |
| Tablet  | 768   | 1024   |
| Desktop | 1920  | 1080   |

---

## ⚠️ Best Practices

### DO ✅

- Use `data-testid` for reliable selectors
- Wait for API responses before asserting
- Take screenshots at critical points
- Test responsive breakpoints

### DON'T ❌

- Use flaky selectors (nth-child, text content)
- Hard-code delays
- Skip error scenarios
- Test everything with E2E

---

## ✅ Quick Checklist

- [ ] Dev server running
- [ ] Critical user flows tested
- [ ] Form validations verified
- [ ] Responsive design tested
- [ ] Screenshots captured
