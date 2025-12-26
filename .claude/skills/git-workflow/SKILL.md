---
name: git-workflow
description: Git workflow and commit conventions. Apply when making commits, creating branches, or managing version control.
---

# Git Workflow

> Áp dụng workflow này khi làm việc với Git.

---

## 🌿 Branching Strategy

### Branch Naming

| Type    | Pattern                          | Example                          |
| ------- | -------------------------------- | -------------------------------- |
| Feature | `feature/{ticket}-{description}` | `feature/123-user-auth`          |
| Bug fix | `fix/{ticket}-{description}`     | `fix/456-login-error`            |
| Hotfix  | `hotfix/{description}`           | `hotfix/critical-security-patch` |
| Release | `release/{version}`              | `release/1.2.0`                  |
| Chore   | `chore/{description}`            | `chore/update-dependencies`      |

### Branch Flow

```
main (production)
  │
  └── develop (integration)
        │
        ├── feature/123-user-auth
        ├── feature/456-payment-flow
        └── fix/789-validation-error
```

---

## 📝 Commit Messages

### Conventional Commits Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type       | Description                  | Example                                           |
| ---------- | ---------------------------- | ------------------------------------------------- |
| `feat`     | New feature                  | `feat(auth): add Google OAuth login`              |
| `fix`      | Bug fix                      | `fix(api): resolve race condition in user update` |
| `docs`     | Documentation                | `docs(readme): add API usage examples`            |
| `style`    | Formatting (no code change)  | `style(components): fix indentation`              |
| `refactor` | Code change (no feature/fix) | `refactor(utils): simplify date formatting`       |
| `test`     | Adding/updating tests        | `test(auth): add login flow tests`                |
| `chore`    | Maintenance                  | `chore(deps): update dependencies`                |
| `perf`     | Performance improvement      | `perf(api): add caching for user queries`         |
| `ci`       | CI/CD changes                | `ci(github): add deployment workflow`             |
| `build`    | Build system changes         | `build(vite): optimize bundle size`               |

### Scope (Optional)

Common scopes:

- `auth` - Authentication
- `api` - API layer
- `ui` - User interface
- `db` - Database
- `config` - Configuration
- `deps` - Dependencies

### Examples

```bash
# Simple feature
git commit -m "feat(auth): add password reset functionality"

# Bug fix with issue reference
git commit -m "fix(api): resolve null pointer in user service

The user service was throwing NPE when email was not provided.
Added null check before processing.

Closes #123"

# Breaking change
git commit -m "feat(api)!: change authentication endpoint

BREAKING CHANGE: The /auth/login endpoint now requires
email instead of username. Update all clients accordingly."

# Multiple changes (use body)
git commit -m "refactor(utils): reorganize helper functions

- Move date utils to separate file
- Add type definitions for all functions
- Remove deprecated functions
- Update imports across codebase"
```

---

## 🔄 Workflow Commands

### Starting New Work

```bash
# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/123-user-auth

# Or from develop
git checkout develop
git pull origin develop
git checkout -b feature/123-user-auth
```

### During Development

```bash
# Stage changes
git add -A                    # All changes
git add src/services/*.ts     # Specific files
git add -p                    # Interactive staging

# Commit with message
git commit -m "feat(auth): add login form component"

# Amend last commit (before push)
git commit --amend -m "feat(auth): add login form with validation"

# Push to remote
git push origin feature/123-user-auth
```

### Keeping Branch Updated

```bash
# Rebase onto latest main
git fetch origin
git rebase origin/main

# Resolve conflicts if any
# After resolving:
git add .
git rebase --continue

# Force push after rebase
git push origin feature/123-user-auth --force-with-lease
```

### Before Creating PR

```bash
# Squash commits (optional, for clean history)
git rebase -i HEAD~3  # Last 3 commits

# Run tests
npm run test

# Run linter
npm run lint

# Update from main
git fetch origin
git rebase origin/main
git push origin feature/123-user-auth --force-with-lease
```

---

## 🔀 Pull Request Guidelines

### PR Title Format

```
<type>(<scope>): <description> (#ticket)
```

Examples:

- `feat(auth): add Google OAuth login (#123)`
- `fix(api): resolve validation error (#456)`

### PR Description Template

```markdown
## Summary

[Brief description of changes]

## Changes

- [Change 1]
- [Change 2]
- [Change 3]

## Testing

- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing completed

## Checklist

- [ ] Code follows project conventions
- [ ] Documentation updated
- [ ] No console.log statements
- [ ] No TODO comments left

## Screenshots (if applicable)

[Add screenshots]

## Related Issues

Closes #123
```

---

## ⚠️ Git Best Practices

### DO ✅

1. **Commit often** - Small, focused commits
2. **Write descriptive messages** - Future you will thank you
3. **Use branches** - Never commit directly to main
4. **Pull before push** - Stay updated with remote
5. **Review your own code** - `git diff` before commit
6. **Use .gitignore** - Don't commit generated files

### DON'T ❌

1. **Don't commit secrets** - Use environment variables
2. **Don't force push to shared branches** - Use `--force-with-lease`
3. **Don't commit large files** - Use Git LFS if needed
4. **Don't mix formatting with logic changes** - Separate commits
5. **Don't leave WIP commits** - Squash before PR

---

## 🛠️ Useful Git Commands

### Undo Changes

```bash
# Discard unstaged changes
git checkout -- <file>
git restore <file>

# Unstage file (keep changes)
git reset HEAD <file>
git restore --staged <file>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert a pushed commit
git revert <commit-hash>
```

### View History

```bash
# Pretty log
git log --oneline -n 10

# Log with graph
git log --oneline --graph --all

# View file history
git log -p <file>

# Find who changed a line
git blame <file>
```

### Stash Changes

```bash
# Stash current changes
git stash

# Stash with message
git stash save "WIP: working on auth"

# List stashes
git stash list

# Apply most recent stash
git stash pop

# Apply specific stash
git stash apply stash@{2}
```

### Clean Up

```bash
# Delete merged branches
git branch --merged | grep -v main | xargs git branch -d

# Prune remote tracking branches
git fetch --prune

# Clean untracked files (dry run first)
git clean -n
git clean -fd
```

---

## 📋 Pre-Commit Checklist

Before every commit:

- [ ] Code compiles without errors
- [ ] Tests pass
- [ ] Linter passes
- [ ] No console.log/debugger statements
- [ ] No TODO/FIXME left unaddressed
- [ ] Commit message follows convention
- [ ] Files are properly staged (no unintended changes)

---

_Follow this workflow for clean, maintainable version control._
