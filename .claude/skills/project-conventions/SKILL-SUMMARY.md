---
name: project-conventions-summary
description: Quick reference for coding conventions. Read SKILL.md for full details.
---

# Project Conventions (Quick Reference)

> 📖 **Full details**: `.claude/skills/project-conventions/SKILL.md`

---

## 📁 File Naming

| Type       | Convention      | Example             |
| ---------- | --------------- | ------------------- |
| Components | PascalCase      | `UserCard.tsx`      |
| Hooks      | camelCase + use | `useAuth.ts`        |
| Utilities  | kebab-case      | `date-utils.ts`     |
| Tests      | + `.test`       | `UserCard.test.tsx` |

---

## 🎨 Naming Conventions

| Element   | Convention       | Example                 |
| --------- | ---------------- | ----------------------- |
| Variables | camelCase        | `userName`, `isLoading` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES`           |
| Functions | camelCase        | `getUserById`           |
| Classes   | PascalCase       | `UserService`           |
| Booleans  | is/has/can       | `isActive`, `hasError`  |

---

## 📝 Imports Order

```typescript
// 1. External packages (React, libraries)
// 2. Internal aliases (@/)
// 3. Relative imports
// 4. Type imports
// 5. Style imports
```

---

## ⚠️ Key Rules

- **Line length**: Max 100 characters
- **Tab size**: 2 spaces
- **TypeScript**: Avoid `any`, use `unknown` if needed
- **Errors**: Descriptive messages with context
- **React**: Hooks first, then derived state, effects, handlers, render
- **Tests**: AAA pattern (Arrange, Act, Assert)
- **Comments**: Explain WHY, not WHAT

---

## ✅ Quick Checklist

- [ ] Naming follows conventions
- [ ] Imports are ordered correctly
- [ ] No `any` types
- [ ] Error messages are descriptive
- [ ] Boolean variables have prefix (is/has/can)
