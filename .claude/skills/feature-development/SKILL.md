---
name: feature-development
description: Master workflow for feature development phases.
---

# Feature Development

## 🔄 Workflow

1. **Analysis**: Requirement Analyst + Codebase Scout.
   - Output: Requirements & Codebase Analysis.
2. **Planning**: Solution Architect.
   - Output: Architecture Plan.
   - **Gate**: User Approval (if Complex).
3. **Implementation**: Senior Dev + Test Engineer.
   - Output: Code + Tests.
   - **Gate**: Tests Pass & Coverage > 80%.
4. **QA**: Code Reviewer.
   - Output: Review Report.
   - **Gate**: No Critical Issues.
5. **Finalize**: Docs Writer.
   - Output: Docs, Changelog, Commit.

## ⚠️ Key Rules

- **Handoff**: Agents read previous outputs from memory/files.
- **Validation**: Each phase validates input before starting.
- **Recovery**: If Gate fails, loop back to previous agent for fix.
