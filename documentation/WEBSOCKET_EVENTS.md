# VAYRO — WebSocket & Real-Time Event Architecture

**Protocol:** Socket.IO / WebSocket  
**Target Gateway Port:** `3000` (or dedicated WS port)  
**Status:** SPECIFICATION / ARCHITECTURAL CONTRACT (Implementation scheduled for Phases 4, 5, 7)  

> [!NOTE]
> **Implementation Status**: This document details the architectural conventions and planned event payloads for real-time telemetry, convoy status, and emergency messaging. These events are scheduled for implementation in upcoming development phases and are NOT active in Phase 1 (Foundation).

---

## 1. WebSocket Namespaces & Room Organization

To prevent event bleeding and unnecessary traffic amplification across clients, VAYRO partitions WebSocket traffic by domain namespace:

| Namespace | Responsibility | Primary Rooms | Planned Phase |
| :--- | :--- | :--- | :--- |
| `/locations` | Ephemeral high-frequency GPS telemetry | `trip:<trip_id>` | Phase 4 |
| `/convoy` | Convoy status, member join/leave, speed | `trip:<trip_id>` | Phase 4 |
| `/chat` | Group trip messages and announcements | `trip:<trip_id>`, `server:<server_id>` | Phase 6 |
| `/emergency` | High-priority SOS beacons and panic alerts | `trip:<trip_id>`, `server:<server_id>` | Phase 7 |

---

## 2. Event Conventions & Naming Standard

- **Client to Server (Egress)**: `domain:action` (e.g. `location:update`, `convoy:join`, `emergency:trigger`)
- **Server to Client (Ingress)**: `domain:event` (e.g. `location:broadcast`, `convoy:member_joined`, `emergency:alert`)

---

## 3. Core Event Specifications

### 3.1 Location Stream (`/locations`)

#### `location:update` (Client -> Server)
Emitted by the mobile client when moving and sharing consent is active.
```json
{
  "tripId": "trip_01HXYZ...",
  "latitude": 37.774929,
  "longitude": -122.419416,
  "heading": 184.2,
  "speed": 62.5,
  "accuracy": 4.1,
  "altitude": 15.2,
  "timestamp": 1731320000000
}
```

#### `location:broadcast` (Server -> Trip Room)
Broadcast by the backend to all other authorized participants in the trip.
```json
{
  "userId": "usr_99AABB...",
  "tripId": "trip_01HXYZ...",
  "latitude": 37.774929,
  "longitude": -122.419416,
  "heading": 184.2,
  "speed": 62.5,
  "timestamp": 1731320000000
}
```

---

### 3.2 Convoy Events (`/convoy`)

#### `convoy:status_change`
Broadcast when a vehicle stops, falls behind, or reroutes.
```json
{
  "userId": "usr_99AABB...",
  "tripId": "trip_01HXYZ...",
  "status": "STOPPED",
  "reason": "FUEL_STOP",
  "etaRemainingSeconds": 1820
}
```

---

### 3.3 Emergency Events (`/emergency`)

#### `emergency:alert` (Highest Priority)
Broadcast to every member of the trip and server regardless of muted status.
```json
{
  "alertId": "emg_777...",
  "userId": "usr_99AABB...",
  "tripId": "trip_01HXYZ...",
  "type": "VEHICLE_BREAKDOWN",
  "latitude": 37.774929,
  "longitude": -122.419416,
  "timestamp": 1731320000000,
  "message": "Engine overheated on Highway 101 shoulder."
}
```
