---
name: testing-strategy
description: Testing strategy and best practices. Apply when writing tests or reviewing test quality.
---

# Testing Strategy

> Áp dụng strategy này khi viết tests hoặc review test quality.

---

## 🎯 Testing Goals

### Coverage Targets

| Code Type      | Minimum Coverage | Ideal Coverage |
| -------------- | ---------------- | -------------- |
| Business logic | 90%              | 95%            |
| Utilities      | 85%              | 90%            |
| API services   | 80%              | 90%            |
| UI components  | 70%              | 80%            |
| Overall        | 80%              | 85%            |

### What to Test

| Priority   | What             | Why                            |
| ---------- | ---------------- | ------------------------------ |
| **High**   | Business logic   | Core value of the app          |
| **High**   | API integrations | External dependencies can fail |
| **High**   | Edge cases       | Where bugs hide                |
| **Medium** | UI interactions  | User experience                |
| **Medium** | Error handling   | Graceful failures              |
| **Low**    | Styling/Layout   | Visual regression tools better |

---

## 🧪 Test Types

### Unit Tests

Test individual functions/classes in isolation.

```typescript
// What to test:
// - Pure functions
// - Class methods
// - Hooks (with renderHook)
// - Utility functions

describe("calculateDiscount", () => {
  it("should return 20% discount for orders over $100", () => {
    expect(calculateDiscount(150)).toBe(30);
  });

  it("should return 0 discount for orders under $50", () => {
    expect(calculateDiscount(40)).toBe(0);
  });

  it("should handle edge case of exactly $100", () => {
    expect(calculateDiscount(100)).toBe(20);
  });
});
```

### Integration Tests

Test multiple units working together.

```typescript
// What to test:
// - API calls with mocked responses
// - Component with context/providers
// - Database operations (with test DB)

describe("UserService integration", () => {
  it("should create user and send welcome email", async () => {
    // Arrange
    const userData = { email: "test@example.com", name: "Test" };
    mockEmailService.send.mockResolvedValue({ success: true });

    // Act
    const user = await userService.createUser(userData);

    // Assert
    expect(user.id).toBeDefined();
    expect(mockEmailService.send).toHaveBeenCalledWith(
      expect.objectContaining({ to: userData.email })
    );
  });
});
```

### Component Tests

Test React/Vue components.

```typescript
import { render, screen, userEvent } from "@testing-library/react";

describe("LoginForm", () => {
  it("should submit form with valid credentials", async () => {
    const onSubmit = vi.fn();
    render(<LoginForm onSubmit={onSubmit} />);

    await userEvent.type(screen.getByLabelText("Email"), "test@example.com");
    await userEvent.type(screen.getByLabelText("Password"), "password123");
    await userEvent.click(screen.getByRole("button", { name: "Login" }));

    expect(onSubmit).toHaveBeenCalledWith({
      email: "test@example.com",
      password: "password123",
    });
  });

  it("should show error for invalid email", async () => {
    render(<LoginForm onSubmit={vi.fn()} />);

    await userEvent.type(screen.getByLabelText("Email"), "invalid-email");
    await userEvent.click(screen.getByRole("button", { name: "Login" }));

    expect(screen.getByText("Invalid email format")).toBeInTheDocument();
  });
});
```

---

## 📝 Test Structure

### AAA Pattern

```typescript
it("should [expected behavior] when [condition]", async () => {
  // Arrange - Set up test data and mocks
  const input = createTestInput();
  mockService.method.mockResolvedValue(expectedResult);

  // Act - Execute the function under test
  const result = await functionUnderTest(input);

  // Assert - Verify the outcome
  expect(result).toEqual(expectedOutput);
  expect(mockService.method).toHaveBeenCalledWith(input);
});
```

### Describe Blocks Organization

```typescript
describe("UserService", () => {
  // Group by method
  describe("createUser", () => {
    // Group by scenario
    describe("with valid data", () => {
      it("should create user successfully", () => {});
      it("should return user with generated id", () => {});
      it("should hash password before saving", () => {});
    });

    describe("with invalid data", () => {
      it("should throw ValidationError for missing email", () => {});
      it("should throw ValidationError for invalid email format", () => {});
    });

    describe("when email already exists", () => {
      it("should throw DuplicateError", () => {});
    });
  });

  describe("updateUser", () => {
    // Similar structure
  });
});
```

---

## 🎭 Mocking

### When to Mock

