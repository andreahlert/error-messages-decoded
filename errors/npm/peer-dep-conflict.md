# npm peer dependency conflict

> npm ERR! code ERESOLVE
> npm ERR! ERESOLVE could not resolve
> npm ERR!
> npm ERR! While resolving: @angular/compiler-cli@16.2.0
> npm ERR! Found: typescript@5.3.3
> npm ERR! node_modules/typescript
> npm ERR!
> npm ERR! Could not resolve dependency:
> npm ERR! peer typescript@">=5.0 <5.3" from @angular/compiler-cli@16.2.0
> npm ERR! Fix the upstream dependency conflict, or retry
> npm ERR! this command with --force or --legacy-peer-deps

## What happened

You're installing a package and its peer dependency requirement conflicts with what you already have (or what another package needs). Different from ERESOLVE in that this is usually one specific package pair you can identify and fix.

## Why it happens

The package you're installing declares it needs a specific version range of a peer dependency, and you have a version outside that range. In the example above, Angular 16 needs TypeScript <5.3 but you have 5.3.3 installed. This is npm being strict about what the package author said they tested against.

## How to fix it

First, understand the conflict. Read the error. It tells you exactly what version is expected and what you have.

```bash
# If the newer version of the tool supports your dependency
npm install @angular/compiler-cli@latest

# If you need to downgrade the conflicting dependency
npm install typescript@5.2

# If you know it works despite the version mismatch (common with TypeScript)
npm install --legacy-peer-deps
```

For TypeScript specifically, many packages lag behind TS releases. It usually works fine to override:

```json
{
  "overrides": {
    "@angular/compiler-cli": {
      "typescript": "$typescript"
    }
  }
}
```

## Don't do this

**Don't install both versions side by side with aliases** unless you really know what you're doing. Two versions of TypeScript or React in the same project causes bizarre bugs.

**Don't remove the peer dep requirement by patching `node_modules`.** It'll come back on next install and you'll forget why things broke.

## Still not working?

Check compatibility matrices. Frameworks like Angular, Next.js, and Nx publish which versions of TypeScript, React, etc. they support:

```bash
# See what a package expects
npm info @angular/compiler-cli@16 peerDependencies
npm info @angular/compiler-cli@17 peerDependencies
```

If two packages need mutually exclusive versions of the same peer dep, one of them needs to be replaced. There's no workaround for genuinely incompatible packages.

For yarn users, `yarn install` is more lenient with peer deps by default. pnpm uses `pnpm install --no-strict-peer-dependencies`.
