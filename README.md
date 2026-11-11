# VAYRO — Move as One.

> **Premium Group Travel & Real-Time Travel Coordination Platform**  
> *One group. One destination. Individual routes. Shared journey.*

---

## 1. Project Overview

VAYRO is an enterprise-grade connected travel platform engineered to synchronize multi-vehicle expeditions and group journeys. It unites persistent community hubs (**Servers**) with synchronized, real-time travel coordination sessions (**Trips**).

### Architectural Philosophy
- **One Group, Common Destination**: Every convoy participant travels toward a shared destination.
- **Individual Routes**: Each traveler starts from a unique origin and receives independent, turn-by-turn routing optimized for their vehicle type.
- **Shared Journey**: Real-time GPS location sharing (consent-based), low-latency group voice, shared itineraries, split expenses, and emergency alerts.

---

## 2. Monorepo Structure

```text
VAYRO/
├── mobile/                   # Flutter cross-platform mobile client (iOS / Android / Desktop)
│   ├── lib/
│   │   ├── app/              # Bootstrap, router (go_router), brand dark theme
│   │   ├── core/             # Network (Dio), local DB (Drift SQLite), secure storage
│   │   ├── features/         # Feature-first Clean Architecture (auth, servers, trips, location...)
│   │   └── shared/           # Design system tokens, reusable widgets, shared models
│   └── test/                 # Bootstrap, widget, theme, network, and database tests
│
├── backend/                  # NestJS modular monolith REST & WebSocket backend
│   ├── src/
│   │   ├── config/           # Type-safe environment validation (class-validator)
│   │   ├── common/           # Global exception filter, interceptors, pipes
│   │   ├── database/         # Prisma ORM service & PostgreSQL connection lifecycle
│   │   ├── redis/            # ioredis service & cache connectivity
│   │   ├── health/           # Health checks & end-to-end integration smoke test
│   │   └── modules/          # Encapsulated domain boundaries (servers, trips, telemetry...)
│   ├── prisma/               # Schema definitions, migrations, and seed scripts
│   └── test/                 # Unit and end-to-end test suites
│
├── admin/                    # React administration & telemetry console (Vite + Tailwind CSS)
│   ├── src/
│   │   ├── components/       # Header, Sidebar, StatusCard, Layout
│   │   ├── pages/            # Infrastructure Overview & System Health telemetry
│   │   └── services/         # Typed API clients
│   └── index.html
│
├── infrastructure/           # Declarative deployment, database, and container resources
│   ├── docker/
│   ├── database/
│   └── deployment/
│
├── documentation/            # Comprehensive engineering specifications
│   ├── PRD.md                # Product requirements reference placeholder
│   ├── ARCHITECTURE.md       # High-level architecture and system design
│   ├── DATABASE.md           # PostgreSQL, Prisma, Redis, Drift persistence guide
│   ├── API_DOCUMENTATION.md  # REST API endpoints and Swagger documentation
│   ├── WEBSOCKET_EVENTS.md   # Real-time event specification & contracts
│   ├── SECURITY.md           # Secrets, CORS, and location privacy policies
│   ├── DEVELOPMENT_ROADMAP.md# 18-phase incremental development roadmap
│   ├── ENVIRONMENT_AUDIT.md  # Workstation inspection and toolchain report
│   └── SETUP_GUIDE.md        # Step-by-step developer onboarding instructions
│
├── scripts/                  # Development automation scripts (PowerShell & Bash)
├── .github/workflows/        # Automated CI workflows (Mobile, Backend, Admin)
├── docker-compose.yml        # PostgreSQL 16 & Redis 7 development containers
├── .gitignore                # Multi-stack ignore rules (Flutter, Node, Secrets)
├── .editorconfig             # Standardized cross-editor formatting rules
└── .gitattributes            # Git text normalization and LF line endings
```

---

## 3. Quick Start Guide

### Step 1: Start Infrastructure (PostgreSQL & Redis)
Ensure Docker Desktop is running, then execute:
```bash
docker compose up -d
```

### Step 2: Configure Environment Variables
Copy template `.env.example` files:
```bash
cp backend/.env.example backend/.env
cp admin/.env.example admin/.env
cp mobile/.env.example mobile/.env
```

### Step 3: Run NestJS Backend
```bash
cd backend
npm install
npm run prisma:generate
npm run prisma:migrate
npm run prisma:seed
npm run start:dev
```
- API Base: `http://localhost:3000/api/v1`
- Swagger Documentation: `http://localhost:3000/api/docs`
- Health Check: `http://localhost:3000/api/v1/health`

### Step 4: Run React Admin Dashboard
```bash
cd admin
npm install
npm run dev
```
- Admin Console: `http://localhost:5173`

### Step 5: Run Flutter Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

> [!NOTE]
> **Mobile Networking Note**:
> - Android Emulator connects to `http://10.0.2.2:3000/api/v1`.
> - Physical devices must use your workstation's LAN IP address (configurable in mobile Settings).

---

## 4. Running Monorepo Tests

Run test suites across all packages:
```bash
# PowerShell
.\scripts\run-tests.ps1

# Bash (macOS/Linux)
./scripts/run-tests.sh
```

Or test each package independently:
```bash
# Backend unit & e2e tests
cd backend && npm test && npm run test:e2e

# Admin component tests & production build
cd admin && npm test && npm run build

# Mobile unit & widget tests
cd mobile && flutter test
```

---

## 5. Security Principles

- **No Hardcoded Secrets**: Secrets and database credentials must never be committed to Git.
- **Client Isolation**: The Flutter app and Admin UI never hold database credentials or service-role keys.
- **Location Privacy**: Ephemeral GPS sharing requires explicit opt-in consent and terminates automatically at trip completion.

---

## 6. Development Status & Next Steps

Current Stage: **Phase 1 (Foundation Setup)** completed.  
Next Milestone: **Phase 2 (Authentication & Identity Management)**.
Consult [documentation/DEVELOPMENT_ROADMAP.md](documentation/DEVELOPMENT_ROADMAP.md) for full phase sequencing.

