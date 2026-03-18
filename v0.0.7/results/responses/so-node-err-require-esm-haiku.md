**Root cause:** node-fetch v3 is **ES Module only** and has no CommonJS entry point. Node.js blocks `require()` from loading ES Modules by design.

**Your fixes, in order of practicality:**

1. **Downgrade to node-fetch v2** (easiest if you don't need v3's features)
   ```bash
   npm install node-fetch@2
   ```
   v2 supports CommonJS `require()` natively.

2. **Convert to dynamic import** (if you need v3)
   ```javascript
   // Instead of:
   // const fetch = require('node-fetch');
   
   // Use:
   const fetch = (await import('node-fetch')).default;
   ```
   Requires wrapping in an `async` function or converting your module to use `await` at top level.

3. **Switch to a CommonJS-compatible alternative**
   ```bash
   npm install undici  # Node.js built-in alternative, supports CommonJS
   ```
   Then: `const { fetch } = require('undici');`

4. **Convert entire project to ESM** (long-term solution)
   - Add `"type": "module"` to `package.json`
   - Rename `.js` files to `.mjs` or keep `.js` with type flag
   - Replace all `require()` with `import`
   - Replace `module.exports` with `export`

**Recommendation:** Start with option 1 (downgrade) unless you have a specific reason to use v3. If you do need v3 features, option 2 (dynamic import) is the quickest fix for a few callsites, or go straight to ESM conversion if it's a larger codebase.
