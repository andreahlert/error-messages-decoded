The root cause is typically **using `time.sleep()` instead of `asyncio.sleep()`** in an async function, which blocks the entire event loop and defeats the purpose of async.

## The Fix

Use `asyncio.sleep()` instead:

```python
import asyncio

async def periodic_task():
    while True:
        await asyncio.sleep(5)  # Non-blocking delay
        await your_function()

# Run it
asyncio.run(periodic_task())
```

## Other Common Issues

**Issue: Not keeping the event loop alive**
```python
# WRONG: Task starts but loop exits immediately
asyncio.create_task(periodic_task())
```

**Fix: Use `asyncio.run()` or `await` the coroutine**
```python
# Correct
asyncio.run(periodic_task())

# Or if running alongside other tasks
async def main():
    task = asyncio.create_task(periodic_task())
    # Do other async work here
    await task  # Keep it alive

asyncio.run(main())
```

**For cleanup/cancellation:**
```python
async def periodic_function(interval, func):
    try:
        while True:
            await asyncio.sleep(interval)
            await func()
    except asyncio.CancelledError:
        print("Task cancelled")

# Usage
task = asyncio.create_task(periodic_function(5, my_func))
# Later: task.cancel()
```

**Key difference:**
- `time.sleep(5)` = blocks the event loop for 5 seconds (nothing else runs)
- `await asyncio.sleep(5)` = yields control, other tasks run during the 5 seconds
