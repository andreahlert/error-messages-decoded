# Docker port mapping works but connection refused

> curl: (7) Failed to connect to localhost port 8080: Connection refused

## What happened
Docker maps port 8080 to the container, but connections to `localhost:8080` are refused even though the container is running.

## Why it happens
The application inside the container is binding to `127.0.0.1` (localhost) instead of `0.0.0.0` (all interfaces). When Docker forwards traffic from the host to the container, it arrives on the container's network interface, not on `127.0.0.1`. If the app only listens on `127.0.0.1`, it rejects connections from Docker's bridge network.

## How to fix it
```bash
# Make the application bind to 0.0.0.0 instead of 127.0.0.1
# Node.js
# app.listen(8080, '0.0.0.0');

# Python Flask
# app.run(host='0.0.0.0', port=8080)

# Or use host network mode (no port mapping needed)
docker run --network host myapp
```

```dockerfile
# In Dockerfile, EXPOSE documents the port but does not publish it
EXPOSE 8080
# Use environment variables to control the bind address
ENV HOST=0.0.0.0
CMD ["node", "server.js"]
```

## Still not working?
Check `docker port <container>` to verify the port mapping. Use `docker exec <container> netstat -tlnp` to see what the process is listening on inside the container. If using Docker Compose, verify the `ports` section format is `"8080:8080"`. On Docker Desktop for Mac/Windows, `host.docker.internal` is the host address, not `localhost`.
