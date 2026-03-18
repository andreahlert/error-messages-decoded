# Redis WRONGTYPE key holds wrong kind of value

> WRONGTYPE Operation against a key holding the wrong kind of value

## What happened
You tried to use a command on a Redis key that holds a different data structure than what the command expects. For example, running `GET` on a key that holds a hash, or `LPUSH` on a key that holds a string.

## Why it happens
Redis keys are typed: a key can hold a string, hash, list, set, sorted set, or stream. Once a key is created with one type, you cannot use commands for a different type on it. This commonly happens when application code changes the data structure for a key but old data still exists, or when different parts of the app use the same key name for different purposes.

## How to fix it

First, check the current type of the key:
```bash
redis-cli TYPE mykey
```

If the key holds the wrong type and you need to change it, delete and recreate it:
```bash
redis-cli DEL mykey
# Now use the correct command for your intended data structure
redis-cli HSET mykey field1 value1  # for hash
# or
redis-cli SET mykey "value"          # for string
```

If different parts of your app use the same key name for different data structures, use a naming convention:
```
user:123:profile   -> hash
user:123:sessions  -> set
user:123:feed      -> list
```

## Still not working?
- If you are migrating data structures (e.g., from string to hash), update all code paths that read/write the key at the same time.
- Use `SCAN` with `TYPE` filter to find all keys of a specific type: `redis-cli --scan --pattern 'user:*' | xargs -L 1 redis-cli TYPE`
- In a multi-service environment, audit all services that access the key to ensure they agree on the data structure.
