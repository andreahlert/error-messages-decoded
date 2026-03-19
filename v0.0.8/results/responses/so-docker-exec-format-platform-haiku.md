## Root Cause

Your Docker image was built for ARM64 (M1/M2 Mac architecture), but you're trying to run it on an x86_64 Linux server. The binary format doesn't match—the CPU can't execute ARM instructions.

## Fix

**Option 1: Build for the target architecture (recommended)**

When building on your Mac, explicitly specify the target platform:

```bash
docker build --platform linux/amd64 -t your-image-name .
```

This forces the build to target x86_64 Linux, even though you're building on ARM.

**Option 2: Use buildx for multi-platform images**

If you need the image to work on both platforms:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t your-image-name .
```

This creates images tagged for both architectures under the same name. When pulled, Docker automatically gets the matching architecture.

**Option 3: Rebuild on the target server**

If you have access to the x86 Linux server, just build there directly:

```bash
docker build -t your-image-name .
```

## Check Your Dockerfile

Also verify your **base image** supports the target architecture. Some minimal images (like `alpine:latest` or `python:3.x-slim`) support multiple architectures, but older or specialized images might not. Check the image's documentation if builds still fail.
