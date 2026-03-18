# GitHub Actions fails on specific OS only

> Error: Process completed with exit code 1

## What happened
A GitHub Actions workflow step fails on one operating system (e.g., Windows) but passes on others (Linux, macOS). The error message is generic, making it hard to diagnose.

## Why it happens
OS-specific differences cause subtle failures: path separators (`/` vs `\`), case sensitivity in file names (Linux is case-sensitive, macOS/Windows are not), line endings (LF vs CRLF), different environment variable syntax (`$VAR` vs `%VAR%`), and different temp directory locations (`/tmp` vs `$RUNNER_TEMP`).

## How to fix it

Use platform-agnostic path handling:
```yaml
- name: Build
  shell: bash  # Use bash on all platforms for consistent behavior
  run: |
    # Use forward slashes even on Windows (bash handles it)
    node scripts/build.js

- name: Get temp directory
  shell: bash
  run: |
    # Use RUNNER_TEMP instead of hardcoded /tmp
    echo "TEMP_DIR=$RUNNER_TEMP" >> $GITHUB_ENV
```

Handle path separators in code:
```javascript
// Use path.join() instead of string concatenation
const path = require('path');
const filePath = path.join('src', 'components', 'App.js');
// Not: 'src/components/App.js'
```

Handle case sensitivity:
```yaml
- name: Check file exists
  shell: bash
  run: |
    # On macOS/Windows, README.md and readme.md are the same file
    # On Linux, they are different
    ls -la README.md
```

Handle environment variables consistently:
```yaml
- name: Set env var
  shell: bash
  run: |
    # Works on all platforms with bash shell
    echo "MY_VAR=value" >> $GITHUB_ENV

- name: Use env var
  shell: bash
  run: |
    echo "$MY_VAR"  # bash syntax, not %MY_VAR%
```

## Still not working?
- Always set `shell: bash` explicitly in your steps for cross-platform consistency. GitHub Actions uses PowerShell by default on Windows.
- For file operations in tests, use `os.tmpdir()` (Node) or `tempfile.gettempdir()` (Python) instead of hardcoded paths.
- If a test relies on file ordering, sort explicitly. Directory listing order varies by OS and filesystem.
- Use the `runner.os` context to conditionally run OS-specific steps: `if: runner.os == 'Windows'`.
