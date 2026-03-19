# Root Cause

This error occurs when the **server-rendered HTML doesn't match what the client renders during hydration**, and that mismatch happens outside a Suspense boundary. Without Suspense to catch the error gracefully, React falls back to full client-side rendering.

Common causes:
1. **Browser APIs on server** - Using `window`, `document`, `localStorage`, etc. in components that also run server-side
2. **Random/dynamic values** - Math.random(), Date.now(), UUIDs generated differently each time
3. **Timezone-dependent rendering** - Date formatting that differs between server and client
4. **Client-only state** - Components that initialize state differently than server output

# Specific Fixes

## Option 1: Suppress hydration on specific mismatches (quick, not ideal)
```jsx
<div suppressHydrationWarning>
  {/* content that might mismatch */}
</div>
```

## Option 2: Only render on client (best for browser APIs)
```jsx
'use client'

import { useEffect, useState } from 'react'

export default function Component() {
  const [mounted, setMounted] = useState(false)
  
  useEffect(() => setMounted(true), [])
  
  if (!mounted) return null
  
  return <div>{typeof window !== 'undefined' && window.location.href}</div>
}
```

## Option 3: Wrap with Suspense (for async components)
```jsx
import { Suspense } from 'react'

export default function Page() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <YourComponent />
    </Suspense>
  )
}
```

## Option 4: Ensure matching render
```jsx
// Bad: different each render
{new Date().toLocaleDateString()}

// Good: deterministic
{new Date('2026-03-18').toLocaleDateString()}
```

**Check your code for:** browser API usage, `Math.random()`, `Date.now()`, timezone-dependent formatting, or state that hydrates differently than server render. That's where the mismatch is happening.
