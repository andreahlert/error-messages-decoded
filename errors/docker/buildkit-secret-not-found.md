# BuildKit secret not found during build

> ERROR: failed to solve: failed to compute cache key: /run/secrets/npmrc not found

## What happened

Your Dockerfile uses `RUN --mount=type=secret` to access a secret file during the build, but Docker can't find it. The secret was never mounted because BuildKit isn't enabled, or the secret wasn't passed correctly to the build command.

## Why it happens

The `--mount=type=secret` syntax is a BuildKit-only feature. Classic Docker builder silently ignores it, meaning `/run/secrets/npmrc` never gets created inside the build context. Even with BuildKit enabled, you still need to explicitly pass the secret file using `--secret` when running `docker build`.

This commonly happens when:

- You're running Docker without `DOCKER_BUILDKIT=1` set
- You forgot the `--secret` flag in the build command
- The `id=` in the Dockerfile doesn't match the `id=` in the build command
- The source file path is wrong or the file doesn't exist on the host

## How to fix it

Make sure BuildKit is enabled and pass the secret at build time:

```bash
# Enable BuildKit and build with the secret
DOCKER_BUILDKIT=1 docker build \
  --secret id=npmrc,src=$HOME/.npmrc \
  -t myapp .
```

Your Dockerfile should reference the same `id`:

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./

# Mount the secret during npm install only
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci --production

COPY . .
CMD ["node", "index.js"]
```

To make BuildKit the default permanently:

```bash
# Option 1: Environment variable (add to ~/.bashrc or ~/.zshrc)
export DOCKER_BUILDKIT=1

# Option 2: Docker daemon config (/etc/docker/daemon.json)
{
  "features": { "buildkit": true }
}

# Restart Docker after changing daemon.json
sudo systemctl restart docker
```

Verify BuildKit is active:

```bash
docker build --help 2>&1 | grep -q "secret" && echo "BuildKit enabled" || echo "BuildKit NOT enabled"
```

## Don't do this

- Don't `COPY .npmrc .` into the image. The `.npmrc` file contains your registry auth token and will be baked into every layer. Anyone who pulls the image can extract it.
- Don't use build args (`ARG NPM_TOKEN`) for secrets either. Build args are visible in `docker history` and image metadata.
- Don't add `.npmrc` and then try to `RUN rm .npmrc` in the same layer or a later layer. Earlier layers still contain the file.

## Still not working?

Check that the secret IDs match exactly between your Dockerfile and build command:

```bash
# Dockerfile says: --mount=type=secret,id=npmrc
# Build command must use the same id:
docker build --secret id=npmrc,src=.npmrc .
#                      ^^^^^^^^ must match
```

If using Docker Compose, secrets require Compose v2 and a specific syntax:

```yaml
# docker-compose.yml
services:
  app:
    build:
      context: .
      secrets:
        - npmrc
secrets:
  npmrc:
    file: ./.npmrc
```

If you're in CI/CD, write the secret to a temp file first:

```bash
echo "$NPM_TOKEN" > /tmp/.npmrc
DOCKER_BUILDKIT=1 docker build --secret id=npmrc,src=/tmp/.npmrc .
rm /tmp/.npmrc
```
