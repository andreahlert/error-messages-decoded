# Root Cause

Docker containers have an isolated network stack. When your container tries to connect to `localhost:5432`, it's looking for PostgreSQL on the container's loopback interface, not the host's. The connection fails because PostgreSQL is running on the **host's** loopback, which the container can't see.

# Fixes (by OS)

## Mac & Windows (Docker Desktop)

Use `host.docker.internal` instead of `localhost`:

```env
DATABASE_URL=postgresql://user:password@host.docker.internal:5432/dbname
```

Or in your Docker run command:
```bash
docker run -e DATABASE_HOST=host.docker.internal myimage
```

## Linux

`host.docker.internal` doesn't exist on Linux. Use one of these:

**Option 1: Use host's actual IP** (most reliable)
```bash
# Find host IP
hostname -I  # e.g., 192.168.1.100

# Then use it in connection string
DATABASE_URL=postgresql://user:password@192.168.1.100:5432/dbname
```

**Option 2: Use `--network host`** (simplest, but less isolation)
```bash
docker run --network host myimage
```

**Option 3: PostgreSQL must listen on all interfaces** (required for any remote connection)
Check `/etc/postgresql/*/main/postgresql.conf`:
```conf
listen_addresses = '*'  # or the specific host IP, not 'localhost'
```

Then restart PostgreSQL and ensure firewall allows port 5432 from Docker's subnet.

## Docker Compose

```yaml
services:
  app:
    environment:
      DATABASE_HOST: host.docker.internal  # Mac/Windows
      # or for Linux: 172.17.0.1 (default Docker bridge gateway)
```

# Verify the fix

From inside the container:
```bash
docker exec mycontainer curl -v telnet://host.docker.internal:5432
# or
docker exec mycontainer psql -h host.docker.internal -U user dbname
```

The most common issue is using `localhost` in the connection string. Switch to `host.docker.internal` (Mac/Windows) or the host's IP (Linux).
