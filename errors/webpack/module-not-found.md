# Module not found: Error: Can't resolve 'xxx'

> Module not found: Error: Can't resolve 'xxx' in '/path/to/project/src'
> Module not found: Error: Can't resolve './components/Header'

## What happened

Webpack can't find a module you imported. The import path doesn't resolve to any file or installed package.

## Why it happens

- The package isn't installed (missing from `node_modules`)
- The file path is wrong (typo, wrong extension, wrong relative path)
- Webpack's `resolve.extensions` doesn't include your file's extension
- Path aliases (`@/`, `~/`) aren't configured in webpack

## How to fix it

**If it's an npm package:**

```bash
npm install xxx
# or
yarn add xxx
```

**If it's a file import with wrong path:**

```bash
# Check the actual file path
ls src/components/
# Maybe it's Header.tsx, not Header.js
```

**If webpack doesn't resolve your file extension:**

```javascript
// webpack.config.js
module.exports = {
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx', '.json'],
  },
};
```

**If using path aliases:**

```javascript
// webpack.config.js
const path = require('path');
module.exports = {
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },
};
```

Don't forget to also add aliases in `tsconfig.json` if using TypeScript.

## Don't do this

- Don't install packages globally and expect webpack to find them. Webpack only looks in the project's `node_modules`.
- Don't use absolute file paths in imports. They break on other machines.

## Still not working?

- Delete `node_modules` and `package-lock.json`, then `npm install` fresh.
- Check for case sensitivity. macOS is case-insensitive, Linux is not. `./Header` vs `./header` matters in CI/CD.
- If using `resolve.modules`, make sure it includes `node_modules`.
- Run webpack with `--stats verbose` to see the full resolution attempt.
