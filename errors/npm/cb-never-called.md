# npm cb() never called

> npm ERR! cb() never called!
> npm ERR! This is an error with npm itself. Please report this error at:
> npm ERR!     <https://github.com/npm/cli/issues>
> npm ERR! A complete log of this run can be found in:
> npm ERR!     /home/user/.npm/_logs/2024-01-15T10_30_00_000Z-debug-0.log

## What happened

npm's install process crashed partway through. An internal callback was never invoked, leaving npm in a broken state. The install did not complete.

## Why it happens

This is almost always a corrupted npm cache or a network interruption during package download. A package tarball got partially downloaded, npm cached the broken file, and now every subsequent install tries to use the corrupt cached version and chokes. It can also be triggered by disk space issues or antivirus software locking files mid-write.

## How to fix it

```bash
# Step 1: Clear the npm cache
npm cache clean --force

# Step 2: Remove node_modules and lockfile
rm -rf node_modules package-lock.json

# Step 3: Reinstall
npm install
```

If that doesn't work:

```bash
# Nuclear option: clear everything npm-related
npm cache clean --force
rm -rf node_modules package-lock.json
rm -rf ~/.npm/_cacache
npm install
```

## Don't do this

**Don't just re-run `npm install` without clearing the cache.** The corrupt cache entry is the problem. It won't fix itself.

**Don't downgrade npm.** This error exists across versions. It's almost never an npm version bug.

**Don't file a GitHub issue on npm** (despite what the error says). 99% of the time it's your cache, not npm's code.

## Still not working?

Check available disk space:

```bash
df -h .
```

If you're behind a corporate proxy or VPN, the download might be getting mangled:

```bash
# Check your registry config
npm config get registry

# Try switching to the official registry
npm config set registry https://registry.npmjs.org/

# If behind a proxy
npm config set proxy http://your-proxy:8080
npm config set https-proxy http://your-proxy:8080
```

On Windows, antivirus (especially Windows Defender) can lock files during extraction. Add your project directory and `%APPDATA%\npm-cache` to the exclusion list.

If it keeps happening, try a different package manager:

```bash
npx corepack enable
corepack prepare pnpm@latest --activate
pnpm install
```
