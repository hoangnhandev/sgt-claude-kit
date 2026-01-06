---
description: "TRIGGER: Framework/library migration request. FLOW: migration-analyst → codebase-scout → solution-architect → senior-developer → code-reviewer. OUTPUT: Incremental screen-by-screen migration with context7 documentation."
---

# Migration Workflow

## 📊 Risk Criteria

| Criteria              | LOW           | MEDIUM           | HIGH                   |
| --------------------- | ------------- | ---------------- | ---------------------- |
| **Scope**             | Single screen | Multiple screens | Core patterns / global |
| **Breaking Changes**  | 0-3 changes   | 4-6 changes      | 7+ changes             |
| **Shared Components** | Isolated      | Some shared      | Many shared            |

> **Note**: If ANY criteria qualifies as HIGH, use **screen-by-screen** strategy with feature flags.

## 🔄 Execution Flow

**Step 1: Migration Analysis**

- **Agent**: `migration-analyst`
- **Action**: Get source/target versions, query context7 for migration docs, assess risk.
- **Memory Output**: Create `migration-requirements` entity containing:
  - Source/Target Versions
  - Breaking Changes (from context7)
  - Risk Level & Strategy

**Step 2: Screen Inventory**

- **Agent**: `codebase-scout`
- **Memory Input**: Read `migration-requirements` from Memory.
- **Action**: List screens in scope, map dependencies, determine migration order.
- **Memory Output**: Create `migration-inventory` entity containing:
  - Screens List (ordered by priority)
  - Affected Patterns
  - Migration Order

**Step 3: Migration Plan**

- **Agent**: `solution-architect`
- **Memory Input**: Read `migration-requirements` and `migration-inventory` from Memory.
- **Action**: Design per-screen migration plan with rollback strategy.
- **Artifact**: Produce `.temp/plans/migration-plan.md`.

**Step 4: Incremental Implementation** (Loop per screen)

- **Agent**: `senior-developer`
- **Memory Input**: Read all Memory entities and `.temp/plans/migration-plan.md`.
- **Action**: Migrate ONE screen at a time. Validate with lint/build.
- **Memory Output**: Update `migration-progress` entity containing:
  - Current Screen & Status
  - Files Changed
  - Validation Results

**Step 5: Screen Review & User Approval**

- **Agent**: `code-reviewer`
- **Memory Input**: Read `migration-requirements` and `migration-progress` from Memory.
- **Action**: Review current screen's migration.
- **Verdict**: ✅ APPROVED | 🚫 CHANGES REQUESTED | ⏸️ PAUSE (critical issue)
- **User Gate**: After code review passes, **ASK USER** to manually verify the screen before proceeding.
  - User confirms → Continue to next screen (return to Step 4)
  - User requests changes → Return to Step 4 with feedback
  - User stops → Pause workflow and log progress

**Step 6: Final Verification** (After all screens)

- **Agent**: `senior-developer`
- **Memory Input**: Read all Memory entities and artifact.
- **Action**: Run final full-project validation to ensure system consistency. Create migration summary.
- **Memory Output**: Create `migration-summary` entity.

**Step 7: Final Sign-off**

- **Agent**: `code-reviewer`
- **Memory Input**: Read `migration-summary` and verify entire changes.
- **Action**: Check for legacy artifacts, overall consistency, and pass/fail of final validation.
- **Verdict**: ✅ MIGRATION COMPLETE | 🚫 FIXES NEEDED

## Memory Consistency Rules

- **Source of Truth**: The Memory Graph is the primary context carrier.
- **Mandatory Read**: Every agent MUST call `read_graph` or `search_nodes` at the start of their turn.
- **Structured Handoff**: Agents pass information via specific Entities (`migration-requirements`, `migration-inventory`) rather than just chat history.

## ⚠️ Error Handling

| Failure Point               | Action                                                         | Responsible Agent   |
| --------------------------- | -------------------------------------------------------------- | ------------------- |
| **context7 unavailable**    | Fallback to web search or ask user for doc links.              | `migration-analyst` |
| **Screen migration fails**  | Rollback that screen only, continue with next.                 | `senior-developer`  |
| **Build fails after merge** | Identify conflicting screen, revert and fix.                   | `senior-developer`  |
| **Missing Context**         | If required Memory entities are missing, STOP and notify user. | Any agent           |

### Rollback Procedure

If migration causes critical issues:

1. **Revert Screen**: `git checkout main -- [screen-files]`
2. **Revert All**: `git checkout -- .` to discard all uncommitted changes
3. **Log**: Store failure reason in Memory entity `failure-log`
4. **Notify**: Report to user with clear explanation of what went wrong
