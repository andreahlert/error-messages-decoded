# RuntimeError: This event loop is already running

> RuntimeError: This event loop is already running

## What happened

You called `asyncio.run()` or `loop.run_until_complete()` from inside code that's already running on an asyncio event loop. asyncio doesn't allow nesting loops.

## Why it happens

In standard Python scripts, `asyncio.run()` starts a new event loop, runs your coroutine, and shuts down the loop. But in certain environments, an event loop is already running in the background:

- **Jupyter notebooks** run their own event loop for cell execution
- **IPython** uses an event loop internally
- **Web frameworks** like FastAPI, Quart, or Sanic already have a loop active when handling requests
- **Libraries** that call `asyncio.run()` internally, being called from another async context

When you call `asyncio.run()` or `loop.run_until_complete()` in these contexts, asyncio raises this error because it can't run a loop inside a loop.

## How to fix it

**In Jupyter or IPython, use `await` directly:**

```python
# Instead of asyncio.run(fetch_data()), just await it
result = await fetch_data()
```

**If you need to run async code from a sync function in Jupyter, use `nest_asyncio`:**

```bash
pip install nest_asyncio
```

```python
import nest_asyncio
nest_asyncio.apply()

# Now asyncio.run() works even inside Jupyter
import asyncio
result = asyncio.run(fetch_data())
```

**In an async web framework, use `await` instead of `asyncio.run()`:**

```python
# Bad: inside a FastAPI route
@app.get("/data")
async def get_data():
    result = asyncio.run(fetch_from_api())  # crashes
    return result

# Good: just await it
@app.get("/data")
async def get_data():
    result = await fetch_from_api()
    return result
```

**If you're writing a library that must work in both sync and async contexts:**

```python
import asyncio

def run_async(coro):
    try:
        loop = asyncio.get_running_loop()
    except RuntimeError:
        # No loop running, safe to use asyncio.run()
        return asyncio.run(coro)
    else:
        # Loop already running, need a different approach
        import concurrent.futures
        with concurrent.futures.ThreadPoolExecutor() as pool:
            return pool.submit(asyncio.run, coro).result()
```

## Don't do this

- Don't create a new event loop manually with `asyncio.new_event_loop()`. It runs on the same thread and can cause race conditions, missed callbacks, and data corruption.
- Don't wrap everything in `threading.Thread` to bypass the error. It works technically but adds unnecessary complexity and makes debugging async code much harder.
- Don't call `nest_asyncio.apply()` in production application code. It's a patch for interactive environments (Jupyter, scripts), not a solution for proper async architecture.

## Still not working?

If you're calling a sync library from inside async code, use `loop.run_in_executor()`:

```python
import asyncio

async def handler():
    loop = asyncio.get_event_loop()
    # Run blocking/sync code in a thread pool
    result = await loop.run_in_executor(None, sync_blocking_function, arg1, arg2)
    return result
```

If a third-party library calls `asyncio.run()` internally and you can't change it, run it in a separate thread:

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def call_sync_lib_that_uses_asyncio():
    loop = asyncio.get_event_loop()
    result = await loop.run_in_executor(
        ThreadPoolExecutor(1),
        problematic_library.do_stuff
    )
    return result
```

For scripts that need to work both as standalone and inside Jupyter:

```python
import asyncio

async def main():
    # your async code here
    pass

if __name__ == "__main__":
    asyncio.run(main())
# In Jupyter, just call: await main()
```
