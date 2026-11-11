# VAYRO — Database Architecture & Persistence Guide

**Primary Database Engine:** PostgreSQL 16 Alpine  
**ORM / Data Layer:** Prisma ORM 5.14+  
**Local Client Persistence:** SQLite via Drift 2.18+  
**In-Memory Store:** Redis 7 Alpine  
**Status:** Approved Foundation  

---

## 1. Relational Database (PostgreSQL via Docker)

PostgreSQL serves as the system of record for all durable entities:
- Accounts, credentials, user profiles
- Servers (Communities), members, invitations, RBAC roles
- Trips, legs, waypoints, itineraries, and expenses
- Audit logs, permissions, emergency event records

### Connection Configuration
The backend connects via standard PostgreSQL URI injected from the environment:
```env
DATABASE_URL=postgresql://<POSTGRES_USER>:<POSTGRES_PASSWORD>@<HOST>:<PORT>/<POSTGRES_DB>
```

Default development parameters (defined in `.env.example` and `docker-compose.yml`):
- **User:** `vayro_user`
- **Password:** `vayro_secret_dev_password`
- **Host:** `localhost`
- **Port:** `5432`
- **Database:** `vayro_db`

---

## 2. Prisma ORM Workflow

Prisma provides type-safe query generation, automated schema migrations, and declarative relation management.

### Schema Location
The source schema is located at:
`backend/prisma/schema.prisma`

### Standard Commands
Execute these commands from inside `backend/`:

1. **Generate Prisma Client Types**:
   ```bash
   npm run prisma:generate
   ```
2. **Create and Apply Migration in Development**:
   ```bash
   npm run prisma:migrate
   ```
3. **Push Schema Directly Without Creating Migration Files** (Prototyping):
   ```bash
   npm run prisma:push
   ```
4. **Seed Database with Reproducible Development Records**:
   ```bash
   npm run prisma:seed
   ```
5. **Open Prisma Studio Interactive UI**:
   ```bash
   npx prisma studio
   ```

---

## 3. Initial Development Schema

To keep the foundation clean and prevent premature schema churn before design reviews, the initial schema contains only the `DevHealthRecord` verification model:

```prisma
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

## 4. Development Data Management & Volume Lifecycle

### Persistent Development Volumes
Docker Compose manages data persistence using a named Docker volume (`vayro_postgres_data`). Data persists across container restarts:
```bash
# Graceful stop — keeps database tables and records intact
docker compose down
```

### Destructive Teardown (Hard Reset)
When starting fresh or after major breaking schema migrations:
```bash
# WARNING: Deletes persistent development database data permanently
docker compose down -v
```

---

## 5. Mobile Local Database (Drift + SQLite)

To support seamless travel across remote regions with intermittent or absent cellular connectivity, the mobile client implements an offline-first storage engine:
- **Engine**: SQLite 3 via `drift`
- **Location**: Sandboxed application document directory on Android/iOS
- **Schema**: Versioned with automated migration hooks in `mobile/lib/core/storage/local_database.dart`
- **Initial Verification Table**: `dev_health_records`

