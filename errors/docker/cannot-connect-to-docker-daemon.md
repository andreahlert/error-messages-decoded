# Cannot connect to the Docker daemon

> Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
> Got permission denied while trying to connect to the Docker daemon socket

## What happened

The Docker client can't talk to the Docker daemon. Either the daemon isn't running, or your user doesn't have permission to access the socket.

## Why it happens

The Docker CLI is just a client. It needs the `dockerd` daemon to be running and listening on `/var/run/docker.sock`. If the daemon is stopped, the socket doesn't exist, or your user isn't in the `docker` group, the connection fails.

## How to fix it

```bash
# Check if Docker is running
sudo systemctl status docker

# Start it if it's not
sudo systemctl start docker

# Enable it to start on boot
sudo systemctl enable docker
```

If Docker is running but you get permission denied:

```bash
# Add your user to the docker group
sudo usermod -aG docker $USER

# Apply the group change (or log out and back in)
newgrp docker
```

## Don't do this

- Don't run everything with `sudo` as a permanent fix. Fix the group membership instead.
- Don't `chmod 777 /var/run/docker.sock`. This gives every user on the system root-equivalent access.

## Still not working?

On Docker Desktop (macOS/Windows), open the app. The daemon only runs when the Desktop app is running.

If the socket exists but the daemon crashed:

```bash
# Check daemon logs
sudo journalctl -u docker.service --no-pager -n 50

# Force restart
sudo systemctl restart docker
```

If you're using WSL2, make sure Docker Desktop's WSL integration is enabled for your distro in Settings > Resources > WSL Integration.
