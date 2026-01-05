---
name: frameworks-and-cloud
description: "LOAD BY: solution-architect, senior-developer, code-reviewer. CONTAINS: Framework-specific patterns (Next.js, Laravel, Spring Boot) and cloud best practices (AWS). USE: Reference during implementation for correct directory structure and patterns."
---

# Frameworks & Cloud

## 🐘 Laravel

- **Dir**: `app/Http/{Controllers,Requests,Resources}`, `app/Models`, `database/migrations`.
- **Naming**: `UserController` (Pascal), `users` (table/snake).
- **Best Practices**: Use FormRequests for validation. Use Eloquent Scopes. No Raw SQL.

## ☕ Java (Spring Boot)

- **Dir**: `controller`, `service`, `repository`, `model/entity`.
- **Pattern**: Controller -> Service (Interface+Impl) -> Repository (JPA).
- **Best Practices**: Use Lombok (`@Data`). Use DTOs. `@Transactional` on services.

## ⚡ Next.js / Node.js

- **Dir**: `app/(group)/page.tsx` (App Router). `services/`.
- **Rendering Strategy**:
  - **PPR (Partial Prerendering)**: Enable `ppr: true` in config. Wrap dynamic parts in `<Suspense>`.
  - **Server Components**: Default. Use for data fetching, sensitive logic, keeping bundle small.
  - **Client Components**: Only for interactivity (`onClick`, `useState`). Keep at leaf nodes.
  - **Streaming**: Use `<Suspense fallback={<Skeleton />}>` for slow data fetches to avoid blocking UI.
- **Validation**: Zod for schemas. `react-hook-form` for inputs.
- **Code Organization**:
  - **Barrel Exports**: Create `index.ts` in each folder to export all contents (`export * from './File'`).
  - **Imports**: Use short/absolute imports (e.g., `@/components`) instead of relative paths.
- **Node Backend**: Layered Arch (Controller -> Service -> Repo). `try/catch` in async handlers.

## ☁️ AWS

- **IaC**: SAM/CDK/Terraform.
- **Services**: Lambda (Serverless), DynamoDB (Single Table Design preferred), S3.
- **Best Practices**: Least Privilege (IAM). Environment Variables (SSM/Secrets). Structured Logging.
