---
name: frameworks-and-cloud
description: Best practices and conventions for Laravel, Java, Next.js, Node.js, and AWS development. Apply when working with these technologies.
---

# Frameworks & Cloud Skills

> Áp dụng các conventions và best practices này khi làm việc với các framework và cloud platform cụ thể.

---

## 🐘 Laravel (PHP)

### Directory Structure

```
app/
├── Http/
│   ├── Controllers/      # Request handling
│   ├── Middleware/       # Request/Response filters
│   ├── Requests/         # Form request validation
│   └── Resources/        # API resources (JSON transformation)
├── Models/               # Eloquent models
├── Services/             # Business logic layer
├── Repositories/         # Data access layer (optional)
├── Events/               # Event classes
├── Listeners/            # Event listeners
├── Jobs/                 # Queue jobs
├── Mail/                 # Mailable classes
└── Policies/             # Authorization policies

resources/
├── views/                # Blade templates
├── js/                   # JavaScript assets
└── css/                  # Style assets

database/
├── migrations/           # Database migrations
├── seeders/              # Database seeders
└── factories/            # Model factories

routes/
├── web.php               # Web routes
├── api.php               # API routes
└── console.php           # Console commands

tests/
├── Feature/              # Feature tests
└── Unit/                 # Unit tests
```

### Naming Conventions

| Element         | Convention                | Example                                  |
| --------------- | ------------------------- | ---------------------------------------- |
| Models          | Singular, PascalCase      | `User`, `OrderItem`                      |
| Controllers     | PascalCase + Controller   | `UserController`, `OrderController`      |
| Migrations      | snake_case with timestamp | `2024_01_01_000000_create_users_table`   |
| Database tables | Plural, snake_case        | `users`, `order_items`                   |
| Pivot tables    | Singular, alphabetical    | `order_product`                          |
| Foreign keys    | snake_case + \_id         | `user_id`, `order_id`                    |
| Form Requests   | PascalCase + Request      | `StoreUserRequest`, `UpdateOrderRequest` |
| Resources       | PascalCase + Resource     | `UserResource`, `OrderCollection`        |

### Best Practices

```php
// ✅ Good - Use Form Request for validation
class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users'],
            'password' => ['required', 'confirmed', Password::defaults()],
        ];
    }
}

// ✅ Good - Use API Resources for JSON responses
class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'created_at' => $this->created_at->toIso8601String(),
        ];
    }
}

// ✅ Good - Service layer for business logic
class UserService
{
    public function __construct(
        private UserRepository $userRepository,
        private NotificationService $notificationService
    ) {}

    public function createUser(array $data): User
    {
        $user = $this->userRepository->create($data);
        $this->notificationService->sendWelcomeEmail($user);
        return $user;
    }
}

// ✅ Good - Use Eloquent scopes for reusable queries
class User extends Model
{
    public function scopeActive(Builder $query): Builder
    {
        return $query->where('status', 'active');
    }

    public function scopeCreatedAfter(Builder $query, Carbon $date): Builder
    {
        return $query->where('created_at', '>=', $date);
    }
}

// Usage: User::active()->createdAfter(now()->subMonth())->get();
```

### Laravel-Specific Guidelines

- **Use Eloquent ORM** for database operations, avoid raw queries unless necessary
- **Use Queue Jobs** for time-consuming tasks (email, file processing)
- **Use Events & Listeners** for decoupling side effects
- **Use Policies** for authorization logic
- **Use Config caching** in production (`php artisan config:cache`)
- **Use Route model binding** for cleaner controller methods
- **Always validate input** using Form Requests

---

## ☕ Java (Spring Boot)

### Directory Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/company/project/
│   │       ├── config/            # Configuration classes
│   │       ├── controller/        # REST controllers
│   │       ├── service/           # Business logic
│   │       │   └── impl/          # Service implementations
│   │       ├── repository/        # Data access (JPA repositories)
│   │       ├── model/             # Entity classes
│   │       │   ├── entity/        # JPA entities
│   │       │   ├── dto/           # Data transfer objects
│   │       │   └── mapper/        # DTO-Entity mappers
│   │       ├── exception/         # Custom exceptions
│   │       ├── security/          # Security configuration
│   │       └── util/              # Utility classes
│   └── resources/
│       ├── application.yml        # Main configuration
│       ├── application-dev.yml    # Dev environment config
│       └── application-prod.yml   # Production config
└── test/
    └── java/                      # Test classes (mirror main structure)
