# Docker: no space left on device

> no space left on device
> write /var/lib/docker/tmp/...: no space left on device
> failed to register layer: Error processing tar file(exit status 1): write: no space left on device

## What happened

Docker ran out of disk space. This usually means old images, stopped containers, and unused volumes have piled up over time and filled your disk (or the Docker VM's disk on macOS/Windows).

## Why it happens

Docker never cleans up after itself by default. Every `docker build`, every pulled image, every stopped container leaves layers and data behind. On a busy dev machine, this eats gigabytes fast.

## How to fix it

```bash
# See how much Docker is using
docker system df

# Nuclear option: remove everything unused
docker system prune -a --volumes

# More targeted: just dangling images and build cache
docker image prune -a
docker builder prune
```

`docker system prune -a --volumes` removes all unused images, stopped containers, unused networks, and orphaned volumes. You'll need to re-pull images but it typically frees 10-50GB.

## Don't do this

- Don't resize your disk without pruning first. You'll just fill it up again.
- Don't delete files under `/var/lib/docker/` manually. You'll corrupt Docker's internal state.
- Don't ignore the `--volumes` flag if you have orphaned volumes. Those are often the biggest space hogs.

## Still not working?

Check if it's the host disk, not Docker:

```bash
df -h /
df -h /var/lib/docker
```

**Trap: inode exhaustion.** `df -h` can show plenty of free space, but you're out of inodes. Millions of small files (common in node_modules layers) can exhaust inodes before filling disk space:

```bash
df -i /var/lib/docker
# If IUse% is near 100%, that's your problem
# You need to prune images/containers to free inodes, not disk space
```

**Trap: Docker on a separate partition.** Many Linux setups mount `/var/lib/docker` on a small separate partition. The root filesystem shows free space, but Docker's partition is full. Always check the specific mount point Docker uses.

If `/var/lib/docker` is on a small partition, move it:

```bash
# In /etc/docker/daemon.json
{ "data-root": "/mnt/bigger-disk/docker" }
sudo systemctl restart docker
```

On Docker Desktop, increase the disk image size in Settings > Resources.
