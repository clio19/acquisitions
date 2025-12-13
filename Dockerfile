FROM node:18-alpine AS base
WORKDIR /app

# copy only package files first for better cache
COPY package.json package-lock.json* ./

# install deps as root (avoids permission issues), omit dev deps in production
RUN npm ci --omit=dev

# copy app sources
COPY . .

# ensure node user owns files (so runtime as non-root works)
RUN chown -R node:node /app

USER node
EXPOSE 3000
ENV NODE_ENV=production
CMD ["npm", "start"]