# Jest fails with ESM import syntax

> SyntaxError: Cannot use import statement outside a module

## What happened
Jest tried to run a test that imports from an ESM-only npm package, but Jest's default CommonJS transform pipeline cannot handle the ES module syntax.

## Why it happens
Some npm packages ship only ESM (using `export`/`import`). Jest runs in CommonJS mode by default and needs a transform step to convert ESM imports. If the package is in `node_modules` and excluded from transforms, the raw ESM syntax causes a syntax error.

## How to fix it
```js
// jest.config.js - transform the ESM package with babel-jest
module.exports = {
  transform: {
    '^.+\\.[jt]sx?$': 'babel-jest',
  },
  transformIgnorePatterns: [
    'node_modules/(?!(esm-only-package|another-esm-pkg)/)',
  ],
};
```

```bash
# Install babel preset if not present
npm install --save-dev @babel/preset-env
```

## Still not working?
If using TypeScript, configure `ts-jest` with `esModuleInterop: true` in your tsconfig. You can also use `moduleNameMapper` in Jest config to point to a CommonJS build of the dependency if one exists.
