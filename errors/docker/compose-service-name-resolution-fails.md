# Docker Compose service name DNS resolution fails

> getaddrinfo ENOTFOUND backend

## What happened
A container in Docker Compose cannot resolve another service by its name (e.g., `backend`), getting a DNS lookup failure.

## Why it happens
Services can only resolve each other by name if they are on the same Docker network. If services are defined in different Compose files without a shared network, or if a custom network configuration overrides the default network, DNS resolution between services breaks. Also, `depends_on` does not create network connectivity, it only controls startup order.

## How to fix it
```yaml
# docker-compose.yml - services on the default network can resolve each other
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    # Use the service name as hostname
    environment:
      API_URL: http://backend:8080

  backend:
    build: ./backend
    ports:
      - "8080:8080"

# If using custom networks, put both services on the same network
services:
  frontend:
    networks:
      - app-network
  backend:
    networks:
      - app-network

networks:
  app-network:
```

## Still not working?
Verify both services are running with `docker compose ps`. Test DNS from inside the container: `docker exec frontend nslookup backend`. If services are in different Compose files, create an external network and reference it in both. Check that the service name in your connection string matches the service name in `docker-compose.yml` exactly (case-sensitive).
