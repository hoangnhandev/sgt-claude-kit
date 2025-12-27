---
name: security-guidelines
description: Security standards and best practices for code review and implementation. Apply when reviewing code security or implementing sensitive features.
---

# 🛡️ Security Guidelines

> Áp dụng chặt chẽ các quy tắc này để đảm bảo ứng dụng an toàn trước các lỗ hổng phổ biến (OWASP Top 10) và bảo vệ dữ liệu người dùng.

---

## 1. 🔐 Authentication & Session Management

### Password Policy

| Requirement        | Standard               | Notes                       |
| ------------------ | ---------------------- | --------------------------- |
| **Hashing**        | bcrypt (cost 12+)      | KHÔNG BAO GIỜ lưu plaintext |
| **Minimum Length** | 8 characters           | Bắt buộc                    |
| **Complexity**     | Upper + Lower + Number | Khuyến nghị                 |
| **History**        | No reuse of last 3     | Cho hệ thống Enterprise     |

### Token & Cookie Security

```typescript
// ✅ Correct: HttpOnly cookie settings
const cookieOptions = {
  httpOnly: true, // Prevent XSS access
  secure: true, // HTTPS only
  sameSite: "lax", // CSRF protection
  maxAge: 15 * 60, // 15 minutes for access token
  path: "/",
};

// ❌ WRONG: Never store in localStorage
localStorage.setItem("token", jwt); // XSS vulnerable!
```

### Token Lifetime

| Token Type    | Lifetime   | Storage              |
| ------------- | ---------- | -------------------- |
| Access Token  | 15-30 min  | HttpOnly Cookie      |
| Refresh Token | 7 days     | HttpOnly Cookie + DB |
| Verification  | 1-24 hours | Database only        |

### Login Protection

