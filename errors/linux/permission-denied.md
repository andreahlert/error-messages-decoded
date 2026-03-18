# bash: permission denied

> bash: ./script.sh: Permission denied
> bash: /usr/local/bin/mytool: Permission denied

## What happened

You tried to execute a file that doesn't have the execute permission bit set, or you don't have access to it.

## Why it happens

On Linux, a file needs the execute (`x`) permission for your user to run it. Downloaded scripts, files from Windows/macOS, or files created with `echo` or `cat` don't get execute permission by default. It can also mean the file is on a filesystem mounted with `noexec`.

## How to fix it

```bash
# Check current permissions
ls -la script.sh

# Add execute permission
chmod +x script.sh

# If you don't own the file
sudo chmod +x script.sh

# Or run it through the interpreter directly
bash script.sh
python3 script.py
```

## Don't do this

- Don't `chmod 777` the file. That makes it readable, writable, and executable by every user on the system. Use `chmod +x` or `chmod 755`.
- Don't `sudo` the execution unless the script actually needs root. Fix the permission instead.

## Still not working?

Check if the filesystem is mounted with `noexec`:

```bash
mount | grep $(df --output=source script.sh | tail -1)
# Look for "noexec" in the mount options

# Remount without noexec
sudo mount -o remount,exec /tmp
```

If the file has a shebang (`#!/bin/bash`) but the error says "Permission denied" on a different path, the interpreter itself might not be accessible. Check with `which bash` and `ls -la /bin/bash`.

On SELinux systems, the file context might be wrong:

```bash
ls -laZ script.sh
restorecon -v script.sh
```
