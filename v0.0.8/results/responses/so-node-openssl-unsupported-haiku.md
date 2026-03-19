## Root Cause

Node.js 17+ uses OpenSSL 3.0 by default, which disabled legacy cryptographic algorithms that older versions of webpack and build tools depend on. Your build tools are trying to use these now-unsupported algorithms.

## Fixes

**Option 1: Use the legacy OpenSSL provider (quickest)**

Add this to your `package.json` scripts:

```json
"build": "NODE_OPTIONS=--openssl-legacy-provider webpack build"
```

Or if using `react-scripts`:

```json
"build": "NODE_OPTIONS=--openssl-legacy-provider react-scripts build"
```

**Option 2: Upgrade your build tools (recommended long-term)**

Update webpack and related packages to versions that support Node 17+:

```bash
npm install --save-dev webpack@latest webpack-cli@latest
```

Also update `react-scripts` if using Create React App:

```bash
npm install react-scripts@latest
```

**Option 3: Downgrade Node.js (temporary)**

Use Node 16 LTS until you can upgrade your build tools:

```bash
nvm install 16
nvm use 16
```

## Which to choose?

- **Short term**: Use Option 1 (legacy provider flag) to unblock immediately
- **Long term**: Do Option 2 (upgrade build tools) to stay on Node 17+ safely

Most npm packages have released Node 17+ compatible versions by now, so upgrading is usually smooth.
