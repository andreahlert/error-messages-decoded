# System limit for number of file watchers reached

> Error: ENOSPC: System limit for number of file watchers reached, watch '/home/user/project/src'
>     at FSWatcher.<computed> (node:internal/fs/watchers:244:19)
>     at Object.watch (node:fs:2358:34)

## What happened

You started a dev server (webpack-dev-server, vite, next dev, nodemon, jest --watch) and the OS ran out of inotify watchers. Your project has more files than Linux allows you to watch.

**Trap: This is NOT a disk space error.** Despite the name `ENOSPC` ("no space"), this has nothing to do with disk space. It's about inotify file watcher limits. Running `df -h` will show plenty of free disk. The "space" that's exhausted is the kernel's pool of inotify watchers, not filesystem blocks.

## Why it happens

Linux uses `inotify` to watch files for changes. The default limit is 8,192 watchers. A single `node_modules` folder can have 50,000+ files. When your dev tool tries to watch them all, the kernel says no. This is a Linux-only problem. macOS uses a different mechanism (FSEvents) with no practical limit.

## How to fix it

```bash
# Check current limit
cat /proc/sys/fs/inotify/max_user_watches

# Increase temporarily (resets on reboot)
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl -p

# Increase permanently
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

524288 is the value recommended by most tools (VS Code, React docs, etc.).

## Don't do this

**Don't set it to some astronomical number like 99999999.** Each watcher consumes ~1KB of kernel memory. 524288 uses about 500MB. Going higher wastes RAM for no benefit.

**Don't ignore it and restart the dev server repeatedly.** The limit won't change. You'll just get the error faster each time as other watchers accumulate.

## Still not working?

If you can't change system settings (shared server, restricted container), tell your tool to watch fewer files:

```javascript
// webpack.config.js - ignore node_modules
watchOptions: {
  ignored: /node_modules/,
}

// nodemon.json
{
  "ignore": ["node_modules", ".git", "dist"]
}
```

```bash
# For jest, use --watchAll=false in CI, --watch only watches changed files
jest --watch   # only watches files changed since last commit
```

On WSL2, this limit is separate from the Windows host. Apply the sysctl fix inside WSL:

```bash
# Inside WSL
sudo sysctl fs.inotify.max_user_watches=524288
```

If the issue is in a Docker container, set it on the host, not inside the container. Containers share the host kernel's inotify limits.
