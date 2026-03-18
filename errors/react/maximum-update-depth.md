# Maximum update depth exceeded

> Error: Maximum update depth exceeded. This can happen when a component calls setState inside useEffect, but useEffect either doesn't have a dependency array, or one of the dependencies changes on every render.

## What happened

A `useEffect` is firing on every render, calling `setState`, which triggers another render, which fires `useEffect` again. It's an infinite loop caught by React's safety limit.

## Why it happens

Your `useEffect` dependency array includes a value that changes on every render. Usually an object, array, or function created inline.

## How to fix it

**Object/array dependency that's recreated every render:**

```jsx
// WRONG: new object reference every render
useEffect(() => {
  fetchData(options);
}, [{ page: 1, limit: 10 }]); // infinite loop

// RIGHT: memoize or use primitives
const options = useMemo(() => ({ page: 1, limit: 10 }), []);
useEffect(() => {
  fetchData(options);
}, [options]);

// BETTER: use primitive dependencies
useEffect(() => {
  fetchData({ page, limit });
}, [page, limit]);
```

**Function dependency:**

```jsx
// WRONG: new function every render
const getData = () => fetch(`/api/${id}`);
useEffect(() => {
  getData().then(setData);
}, [getData]); // infinite loop

// RIGHT: wrap in useCallback
const getData = useCallback(() => fetch(`/api/${id}`), [id]);
useEffect(() => {
  getData().then(setData);
}, [getData]);

// SIMPLER: just move the function inside useEffect
useEffect(() => {
  fetch(`/api/${id}`).then(r => r.json()).then(setData);
}, [id]);
```

**setState in useEffect without proper guards:**

```jsx
// WRONG: updates state on every render
useEffect(() => {
  setProcessed(items.map(transform));
}); // missing dependency array!

// RIGHT: add the dependency array
useEffect(() => {
  setProcessed(items.map(transform));
}, [items]);
```

## Don't do this

- Don't remove the dependency array entirely. That's what's causing the loop.
- Don't add `// eslint-disable-next-line react-hooks/exhaustive-deps` without understanding why the lint rule flagged it.

## Still not working?

- If a parent component is passing new object/function props on every render, the fix needs to happen in the parent.
- Use React DevTools "highlight updates" to see which components are re-rendering in a loop.
- Sometimes the loop is two components ping-ponging state updates to each other via context or props.
