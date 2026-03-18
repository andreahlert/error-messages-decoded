# ERR_MODULE_NOT_FOUND with ES modules import

> node:internal/errors:496
>     ErrorCaptureStackTrace(err);
>     ^
> Error [ERR_MODULE_NOT_FOUND]: Cannot find module '/home/user/project/src/utils'
> imported from /home/user/project/src/index.js
> Did you mean to import "../src/utils.js"?
>     at finalizeResolution (node:internal/modules/esm/resolve:264:11)
>     at moduleResolve (node:internal/modules/esm/resolve:913:10)
>   code: 'ERR_MODULE_NOT_FOUND'

## What happened

You're using ES modules (`import`/`export`) and Node can't resolve one of your imports. The file exists, but Node's ESM loader has stricter rules than CommonJS.

## Why it happens

ES modules in Node require **full file extensions** in relative imports. Unlike CommonJS `require()` which auto-resolves `./utils` to `./utils.js`, ESM does not. This is by design, matching how browsers handle module imports. Node is telling you exactly what's wrong, but if you're coming from CommonJS or bundled TypeScript, this feels wrong.

## How to fix it

```javascript
// WRONG - this worked in CommonJS but fails in ESM
import { helper } from './utils';

// RIGHT - include the .js extension
import { helper } from './utils.js';

// WRONG - directory imports don't auto-resolve index.js either
import { db } from './lib';

// RIGHT
import { db } from './lib/index.js';
```

Make sure your `package.json` has the module type set:

```json
{
  "type": "module"
}
```

## Don't do this

**Don't switch back to CommonJS just because of this.** Adding `.js` extensions is a one-time migration cost.

**Don't add a bundler (webpack/esbuild) solely to work around this.** That's a sledgehammer for a thumbtack.

## Still not working?

If you're importing from `node_modules`, bare specifiers still work fine. The extension rule only applies to relative imports:

```javascript
// This is fine, no extension needed
import express from 'express';

// This needs an extension
import { myUtil } from './myUtil.js';
```

If you're using TypeScript with ESM, you need `.js` extensions in your `.ts` files (yes, really):

```typescript
// In src/index.ts, importing src/utils.ts:
import { helper } from './utils.js';  // .js, not .ts
```

This is because TypeScript doesn't rewrite import paths. The compiled `.js` output needs to reference `.js` files.

If you're using `ts-node` with ESM:

```bash
# Use the ESM loader
node --loader ts-node/esm src/index.ts

# Or in tsconfig.json
{
  "ts-node": {
    "esm": true
  }
}
```
