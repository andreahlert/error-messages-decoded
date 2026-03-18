# Invalid hook call

> Error: Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:
> 1. You might have mismatching versions of React and the renderer (such as React DOM)
> 2. You might be breaking the Rules of Hooks
> 3. You might have more than one copy of React in the same app

## What happened

React hooks (`useState`, `useEffect`, etc.) were called somewhere they can't run. This crashes the entire component tree.

## Why it happens

Despite the three reasons listed, the actual cause is almost always one of these:

1. You called a hook inside a regular function, not a component or custom hook
2. You have two copies of React in your bundle (very common in monorepos)
3. You called a hook conditionally or inside a loop

## How to fix it

**If you called a hook outside a component:**

```jsx
// WRONG: this is a plain function, not a component
function getData() {
  const [data, setData] = useState(null); // breaks
}

// RIGHT: components start with uppercase and return JSX
function DataLoader() {
  const [data, setData] = useState(null);
  return <div>{data}</div>;
}

// RIGHT: custom hooks must start with "use"
function useData() {
  const [data, setData] = useState(null);
  return data;
}
```

**If you have duplicate React copies:**

```bash
# Check for duplicates
npm ls react

# If you see multiple versions, deduplicate
npm dedupe

# In a monorepo, hoist react to the root
# Add to root package.json
```

**If you're calling hooks conditionally:**

```jsx
// WRONG
if (isLoggedIn) {
  const [user, setUser] = useState(null); // breaks
}

// RIGHT: always call hooks at the top level
const [user, setUser] = useState(null);
// Use the condition elsewhere
```

## Don't do this

- Don't alias React hooks to hide them inside utility functions. The call still needs to happen in a component body.
- Don't mix React 17 and React 18 in the same bundle. Pin all React packages to the same major version.

## Still not working?

- If using Webpack, add a `resolve.alias` for `react` to force a single copy:
  ```js
  resolve: { alias: { react: path.resolve('./node_modules/react') } }
  ```
- If using linked packages (`npm link`), this is almost certainly a duplicate React issue. Use `npm link ../your-package/node_modules/react` from the app.
- Class components also trigger this if you accidentally call hooks inside them.
