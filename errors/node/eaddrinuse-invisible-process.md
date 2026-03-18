# EADDRINUSE but no visible process on the port

> Error: listen EADDRINUSE: address already in use :::3000

## What happened
Your server cannot bind to port 3000 even though `lsof` or `netstat` shows nothing obvious listening on it.

## Why it happens
The socket may be in `TIME_WAIT` state (TCP keeps the port reserved for ~60 seconds after close). Another common cause: the server binds to `::` (IPv6 all interfaces) while you're checking `127.0.0.1` (IPv4), or vice versa. On some systems, `localhost` resolves to `::1` (IPv6) while the app binds to `0.0.0.0` (IPv4).

## How to fix it
```bash
# Check both IPv4 and IPv6
lsof -i :3000
ss -tlnp | grep 3000

# Check for TIME_WAIT sockets
ss -tan | grep 3000

# Enable SO_REUSEADDR in your server code
# Node.js example:
# server.listen(3000, '0.0.0.0', () => {});
```

```js
// Node.js - enable reuseAddr to bypass TIME_WAIT
const server = http.createServer(app);
server.listen({ port: 3000, host: '0.0.0.0', reuseAddr: true });
```

## Still not working?
On Linux, reduce TIME_WAIT duration: `echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse`. Check if Docker or WSL is mapping the port. On macOS, AirPlay receiver uses port 5000 by default. Explicitly bind to `127.0.0.1` instead of `0.0.0.0` to avoid IPv6 conflicts.
