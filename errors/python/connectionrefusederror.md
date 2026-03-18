# ConnectionRefusedError when hitting a local service

> ConnectionRefusedError: [Errno 111] Connection refused

## What happened

Your code tried to open a TCP connection to a host and port, but nothing was listening there. The operating system immediately rejected the connection.

## Why it happens

The service you're trying to reach (database, API, Redis, etc.) either isn't running, is listening on a different port, or is bound to a different network interface. In Docker setups, `localhost` inside a container is not the same `localhost` as your host machine.

## How to fix it

```bash
# Check if anything is listening on the expected port
ss -tlnp | grep 5432

# If empty, the service isn't running. Start it:
sudo systemctl start postgresql
# or
docker start my-postgres

# Check which interface it's bound to
ss -tlnp | grep 5432
# If it shows 127.0.0.1:5432, it only accepts connections from localhost
# If your code uses a different IP, that's the problem
```

For Docker Compose, use the service name as the hostname, not `localhost`:

```python
# Wrong (inside a container)
conn = psycopg2.connect(host='localhost', port=5432)

# Right (inside docker-compose network)
conn = psycopg2.connect(host='db', port=5432)
```

## Don't do this

- Don't add a retry loop with `time.sleep(1)` as a "fix." It covers up the problem and adds 30 seconds of latency on every startup.
- Don't change the firewall rules (iptables/ufw) without checking if the service is actually running first.

## Still not working?

If the service IS running and you still get refused:

```bash
# Check if a firewall is blocking it
sudo iptables -L -n | grep 5432

# Check if the service config restricts connections
# PostgreSQL: check listen_addresses in postgresql.conf
# Redis: check bind directive in redis.conf
# Both default to localhost-only for security
```

In WSL2, services on the Windows host aren't reachable via `localhost`. Use the WSL gateway IP: `ip route show | grep default | awk '{print $3}'`.
