---
name: security-guidelines-summary
description: Quick reference for security best practices. Read SKILL.md for full details.
---

# Security Guidelines (Quick Reference)

> 📖 **Full details**: `.claude/skills/security-guidelines/SKILL.md`

---

## 🔐 Authentication

| Rule             | Requirement                        |
| ---------------- | ---------------------------------- |
| Password hashing | bcrypt (cost 12+), NEVER plaintext |
| Token storage    | HttpOnly cookies, NOT localStorage |
| Rate limiting    | 5 attempts/minute/IP               |
| Generic messages | "Invalid credentials" only         |

---

## 🛡️ Injection Prevention

```typescript
// ❌ SQL Injection - NEVER
const query = `SELECT * FROM users WHERE email = '${userInput}'`;

// ✅ Use parameterized queries
const user = await prisma.user.findUnique({ where: { email: userInput } });

// ❌ XSS - NEVER
element.innerHTML = userInput;
<div dangerouslySetInnerHTML={{ __html: userInput }} />;

// ✅ Use textContent or sanitize
element.textContent = userInput;
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />;
```

---

## 🔒 Data Protection

| Data Type | Storage Rule        | Logging Rule |
| --------- | ------------------- | ------------ |
| Passwords | Hash only           | ❌ Never log |
| API Keys  | Environment vars    | ❌ Never log |
| Tokens    | HttpOnly cookies    | ❌ Never log |
| PII       | Encrypt if required | ⚠️ Mask      |

---

## 🔍 Always Verify Ownership (IDOR)

```typescript
// ❌ WRONG - No ownership check
const order = await prisma.order.findUnique({ where: { id: req.params.id } });

// ✅ CORRECT - Verify user owns resource
const order = await prisma.order.findUnique({
  where: { id: req.params.id, userId: req.user.id },
});
```

---

## 🚨 Critical Checks (MUST BLOCK)

- SQL concatenation with user input
- Hardcoded credentials/secrets
- Unsanitized dangerouslySetInnerHTML
- Logging passwords/tokens/API keys
- Missing ownership check on private resources
- Secrets committed to repository

---

## ✅ Quick Checklist

- [ ] No hardcoded secrets
- [ ] Parameterized queries used
- [ ] HttpOnly cookies for tokens
- [ ] Input sanitized before HTML render
- [ ] Ownership verified for resources
- [ ] Sensitive data not logged
