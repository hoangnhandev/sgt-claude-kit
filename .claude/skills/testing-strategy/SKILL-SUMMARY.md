# Testing Strategy (Cheatsheet)

Full: `.claude/skills/testing-strategy/SKILL.md`

## 📊 Thresholds

- **Coverage**: Min **80%** overall. 95% for Critical logic.
- **Gate**: Block merge if ANY test fails.

## 🧪 Approaches

1. **Unit**: Logic isolation. Mock DB/API. Focus: Services, Utils.
2. **Component**: UI behavior. Mock hooks. Focus: User Interactions.
3. **Integration**: Happy paths. Real DB (optional). Focus: API Flows.
4. **Reproduction**: Create failing test -> Fix -> Verify pass.
