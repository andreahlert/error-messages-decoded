# Random AbortError in fetch requests

> AbortError: The operation was aborted

## What happened
Fetch requests are randomly aborted, often in React components that unmount before the request completes, or when using `AbortController` with race conditions.

## Why it happens
When a React component unmounts (e.g., user navigates away), a cleanup function in `useEffect` may abort in-flight requests via `AbortController.abort()`. If the component re-mounts quickly (React Strict Mode double-mounts in development), the signal from the first mount aborts the second mount's request. Timeouts on `AbortController` can also trigger unexpectedly.

## How to fix it
```jsx
useEffect(() => {
  const controller = new AbortController();

  async function fetchData() {
    try {
      const res = await fetch('/api/data', { signal: controller.signal });
      const data = await res.json();
      setData(data);
    } catch (err) {
      // Ignore abort errors - they're expected on cleanup
      if (err.name !== 'AbortError') {
        setError(err);
      }
    }
  }

  fetchData();

  // Cleanup: abort on unmount
  return () => controller.abort();
}, []);
```

## Still not working?
If using React 18 Strict Mode, the double-mount in development is intentional. Make sure each effect creates its own `AbortController`. Check for shared `AbortController` instances being reused across components. If the abort happens in production, check for timeout values on the signal that are too short.
