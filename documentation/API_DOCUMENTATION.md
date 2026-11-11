# VAYRO — REST API Documentation & Guidelines

**API Version:** v1  
**Base Path:** `/api/v1`  
**Swagger Interactive Explorer:** `http://localhost:3000/api/docs`  
**Protocol:** HTTPS in Production, HTTP in Development  

---

## 1. RESTful Design Conventions

1. **Versioning**: All endpoints are prefixed with `/api/v1`.
2. **Resource Naming**: Plural nouns for collections (e.g., `/servers`, `/trips`, `/locations`).
3. **HTTP Verbs**:
   - `GET`: Read resource or collection. Safe and idempotent.
   - `POST`: Create resource or trigger action (e.g., invite, broadcast).
   - `PUT`: Complete replacement of resource.
   - `PATCH`: Partial update of resource fields.
   - `DELETE`: Remove resource.
4. **Content Type**: `application/json` for all request payloads and responses.

---

## 2. Standard Response Format

All API responses follow a uniform JSON envelope:

### Success Response Envelope
```json
{
  "status": "ok",
  "service": "vayro-backend",
  "version": "1.0.0",
  "timestamp": "2026-11-11T12:00:00.000Z",
  "data": { ... }
}
```

### Error Response Envelope
```json
{
  "status": "error",
  "service": "vayro-backend",
  "version": "1.0.0",
  "timestamp": "2026-11-11T12:00:00.000Z",
  "path": "/api/v1/health",
  "error": {
    "code": "BAD_REQUEST",
    "message": "Validation failed: client must be a string",
    "details": [ ... ]
  }
}
```

---

## 3. Foundation Endpoints

### 3.1 Basic Health Check
- **Route:** `GET /api/v1/health`
- **Auth Required:** No
- **Description:** Verifies that the NestJS process is running and responding.
- **Sample Output:**
  ```json
  {
    "status": "ok",
    "service": "vayro-backend",
    "version": "1.0.0",
    "timestamp": "2026-11-11T12:00:00.000Z"
  }
  ```

### 3.2 PostgreSQL Database Health Check
- **Route:** `GET /api/v1/health/database`
- **Auth Required:** No
- **Description:** Executes live `$queryRaw SELECT 1` against PostgreSQL via Prisma.
- **Sample Output:**
  ```json
  {
    "status": "ok",
    "service": "vayro-backend",
    "version": "1.0.0",
    "timestamp": "2026-11-11T12:00:00.000Z",
    "database": {
      "status": "healthy",
      "latencyMs": 4
    }
  }
  ```

### 3.3 Redis Health Check
- **Route:** `GET /api/v1/health/redis`
- **Auth Required:** No
- **Description:** Sends live `PING` command to Redis cluster/standalone instance.
- **Sample Output:**
  ```json
  {
    "status": "ok",
    "service": "vayro-backend",
    "version": "1.0.0",
    "timestamp": "2026-11-11T12:00:00.000Z",
    "redis": {
      "status": "healthy",
      "latencyMs": 2
    }
  }
  ```

### 3.4 Integration Smoke Test
- **Route:** `GET /api/v1/health/smoke-test`
- **Query Parameters:**
  - `client` (string, optional): Calling client name (e.g. `vayro-mobile-client`).
  - `note` (string, optional): Debug label.
- **Auth Required:** No (Dev-only)
- **Description:** Validates end-to-end integration by querying or creating a record in `dev_health_records` table and returning full matrix.

---

## 4. Authentication & Authorization Expectations

1. **Bearer Token Authentication**: Future protected routes require an `Authorization` header formatted as:
   ```text
   Authorization: Bearer <jwt_access_token>
   ```
2. **Token Renewal**: Mobile and Admin clients will support silent token refresh via HTTP-only secure cookie or refresh token rotation.
3. **Role Enforcement**: User authorization will be checked at controller boundary using `@Roles(...)` decorators and NestJS guards.

