# PostgreSQL deadlock detected

> ERROR: deadlock detected
> DETAIL: Process 12345 waits for ShareLock on transaction 67890; blocked by process 12346.
> Process 12346 waits for ShareLock on transaction 67891; blocked by process 12345.

## What happened

Two transactions were each waiting for the other to finish. PostgreSQL detected the circular wait after `deadlock_timeout` (default 1 second) and killed one of them to break the cycle.

## Why it happens

**Root cause: inconsistent lock ordering.** Transaction A locks row 1 then tries to lock row 2. Transaction B locks row 2 then tries to lock row 1. Neither can proceed. This typically happens when concurrent updates touch the same rows in different orders, or when an ORM issues updates in non-deterministic order. The fix is always the same: ensure all transactions acquire locks in the same order (e.g., sort by primary key). If every transaction locks row 1 before row 2, deadlocks become impossible.

## How to fix it

The fundamental fix is to always lock rows in a consistent order:

```sql
-- Instead of updating rows in arbitrary order,
-- sort by primary key so all transactions lock in the same sequence
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- For bulk operations, ORDER BY the primary key
UPDATE accounts SET status = 'active'
WHERE id IN (SELECT id FROM accounts WHERE status = 'pending' ORDER BY id FOR UPDATE);
```

For application code, add retry logic:

```python
from tenacity import retry, retry_if_exception_type
import psycopg2

@retry(retry=retry_if_exception_type(psycopg2.errors.DeadlockDetected), stop=3)
def transfer_funds(from_id, to_id, amount):
    # ensure consistent ordering
    first, second = sorted([from_id, to_id])
    # ... execute the transfer
```

## Don't do this

- Don't increase `deadlock_timeout`. That just makes the detection slower, not less frequent.
- Don't use `LOCK TABLE` on entire tables. That serializes everything and kills performance.

## Still not working?

Enable deadlock logging to understand the pattern:

```sql
-- In postgresql.conf
-- log_lock_waits = on
-- deadlock_timeout = 1s

-- Then check the logs for which queries are involved
```

Consider using `SELECT ... FOR UPDATE SKIP LOCKED` for queue-like workloads, or advisory locks for application-level coordination.
