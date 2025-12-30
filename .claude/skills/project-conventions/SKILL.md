---
name: project-conventions
description: Coding conventions and standards for the project.
---

# Project Conventions

## 📁 Structure

- **Src**: `components` (UI), `services` (Logic), `hooks`, `utils`, `types`, `styles`.
- **Naming**:
  - Files: `UserCard.tsx` (Pascal), `useAuth.ts` (camel), `date-utils.ts` (kebab).
  - Vars: `userName` (camel), `MAX_RETRIES` (UPPER_SNAKE).
  - Bool: `isLoading`, `hasError` (verify state).

## 🎨 Code Style

### Imports Order

1. Ext Libs (`react`, `axios`)
2. Internal (`@/components`)
3. Relative (`./utils`)
4. Types (`type/interface`)

### Formatting

- **Max Length**: 100 chars. **Tab**: 2 spaces. **Prettier**: On.
- **Destructure**: `const { name } = user` (when possible).

## 🔧 Types

- **Interfaces**: `interface User { ... }` (Objects).
- **Types**: `type Role = 'admin' | 'user'` (Unions/Primitives).
- **Generics**: `ApiResponse<TData>`.
- **Prohibited**: NO `any`. Use `unknown` or specific types.

## ⚠️ Error Handling

- **Pattern**: `try/catch` with specialized naming.
- **Throw**: `throw new Error("Context: message")` (Descriptive).

## 📊 React

- **Comp**: `export function Name({ prop }: Props)`.
- **Order**: Hooks -> Derived State -> Effects -> Handlers -> Render.
- **Props**: Destructure with defaults. Spread rest: `{...props}`.

## 🧪 Testing

- **Name**: `describe("Service", () => it("should X when Y"))`.
- **AAA**: Arrange -> Act -> Assert.
- **Mock**: Isolate unit tests.

## 📝 Comments

- **Rule**: Explain WHY, not WHAT.
- **JSDoc**: Required for Public APIs (`@param`, `@returns`, `@example`).
