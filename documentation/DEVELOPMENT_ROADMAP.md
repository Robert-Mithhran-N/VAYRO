# VAYRO — 18-Phase Development Roadmap

**Product:** VAYRO (Move as One)  
**Strategy:** Production-oriented, incremental, test-driven  
**Current Milestone:** Phase 1 (Foundation Setup)  

---

## Roadmap Dependency Graph

```
Phase 1: Foundation Setup (COMPLETED)
   │
   ├──► Phase 2: Authentication & Identity
   │       │
   │       ├──► Phase 3: Travel Servers & Communities
   │       │       │
   │       │       └──► Phase 4: Member Invitations & RBAC Roles
   │       │               │
   │       │               └──► Phase 5: Trip Creation & Common Destination
   │       │                       │
   │       │                       ├──► Phase 6: Consent-Based Location Engine
   │       │                       │       │
   │       │                       │       └──► Phase 7: Shared Group Maps & Convoy Tracking
   │       │                       │               │
   │       │                       │               └──► Phase 8: Individual Navigation Routes
   │       │                       │
   │       │                       ├──► Phase 9: Low-Latency Group Voice (LiveKit)
   │       │                       ├──► Phase 10: Messaging & Trip Chat
   │       │                       ├──► Phase 11: Emergency SOS & Alerts
   │       │                       ├──► Phase 12: Shared Itineraries & Waypoints
   │       │                       ├──► Phase 13: Expense Splitting & Ledger
   │       │                       └──► Phase 14: Shared Convoy Music Queue
   │       │
   │       └──► Phase 15: Offline Caching & Background Sync
   │
   └──► Phase 16: Admin Web Console & Operations
           │
           └──► Phase 17: Security Hardening & Performance Optimization
                   │
                   └──► Phase 18: Production Cloud Deployment & Store Launch
```

---

## Detailed Phase Breakdown

### Phase 1: Foundation & Monorepo Infrastructure (Current)
- Monorepo directory structure, Git configuration, and CI workflows.
- Flutter mobile client scaffold with Riverpod, go_router, Drift SQLite, and brand design system.
- NestJS backend modular monolith with Prisma ORM, PostgreSQL 16, and Redis 7 in Docker Compose.
- React admin dashboard with Vite, Tailwind CSS, and telemetry cards.
- End-to-end integration smoke test (Flutter -> NestJS -> PostgreSQL).

### Phase 2: Authentication & Identity Management
- JWT access and refresh token strategy with rotation.
- Secure token storage on mobile (`flutter_secure_storage`).
- User profile schemas and avatar upload pipelines.

### Phase 3: Private Travel Servers & Communities
- Server entity creation, server settings, and privacy tiers.
- Persistent community channels and member rosters.

### Phase 4: Member Invitations & RBAC Role System
- Cryptographically secure, expiring invitation links and deep links.
- Granular permissions: Server Owner, Administrator, Lead Navigator, Traveler, Guest.

### Phase 5: Trip Creation & Journey Coordination
- Ephemeral journey entities created within servers.
- Definition of common group destinations and participant rosters.

### Phase 6: Consent-Based Location Engine
- Mobile background location services with battery-efficient geofencing.
- User privacy toggles, precision degradation, and Ghost Mode.

### Phase 7: Shared Group Maps & Real-Time Convoy Visualizer
- Mapbox / Google Maps SDK vector map integration on Flutter.
- Multi-vehicle coordinate markers and real-time interpolation.

### Phase 8: Individual Navigation Routing toward Common Destination
- Independent route calculation from unique starting locations.
- Waypoint convergence algorithms and convoy catch-up alerts.

### Phase 9: Low-Latency Group Voice & Spatial Audio
- LiveKit SFU infrastructure integration.
- Push-to-talk (PTT) and hands-free voice channels for drivers.

### Phase 10: Real-Time Messaging & Trip Announcements
- WebSocket-powered chat channels per trip and server.
- High-priority pinned announcements from navigators.

### Phase 11: Emergency SOS & Convoy Breakdown Alerts
- One-touch emergency beacon with immediate coordinate broadcast.
- Automated convoy notifications for unexpected stops or deviations.

### Phase 12: Shared Itinerary & Waypoint Management
- Multi-day trip schedules, gas stops, scenic overlooks, and lodging check-ins.
- Collaborative itinerary editing with optimistic UI updates.

### Phase 13: Multi-Currency Expense Ledger & Splitting
- Expense logging with receipt attachment.
- Automatic debt simplification and multi-currency exchange conversion.

### Phase 14: Shared Convoy Music Queue
- Collaborative playlist queuing integration.
- Synced playback metadata across convoy vehicles.

### Phase 15: Offline Caching & Background Synchronization
- Local Drift SQLite storage for offline maps, itineraries, and trip notes.
- Conflict-free resolution when re-entering cellular coverage.

### Phase 16: Admin Web Console & Platform Telemetry
- Full operational management for server health, user support, and moderation.
- Live telemetry dashboards for active convoys.

### Phase 17: Security Hardening & Performance Optimization
- Penetration testing, rate limiting, and dependency audits.
- Redis geospatial query optimization and mobile battery profiling.

### Phase 18: Production Cloud Deployment & Public Launch
- Kubernetes / ECS deployment, automated CI/CD pipelines, and multi-region replication.
- Apple App Store and Google Play Store submission and monitoring.

