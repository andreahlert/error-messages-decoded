# ENFILE file table overflow

> Error: ENFILE: file table overflow, open '/app/data/config.json'

## What happened
The operating system's global file descriptor table is full. No process on the system can open new files.

## Why it happens
The system-wide limit on open file descriptors (`fs.file-max`) has been reached. This is different from the per-process `ulimit -n` limit. It happens on servers handling many concurrent connections, or applications that open many files without closing them. Docker containers inherit the host's system limits.

## How to fix it
```bash
# Check current system-wide limit
cat /proc/sys/fs/file-max

# Check how many file descriptors are in use
cat /proc/sys/fs/file-nr

# Increase system-wide limit temporarily
sudo sysctl -w fs.file-max=500000

# Make it permanent
echo "fs.file-max = 500000" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Also increase per-process limits
ulimit -n 65536
```

## Still not working?
Check for file descriptor leaks in your application with `lsof -p <PID> | wc -l`. In Docker, set `--ulimit nofile=65536:65536` on `docker run`. For systemd services, add `LimitNOFILE=65536` to the unit file. Check if any process is holding thousands of open file handles with `ls /proc/*/fd | wc -l`.
