# Circular dependency causing undefined imports

> Circular dependency detected: src/moduleA.js -> src/moduleB.js -> src/moduleA.js

## What happened

Two or more modules import each other, forming a cycle. Webpack detected it and warned you. At runtime, one of the modules in the cycle will receive an incomplete (empty object or `undefined`) import instead of the expected value.

## Why it happens

When JavaScript encounters a circular import, it has to break the cycle somewhere. The module that gets loaded second receives a partially initialized version of the first module. In practice, this means some exports are `undefined` at the time they're accessed.

The most common cause is **barrel exports** (index.js files that re-export everything):

```javascript
// src/index.js (barrel file)
export { User } from './User';
export { Order } from './Order';
export { formatName } from './utils';

// src/User.js
import { formatName } from './index';  // goes through barrel

// src/utils.js
import { User } from './index';  // goes through barrel

// Cycle: User -> index -> utils -> index -> User
// At runtime, User is undefined when utils.js loads
```

It also happens with tightly coupled modules:

```javascript
// moduleA.js
import { helperB } from './moduleB';
export const helperA = () => helperB();

// moduleB.js
import { helperA } from './moduleA';
export const helperB = () => helperA();
```

## How to fix it

**1. Import directly from the source file, not through barrel exports:**

```javascript
// Bad: imports through the barrel, creating cycles
import { formatName } from './index';

// Good: import directly from the source
import { formatName } from './utils';
```

**2. Extract shared code into a separate module:**

```javascript
// Before: A imports from B, B imports from A
// After: extract shared logic to C

// shared.js (new file, no imports from A or B)
export const sharedHelper = () => { /* ... */ };

// moduleA.js
import { sharedHelper } from './shared';

// moduleB.js
import { sharedHelper } from './shared';
```

**3. Use lazy imports for cases where you truly need the cycle:**

```javascript
// moduleA.js
export const helperA = () => {
  // Import at call time, not at module load time
  const { helperB } = require('./moduleB');
  return helperB();
};
```

**4. Detect cycles with the circular-dependency-plugin:**

```bash
npm install --save-dev circular-dependency-plugin
```

```javascript
// webpack.config.js
const CircularDependencyPlugin = require('circular-dependency-plugin');

module.exports = {
  plugins: [
    new CircularDependencyPlugin({
      exclude: /node_modules/,
      failOnError: true,  // fail the build on cycles
      allowAsyncCycles: false,
      cwd: process.cwd(),
    })
  ]
};
```

**5. For large codebases, find all cycles:**

```bash
# Using madge to visualize dependencies
npx madge --circular src/
npx madge --circular --image graph.png src/
```

## Don't do this

- Don't ignore the warning. The code might work now by coincidence (load order), but it will break unpredictably when you add new imports, change bundler settings, or code-split.
- Don't fix it by reordering imports. The evaluation order depends on the bundler and can change between builds.
- Don't just suppress the warning in your webpack config. The `undefined` imports will cause runtime crashes in production.

## Still not working?

If you have a deep dependency tree and can't find the cycle, trace it step by step:

```bash
# List the full chain for a specific file
npx madge --circular --warning src/moduleA.js

# Generate a dependency graph image
npx madge --image deps.svg src/
```

For barrel files (`index.js`), consider breaking them into smaller, focused barrels:

```javascript
// Instead of one giant index.js
// src/index.js exports EVERYTHING

// Split into focused entry points
// src/models/index.js - only models
// src/utils/index.js - only utilities
// src/services/index.js - only services

// Rule: a barrel should never import from another barrel
```

If you're using TypeScript, type-only imports don't cause runtime cycles:

```typescript
// This is safe: type imports are erased at compile time
import type { User } from './User';

// This causes cycles: it's a value import
import { User } from './User';
```
