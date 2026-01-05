# SGT Claude Kit

SGT Claude Kit transforms your Claude Code experience by injecting specialized AI agents and structured workflows directly into your project. It acts as a plugin for Claude Code, setting up a defined process for feature development, bug fixing, and code quality assurance.

## 🚀 Features

- **Structured Workflows**: Pre-defined workflows for common tasks (`/feature`, `/bugfix`, `/plan`).
- **Specialized Agents**: Custom agents configured for specific roles (Implementation, Review, QA).
- **Automated Setup**: Instantly scaffolds your project with the necessary `.claude` and `.temp` configurations.
- **Tools Integration**: Comes with pre-configured MCP tool definitions.

## 📦 Installation

Run the following command in your project root:

```bash
npx sgt-claude-kit
```

This command will copy the necessary configuration files (`.claude`, `.temp`, `.mcp.json`) into your current directory.

> **Notes**:
>
> 1. To use MCP features, you must install [`uvx`](https://docs.astral.sh/uv/getting-started/installation/).
> 2. You must configure the project path for Serena.

## 🛠 Usage

Once installed, simply start Claude Code as usual:

```bash
claude
```

You will now have access to new slash commands and workflows.

### Available Commands

- **/feature**: Start a new feature development workflow. Usually involves planning, implementation, and review.
- **/bugfix**: specialized workflow for diagnosing and fixing bugs.
- **/plan**: Generate a detailed implementation plan.
- **/analyze**: Analyze the codebase or specific files.
- **/review**: Request a code review for your changes.
- **/test**: Run tests and diagnose failures.
- **/e2e**: Run end-to-end tests.

## 📂 Project Structure

The installer adds the following to your project:

- **.claude/**: Contains the agent definitions (`agents/`), slash command workflows (`commands/`), and settings.
- **.temp/**: Stores Kira-specific templates and configurations (e.g., `PRD_TEMPLATE.md`).
- **.mcp.json**: Configuration for Model Context Protocol (MCP) servers.

## 🤝 Contributing

Contributions are welcome! Please examine the `package.json` and scripts to understand the structure.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
