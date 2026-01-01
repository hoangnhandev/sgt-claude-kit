---
name: security-guidelines
description: Security Protocols & Checklists. MUST BE LOADED by Code Reviewer and Senior Developer when handling authentication, data privacy, or external inputs. Contains critical "MUST BLOCK" rules.
---

# 🛡️ Security Guidelines

> Apply these guidelines strictly to ensure application security (OWASP Top 10).

## 1. 🔐 Authentication & Session

- **Passwords**: Hashing (bcrypt cost 12+). KHÔNG lưu plaintext.
- **Cookies**: `httpOnly: true`, `secure: true`, `sameSite: "lax"`.
- **Storage**: NEVER store tokens in `localStorage`. Use HttpOnly Cookies.
- **Protection**: Rate limiting (5 attempts/min/IP). Generic error messages.

## 2. 🛡️ Injection Prevention

- **SQL**: Use Parameterized queries or ORM (Prisma). No string concatenation.
- **XSS**: No `dangerouslySetInnerHTML`. Use `textContent` or SANITIZE (DOMPurify).
- **Command**: Avoid shell exec with user input. Use `execFile` with args.

## 3. 🔒 Data Protection

- **Logging**: NEVER log passwords, tokens, or PII. Redact sensitive fields.
- **API**: Select only needed fields. Use DTOs/Serialization layer.
- **Secrets**: Use Environment Variables (.env). No hardcoded keys.

## 4. 🌐 Authorization (IDOR)

- **Ownership**: Always verify user owns the resource before Access/Edit/Delete.
- **Ownership Verification**: `where: { id: resourceId, userId: currentUser.id }`.

## 5. 📦 Dependencies

- **Audit**: `npm audit` regularly.
- **Rules**: Pin major versions. Use well-maintained packages.

## ✅ Security Review Checklist

### 🔴 MUST BLOCK (Critical)

- SQL concatenation or raw Shell exec with user input.
- Hardcoded credentials or logging sensitive data.
- Missing ownership checks on private resources.
- Secrets committed to repository.

### 🟡 SHOULD FIX (Warning)

- Missing rate limiting on public APIs.
- High vulnerabilities in `npm audit`.
- Missing security headers (CSP, HSTS).

_Updated regularly based on new vulnerabilities. Last updated: 2025-12-27_
