# Redis latency spikes from swap and THP

> Redis latency spikes every few minutes, p99 from 1ms to 500ms

## What happened

Redis response times spike periodically from sub-millisecond to hundreds of milliseconds. The spikes correlate with background saves (RDB snapshots) or occur at regular intervals. Between spikes, performance is normal.

## Why it happens

Two main culprits on Linux:

**Transparent Huge Pages (THP):** When Redis forks for `bgsave` or `bgrewriteaof`, Linux uses copy-on-write for memory pages. With THP enabled, the kernel merges 4KB pages into 2MB huge pages. When Redis writes to a huge page after forking, the kernel must copy the entire 2MB page instead of just 4KB. This causes latency spikes of 100-500ms during background saves.

**Swap:** When the system runs low on memory, Linux swaps Redis pages to disk. Any Redis operation that touches a swapped page blocks for milliseconds while the page is loaded back from disk. Since Redis is single-threaded, this blocks all other operations too.

Other possible causes:

- `bgsave` fork itself on large datasets (copy page tables)
- AOF fsync policy set to `everysec` with a slow disk
- Linux overcommit settings preventing the fork

## How to fix it

**Disable Transparent Huge Pages:**

```bash
# Immediate fix (resets on reboot)
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag

# Permanent fix: create a systemd service
sudo tee /etc/systemd/system/disable-thp.service <<'EOF'
[Unit]
Description=Disable Transparent Huge Pages
Before=redis.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled && echo never > /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable disable-thp
sudo systemctl start disable-thp
```

**Eliminate swap for Redis:**

```bash
# Check if Redis is swapping
redis-cli info memory | grep -E "used_memory_human|used_memory_rss_human"
# If rss is much larger than used_memory, fragmentation is high
# If rss is much smaller than used_memory, Redis is being swapped out

# Check system swap usage
swapon --show
free -h

# Reduce swappiness (0-100, lower = less swapping)
sudo sysctl vm.swappiness=1
echo "vm.swappiness=1" | sudo tee -a /etc/sysctl.conf

# Disable swap entirely for the Redis process (Linux 3.9+)
# Run Redis with memory locking
```

**Configure Redis to lock its memory:**

```bash
# In redis.conf
# Prevents Redis memory from being swapped
# Requires the redis user to have memlock capability
```

```bash
# Set memlock for the Redis service
sudo mkdir -p /etc/systemd/system/redis.service.d
sudo tee /etc/systemd/system/redis.service.d/override.conf <<'EOF'
[Service]
LimitMEMLOCK=infinity
EOF

sudo systemctl daemon-reload
sudo systemctl restart redis
```

**Fix overcommit for bgsave fork:**

```bash
# Allow the fork even when memory appears "full"
sudo sysctl vm.overcommit_memory=1
echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
```

**Confirm the fix with Redis's built-in latency monitoring:**

```bash
# Enable latency monitoring (threshold in ms)
redis-cli config set latency-monitor-threshold 10

# Check latency history
redis-cli latency history command
redis-cli latency latest

# Watch latency in real-time
redis-cli --latency
redis-cli --latency-history
```

## Don't do this

- Don't increase `maxmemory`. The latency isn't caused by Redis running out of its own memory limit. It's caused by the OS swapping or THP behavior. More `maxmemory` might even make it worse by using more RAM.
- Don't disable persistence (`save ""`) unless you're okay losing data. Fix the root cause instead.
- Don't add more Redis replicas thinking it's a load issue. The latency spikes affect the primary, and replicas will have the same THP/swap problem.

## Still not working?

Run Redis's full latency diagnosis:

```bash
redis-cli debug sleep 0  # test baseline
redis-cli latency doctor  # AI-powered diagnosis (Redis 6.2+)
```

Check if AOF fsync is causing the spikes:

```bash
redis-cli info persistence | grep -E "aof_enabled|aof_last_bgrewrite"

# If using AOF, check your fsync policy
redis-cli config get appendfsync
# "everysec" can spike if disk is slow
# Consider switching to "no" if data loss risk is acceptable
```

Monitor the fork duration:

```bash
redis-cli info stats | grep latest_fork_usec
# Values over 100000 (100ms) indicate fork is too slow
# This happens on large datasets (>10GB) with many keys
```

For large datasets, consider using Redis 7.0+ which has improvements to fork performance, or use Redis Cluster to split data across multiple smaller instances.
