# 🚀 Kira Agent

> **AI-Powered Feature Development Workflow cho Claude Code**

Kira Agent là một framework tự động hóa quy trình phát triển tính năng, tận dụng tối đa sức mạnh của Claude Code với các subagents chuyên biệt, skills domain-specific, và hooks tự động.

---

## ✨ Tính Năng Chính

- 🤖 **7 Subagents Chuyên Biệt** - Phân chia công việc theo chuyên môn
- 📚 **Skills Domain-Specific** - Kiến thức riêng cho từng project
- ⚡ **Hooks Automation** - Tự động format, lint, và log
- 🔌 **MCP Servers Integration** - Mở rộng capabilities
- 💻 **Custom Slash Commands** - Trigger workflow nhanh

---

## 📋 Mục Lục

- [Cài Đặt](#-cài-đặt)
- [Cách Sử Dụng](#-cách-sử-dụng)
- [Cấu Trúc Dự Án](#-cấu-trúc-dự-án)
- [Subagents](#-subagents)
- [Slash Commands](#-slash-commands)
- [Skills](#-skills)
- [Workflow](#-workflow)
- [Tùy Chỉnh](#-tùy-chỉnh)

---

## 🛠️ Cài Đặt

### Yêu Cầu

- [Claude Code](https://claude.ai/code) đã được cài đặt
- Node.js >= 18 (cho hooks formatting)
- Git

### Thiết Lập

1. **Clone hoặc copy cấu trúc vào project của bạn:**

```bash
git clone https://github.com/your-username/kira-agent.git
# Hoặc copy thư mục .claude và .kira vào project hiện tại
cp -r kira-agent/.claude your-project/
cp -r kira-agent/.kira your-project/
```

2. **Đảm bảo cấu trúc thư mục:**

```
your-project/
├── .mcp.json                # MCP Servers configuration (auto-loaded)
├── .claude/
│   ├── agents/              # Subagents
│   ├── commands/            # Slash commands
│   ├── skills/              # Domain knowledge
│   └── settings.json        # Hooks & Permissions
└── .kira/
    ├── inputs/              # Input requirements
    ├── plans/               # Generated plans
    ├── reviews/             # Code review reports
    └── logs/                # Session logs
```

3. **Khởi động Claude Code:**

```bash
claude
```

---

## 🚀 Cách Sử Dụng

### Chế Độ Local (File-based)

Sử dụng khi phát triển solo với requirements local:

```bash
# 1. Tạo file requirement
touch .kira/inputs/feature-user-auth.md
# Edit file với requirement details theo template

# 2. Mở Claude Code
claude

# 3. Chạy workflow
> /feature .kira/inputs/feature-user-auth.md

# 4. Xem kết quả
cat .kira/plans/user-auth-plan.md
cat .kira/reviews/user-auth-review.md
```

### Chế Độ GitHub

Sử dụng khi làm việc với GitHub Issues:

```bash
# Với issue number
> /feature #123

# Hoặc với URL đầy đủ
> /feature https://github.com/org/repo/issues/123
```

### Chạy Từng Phase Riêng Lẻ

```bash
# Chỉ phân tích requirement
> /analyze .kira/inputs/feature-xyz.md

# Chỉ lên kế hoạch (sau khi đã analyze)
> /plan .kira/inputs/feature-xyz.md

# Chỉ implement (khi đã có plan)
> /implement .kira/plans/xyz-plan.md

# Chỉ viết tests
> /test

# Chỉ review code
> /review
```

---

## 📁 Cấu Trúc Dự Án

```
project/
├── .mcp.json                          # MCP Servers (auto-loaded by Claude Code)
├── .claude/
│   ├── settings.json              # Hooks + Permissions
│   │
│   ├── agents/                    # Subagents (Workers)
│   │   ├── requirement-analyst.md      # Phân tích yêu cầu
│   │   ├── codebase-scout.md           # Khám phá codebase
│   │   ├── solution-architect.md       # Thiết kế solution
│   │   ├── senior-developer.md         # Triển khai code
│   │   ├── test-engineer.md            # Viết và chạy tests
│   │   ├── code-reviewer.md            # Review code
│   │   └── documentation-writer.md     # Viết docs
│   │
│   ├── skills/                    # Skills (Knowledge Base)
│   │   ├── project-conventions/        # Coding standards
│   │   ├── testing-strategy/           # Testing practices
│   │   ├── git-workflow/               # Git conventions
│   │   └── feature-development/        # Development workflow
│   │
│   └── commands/                  # Custom Slash Commands
│       ├── feature.md                  # /feature - Full workflow
│       ├── analyze.md                  # /analyze - Phân tích
│       ├── plan.md                     # /plan - Thiết kế
│       ├── implement.md                # /implement - Triển khai
│       ├── test.md                     # /test - Testing
│       └── review.md                   # /review - Review code
│
├── .kira/                         # Kira Agent Workspace
│   ├── inputs/                    # Input requirements
│   ├── plans/                     # Implementation plans
│   ├── reviews/                   # Code review reports
│   └── logs/                      # Workflow logs
│
└── [your-project-files]
```

---

## 🤖 Subagents

| Agent                    | Mô Tả                                                          | Tools                               | Model  |
| ------------------------ | -------------------------------------------------------------- | ----------------------------------- | ------ |
| **requirement-analyst**  | Phân tích yêu cầu, xác định scope và acceptance criteria       | Read, Grep, Glob, WebSearch         | Sonnet |
| **codebase-scout**       | Khám phá codebase, tìm files liên quan, phân tích dependencies | Read, Grep, Glob, Bash              | Sonnet |
| **solution-architect**   | Thiết kế technical solution, lên kế hoạch implementation       | Read, Grep, Glob, WebSearch         | Sonnet |
| **senior-developer**     | Triển khai code theo plan, áp dụng conventions                 | Read, Write, Edit, Bash, Grep, Glob | Sonnet |
| **test-engineer**        | Viết và chạy tests, đảm bảo coverage                           | Read, Write, Edit, Bash, Grep       | Sonnet |
| **code-reviewer**        | Review code, kiểm tra security và best practices               | Read, Grep, Glob, Bash              | Sonnet |
| **documentation-writer** | Cập nhật docs, thêm comments, update CHANGELOG                 | Read, Write, Edit, Grep             | Haiku  |

---

## ⚡ Slash Commands

| Command             | Mô Tả                                 | Phases                                                       |
| ------------------- | ------------------------------------- | ------------------------------------------------------------ |
| `/feature <input>`  | Chạy full workflow phát triển feature | Analysis → Planning → Implementation → Review → Finalization |
| `/analyze <input>`  | Chỉ phân tích requirement và codebase | Analysis only                                                |
| `/plan <input>`     | Thiết kế solution từ requirement      | Planning only                                                |
| `/implement <plan>` | Triển khai code theo plan có sẵn      | Implementation only                                          |
| `/test`             | Viết và chạy tests cho code mới       | Testing only                                                 |
| `/review`           | Review code changes hiện tại          | Review only                                                  |
| `/e2e <input>`      | Chạy E2E tests với Playwright MCP     | E2E Testing only                                             |

### Ví Dụ Sử Dụng

```bash
# Full workflow với file requirement local
> /feature .kira/inputs/add-payment-gateway.md

# Full workflow với GitHub issue
> /feature #42

# Chỉ phân tích requirement
> /analyze "Thêm tính năng export PDF cho báo cáo"

# Implement từ plan có sẵn
> /implement .kira/plans/payment-gateway-plan.md

# Review code đã thay đổi
> /review
```

---

## 📚 Skills

Skills là các file markdown chứa kiến thức domain-specific cho project:

| Skill                   | Mô Tả                                           |
| ----------------------- | ----------------------------------------------- |
| **project-conventions** | Coding style, naming conventions, import order  |
| **testing-strategy**    | Testing practices, coverage requirements        |
| **git-workflow**        | Branch naming, commit message format            |
| **feature-development** | Complete development workflow guide             |
| **e2e-testing**         | Playwright MCP patterns for browser E2E testing |

### Tùy Chỉnh Skills

Chỉnh sửa các file trong `.claude/skills/*/SKILL.md` để phù hợp với project của bạn:

```markdown
---
name: project-conventions
description: Coding conventions cho project
---

# Project Conventions

## Code Style

- Use Prettier for formatting
- Tab size: 2 spaces

## Naming

- Components: PascalCase
- Functions: camelCase
```

---

## 🔄 Workflow

### Sơ Đồ Tổng Quan

```
📥 Input (Issue/File/Text)
        │
        ▼
┌───────────────────────────────────────────┐
│  PHASE 1: ANALYSIS                        │
│  🔍 Requirement Analyst → Codebase Scout  │
└───────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│  PHASE 2: PLANNING                        │
│  📐 Solution Architect                    │
│  [Checkpoint: User approval nếu complex]  │
└───────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│  PHASE 3: IMPLEMENTATION                  │
│  💻 Senior Developer → 🧪 Test Engineer   │
│  [Hook: Auto-format, Run linter]          │
└───────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│  PHASE 4: QUALITY ASSURANCE               │
│  🔎 Code Reviewer                         │
│  [Checkpoint: Fix nếu có CRITICAL issues] │
└───────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│  PHASE 5: FINALIZATION                    │
│  📝 Documentation Writer → Git Commit     │
└───────────────────────────────────────────┘
        │
        ▼
📤 Output (Plan + Review + Logs)
```

### Quality Gates

| Gate          | Tiêu Chí                 | Hành Động Nếu Fail    |
| ------------- | ------------------------ | --------------------- |
| Plan Approval | Complex features         | Pause cho user review |
| Test Coverage | >= 80%                   | Block đến khi fix     |
| Code Review   | Không có CRITICAL issues | Re-implement          |
| Lint          | Không có errors          | Auto-fix hoặc block   |

---

## ⚙️ Tùy Chỉnh

### Hooks Configuration

Chỉnh sửa `.claude/settings.json` để customize hooks:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$file\""
          }
        ]
      }
    ]
  }
}
```

### Thêm Subagent Mới

Tạo file mới trong `.claude/agents/`:

```markdown
---
name: my-custom-agent
description: Mô tả agent
tools: Read, Write, Edit
model: sonnet
---

Bạn là [Role] với nhiệm vụ...

## Quy Trình:

1. Step 1
2. Step 2

## Output Format:

...
```

### Template Input

Sử dụng template khi tạo requirement mới (`.kira/inputs/`):

```markdown
# Feature Request: [Tên Feature]

## 1. Mô Tả

[Chi tiết feature]

## 2. User Story

As a [role], I want [feature], so that [benefit].

## 3. Acceptance Criteria

- [ ] Criteria 1
- [ ] Criteria 2

## 4. Priority

- [ ] Critical
- [ ] High
- [x] Medium
- [ ] Low
```

---

## 🔌 MCP Servers

Kira Agent sử dụng MCP (Model Context Protocol) để mở rộng capabilities. Project đã đóng gói sẵn cấu hình MCP trong file `.mcp.json`.

### MCP Servers Đã Cấu Hình

| Server         | Package                  | Mục Đích                   |
| -------------- | ------------------------ | -------------------------- |
| **context7**   | `@upstash/context7-mcp`  | Tra cứu documentation APIs |
| **playwright** | `@playwright/mcp@latest` | Browser automation, E2E    |

### Cách Hoạt Động

Khi bạn mở project với Claude Code, file `.mcp.json` sẽ được tự động nhận diện và các MCP servers sẽ được khởi động:

```bash
# Claude Code sẽ tự động load .mcp.json
claude

# Kiểm tra MCP servers đang chạy
> /mcp
```

### File `.mcp.json`

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {}
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "env": {}
    }
  }
}
```

### Thêm MCP Server Mới

**Cách 1: Sử dụng CLI**

```bash
# Thêm server vào project scope (lưu vào .mcp.json)
claude mcp add --transport http stripe --scope project https://mcp.stripe.com

# Thêm stdio server
claude mcp add my-server --scope project -- npx -y my-mcp-server
```

**Cách 2: Chỉnh sửa `.mcp.json` trực tiếp**

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### Environment Variables

File `.mcp.json` hỗ trợ environment variable expansion:

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

- `${VAR}` - Mở rộng giá trị của biến môi trường `VAR`
- `${VAR:-default}` - Sử dụng giá trị `default` nếu `VAR` không tồn tại

### MCP Scopes

| Scope       | File             | Sử Dụng                           |
| ----------- | ---------------- | --------------------------------- |
| **Project** | `.mcp.json`      | Chia sẻ với team, commit vào Git  |
| **User**    | `~/.claude.json` | Cá nhân, dùng cho nhiều projects  |
| **Local**   | `~/.claude.json` | Cá nhân, chỉ cho project hiện tại |

### Quản Lý MCP

```bash
# Liệt kê tất cả servers
claude mcp list

# Xem chi tiết server
claude mcp get context7

# Xóa server
claude mcp remove my-server

# Reset project choices (nếu từ chối nhầm)
claude mcp reset-project-choices
```

### MCP Servers Phổ Biến

| Server     | Package                                   | Mục Đích           |
| ---------- | ----------------------------------------- | ------------------ |
| GitHub     | `@modelcontextprotocol/server-github`     | Issues, PRs, Repos |
| PostgreSQL | `@modelcontextprotocol/server-postgres`   | Database queries   |
| Sentry     | Remote HTTP                               | Error monitoring   |
| Filesystem | `@modelcontextprotocol/server-filesystem` | File access        |

---

## 📊 Best Practices

### Khi Nào Dùng Full Workflow (`/feature`)

- ✅ Phát triển feature mới
- ✅ Thay đổi lớn, phức tạp
- ✅ Cần documentation đầy đủ

### Khi Nào Dùng Partial Workflow

- ⚡ Bug fixes đơn giản → `/implement` trực tiếp
- ⚡ Refactoring → Tạo command `/refactor` riêng
- ⚡ Hotfixes → Skip review phase

---

## 🤝 Đóng Góp

Mọi đóng góp đều được hoan nghênh! Vui lòng:

1. Fork repository
2. Tạo branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Tạo Pull Request

---

## 📝 License

MIT License - xem [LICENSE](LICENSE) để biết thêm chi tiết.

---

## 📞 Liên Hệ

- **Author**: Panda-B
- **Last Updated**: 2025-12-27

---

_Made with ❤️ using Claude Code_
