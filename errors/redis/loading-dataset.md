# Redis is loading and rejecting commands

> LOADING Redis is loading the dataset in memory

## What happened

Redis is starting up and loading data from the RDB dump or AOF file. Until loading completes, it rejects all commands except `INFO` and `SUBSCRIBE`.

## Why it happens

Redis loads the entire dataset into memory before accepting connections. If your RDB file or AOF log is large (several GB), this can take minutes. This typically hits you after a Redis restart, server reboot, or failover to a replica that needs to sync.

## How to fix it

```bash
# Check loading progress
redis-cli INFO persistence
# Look for: loading_eta_seconds, loading_loaded_perc

# Wait for it to finish (there's no way to skip it)
watch -n 1 'redis-cli INFO persistence 2>/dev/null | grep loading'
```

Your application should handle this gracefully with retries:

```python
import redis
from tenacity import retry, wait_exponential, stop_after_delay

@retry(wait=wait_exponential(min=1, max=10), stop=stop_after_delay(120))
def get_redis_connection():
    r = redis.Redis(host='localhost', port=6379)
    r.ping()
    return r
```

## Don't do this

- Don't kill Redis because it's "hanging." It's loading your data. Killing it means it starts over from scratch.
- Don't set `maxmemory` lower than your dataset during a restart thinking it'll load faster. It'll just fail to load entirely.

## Still not working?

If loading takes too long every restart:

```bash
# Check how big your dataset is
ls -lh /var/lib/redis/dump.rdb

# Consider switching from RDB to AOF with rewrite
# AOF rewrites are incremental and can be faster

# Or reduce dataset size by setting TTLs on keys
redis-cli INFO keyspace
```

For production systems, avoid the loading problem entirely by using Redis Sentinel or Redis Cluster with replicas. Failover to a replica is instant because it already has the data in memory.

If loading always fails partway through, the dump file might be corrupted:

```bash
redis-check-rdb /var/lib/redis/dump.rdb
```
