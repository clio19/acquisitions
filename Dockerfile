# syntax=docker/dockerfile:1

FROM node:20-slim AS base
WORKDIR /app

# Install deps (with dev deps for the development image)
FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci

# Development image (bind-mount friendly)
FROM deps AS development
ENV NODE_ENV=development
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Production deps (omit dev dependencies)
FROM base AS prod-deps
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Production runtime image
FROM base AS production
ENV NODE_ENV=production

# Copy only what we need at runtime
COPY --from=prod-deps /app/node_modules ./node_modules
COPY package.json ./package.json
COPY src ./src

# Run as non-root
USER node
EXPOSE 3000
CMD ["npm", "start"]
