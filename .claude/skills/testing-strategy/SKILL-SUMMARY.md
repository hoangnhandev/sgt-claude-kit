---
name: testing-strategy-summary
description: Quick reference for testing best practices. Read SKILL.md for full details.
---

# Testing Strategy (Quick Reference)

> 📖 **Full details**: `.claude/skills/testing-strategy/SKILL.md`

---

## 🎯 Coverage Targets

| Code Type      | Minimum | Ideal |
| -------------- | ------- | ----- |
| Business logic | 90%     | 95%   |
| Overall        | 80%     | 85%   |

---

## 🧪 Test Types

| Type        | What to Test                       |
| ----------- | ---------------------------------- |
| Unit        | Pure functions, hooks, utilities   |
| Integration | API calls, components with context |
| Component   | React/Vue component interactions   |

---

## 📝 AAA Pattern

```typescript
it("should [behavior] when [condition]", async () => {
  // Arrange - Set up test data and mocks
  // Act - Execute the function
  // Assert - Verify outcome
});
```

---

## 🎭 Mocking Rules

| Mock             | Don't Mock              |
| ---------------- | ----------------------- |
| External APIs    | Pure functions          |
| Database calls   | The function under test |
| File system      | Simple utilities        |
| Network requests | Internal dependencies   |

---

## 🔍 Edge Cases to Test

- Empty inputs (`[]`, `null`, `undefined`)
- Boundary values (max, min)
- Special characters in strings
- Concurrent operations
- Timeout scenarios

---

## ✅ Quick Checklist

- [ ] Happy path covered
- [ ] Error cases covered
- [ ] Edge cases covered
- [ ] Coverage >= 80%
- [ ] Tests are independent (no shared state)
- [ ] Test names are descriptive
- [ ] No flaky tests
