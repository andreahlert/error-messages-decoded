# Docker multi-stage build has no layer cache

> Docker multi-stage build takes 8 minutes every time even when only application code changed

## What happened
Docker rebuilds all layers every time, even when only the application source code changed, because the layer cache is invalidated early in the Dockerfile.

## Why it happens
Docker invalidates cache from the first changed layer onwards. If you `COPY . .` early in the Dockerfile (before installing dependencies), any source code change invalidates the dependency installation layer. The dependencies are re-installed every build even though `package.json` did not change.

## How to fix it
```dockerfile
# Copy dependency files FIRST, install, THEN copy source code
FROM node:20 AS builder

WORKDIR /app

# Copy only dependency files first (cache layer)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code (this layer invalidates on code changes)
COPY . .
RUN npm run build

FROM node:20-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

```bash
# Use .dockerignore to exclude unnecessary files
echo "node_modules
.git
*.md
dist" > .dockerignore
```

## Still not working?
Ensure `.dockerignore` excludes `node_modules`, `.git`, and other large directories that invalidate cache. Use BuildKit (`DOCKER_BUILDKIT=1`) for better caching. For monorepos, use `--cache-from` to pull cache from a registry. Consider using `--mount=type=cache,target=/root/.npm` to cache npm packages across builds.
