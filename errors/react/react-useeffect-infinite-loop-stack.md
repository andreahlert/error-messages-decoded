# React useEffect causes infinite re-render loop

> RangeError: Maximum call stack size exceeded

## What happened
A React component entered an infinite render loop because a `useEffect` hook sets state on every render, triggering another render, which triggers the effect again.

## Why it happens
When `useEffect` has no dependency array (or includes a value that changes on every render like an object/array literal), it runs after every render. If it calls a state setter, it causes a re-render, creating a circular loop that overflows the call stack.

## How to fix it
```jsx
// Add a dependency array to limit when the effect runs
useEffect(() => {
  fetchData().then(setData);
}, []); // empty array = run once on mount

// If you need dependencies, make sure they are stable references
const memoizedValue = useMemo(() => computeValue(input), [input]);
useEffect(() => {
  doSomething(memoizedValue);
}, [memoizedValue]);
```

## Still not working?
Check if any dependency in the array is an object or array created during render. Use `useMemo` or `useCallback` to stabilize references. Also check for circular state updates where setting state A triggers an effect that sets state B, which triggers an effect that sets state A.
