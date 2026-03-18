# Python asyncio Event loop is closed on Windows

> RuntimeError: Event loop is closed

## What happened
An asyncio program running on Windows raised a RuntimeError after the event loop was closed, typically when using `asyncio.run()` or when a `ProactorEventLoop` tries to clean up resources.

## Why it happens
On Windows, Python defaults to the `ProactorEventLoop`, which has a known issue where `__del__` methods on transport objects try to call the event loop after it has been closed, raising this error. This is especially common with `aiohttp`, `httpx`, and other libraries that use TCP connections.

## How to fix it

Set the event loop policy to use `WindowsSelectorEventLoopPolicy`:
```python
import asyncio
import sys

if sys.platform == 'win32':
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

async def main():
    # your async code here
    pass

asyncio.run(main())
```

If you need `ProactorEventLoop` features (e.g., subprocess support on Windows), suppress the error by overriding the event loop:
```python
import asyncio
import sys

if sys.platform == 'win32':
    from asyncio.proactor_events import _ProactorBasePipeTransport

    # Silence the "Event loop is closed" error on Windows
    def silence_event_loop_closed(func):
        def wrapper(self, *args, **kwargs):
            try:
                return func(self, *args, **kwargs)
            except RuntimeError as e:
                if str(e) != 'Event loop is closed':
                    raise
        return wrapper

    _ProactorBasePipeTransport.__del__ = silence_event_loop_closed(
        _ProactorBasePipeTransport.__del__
    )

asyncio.run(main())
```

## Still not working?
- If using `aiohttp`, upgrade to version 3.9+ which handles this internally.
- The `SelectorEventLoop` does not support subprocesses on Windows. If you need both, use `ProactorEventLoop` with the suppression workaround above.
- On Python 3.12+, this issue has been partially fixed in CPython. Upgrade Python if possible.
