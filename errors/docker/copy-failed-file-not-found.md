# COPY failed: file not found in build context

> COPY failed: file not found in build context
> failed to compute cache key: "/app.js" not found: not found
> COPY failed: stat /var/lib/docker/tmp/.../package.json: no such file or directory

## What happened

Docker can't find a file you're trying to COPY into the image. The file either doesn't exist where you think it does, or it's being excluded by `.dockerignore`.

## Why it happens

`COPY` paths are relative to the build context (the directory you pass to `docker build`). Docker sends that directory to the daemon and COPY can only access files inside it. If the file is outside the context, listed in `.dockerignore`, or the path is wrong, it fails.

## How to fix it

```bash
# Check your build context - what directory are you passing?
docker build -t myapp .  # "." is the build context

# Verify the file exists relative to the build context
ls -la package.json

# Check if .dockerignore is excluding it
cat .dockerignore
```

Common fixes in the Dockerfile:

```dockerfile
# Wrong: absolute path on host doesn't work
COPY /home/user/app/config.json /app/

# Right: relative to build context
COPY config.json /app/

# Wrong: path outside build context
COPY ../shared/lib.js /app/

# Right: adjust your build context or move the file
# docker build -f app/Dockerfile .  (build context is parent dir)
```

## Don't do this

- Don't `COPY . .` just because a specific file isn't found. Fix the path for the specific file.
- Don't remove `.dockerignore` entirely. It exists to keep `node_modules`, `.git`, and other junk out of your image. Just whitelist the file you need.

## Still not working?

If using Docker Compose, remember the build context is set in `docker-compose.yml`:

```yaml
services:
  app:
    build:
      context: .        # This is the build context
      dockerfile: docker/Dockerfile
```

In multi-stage builds, you can't COPY from the host in a later stage. Use `COPY --from=builder` to copy between stages.
