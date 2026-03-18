# Too many open files

> bash: /dev/null: Too many open files
> accept tcp [::]:8080: accept4: too many open files
> Error: EMFILE, too many open files

## What happened

Your process hit the maximum number of file descriptors it's allowed to have open at once. On Linux, "files" includes network sockets, pipes, and actual files.

## Why it happens

Every process has a limit on how many file descriptors it can hold open (default is usually 1024). Servers handling many connections, applications with file descriptor leaks, or tools that open many files at once (like inotify watchers) hit this limit. The `ulimit` is per-process, enforced by the kernel.

## How to fix it

```bash
# Check current limits
ulimit -n        # soft limit for current shell
ulimit -Hn       # hard limit

# Increase for current session
ulimit -n 65536

# Make it permanent - add to /etc/security/limits.conf
# * soft nofile 65536
# * hard nofile 65536

# For systemd services, edit the unit file
sudo systemctl edit myservice
# Add:
# [Service]
# LimitNOFILE=65536
```

Check how many FDs your process is actually using:

```bash
# Find the PID
pgrep -f myapp

# Count open file descriptors
ls /proc/<PID>/fd | wc -l
```

## Don't do this

- Don't set `ulimit -n unlimited`. Set it to a reasonable number like 65536.
- Don't just keep increasing the limit if usage keeps growing. That's a file descriptor leak. Fix the code.
- Don't edit `/etc/security/limits.conf` without also checking that `pam_limits.so` is enabled in your PAM config.

## Still not working?

The system-wide maximum also matters:

```bash
# Check system-wide limit
cat /proc/sys/fs/file-nr
# Shows: allocated  free  max

# Increase system-wide max
sudo sysctl -w fs.file-max=2097152
# Make permanent in /etc/sysctl.conf
```

For Node.js with file watchers (webpack, nodemon), this is often an inotify limit, not a file descriptor limit:

```bash
cat /proc/sys/fs/inotify/max_user_watches
sudo sysctl -w fs.inotify.max_user_watches=524288
```