```

### Naming Conventions

| Element       | Convention                        | Example                                |
| ------------- | --------------------------------- | -------------------------------------- |
| Packages      | lowercase, dot-separated          | `com.company.project.service`          |
| Classes       | PascalCase                        | `UserService`, `OrderController`       |
| Interfaces    | PascalCase (no I prefix)          | `UserRepository`, `PaymentGateway`     |
| Methods       | camelCase                         | `findByEmail`, `createOrder`           |
| Constants     | UPPER_SNAKE_CASE                  | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` |
| Entity tables | snake_case                        | `@Table(name = "user_orders")`         |
| DTOs          | PascalCase + DTO/Request/Response | `UserDTO`, `CreateUserRequest`         |

### Best Practices

```java
// ✅ Good - Use DTOs for API contracts
@Data
@Builder
public class UserDTO {
    private Long id;
    private String name;
    private String email;
    private LocalDateTime createdAt;
}

// ✅ Good - Use constructor injection
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EventPublisher eventPublisher;

    @Override
    @Transactional
    public UserDTO createUser(CreateUserRequest request) {
        User user = User.builder()
            .name(request.getName())
            .email(request.getEmail())
            .password(passwordEncoder.encode(request.getPassword()))
            .build();

        user = userRepository.save(user);
        eventPublisher.publish(new UserCreatedEvent(user));
        return userMapper.toDTO(user);
    }
}

// ✅ Good - Use Spring Data JPA query methods
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    List<User> findByStatusAndCreatedAtAfter(UserStatus status, LocalDateTime date);

    @Query("SELECT u FROM User u WHERE u.department.id = :deptId AND u.status = 'ACTIVE'")
    List<User> findActiveUsersByDepartment(@Param("deptId") Long departmentId);
}

// ✅ Good - Global exception handling
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(EntityNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        List<String> errors = ex.getBindingResult().getFieldErrors().stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .toList();
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("VALIDATION_ERROR", errors));
    }
}
```

### Java-Specific Guidelines

- **Use Lombok** to reduce boilerplate (`@Data`, `@Builder`, `@RequiredArgsConstructor`)
- **Use MapStruct** for DTO-Entity mapping
- **Use Bean Validation** (`@Valid`, `@NotNull`, `@Size`, etc.)
- **Use `Optional`** for nullable return values
- **Always use `@Transactional`** at service layer for database operations
- **Use Spring Profiles** for environment-specific configuration
- **Use Actuator** for health checks and metrics

---

## ⚡ Next.js

### Directory Structure (App Router)

```
src/
├── app/
│   ├── (auth)/              # Route group for auth pages
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/         # Route group for dashboard
│   │   ├── layout.tsx       # Dashboard layout
│   │   ├── page.tsx         # Dashboard home
│   │   └── settings/
│   ├── api/                 # API routes
│   │   └── users/
│   │       └── route.ts
│   ├── layout.tsx           # Root layout
│   ├── page.tsx             # Home page
│   ├── loading.tsx          # Loading UI
│   ├── error.tsx            # Error boundary
│   └── not-found.tsx        # 404 page
├── components/
│   ├── ui/                  # Reusable UI components
│   └── features/            # Feature-specific components
├── lib/                     # Utility functions, configurations
├── hooks/                   # Custom React hooks
├── types/                   # TypeScript types
├── services/                # API service layer
└── styles/                  # Global styles
```

### Naming Conventions

| Element        | Convention                | Example                  |
| -------------- | ------------------------- | ------------------------ |
| Pages          | folder with page.tsx      | `app/users/page.tsx`     |
| API Routes     | folder with route.ts      | `app/api/users/route.ts` |
| Components     | PascalCase                | `UserCard.tsx`           |
| Hooks          | camelCase with use prefix | `useAuth.ts`             |
| Server Actions | camelCase                 | `createUser.ts`          |
| Route Groups   | (groupName)               | `(auth)`, `(dashboard)`  |

