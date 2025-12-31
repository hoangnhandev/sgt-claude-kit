---
name: testing-strategy
description: Testing strategy and best practices. Apply when writing tests or reviewing test quality.
---

# Testing Strategy

> Apply this strategy when writing tests or reviewing test quality.

## 🎯 Testing Goals

| Code Type      | Min Coverage | Ideal Coverage |
| -------------- | ------------ | -------------- |
| Business logic | 90%          | 95%            |
| Utilities      | 85%          | 90%            |
| UI components  | 70%          | 80%            |
| Overall        | **80%**      | 85%            |

## 🧪 Test Types & Priority

1. **Unit Tests (High)**: Logic isolation. Focus: Pure functions, Class methods, Hooks, Utils.
2. **Integration Tests (High)**: Multiple units working together. Focus: API calls (mocked), Context/Providers.
3. **Component Tests (Medium)**: UI behavior. Focus: User interactions, Validations.
4. **Reproduction Tests (CRITICAL)**: Create failing test -> Fix -> Pass.

## 📝 Test Structure (AAA Pattern)

- **Arrange**: Set up test data and mocks.
- **Act**: Execute the function/component under test.
- **Assert**: Verify outcome against expectation.

## 🎭 Mocking Rules

- **Mock**: External APIs, DB calls, File system, Network, Time/Date.
- **Don't Mock**: Pure functions, Simple utilities, The actual logic being tested.
- **Cleanup**: `vi.clearAllMocks()` in `beforeEach`.

## ✅ Test Checklist

- [ ] All public functions tested.
- [ ] Happy path + Error cases + Edge cases covered.
- [ ] Test names are descriptive (Gherkin style preferred).
- [ ] Tests are independent and deterministic.
- [ ] No magic numbers; use test data factories.

## 🌐 E2E Testing (Playwright)

### Core Tools

- `navigate({ url })`: Go to page.
- `click({ selector })`: Click element (`data-testid` preferred).
- `type({ selector, text })`: Input text.
- `screenshot({ name })`: Capture state (Required for validation).
- `playwright_expect_response({ urlPattern, status })`: Wait for API.

### Standard Flow

1. **Setup**: Clear state, Navigate to URL.
2. **Action**: Interact (Click, Type).
3. **Verify**: Check UI (Screenshots) & API (Response status).
4. **Report**: Pass/Fail with evidence.

### Best Practices

- **Selectors**: Use `[data-testid='...']` > ID > CSS.
- **Wait**: Always wait for network (`expect_response`) before UI checks.
- **Mobile**: Test on mobile viewport (375x667).
