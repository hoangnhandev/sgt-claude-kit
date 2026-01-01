---
name: frameworks-and-cloud
description: Best practices for Laravel, Java, Next.js, Node.js, and AWS.
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
- **Node Backend**: Layered Arch (Controller -> Service -> Repo). `try/catch` in async handlers.

## ☁️ AWS

- **IaC**: SAM/CDK/Terraform.
- **Services**: Lambda (Serverless), DynamoDB (Single Table Design preferred), S3.
- **Best Practices**: Least Privilege (IAM). Environment Variables (SSM/Secrets). Structured Logging.
