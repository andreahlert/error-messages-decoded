# OpenSSL digital envelope routines unsupported

> Error: error:0308010C:digital envelope routines::unsupported
>     at new Hash (node:internal/crypto/hash:71:19)
>     at Object.createHash (node:crypto:133:10)
>     at module.exports (/home/user/project/node_modules/webpack/lib/util/createHash.js:135:53)
> {
>   opensslErrorStack: [ 'error:03000086:digital envelope routines::initialization error' ],
>   library: 'digital envelope routines',
>   reason: 'unsupported',
>   code: 'ERR_OSSL_EVP_UNSUPPORTED'
> }

## What happened

Your build (usually webpack 4, or Create React App with react-scripts < 5) crashed because it uses an MD4 hash that OpenSSL 3.0 no longer allows by default.

## Why it happens

Node 17+ ships with OpenSSL 3.0, which disabled legacy hashing algorithms like MD4. Webpack 4 uses MD4 internally for module hashing. The webpack code calls `crypto.createHash('md4')` and OpenSSL 3.0 rejects it. This affects: Create React App (react-scripts < 5), older webpack 4 setups, and any tool using legacy crypto algorithms.

## How to fix it

**Option 1: Use the OpenSSL legacy provider** (quick workaround)

```bash
export NODE_OPTIONS=--openssl-legacy-provider
npm run build
```

For `package.json`:

```json
{
  "scripts": {
    "build": "NODE_OPTIONS=--openssl-legacy-provider react-scripts build",
    "start": "NODE_OPTIONS=--openssl-legacy-provider react-scripts start"
  }
}
```

**Option 2: Upgrade to webpack 5** (proper fix)

```bash
# For Create React App, upgrade react-scripts
npm install react-scripts@5

# For raw webpack
npm install webpack@5 webpack-cli@5
```

Webpack 5 uses xxhash64 by default, which works fine with OpenSSL 3.0.

## Don't do this

**Don't downgrade Node to 16 LTS.** Node 16 is EOL. You're trading one problem for security vulnerabilities.

**Don't set `NODE_OPTIONS=--openssl-legacy-provider` globally in your shell profile.** It weakens crypto for every Node process on your machine.

## Still not working?

If you can't upgrade webpack and the env var doesn't work on Windows:

```powershell
# Windows PowerShell
$env:NODE_OPTIONS="--openssl-legacy-provider"
npm run build

# Or in cross-platform package.json using cross-env
npm install --save-dev cross-env
```

```json
{
  "scripts": {
    "build": "cross-env NODE_OPTIONS=--openssl-legacy-provider webpack"
  }
}
```

If the error comes from a different tool (not webpack), you can force the hash algorithm in webpack config:

```javascript
// webpack.config.js (webpack 5 only)
output: {
  hashFunction: 'xxhash64',
}
```

For Vite/esbuild users: you shouldn't see this error. If you do, a plugin or dependency is using the old Node crypto API directly.
