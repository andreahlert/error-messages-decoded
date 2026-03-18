# PostgreSQL serialization failure on read/write dependency

> ERROR:  could not serialize access due to read/write dependencies among transactions

## What happened
A transaction using `SERIALIZABLE` isolation level was aborted because PostgreSQL detected a potential conflict that could violate serializability guarantees.

## Why it happens
The `SERIALIZABLE` isolation level guarantees that concurrent transactions produce the same result as if they were executed one at a time. When PostgreSQL detects a read/write dependency cycle between transactions, it aborts one of them to prevent an anomaly. This is more likely with high concurrency and overlapping read/write sets.

## How to fix it

Implement retry logic for serialization failures:
```python
from psycopg2 import OperationalError
import time

def execute_with_retry(func, max_retries=3):
    for attempt in range(max_retries):
        try:
            with connection:
                with connection.cursor() as cur:
                    return func(cur)
        except OperationalError as e:
            if "could not serialize" in str(e) and attempt < max_retries - 1:
                time.sleep(0.1 * (2 ** attempt))
                continue
            raise
```

If you do not need full serializability, use a lower isolation level:
```sql
SET default_transaction_isolation = 'read committed';
-- or per transaction:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

Use `REPEATABLE READ` as a middle ground:
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

## Still not working?
- Reduce the scope of your transactions: read and write fewer rows per transaction to minimize conflict windows.
- Consider using explicit locking (`SELECT FOR UPDATE`) at a lower isolation level instead of relying on serializable.
- Monitor conflict frequency with: `SELECT * FROM pg_stat_database WHERE datname = 'mydb';` and check `conflicts`.
