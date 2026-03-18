# Process killed by signal 9 (OOM Killer)

> Killed
> Out of memory: Killed process 12345 (java) total-vm:4048060kB
> bash: line 1: 12345 Killed  ./myapp
> dmesg: oom-kill:constraint=CONSTRAINT_NONE

## What happened

The Linux OOM (Out of Memory) killer terminated your process because the system ran out of available memory. Signal 9 (SIGKILL) can't be caught or handled, so the process dies immediately.

## Why it happens

When physical memory and swap are exhausted, the kernel picks a process to kill to free memory and keep the system alive. It scores processes by memory usage, and the biggest consumer usually gets killed. This is different from application-level out-of-memory errors: this is the kernel stepping in as a last resort.

## How to fix it

**First, confirm it was actually the OOM killer using `dmesg`:**

```bash
# This is the definitive check - dmesg shows kernel-level kill decisions
dmesg | grep -i "oom\|killed process"
journalctl -k | grep -i oom

# Check current memory state
free -h
cat /proc/meminfo | head -5

# Find memory-hungry processes
ps aux --sort=-%mem | head -10
```

**Trap: check cgroup limits, not just system memory.** In containers (Docker, Kubernetes) or systemd services with `MemoryMax`, the kill happens at the cgroup level. System-wide `free -h` may show plenty of memory, but the process hit its cgroup limit:

```bash
# Check if the process was in a cgroup with memory limits
cat /sys/fs/cgroup/memory/docker/<container-id>/memory.limit_in_bytes
# Or for cgroup v2
cat /sys/fs/cgroup/<slice>/memory.max

# In Docker
docker stats --no-stream

# In Kubernetes
kubectl describe pod <pod> | grep -A5 "Limits"
```

Fixes depending on cause:

```bash
# If the app genuinely needs more memory, add swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# If the app has a memory limit setting
java -Xmx2g -jar myapp.jar
node --max-old-space-size=2048 app.js
```

## Don't do this

- Don't disable the OOM killer (`echo -17 > /proc/PID/oom_adj`). If nothing gets killed, the whole system freezes.
- Don't add swap to an SSD without understanding the write amplification tradeoff.
- Don't just buy more RAM without profiling where memory is going. Leaks will eat any amount of RAM.

## Still not working?

Protect critical processes from the OOM killer:

```bash
# Lower OOM score (less likely to be killed, -1000 to 1000)
echo -500 > /proc/<PID>/oom_score_adj
```

Profile memory usage to find the leak:

```bash
# Track memory over time
while true; do ps -p <PID> -o rss= >> mem.log; sleep 60; done

# Use valgrind for C/C++
valgrind --leak-check=full ./myapp
```

In containers, the OOM kill happens at the cgroup level, not system level. Check container memory limits with `docker stats` or `kubectl top pods`.
