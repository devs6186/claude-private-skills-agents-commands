---
name: v3-ddd-architecture
version: 1.0.0
description: |
  Domain-Driven Design (DDD) architecture patterns for TypeScript/Node.js projects.
  Covers bounded contexts, entities, value objects, aggregates, repositories,
  use cases, domain services, and dependency injection. Based on production-grade
  DDD patterns with Clean Architecture layers.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Domain-Driven Design Architecture

Production-grade DDD patterns for TypeScript applications.

---

## Directory Structure

```
src/
├── kernel/                    # Shared base classes
│   ├── Entity.ts
│   ├── ValueObject.ts
│   ├── AggregateRoot.ts
│   ├── DomainEvent.ts
│   └── Repository.ts
├── domains/                   # Bounded contexts
│   ├── users/
│   │   ├── entities/          # User, Profile
│   │   ├── value-objects/     # Email, Password, UserId
│   │   ├── services/          # UserDomainService
│   │   ├── repositories/      # IUserRepository
│   │   └── events/            # UserCreated, UserDeleted
│   └── orders/
│       ├── entities/
│       ├── value-objects/
│       └── ...
├── application/               # Use cases (one file per use case)
│   ├── users/
│   │   ├── CreateUser.ts
│   │   ├── UpdateUser.ts
│   │   └── DeleteUser.ts
│   └── orders/
├── infrastructure/            # Implementations
│   ├── repositories/          # PostgreSQL, Redis implementations
│   ├── services/              # External APIs
│   └── persistence/           # DB connection, migrations
└── shared/                    # Cross-cutting concerns
    ├── types/
    ├── errors/
    └── utils/
```

---

## Base Classes

### Entity
```typescript
// src/kernel/Entity.ts
export abstract class Entity<T> {
  protected readonly _id: T
  private readonly _createdAt: Date
  private readonly _updatedAt: Date

  constructor(id: T) {
    this._id = id
    this._createdAt = new Date()
    this._updatedAt = new Date()
  }

  get id(): T { return this._id }
  get createdAt(): Date { return this._createdAt }

  equals(other: Entity<T>): boolean {
    return this._id === other._id
  }
}
```

### Value Object
```typescript
// src/kernel/ValueObject.ts
export abstract class ValueObject<T extends object> {
  protected readonly props: Readonly<T>

  constructor(props: T) {
    this.props = Object.freeze({ ...props })
  }

  equals(other: ValueObject<T>): boolean {
    return JSON.stringify(this.props) === JSON.stringify(other.props)
  }
}
```

### Aggregate Root
```typescript
// src/kernel/AggregateRoot.ts
import { Entity } from './Entity'
import { DomainEvent } from './DomainEvent'

export abstract class AggregateRoot<T> extends Entity<T> {
  private _domainEvents: DomainEvent[] = []

  protected addDomainEvent(event: DomainEvent): void {
    this._domainEvents.push(event)
  }

  clearEvents(): DomainEvent[] {
    const events = [...this._domainEvents]
    this._domainEvents = []
    return events
  }
}
```

---

## Domain Example: User

### Value Object — Email
```typescript
// src/domains/users/value-objects/Email.ts
import { ValueObject } from '../../../kernel/ValueObject'

interface EmailProps { value: string }

export class Email extends ValueObject<EmailProps> {
  private constructor(props: EmailProps) {
    super(props)
  }

  static create(email: string): Email {
    if (!email.includes('@')) {
      throw new Error(`Invalid email: ${email}`)
    }
    return new Email({ value: email.toLowerCase() })
  }

  get value(): string { return this.props.value }
}
```

### Entity — User
```typescript
// src/domains/users/entities/User.ts
import { AggregateRoot } from '../../../kernel/AggregateRoot'
import { Email } from '../value-objects/Email'
import { UserCreated } from '../events/UserCreated'

export class User extends AggregateRoot<string> {
  private _email: Email
  private _name: string

  private constructor(id: string, email: Email, name: string) {
    super(id)
    this._email = email
    this._name = name
  }

  static create(id: string, email: string, name: string): User {
    const user = new User(id, Email.create(email), name)
    user.addDomainEvent(new UserCreated(id, email))
    return user
  }

  get email(): string { return this._email.value }
  get name(): string { return this._name }

  updateName(name: string): void {
    if (!name.trim()) throw new Error('Name cannot be empty')
    this._name = name
  }
}
```

---

## Use Case Pattern

```typescript
// src/application/users/CreateUser.ts
interface CreateUserInput {
  email: string
  name: string
}

interface CreateUserOutput {
  id: string
  email: string
  name: string
}

export class CreateUserUseCase {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly idGenerator: IIdGenerator,
    private readonly eventBus: IEventBus,
  ) {}

  async execute(input: CreateUserInput): Promise<CreateUserOutput> {
    // Check for duplicates
    const existing = await this.userRepository.findByEmail(input.email)
    if (existing) throw new ConflictError(`Email already registered: ${input.email}`)

    // Create domain entity
    const id = this.idGenerator.generate()
    const user = User.create(id, input.email, input.name)

    // Persist
    await this.userRepository.save(user)

    // Dispatch domain events
    const events = user.clearEvents()
    await this.eventBus.publishAll(events)

    return { id: user.id, email: user.email, name: user.name }
  }
}
```

---

## Repository Interface

```typescript
// src/domains/users/repositories/IUserRepository.ts
export interface IUserRepository {
  findById(id: string): Promise<User | null>
  findByEmail(email: string): Promise<User | null>
  save(user: User): Promise<void>
  delete(id: string): Promise<void>
}
```

---

## Rules

- Domain entities have NO knowledge of HTTP, databases, or external services
- Use cases orchestrate domain entities but contain no business logic themselves
- Business rules live in entities and domain services, not in use cases
- Value objects are immutable — never mutate them, create new instances
- Aggregates enforce their own invariants — never bypass an aggregate to modify its children directly
- One use case per file, named for what it does: `CreateUser.ts`, not `UserService.ts`
