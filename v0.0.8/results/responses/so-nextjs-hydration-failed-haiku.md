# Root Cause

A hydration mismatch happens when the HTML rendered on the server doesn't match what React generates on the client. The server renders static HTML, then React takes over on the client — if they don't match, React can't safely attach event listeners and reuses the DOM.

Common culprits:

1. **Browser-only APIs used during render** — accessing `window`, `document`, `navigator`, or `localStorage` during component render
2. **Random/dynamic values** — timestamps, UUIDs, or Math.random() without consistent seeding
3. **Client-only state** — conditional rendering based on `useEffect` state or `typeof window` checks that evaluate differently on server
4. **Time-based rendering** — showing different content based on current time, timezone, or date
5. **Hydration timing mismatch** — data fetching that completes at different times

---

# How to Fix

**Option 1: Use `suppressHydrationWarning`** (quick fix, temporary)
```jsx
<div suppressHydrationWarning>
  {typeof window !== 'undefined' && <dynamic-content />}
</div>
```
Only suppress where you *intentionally* have client-only content.

**Option 2: Defer rendering until hydration completes** (preferred)
```jsx
export default function MyComponent() {
  const [isClient, setIsClient] = useState(false);
  useEffect(() => setIsClient(true), []);

  if (!isClient) return null; // or a skeleton/placeholder
  return <your-dynamic-content />;
}
```

**Option 3: Use `next/dynamic` with `ssr: false`** (for heavy client components)
```jsx
const DynamicComponent = dynamic(() => import('./MyComponent'), { ssr: false });
export default function Page() {
  return <DynamicComponent />;
}
```

**Option 4: Make server and client render identical**
If you're using random values, timestamps, or browser APIs:
- Move them to `useEffect` only (client-side)
- For data: fetch on server with `getServerSideProps` or `getStaticProps`, pass as props
- For timestamps: render a placeholder on server, format only on client

**Option 5: Check for CSS/styling** (less obvious)
If using CSS-in-JS (styled-components, emotion), ensure it's configured for Next.js with proper Babel plugins. Mismatched class names between server and client cause mismatches.

---

# Debug Steps

1. **Open DevTools** → check Console for the specific element that mismatches
2. **Compare markup** → inspect what the server rendered vs. what's in the DOM after hydration
3. **Check your code** for `typeof window`, `useEffect`, `useState` initializers that access browser APIs
4. **Verify data fetching** — if you're fetching data that affects render, ensure it happens before server render

Most common fix: move browser-dependent logic to `useEffect` or use the `isClient` pattern above.
