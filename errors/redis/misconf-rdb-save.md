# Redis MISCONF: can't save RDB snapshots

> MISCONF Redis is configured to save RDB snapshots, but it's currently unable to persist to disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails.

## What happened

Redis tried to write a snapshot (RDB file) to disk and failed. Because `stop-writes-on-bgsave-error` is `yes` (the default), Redis blocks all write commands until the disk issue is resolved.

## Why it happens

The disk is full, Redis doesn't have write permissions to its data directory, or the `fork()` call failed because the system doesn't have enough memory for the copy-on-write operation. The last one is extremely common on systems without swap and with `overcommit_memory` set to 0.

## How to fix it

```bash
# Immediate fix: allow writes while you diagnose
redis-cli CONFIG SET stop-writes-on-bgsave-error no

# Check disk space
df -h /var/lib/redis/

# Check permissions
ls -la /var/lib/redis/
# Should be owned by redis:redis

# Free up disk space or fix permissions
sudo chown redis:redis /var/lib/redis/
```

**Trap: fork() doubles memory usage.** Redis uses `fork()` for background saves (BGSAVE). On Linux, `fork()` creates a copy-on-write clone of the entire Redis process. If Redis is using 8GB of RAM, the kernel needs to guarantee 8GB more is available for the child process (even though copy-on-write means it rarely uses that much). With `overcommit_memory=0` (the default), the kernel refuses the fork if it can't guarantee the memory, and the save fails. This is the most common cause of this error on machines where Redis uses more than ~50% of available RAM.

```bash
# Allow overcommit (needed for Redis fork)
echo 1 | sudo tee /proc/sys/vm/overcommit_memory

# Make it permanent
echo "vm.overcommit_memory = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Try saving again
redis-cli BGSAVE
```

## Don't do this

- Don't leave `stop-writes-on-bgsave-error no` permanently. It means Redis will silently lose data if the disk stays full and it crashes.
- Don't disable RDB entirely unless you have AOF enabled as an alternative persistence method.

## Still not working?

Check Redis logs for the exact failure:

```bash
tail -50 /var/log/redis/redis-server.log

# If it's a transparent hugepages issue
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
```

If you're running Redis in Docker, make sure the volume has enough space and the container has appropriate memory limits set.