### Best Practices

```tsx
// ✅ Good - Server Component (default in App Router)
// app/users/page.tsx
import { getUsers } from "@/services/user-service";

export const metadata = {
  title: "Users | My App",
  description: "Manage your users",
};

export default async function UsersPage() {
  const users = await getUsers(); // Direct server-side fetch

  return (
    <main>
      <h1>Users</h1>
      <UserList users={users} />
    </main>
  );
}

// ✅ Good - Client Component with 'use client' directive
("use client");

import { useState, useTransition } from "react";
import { createUser } from "@/actions/user-actions";

export function CreateUserForm() {
  const [isPending, startTransition] = useTransition();

  const handleSubmit = (formData: FormData) => {
    startTransition(async () => {
      await createUser(formData);
    });
  };

  return (
    <form action={handleSubmit}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit" disabled={isPending}>
        {isPending ? "Creating..." : "Create User"}
      </button>
    </form>
  );
}

// ✅ Good - Server Action for mutations
// actions/user-actions.ts
("use server");

import { revalidatePath } from "next/cache";
import { z } from "zod";

const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export async function createUser(formData: FormData) {
  const validated = createUserSchema.parse({
    name: formData.get("name"),
    email: formData.get("email"),
  });

  await db.user.create({ data: validated });
  revalidatePath("/users");
}

// ✅ Good - API Route Handler
// app/api/users/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const page = parseInt(searchParams.get("page") ?? "1");

  const users = await db.user.findMany({
    skip: (page - 1) * 10,
    take: 10,
  });

  return NextResponse.json({ users, page });
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await db.user.create({ data: body });
  return NextResponse.json(user, { status: 201 });
}
```

### Next.js-Specific Guidelines

- **Use Server Components** by default, add `'use client'` only when needed
- **Use Server Actions** for data mutations instead of API routes
- **Use `revalidatePath`/`revalidateTag`** for cache invalidation
- **Use Route Groups** `(folder)` for layout organization without affecting URL
- **Use Parallel Routes** `@folder` for complex layouts
- **Use `loading.tsx`** and `error.tsx` for better UX
- **Use `generateMetadata`** for dynamic SEO
- **Use next/image** for automatic image optimization
- **Use next/font** for font optimization

---

## 🟢 Node.js

### Directory Structure

```
src/
├── config/               # Configuration files
│   ├── database.ts
│   ├── redis.ts
│   └── index.ts
├── controllers/          # Request handlers
├── services/             # Business logic
├── repositories/         # Data access layer
├── models/               # Database models
├── middleware/           # Express middleware
├── routes/               # Route definitions
├── utils/                # Utility functions
├── types/                # TypeScript types
├── validators/           # Input validation schemas
├── jobs/                 # Background jobs
└── index.ts              # Application entry point

tests/
├── unit/                 # Unit tests
├── integration/          # Integration tests
└── e2e/                  # End-to-end tests
```

### Naming Conventions

| Element               | Convention       | Example                                 |
| --------------------- | ---------------- | --------------------------------------- |
| Files                 | kebab-case       | `user-service.ts`, `auth-middleware.ts` |
| Classes               | PascalCase       | `UserService`, `DatabaseConfig`         |
| Functions             | camelCase        | `createUser`, `validateToken`           |
| Constants             | UPPER_SNAKE_CASE | `MAX_CONNECTIONS`, `JWT_SECRET`         |
| Interfaces            | PascalCase       | `User`, `CreateUserInput`               |
| Environment variables | UPPER_SNAKE_CASE | `DATABASE_URL`, `API_KEY`               |

### Best Practices

