# Node can't find a module you definitely installed

> Error: Cannot find module 'express'
> Require stack:
> - /home/user/project/src/index.js
>     at Function.Module._resolveFilename (node:internal/modules/cjs/loader:1075:15)
>     at Function.Module._load (node:internal/modules/cjs/loader:920:27)

## What happened

You're requiring or importing a package that Node can't locate in any of the paths it searches. You probably installed it, but not where Node is looking.

## Why it happens

Node resolves modules by walking up the directory tree looking for `node_modules/` folders. If you installed the package in a different directory than where your script runs, or if `node_modules` got deleted/corrupted, Node won't find it. Common triggers: running `npm install` in the wrong directory, using a global install when you need local, or a botched `node_modules` after a failed install.

## How to fix it

```bash
# Most of the time: you just need to install dependencies
cd /path/to/your/project
npm install

# If the specific module is missing from package.json
npm install express

# If node_modules exists but is corrupted
rm -rf node_modules package-lock.json
npm install
```

If you're running a script from a different directory than expected:

```bash
# Check where Node is looking
node -e "console.log(module.paths)"

# Run from the project root, not a subdirectory
cd /path/to/project-root && node src/index.js
```

## Don't do this

**Don't install globally to fix a local import.** `npm install -g express` won't help. Your `require('express')` in a project looks for local `node_modules`, not global.

**Don't manually copy `node_modules` between projects.** The dependency tree is project-specific. It will break in subtle ways.

## Still not working?

If the module is a local file (`require('./utils')`), check:

```bash
# Node doesn't auto-resolve .ts files. Be explicit:
require('./utils.js')   # not require('./utils')

# Check for case-sensitivity (Linux is case-sensitive, macOS isn't)
ls -la src/  # Is it Utils.js or utils.js?
```

If you're in a monorepo, the package might be hoisted differently:

```bash
# With npm workspaces
npm install --workspace=packages/your-package

# With pnpm, the module might be in a virtual store
# Make sure your package.json lists the dependency
```
