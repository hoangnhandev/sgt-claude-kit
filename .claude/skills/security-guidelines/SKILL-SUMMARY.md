# Security Guidelines (Cheatsheet)

Full: `.claude/skills/security-guidelines/SKILL.md`

## 🛡️ Critical Checks

1. **Injection**: No raw SQL. No `eval()`. Use param queries.
2. **XSS**: No `dangerouslySetInnerHTML`. Sanitize user inputs.
3. **Secrets**: NO hardcoded keys/tokens. Use `.env`.
4. **Auth**: Verify ownership before data access. Check roles.
5. **Data**: No exposing PII/Credentials in logs/responses.
