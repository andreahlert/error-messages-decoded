The `UnixHTTPConnectionPool` timeout typically means Docker Compose can't reach the Docker daemon via the Unix socket. Here are the root causes and specific fixes:

## Root Causes (in order of likelihood)

1. **Docker daemon not running** — most common
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker  # autostart on reboot
   ```

2. **Socket permission issue** — Docker socket exists but your user can't access it
   ```bash
   # Check if you're in docker group
   groups $USER
   
   # If docker is missing:
   sudo usermod -aG docker $USER
   newgrp docker  # apply group changes
   ```

3. **Docker daemon stuck or unresponsive** — restart it
   ```bash
   sudo systemctl restart docker
   ```

4. **Incorrect Docker socket path** — check Docker is using the standard socket
   ```bash
   ls -la /var/run/docker.sock  # should exist
   
   # If using different socket, set in docker-compose:
   # Add to docker-compose.yml:
   # version: '3'
   # services:
   #   ...
   # 
   # Or export: export DOCKER_HOST=unix:///path/to/socket
   ```

5. **Resource exhaustion** — Docker daemon can't handle more connections
   ```bash
   # Check if Docker is actually responding
   docker ps
   
   # If it's slow/hangs, restart and check system resources
   docker system prune -a  # free up space if disk is full
   ```

## Quick Diagnostic

Run this to identify which issue you have:

```bash
# Is Docker running?
sudo systemctl status docker

# Can you reach the socket?
docker ps

# If that times out too, Docker daemon is stuck — restart it
sudo systemctl restart docker
```

**Most likely fix**: The Docker daemon isn't running or not responding. Start with `sudo systemctl restart docker`, then verify with `docker ps`. If that works, `docker-compose up` will work.

What does `docker ps` return when you run it? That'll tell us which issue you're hitting.
