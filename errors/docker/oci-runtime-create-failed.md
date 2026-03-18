# OCI runtime create failed

> OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "/app/start.sh": permission denied: unknown
> OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "node": executable file not found in $PATH: unknown

## What happened

The container started but the process inside it failed to launch. Either the entrypoint binary doesn't exist, isn't executable, or has the wrong format.

## Why it happens

The OCI runtime (runc) tries to exec the entrypoint/command inside the container's filesystem. If that binary is missing, has no execute permission, or has Windows-style line endings (CRLF in a shell script), the exec call fails before the container even starts.

## How to fix it

```bash
# Check what the entrypoint is
docker inspect --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}' myimage

# Test interactively by overriding the entrypoint
docker run --rm -it --entrypoint /bin/sh myimage

# Inside the container, verify the file exists and is executable
ls -la /app/start.sh
file /app/start.sh
```

If the script isn't executable, fix it in your Dockerfile:

```dockerfile
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
```

If the issue is CRLF line endings (common when building on Windows):

```bash
# Fix line endings before building
sed -i 's/\r$//' start.sh
# or add to Dockerfile
RUN sed -i 's/\r$//' /app/start.sh
```

## Don't do this

- Don't add `RUN chmod 777` on everything. Fix the specific file that needs execute permission.
- Don't switch to a different base image hoping it "just works." The problem is your file, not the base image.

## Still not working?

If the error says `executable file not found in $PATH`, the binary isn't installed:

```bash
# Make sure your multi-stage build copies the binary
COPY --from=builder /app/mybin /usr/local/bin/mybin
```

Check that your base image actually has a shell if your CMD uses shell form (`CMD node app.js` needs `/bin/sh`). Use exec form instead: `CMD ["node", "app.js"]`.
