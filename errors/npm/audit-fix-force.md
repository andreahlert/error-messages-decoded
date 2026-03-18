# npm audit fix --force breaks everything

> npm WARN using --force Recommended protections disabled.
> npm WARN audit Updating react-scripts to 3.0.1, which is a SemVer major change.
> added 125 packages, removed 412 packages, changed 387 packages, and audited 1289 packages
>
> 12 vulnerabilities (5 moderate, 4 high, 3 critical)

## What happened

You ran `npm audit`, saw scary vulnerability numbers, ran `npm audit fix --force`, and now your project is broken. Dependencies were downgraded or upgraded across major versions and things no longer work together.

## Why it happens

`npm audit fix` without `--force` only applies safe, semver-compatible patches. The `--force` flag lets npm make breaking changes: major version bumps, replacing packages with different ones, whatever it takes to resolve the audit findings. This regularly breaks build tools, frameworks, and anything with tight version coupling. And ironically, it often doesn't even fix all the vulnerabilities.

## How to fix it

Roll back the damage first:

```bash
# If you have a clean git state before the --force
git checkout -- package.json package-lock.json
rm -rf node_modules
npm install

# If you don't have git history, restore from lockfile
# (Hopefully you committed package-lock.json before this)
```

Then handle the audit properly:

```bash
# See what's actually vulnerable
npm audit

# Apply only safe, non-breaking fixes
npm audit fix

# For remaining vulnerabilities, check if they actually affect you
# Most audit findings are in dev dependencies or unreachable code paths
```

## Don't do this

**Never run `npm audit fix --force` on a project you need to work.** The `--force` flag is not "try harder." It's "break things if necessary."

**Don't chase zero vulnerabilities at all costs.** A "critical" vulnerability in a dev-only test utility doesn't affect your production users. Read the advisory, check if the vulnerable code path is reachable in your usage.

**Don't run `npm audit fix` in CI/CD.** Audit should inform, not modify. Use `npm audit --audit-level=critical` as a gate, not `fix`.

## Still not working?

For vulnerabilities in transitive dependencies you can't control:

```json
// package.json - force a specific version of a nested dep
{
  "overrides": {
    "vulnerable-package": "2.0.1"
  }
}
```

For `npm audit` findings that are false positives or won't-fix in dev deps:

```bash
# Audit only production dependencies
npm audit --omit=dev
```

If your project was wrecked by `--force` and you have no git history, compare your `package.json` with the project's template or documentation to restore the correct versions manually. Then lock them down:

```bash
# After restoring correct versions
npm install
npm audit  # accept the remaining findings if they're in dev deps
```
