# npm ENOTEMPTY rmdir error in CI

> Error: ENOTEMPTY: directory not empty, rmdir '/home/runner/work/app/node_modules/.cache'

## What happened
`npm ci` or `npm install` failed because it could not remove a directory inside `node_modules` that was not empty, typically due to stale cache or corrupted `node_modules`.

## Why it happens
This happens when CI caches `node_modules` between runs and the cache becomes stale or corrupt. npm tries to clean the directory but files remain from a previous build. It can also happen when the lock file has changed but `node_modules` was restored from cache.

## How to fix it
```bash
# Clean node_modules and cache before install
rm -rf node_modules
npm cache clean --force
npm ci

# In CI, don't cache node_modules directly - cache ~/.npm instead
# GitHub Actions example:
# - uses: actions/cache@v4
#   with:
#     path: ~/.npm
#     key: npm-${{ hashFiles('package-lock.json') }}
```

## Still not working?
Delete the CI cache entirely and rebuild. If using GitHub Actions, change the cache key to force a fresh install. Make sure your CI config uses `npm ci` (which deletes `node_modules` first) instead of `npm install`. Check if the lock file is committed and up to date.
