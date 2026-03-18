# Cannot exec into distroless container

> OCI runtime exec failed: exec failed: unable to start container process: exec: 'sh': executable file not found in $PATH

## What happened
You tried to `docker exec` into a container to get a shell, but the container image has no shell binary because it's a distroless or scratch-based image.

## Why it happens
Distroless images (like `gcr.io/distroless/base`) and `FROM scratch` images contain only the application binary and its runtime dependencies. There is no shell (`sh`, `bash`), no package manager, and no standard Unix utilities. This is by design for security and minimal image size.

## How to fix it
```bash
# Use the debug variant of the distroless image (has busybox shell)
# In your Dockerfile, temporarily switch to:
# FROM gcr.io/distroless/base:debug
docker exec -it <container> /busybox/sh

# Or copy a static busybox binary into the running container
docker cp /usr/bin/busybox <container>:/busybox
docker exec -it <container> /busybox sh

# For debugging, use ephemeral containers in Kubernetes
kubectl debug -it <pod> --image=busybox --target=<container>
```

## Still not working?
Use `docker cp` to copy files out of the container for inspection instead of exec-ing in. For Kubernetes, use `kubectl debug` with a sidecar debug image. In your Dockerfile, use a multi-stage build where the final stage uses `gcr.io/distroless/base:debug` during development and the non-debug variant in production. You can also use `docker run --entrypoint` with a different image mounting the same volumes.
