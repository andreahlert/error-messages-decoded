# PostgreSQL UPDATE with ORDER BY Error

## Root Cause

PostgreSQL (like most SQL databases) **doesn't support ORDER BY in UPDATE statements** because UPDATE is semantically a set operation, not a sequential one. The standard SQL syntax for UPDATE has no ORDER BY clause.

If you're trying this:
```sql
UPDATE table_name
SET column = value
ORDER BY some_column
LIMIT 10;
```

You'll get: `ERROR: syntax error at or near "ORDER"`

## Solution: Use a CTE

The standard fix is a **Common Table Expression (CTE)** with a window function:

```sql
WITH cte AS (
  SELECT ctid, ROW_NUMBER() OVER (ORDER BY some_column) as rn
  FROM table_name
  WHERE some_condition
  LIMIT 10  -- if you only want to update some rows
)
UPDATE table_name
SET column = new_value
WHERE ctid IN (SELECT ctid FROM cte);
```

### Alternative: Subquery with ctid

If you just need ordering without row numbering:

```sql
UPDATE table_name
SET column = new_value
WHERE id IN (
  SELECT id FROM table_name
  WHERE some_condition
  ORDER BY some_column
  LIMIT 10
);
```

### For Row Lock Control

If your goal is controlling lock order (mentioned in your context), use explicit locking:

```sql
BEGIN;
SELECT id FROM table_name
WHERE some_condition
ORDER BY some_column
LIMIT 10
FOR UPDATE;

UPDATE table_name
SET column = new_value
WHERE id IN (above_ids);
COMMIT;
```

## Key Points

- **CTE approach is most reliable** for complex updates with ordering
- `ctid` (PostgreSQL's internal row ID) persists across queries in a transaction
- Always test lock contention with concurrent transactions if that's your concern
