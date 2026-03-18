# Root Cause

`host.docker.internal` is a DNS name provided by **Docker Desktop** (macOS/Windows only). On Linux with the native Docker daemon, this name doesn't resolve—it simply doesn't exist in the container's DNS.

# Solutions

**1. Use the gateway IP (simplest)**
The host is reachable at the default bridge gateway:
```bash
docker run -e HOST_IP=172.17.0.1 your-image
```

In your app, connect to `172.17.0.1` instead of `localhost`.

**2. Add host entry at runtime (Docker 20.10+, recommended)**
```bash
docker run --add-host host.docker.internal:host-gateway your-image
```

This creates a DNS entry for `host.docker.internal` pointing to the host. Now you can use `host.docker.internal` in your code without changes.

In `docker-compose.yml`:
```yaml
services:
  app:
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

**3. Use `--network host` (not recommended)**
```bash
docker run --network host your-image
```
Shares the host's network stack directly, but loses container isolation—security/port conflict risks.

---

**Which to use?**
- Use option 2 if you want code/config parity with macOS/Windows setups
- Use option 1 if you need explicit control and portability
- Avoid option 3 unless you have specific requirements

What's your container setup (standalone `docker run` or `docker-compose`)?
