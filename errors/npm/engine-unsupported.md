# npm ERR! engine Unsupported

> npm ERR! code EBADENGINE
> npm ERR! engine Unsupported engine
> npm ERR! engine Not compatible with your version of node/npm.
> npm ERR! notsup Required: {"node":">=18.0.0"}
> npm ERR! notsup Actual:   {"node":"16.20.2","npm":"8.19.4"}

## What happened

You're trying to install a package (or run `npm install` on a project) that requires a newer version of Node than what you're running.

## Why it happens

The package's `package.json` has an `engines` field specifying minimum Node/npm versions. Your local Node is older than what's required. This started happening more frequently as packages dropped Node 16 support (EOL September 2023) and Node 14 support before that.

## How to fix it

```bash
# Check your current Node version
node -v

# If using nvm, switch to the required version
nvm install 18
nvm use 18

# If using fnm
fnm install 18
fnm use 18

# Verify
node -v
npm -v
```

If the project has a `.nvmrc` or `.node-version` file:

```bash
nvm use     # reads .nvmrc automatically
# or
fnm use     # reads .node-version automatically
```

## Don't do this

**Don't bypass the engine check with `npm install --ignore-engines`.** The package author set that requirement for a reason (uses `fetch()`, `structuredClone()`, or other APIs only in newer Node). It might install but crash at runtime.

**Don't modify the package's `engines` field in `node_modules`.** It'll be overwritten on next install.

## Still not working?

If you can't upgrade Node (legacy project, CI constraints):

```bash
# Find the last version of the package that supports your Node
npm view some-package engines --json
npm view some-package@3 engines --json
npm view some-package@2 engines --json

# Install that specific version
npm install some-package@2
```

If `engines` is set in your own project's `package.json` and you want to relax it:

```json
{
  "engines": {
    "node": ">=16.0.0"
  }
}
```

For CI environments, make sure the Node version in your workflow matches:

```yaml
# GitHub Actions
- uses: actions/setup-node@v4
  with:
    node-version: 18

# Or use the project's .nvmrc
    node-version-file: '.nvmrc'
```