- **Rate Limiting**: 5 attempts/minute/IP (mandatory)
- **Account Lockout**: Lock 15-30 min after 5 failed attempts
- **Generic Messages**: "Invalid credentials" (don't reveal if user exists)

---

## 2. 🛡️ Injection Prevention

### SQL Injection (Critical)

```typescript
// ❌ DANGEROUS: String concatenation
const query = `SELECT * FROM users WHERE email = '${userInput}'`;

// ✅ SAFE: Parameterized query (Prisma)
const user = await prisma.user.findUnique({
  where: { email: userInput },
});

// ✅ SAFE: Parameterized query (Raw SQL)
const users = await db.query("SELECT * FROM users WHERE email = $1", [
  userInput,
]);
```

### Command Injection

```typescript
// ❌ DANGEROUS: Direct user input in shell
exec(`ls ${userInput}`);

// ✅ SAFE: Use library with sanitization
import { execFile } from "child_process";
execFile("ls", [sanitizedPath]);
```

### XSS Prevention

```typescript
// ❌ DANGEROUS: Unescaped HTML
element.innerHTML = userInput;
<div dangerouslySetInnerHTML={{ __html: userInput }} />;

// ✅ SAFE: Use textContent or sanitize
element.textContent = userInput;
import DOMPurify from "dompurify";
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />;
```

---

## 3. 🔒 Data Protection

### Sensitive Data Handling

| Data Type    | Storage Rule                  | Logging Rule   |
| ------------ | ----------------------------- | -------------- |
| Passwords    | Hash only (never plaintext)   | ❌ Never log   |
| API Keys     | Environment variables         | ❌ Never log   |
| Tokens       | HttpOnly cookies              | ❌ Never log   |
| PII          | Encrypt at rest (if required) | ⚠️ Mask/Redact |
| Credit Cards | Use payment provider (Stripe) | ❌ Never store |

### Logging Guidelines

```typescript
// ❌ WRONG: Logging sensitive data
console.log("Login attempt:", { email, password, token });
logger.info("User data:", user);

// ✅ CORRECT: Redact sensitive fields
console.log("Login attempt:", { email, password: "[REDACTED]" });
logger.info("User data:", { id: user.id, email: user.email });
```

### API Response Security

```typescript
// ❌ WRONG: Exposing sensitive fields
return res.json(user); // May include passwordHash!

// ✅ CORRECT: Select only needed fields
return res.json({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role,
});

// ✅ BETTER: Use serialization layer
return res.json(UserDTO.fromEntity(user));
```

---

## 4. 🌐 Configuration Security

### Environment Variables

```bash
# .gitignore - MUST include:
.env
.env.local
.env.*.local
*.pem
*.key
```

```typescript
// ❌ WRONG: Hardcoded secrets
const API_KEY = "sk-1234567890abcdef";
const JWT_SECRET = "my-secret-key";

// ✅ CORRECT: Environment variables
const API_KEY = process.env.API_KEY;
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) throw new Error("JWT_SECRET is required");
```

### Security Headers (Helmet.js)

```typescript
import helmet from "helmet";

app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'"], // Tighten for production
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "https:"],
      },
    },
    hsts: { maxAge: 31536000, includeSubDomains: true },
    noSniff: true,
    frameguard: { action: "deny" },
  })
);
```

---

## 5. 🔍 Authorization (IDOR Prevention)

### Always Verify Ownership

```typescript
// ❌ WRONG: Trust user input for resource access
app.get("/api/orders/:id", async (req, res) => {
  const order = await prisma.order.findUnique({
    where: { id: req.params.id },
  });
  return res.json(order); // Anyone can access any order!
});

// ✅ CORRECT: Verify user owns the resource
app.get("/api/orders/:id", async (req, res) => {
  const order = await prisma.order.findUnique({
    where: {
      id: req.params.id,
      userId: req.user.id, // Ensure ownership
    },
  });
  if (!order) return res.status(404).json({ error: "Not found" });
  return res.json(order);
});
```

---

## 6. 📦 Dependency Security

### Regular Audits

```bash
# Check for vulnerabilities
npm audit

# Fix automatically (when safe)
npm audit fix

# Check for outdated packages
npm outdated
```

### Dependency Rules

- ✅ Use well-maintained packages (check last update, stars, issues)
- ✅ Pin major versions in package.json
- ✅ Review changelogs before major updates
- ❌ Avoid packages with known HIGH/CRITICAL vulnerabilities
- ❌ Avoid unmaintained packages (no updates > 1 year)

---

## 7. ✅ Security Review Checklist

### Critical Issues (🔴 MUST BLOCK)

| Category      | Check                                             |
| ------------- | ------------------------------------------------- |
| **Injection** | SQL concatenation, eval(), exec() with user input |
| **Auth**      | Hardcoded credentials, plaintext passwords        |
| **XSS**       | Unsanitized dangerouslySetInnerHTML/v-html        |
| **Data**      | Logging passwords, tokens, or API keys            |
| **IDOR**      | Missing ownership check on private resources      |
| **Config**    | Secrets committed to repository                   |

### Warnings (🟡 SHOULD FIX)

| Category       | Check                                      |
| -------------- | ------------------------------------------ |
| **Rate Limit** | Missing rate limiting on public APIs       |
| **Deps**       | npm audit shows HIGH vulnerabilities       |
| **Headers**    | Missing security headers (CSP, HSTS, etc.) |
| **Validation** | Missing input validation on API endpoints  |

### Suggestions (🔵 NICE TO HAVE)

| Category    | Check                                              |
| ----------- | -------------------------------------------------- |
| **Crypto**  | Using older algorithms (MD5, SHA1)                 |
| **Logging** | Insufficient security event logging                |
| **2FA**     | High-value actions without additional verification |

---

## 8. 🚨 Security Grep Patterns

Use these patterns for automated security scanning:

```bash
# SQL Injection risks
grep -rn "query.*\\\$\|execute.*\\\$\|sql.*+" --include="*.ts" --include="*.js"

# XSS risks
grep -rn "innerHTML\|dangerouslySetInnerHTML\|v-html" --include="*.tsx" --include="*.vue"

# Hardcoded secrets
grep -rn "password.*=.*['\"]\\|api_key.*=.*['\"]\\|secret.*=.*['\"]" --include="*.ts"

# Logging sensitive data
grep -rn "console.*password\|console.*token\|log.*password" --include="*.ts"

# Eval usage
grep -rn "\\beval\\(\\|\\bexec\\(\\|Function\\(" --include="*.ts" --include="*.js"
```

---

## 9. 🔗 References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [CWE Top 25 Most Dangerous Software Weaknesses](https://cwe.mitre.org/top25/)

---

_Cập nhật định kỳ dựa trên các lỗ hổng mới được công bố. Last updated: 2025-12-27_
