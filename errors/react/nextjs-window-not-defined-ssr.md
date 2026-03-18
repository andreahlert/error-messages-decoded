# Next.js window is not defined during SSR

> ReferenceError: window is not defined

## What happened
A component or library accesses `window`, `document`, or other browser globals during server-side rendering, where these objects do not exist.

## Why it happens
Next.js renders components on the server first (SSR). The `window` and `document` objects only exist in the browser. If a component or an imported library accesses `window` at the module level or during render, it throws on the server.

## How to fix it
```jsx
import { useEffect, useState } from 'react';

// Option 1: Guard with typeof check
function MyComponent() {
  const isClient = typeof window !== 'undefined';
  // Use isClient before accessing window APIs
}

// Option 2: Use useEffect (runs only on client)
function MyComponent() {
  const [width, setWidth] = useState(0);
  useEffect(() => {
    setWidth(window.innerWidth);
  }, []);
  return <div>Width: {width}</div>;
}

// Option 3: Dynamic import with ssr disabled
import dynamic from 'next/dynamic';
const BrowserOnlyComponent = dynamic(
  () => import('../components/BrowserOnly'),
  { ssr: false }
);
```

## Still not working?
If a third-party library accesses `window` at import time, use `dynamic` import with `ssr: false` to load it only on the client. Check for window references in library initialization code. For chart libraries or rich text editors, this is the most common pattern.
