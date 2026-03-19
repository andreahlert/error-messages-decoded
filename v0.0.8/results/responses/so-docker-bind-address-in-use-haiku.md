**Root cause:** Another process or Docker container is already listening on the port you're trying to bind.

**How to fix it:**

**Option 1: Find and stop what's using the port**

If you know the port (e.g., 8080):
```bash
# Find the process using the port
lsof -i :8080

# Kill the process (replace PID with the actual ID)
kill -9 <PID>
```

**Option 2: Stop existing Docker containers**

```bash
# List running containers
docker ps

# Stop the container using the port
docker stop <container_id>

# Or stop all containers
docker stop $(docker ps -q)
```

**Option 3: Use a different port**

If you control the command, map to a different port:
```bash
# Instead of -p 8080:8080, use:
docker run -p 8081:8080 <image>

# Or in docker-compose.yml:
ports:
  - "8081:8080"
```

**To find what's using a specific port more directly:**
```bash
# Linux/Mac
netstat -tulpn | grep :8080

# Or (more reliable)
sudo lsof -i -P -n | grep LISTEN
```

**Which option applies?**
- If you just started a container and it won't restart, the old one is still running — use Option 2
- If you have a persistent service running on that port, use Option 1
- If you can't stop what's using it, switch ports with Option 3

What port is the error mentioning?
