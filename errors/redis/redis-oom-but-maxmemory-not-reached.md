# Redis OOM command not allowed when maxmemory reached

> OOM command not allowed when used memory > 'maxmemory'

## What happened
Redis rejected a write command because the used memory has exceeded the `maxmemory` limit, and the configured eviction policy either cannot free memory or is set to `noeviction`.

## Why it happens
When `maxmemory-policy` is set to `noeviction` (the default), Redis will not delete any keys when the memory limit is reached. It simply rejects all write commands. Even with an eviction policy like `volatile-lru`, if no keys have a TTL set, Redis cannot evict anything. Additionally, `used_memory_rss` (actual OS memory) can be significantly higher than `used_memory` due to memory fragmentation.

## How to fix it

Check the current memory configuration:
```bash
redis-cli INFO memory
redis-cli CONFIG GET maxmemory
redis-cli CONFIG GET maxmemory-policy
```

Set an appropriate eviction policy:
```bash
# Evict least recently used keys (good general-purpose policy)
redis-cli CONFIG SET maxmemory-policy allkeys-lru

# Only evict keys with TTL set
redis-cli CONFIG SET maxmemory-policy volatile-lru

# Make it persistent
redis-cli CONFIG REWRITE
```

Check memory fragmentation:
```bash
redis-cli INFO memory | grep -E "used_memory_rss|mem_fragmentation_ratio"
# If fragmentation ratio > 1.5, Redis is using much more OS memory than needed
```

If fragmentation is high, enable active defragmentation:
```bash
redis-cli CONFIG SET activedefrag yes
```

## Still not working?
- If using `volatile-lru` or `volatile-ttl`, check that your keys actually have TTLs: `redis-cli --scan | head -20 | xargs -L 1 redis-cli TTL`. Keys without TTL (-1) cannot be evicted by volatile policies.
- Monitor `used_memory_rss` vs `used_memory`: high RSS with normal used_memory indicates fragmentation.
- Consider using `allkeys-lru` instead of `volatile-lru` if you want Redis to be able to evict any key.
- Review large keys: `redis-cli --bigkeys` to find keys consuming the most memory.
