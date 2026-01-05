---
description: Executes End-to-End (E2E) tests using Playwright. It sets up the environment and instructs the 'test-engineer' to perform browser-based testing scenarios to verify full application workflows. Note: You must use the subagents specified in this command.
---

# E2E Testing Workflow

## 1. Setup

**Agent**: `test-engineer` (Mode: E2E)
**Task**: Check env, launch browser.

## 2. Execute

**Agent**: `test-engineer`
**Tools**: Use Playwright MCP (`navigate`, `click`, `screenshot`).
**Task**: Run scenario steps.

## 3. Report

**Output**: Pass/Fail with screenshots.
