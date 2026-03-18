# upstream timed out (110: Connection timed out)

> upstream timed out (110: Connection timed out) while reading response header from upstream
> upstream timed out (110: Connection timed out) while connecting to upstream

## What happened

Nginx forwarded a request to your backend (Node, Python, PHP-FPM, etc.) and the backend didn't respond within the timeout window. The user sees a 504 Gateway Timeout.

## Why it happens

- Your backend is overloaded or deadlocked
- A database query or external API call is taking too long
- The backend process crashed and isn't accepting connections
- The upstream address is wrong and nginx is connecting to nothing

## How to fix it

**First, check if the backend is actually running:**

```bash
# Check if the upstream is listening
ss -tlnp | grep ':3000'  # or whatever port your backend uses
curl -v http://localhost:3000/health
```

**If the backend is slow, increase timeouts:**

```nginx
location /api/ {
    proxy_pass http://backend;
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 120s;  # increase for slow endpoints
}
```

**If using FastCGI (PHP-FPM):**

```nginx
location ~ \.php$ {
    fastcgi_read_timeout 120s;
    fastcgi_pass unix:/run/php/php-fpm.sock;
    # ...
}
```

**If the upstream address is wrong:**

```nginx
# Make sure this matches where your app actually listens
upstream backend {
    server 127.0.0.1:3000;  # not 0.0.0.0:3000
}
```

## Don't do this

- Don't set timeouts to 600s or higher to "fix" the issue. You're just making users wait longer for something that's fundamentally broken. Fix the slow backend.
- Don't add more upstream servers to "balance the load" if one server is already dying. You'll just kill them all.

## Still not working?

- Check backend logs. The timeout is a symptom; the root cause is in your application.
- If using Unix sockets, check permissions: `ls -la /run/php/php-fpm.sock`.
- Monitor backend memory. An OOM-killed process won't accept connections.
- Try `curl` directly to the upstream from the nginx server to isolate the issue.

**Trap: keepalive connections under high load.** By default, nginx opens a new TCP connection to the upstream for every request and closes it after. Under high load, this creates thousands of connections in TIME_WAIT state and exhausts ephemeral ports. Enable keepalive connections to the upstream:

```nginx
upstream backend {
    server 127.0.0.1:3000;
    keepalive 32;  # pool of idle keepalive connections per worker
}

location /api/ {
    proxy_pass http://backend;
    proxy_http_version 1.1;                # required for keepalive
    proxy_set_header Connection "";         # clear the "close" default
}
```

Without `keepalive`, you'll see timeouts spike under load even though the backend itself is healthy.
