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
   - `POST`: Create resource or trigger action (e.g., register, login, refresh).
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
  "timestamp": "2026-11-12T12:00:00.000Z",
  "data": { ... }
}
```

### Error Response Envelope
```json
{
  "status": "error",
  "service": "vayro-backend",
  "version": "1.0.0",
  "timestamp": "2026-11-12T12:00:00.000Z",
  "path": "/api/v1/auth/login",
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid email or password.",
    "details": null
  }
}
```

---

## 3. Endpoints Matrix

### 3.1 Health & Diagnostics
- `GET /api/v1/health`: Basic service vitality check.
- `GET /api/v1/health/database`: Real PostgreSQL connectivity status via Prisma.
- `GET /api/v1/health/redis`: Real Redis connectivity status via ioredis.
- `GET /api/v1/health/smoke-test`: End-to-end integration check across backend, database, and cache.

### 3.2 Authentication & Identity (Phase 2)

#### `POST /api/v1/auth/register`
Registers a new traveler account.
- **Auth Required:** No (`@Public()`)
- **Body:**
  ```json
  {
    "email": "traveler@vayro.app",
    "password": "Password123!",
    "displayName": "Alex Rivera"
  }
  ```
- **Response (201 Created):**
  ```json
  {
    "user": {
      "id": "usr_uuid_1234",
      "email": "traveler@vayro.app",
      "displayName": "Alex Rivera",
      "role": "USER",
      "isActive": true
    },
    "tokens": {
      "accessToken": "eyJhbGciOi...",
      "refreshToken": "eyJhbGciOi...",
      "tokenType": "Bearer",
      "expiresIn": "15m"
    }
  }
  ```

#### `POST /api/v1/auth/login`
Authenticates existing traveler with email and password.
- **Auth Required:** No (`@Public()`)
- **Body:**
  ```json
  {
    "email": "traveler@vayro.app",
    "password": "Password123!"
  }
  ```
- **Response (200 OK):** Same payload as register.

#### `POST /api/v1/auth/refresh`
Rotates and issues new token pair using a valid refresh token.
- **Auth Required:** No (`@Public()`)
- **Body:**
  ```json
  {
    "refreshToken": "eyJhbGciOi..."
  }
  ```
- **Response (200 OK):**
  ```json
  {
    "accessToken": "eyJhbGciOi...",
    "refreshToken": "eyJhbGciOi...",
    "tokenType": "Bearer",
    "expiresIn": "15m"
  }
  ```

#### `POST /api/v1/auth/logout`
Revokes active refresh tokens.
- **Auth Required:** Yes (`Bearer <accessToken>`)
- **Body (Optional):**
  ```json
  {
    "refreshToken": "eyJhbGciOi..."
  }
  ```
- **Response (200 OK):** `{ "message": "Logged out successfully." }`

#### `GET /api/v1/auth/me`
Retrieves currently authenticated user profile.
- **Auth Required:** Yes (`Bearer <accessToken>`)
- **Response (200 OK):** User entity without password hash.
