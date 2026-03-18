# Root Cause

**Node 17+ uses OpenSSL 3.0**, which disabled older cryptographic algorithms (MD5, SHA1) that webpack <5.61.0 and react-scripts <5.0.0 depend on. The error `0308010C` is OpenSSL rejecting these unsupported algorithms.

# Solutions

## Option 1: Upgrade Build Tool (Recommended)

If using **react-scripts** (Create React App):
```bash
npm install react-scripts@latest
```
You need **5.0.0 or higher** which includes webpack 5.61+.

If using **webpack directly**:
```bash
npm install webpack@5.88.0
```
Requires **5.61.0 or higher**.

## Option 2: Use Legacy OpenSSL Provider (Temporary Workaround)

If you can't upgrade immediately, add this to your build script in `package.json`:

```json
{
  "scripts": {
    "build": "NODE_OPTIONS=--openssl-legacy-provider react-scripts build"
  }
}
```

Or on Windows (CMD):
```json
{
  "scripts": {
    "build": "set NODE_OPTIONS=--openssl-legacy-provider && react-scripts build"
  }
}
```

Or Windows (PowerShell):
```json
{
  "scripts": {
    "build": "$env:NODE_OPTIONS='--openssl-legacy-provider'; react-scripts build"
  }
}
```

## Option 3: Downgrade Node

Use Node 16 LTS (not recommended long-term):
```bash
nvm install 16
nvm use 16
```

---

**Best practice**: Upgrade your build tools. The legacy provider flag is a short-term workaround and will be removed in future Node versions.
