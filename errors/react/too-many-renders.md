# Too many re-renders

> Error: Too many re-renders. React limits the number of renders to prevent an infinite loop.

## What happened

Your component entered an infinite render loop. React detected it was calling `setState` during render, triggering another render, which called `setState` again, forever.

## Why it happens

Almost always one of these two mistakes:

1. Calling a function directly in JSX instead of passing a reference
2. Calling `setState` unconditionally inside the component body

## How to fix it

**Mistake #1: Calling the function in onClick instead of referencing it:**

```jsx
// WRONG: this calls handleClick immediately on every render
<button onClick={handleClick()}>Click</button>

// RIGHT: pass the function reference
<button onClick={handleClick}>Click</button>

// RIGHT: if you need to pass arguments, wrap in arrow function
<button onClick={() => handleClick(id)}>Click</button>
```

**Mistake #2: setState during render:**

```jsx
// WRONG: this sets state on every render, causing re-render
function Component() {
  const [count, setCount] = useState(0);
  setCount(count + 1); // infinite loop

  // RIGHT: put it in useEffect
  useEffect(() => {
    setCount(c => c + 1);
  }, []); // runs once after mount
}
```

**Mistake #3: Object/array in useEffect dependency causing loop:**

```jsx
// WRONG: new object reference every render triggers useEffect
useEffect(() => {
  fetchData(filters);
}, [{ status: 'active' }]); // new object every render = infinite loop

// RIGHT: use primitive values or useMemo
const filters = useMemo(() => ({ status: 'active' }), []);
useEffect(() => {
  fetchData(filters);
}, [filters]);
```

## Don't do this

- Don't "fix" it by removing the dependency array from useEffect. That makes it run on every render, which is probably what caused this in the first place.
- Don't add `if` checks inside the render body to gate `setState` calls. Move the logic into `useEffect`.

## Still not working?

- Add a `console.log` at the top of the component to see what props/state change each render.
- Use React DevTools Profiler to see what triggers each render.
- Check custom hooks. The infinite loop might be inside a custom hook, not your component directly.
