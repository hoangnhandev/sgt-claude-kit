# Bug Analysis (Cheatsheet)

Full: `.claude/skills/bug-analysis/SKILL.md`

## 🔴 Severity

P0 (Critical) > P1 (High) > P2 (Medium) > P3 (Low)

## 🔍 Process

1. **Reproduce**: Define steps & env.
2. **Root Cause**: 5 Whys (Logic/State/Race).
3. **Fix**: Minimal change. Defensive coding.
4. **Verify**: Repro Test (Fail) -> Fix -> Repro Test (Pass).
