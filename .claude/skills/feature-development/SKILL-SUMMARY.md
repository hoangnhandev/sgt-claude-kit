---
name: feature-development-summary
description: Quick reference for feature development workflow. Read SKILL.md for full details.
---

# Feature Development (Quick Reference)

> 📖 **Full details**: `.claude/skills/feature-development/SKILL.md`

---

## 🔄 Workflow Phases

```
📥 INPUT → Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → 📤 OUTPUT
          Analysis   Planning   Implement   QA       Finalize
```

---

## 📋 Phase Summary

| Phase | Subagents                           | Output                        | Quality Gate              |
| ----- | ----------------------------------- | ----------------------------- | ------------------------- |
| 1     | requirement-analyst, codebase-scout | requirements.md, analysis.md  | None                      |
| 2     | solution-architect                  | architecture.md               | ⏸️ User review if !Simple |
| 3     | senior-developer, test-engineer     | code + tests + reports        | ❌ Block if tests fail    |
| 4     | code-reviewer                       | review.md                     | ❌ Block if CRITICAL      |
| 5     | documentation-writer                | docs, git commit, session log | None                      |

---

## 🚦 Quality Gates

1. **Plan Approval** (After Phase 2): Medium/Complex/Critical → User review
2. **Tests Pass** (After Phase 3): Fail or coverage < 80% → Block
3. **No Critical** (After Phase 4): CRITICAL issues → Block, fix, re-review

---

## 📁 Output Structure

```
.kira/
├── plans/
│   ├── {feature}-requirements.md
│   ├── {feature}-codebase-analysis.md
│   ├── {feature}-architecture.md
│   ├── {feature}-implementation-report.md
│   ├── {feature}-test-report.md
│   └── plan-{feature}.md
├── reviews/
│   └── {feature}-review.md
└── logs/
    └── session-{timestamp}.md
```

---

## 🎮 Commands

| Command             | Phases | Description           |
| ------------------- | ------ | --------------------- |
| `/feature <req>`    | 1→5    | Full workflow         |
| `/analyze <req>`    | 1      | Analysis only         |
| `/plan <slug>`      | 2      | Planning only         |
| `/implement <slug>` | 3→5    | Implement to complete |
| `/review`           | 4      | Code review only      |

---

## ✅ Completion Checklist

- [ ] All phases executed
- [ ] Tests pass (coverage >= 80%)
- [ ] Code review approved
- [ ] Documentation updated
- [ ] Git commit created
