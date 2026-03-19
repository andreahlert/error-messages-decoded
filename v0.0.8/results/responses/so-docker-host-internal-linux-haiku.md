## Root Cause

`host.docker.internal` is a Docker Desktop feature (Mac/Windows only). On Linux, Docker runs natively without a VM layer, so this hostname doesn't exist by default.

## Solutions (pick one)

### 1. **Use the default bridge gateway** (simplest)
The host is accessible at `172.17.0.1`:
```bash
docker run myimage curl http://172.17.0.1:8000
```

**Problem:** IP is hardcoded. Breaks if using custom networks.

### 2. **Use the host's actual IP** (more reliable)
```bash
docker run myimage curl http://host-machine-ip:8000
```
Replace `host-machine-ip` with the result of `hostname -I` on the host.

**Problem:** Need to know/set the IP at runtime.

### 3. **Add to docker-compose** (recommended for compose projects)
```yaml
version: '3'
services:
  app:
    environment:
      - HOST_IP=${HOST_IP}  # Pass as: docker-compose up (with HOST_IP set)
```

Then in your code use `$HOST_IP` instead of `host.docker.internal`.

### 4. **Use `--network host`** (if isolation not needed)
```bash
docker run --network host myimage
```
Container sees host's network directly. **Downside:** loses network isolation; ports bind to host automatically.

### 5. **Docker 20.10+: Enable host.docker.internal**
```bash
docker run --add-host=host.docker.internal:host-gateway myimage
```
This is the Docker-native approach if you're on Linux 5.10+.

## Quick Fix
Add this to your Dockerfile or docker-compose:
```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

This works on Docker 20.10+ and is the cleanest solution for Linux.
