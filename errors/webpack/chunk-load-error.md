# ChunkLoadError: Loading chunk xxx failed

> ChunkLoadError: Loading chunk 452 failed.
> (error: https://example.com/static/js/452.abc123.js)
> Uncaught (in promise) ChunkLoadError: Loading chunk vendors~main failed.

## What happened

The browser tried to load a JavaScript chunk (code-split bundle) and the network request failed. The user sees a broken page or a feature that doesn't load.

## Why it happens

- A new deployment changed chunk filenames but the user's browser has a cached HTML page referencing old chunks
- CDN or server returned a 404 for the chunk file
- Network issue (flaky connection, corporate proxy blocking)
- `output.publicPath` is wrong in your webpack config
- The chunk was never built (build error that was ignored)

## How to fix it

**Handle the error gracefully with a retry/reload:**

```javascript
// In your app's error boundary or lazy load wrapper
const MyComponent = React.lazy(() =>
  import('./MyComponent').catch(() => {
    // Chunk failed to load, reload the page to get fresh HTML
    window.location.reload();
    return { default: () => null };
  })
);
```

**Better approach with retry logic:**

```javascript
function lazyRetry(importFn, retries = 3) {
  return new Promise((resolve, reject) => {
    importFn()
      .then(resolve)
      .catch((error) => {
        if (retries > 0) {
          setTimeout(() => {
            lazyRetry(importFn, retries - 1).then(resolve, reject);
          }, 1000);
        } else {
          reject(error);
        }
      });
  });
}

const MyComponent = React.lazy(() => lazyRetry(() => import('./MyComponent')));
```

**Fix `publicPath` if it's wrong:**

```javascript
// webpack.config.js
output: {
  publicPath: '/',  // or your CDN URL
}
```

## Don't do this

- Don't force `window.location.reload()` in an infinite loop. Add a check (sessionStorage flag) to only reload once.
- Don't disable code splitting to "fix" this. You'll ship a massive single bundle instead.

## Still not working?

- Check your deployment process. If you delete old chunks before all users have loaded the new HTML, cached pages will break. Keep old chunks around for at least one deployment cycle.
- Verify the chunk files exist on your server/CDN: `curl -I https://example.com/static/js/452.abc123.js`.
- If using a service worker, it might be caching old HTML that references old chunks. Update the SW cache strategy.
- Use `output.chunkFilename: '[name].[contenthash].js'` so chunks get unique names per build.
