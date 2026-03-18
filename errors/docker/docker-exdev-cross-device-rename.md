# Docker EXDEV cross-device rename error

> Error: EXDEV: cross-device link not permitted, rename '/tmp/upload-abc123' -> '/app/data/file.dat'

## What happened
An application inside a Docker container tried to rename (move) a file from one filesystem to another, which fails because `rename()` only works within the same filesystem.

## Why it happens
In Docker, `/tmp` is on the container's writable layer while `/app/data` may be on a mounted volume. Since these are different filesystems, the kernel cannot do an atomic rename across them. The `fs.rename()` / `os.rename()` syscall fails with EXDEV.

## How to fix it
```js
// Node.js - use copyFile + unlink instead of rename
const fs = require('fs');
await fs.promises.copyFile('/tmp/upload-abc123', '/app/data/file.dat');
await fs.promises.unlink('/tmp/upload-abc123');

// Or use fs-extra's move() which handles cross-device automatically
const fse = require('fs-extra');
await fse.move('/tmp/upload-abc123', '/app/data/file.dat');
```

```bash
# Or ensure tmp and destination are on the same volume
# docker-compose.yml
# volumes:
#   - app-data:/app/data
# Set your app's temp directory to the same mount:
# TMPDIR=/app/data/tmp node app.js
```

## Still not working?
If using multer or another upload library, configure its temp directory to be on the same volume as the final destination. Set the `dest` or `tmpdir` option to a path within the mounted volume rather than the system `/tmp`.
