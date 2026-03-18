# JavaScript heap out of memory

> FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - JavaScript heap out of memory
>  1: 0xb090e0 node::Abort() [node]
>  2: 0xa1b70e v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, v8::OOMDetails const&) [node]
>
> --- or in newer Node versions ---
>
> FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory

## What happened

Node's V8 engine ran out of memory during a build, test run, or while processing data. The process was killed.

## Why it happens

V8 defaults to ~1.7GB heap on 64-bit systems. This gets blown by: webpack/vite building a large app, TypeScript compiling a huge codebase, reading a massive file into memory, or a memory leak in a long-running process. The garbage collector can't free memory fast enough (or at all, if you're leaking).

## How to fix it

For build tools (webpack, tsc, vite, next build):

```bash
# Increase Node's heap limit (4GB in this example)
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build

# Or inline for a single command
NODE_OPTIONS="--max-old-space-size=4096" npx webpack
```

Common values: `4096` (4GB), `8192` (8GB). Don't go above your available RAM.

For `package.json` scripts, set it permanently:

```json
{
  "scripts": {
    "build": "NODE_OPTIONS='--max-old-space-size=4096' next build"
  }
}
```

## Don't do this

**Don't just keep increasing the heap size.** If your project needs 16GB to build, something is wrong. You're masking a real problem (circular dependencies, unoptimized source maps, bundling `node_modules`).

**Don't add `--max-old-space-size` to your shell profile globally.** Every Node process will allocate that much. Set it per-command.

## Still not working?

If it's a memory leak in a running server, increasing heap just delays the crash:

```bash
# Profile memory usage
node --inspect server.js
# Open chrome://inspect, take heap snapshots, compare them
```

For webpack specifically, check these common memory hogs:

```javascript
// webpack.config.js - use cheaper source maps for dev
devtool: 'eval-cheap-module-source-map',  // not 'source-map'

// Limit TypeScript checking to relevant files
// fork-ts-checker-webpack-plugin eats RAM on large codebases
```

If it's happening in CI (GitHub Actions, etc.), the runner might have limited memory:

```yaml
# GitHub Actions runners have 7GB RAM
# Use swap or split the build
env:
  NODE_OPTIONS: "--max-old-space-size=4096"
```
