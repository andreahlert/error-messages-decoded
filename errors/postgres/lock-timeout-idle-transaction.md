# Lock timeout caused by idle transaction

> ERROR: canceling statement due to lock timeout

## What happened

Your query waited for a lock but gave up after `lock_timeout` was reached. Another session is holding a conflicting lock, and that session is sitting idle inside an open transaction, doing nothing but blocking everyone else.

## Why it happens

A transaction that ran `BEGIN` (or started implicitly through an ORM) acquired a lock, then never committed or rolled back. Common causes:

- A forgotten `psql` session with an open transaction
- An ORM or connection pool that started a transaction but the application code threw an exception before committing
- A long-running migration that holds `AccessExclusiveLock` on a table while other queries pile up waiting
- A debugging session where someone ran a query inside a transaction and walked away

The waiting queries don't fail immediately. They queue up silently until `lock_timeout` kicks in and kills them.

## How to fix it

First, find the blocking session:

```sql
-- Find idle-in-transaction sessions holding locks
SELECT
  pid,
  usename,
  state,
  query,
  state_change,
  now() - state_change AS idle_duration,
  application_name
FROM pg_stat_activity
WHERE state = 'idle in transaction'
ORDER BY state_change ASC;
```

Find exactly which lock is blocking which:

```sql
-- Show blocker -> blocked relationships
SELECT
  blocked.pid AS blocked_pid,
  blocked.query AS blocked_query,
  blocking.pid AS blocking_pid,
  blocking.query AS blocking_query,
  blocking.state AS blocking_state,
  now() - blocking.state_change AS blocking_idle_time
FROM pg_locks AS blocked_locks
JOIN pg_stat_activity AS blocked ON blocked.pid = blocked_locks.pid
JOIN pg_locks AS blocking_locks
  ON blocking_locks.locktype = blocked_locks.locktype
  AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
  AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
  AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
  AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
  AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
  AND blocking_locks.pid != blocked_locks.pid
JOIN pg_stat_activity AS blocking ON blocking.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted
  AND blocking_locks.granted;
```

Terminate the blocking session:

```sql
-- Gracefully cancel the blocking query first
SELECT pg_cancel_backend(12345);

-- If that doesn't work, terminate the connection
SELECT pg_terminate_backend(12345);
```

Prevent this from happening again:

```sql
-- Set a global idle-in-transaction timeout (PostgreSQL 9.6+)
ALTER SYSTEM SET idle_in_transaction_session_timeout = '5min';
SELECT pg_reload_conf();

-- Set lock_timeout so queries fail fast instead of hanging
ALTER SYSTEM SET lock_timeout = '10s';
SELECT pg_reload_conf();
```

## Don't do this

- Don't just increase `lock_timeout`. The real problem is the idle transaction, not the timeout value. A higher timeout means queries hang longer before failing.
- Don't kill all idle connections blindly. Some may be legitimately waiting in a connection pool. Target only `idle in transaction` sessions.
- Don't run `ALTER TABLE` or `CREATE INDEX` (without `CONCURRENTLY`) during peak hours. These acquire `AccessExclusiveLock` and become the blocker themselves.

## Still not working?

If this keeps happening, the root cause is usually application code not closing transactions properly. Check your ORM/driver settings:

```python
# SQLAlchemy: enable pool pre-ping and set timeouts
engine = create_engine(
    "postgresql://...",
    pool_pre_ping=True,
    pool_recycle=300,
    connect_args={
        "options": "-c idle_in_transaction_session_timeout=300000"
    }
)
```

```javascript
// node-postgres: set statement_timeout per connection
const pool = new Pool({
  connectionString: '...',
  statement_timeout: 30000,
  idle_in_transaction_session_timeout: 300000
});
```

For migrations that need `AccessExclusiveLock`, use a short `lock_timeout` and retry:

```sql
-- Try to acquire the lock, fail fast if blocked
SET lock_timeout = '3s';
ALTER TABLE big_table ADD COLUMN new_col text;
-- If it fails, wait and retry instead of blocking everything
```
