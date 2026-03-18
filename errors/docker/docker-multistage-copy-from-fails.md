# Docker COPY --from fails with file not found

> COPY failed: stat /var/lib/docker/overlay2/.../merged/app/build: file does not exist

## What happened
A `COPY --from=builder` instruction in a multi-stage Dockerfile fails because the expected file or directory does not exist in the build stage.

## Why it happens
The build stage did not produce the expected output at the path specified in `COPY --from`. Common causes: the build command failed silently, the output path is wrong, the stage name does not match, or the WORKDIR in the build stage differs from what the COPY expects.

## How to fix it
```dockerfile
# Name the build stage explicitly with AS
FROM node:20 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
# Verify build output: RUN ls -la /app/build

# Reference the stage name in COPY --from
FROM node:20-slim
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "build/index.js"]
```

```bash
# Debug: build just the first stage and check output
docker build --target builder -t debug-build .
docker run --rm debug-build ls -la /app/build
```

## Still not working?
Add `RUN ls -la /app/` before the final `FROM` to verify the build output exists and is at the expected path. Check that the `--from` stage name matches the `AS` alias exactly. If using numeric indices (`--from=0`), make sure the stage order has not changed. Verify the build command in the stage actually produces output (check exit codes).
