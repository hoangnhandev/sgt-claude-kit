---
name: e2e-testing
description: Browser-based UI testing using Playwright MCP.
---

# E2E Testing (Playwright MCP)

## 🔧 Core Tools

- `navigate({ url })`: Go to page.
- `click({ selector })`: Click element (`data-testid` preferred).
- `type({ selector, text })`: Input text.
- `screenshot({ name })`: Capture state (Required for validation).
- `playwright_expect_response({ urlPattern, status })`: Wait for API.
- `playwright_resize({ width, height })`: Test Responsive.

## 📋 Standard Workflow

1. **Setup**: Clear state, Navigate to URL.
2. **Action**: Interact (Click, Type).
3. **Verify**: Check UI (Screenshots) & API (Response status).
4. **Report**: Pass/Fail with evidence.

## ⚠️ Best Practices

- **Selectors**: Use `[data-testid='...']` > ID > CSS.
- **Wait**: Always wait for network (`expect_response`) before UI checks.
- **Mobile**: Test on mobile viewport (375x667).
