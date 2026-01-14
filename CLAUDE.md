# Project Context

## 🛠 Tech Stack

- **Language**: JavaScript (Node.js)
- **Runtime**: Node.js >= 18
- **Package Manager**: npm
- **Key Tools**: Prettier (auto-formatting)

## 📂 Directory Structure

- `/bin`: Contains CLI installer script (`install.js`)
- `/.claude`: Claude Code configuration
  - `/agents`: Agent definitions for specialized workflows (requirement-analyst, codebase-scout, solution-architect, senior-developer, code-reviewer, migration-analyst, bug-handler)
  - `/commands`: Slash command workflows (feature, bugfix, migrate, init)
  - `/skills`: Reusable skill modules (project-conventions, security-guidelines, frameworks-and-cloud)
  - `settings.json`: Claude Code settings (Prettier hook)
- `/.temp`: PRD templates for workflows (FEATURE_PRD_TEMPLATE, BUGFIX_PRD_TEMPLATE, MIGRATE_PRD_TEMPLATE)
- `/.mcp.json`: MCP server configuration (context7, serena, memory, git, AWS CDK, AWS documentation)

## 📏 Patterns & Conventions

- **File Naming**:
  - Install scripts: `install.js` (kebab-case)
  - Agent definitions: `kebab-case.md` (e.g., `codebase-scout.md`)
  - Skills: `kebab-case/SKILL.md` pattern
- **Code Style**:
  - Max line length: 100 characters
  - Tab size: 2 spaces
  - Prettier: Enabled (auto-format on Edit/Write via hook)
- **Early Return**: Prefer early returns to avoid deep nesting
- **Error Handling**: Descriptive error messages with context prefix
- **No Hardcoding**: Use constants/config files

## 🔑 Key Code Locations

- **Entry Point**: `bin/install.js` - CLI installer that copies `.claude`, `.temp`, and `.mcp.json` to target project
- **Agent Definitions**: `.claude/agents/*.md` - Define specialized AI agent roles and workflows
- **Command Workflows**: `.claude/commands/*.md` - Define slash command behavior (/feature, /bugfix, /migrate, /init)
- **Skills**: `.claude/skills/*/SKILL.md` - Shared conventions and guidelines
- **Templates**: `.temp/*.md` - PRD templates for feature, bugfix, and migration workflows

## 🚀 Package Information

- **Name**: sgt-claude-kit
- **Version**: 1.3.0
- **Description**: AI-Powered Feature Development Workflow for Claude Code
- **Binary**: `sgt-claude-kit` command (installs to project via npx)

## 📋 Workflow System

This package implements a structured development workflow with these paths:

1. **/feature**: requirement-analyst → codebase-scout → solution-architect (if FULL) → senior-developer → code-reviewer
2. **/bugfix**: bug-handler → senior-developer → code-reviewer
3. **/migrate**: migration-analyst → codebase-scout → solution-architect → senior-developer → code-reviewer
4. **/init**: codebase-scout → generates CLAUDE.md

## 🎯 Agent Roles

- **requirement-analyst**: Extracts User Story, Acceptance Criteria, and LITE/FULL complexity verdict
- **codebase-scout**: Explores codebase, finds patterns, stores findings in memory
- **solution-architect**: Creates implementation-plan.md for FULL complexity features
- **senior-developer**: Writes production code with minimal changes
- **code-reviewer**: Final quality gate (APPROVED/CHANGES REQUESTED)
- **migration-analyst**: Analyzes migration requirements with version/breaking-change assessment
- **bug-handler**: Analyzes bugs with severity/root cause/fix options

## 🔒 Security Guidelines

- OWASP Top 10 prevention
- Auth/session rules
- Injection prevention
- MUST BLOCK checklist for security issues
