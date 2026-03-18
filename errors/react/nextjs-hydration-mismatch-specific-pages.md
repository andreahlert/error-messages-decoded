# Next.js hydration mismatch on specific pages

> Error: Hydration failed because the initial UI does not match what was rendered on the server.

## What happened
The HTML generated on the server differs from what React renders on the client, causing a hydration mismatch on certain pages.

## Why it happens
Server and client render different output when code depends on browser-only values: `Date.now()` (different timezone/locale), `window.innerWidth`, `localStorage`, or `navigator`. Browser extensions that inject DOM elements also cause mismatches. The server renders one thing, the client renders another.

## How to fix it
```jsx
// Defer browser-dependent rendering to useEffect
import { useState, useEffect } from 'react';

function TimeDisplay() {
  const [time, setTime] = useState('');

  useEffect(() => {
    // Only runs on client, after hydration
    setTime(new Date().toLocaleString());
  }, []);

  return <span>{time}</span>;
}

// For components that must differ, use typeof window check
function ClientOnly({ children }) {
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  if (!mounted) return null;
  return children;
}
```

## Still not working?
Check for browser extensions (React DevTools, ad blockers) injecting elements into the DOM. Test in incognito mode. If the mismatch involves dates or locale-specific formatting, ensure both server and client use the same timezone/locale settings, or defer formatting to `useEffect`.
