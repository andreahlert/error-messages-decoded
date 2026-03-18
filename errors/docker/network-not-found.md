# Docker network not found

> Error response from daemon: network myapp_default not found
> failed to create endpoint on network bridge: network bridge not found
> could not find network mynetwork: network mynetwork not found

## What happened

Docker is trying to connect a container to a network that doesn't exist. This usually happens after a `docker-compose down`, a Docker daemon restart, or when referencing a network from another compose stack.

## Why it happens

Docker Compose creates networks with a prefix based on the project directory name. If you renamed the folder, ran `docker-compose down` (which removes networks), or are referencing an external network that hasn't been created yet, the network won't be found.

## How to fix it

```bash
# List existing networks
docker network ls

# Create the missing network manually
docker network create mynetwork

# If using Compose, just bring the stack up (it creates networks)
docker compose up -d
```

If you're referencing a network from another compose stack:

```yaml
# docker-compose.yml
networks:
  shared:
    external: true
    name: actual-network-name  # must match exactly
```

```bash
# Create it if it doesn't exist
docker network create actual-network-name
```

## Don't do this

- Don't hardcode network names with underscores assuming Compose's naming convention. Use `docker network ls` to check the actual name.
- Don't use `docker-compose down` in production if other services depend on the shared network. Use `docker-compose stop` instead (it preserves networks).

## Still not working?

If `docker network ls` shows the network but containers still can't find it, the Docker daemon might be in a bad state:

```bash
# Prune orphaned networks
docker network prune

# Restart Docker daemon as last resort
sudo systemctl restart docker
```

For Compose v2, the default network name changed from `folder_default` to `folder-default` (underscore to hyphen). Check which version you're running with `docker compose version`.
