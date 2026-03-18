# Next.js cannot resolve 'fs' in client component

> Module not found: Can't resolve 'fs'

## What happened
A Next.js client component or a dependency tries to import the Node.js `fs` module, which does not exist in the browser bundle.

## Why it happens
Client components (marked with `'use client'` or imported into client code) are bundled for the browser, where Node.js built-in modules like `fs`, `path`, `crypto` are unavailable. This happens when server-only code leaks into the client bundle, or a library has both server and client exports but the bundler picks the wrong one.

## How to fix it
```js
// next.config.js - add webpack resolve fallback for the module
module.exports = {
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        path: false,
        crypto: false,
      };
    }
    return config;
  },
};

// Or use dynamic import with ssr disabled for the component
import dynamic from 'next/dynamic';
const ServerComponent = dynamic(() => import('./ServerComponent'), {
  ssr: false,
});
```

## Still not working?
Move fs-dependent logic to a Server Component (no `'use client'` directive), API route, or `getServerSideProps`. If a third-party library causes this, check if it has a separate browser entry point. Use `import 'server-only'` package to mark modules that should never be bundled for the client.