```typescript
// ✅ Good - Service layer with dependency injection
// services/user-service.ts
import { injectable, inject } from "tsyringe";

@injectable()
export class UserService {
  constructor(
    @inject(UserRepository) private userRepo: UserRepository,
    @inject(EmailService) private emailService: EmailService,
    @inject(Logger) private logger: Logger
  ) {}

  async createUser(input: CreateUserInput): Promise<User> {
    this.logger.info("Creating user", { email: input.email });

    const existingUser = await this.userRepo.findByEmail(input.email);
    if (existingUser) {
      throw new ConflictError("Email already exists");
    }

    const hashedPassword = await bcrypt.hash(input.password, 12);
    const user = await this.userRepo.create({
      ...input,
      password: hashedPassword,
    });

    await this.emailService.sendWelcome(user);
    this.logger.info("User created", { userId: user.id });

    return user;
  }
}

// ✅ Good - Input validation with Zod
// validators/user-validator.ts
import { z } from "zod";

export const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  password: z
    .string()
    .min(8)
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      "Password must contain lowercase, uppercase, and number"
    ),
});

export type CreateUserInput = z.infer<typeof createUserSchema>;

// ✅ Good - Express error handling middleware
// middleware/error-handler.ts
export const errorHandler: ErrorRequestHandler = (err, req, res, next) => {
  const logger = req.logger || console;

  if (err instanceof ValidationError) {
    return res.status(400).json({
      error: "VALIDATION_ERROR",
      message: err.message,
      details: err.details,
    });
  }

  if (err instanceof NotFoundError) {
    return res.status(404).json({
      error: "NOT_FOUND",
      message: err.message,
    });
  }

  logger.error("Unhandled error", { error: err, stack: err.stack });

  return res.status(500).json({
    error: "INTERNAL_ERROR",
    message: "An unexpected error occurred",
  });
};

// ✅ Good - Async handler wrapper
// utils/async-handler.ts
export const asyncHandler = (fn: RequestHandler): RequestHandler => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

// Usage in controller
router.post(
  "/users",
  asyncHandler(async (req, res) => {
    const user = await userService.createUser(req.body);
    res.status(201).json(user);
  })
);
```

### Node.js-Specific Guidelines

- **Use TypeScript** for type safety
- **Use environment variables** for configuration (dotenv, @nestjs/config)
- **Use Zod/Joi** for input validation
- **Use Winston/Pino** for structured logging
- **Handle async errors** with try-catch or wrapper functions
- **Use connection pooling** for database connections
- **Use PM2/Docker** for production process management
- **Use rate limiting** and security middleware (helmet, cors)
- **Use graceful shutdown** for handling SIGTERM/SIGINT

---

## ☁️ AWS (Amazon Web Services)

### Infrastructure as Code (IaC) Structure

```
infrastructure/
├── terraform/                    # Terraform configurations
│   ├── modules/                  # Reusable modules
│   │   ├── vpc/
│   │   ├── ecs/
│   │   ├── rds/
│   │   └── lambda/
│   ├── environments/             # Environment-specific
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── main.tf
├── cloudformation/               # CFN templates (if used)
│   └── templates/
├── sam/                          # SAM for serverless
│   ├── template.yaml
│   └── samconfig.toml
└── cdk/                          # AWS CDK (TypeScript)
    ├── lib/
    │   └── stacks/
    └── bin/
        └── app.ts
```

### Naming Conventions

| Resource              | Convention                             | Example                                       |
| --------------------- | -------------------------------------- | --------------------------------------------- |
| S3 Buckets            | lowercase, hyphenated, globally unique | `mycompany-prod-assets`, `mycompany-dev-logs` |
| Lambda Functions      | PascalCase or kebab-case               | `ProcessOrderFunction`, `process-order`       |
| DynamoDB Tables       | PascalCase                             | `Users`, `OrderItems`                         |
| IAM Roles             | PascalCase with suffix                 | `LambdaExecutionRole`, `ECSTaskRole`          |
| Security Groups       | lowercase with description             | `web-server-sg`, `database-sg`                |
| CloudFormation Stacks | PascalCase                             | `ProductionVPCStack`, `DevLambdaStack`        |
| SSM Parameters        | /environment/service/key               | `/prod/api/database-url`                      |
| Secrets Manager       | environment/service/secret             | `prod/api/db-credentials`                     |

### Best Practices

