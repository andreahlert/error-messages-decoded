## Root Cause

**Inconsistent lock ordering** during concurrent UPDATE queries. When transactions acquire locks on multiple rows in different orders, they create a circular wait:

- Transaction A: locks row 1 → waits for row 2
- Transaction B: locks row 2 → waits for row 1
- Deadlock

This is especially common when using ORMs that don't guarantee deterministic row processing order.

## How to Fix It

### 1. **Always lock rows in consistent order** (primary fix)

```sql
-- ❌ BAD: No guaranteed order
UPDATE accounts SET balance = balance - 100 WHERE id IN (1, 2, 3);

-- ✅ GOOD: Sort by primary key
UPDATE accounts SET balance = balance - 100 WHERE id IN (1, 2, 3) ORDER BY id;
```

### 2. **Explicit row-level locking before UPDATE** (safest approach)

```sql
BEGIN;
  -- Lock rows in order first
  SELECT * FROM accounts WHERE id IN (1, 2, 3) FOR UPDATE ORDER BY id;
  -- Now UPDATE without deadlock risk
  UPDATE accounts SET balance = balance - 100 WHERE id IN (1, 2, 3);
COMMIT;
```

### 3. **Application-level retry logic** (handles occasional cases)

```python
from tenacity import retry, retry_if_exception_type
import psycopg2

@retry(retry=retry_if_exception_type(psycopg2.errors.DeadlockDetected), stop=3)
def transfer(from_id, to_id, amount):
    # Ensure consistent ordering
    first, second = sorted([from_id, to_id])
    # ... execute transfer with first ID locked before second
```

### 4. **Check for missing indexes**

A missing index on your WHERE clause forces full table scans, increasing lock conflicts:

```sql
CREATE INDEX ON accounts(status) WHERE status = 'pending';
```

## Don't Do This

- Don't increase `deadlock_timeout`—it just detects slower, doesn't prevent
- Don't use `LOCK TABLE`—serializes everything, kills throughput

If you're still hitting deadlocks, enable logging and share your actual UPDATE queries and table schema for diagnosis.
