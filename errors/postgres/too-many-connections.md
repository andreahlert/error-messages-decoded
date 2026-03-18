# PostgreSQL refuses connections: too many clients

> FATAL: too many connections for role "myapp"
> FATAL: sorry, too many clients already

## What happened

PostgreSQL has a hard limit on concurrent connections (`max_connections`, default 100). Every connection hit that limit, or a per-role connection limit was reached.

## Why it happens

Your application opens connections but doesn't close them. Each request, worker, or thread grabs a connection and holds it. With 10 Gunicorn workers, 4 threads each, you're using 40 connections from a single app. Add Celery workers, a migration runner, and monitoring, and you're over 100 fast.

## How to fix it

```bash
# Check current connections
sudo -u postgres psql -c "SELECT count(*) FROM pg_stat_activity;"

# See who's using them
sudo -u postgres psql -c "
SELECT usename, application_name, state, count(*)
FROM pg_stat_activity
GROUP BY usename, application_name, state
ORDER BY count DESC;"

# Kill idle connections hogging slots
sudo -u postgres psql -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle' AND query_start < now() - interval '10 minutes';"
```

The real fix is a connection pooler:

```bash
# Install PgBouncer
sudo apt install pgbouncer

# Configure /etc/pgbouncer/pgbouncer.ini
# [databases]
# mydb = host=127.0.0.1 dbname=mydb
# [pgbouncer]
# pool_mode = transaction
# max_client_conn = 1000
# default_pool_size = 20

sudo systemctl start pgbouncer
```

## Don't do this

- Don't just bump `max_connections` to 500. Each connection uses ~5-10MB of RAM and PostgreSQL performance degrades past ~200 connections even with enough RAM.
- Don't restart PostgreSQL to free connections. That kills all active queries.

## Still not working?

Check for per-role limits:

```sql
SELECT rolname, rolconnlimit FROM pg_roles WHERE rolconnlimit > 0;
-- -1 means unlimited. Any positive number is a hard cap.

-- Remove the per-role limit
ALTER ROLE myapp CONNECTION LIMIT -1;
```

For Django/SQLAlchemy, configure connection pooling at the application level and set `CONN_MAX_AGE` (Django) or `pool_size` (SQLAlchemy) to avoid leaking connections.
