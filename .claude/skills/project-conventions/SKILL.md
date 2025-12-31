---
name: project-conventions
description: Coding conventions and standards for the project.
---

# Project Conventions

## 📁 Structure

- **Src**: `components` (UI), `services` (Logic), `hooks`, `utils`, `constants`, `config`, `types`, `styles`.
- **Naming**:
  - Files: `UserCard.tsx` (Pascal), `useAuth.ts` (camel), `date-utils.ts` (kebab).
  - Vars: `userName` (camel), `MAX_RETRIES` (UPPER_SNAKE).
  - Bool: `isLoading`, `hasError` (verify state).

## 🏗️ Architecture

- **Pattern**: MVC (Model-View-Controller) / Layered.
- **Service Layer**: Contains ALL business logic.
- **Handlers/Controllers**: Thin layer. Solely responsible for receiving input, delegating to Service, and returning output.

## 🎨 Code Style

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

## 🧪 Testing

- **Name**: `describe("Service", () => it("should X when Y"))`.
- **AAA**: Arrange -> Act -> Assert.
- **Mock**: Isolate unit tests.

## 📝 Comments

- **Rule**: Explain WHY, not WHAT.
- **JSDoc**: Required for Public APIs (`@param`, `@returns`, `@example`).

## 📦 Package Version Check

**Purpose**: Ensure Context7 documentation queries match the library version used in the project.

**Workflow**:

1. **Check dependency files** before querying Context7:
   - Node.js: `package.json` → `dependencies` / `devDependencies`
   - Python: `requirements.txt` / `pyproject.toml`
2. **Query Context7 with a specific version**:
   - Use `resolve-library-id` with the package name.
   - Select results matching the major version (e.g., `v14.x` for Next.js 14.2.3).
3. **Fallback**: If the exact version is not found, use the closest version available or latest.

## 🧱 Maintainability

- **No Hardcoding**: Avoid magic strings/numbers. Use `constants` or `config` files.
- **Shared Logic**: Create `utils` or `helpers` or `libs` for logic used across the project.
- **Centralization**: Centralize global settings/configs/components to facilitate management.
- **Imports**: Use aliases (`@/`) and `index` files (barrelling) to shorten and clean up imports.
