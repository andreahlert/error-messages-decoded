# Docker container exits immediately with code 0

> Container exits immediately with status code 0

## What happened
The container starts and immediately exits with status code 0 (success), meaning the main process completed and there is nothing keeping the container alive.

## Why it happens
A container runs as long as its main process (PID 1) is running. If the CMD or ENTRYPOINT runs a background/daemon process and then exits, the container stops. Common causes: running a service with `&` (background), using a script that starts a daemon and exits, or a CMD that completes immediately (like `echo` or `ls`).

## How to fix it
```dockerfile
# Run the process in the foreground, not as a daemon
# Bad: starts in background, container exits
CMD ["nginx"]
# nginx defaults to daemon mode

# Good: run in foreground
CMD ["nginx", "-g", "daemon off;"]

# For custom scripts, exec the final command
# entrypoint.sh
#!/bin/bash
# setup steps...
exec "$@"  # replaces shell with the CMD process
```

```bash
# Keep a container running for debugging
docker run -d myimage tail -f /dev/null

# Or with stdin/tty
docker run -dit myimage
```

## Still not working?
Check `docker logs <container>` to see if the process printed an error before exiting. Verify the ENTRYPOINT/CMD is correct with `docker inspect <image> | grep -A5 Cmd`. If using an entrypoint script, make sure it ends with `exec` to replace the shell process. For Java apps, ensure the JVM is not forking to background.
