# React state update on unmounted component

> Warning: Can't perform a React state update on an unmounted component. This is a no-op, but it indicates a memory leak in your application. To fix, cancel all subscriptions and asynchronous tasks in a useEffect cleanup function.

## What happened

An async operation (fetch, setTimeout, subscription) completed after the component was already removed from the DOM, and it tried to call `setState` on something that no longer exists.

## Why it happens

You started an async operation in `useEffect` or an event handler, the user navigated away or the component was conditionally hidden, and the callback fired after unmount. Common with API calls, timers, and WebSocket listeners.

## How to fix it

**For fetch/async calls, use an abort controller:**

```typescript
useEffect(() => {
  const controller = new AbortController();

  fetch('/api/data', { signal: controller.signal })
    .then(res => res.json())
    .then(data => setData(data))
    .catch(err => {
      if (err.name !== 'AbortError') throw err;
    });

  return () => controller.abort();
}, []);
```

**For timers:**

```typescript
useEffect(() => {
  const timer = setTimeout(() => setVisible(true), 3000);
  return () => clearTimeout(timer);
}, []);
```

**For subscriptions:**

```typescript
useEffect(() => {
  const ws = new WebSocket(url);
  ws.onmessage = (e) => setMessages(prev => [...prev, e.data]);
  return () => ws.close();
}, [url]);
```

## Don't do this

- Don't use a `let isMounted = true` flag with `useRef`. It works but masks the real problem: you should cancel the operation, not just ignore the result.
- Don't wrap every `setState` in a try/catch. The warning isn't an error you can catch.

## Still not working?

- Note: React 18 removed this warning. If you're seeing it, you're on React 17 or below.
- If using React Query or SWR, they handle this automatically. Consider migrating your raw fetch calls.
- Check if a parent component is unmounting and remounting children unexpectedly (common with key changes).
