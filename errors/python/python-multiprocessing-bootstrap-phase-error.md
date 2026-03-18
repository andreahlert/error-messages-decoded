# Python multiprocessing bootstrap phase RuntimeError

> RuntimeError: An attempt has been made to start a new process before the current process has finished its bootstrapping phase

## What happened
A child process tried to spawn another process before the main module finished loading. This crashes with a RuntimeError during the bootstrap phase.

## Why it happens
On Windows and macOS (which use the `spawn` start method by default), new processes re-import the main module. If your process-spawning code runs at module level (outside of `if __name__ == '__main__'`), the child process will try to spawn yet another process during import, causing infinite recursion.

## How to fix it

Wrap all multiprocessing code inside `if __name__ == '__main__':`:
```python
from multiprocessing import Pool

def worker(x):
    return x * x

if __name__ == '__main__':
    with Pool(4) as pool:
        results = pool.map(worker, range(10))
        print(results)
```

If using `freeze_support` (for PyInstaller or cx_Freeze):
```python
from multiprocessing import freeze_support, Pool

def worker(x):
    return x * x

if __name__ == '__main__':
    freeze_support()
    with Pool(4) as pool:
        results = pool.map(worker, range(10))
```

If you need to use `fork` instead of `spawn` (Linux only):
```python
import multiprocessing
multiprocessing.set_start_method('fork')
```

## Still not working?
- If this happens in a Jupyter notebook, use `multiprocessing.set_start_method('fork')` or use the `concurrent.futures.ProcessPoolExecutor` instead.
- Make sure worker functions are defined at the top level of a module (not inside another function or class), as they must be picklable.
- If using PyTorch DataLoader with `num_workers > 0`, the same `if __name__ == '__main__'` guard is required.
