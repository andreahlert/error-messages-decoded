# useEffect infinite loop (Maximum update depth exceeded)

> Maximum update depth exceeded. This can happen when a component repeatedly calls setState inside componentDidUpdate or useEffect without a dependency array.

## What happened

Your component is stuck in an infinite render loop. A `useEffect` calls `setState`, which triggers a re-render, which runs the `useEffect` again, which calls `setState` again, forever.

## Why it happens

There are three common patterns that cause this:

**1. Missing dependency array:**

```jsx
// Runs after EVERY render, sets state, triggers another render
useEffect(() => {
  setCount(count + 1);
});  // no dependency array = runs every render
```

**2. Object or array in dependency array:**

```jsx
// New object reference every render, so useEffect thinks it changed
useEffect(() => {
  fetchData(filters);
}, [filters]);  // if filters = { status: 'active' } is created during render

// Same with arrays
useEffect(() => {
  setItems(data.map(transform));
}, [data.map(transform)]);  // new array every render
```

**3. Function in dependency array:**

```jsx
useEffect(() => {
  loadData();
}, [loadData]);  // if loadData is redefined every render
```

Every render creates a new reference for objects, arrays, and functions. `useEffect` compares dependencies by reference (`===`), sees a "new" value, and runs again.

## How to fix it

**Add the correct dependency array:**

```jsx
// Only run once on mount
useEffect(() => {
  fetchInitialData();
}, []);  // empty array = only on mount

// Only run when `id` changes
useEffect(() => {
  fetchUser(id);
}, [id]);  // primitive values are compared by value, safe
```

**Stabilize object/array dependencies with `useMemo`:**

```jsx
// Memoize the object so it keeps the same reference
const filters = useMemo(() => ({
  status: 'active',
  role: userRole
}), [userRole]);  // only recreate when userRole changes

useEffect(() => {
  fetchData(filters);
}, [filters]);  // stable reference now
```

**Stabilize function dependencies with `useCallback`:**

```jsx
const loadData = useCallback(() => {
  return fetch(`/api/users/${id}`);
}, [id]);  // only recreate when id changes

useEffect(() => {
  loadData();
}, [loadData]);  // stable reference
```

**Use functional setState to avoid depending on the current state:**

```jsx
// Bad: depends on count, which changes every time
useEffect(() => {
  const interval = setInterval(() => {
    setCount(count + 1);  // stale closure AND infinite loop risk
  }, 1000);
  return () => clearInterval(interval);
}, [count]);  // runs on every count change

// Good: functional update, no dependency on count
useEffect(() => {
  const interval = setInterval(() => {
    setCount(prev => prev + 1);  // no external dependency
  }, 1000);
  return () => clearInterval(interval);
}, []);  // runs once
```

## Don't do this

- Don't disable the `react-hooks/exhaustive-deps` ESLint rule. It's telling you about a real bug. The loop IS the problem, not the linting.
- Don't add `// eslint-disable-next-line` to silence the warning without fixing the root cause. You'll end up with stale closures or infinite loops.
- Don't use `useRef` to store a "should I run" flag as a workaround. Fix the dependency array instead.

## Still not working?

If you can't figure out which dependency is changing, log them:

```jsx
const deps = [filters, userId, config];

useEffect(() => {
  console.log('useEffect fired');
}, deps);

// Add this to find WHICH dep changed
const prevDeps = useRef(deps);
useEffect(() => {
  deps.forEach((dep, i) => {
    if (dep !== prevDeps.current[i]) {
      console.log(`Dependency ${i} changed:`, prevDeps.current[i], '->', dep);
    }
  });
  prevDeps.current = deps;
});
```

If the dependency is coming from a context or Redux store, the provider might be creating a new object on every render. Move the memoization to the provider:

```jsx
// In the context provider
const value = useMemo(() => ({ user, settings }), [user, settings]);
return <MyContext.Provider value={value}>{children}</MyContext.Provider>;
```
