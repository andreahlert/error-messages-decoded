# Port already in use when starting a container

> Bind for 0.0.0.0:3000 failed: port is already allocated
> Error starting userland proxy: listen tcp4 0.0.0.0:3000: bind: address already in use

## What happened

You tried to start a container that maps to a host port something else is already using. Either another container, a local dev server, or a zombie process is sitting on that port.

## Why it happens

Docker can't bind two processes to the same host port. Something already claimed port 3000 (or whatever port you're mapping) before your container tried to start.

## How to fix it

```bash
# Find what's using the port
sudo lsof -i :3000
# or
sudo ss -tlnp | grep 3000

# If it's a container, stop it
docker stop $(docker ps -q --filter publish=3000)

# If it's a local process, kill it
kill -9 <PID>
```

Then restart your container. If you can't kill the other process, remap to a different port:

```bash
docker run -p 3001:3000 your-image
```

## Don't do this

- Don't blindly `kill -9` without checking what the PID is. You might kill something important.
- Don't change the container's internal port (the right side of `-p`). Change the host port (the left side).

## Still not working?

Check for stopped containers still holding the port allocation:

```bash
docker ps -a --filter publish=3000
docker rm <container_id>
```

On macOS, AirPlay Receiver listens on port 5000 and AirDrop uses 7000. Disable them in System Settings if they conflict.
