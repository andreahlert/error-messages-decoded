# PostgreSQL won't accept connections

> psql: error: could not connect to server: Connection refused
>     Is the server running on host "127.0.0.1" and accepting
>     TCP/IP connections on port 5432?

## What happened

Your client tried to reach PostgreSQL and nobody answered. The server isn't running, isn't listening on that port, or isn't accepting TCP connections.

## Why it happens

PostgreSQL is either stopped, crashed, listening on a Unix socket only (not TCP), or listening on a different port. After an OS update or restart, the service might not have come back up.

## How to fix it

```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql
# or
pg_isready

# If it's not running, start it
sudo systemctl start postgresql

# If it won't start, check the logs
sudo journalctl -u postgresql --no-pager -n 50
# or
tail -50 /var/log/postgresql/postgresql-*-main.log
```

If it's running but still refusing connections, check the listen config:

```bash
# Find postgresql.conf
sudo -u postgres psql -c "SHOW config_file;"

# Check listen_addresses (default is 'localhost')
grep listen_addresses /etc/postgresql/*/main/postgresql.conf

# To accept connections from other hosts:
# Change to listen_addresses = '*' and restart
sudo systemctl restart postgresql
```

## Don't do this

- Don't set `listen_addresses = '*'` on a production server without also configuring `pg_hba.conf` properly. You're opening the door to anyone who can reach the port.
- Don't kill -9 the PostgreSQL process. Use `pg_ctl stop` or `systemctl stop`. Killing it can corrupt data.

## Still not working?

```bash
# Check which port PostgreSQL is actually using
sudo -u postgres psql -c "SHOW port;"
ss -tlnp | grep postgres

# If it's on a non-standard port, connect with -p
psql -h localhost -p 5433 -U postgres

# In Docker, make sure the port is mapped
docker ps  # check the PORTS column
docker logs my-postgres-container
```

If PostgreSQL crashed and won't restart, look for a stale PID file:

```bash
# Remove stale PID file if the process is truly dead
sudo rm /var/run/postgresql/*.pid
sudo systemctl start postgresql
```
