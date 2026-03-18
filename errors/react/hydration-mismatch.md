# Hydration failed because the initial UI does not match

> Error: Hydration failed because the initial UI does not match what was rendered on the server.
> Warning: Expected server HTML to contain a matching <div> in <div>.
> Error: There was an error while hydrating. Because the error happened outside of a Suspense boundary, the entire root will switch to client rendering.

## What happened

The HTML generated on the server doesn't match what React tried to render on the client. React can't "hydrate" (attach event listeners to) HTML that has a different structure than what it expects.

## Why it happens

Something in your component produces different output on server vs client:

- Using `window`, `localStorage`, or `document` during render (they don't exist on the server)
- Using `Date.now()` or `Math.random()` which produces different values
- Browser extensions that inject HTML into the page
- Invalid HTML nesting (like `<p>` inside `<p>`, or `<div>` inside `<p>`)

## How to fix it

**For browser-only APIs:**

```jsx
// WRONG: window doesn't exist on server
function Component() {
  const width = window.innerWidth;
  return <div>{width > 768 ? 'Desktop' : 'Mobile'}</div>;
}

// RIGHT: render a consistent default, then update on client
function Component() {
  const [width, setWidth] = useState(0);
  useEffect(() => {
    setWidth(window.innerWidth);
  }, []);
  return <div>{width > 768 ? 'Desktop' : 'Mobile'}</div>;
}
```

**For invalid HTML nesting:**

```jsx
// WRONG: p cannot contain div
<p><div>nested</div></p>

// RIGHT
<div><div>nested</div></div>
```

**For timestamps or dynamic content:**

```jsx
// Use suppressHydrationWarning for intentionally different content
<time suppressHydrationWarning>{new Date().toLocaleString()}</time>
```

## Don't do this

- Don't add `suppressHydrationWarning` to everything. It hides real bugs.
- Don't disable SSR for the whole page. Fix the specific component.
- Don't check `typeof window !== 'undefined'` during render. It changes the output, which IS the mismatch.

## Still not working?

- Browser extensions (especially ad blockers) inject HTML that causes mismatches. Test in incognito mode.
- Check if your CSS-in-JS library generates different class names on server vs client.
- In Next.js, use `next/dynamic` with `{ ssr: false }` for components that truly can't render on the server.
