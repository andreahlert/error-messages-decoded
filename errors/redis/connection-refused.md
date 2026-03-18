# Redis won't accept connections

> Could not connect to Redis at 127.0.0.1:6379: Connection refused

## What happened

Your application tried to connect to Redis but nothing is listening on port 6379. Redis is either not running, crashed, or bound to a different interface.

## Why it happens

Redis isn't started, it crashed due to an out-of-memory kill (OOM killer), or it's listening on a Unix socket instead of TCP. In Docker setups, `127.0.0.1` inside a container doesn't reach the host machine's Redis.

## How to fix it

```bash
# Check if Redis is running
systemctl status redis
# or
redis-cli ping  # should return PONG

# Start it if it's not running
sudo systemctl start redis

# If it was OOM-killed, check the system logs
dmesg | grep -i "killed process"
journalctl -u redis --no-pager -n 30
```

For Docker Compose, use the service name:

```python
# Wrong (inside a container)
redis = Redis(host='127.0.0.1', port=6379)

# Right (docker-compose service name)
redis = Redis(host='redis', port=6379)
```

## Don't do this

- Don't bind Redis to `0.0.0.0` without setting a password (`requirepass`). Exposed Redis instances get compromised within minutes. Cryptominer bots scan for this constantly.
- Don't ignore OOM kills. If Redis keeps getting killed, you need to either reduce memory usage or increase the server's RAM.

## Still not working?

```bash
# Check what Redis is bound to
grep "^bind" /etc/redis/redis.conf

# Check if it's using a Unix socket instead of TCP
grep "^unixsocket" /etc/redis/redis.conf

# Connect via socket if that's what's configured
redis-cli -s /var/run/redis/redis-server.sock ping
```

If Redis crashes on startup, check for a corrupted RDB or AOF file:

```bash
redis-check-rdb /var/lib/redis/dump.rdb
redis-check-aof /var/lib/redis/appendonly.aof
```
