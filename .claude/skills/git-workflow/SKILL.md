---
name: git-workflow
description: Git & Commit Standards. LOAD this skill when creating branches, writing commit messages, or managing PRs. Defines the exact formatting rules for version control.
---

# Git Workflow

## 🌿 Branching

- **Naming**: `feature/{id}-slug`, `fix/{id}-slug`, `chore/desc`.
- **Flow**: `main` -> `feature/` -> `PR` -> `main`.

## 📝 Commit Messages

Based on [Conventional Commits](https://www.conventionalcommits.org/):
Format: `<type>(<scope>): <subject>`

### Types

- **feat**: New feature (`feat(auth): login`)
- **fix**: Bug fix (`fix(api): crash`)
- **docs**: Documentation (`docs: readme`)
- **refactor**: Code change without logic change
- **test**: Add/Update tests
- **chore**: Deps, build, tools

### Rules

1. **Subject**: Imperative ("Add" not "Added"). No period.
2. **Body**: "Fixes #123" if applicable.
3. **Scope**: Optional but recommended (`api`, `ui`, `db`).

## 🔄 Workflow

1. **Start**: `git checkout -b feature/123-login`
2. **Work**:
   - `git add -p` (Interactive staging)
   - `npm run lint` && `npm run test`
3. **Commit**: `git commit -m "feat(auth): implement login"`
4. **Push**: `git push origin feature/123-login`

## ⚠️ Best Practices

- **Atomic Commits**: One logical change per commit.
- **No Secrets**: Check `.env` usage.
- **Rebase**: Keep history clean before PR.
