---
description: Initializes or refreshes the project context by generating the `CLAUDE.md` file. Run this at the start of a project or after major architectural changes.
---

# Init / Context Refresh Workflow

## 1. Context Generation

**Agent**: `codebase-scout`
**Task**:

1. Scan the codebase (root files, key directories).
2. Synthesize Tech Stack, Directory Structure, Patterns, and Conventions.
3. **Generate/Overwrite `CLAUDE.md`** in the project root.

**Output template for `CLAUDE.md`**:

```markdown
# Project Context

## 🛠 Tech Stack

- **Language**: ...
- **Framework**: ...
- **Key Libs**: ...

## 📂 Directory Structure

- `/src`: ...
- `/components`: ...

## 📏 Patterns & Conventions

- **Styling**: ...
- **State Management**: ...
- **API**: ...

## 🔑 Key Code Locations

- **Entry**: ...
- **Config**: ...
- **Utils**: ...
```

## 2. Confirmation

**System**: Notify user that context is ready in `CLAUDE.md`.
