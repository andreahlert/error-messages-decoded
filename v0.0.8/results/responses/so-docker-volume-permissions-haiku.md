This is a classic Docker volume permission issue. Here's the root cause and fixes:

## Root Cause

When you mount a volume (`-v /host/path:/container/path`), Docker preserves the **host file ownership and permissions**. If:
- The host path is owned by user `1000:1000`
- But the container process runs as user `root` (UID 0) or a different UID
- Permission denied occurs when the container user can't read/write those files

## Specific Fixes

**Option 1: Run container as the host user (Best for development)**
```bash
docker run -u $(id -u):$(id -g) -v /host/path:/container/path image
```
This makes the container process run with the same UID/GID as your host user, matching file ownership.

**Option 2: Fix host directory permissions**
```bash
chmod 777 /host/path  # or more restrictive: 755 or 775
```
Make the directory world-readable, or give your user group write access.

**Option 3: Use bind mount with `chown` in entrypoint (for production)**
In your Dockerfile:
```dockerfile
RUN chown -R appuser:appgroup /container/path
```
Then run as that user: `USER appuser`

**Option 4: SELinux/AppArmor (Linux)**
If you see permission denied even with 777:
```bash
docker run --security-opt label=disable -v /host/path:/container/path image
```
Or on the host: `chcon -R -t svirt_sandbox_file_t /host/path`

## What to check first
1. `ls -la /host/path` - See actual ownership
2. `id` in the container - See which user the process runs as
3. Match them or use Option 1

**Option 1 is usually best for local development.** For production containers, explicit `USER` directives + fixing ownership at build time is cleaner.
