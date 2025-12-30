---
description: Run tests and verify quality.
---

# Test Workflow

## 1. Test Execution

**Agent**: `test-engineer`
**Input**: Current codebase state.
**Task**:

- Run unit/integration tests.
- Check coverage.
- If `/bugfix`, verify reproduction test.

## Output

- Report: `.kira/plans/{slug}-test-report.md`
- Status: Pass/Fail
