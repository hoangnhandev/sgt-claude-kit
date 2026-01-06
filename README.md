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
> 3. To search documentation effectively with Context7, get an API key [here](https://context7.com/docs/howto/api-keys#creating-api-keys).

## 🛠 Usage

Once installed, simply start Claude Code as usual:

```bash
claude
```

You will now have access to new slash commands and workflows.

### Available Commands

#### `/init` - Initialize Project Context

**Description**: Scans the codebase and generates a `CLAUDE.md` file containing project context for agents to reference.

**When to use**:

- When starting work on a new project
- After significant architectural changes
- When you want to refresh the project context

**Usage**:

```
/init
```

**Real-world Examples**:

```bash
# Example 1: Initialize context for a newly cloned project
> /init
# The agent will scan the entire codebase and create CLAUDE.md with info on tech stack, directory structure, patterns...

# Example 2: Refresh context after a major refactor
> /init
# After reorganizing directories or changing frameworks, run this to update the context

# Example 3: Update context when onboarding a new team member
> /init
# Create CLAUDE.md so new members can quickly understand the project
```

---

#### `/feature` - New Feature Development

**Description**: A complete workflow for developing new features, from requirement analysis → codebase exploration → planning → implementation → code review.

**When to use**:

- When adding a new feature to the project
- When there's an enhancement request from users or stakeholders

**Usage**:

```
/feature <feature description>
```

**Real-world Examples**:

```bash
# Example 1: Add authentication feature
> /feature Add login/register system with email and password, including form validation and session management

# Example 2: Create a dashboard component
> /feature Create a dashboard page showing user statistics with a line chart for monthly revenue and a pie chart for customer segments

# Example 3: Implement dark mode
> /feature Add dark/light mode toggle, save preference to localStorage, and automatically detect system preference
```

---

#### `/bugfix` - Bug Fixing

**Description**: A specialized workflow for diagnosing and fixing bugs, including root cause analysis, implementation, and review.

**When to use**:

- When receiving a bug report from a user
- When a bug is discovered during development
- When there's an error log that needs processing

**Usage**:

```
/bugfix <description of the bug or paste error log>
```

**Real-world Examples**:

```bash
# Example 1: Fix bug from error message
> /bugfix TypeError: Cannot read property 'map' of undefined at ProductList.tsx:45 when loading products page

# Example 2: Fix UI/UX bug
> /bugfix Submit button stays disabled after the first click and doesn't re-enable when the user edits the form

# Example 3: Fix business logic bug
> /bugfix Cart total calculation is wrong when applying multiple discount codes; discounts are not stacking correctly
```

---

#### `/migrate` - Framework/Library Migration

**Description**: A workflow for migrating frameworks or libraries, performed incrementally (screen-by-screen) with validation and rollback strategy.

**When to use**:

- When upgrading a major version of a framework
- When migrating from one library to another
- When performing a large refactor involving core patterns

**Usage**:

```
/migrate <description of the migration task>
```

**Real-world Examples**:

```bash
# Example 1: Upgrade React version
> /migrate Upgrade from React 17 to React 18, including updating breaking changes and adopting concurrent features

# Example 2: Migrate state management
> /migrate Move from Redux to Zustand for state management, migrating module by module starting with the user module

# Example 3: Migrate CSS framework
> /migrate Migrate from styled-components to Tailwind CSS, starting with shared components then moving to pages
```

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
