# nginx: open() "/run/nginx.pid" failed (Permission denied)

> nginx: [emerg] open() "/run/nginx.pid" failed (13: Permission denied)
> nginx: [emerg] open() "/var/run/nginx.pid" failed (13: Permission denied)

## What happened

Nginx tried to write its PID file but the current user doesn't have permission to write to `/run/` or the PID file is owned by root from a previous run.

## Why it happens

- You ran nginx without `sudo` but the PID file location requires root
- A previous `sudo nginx` created a root-owned PID file and now a different user can't overwrite it
- SELinux or AppArmor is blocking the write

## How to fix it

**Run nginx with proper permissions:**

```bash
sudo nginx
# or via systemd
sudo systemctl start nginx
```

**If a stale PID file is the problem:**

```bash
sudo rm /run/nginx.pid
sudo systemctl start nginx
```

**If you need to run nginx as non-root, change the PID location in `nginx.conf`:**

```nginx
pid /tmp/nginx.pid;
```

And also update temp paths:

```nginx
http {
    client_body_temp_path /tmp/nginx/client_body;
    proxy_temp_path /tmp/nginx/proxy;
    fastcgi_temp_path /tmp/nginx/fastcgi;
    uwsgi_temp_path /tmp/nginx/uwsgi;
    scgi_temp_path /tmp/nginx/scgi;
}
```

## Don't do this

- Don't `chmod 777 /run/`. That's a security disaster on a shared or production system.
- Don't run nginx as root in production just to fix this. Configure the PID path properly or use systemd.

## Still not working?

- Check SELinux: `sudo ausearch -m AVC -ts recent` to see if it's blocking nginx.
- Check if `/run/` is a tmpfs that gets recreated on boot. You might need a systemd-tmpfiles config to create the nginx directory on boot.
- On containers, this is often because the image expects to run as root but the pod runs as non-root. Use the unprivileged nginx image: `nginx-unprivileged`.
