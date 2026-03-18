# context deadline exceeded during Docker build

> failed to solve: context deadline exceeded
> error: failed to fetch remote https://...: context deadline exceeded
> dial tcp: lookup registry-1.docker.io: context deadline exceeded

## What happened

A network request timed out during your Docker build or pull. Docker gave up waiting for a response from a registry, package manager, or some external URL.

## Why it happens

Docker has internal timeouts for network operations. If your network is slow, a registry is down, a corporate proxy is blocking traffic, or DNS resolution is failing, the operation times out. This hits hardest during `docker pull`, `docker build` with `RUN apt-get install`, or pulling base images.

## How to fix it

```bash
# Test basic connectivity to Docker Hub
curl -I https://registry-1.docker.io/v2/

# Check DNS resolution
nslookup registry-1.docker.io

# Retry the build (transient network issues are common)
docker build --no-cache -t myapp .

# If behind a corporate proxy, configure Docker
# In /etc/docker/daemon.json or Docker Desktop settings:
{
  "proxies": {
    "http-proxy": "http://proxy.corp:8080",
    "https-proxy": "http://proxy.corp:8080",
    "no-proxy": "localhost,127.0.0.1"
  }
}
```

For slow package installs, increase BuildKit timeouts:

```bash
DOCKER_BUILDKIT=1 docker build --network=host -t myapp .
```

## Don't do this

- Don't keep retrying in a tight loop. If the registry is down, wait a few minutes.
- Don't disable BuildKit to "fix" this. The timeout exists in both build backends.

## Still not working?

If you're on a VPN, try disconnecting. Many VPNs break Docker's DNS resolution.

Use a Docker Hub mirror if the main registry is consistently slow:

```json
// /etc/docker/daemon.json
{ "registry-mirrors": ["https://mirror.gcr.io"] }
```

Check if Docker Hub rate limits are hitting you (100 pulls/6h for anonymous). Login with `docker login` to get 200 pulls/6h.
