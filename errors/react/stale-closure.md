# React stale closure in setInterval/setTimeout

> State variable is always the initial value inside setInterval callback

## What happened

You used `setInterval` or `setTimeout` inside a `useEffect`, and the callback always sees the initial state value, never the updated one. Your counter stays at 1 forever, or your data is always the first fetch result.

## Why it happens

When `useEffect` runs, the callback you pass to `setInterval` captures (closes over) the state variable's value at that moment. JavaScript closures freeze the variable reference. If the effect only runs once (with `[]` deps), the interval callback permanently sees the initial state. This is the "stale closure" bug.

```jsx
// Bug: count is always 0 inside the interval
useEffect(() => {
  const id = setInterval(() => {
    setCount(count + 1); // count is always 0 here
  }, 1000);
  return () => clearInterval(id);
}, []); // empty deps = closure captures initial count
```

## How to fix it

**Option 1: Use the functional updater form (best for simple cases)**

```jsx
useEffect(() => {
  const id = setInterval(() => {
    setCount(prev => prev + 1); // always uses latest value
  }, 1000);
  return () => clearInterval(id);
}, []);
```

**Option 2: Use a ref to hold the latest value (for complex cases)**

```jsx
const countRef = useRef(count);
countRef.current = count; // always up to date

useEffect(() => {
  const id = setInterval(() => {
    console.log(countRef.current); // reads latest value
    setCount(countRef.current + 1);
  }, 1000);
  return () => clearInterval(id);
}, []);
```

**Option 3: Add the dependency and let the effect re-run (careful with this)**

```jsx
useEffect(() => {
  const id = setInterval(() => {
    setCount(count + 1);
  }, 1000);
  return () => clearInterval(id);
}, [count]); // re-creates interval every time count changes
```

This works but creates/destroys the interval on every state change, which can cause timing drift.

## Don't do this

- Don't add the state variable to the dependency array of `useEffect` when using `setInterval`. You'll create and destroy the interval on every tick, causing timer drift and potential performance issues.
- Don't reach for `useRef` for everything. The functional updater (`prev => prev + 1`) is cleaner when the new state depends only on the previous state.
- Don't disable the `react-hooks/exhaustive-deps` lint rule to hide this. The lint rule is correctly warning you about the stale closure.

## Still not working?

If you need to read multiple state values inside the interval, the ref pattern is your best option. For complex interval logic, consider extracting a custom `useInterval` hook:

```jsx
function useInterval(callback, delay) {
  const savedCallback = useRef(callback);
  savedCallback.current = callback; // update ref on every render

  useEffect(() => {
    const id = setInterval(() => savedCallback.current(), delay);
    return () => clearInterval(id);
  }, [delay]);
}

// Usage: callback always has fresh state
useInterval(() => {
  setCount(count + 1); // count is always current
}, 1000);
```

This pattern (from Dan Abramov's blog) separates the interval scheduling from the callback, so the callback always sees the latest state without restarting the interval.