```yaml
# ✅ Good - SAM Template with proper structure
# template.yaml
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31

Parameters:
  Environment:
    Type: String
    AllowedValues: [dev, staging, prod]
    Default: dev

Globals:
  Function:
    Runtime: nodejs20.x
    Timeout: 30
    MemorySize: 256
    Tracing: Active
    Environment:
      Variables:
        ENVIRONMENT: !Ref Environment
        LOG_LEVEL: !If [IsProd, "info", "debug"]

Conditions:
  IsProd: !Equals [!Ref Environment, "prod"]

Resources:
  # API Gateway
  ApiGateway:
    Type: AWS::Serverless::Api
    Properties:
      StageName: !Ref Environment
      Cors:
        AllowOrigin: "'*'"
        AllowMethods: "'GET,POST,PUT,DELETE,OPTIONS'"
        AllowHeaders: "'Content-Type,Authorization'"

  # Lambda Function
  ProcessOrderFunction:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: !Sub "${Environment}-process-order"
      Handler: src/handlers/process-order.handler
      Events:
        ApiEvent:
          Type: Api
          Properties:
            RestApiId: !Ref ApiGateway
            Path: /orders
            Method: POST
      Policies:
        - DynamoDBCrudPolicy:
            TableName: !Ref OrdersTable
        - SSMParameterReadPolicy:
            ParameterName: !Sub "${Environment}/api/*"
      Environment:
        Variables:
          ORDERS_TABLE: !Ref OrdersTable

  OrdersTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: !Sub "${Environment}-orders"
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: PK
          AttributeType: S
        - AttributeName: SK
          AttributeType: S
      KeySchema:
        - AttributeName: PK
          KeyType: HASH
        - AttributeName: SK
          KeyType: RANGE

Outputs:
  ApiEndpoint:
    Value: !Sub "https://${ApiGateway}.execute-api.${AWS::Region}.amazonaws.com/${Environment}"
```

```typescript
// ✅ Good - Lambda handler with proper patterns
// src/handlers/process-order.ts
import { APIGatewayProxyHandler } from "aws-lambda";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";
import { Logger } from "@aws-lambda-powertools/logger";
import { Tracer } from "@aws-lambda-powertools/tracer";
import { injectLambdaContext } from "@aws-lambda-powertools/logger/middleware";
import { captureLambdaHandler } from "@aws-lambda-powertools/tracer/middleware";
import middy from "@middy/core";

const logger = new Logger({ serviceName: "order-service" });
const tracer = new Tracer({ serviceName: "order-service" });

const ddbClient = tracer.captureAWSv3Client(
  DynamoDBDocumentClient.from(new DynamoDBClient({}))
);

const processOrderHandler: APIGatewayProxyHandler = async (event) => {
  try {
    const body = JSON.parse(event.body || "{}");

    logger.info("Processing order", { orderId: body.orderId });

    await ddbClient.send(
      new PutCommand({
        TableName: process.env.ORDERS_TABLE!,
        Item: {
          PK: `ORDER#${body.orderId}`,
          SK: `ORDER#${body.orderId}`,
          ...body,
          createdAt: new Date().toISOString(),
        },
      })
    );

    logger.info("Order processed successfully", { orderId: body.orderId });

    return {
      statusCode: 201,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Order created", orderId: body.orderId }),
    };
  } catch (error) {
    logger.error("Failed to process order", { error });
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal server error" }),
    };
  }
};

export const handler = middy(processOrderHandler)
  .use(injectLambdaContext(logger))
  .use(captureLambdaHandler(tracer));
```

### AWS-Specific Guidelines

- **Use IAM least-privilege principle** - only grant necessary permissions
- **Use SSM Parameter Store** for configuration, **Secrets Manager** for credentials
- **Use CloudWatch** for logging, metrics, and alarms
- **Use X-Ray** for distributed tracing
- **Use Lambda Powertools** for logging, tracing, and metrics
- **Use AWS SDK v3** for better tree-shaking and performance
- **Use SAM/CDK** for Infrastructure as Code
- **Tag all resources** with Environment, Project, Owner
- **Enable encryption** at rest (S3, RDS, DynamoDB)
- **Use VPC endpoints** for private access to AWS services
- **Use CloudFormation outputs** for cross-stack references

---

_Áp dụng các conventions này một cách nhất quán khi làm việc với từng công nghệ tương ứng._
