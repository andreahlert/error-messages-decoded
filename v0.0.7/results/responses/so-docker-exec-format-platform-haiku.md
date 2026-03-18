**Root cause:** You built the image on ARM64 (M1/M2 Mac) but are running it on amd64 (x86 Linux). The Docker image contains ARM64 binaries, which the x86 CPU cannot execute.

**Fix:** Build for the target architecture using Docker Buildx:

```bash
docker buildx build --platform linux/amd64 -t your-image:tag .
```

Or push a multi-arch image to a registry:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t your-image:tag --push .
```

Then pull from the registry on your x86 server — Docker will select the correct architecture automatically.

**Alternative (if you can't use buildx):**
Build directly on the x86 server, or use a CI/CD pipeline that builds for multiple architectures.

The `--platform` flag explicitly tells Docker which CPU architecture to target, avoiding the implicit ARM64 from your Mac build.
