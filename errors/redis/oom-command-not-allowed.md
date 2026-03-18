# Redis out of memory

> OOM command not allowed when used memory > 'maxmemory'

## What happened

Redis hit its configured memory limit (`maxmemory`) and your write command was rejected because the eviction policy doesn't allow automatic key removal, or there's nothing left to evict.

## Why it happens

By default, `maxmemory-policy` is `noeviction`, which means Redis will refuse writes once it's full rather than deleting existing keys. If you're using Redis as a cache but configured it like a persistent store, you get this error instead of automatic cache cleanup.

## How to fix it

```bash
# Check current memory usage and limit
redis-cli INFO memory | grep -E "used_memory_human|maxmemory_human|maxmemory_policy"

# For cache use: set an eviction policy (no restart needed)
redis-cli CONFIG SET maxmemory-policy allkeys-lru

# Increase the memory limit if needed
redis-cli CONFIG SET maxmemory 2gb

# Make it permanent in redis.conf
# maxmemory 2gb
# maxmemory-policy allkeys-lru
```

Eviction policy cheat sheet:
- `allkeys-lru`: Evict least recently used keys. Best for general caching.
- `volatile-lru`: Only evict keys with TTL set. Good when mixing cache and persistent data.
- `noeviction`: Refuse writes when full. Use for queues where data loss is unacceptable.

## Don't do this

- Don't keep increasing `maxmemory` without understanding what's eating the memory. You might have a leak.
- Don't use `FLUSHALL` on production to "fix" it. You'll wipe all data.

## Still not working?

Find what's using all the memory:

```bash
# Sample the biggest keys
redis-cli --bigkeys

# Get a detailed memory breakdown
redis-cli MEMORY DOCTOR

# Check a specific key's memory usage
redis-cli MEMORY USAGE mykey
```

If one key is massive (a list or set with millions of members), that's your culprit. Consider using `SCAN` with `UNLINK` (async delete) instead of `DEL` for large keys to avoid blocking Redis.
