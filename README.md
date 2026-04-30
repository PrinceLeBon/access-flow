# AccessFlow – Request Management & Approval System

## Project Overview
AccessFlow is a production-grade, modular fullstack application for managing and approving user requests in an enterprise environment. It features strict clean architecture, RBAC, secure authentication, PostgreSQL database, and a modern Flutter Web frontend.

---

## Requirements

- Docker & Docker Compose (recommended for backend and database)
- Node.js (v18+)
- npm
- Flutter (3.0+)
- PostgreSQL (if not using Docker)

---

## Project Structure

- `/backend` – Node.js, Express, Prisma, PostgreSQL
- `/frontend` – Flutter Web (BLoC, Dio)

---

## Backend Setup

### 1. Environment Variables

Copy `.env` or `.env.development` in `/backend` and set:

```
DATABASE_URL=postgresql://postgres:postgres@localhost:5433/accessflow?schema=public
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
```

### 2. Start with Docker (Recommended)

From the project root:

```
docker compose up --build
```

- This will start:
  - PostgreSQL database (on port 5433)
  - Backend API (on port 4000)
  - Frontend (on port 3000)

### 3. Manual Backend Start (Local Dev)

1. Install dependencies:
   ```
   cd backend
   npm install
   ```
2. Start PostgreSQL locally or with Docker (see above).
3. Run Prisma migrations:
   ```
   npx prisma generate
   npx prisma migrate dev --name init
   ```
4. Start the backend:
   ```
   npm run start
   # or for auto-reload:
   npx nodemon src/index.js
   ```

### 4. API Documentation

- Swagger UI: [http://localhost:4000/api/docs](http://localhost:4000/api/docs)

---

## Frontend Setup

### 1. Install Flutter dependencies

```
cd frontend
flutter pub get
```

### 2. Run the Flutter Web App

```
flutter run -d chrome
```

- The app will be available at [http://localhost:3000](http://localhost:3000) if using Docker, or [http://localhost:8080](http://localhost:8080) if running with `flutter run`.

### 3. Environment Configuration

- API base URL is set in `lib/core/constants/env.dart`.
- For Docker: `http://localhost:4000`
- For local dev: adjust as needed.

---

## Usage

### Backend URLs
- Health check: `GET /health`
- Auth: `POST /api/auth/register`, `POST /api/auth/login`
- Requests: `GET /api/requests`, `POST /api/requests`, etc.
- Admin panel: `GET /admin` (frontend route)
- Swagger docs: `/api/docs`

### Frontend URLs
- `/login` – Login screen
- `/register` – Register screen
- `/requests` – User request list
- `/create-request` – Create a new request
- `/admin` – Admin panel (view/approve/reject requests)

---

## Roles & Permissions

- User: Can create and view their own requests
- Manager: Can approve/reject requests
- Admin: Full access

---

## Notes

- Make sure ports 4000 (backend), 3000 (frontend), and 5433 (PostgreSQL) are available.
- For production, set strong secrets in `.env` files.
- All API endpoints and request/response formats are documented in Swagger UI.
- RBAC and permission checks are enforced on the backend.

---

## Troubleshooting

- If you see database connection errors, ensure PostgreSQL is running and the port matches your `.env`.
- For frontend errors, run `flutter pub get` and `flutter analyze` to check for missing dependencies or code issues.
- For Docker issues, try `docker compose down -v` to reset containers and volumes.

---

## License

MIT
