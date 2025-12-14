<div align="center">
  <br />
      <img src="public/readme/hero.webp" alt="Project Banner">
  <br />

  <div>
<img src="https://img.shields.io/badge/-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"/>
<img src="https://img.shields.io/badge/-Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white"/>
<img src="https://img.shields.io/badge/-Express.js-000000?style=for-the-badge&logo=express&logoColor=white"/>
<img src="https://img.shields.io/badge/-Neon%20Postgres-2496ED?style=for-the-badge&logo=postgresql&logoColor=white"/>
<img src="https://img.shields.io/badge/-Drizzle%20ORM-FFDF00?style=for-the-badge&logo=drizzle&logoColor=black"/>

  </div>

  <h3 align="center">Scalable Production Ready API</h3>

</div>


## <a name="tech-stack">⚙️ Tech Stack</a>

- **[Arcjet](https://jsm.dev/dops25-arcjet)** is a developer-first security layer that enables you to protect your applications with minimal code. It offers features like bot protection, rate limiting, email validation, and defense against common attacks. Arcjet's SDK integrates seamlessly into your application, providing real-time security decisions without the need for additional infrastructure.


- **[Docker](https://www.docker.com/)** is a leading containerization platform that allows you to package applications along with all their dependencies into portable, lightweight containers. This ensures consistent behavior across different environments, simplifies deployment, and makes scaling applications more efficient.  

- **[Kubernetes](https://kubernetes.io/)** is an open-source orchestration system designed to automate the deployment, scaling, and management of containerized applications. It handles tasks like load balancing, self-healing, and rolling updates, making it essential for running applications reliably at scale.  

- **[Warp](https://jsm.dev/dops25-warp)** is a modern terminal built in Rust, optimized for developer productivity. It offers features like AI-assisted commands, easy collaboration, command history search, and a faster, more intuitive interface compared to traditional terminals.  

- **[Node.js](https://nodejs.org/)** is a fast, event-driven JavaScript runtime built on Chrome’s V8 engine. It enables developers to build scalable, high-performance server-side applications and APIs using JavaScript on both the client and server side.  

- **[Express.js](https://expressjs.com/)** is a minimal and flexible Node.js web application framework. It provides robust features for building APIs and server-side applications, including routing, middleware support, and simplified request/response handling.  

- **[Neon Postgres](https://jsm.dev/dops25-neon)** is a fully managed, serverless Postgres database designed for modern cloud applications. It offers autoscaling, branching for development workflows, and simplifies database management without compromising performance.  

- **[Drizzle ORM](https://orm.drizzle.team/)** is a TypeScript-first, lightweight ORM for SQL databases. It provides type safety, schema migrations, and an intuitive API for building reliable and maintainable database queries.  

- **[Zod](https://zod.dev/)** is a TypeScript-first schema validation library that ensures runtime type safety. It helps developers validate data structures, enforce strict type checks, and catch errors early in the development process.  

## <a name="features">🔋 Features</a>

👉 **Absolute Imports**: Clean import paths using `#` prefix aliases for more organized and readable code.  

👉 **Business Listings**: Create, update, delete, and browse business listings efficiently.  

👉 **Database Integration**: Integrate PostgreSQL with Drizzle ORM, including migrations for schema management.  

👉 **Deal Management**: Create deals on listings, accept or reject offers, and track deal status.  

👉 **Docker Support**: Full containerization with development and production environments for consistent deployment.  

👉 **ESLint + Prettier**: Enforce code linting and formatting rules for cleaner, consistent code.  

👉 **Health Monitoring**: Endpoint to check system health and monitor overall application status.  

👉 **Hot Reload**: Development server automatically restarts on file changes for faster iteration.  

👉 **Jest Testing**: Framework for unit and integration testing with SuperTest for HTTP endpoints.  

👉 **Request Validation**: Validate all API inputs using Zod schemas to ensure data integrity.  

👉 **Role-Based Access Control**: Implement admin and user roles with permission middleware for secure operations.  

👉 **Structured Logging**: Winston-based logging throughout the application for better monitoring and debugging.  

👉 **User Authentication & Authorization**: JWT-based authentication supporting signup, signin, and signout workflows.  

👉 **User Management**: CRUD operations for user accounts, enabling easy administration and management.


And many more, including code architecture and reusability.

## <a name="quick-start">🤸 Quick Start</a>

Follow these steps to set up the project locally on your machine.

**Prerequisites**

Make sure you have the following installed on your machine:

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en)
- [npm](https://www.npmjs.com/) (Node Package Manager)

## Prerequisites

- Docker Desktop / Docker Engine with `docker compose`
- A Neon account + Neon project (for Neon Local to proxy to)

## Environment files

You will typically have these files locally (they are gitignored):

- `.env.development` (app settings for local dev)
- `.env.neon-local` (Neon Local proxy settings)
- `.env.production` (app settings for production-like runs)

### Development DATABASE_URL

In `.env.development`:

- `DATABASE_URL=postgres://neon:npg@neon-local:5432/neondb?sslmode=require`

Inside Compose, the hostname `neon-local` resolves to the Neon Local container.

### Production DATABASE_URL

In `.env.production`:

- `DATABASE_URL=postgres://...neon.tech...` (your Neon Cloud connection string)

## Development: run with Neon Local

1) Fill in `.env.neon-local`:

- `NEON_API_KEY`
- `NEON_PROJECT_ID`
- (recommended) `PARENT_BRANCH_ID`

If you set `PARENT_BRANCH_ID`, Neon Local will create a fresh ephemeral branch when the container starts and delete it when it stops.

2) Start the stack:

```bash
docker compose -f docker-compose.dev.yml up --build
```

The API will be available at:

- `http://localhost:3000`

Neon Local will expose Postgres locally on:

- `postgres://neon:npg@localhost:5432/neondb?sslmode=require`

### Running migrations in dev

From another terminal:

```bash
docker compose -f docker-compose.dev.yml exec app npm run db:migrate
```

### Running tests in dev

```bash
docker compose -f docker-compose.dev.yml exec app npm test
```

## Production: run against Neon Cloud

1) Set your Neon Cloud connection string in `.env.production` (or inject `DATABASE_URL` via your platform/secret manager).

2) Run:

```bash
docker compose -f docker-compose.prod.yml up --build
```

This starts only the API container. The database is **not** started by Compose in production because it is managed by Neon.

## How the app switches between dev and prod

- The app always reads `DATABASE_URL` from environment variables.
- `docker-compose.dev.yml` loads `.env.development` (Neon Local connection string).
- `docker-compose.prod.yml` loads `.env.production` (Neon Cloud connection string).

The code also detects Neon Local/localhost URLs and configures the Neon serverless driver to talk to the Neon Local SQL endpoint.

## Notes / troubleshooting

- If you hit file sharing issues on Windows with the `./.git/HEAD` volume mount, remove the `./.git/HEAD:/tmp/.git/HEAD:ro` line from `docker-compose.dev.yml`. Branch-per-git-branch support is optional.
- Keep secrets out of git. Use your CI/CD or Kubernetes secrets to inject `DATABASE_URL`, `ARCJET_KEY`, and `NEON_API_KEY`.
