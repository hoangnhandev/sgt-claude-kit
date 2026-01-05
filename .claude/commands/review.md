---
description: Conducts a formal code review using the 'code-reviewer' agent. It analyzes git diffs for security, logic, and style issues, producing a report with approval status or requested changes. Note: You must use the subagents specified in this command.
---

# Review Workflow

## 1. Review

**Agent**: `code-reviewer`
**Input**: Git diff.
**Task**: Check Security, Logic, Style.

## 2. Output

**Status**: `Approved` or `Changes Requested`.
**Artifact**: Review Report.
