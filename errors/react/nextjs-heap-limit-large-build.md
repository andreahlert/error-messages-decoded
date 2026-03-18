# Next.js build runs out of memory

> FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory

## What happened
The Next.js build process exhausted the default Node.js heap memory limit while generating static pages or processing large bundles.

## Why it happens
Large Next.js apps with many static pages (via `getStaticPaths`) or heavy dependencies can exceed the default ~1.7GB heap limit during build. Each pre-rendered page consumes memory, and with hundreds or thousands of pages, the build process runs out.

## How to fix it
```bash
# Increase Node.js heap size for the build
export NODE_OPTIONS="--max-old-space-size=8192"
next build

# Or in package.json scripts
# "build": "NODE_OPTIONS='--max-old-space-size=8192' next build"
```

```js
// next.config.js - use ISR to avoid building all pages at once
export default {
  // Reduce pages built at build time
  experimental: {
    workerThreads: true,
  },
};

// In getStaticPaths - limit pre-rendered pages
export async function getStaticPaths() {
  return {
    paths: [], // build on-demand
    fallback: 'blocking', // ISR
  };
}
```

## Still not working?
Enable incremental static regeneration (ISR) to avoid pre-rendering all pages at build time. Audit your bundle with `@next/bundle-analyzer` to find oversized dependencies. If using `output: 'standalone'`, ensure you're not importing server-heavy modules in client components.
