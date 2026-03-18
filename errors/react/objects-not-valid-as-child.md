# Objects are not valid as a React child

> Error: Objects are not valid as a React child (found: object with keys {xxx, yyy}). If you meant to render a collection of children, use an array instead.
> Error: Objects are not valid as a React child (found: [object Promise]).

## What happened

You tried to render a plain JavaScript object directly in JSX. React can render strings, numbers, booleans, null, undefined, and other React elements, but not plain objects.

## Why it happens

- You're rendering an entire object instead of a specific property
- You're rendering a Date object directly
- You're accidentally rendering a Promise (forgot `await` or didn't use state)
- You're passing an object where a string is expected

## How to fix it

**If you're rendering an object instead of its property:**

```jsx
// WRONG
const user = { name: 'Alice', age: 30 };
return <div>{user}</div>;

// RIGHT: access the specific property
return <div>{user.name}</div>;

// Or stringify it for debugging
return <pre>{JSON.stringify(user, null, 2)}</pre>;
```

**If it's a Date object:**

```jsx
// WRONG
return <span>{new Date()}</span>;

// RIGHT
return <span>{new Date().toLocaleDateString()}</span>;
```

**If it says `[object Promise]`:**

```jsx
// WRONG: async functions return Promises
const getData = async () => { /* ... */ };
return <div>{getData()}</div>;

// RIGHT: use state and useEffect
const [data, setData] = useState(null);
useEffect(() => {
  getData().then(setData);
}, []);
return <div>{data?.name}</div>;
```

## Don't do this

- Don't wrap everything in `JSON.stringify()` as a permanent fix. It means your data flow is wrong.
- Don't use `.toString()` on objects. You'll get `[object Object]` in your UI.

## Still not working?

- Check if a library returns an object where you expect a string (e.g., i18n libraries returning objects instead of translated strings).
- If using `React.Children` API, make sure you're passing actual React nodes, not configuration objects.
- Console.log the value right before the JSX to see its actual type and shape.
