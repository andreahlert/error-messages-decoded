## Root Cause

Docker Compose's `depends_on` only waits for containers to **start**, not for them to become **healthy**. The healthcheck status is determined separately and is not a blocking condition for dependent services.

## The Fix

Add `condition: service_healthy` to `depends_on`:

```yaml
version: '3.8'

services:
  container_a:
    image: postgres:latest
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  container_b:
    image: myapp:latest
    depends_on:
      container_a:
        condition: service_healthy  # ← This is the key
```

## How it works

- **`condition: service_healthy`** tells Compose to wait until the specified service's healthcheck passes
- Without this, Compose only waits for `service_started` (default)
- The healthcheck must be defined on the service being waited for

## Important Notes

1. **This only works in Compose v2.1+** - Verify your version with `docker-compose --version`
2. **Healthcheck must exit 0 on success** - Your test command must return exit code 0 when healthy
3. **Startup order matters** - The healthcheck on `container_a` will start immediately when the container starts, so `container_b` will wait appropriately

If you're still having issues, share your docker-compose.yml and I can help debug the specific healthcheck command.
