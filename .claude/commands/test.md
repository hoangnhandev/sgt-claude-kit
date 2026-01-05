---
description: Executes unit and integration tests to verify code quality. It uses the 'test-engineer' to run the test suite, check coverage, and validate fixes (especially for bug reproduction). Returns a Pass/Fail status and a report. Note: You must use the subagents specified in this command.
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

- Report: `.temp/plans/{slug}-test-report.md`
- Status: Pass/Fail
