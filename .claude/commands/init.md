---
description: "TRIGGER: New project setup OR after major architectural changes. FLOW: codebase-scout scans and generates CLAUDE.md. OUTPUT: Project context file in root directory for all agents to reference."
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

**System**: Notify user that `CLAUDE.md` has been created successfully. Do not show the content of the file.
