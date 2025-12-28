---
name: git-workflow-summary
description: Quick reference for Git conventions. Read SKILL.md for full details.
---

# Git Workflow (Quick Reference)

> 📖 **Full details**: `.claude/skills/git-workflow/SKILL.md`

---

## 🌿 Branch Naming

| Type    | Pattern                          | Example                 |
| ------- | -------------------------------- | ----------------------- |
| Feature | `feature/{ticket}-{description}` | `feature/123-user-auth` |
| Bug fix | `fix/{ticket}-{description}`     | `fix/456-login-error`   |
| Hotfix  | `hotfix/{description}`           | `hotfix/security-patch` |
| Chore   | `chore/{description}`            | `chore/update-deps`     |

---

## 📝 Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer: Closes #123]
```

### Types

| Type       | Use For                      |
| ---------- | ---------------------------- |
| `feat`     | New feature                  |
| `fix`      | Bug fix                      |
| `docs`     | Documentation                |
| `refactor` | Code change (no feature/fix) |
| `test`     | Adding/updating tests        |
| `chore`    | Maintenance, dependencies    |

### Examples

```bash
git commit -m "feat(auth): add Google OAuth login"
git commit -m "fix(api): resolve null pointer in user service"
git commit -m "docs(readme): add API usage examples"
```

---

## ⚠️ Key Rules

### DO ✅

- Commit often (small, focused commits)
- Write descriptive messages
- Use branches (never commit to main directly)
- Review your code before commit (`git diff`)

### DON'T ❌

- Commit secrets
- Force push to shared branches
- Leave WIP commits (squash before PR)
- Mix formatting with logic changes

---

## ✅ Pre-Commit Checklist

- [ ] Code compiles without errors
- [ ] Tests pass
- [ ] Linter passes
- [ ] No console.log/debugger
- [ ] Commit message follows convention
