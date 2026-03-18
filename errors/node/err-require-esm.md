# require() of ES Module not supported

> Error [ERR_REQUIRE_ESM]: require() of ES Module /home/user/project/node_modules/node-fetch/src/index.js
> from /home/user/project/src/api.js not supported.
> Instead change the require of index.js in /home/user/project/src/api.js to a dynamic import()
> which is available in all CommonJS modules.

## What happened

You're using `require()` to import a package that shipped as ESM-only. The package author dropped CommonJS support and your project still uses `require()`.

## Why it happens

Starting around 2021-2022, popular packages migrated to ESM-only: `node-fetch` v3, `chalk` v5, `got` v12, `nanoid` v4, `p-*` packages, `execa` v6+, `globby` v13+. They set `"type": "module"` in their package.json. Node's `require()` cannot load ES modules. This is by design, not a bug.

## How to fix it

**Option 1: Pin to the last CommonJS version (v2/v4/v11)** (quickest fix, no code changes)

This is often the simplest and safest fix. These packages' last CJS versions are stable and still receive security patches in many cases:

```bash
# Common packages and their last CJS versions:
npm install node-fetch@2       # v3+ is ESM-only
npm install chalk@4            # v5+ is ESM-only
npm install got@11             # v12+ is ESM-only
npm install nanoid@3           # v4+ is ESM-only
npm install globby@11          # v12+ is ESM-only
npm install execa@5            # v6+ is ESM-only
```

**Trap:** Don't waste hours trying to convert your entire project to ESM or configuring dynamic imports when pinning to v2 (or equivalent) works immediately. The CJS versions are battle-tested and widely used. Convert to ESM on your own timeline, not because a dependency forced you.

**Option 2: Use dynamic import()** (works in CommonJS)

```javascript
// Instead of: const fetch = require('node-fetch');
const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

// Or use async/await
async function main() {
  const { default: fetch } = await import('node-fetch');
  const res = await fetch('https://example.com');
}
```

**Option 3: Convert your project to ESM** (proper long-term fix)

```json
// package.json
{ "type": "module" }
```

Then change all `require()` to `import` and `module.exports` to `export`.

## Don't do this

**Don't downgrade Node to dodge this.** The error comes from the package, not Node's version.

**Don't fork the package to add CJS back.** You'll miss security updates and bug fixes.

## Still not working?

If you're stuck in CommonJS because of your tooling (Jest, ts-node), and can't convert:

```bash
# Jest has experimental ESM support
node --experimental-vm-modules npx jest

# Or use ts-jest with ESM support in jest.config
{
  "extensionsToTreatAsEsm": [".ts"],
  "transform": { "^.+\\.tsx?$": ["ts-jest", { "useESM": true }] }
}
```

If the error comes from a transitive dependency (a dep of a dep), you can't pin it directly. Use npm overrides:

```json
{
  "overrides": {
    "node-fetch": "2.7.0"
  }
}
```
