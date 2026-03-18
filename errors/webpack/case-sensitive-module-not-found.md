# Module not found due to case sensitivity

> Module not found: Error: Can't resolve './Component' in '/app/src/pages'

## What happened
The import path works on macOS/Windows but fails on Linux (CI, Docker, production) because the filename's case does not match the import statement.

## Why it happens
macOS and Windows use case-insensitive filesystems by default, so `import './Component'` resolves even if the file is `component.tsx`. Linux uses a case-sensitive filesystem, so the exact case must match. This commonly breaks in CI/Docker where the environment is Linux-based.

## How to fix it
```bash
# Find the actual filename and fix the import
ls -la src/pages/

# Rename the file to match the import (or vice versa)
git mv src/pages/component.tsx src/pages/Component.tsx

# Use case-sensitive-paths-webpack-plugin to catch this locally
npm install --save-dev case-sensitive-paths-webpack-plugin
```

```js
// webpack.config.js
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
module.exports = {
  plugins: [new CaseSensitivePathsPlugin()],
};
```

## Still not working?
On macOS, you can create a case-sensitive APFS volume for development to catch these issues early. Always use `git mv` to rename files so Git tracks the case change properly. Check all imports in the file, not just the one reported.
