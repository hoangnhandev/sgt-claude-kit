---
name: frameworks-and-cloud-summary
description: Quick reference for Laravel, Java, Next.js, Node.js, AWS. Read SKILL.md for full details.
---

# Frameworks & Cloud (Quick Reference)

> 📖 **Full details**: `.claude/skills/frameworks-and-cloud/SKILL.md`

---

## 🐘 Laravel

| Element       | Convention              | Example                |
| ------------- | ----------------------- | ---------------------- |
| Models        | Singular, PascalCase    | `User`, `OrderItem`    |
| Controllers   | PascalCase + Controller | `UserController`       |
| Tables        | Plural, snake_case      | `users`, `order_items` |
| Form Requests | PascalCase + Request    | `StoreUserRequest`     |

**Key Practices**: Use Form Requests, API Resources, Service layer, Eloquent scopes, Queue Jobs

---

## ☕ Java (Spring Boot)

| Element   | Convention       | Example                        |
| --------- | ---------------- | ------------------------------ |
| Classes   | PascalCase       | `UserService`                  |
| Methods   | camelCase        | `findByEmail`                  |
| DTOs      | + DTO/Request    | `UserDTO`, `CreateUserRequest` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`              |

**Key Practices**: Use Lombok, MapStruct, Bean Validation, `@Transactional`, Spring Profiles

---

## ⚡ Next.js (App Router)

| Element        | Convention        | Example                  |
| -------------- | ----------------- | ------------------------ |
| Pages          | folder + page.tsx | `app/users/page.tsx`     |
| API Routes     | folder + route.ts | `app/api/users/route.ts` |
| Route Groups   | (groupName)       | `(auth)`, `(dashboard)`  |
| Server Actions | camelCase         | `createUser.ts`          |

**Key Practices**: Server Components by default, `'use client'` only when needed, Server Actions for mutations, `revalidatePath`

---

## 🟢 Node.js

| Element  | Convention       | Example           |
| -------- | ---------------- | ----------------- |
| Files    | kebab-case       | `user-service.ts` |
| Classes  | PascalCase       | `UserService`     |
| Env vars | UPPER_SNAKE_CASE | `DATABASE_URL`    |

**Key Practices**: TypeScript, Zod validation, Winston/Pino logging, error middleware, connection pooling

---

## ☁️ AWS

| Resource       | Convention           | Example                  |
| -------------- | -------------------- | ------------------------ |
| S3 Buckets     | lowercase-hyphenated | `mycompany-prod-assets`  |
| Lambda         | PascalCase or kebab  | `ProcessOrderFunction`   |
| SSM Parameters | /env/service/key     | `/prod/api/database-url` |
| IAM Roles      | PascalCase + Role    | `LambdaExecutionRole`    |

**Key Practices**: IAM least-privilege, SSM for config, Secrets Manager for credentials, Lambda Powertools, tag all resources

---

## ✅ Quick Selection Guide

| If working with... | Check section in SKILL.md |
| ------------------ | ------------------------- |
| PHP/Laravel        | Laravel section           |
| Spring Boot        | Java section              |
| React/Next.js      | Next.js section           |
| Express/NestJS     | Node.js section           |
| AWS Serverless     | AWS section               |
