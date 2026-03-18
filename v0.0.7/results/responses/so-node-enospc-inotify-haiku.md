The root cause is **not disk space** despite the misleading error name. The problem is that **Linux has a limit on the number of inotify watches** (file change monitors) per user, and your file watcher has hit that limit.

## Check current limit:

```bash
cat /proc/sys/fs/inotify/max_user_watches
```

Typically defaults to `8192`. When exceeded, inotify returns ENOSPC.

## Fix it:

**Temporarily (current session only):**

```bash
sudo sysctl -w fs.inotify.max_user_watches=524288
```

**Permanently (survives reboot):**

Add this to `/etc/sysctl.conf`:

```bash
fs.inotify.max_user_watches=524288
```

Then reload:

```bash
sudo sysctl -p
```

The value `524288` is usually safe. If you have a massive project, you can go higher.

## Why it happens:

Grunt watch (and nodemon) use inotify to monitor files for changes. If your project has many files, dependencies, or node_modules folders, it quickly exhausts the default watch limit.

## Quick verification:

After applying the fix, restart your watcher. If it was the inotify limit, the error should disappear.
