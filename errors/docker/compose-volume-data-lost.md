# Docker Compose data lost after down and up

> Database is empty after running docker-compose down and docker-compose up

## What happened
Data stored in a Docker volume disappeared after running `docker-compose down` and `docker-compose up`.

## Why it happens
Running `docker-compose down -v` (with the `-v` flag) removes named volumes along with the containers. Even without `-v`, if the volume is defined as an anonymous volume (no name in the `volumes` key), it gets a random name and a new one is created on `docker-compose up`. Data only persists in explicitly named volumes.

## How to fix it
```yaml
# docker-compose.yml - use named volumes
services:
  db:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data  # named volume reference

volumes:
  pgdata:  # declare the named volume
    # Optional: mark as external to prevent accidental deletion
    # external: true
```

```bash
# NEVER use -v flag with down unless you want to delete data
docker-compose down     # safe - keeps volumes
docker-compose down -v  # DELETES volumes and data!

# List existing volumes
docker volume ls

# Inspect a volume
docker volume inspect <project>_pgdata
```

## Still not working?
If you used `docker-compose down -v` already, the data is gone and cannot be recovered. To prevent this in the future, mark volumes as `external: true` in your compose file, which prevents `docker-compose down -v` from removing them. Create the external volume manually with `docker volume create pgdata`.
