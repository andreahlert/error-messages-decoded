# No matching version found for package

> npm ERR! code ETARGET
> npm ERR! notarget No matching version found for @company/ui-components@3.2.1.
> npm ERR! notarget In most cases you or one of your dependencies are requesting
> npm ERR! notarget a package version that doesn't exist.
> npm ERR! notarget
> npm ERR! notarget It was specified as a dependency of 'my-app'

## What happened

npm can't find the exact version of a package you're requesting. The version either doesn't exist, was unpublished, or you're looking at the wrong registry.

## Why it happens

Several possible reasons. The version was typo'd in `package.json`. The package was unpublished from npm (rare but it happens). You're using a private/scoped package and npm is looking at the public registry instead of your company's private one. Or the lockfile references a version that existed when your coworker installed but has since been removed.

## How to fix it

```bash
# Check what versions actually exist
npm view @company/ui-components versions --json

# If the version was wrong in package.json, update it
npm install @company/ui-components@latest

# If it's a lockfile issue, regenerate it
rm package-lock.json
npm install
```

If it's a scoped/private package pointing to the wrong registry:

```bash
# Check where npm is looking for this scope
npm config get @company:registry

# Set the correct private registry for the scope
npm config set @company:registry https://npm.company.com/

# Or in .npmrc (project-level, commit this to repo)
echo "@company:registry=https://npm.company.com/" >> .npmrc
```

## Don't do this

**Don't just remove the package from `package.json` without understanding why.** If it's a dependency your code uses, you'll get runtime errors instead.

**Don't blindly install `@latest` if your code depends on v3 APIs.** Check the changelog for breaking changes first.

## Still not working?

If the package was genuinely unpublished (npm allows unpublish within 72 hours):

```bash
# Check if the package exists at all
npm view @company/ui-components

# If it 404s, the package was removed entirely
# You need to find an alternative or host it yourself
```

If you're behind a corporate proxy or using a mirror, it might be stale:

```bash
# Check your registry
npm config get registry

# Try the official registry directly
npm install --registry https://registry.npmjs.org/
```

If a transitive dependency is requesting the phantom version, use overrides:

```json
{
  "overrides": {
    "@company/ui-components": "3.2.0"
  }
}
```

Check if the package moved to a different name (common with org transfers):

```bash
npm view old-package-name
# "This package has been moved to @new-scope/package-name"
```
