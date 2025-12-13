# kubernetes-demo (Acquisitions API)

This is a Node.js (Express) API that uses Drizzle ORM with Neon.

The project supports two database modes:

- Development (local): **Neon Local** proxy in Docker (ephemeral branches)
- Production: **Neon Cloud** (no proxy container)

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
