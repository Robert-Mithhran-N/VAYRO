# VAYRO — System Architecture Specification

**System Name:** VAYRO Platform  
**Architecture Pattern:** Modular Monorepo (Clean Architecture Client + Modular Monolith Backend)  
**Version:** 1.0.0  
**Status:** Approved Foundation  

---

## 1. Architectural Overview

VAYRO is designed as an enterprise-grade connected travel platform providing high-concurrency real-time coordination, telemetry streaming, and resilient offline synchronization.

The platform is structured as an independently runnable, modular monorepo:

```
┌─────────────────────────────────────────────────────────────┐
│                       VAYRO MONOREPO                        │
│                                                             │
│   ┌──────────────────┐  ┌──────────────────┐  ┌───────────┐ │
│   │  mobile/         │  │  backend/        │  │  admin/   │ │
│   │  Flutter Client  │  │  NestJS Monolith │  │  React UI │ │
│   └─────────┬────────┘  └────────┬─────────┘  └─────┬─────┘ │
│             │ HTTP / WS          │                  │ HTTP  │
│             └───────────────► ┌──┴──┐ ◄─────────────┘       │
│                               │ API │                       │
│                               └──┬──┘                       │
│                                  │                          │
│               ┌──────────────────┴──────────────────┐       │
│               │                                     │       │
│               ▼                                     ▼       │
│        ┌──────────────┐                      ┌────────────┐ │
│        │  PostgreSQL  │                      │   Redis    │ │
│        │  Relational  │                      │ Cache / WS │ │
│        └──────────────┘                      └────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Mobile Architecture (`mobile/`)

The mobile client is built on **Flutter & Dart**, adhering to **Feature-First Clean Architecture**.

```
lib/
├── app/          # App bootstrap, MaterialApp.router, AppRouter, Dark Theme
├── core/         # Cross-cutting primitives (config, networking, storage, logging, errors)
├── features/     # Self-contained business domains (auth, servers, trips, location...)
└── shared/       # Common design system tokens, atomic widgets, models, extensions
```

### Layer Responsibilities Inside Each Feature
- **`data/` (Infrastructure & Storage)**:
  - Remote datasources (Dio HTTP clients, WebSocket listeners).
  - Local datasources (Drift SQLite queries).
  - Data transfer objects (DTOs) and serialization.
  - Concrete repository implementations.
- **`domain/` (Pure Business Logic)**:
  - Domain entities (immutable Dart models).
  - Abstract repository interfaces (contracts).
  - Use case interactors. Zero Flutter or framework dependencies.
- **`presentation/` (UI & Interaction)**:
  - Riverpod StateNotifiers / Notifiers for unidirectional reactive state.
  - Screens and composite views.
  - Dumb / atomic presentation widgets.

### Core Client Technologies
- **State Management**: Riverpod (`flutter_riverpod: ^2.5.1`).
- **Navigation**: `go_router: ^14.2.0` (Declarative, deep-link ready).
- **HTTP Client**: `dio: ^5.4.3+1` with centralized retry, authorization, and logging interceptors.
- **Local Persistence**: `drift: ^2.18.0` with SQLite engine for full offline capability.
- **Secure Keystore**: `flutter_secure_storage: ^9.2.2` (EncryptedSharedPreferences on Android, Keychain on iOS).

---

## 3. Backend Architecture (`backend/`)

The backend is structured as a **NestJS Modular Monolith**, enforcing strict encapsulation and domain boundaries across modules.

```
src/
├── config/       # Environment parsing and class-validator runtime enforcement
├── common/       # Global filters, interceptors, guards, pipes, base interfaces
├── database/     # PrismaService and connection lifecycle
├── redis/        # RedisService client and pub/sub connection lifecycle
├── health/       # Health checks and integration smoke tests
└── modules/      # Independent business modules (servers, trips, locations...)
```

### Key Modular Monolith Rules
1. **No Microservices at Initial Stage**: Minimizes distributed transaction complexity, network overhead, and DevOps overhead.
2. **Encapsulated Data Access**: Controllers never query the database directly. All database access is mediated through typed services.
3. **Module Interfaces**: Modules communicate with each other exclusively through exported service contracts or internal events.
4. **Prisma ORM**: Strict TypeScript-generated query builder bound to PostgreSQL 16.
5. **Redis Cache & State Layer**: Manages ephemeral session states, convoy live locations, and WebSocket pub/sub fanout.

---

## 4. Real-Time Communication Architecture

### Ephemeral Telemetry & Live Locations
- High-frequency GPS updates (every 1 to 5 seconds per moving vehicle) are bypass-routed through **Redis In-Memory Geospatial Hashes (`GEOADD` / `GEORADIUS`)** and broadcast via **Socket.IO WebSockets**.
- Locations are persisted to PostgreSQL only at key journey milestones or check-ins to prevent database write saturation.

### Audio & Voice Rooms (Planned Phase 5)
- Spatial group audio will leverage **LiveKit SFU (Selective Forwarding Unit)**.
- The NestJS backend acts as the token issuing authority; voice media streams never traverse the application server directly.

---

## 5. Security & Boundary Architecture

1. **Zero Secret Leakage**: No private keys or database passwords in source code, client builds, or Git history.
2. **Strict Environment Validation**: Backend rejects startup immediately if required configuration variables are missing or malformed.
3. **Network Isolation**: PostgreSQL and Redis are isolated within internal Docker bridge networks and are not exposed directly to the public Internet.
4. **Consent-Based Telemetry**: Mobile location streams can be disabled instantly by the user via local device toggles.

---

## 6. End-to-End Data Flow (Integration Smoke Test)

```
[Flutter UI: HomeScreen]
        │
        │ 1. User taps "Run Smoke Test" or on App Launch
        ▼
[Riverpod: backendHealthProvider]
        │
        │ 2. GET /api/v1/health/smoke-test?client=vayro-mobile-client
        ▼
[NestJS: HealthController & HealthService]
        │
        │ 3. Execute prisma.devHealthRecord.create(...)
        ▼
[PostgreSQL Database]
        │
        │ 4. Insert DevHealthRecord and return generated ID
        ▼
[NestJS: TransformInterceptor]
        │
        │ 5. Format unified JSON response
        ▼
[Flutter: ApiClient]
        │
        │ 6. Parse response & write check to local Drift SQLite database
        ▼
[Flutter UI: System Integration Status Card updates to ONLINE]
```

