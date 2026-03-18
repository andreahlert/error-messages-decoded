# Python WinError 32 file in use by another process

> PermissionError: [WinError 32] The process cannot access the file because it is being used by another process

## What happened
Your Python code tried to access, delete, or move a file that is still open by another handle in the same or another process.

## Why it happens
On Windows, files cannot be deleted or renamed while any process holds an open handle. This commonly happens with `tempfile.NamedTemporaryFile` (which keeps the file open by default), or when you forget to close a file before trying to operate on it. Unlike Unix, Windows enforces mandatory file locking.

## How to fix it

Use `NamedTemporaryFile` with `delete=False` and manage cleanup yourself:
```python
import tempfile
import os

with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
    f.write('data')
    temp_path = f.name

# File is now closed, safe to read/move/delete
with open(temp_path, 'r') as f:
    data = f.read()

os.unlink(temp_path)  # clean up manually
```

Always use context managers to ensure files are closed:
```python
# This ensures the file is closed before you try to do anything else with it
with open('output.txt', 'w') as f:
    f.write('data')

# Now safe to rename, move, or delete
os.rename('output.txt', 'final.txt')
```

If working with file objects, explicitly close before operating:
```python
f = open('data.txt', 'w')
f.write('data')
f.close()  # must close before rename/delete on Windows
os.remove('data.txt')
```

## Still not working?
- Check if an antivirus program is scanning the file. AV software temporarily locks files, causing intermittent WinError 32.
- Use `handle.exe` from Sysinternals to find which process holds the file: `handle.exe filename.txt`.
- If the file is opened by a subprocess, wait for the subprocess to finish before accessing it.
- Add a small retry loop for cases where the file is briefly locked by another process.
