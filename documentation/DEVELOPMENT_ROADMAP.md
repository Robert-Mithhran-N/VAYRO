# VAYRO — 18-Phase Development Roadmap

**Product:** VAYRO (Move as One)  
**Strategy:** Production-oriented, incremental, test-driven  
**Current Milestone:** Phase 2 (Authentication & Identity Management) Completed  
**Next Milestone:** Phase 3 (Private Travel Servers & Communities)  

---

## Detailed Phase Status

- [x] **Phase 1: Foundation & Monorepo Infrastructure** (COMPLETED)
  - Monorepo directory structure, Git configuration, and CI workflows.
  - Flutter client scaffold with Riverpod, go_router, Drift SQLite, and brand design system.
  - NestJS backend modular monolith with Prisma ORM, PostgreSQL 16, and Redis 7 in Docker Compose.
  - React admin dashboard with Vite, Tailwind CSS, and telemetry cards.
  - End-to-end integration smoke test (Flutter -> NestJS -> PostgreSQL).

- [x] **Phase 2: Authentication & Identity Management** (COMPLETED)
  - User and RefreshToken models in Prisma schema.
  - Password hashing with bcrypt.
  - JWT Access Token (15m) and Refresh Token (7d) strategy with token rotation.
  - Auth guards (`JwtAuthGuard`, `@Public()`, `@CurrentUser()`).
  - Auth REST endpoints: `/auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/me`.
  - Flutter Mobile: Domain entities, Remote datasource, Repository, Riverpod `AuthNotifier`, `SignInScreen`, `SignUpScreen`.
  - React Admin: Authenticated API integration.
  - Backend and Mobile unit + e2e test suites.

- [ ] **Phase 3: Private Travel Servers & Communities** (NEXT)
  - Server entity creation, server settings, and privacy tiers.
  - Persistent community channels and member rosters.

- [ ] **Phase 4: Member Invitations & RBAC Role System**
- [ ] **Phase 5: Trip Creation & Common Destination Coordination**
- [ ] **Phase 6: Consent-Based Location Engine & Ephemeral Telemetry**
- [ ] **Phase 7: Shared Group Maps & Convoy Tracking**
- [ ] **Phase 8: Individual Navigation Routes toward Common Destination**
- [ ] **Phase 9: Low-Latency Group Voice & Spatial Audio (LiveKit)**
- [ ] **Phase 10: Real-Time Messaging & Trip Announcements**
- [ ] **Phase 11: Emergency SOS & Convoy Breakdown Alerts**
- [ ] **Phase 12: Shared Itinerary & Waypoint Management**
- [ ] **Phase 13: Multi-Currency Expense Ledger & Splitting**
- [ ] **Phase 14: Shared Convoy Music Queue**
- [ ] **Phase 15: Offline Caching & Background Synchronization**
- [ ] **Phase 16: Admin Web Console & Platform Telemetry**
- [ ] **Phase 17: Security Hardening & Performance Optimization**
- [ ] **Phase 18: Production Cloud Deployment & Public Launch**
