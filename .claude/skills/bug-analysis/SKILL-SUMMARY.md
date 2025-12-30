# Bug Analysis Skill - Summary

> **Quick reference for bug analysis patterns and techniques**

---

## Severity Classification

| Severity    | Priority | Response    | Example                          |
| ----------- | -------- | ----------- | -------------------------------- |
| 🔴 Critical | P0       | Immediate   | Security, data loss, system down |
| 🟠 High     | P1       | < 24h       | Core feature broken              |
| 🟡 Medium   | P2       | < 1 week    | Has workaround                   |
| 🟢 Low      | P3       | Next sprint | Cosmetic, edge case              |

---

## Root Cause Categories

- **Logic Error**: Wrong algorithm/condition
- **State Error**: Invalid state transition
- **Data Error**: Null/undefined, type mismatch
- **Race Condition**: Timing/async issues
- **Integration Error**: API mismatch
- **Edge Case**: Unhandled boundary
- **Config Error**: Wrong settings

---

## Investigation Checklist

```
□ Read bug report fully
□ Identify reproduction steps
□ Trace execution path
□ Locate error point
□ Understand WHY (not just where)
□ Propose fix options
□ Assess risk & complexity
```

---

## Fix Principles

1. **Minimal Change** - Fix only the bug
2. **Root Cause** - Address cause, not symptom
3. **Document** - Add inline comment
4. **Test** - Write reproduction test

---

## Risk Levels

| Risk   | Scope           | Action                   |
| ------ | --------------- | ------------------------ |
| High   | Shared/external | Full test suite + manual |
| Medium | Feature scope   | Unit + integration tests |
| Low    | Isolated        | Unit test only           |

---

## Quick Patterns

**Null Check Fix**:

```typescript
// Fix for bug #123: Handle null user case
const name = user?.name ?? "Unknown";
```

**Race Condition Fix**:

```typescript
// Fix for bug #456: Debounce rapid inputs
const debouncedHandler = debounce(handler, 300);
```

**Validation Fix**:

```typescript
// Fix for bug #789: Validate input before processing
if (!isValid(input)) {
  throw new ValidationError("Invalid input");
}
```

---

_For full details, see `.claude/skills/bug-analysis/SKILL.md`_
