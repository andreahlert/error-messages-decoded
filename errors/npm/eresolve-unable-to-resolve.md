# ERESOLVE unable to resolve dependency tree

> npm ERR! code ERESOLVE
> npm ERR! ERESOLVE unable to resolve dependency tree
> npm ERR!
> npm ERR! While resolving: my-app@1.0.0
> npm ERR! Found: react@18.2.0
> npm ERR! node_modules/react
> npm ERR!   react@"^18.2.0" from the root project
> npm ERR!
> npm ERR! Could not resolve dependency:
> npm ERR! peer react@"^16.8.0 || ^17.0.0" from some-library@2.3.4
> npm ERR! node_modules/some-library

## What happened

You ran `npm install` and npm can't figure out a version combination that satisfies all packages. Two or more dependencies want incompatible versions of the same package.

## Why it happens

npm 7+ enforces peer dependency requirements strictly (npm 6 just warned). A package in your tree declares a `peerDependency` on, say, React 16 or 17, but you have React 18 installed. npm refuses to install because it can't guarantee things will work. The error output shows you exactly which packages conflict.

## How to fix it

```bash
# Option 1: Install with --legacy-peer-deps (skips peer dep checks, like npm 6)
npm install --legacy-peer-deps

# Option 2: Force install (also resolves conflicts, more aggressive)
npm install --force
```

To make it permanent so you don't pass the flag every time:

```bash
# Set for this project only
echo "legacy-peer-deps=true" >> .npmrc

# Or globally
npm config set legacy-peer-deps true
```

The **better** fix is to update the conflicting package:

```bash
# Check if there's a newer version that supports your React version
npm info some-library peerDependencies

# Update the library
npm install some-library@latest
```

## Don't do this

**Don't blindly run `npm install --force` without reading the error.** If the peer dep conflict is real (e.g., library genuinely doesn't work with React 18), forcing the install means runtime crashes. `--force` silences npm but doesn't fix incompatibilities. Your app will break at runtime instead of install time, which is harder to debug. Read the conflict tree npm prints, then decide whether the peer dep declaration is just outdated (safe to override) or reflects a genuine API incompatibility (not safe).

**Don't delete `package-lock.json` as a first resort.** That changes every dependency version, not just the conflicting one. You might introduce other bugs.

**Don't add `--force` or `--legacy-peer-deps` to CI scripts "to make it work."** That masks real dependency conflicts that will eventually cause production bugs. Prefer `--legacy-peer-deps` over `--force` if you must, since it's less aggressive.

## Still not working?

Check if the package has a version compatible with your stack:

```bash
# See all available versions
npm view some-library versions --json

# See what peer deps each version requires
npm info some-library@3.0.0 peerDependencies
```

In a monorepo, use npm overrides to force a version:

```json
{
  "overrides": {
    "some-library": {
      "react": "$react"
    }
  }
}
```

This tells npm "use whatever React version the root project has" instead of what the library asks for.

If you're stuck on npm 7/8 and this is constant pain, consider pnpm, which handles peer deps more gracefully by default.
