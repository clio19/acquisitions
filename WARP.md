# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Local Development
- `npm run dev` - Start development server with --watch flag
- `npm start` - Start production server
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Run ESLint with auto-fix
- `npm run format` - Format code with Prettier
- `npm run format:check` - Check code formatting
- `npm test` - Run Jest tests (configured for ES modules)

### Database Operations
- `npm run db:generate` - Generate Drizzle migrations
- `npm run db:migrate` - Run database migrations
- `npm run db:studio` - Open Drizzle Studio

### Docker & Deployment
- `docker-compose up` - Run application in Docker (development mode)
- `.\deploy.ps1` - PowerShell script to build, push and deploy to Kubernetes
- `kubectl port-forward svc/kubernetes-demo-app 8080:3000` - Access deployed app locally

## Architecture Overview

### Application Structure
This is a Node.js Express REST API with JWT authentication, built using ES modules. The application follows a layered architecture:

- **Entry Point**: `src/index.js` loads environment and starts server
- **Application**: `src/app.js` configures Express with middleware and routes
- **Server**: `src/server.js` handles HTTP server lifecycle

### Key Technologies
- **Database**: PostgreSQL with Drizzle ORM and Neon serverless driver
- **Security**: Arcjet for rate limiting, bot detection, and security policies
- **Authentication**: JWT-based with bcrypt password hashing
- **Logging**: Winston logger with structured logging
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes with deployment and service manifests

### Directory Structure
- `src/config/` - Database, logging, and Arcjet configuration
- `src/controllers/` - Request handlers for auth and users
- `src/middleware/` - Authentication and security middleware
- `src/models/` - Drizzle database schemas
- `src/routes/` - Express route definitions
- `src/services/` - Business logic layer
- `src/utils/` - Helper utilities (JWT, cookies, formatting)
- `src/validations/` - Zod schema validations
- `k8s/` - Kubernetes deployment and service manifests
- `drizzle/` - Database migration files

### Import Aliases
The project uses Node.js subpath imports (package.json imports field):
- `#src/*` maps to `./src/*`
- `#config/*` maps to `./src/config/*`
- `#controllers/*` maps to `./src/controllers/*`
- `#middleware/*` maps to `./src/middleware/*`
- And similar patterns for all major directories

### Security Implementation
- **Arcjet Integration**: Role-based rate limiting (admin: 20/min, user: 10/min, guest: 5/min)
- **Bot Protection**: Automated request blocking
- **Shield Protection**: Suspicious request filtering
- **Helmet**: Security headers
- **CORS**: Cross-origin request handling

### Database Configuration
- Uses Neon PostgreSQL serverless with Drizzle ORM
- Supports local development with neon-local configuration
- Schema migrations managed via drizzle-kit
- User model with role-based access (admin/user roles)

### Kubernetes Deployment
- 2-replica deployment with resource limits (500m CPU, 512Mi memory)
- Health checks on `/healthz` and readiness checks on `/readyz` endpoints
- NodePort service for external access
- Environment variables for NODE_ENV and POD_NAME

### API Endpoints
- `GET /` - Root endpoint
- `GET /health` - Health check with uptime
- `GET /api` - API status
- `/api/auth/*` - Authentication routes
- `/api/users/*` - User management routes

## Development Notes

### Code Standards
- ES2022 modules with 2-space indentation
- Single quotes for strings
- Semicolons required
- Arrow functions preferred
- No unused variables (prefix with _ to ignore)

### Environment Setup
- Requires `DATABASE_URL` environment variable
- Local development supports neon-local database configuration
- Production uses Neon serverless PostgreSQL

### Testing
- Jest configured for ES modules (`NODE_OPTIONS=--experimental-vm-modules`)
- ESLint configured for test files with Jest globals
- No existing test files - tests should be created in `tests/` directory