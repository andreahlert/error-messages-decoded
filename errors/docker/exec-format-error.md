# exec format error (ARM vs x86 mismatch)

> exec /usr/local/bin/node: exec format error
> standard_init_linux.go: exec user process caused: exec format error
> rosetta error: failed to open the extended attributes file

## What happened

You're trying to run a container built for a different CPU architecture. Typically this means running an x86/amd64 image on an ARM machine (Apple Silicon Mac) or vice versa.

## Why it happens

Container images contain compiled binaries. An image built for `linux/amd64` has x86 binaries that can't run natively on ARM64 chips (M1/M2/M3 Macs), and the reverse is also true. Docker Desktop can emulate via Rosetta/QEMU but it's slow and sometimes fails.

## How to fix it

```bash
# Check the image architecture
docker inspect --format '{{.Architecture}}' myimage

# Pull the correct platform explicitly
docker pull --platform linux/arm64 node:20-alpine
# or
docker pull --platform linux/amd64 node:20-alpine

# Build for a specific platform
docker build --platform linux/amd64 -t myapp .

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t myapp .
```

If you're on Apple Silicon and the image only exists for amd64, force emulation:

```bash
docker run --platform linux/amd64 myimage
```

**Trap: M1/M2/M3 Mac (Apple Silicon) building images for deployment.** Most CI/CD and servers run x86_64/amd64. If you build on an ARM Mac without specifying `--platform linux/amd64`, the image works locally but fails in production with this exact error. Always specify the target platform explicitly:

```bash
# Building on Apple Silicon for a typical amd64 server
docker build --platform linux/amd64 -t myapp:latest .
```

## Don't do this

- Don't ignore this and just keep restarting the container. It will never work without the right architecture.
- Don't assume `docker buildx` is set up. You may need to create a builder first: `docker buildx create --use`
- Don't assume images on Docker Hub are multi-arch. Many community images are amd64-only.

## Still not working?

If building multi-platform images, make sure your Dockerfile doesn't hardcode architecture-specific binaries:

```dockerfile
# Bad: hardcoded amd64 binary
ADD https://example.com/tool-linux-amd64 /usr/bin/tool

# Good: use TARGETARCH build arg
ARG TARGETARCH
ADD https://example.com/tool-linux-${TARGETARCH} /usr/bin/tool
```

Some base images like `alpine` have proper multi-arch support. Switch to those if your current base doesn't.
