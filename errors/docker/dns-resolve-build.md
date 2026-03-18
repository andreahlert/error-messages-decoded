# DNS resolution failure during Docker build

> Could not resolve host: registry.npmjs.org

## What happened

Docker can't resolve DNS names during the build process. Network requests to external registries (npm, PyPI, apt repositories) fail because the container's DNS configuration doesn't match the host's.

## Why it happens

Docker containers use their own DNS resolution, which defaults to Google's DNS (8.8.8.8) or the Docker daemon's configured DNS servers. This breaks when:

- Your host is on a corporate network with internal DNS that blocks or doesn't forward external queries
- A VPN rewrites DNS settings on the host but Docker's embedded DNS still uses the old servers
- Your firewall or security group blocks outbound UDP port 53 from the Docker network
- Docker's default bridge network has DNS issues while the host network works fine
- systemd-resolved on the host listens on 127.0.0.53, which is unreachable from inside the container

## How to fix it

**Quick fix: Use host networking for the build:**

```bash
docker build --network=host -t myapp .
```

This makes the build use the host's network stack directly, inheriting its DNS configuration. Works immediately but isn't available on Docker Desktop for Mac/Windows.

**Permanent fix: Configure Docker's DNS servers:**

```bash
# Edit or create /etc/docker/daemon.json
sudo tee /etc/docker/daemon.json <<'EOF'
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
EOF

# Restart Docker
sudo systemctl restart docker
```

If you're on a corporate network, use your company's DNS servers instead:

```bash
# Find your host's DNS servers
cat /etc/resolv.conf
# or
resolvectl status | grep "DNS Servers"

# Use those in daemon.json
sudo tee /etc/docker/daemon.json <<'EOF'
{
  "dns": ["10.0.0.2", "10.0.0.3"]
}
EOF

sudo systemctl restart docker
```

**For systemd-resolved (Ubuntu 18.04+):**

The host uses 127.0.0.53 as its DNS, which is unreachable from containers. Point Docker to the actual upstream DNS:

```bash
# Find the real upstream DNS server
resolvectl status | grep "DNS Servers"

# Use that IP in daemon.json
```

**Verify DNS works inside a container:**

```bash
docker run --rm alpine nslookup registry.npmjs.org
docker run --rm alpine wget -q -O /dev/null https://registry.npmjs.org
```

## Don't do this

- Don't assume it's an internet connectivity issue on the host. If `curl registry.npmjs.org` works on the host but not inside Docker, it's a Docker DNS problem.
- Don't hardcode DNS IPs in your Dockerfile (`RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf`). This breaks in environments with different DNS requirements and gets overwritten anyway.
- Don't use `--network=host` in production Dockerfiles as a permanent solution. It defeats container network isolation.

## Still not working?

If DNS resolves but connections still time out, check if your firewall blocks outbound traffic from the Docker bridge network:

```bash
# Check Docker's network ranges
docker network inspect bridge | grep -A5 "IPAM"

# Test connectivity from inside a container
docker run --rm alpine ping -c 3 8.8.8.8

# If ping works but DNS doesn't, it's a DNS-specific block (UDP 53)
docker run --rm alpine nslookup registry.npmjs.org 8.8.8.8
```

For VPN users, Docker Desktop on Mac/Windows often loses DNS when a VPN connects. Restart Docker Desktop after connecting to the VPN, or configure the VPN's DNS in Docker Desktop settings under "Docker Engine" (same JSON format as `daemon.json`).

If using Docker BuildKit, you can also set the network per-stage:

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine
RUN --network=host npm install
```
