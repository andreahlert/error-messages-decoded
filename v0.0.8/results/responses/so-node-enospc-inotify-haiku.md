## Root Cause

**ENOSPC is misleading** — it's not about disk space. On Linux, file watchers (Grunt, nodemon, etc.) use `inotify` to monitor file changes. Each watched file needs an inotify descriptor. The system has a hard limit (`fs.inotify.max_user_watches`), and with node_modules and large projects, you hit it.

Default limit is usually **8192 watches** — easily exceeded with large projects.

## Fix

Increase the inotify limit:

```bash
cat /proc/sys/fs/inotify/max_user_watches
```

If it's 8192 (or low), increase it:

```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Verify:
```bash
cat /proc/sys/fs/inotify/max_user_watches
```

Should show `524288` now.

## Why This Works

- **524288** is high enough for most projects (including large node_modules)
- The change persists across reboots
- No restart needed — applies immediately

If you still hit it with an enormous project, increase further, but 524288 is typically the sweet spot.
