# PostgreSQL out of shared memory during CREATE INDEX CONCURRENTLY

> ERROR:  out of shared memory
> HINT:  You might need to increase max_locks_per_transaction.

## What happened
PostgreSQL ran out of shared memory for tracking locks, typically during a `CREATE INDEX CONCURRENTLY` operation on a partitioned table or when many objects are locked in a single transaction.

## Why it happens
`CREATE INDEX CONCURRENTLY` on a partitioned table acquires a lock on each partition. PostgreSQL pre-allocates a lock table based on `max_locks_per_transaction * max_connections`. With many partitions (hundreds or thousands), the default `max_locks_per_transaction` (64) is not enough, and the shared lock table fills up.

## How to fix it

Increase `max_locks_per_transaction` in `postgresql.conf`:
```bash
# postgresql.conf
max_locks_per_transaction = 256  # default is 64, increase for partitioned tables
```

Then restart PostgreSQL:
```bash
sudo systemctl restart postgresql
```

If you have many partitions, index them individually instead of all at once:
```sql
-- Index each partition separately instead of the parent table
CREATE INDEX CONCURRENTLY idx_part1_col ON partitioned_table_part1 (column_name);
CREATE INDEX CONCURRENTLY idx_part2_col ON partitioned_table_part2 (column_name);
```

Check how many partitions you have:
```sql
SELECT count(*) FROM pg_inherits WHERE inhparent = 'partitioned_table'::regclass;
```

## Still not working?
- For very large partition counts, also increase `max_pred_locks_per_transaction` if you use serializable isolation.
- Monitor lock usage: `SELECT count(*) FROM pg_locks;` during the operation.
- If the table has thousands of partitions, consider batching index creation across subsets and running them in separate transactions.
