---
description: Analyze requirements and codebase for a new feature.
---

# Analyze Workflow

## 1. Analysis Phase (Parallel Execution)

**Strategy**: Run both agents concurrently to optimize time.

### Requirement Analysis Thread

**Agent**: `requirement-analyst`
**Input**: Feature request / Issue.
**Task**: Parse requirements into structured specs, user stories, and acceptance criteria.

### Codebase Scouting Thread

**Agent**: `codebase-scout`
**Input**: Feature request / Issue.
**Task**: Search for relevant files, dependencies, and potential impact areas based on the feature request keywords.

## Output

- Memory: Requirements & Codebase Analysis entities.
- Ready for: `/plan`
