# Docker Compose build cannot find Dockerfile

> failed to solve: failed to read dockerfile: open Dockerfile: no such file or directory

## What happened
`docker compose build` fails because it cannot find the Dockerfile at the expected path relative to the build context.

## Why it happens
In Docker Compose, the `build.context` defines the root directory sent to the Docker daemon. If the Dockerfile is not in that context directory, or the `dockerfile` path is specified relative to the wrong location, the build fails. A common mistake is setting `context: .` from the project root when the Dockerfile is in a subdirectory.

## How to fix it
```yaml
# docker-compose.yml
services:
  app:
    build:
      # Context is the directory sent to Docker
      context: ./backend
      # Dockerfile path is relative to the context
      dockerfile: Dockerfile

  # If Dockerfile is in a different location than the context:
  frontend:
    build:
      context: .
      dockerfile: ./frontend/Dockerfile
      # Files in Dockerfile COPY are relative to context (.), not dockerfile location
```

## Still not working?
Check that the Dockerfile exists at the resolved path: `ls -la <context>/<dockerfile>`. Remember that `COPY` and `ADD` commands in the Dockerfile are relative to the `context` directory, not the Dockerfile's location. If using a monorepo, set context to the repo root and specify the dockerfile path explicitly.
