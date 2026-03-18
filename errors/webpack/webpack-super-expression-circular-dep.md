# TypeError: Super expression must either be null or a function

> TypeError: Super expression must either be null or a function

## What happened
A class tries to extend another class, but the parent class is `undefined` at the time the child class is defined. This usually manifests at runtime, not compile time.

## Why it happens
Circular dependencies between modules cause this. Module A imports from Module B, and Module B imports from Module A. When webpack evaluates the modules, one of them is not fully initialized yet, so the imported class is `undefined`. Barrel files (index.ts re-exporting everything) are a common source of circular imports.

## How to fix it
```bash
# Detect circular dependencies
npx madge --circular src/

# Or use webpack plugin
npm install --save-dev circular-dependency-plugin
```

```js
// webpack.config.js
const CircularDependencyPlugin = require('circular-dependency-plugin');
module.exports = {
  plugins: [
    new CircularDependencyPlugin({
      exclude: /node_modules/,
      failOnError: true,
    }),
  ],
};
```

```typescript
// Break the circular dependency by restructuring imports
// Instead of A imports B, B imports A:
// Extract shared code into a third module C
// A imports C, B imports C
// Or use dynamic import() to break the cycle
```

## Still not working?
Check your barrel files (`index.ts`) that re-export from multiple modules. Move the base class to its own file that does not import from files that depend on it. Refactor the class hierarchy to avoid mutual dependencies. The error can also happen with incorrect Babel/TypeScript decorator configuration.
