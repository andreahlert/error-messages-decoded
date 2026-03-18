# Next.js environment variable undefined on client side

> TypeError: Cannot read properties of undefined (reading 'API_KEY')

## What happened
An environment variable accessible in server-side code is `undefined` when accessed in a client component or browser-side code.

## Why it happens
Next.js only exposes environment variables to the client if they are prefixed with `NEXT_PUBLIC_`. Server-only env vars (without the prefix) are stripped from the client bundle for security. Accessing `process.env.API_KEY` in a client component returns `undefined`.

## How to fix it
```bash
# Rename the env var with NEXT_PUBLIC_ prefix for client-side access
# .env.local
NEXT_PUBLIC_API_KEY=your-api-key

# Access it in client components as:
# process.env.NEXT_PUBLIC_API_KEY
```

```jsx
// If the key is sensitive, keep it server-only
// Use an API route or Server Component instead
// app/api/data/route.ts
export async function GET() {
  const data = await fetch('https://api.example.com', {
    headers: { Authorization: `Bearer ${process.env.API_KEY}` },
  });
  return Response.json(await data.json());
}
```

## Still not working?
After adding or changing env vars, restart the Next.js dev server. Environment variables are embedded at build time, not runtime. If deploying to Vercel/Netlify, add the env var in the platform's dashboard. Never expose secret keys with `NEXT_PUBLIC_` prefix.
