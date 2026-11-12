# VAYRO — Database Architecture & Persistence Guide

**Primary Database Engine:** PostgreSQL 16 Alpine  
**ORM / Data Layer:** Prisma ORM 5.22+  
**Local Client Persistence:** SQLite via Drift 2.18+  
**In-Memory Store:** Redis 7 Alpine  
**Status:** Phase 2 (Authentication & Identity) Active  

---

## 1. Relational Database (PostgreSQL via Docker)

PostgreSQL serves as the primary system of record for all persistent platform models.

### Connection Configuration
The backend connects via standard PostgreSQL URI:
```env
DATABASE_URL=postgresql://vayro_user:vayro_secret_dev_password@localhost:5432/vayro_db
```

---

## 2. Active Prisma Schema (Phase 2)

```prisma
/// Core User entity representing authenticated travelers and platform admins.
model User {
  id           String         @id @default(uuid())
  email        String         @unique
  passwordHash String         @map("password_hash")
  displayName  String         @map("display_name")
  phoneNumber  String?        @map("phone_number")
  avatarUrl    String?        @map("avatar_url")
  role         String         @default("USER")
  isActive     Boolean        @default(true) @map("is_active")
  createdAt    DateTime       @default(now()) @map("created_at")
  updatedAt    DateTime       @updatedAt @map("updated_at")
  
  refreshTokens RefreshToken[]

  @@map("users")
}

/// Cryptographically hashed refresh token storage for single-use rotation.
model RefreshToken {
  id        String   @id @default(uuid())
  userId    String   @map("user_id")
  tokenHash String   @map("token_hash")
  isRevoked Boolean  @default(false) @map("is_revoked")
  expiresAt DateTime @map("expires_at")
  createdAt DateTime @default(now()) @map("created_at")

  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@map("refresh_tokens")
}

/// Development health verification record.
model DevHealthRecord {
  id        Int      @id @default(autoincrement())
  service   String   @default("vayro-backend")
  checkType String   @map("check_type")
  status    String
  details   String?
  createdAt DateTime @default(now()) @map("created_at")

  @@map("dev_health_records")
}
```

---

## 3. Database Migration Workflow

```bash
cd backend

# Generate Prisma Client after schema changes
npm run prisma:generate

# Apply migrations in local development
npm run prisma:migrate

# Seed development database
npm run prisma:seed
```
