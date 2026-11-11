# VAYRO — Security Architecture & Guidelines

**Policy Version:** 1.0.0  
**Effective Date:** November 11, 2026  
**Status:** Mandatory Standard  

---

## 1. Secrets Management Policy

1. **Zero Credentials in Source Code**: No passwords, database URIs, API keys, JWT signing secrets, or private keys are allowed in source files, commit messages, or Git history.
2. **Environment File Hygiene**:
   - `.env` files are globally ignored by `.gitignore`.
   - Only `.env.example` templates containing non-functional placeholders are committed.
3. **Client-Side Secret Isolation**:
   - **Never embed database credentials, service-role keys, or LiveKit admin secrets in the Flutter mobile client or Admin dashboard**.
   - Mobile client only stores ephemeral user JWT tokens in platform-level encrypted storage (`flutter_secure_storage` with Android KeyStore and iOS Keychain).

---

## 2. Authentication & Authorization Boundaries

1. **Boundary Enforcement**: Authentication is verified at the API gateway layer in NestJS using Passport JWT strategy guards.
2. **Role-Based Access Control (RBAC)**:
   - Server roles (`OWNER`, `ADMIN`, `MODERATOR`, `MEMBER`) govern community management.
   - Trip roles (`LEAD_NAVIGATOR`, `PARTICIPANT`, `VIEWER`) govern live telemetry broadcasting.
3. **Least Privilege**: Prisma database connections use a dedicated PostgreSQL user (`vayro_user`) with restricted schema permissions in production.

---

## 3. Location Privacy & Telemetry Ethics

Because location data is uniquely sensitive, VAYRO enforces strict privacy safeguards:

1. **Explicit Opt-in Consent**:
   - Location streaming requires active, explicit user consent on the mobile client.
   - Background location permissions are requested with prominent in-app rationales.
2. **Trip-Bound Lifetimes**:
   - Location broadcasts terminate automatically when a trip concludes or when the user leaves the convoy.
   - Historical location crumbs are aggregated and anonymized or purged according to user data retention preferences.
3. **Ghost / Privacy Mode**:
   - Users may enter "Ghost Mode" at any time to pause coordinate broadcasts while continuing to view the group destination.

---

## 4. Input Validation & Defense-in-Depth

1. **Strict DTO Validation**: All ingress HTTP endpoints enforce validation using `class-validator` and `class-transformer` through `globalValidationPipe` (`whitelist: true`, `forbidNonWhitelisted: true`).
2. **SQL Injection Prevention**: All database access is mediated by Prisma ORM's parameterized queries. Raw SQL is strictly constrained and parameterized.
3. **CORS Control**: Cross-Origin Resource Sharing is restricted via `CORS_ORIGINS` environment variables.
4. **Error Sanitization**: `AllExceptionsFilter` catches unhandled exceptions and prevents internal error traces, database connection strings, or system paths from leaking to HTTP clients.
5. **Rate Limiting**: Throttling guards will protect authentication and high-frequency endpoints from abuse.

