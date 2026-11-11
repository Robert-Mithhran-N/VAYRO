# VAYRO — Developer Environment Setup & Execution Guide

**Document Version:** 1.0.0  
**Target Platform:** Windows 10/11, macOS, Linux  
**Status:** Approved Foundation  

---

## 1. Prerequisites & Required Toolchain

Ensure the following tools are installed on your workstation:
- **Node.js**: v20.x or v22.x+ LTS (Host has `v24.17.0`)
- **npm**: v10.x+ (Host has `11.13.0`)
- **Git**: v2.30+ (Host has `2.56.0`)
- **Java JDK**: 17+ or 21+ LTS (Host has `25.0.2 LTS`)
- **Docker Desktop**: Docker Engine & Docker Compose (Required for PostgreSQL & Redis)
- **Flutter SDK**: v3.24+ Stable (Includes Dart 3.5+)

---

## 2. Environment Configuration

Copy the example environment files in each project directory:

```bash
# Backend configuration
cp backend/.env.example backend/.env

# Admin configuration
cp admin/.env.example admin/.env

# Mobile configuration
cp mobile/.env.example mobile/.env
```

---

## 3. Starting Infrastructure Services (Docker)

To launch the development database and Redis cache:

```bash
# Start PostgreSQL (5432) and Redis (6379) in the background
docker compose up -d

# Verify container health status
docker compose ps
```

To stop containers:
```bash
docker compose down
```

> [!WARNING]
> To reset and completely delete the development database:
> ```bash
> docker compose down -v
> ```

---

## 4. Starting the NestJS Backend API

From the root directory or inside `backend/`:

```bash
# 1. Install dependencies
cd backend
npm install

# 2. Run Prisma migrations against local PostgreSQL
npm run prisma:generate
npm run prisma:migrate

# 3. Seed initial development record
npm run prisma:seed

# 4. Start NestJS in development watch mode
npm run start:dev
```

The API will be accessible at:
- Base API: `http://localhost:3000/api/v1`
- Health Endpoint: `http://localhost:3000/api/v1/health`
- Integration Smoke Test: `http://localhost:3000/api/v1/health/smoke-test`
- Swagger Interactive Explorer: `http://localhost:3000/api/docs`

---

## 5. Starting the React Admin Dashboard

From the root directory or inside `admin/`:

```bash
# 1. Install dependencies
cd admin
npm install

# 2. Start Vite development server
npm run dev
```

The Admin Console will be available at:
`http://localhost:5173`

---

## 6. Starting the Flutter Mobile Client

From the root directory or inside `mobile/`:

```bash
# 1. Resolve Flutter dependencies
cd mobile
flutter pub get

# 2. Run Flutter analysis
flutter analyze

# 3. Launch the app on an active device/emulator
flutter run
```

### Critical Device Networking Rules
- **Android Emulator**: Uses `http://10.0.2.2:3000/api/v1` (Default preset in Settings).
- **iOS Simulator / Desktop / Web**: Uses `http://127.0.0.1:3000/api/v1`.
- **Physical Phone (USB or Wi-Fi)**:
  - `localhost` on the phone points to the phone itself, NOT your PC!
  - Navigate to in-app **Settings** > **Custom Endpoint Address**.
  - Enter your computer's LAN IPv4 address (e.g. `http://192.168.1.150:3000/api/v1`).
  - Ensure your Windows Defender Firewall permits incoming connections on port `3000`.

---

## 7. Running Test Suites

### Backend Tests
```bash
cd backend
npm test
npm run test:e2e
```

### Admin Tests
```bash
cd admin
npm test
npm run build
```

### Flutter Tests
```bash
cd mobile
flutter test
```

---

## 8. Troubleshooting Common Errors

### "Cannot connect to backend from physical Android device"
- Verify that your PC and phone are on the exact same Wi-Fi subnet.
- Verify your PC's IP using `ipconfig` (Windows) or `ifconfig` (Mac/Linux).
- Temporarily check if Windows Firewall is blocking inbound TCP on port 3000.

### "Prisma Client cannot connect to database"
- Ensure Docker Desktop is active and `docker compose ps` shows `vayro-postgres` as healthy.
- Verify `DATABASE_URL` in `backend/.env`.

### "Docker is not recognized on Windows"
- Install Docker Desktop with the WSL2 backend enabled from [docker.com](https://www.docker.com/).

