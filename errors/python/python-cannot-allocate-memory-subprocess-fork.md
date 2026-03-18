# Python OSError Cannot allocate memory on subprocess fork

> OSError: [Errno 12] Cannot allocate memory

## What happened
Python failed to create a subprocess because the OS could not allocate enough memory for the fork operation.

## Why it happens
On Linux, `fork()` theoretically requires enough virtual memory to duplicate the parent process's address space. If the parent process uses 8GB of RAM, the OS needs to reserve another 8GB of virtual memory for the child (even though copy-on-write means it will not actually use that much physical memory). When `overcommit_memory` is set to 2 (strict), the kernel refuses if there is not enough swap + RAM to back the reservation. This commonly hits Python processes that load large datasets and then try to spawn subprocesses.

## How to fix it

Use `posix_spawn` instead of `fork` by passing `close_fds=True` (default in Python 3.2+) and avoiding `preexec_fn`:
```python
import subprocess

# This uses posix_spawn when possible (avoids fork memory doubling)
result = subprocess.run(['ls', '-la'], capture_output=True, text=True)
# Do NOT use preexec_fn as it forces fork instead of posix_spawn
```

Check and adjust the overcommit settings:
```bash
# Check current setting
cat /proc/sys/vm/overcommit_memory

# Set to heuristic mode (default, allows reasonable overcommit)
sudo sysctl vm.overcommit_memory=0

# Or allow full overcommit (less safe but avoids the error)
sudo sysctl vm.overcommit_memory=1
```

Use `vfork` by avoiding `preexec_fn` in subprocess calls:
```python
# Bad - forces fork (doubles memory)
subprocess.Popen(['cmd'], preexec_fn=os.setsid)

# Good - allows vfork/posix_spawn
subprocess.Popen(['cmd'], start_new_session=True)
```

## Still not working?
- If you need to run subprocesses from a large parent process, consider spawning a small helper process first that in turn spawns the actual command.
- Check available memory: `free -h` and ensure swap is enabled.
- For Python multiprocessing, use `multiprocessing.set_start_method('spawn')` instead of `'fork'` to avoid the fork memory doubling issue.
- Monitor actual memory usage: `cat /proc/<pid>/status | grep VmSize` to see virtual memory before fork.
