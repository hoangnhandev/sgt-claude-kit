---
name: project-conventions
description: Coding conventions and standards for the project. Apply when writing new code or modifying existing code.
---

# Project Conventions

> Áp dụng các conventions này khi viết code mới hoặc chỉnh sửa code hiện có.

---

## 📁 File Structure

### Directory Organization

```
src/
├── components/       # UI Components (React/Vue)
│   ├── common/       # Shared components
│   ├── layouts/      # Layout components
│   └── features/     # Feature-specific components
├── services/         # Business logic & API calls
├── hooks/            # Custom hooks
├── utils/            # Utility functions
├── types/            # TypeScript types/interfaces
├── constants/        # Constants and configuration
├── styles/           # Global styles
└── __tests__/        # Test utilities & mocks
```

### File Naming

| Type       | Convention                  | Example             |
| ---------- | --------------------------- | ------------------- |
| Components | PascalCase                  | `UserCard.tsx`      |
| Hooks      | camelCase with `use` prefix | `useAuth.ts`        |
| Utilities  | kebab-case                  | `date-utils.ts`     |
| Constants  | kebab-case                  | `api-endpoints.ts`  |
| Types      | PascalCase                  | `UserTypes.ts`      |
| Tests      | Same as source + `.test`    | `UserCard.test.tsx` |

---

## 🎨 Code Style

### Naming Conventions

| Element     | Convention                            | Example                       |
| ----------- | ------------------------------------- | ----------------------------- |
| Variables   | camelCase                             | `userName`, `isLoading`       |
| Constants   | UPPER_SNAKE_CASE                      | `MAX_RETRIES`, `API_URL`      |
| Functions   | camelCase                             | `getUserById`, `handleSubmit` |
| Classes     | PascalCase                            | `UserService`, `ApiClient`    |
| Interfaces  | PascalCase with `I` prefix (optional) | `User` or `IUser`             |
| Types       | PascalCase                            | `UserRole`, `ApiResponse`     |
| Enums       | PascalCase                            | `UserStatus`                  |
| Enum values | UPPER_SNAKE_CASE                      | `ACTIVE`, `PENDING`           |

### Boolean Naming

Use prefixes that indicate boolean nature:

```typescript
// ✅ Good
const isLoading = true;
const hasPermission = false;
const canEdit = true;
const shouldRefresh = false;

// ❌ Bad
const loading = true;
const permission = false;
```

### Function Naming

```typescript
// Actions - use verbs
function fetchUser() {}
function createOrder() {}
function updateProfile() {}
function deleteItem() {}

// Getters - use get prefix
function getUserName() {}
function getFormattedDate() {}

// Event handlers - use handle prefix
function handleClick() {}
function handleSubmit() {}
function handleChange() {}

// Validators - use is/has/can prefix
function isValidEmail() {}
function hasRequiredFields() {}
function canAccessResource() {}
```

---

## 📝 Code Formatting

### Imports Order

```typescript
// 1. External packages (React, libraries)
import React, { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import axios from "axios";

// 2. Internal aliases (@/)
import { Button } from "@/components/ui/Button";
import { useAuth } from "@/hooks/useAuth";
import { UserService } from "@/services/UserService";

// 3. Relative imports
import { helperFunction } from "./utils";
import { CONSTANTS } from "./constants";

// 4. Type imports
import type { User, ApiResponse } from "@/types";

// 5. Style imports
import styles from "./Component.module.css";
```

### Line Length & Formatting

- Max line length: 100 characters
- Use Prettier for formatting
- Tab size: 2 spaces
- Trailing commas: ES5

### Destructuring

```typescript
// ✅ Good - Destructure when using multiple properties
const { name, email, role } = user;

// ✅ Good - Keep as object for single property
const userName = user.name;

// ✅ Good - Rename during destructuring
const { name: userName, email: userEmail } = user;
```

---

## 🔧 TypeScript

### Type Definitions

