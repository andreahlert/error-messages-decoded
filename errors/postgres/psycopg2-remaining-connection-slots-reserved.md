# PostgreSQL connection slots reserved for superuser

> psycopg2.OperationalError: FATAL:  remaining connection slots are reserved for non-replication superuser connections

## What happened
Your application tried to open a new connection to PostgreSQL but all available connection slots are in use. The remaining slots are reserved for superuser access only.

## Why it happens
PostgreSQL reserves `superuser_reserved_connections` (default 3) slots for superusers. Your application has exhausted all non-reserved connections, meaning `max_connections - superuser_reserved_connections` are all taken. This typically happens when your app opens connections without closing them, or you have no connection pooling and many concurrent requests.

## How to fix it

First, check what is using all the connections:
```sql
SELECT count(*), state, usename FROM pg_stat_activity GROUP BY state, usename ORDER BY count DESC;
```

Kill idle connections that have been open too long:
```sql
SELECT pg_terminate_backend(pid) FROM pg_stat_activity
WHERE state = 'idle' AND state_change < now() - interval '5 minutes';
```

The real fix is to use a connection pooler like PgBouncer:
```bash
# Install pgbouncer
apt-get install pgbouncer

# Configure /etc/pgbouncer/pgbouncer.ini
# [databases]
# mydb = host=127.0.0.1 port=5432 dbname=mydb
# [pgbouncer]
# pool_mode = transaction
# max_client_conn = 200
# default_pool_size = 20
```

Or configure your application's connection pool properly (e.g., SQLAlchemy):
```python
engine = create_engine(
    "postgresql://user:pass@host/db",
    pool_size=10,
    max_overflow=5,
    pool_pre_ping=True,
    pool_recycle=300,
)
```

## Still not working?
- Check for connection leaks: every `connect()` must have a matching `close()` or use a context manager.
- If using Django, set `CONN_MAX_AGE` to a reasonable value (not `None` which keeps connections open forever).
- Monitor idle connections with: `SELECT * FROM pg_stat_activity WHERE state = 'idle';`
