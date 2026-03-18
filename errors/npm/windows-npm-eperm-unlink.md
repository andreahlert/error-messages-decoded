# npm EPERM unlink error on Windows

> Error: EPERM: operation not permitted, unlink 'C:\Users\dev\project\node_modules\.package-lock.json'

## What happened
npm failed to delete or modify a file in `node_modules` because another process has it locked on Windows.

## Why it happens
Windows locks files that are in use by any process. Common culprits: an IDE (VS Code, WebStorm) indexing `node_modules`, Windows Defender scanning files, or a running Node.js process holding handles on files in the directory.

## How to fix it
```bash
# Close your editor and any running dev servers, then retry
# Delete node_modules with npx rimraf (handles Windows locks better)
npx rimraf node_modules
npm install

# Or run your terminal as Administrator
# Right-click terminal -> Run as administrator
npm install
```

## Still not working?
Add `node_modules` to your antivirus (Windows Defender) exclusion list. In Windows Defender: Settings > Virus & threat protection > Exclusions > Add your project's `node_modules` folder. If the problem persists, use `handle.exe` from Sysinternals to find which process is locking the file.