| Mock             | Don't Mock                      |
| ---------------- | ------------------------------- |
| External APIs    | Pure functions                  |
| Database calls   | Simple utilities                |
| File system      | The function under test         |
| Network requests | Internal dependencies (usually) |
| Time/Date        |                                 |

### Mock Patterns

```typescript
// Mock module
vi.mock("@/services/api", () => ({
  api: {
    get: vi.fn(),
    post: vi.fn(),
  },
}));

// Mock implementation
mockApi.get.mockResolvedValue({ data: mockUser });
mockApi.get.mockRejectedValue(new Error("Network error"));

// Mock with implementation
mockApi.get.mockImplementation((url) => {
  if (url.includes("/users")) return Promise.resolve({ data: mockUsers });
  if (url.includes("/orders")) return Promise.resolve({ data: mockOrders });
});

// Spy on existing method
const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
```

### Reset Mocks

```typescript
beforeEach(() => {
  vi.clearAllMocks(); // Clear call history
});

afterEach(() => {
  vi.resetAllMocks(); // Reset implementations
});

afterAll(() => {
  vi.restoreAllMocks(); // Restore original implementations
});
```

---

## 🔍 Testing Edge Cases

### Common Edge Cases to Test

```typescript
describe("edge cases", () => {
  // Empty inputs
  it("should handle empty array", () => {
    expect(processItems([])).toEqual([]);
  });

  // Null/Undefined
  it("should handle null input", () => {
    expect(processItems(null)).toEqual([]);
  });

  // Boundary values
  it("should handle maximum value", () => {
    expect(processNumber(Number.MAX_SAFE_INTEGER)).toBe(expected);
  });

  // Special characters
  it("should handle special characters in input", () => {
    expect(sanitize("<script>alert('xss')</script>")).toBe("&lt;script&gt;...");
  });

  // Concurrent operations
  it("should handle concurrent calls", async () => {
    const results = await Promise.all([
      service.process(1),
      service.process(2),
      service.process(3),
    ]);
    expect(results).toHaveLength(3);
  });

  // Timeout/slow operations
  it("should timeout after 5 seconds", async () => {
    vi.useFakeTimers();
    const promise = service.slowOperation();
    vi.advanceTimersByTime(5000);
    await expect(promise).rejects.toThrow("Timeout");
    vi.useRealTimers();
  });
});
```

---

## ⚡ Performance Testing

### Test Execution Time

```typescript
it("should complete within 100ms", async () => {
  const start = performance.now();
  await heavyOperation();
  const duration = performance.now() - start;
  expect(duration).toBeLessThan(100);
});
```

### Memory Leak Detection

```typescript
it("should not leak memory", () => {
  const initialMemory = process.memoryUsage().heapUsed;

  for (let i = 0; i < 1000; i++) {
    createAndDestroyComponent();
  }

  // Force garbage collection (Node with --expose-gc flag)
  if (global.gc) global.gc();

  const finalMemory = process.memoryUsage().heapUsed;
  expect(finalMemory - initialMemory).toBeLessThan(1024 * 1024); // < 1MB
});
```

---

## 📊 Test Data

### Test Data Factories

```typescript
// factories/user.factory.ts
export function createTestUser(overrides: Partial<User> = {}): User {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    email: faker.internet.email(),
    role: "user",
    createdAt: new Date(),
    ...overrides,
  };
}

// Usage in tests
const user = createTestUser({ role: "admin" });
const users = Array.from({ length: 10 }, () => createTestUser());
```

### Fixtures

```typescript
// fixtures/users.fixture.ts
export const validUser = {
  id: "user-123",
  name: "Test User",
  email: "test@example.com",
  role: "user" as const,
};

export const adminUser = {
  ...validUser,
  id: "admin-123",
  role: "admin" as const,
};

export const invalidUserData = {
  name: "",
  email: "not-an-email",
};
```

---

## ✅ Test Checklist

Before considering tests complete:

### Coverage

- [ ] All public functions tested
- [ ] Happy path covered
- [ ] Error cases covered
- [ ] Edge cases covered
- [ ] Coverage meets threshold (80%+)

### Quality

- [ ] Tests are independent (no shared state)
- [ ] Tests are deterministic (no flakiness)
- [ ] Test names are descriptive
- [ ] AAA pattern followed
- [ ] Mocks are appropriate (not over-mocking)

### Maintainability

- [ ] No magic numbers (use constants)
- [ ] Test data factories used
- [ ] DRY (shared setup in beforeEach)
- [ ] Tests document expected behavior

---

_Apply this strategy consistently for reliable, maintainable tests._
