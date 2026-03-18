# nginx: bind() to 0.0.0.0:80 failed (Address already in use)

> nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
> nginx: [emerg] bind() to 0.0.0.0:443 failed (98: Address already in use)

## What happened

Nginx can't start because another process is already listening on port 80 (or 443). Only one process can bind to a port at a time.

## Why it happens

- Another nginx instance is already running
- Apache, Caddy, or another web server is using the port
- A previous nginx didn't shut down cleanly
- A Docker container is bound to that port on the host

## How to fix it

**Find what's using the port:**

```bash
sudo ss -tlnp | grep ':80'
# or
sudo lsof -i :80
```

**If it's another nginx instance:**

```bash
sudo nginx -s stop
# or kill it directly
sudo pkill nginx
# Then start fresh
sudo systemctl start nginx
```

**If it's Apache:**

```bash
sudo systemctl stop apache2   # Debian/Ubuntu
sudo systemctl stop httpd     # RHEL/CentOS
sudo systemctl disable apache2  # Prevent it from starting on boot
sudo systemctl start nginx
```

**If it's a Docker container:**

```bash
docker ps | grep '0.0.0.0:80'
docker stop <container_id>
```

## Don't do this

- Don't use `kill -9` on nginx unless `nginx -s stop` and `nginx -s quit` both failed. Hard kills can corrupt logs and leave socket files behind.
- Don't change your nginx port to 8080 to "work around it." Find and stop the conflicting process.

## Still not working?

- If `ss` shows nothing on port 80 but nginx still fails, a socket file might be stale. Reboot the machine or check for zombie processes with `ps aux | grep nginx`.
- On some systems, `systemd-resolved` or `rpcbind` can grab ports. Check `sudo systemctl list-units --type=socket`.
