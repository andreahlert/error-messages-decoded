# MySQL lock wait timeout exceeded

> ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction

## What happened
A transaction tried to acquire a lock on a row or table but another transaction held that lock for longer than `innodb_lock_wait_timeout` (default 50 seconds).

## Why it happens
Another transaction is holding a lock on the rows you need and has not committed or rolled back. This is often caused by long-running queries, uncommitted transactions from idle connections, or application code that opens a transaction and then performs slow operations (API calls, file I/O) before committing.

## How to fix it

Find the blocking transaction:
```sql
-- Check InnoDB status for lock information
SHOW ENGINE INNODB STATUS\G

-- Find blocking queries in the process list
SHOW PROCESSLIST;

-- Query the information_schema for lock details (MySQL 8.0+)
SELECT * FROM information_schema.innodb_trx ORDER BY trx_started ASC;

-- Find who is blocking whom
SELECT
  r.trx_id AS waiting_trx,
  r.trx_mysql_thread_id AS waiting_thread,
  b.trx_id AS blocking_trx,
  b.trx_mysql_thread_id AS blocking_thread,
  b.trx_query AS blocking_query
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id
JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id;
```

Kill the blocking query if needed:
```sql
KILL <blocking_thread_id>;
```

Check and adjust the timeout if appropriate:
```sql
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';
-- Default is 50 seconds. Adjust per-session if needed:
SET innodb_lock_wait_timeout = 10;
```

## Still not working?
- Check for uncommitted transactions from idle connections: `SELECT * FROM information_schema.innodb_trx WHERE trx_state = 'RUNNING' AND trx_query IS NULL;`
- Ensure your application code commits or rolls back transactions promptly. Use connection pool settings to kill idle-in-transaction connections.
- Consider breaking large UPDATE/DELETE operations into smaller batches to reduce lock duration.
