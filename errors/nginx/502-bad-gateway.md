# 502 Bad Gateway

> 502 Bad Gateway
> nginx/1.x.x

## What happened

Nginx received an invalid or no response from the upstream server (your backend app). It's not an nginx problem; nginx is working fine. Your backend is the issue.

## Why it happens

- The backend process crashed or isn't running
- The backend is listening on a different port/socket than nginx expects
- PHP-FPM, Gunicorn, Node, or whatever runs your app died
- The backend returned a malformed HTTP response

## How to fix it

**Check if the backend is running:**

```bash
# For Node
ps aux | grep node
systemctl status your-app

# For PHP-FPM
systemctl status php-fpm
# or
systemctl status php8.2-fpm

# For Python/Gunicorn
ps aux | grep gunicorn
```

**If the backend is down, start it:**

```bash
sudo systemctl start your-app
# Check logs to see why it died
journalctl -u your-app --since "5 minutes ago"
```

**Verify nginx is pointing to the right upstream:**

```bash
# Check what port/socket nginx expects
grep -r proxy_pass /etc/nginx/
grep -r fastcgi_pass /etc/nginx/

# Check what port the backend is actually on
ss -tlnp | grep -E '(node|python|php|java)'
```

**If using PHP-FPM via socket:**

```bash
# Verify the socket exists
ls -la /run/php/php-fpm.sock

# If missing, restart PHP-FPM
sudo systemctl restart php8.2-fpm
```

## Don't do this

- Don't restart nginx. The problem isn't nginx. Restarting it changes nothing.
- Don't increase proxy timeouts for a 502. That's for 504 (timeout). A 502 means the backend is unreachable or responded with garbage.

## Still not working?

- Check backend logs. The answer is always in the backend logs.
- If using Unix sockets, check that nginx user has permission to access the socket.
- Try `curl http://127.0.0.1:YOUR_PORT` from the server to test the backend directly.
- Check if the server ran out of memory. `dmesg | grep -i oom` will show OOM kills.
