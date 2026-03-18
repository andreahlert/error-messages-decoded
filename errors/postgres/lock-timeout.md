# PostgreSQL cancels query due to lock timeout

> ERROR: canceling statement due to lock timeout

## What happened

Your query tried to acquire a lock on a table or row but couldn't get it within the configured `lock_timeout`. Another transaction is holding the lock and hasn't committed or rolled back.

## Why it happens

A long-running transaction (maybe an `ALTER TABLE`, a slow query, or a forgotten `BEGIN` without `COMMIT` in someone's psql session) holds a lock. Your query waits, hits the timeout, and gets killed. This is extremely common during migrations that run `ALTER TABLE` on busy tables.

## How to fix it

```sql
-- Find what's blocking you
SELECT blocked_locks.pid AS blocked_pid,
       blocking_locks.pid AS blocking_pid,
       blocked_activity.query AS blocked_query,
       blocking_activity.query AS blocking_query
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.relation = blocked_locks.relation
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- Kill the blocking query if it's safe to do so
SELECT pg_terminate_backend(blocking_pid);
```

For migrations, set a short lock timeout and retry:

```sql
SET lock_timeout = '3s';
ALTER TABLE users ADD COLUMN verified boolean DEFAULT false;
```

## Don't do this

- Don't run `ALTER TABLE` on production tables during peak traffic without a plan. Use `CREATE INDEX CONCURRENTLY` for indexes and tools like `pg-osc` or `pgroll` for column changes.
- Don't disable `lock_timeout`. An infinite wait is worse than a clear error.

## Still not working?

Check for idle-in-transaction sessions that forgot to commit:

```sql
SELECT pid, state, query_start, query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
AND query_start < now() - interval '5 minutes';

-- Set an automatic timeout for idle transactions
ALTER SYSTEM SET idle_in_transaction_session_timeout = '5min';
SELECT pg_reload_conf();
```

For heavy migration operations, schedule them during low-traffic windows and use advisory locks to prevent concurrent migrations.