```typescript
// ✅ Good - Use interface for objects
interface User {
  id: string;
  name: string;
  email: string;
}

// ✅ Good - Use type for unions, intersections
type UserRole = "admin" | "user" | "guest";
type UserWithRole = User & { role: UserRole };

// ❌ Avoid - Don't use 'any'
const data: any = fetchData(); // Bad

// ✅ Good - Use 'unknown' if type is truly unknown
const data: unknown = fetchData();
```

### Generics

```typescript
// ✅ Good - Use descriptive generic names
interface ApiResponse<TData> {
  data: TData;
  status: number;
  message: string;
}

// ✅ Good - Constrain generics when possible
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

---

## ⚠️ Error Handling

### Try-Catch Pattern

```typescript
// ✅ Good - Comprehensive error handling
async function fetchUser(id: string): Promise<User | null> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    // Log for debugging
    console.error(`[fetchUser] Failed to fetch user ${id}:`, error);

    // Return null or throw based on requirements
    if (error instanceof NotFoundError) {
      return null;
    }
    throw error;
  }
}
```

### Error Messages

```typescript
// ✅ Good - Descriptive error with context
throw new Error(`Failed to create user: email "${email}" already exists`);

// ❌ Bad - Generic error
throw new Error("Error");
```

---

## 📊 React Patterns

### Component Structure

```tsx
// Component file structure
interface Props {
  title: string;
  onSubmit: (data: FormData) => void;
}

export function MyComponent({ title, onSubmit }: Props) {
  // 1. Hooks
  const [state, setState] = useState();
  const { data } = useQuery();

  // 2. Derived state
  const isValid = useMemo(() => validate(state), [state]);

  // 3. Effects
  useEffect(() => {
    // Effect logic
  }, [dependency]);

  // 4. Event handlers
  const handleClick = () => {
    // Handler logic
  };

  // 5. Render
  return <div>{/* JSX */}</div>;
}
```

### Props

```typescript
// ✅ Good - Destructure props with defaults
function Button({
  children,
  variant = "primary",
  disabled = false,
  onClick,
}: ButtonProps) {
  // ...
}

// ✅ Good - Spread remaining props
function Input({ label, error, ...inputProps }: InputProps) {
  return (
    <div>
      <label>{label}</label>
      <input {...inputProps} />
      {error && <span>{error}</span>}
    </div>
  );
}
```

---

## 🧪 Testing

### Test Naming

```typescript
// Format: should [expected behavior] when [condition]
describe("UserService", () => {
  describe("createUser", () => {
    it("should create user when valid data is provided", () => {});
    it("should throw ValidationError when email is invalid", () => {});
    it("should throw DuplicateError when email already exists", () => {});
  });
});
```

### Test Structure (AAA Pattern)

```typescript
it("should return user when valid id is provided", async () => {
  // Arrange
  const userId = "123";
  mockApi.get.mockResolvedValue({ data: mockUser });

  // Act
  const result = await userService.getUser(userId);

  // Assert
  expect(result).toEqual(mockUser);
  expect(mockApi.get).toHaveBeenCalledWith(`/users/${userId}`);
});
```

---

## 📝 Comments

### When to Comment

```typescript
// ✅ Good - Explain WHY, not WHAT
// Use debounce to prevent API spam during rapid typing
const debouncedSearch = useMemo(() => debounce(search, 300), []);

// ✅ Good - Document business rules
// Users must verify email within 24 hours per compliance requirements
if (hoursSinceCreation > 24 && !user.emailVerified) {
  await deactivateAccount(user.id);
}

// ✅ Good - Warn about non-obvious behavior
// IMPORTANT: This array is mutated in place for performance
// Clone before passing if you need the original
sortInPlace(items);

// ❌ Bad - States the obvious
// Increment counter
counter++;
```

### JSDoc for Public APIs

````typescript
/**
 * Creates a new user account.
 *
 * @param data - User creation data
 * @returns Created user with generated ID
 * @throws {ValidationError} If email format is invalid
 * @throws {DuplicateError} If email already exists
 *
 * @example
 * ```typescript
 * const user = await createUser({ email: "test@example.com", name: "Test" });
 * ```
 */
export async function createUser(data: CreateUserData): Promise<User> {
  // Implementation
}
````

---

_Apply these conventions consistently across all code changes._
