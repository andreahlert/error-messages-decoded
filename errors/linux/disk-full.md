# No space left on device (Linux)

> write error: No space left on device
> OSError: [Errno 28] No space left on device
> cp: error writing '/path/file': No space left on device

## What happened

The filesystem is full (or out of inodes). Write operations fail because there's literally nowhere to put the data.

## Why it happens

Something filled up the disk: log files that were never rotated, a runaway process writing temp files, package manager caches, old kernel versions, or Docker images. Sometimes the disk has free space but is out of inodes (millions of tiny files).

## How to fix it

```bash
# Check disk usage
df -h

# Check inode usage (if df shows space available but writes still fail)
df -i

# Find the biggest directories
du -sh /* 2>/dev/null | sort -rh | head -10
du -sh /var/* 2>/dev/null | sort -rh | head -10

# Common quick wins
sudo journalctl --vacuum-size=100M     # trim systemd logs
sudo apt autoremove --purge            # old kernels and packages
sudo apt clean                         # package cache
docker system prune -a                 # Docker garbage
```

## Don't do this

- Don't `rm -rf /tmp/*` blindly. Running processes might have open files there.
- Don't delete files under `/var/lib/` without knowing what service owns them.
- Don't resize the partition as the first fix. Clean up first, you'll just fill the bigger disk too.

## Still not working?

If `df` shows space but you still get "No space left on device," check inodes:

```bash
df -i
# If IUse% is 100%, you have millions of tiny files somewhere
find / -xdev -type d -exec sh -c 'echo "$(find "{}" -maxdepth 1 | wc -l) {}"' \; | sort -rn | head -10
```

A deleted file still takes space if a process has it open:

```bash
# Find deleted files still held open
sudo lsof +L1

# Restart the process holding the file to free the space
sudo systemctl restart <service>
```

Set up log rotation if you haven't:

```bash
# Check logrotate config
cat /etc/logrotate.conf
ls /etc/logrotate.d/
```
