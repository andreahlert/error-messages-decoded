# PostgreSQL slow query doing Seq Scan despite existing index

> Seq Scan on large_table  (cost=0.00..185432.00 rows=5000000 width=64) (actual time=0.021..4523.109 rows=5000000 loops=1)

## What happened
PostgreSQL chose a sequential scan on a large table instead of using an existing index, resulting in a very slow query.

## Why it happens
The query planner estimated that a sequential scan would be faster than an index scan. This usually happens because table statistics are outdated (the planner thinks there are fewer rows than there actually are), or the query returns a large percentage of the table where a sequential scan genuinely is faster. It can also occur when `random_page_cost` is set too high relative to your actual disk speed (e.g., when using SSDs).

## How to fix it

First, update the table statistics:
```sql
ANALYZE large_table;
```

Check what the planner thinks with EXPLAIN ANALYZE:
```sql
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM large_table WHERE status = 'active';
```

If using SSDs, lower `random_page_cost` to reflect faster random I/O:
```sql
-- Default is 4.0, set to 1.1-1.5 for SSDs
SET random_page_cost = 1.1;
-- Then re-run your query to see if the planner chooses the index
```

Make the change permanent in `postgresql.conf`:
```bash
# In postgresql.conf
random_page_cost = 1.1
seq_page_cost = 1.0
effective_cache_size = '8GB'  # set to ~75% of total RAM
```

Run a full VACUUM ANALYZE if stats are very stale:
```sql
VACUUM ANALYZE large_table;
```

## Still not working?
- Check if the index actually covers your query: `\d large_table` to see existing indexes.
- If filtering on a low-cardinality column (e.g., `status` with 3 possible values), the planner may correctly prefer a seq scan since the index would return too many rows.
- Temporarily test with `SET enable_seqscan = off;` to confirm the index works, then investigate why the planner avoids it.
- Check `pg_stats` for the column: `SELECT * FROM pg_stats WHERE tablename = 'large_table' AND attname = 'status';`
