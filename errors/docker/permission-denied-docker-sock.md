# Permission denied on Docker daemon socket

> Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock
> dial unix /var/run/docker.sock: connect: permission denied
> permission denied while trying to connect to the Docker daemon socket

## What happened

Your user doesn't have permission to talk to the Docker daemon. The Docker socket is owned by root and the `docker` group, and your user isn't in that group.

## Why it happens

By default, the Docker socket at `/var/run/docker.sock` has `root:docker` ownership with `660` permissions. If your user isn't in the `docker` group, every `docker` command fails with permission denied. This commonly happens right after installing Docker or on a new user account.

## How to fix it

```bash
# Add your user to the docker group
sudo usermod -aG docker $USER

# Apply immediately without logging out
newgrp docker

# Verify it worked
docker ps
```

If `newgrp` doesn't work, log out and back in. On SSH, just reconnect.

## Don't do this

- Don't `sudo chmod 666 /var/run/docker.sock`. This gives every user and process on the system full Docker access, which is effectively root access. It also resets on every daemon restart, so it's not even a permanent fix.
- Don't alias `docker` to `sudo docker`. Fix the group membership.
- Don't add random service accounts to the `docker` group without understanding that docker group membership is equivalent to root access.

## Still not working?

Check the socket permissions and group:

```bash
ls -la /var/run/docker.sock
# Should show: srw-rw---- root docker

# If the docker group doesn't exist
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl restart docker
```

In CI/CD pipelines (GitHub Actions, GitLab CI), use Docker-in-Docker (`dind`) or mount the socket explicitly. The CI runner user needs to be in the docker group inside the container.

If using rootless Docker, the socket is at a different path: `$XDG_RUNTIME_DIR/docker.sock`. Set `DOCKER_HOST` accordingly.
