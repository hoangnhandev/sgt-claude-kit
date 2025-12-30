# Project Conventions (Cheatsheet)

Full: `.claude/skills/project-conventions/SKILL.md`

## 📁 Naming

- **Files**: `UserCard.tsx` (Components), `date-utils.ts` (Utils), `useAuth.ts` (Hooks).
- **Code**: `userName` (vars), `MAX_RETRIES` (consts), `UserService` (classes), `isActive` (bools).

## ⚠️ Key Rules

1. **Types**: No `any`. Use `unknown` or specific types.
2. **React**: Hooks -> State -> Effects -> Render.
3. **Tests**: AAA pattern. `describe` -> `it`.
4. **Style**: Max 100 chars user line. 2 spaces indent. Imports: Libs -> Internal -> Relative.
