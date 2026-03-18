# npm deprecated warnings failing CI builds

> npm WARN deprecated inflight@1.0.6: This module is not supported, and leaks memory.
> npm WARN deprecated glob@7.2.3: Glob versions prior to v9 are no longer supported

## What happened
CI builds fail or produce noise because npm prints deprecation warnings for transitive dependencies you don't directly control.

## Why it happens
Transitive dependencies deep in the dependency tree use deprecated packages. You cannot directly upgrade them, and `npm audit` flags them. Some CI pipelines treat any stderr output or audit findings as failures.

## How to fix it
```bash
# Suppress audit during install in CI
npm ci --no-audit

# Set audit level to only fail on high/critical
npm audit --audit-level=high

# Override transitive dependencies in package.json
# "overrides": {
#   "glob": "^10.0.0",
#   "inflight": "npm:inflight-replacement@1.0.0"
# }
```

```json
// package.json - use overrides to pin newer versions
{
  "overrides": {
    "glob": "^10.0.0"
  }
}
```

## Still not working?
For yarn, use `resolutions` instead of `overrides`. If the deprecated package is deeply nested and cannot be overridden, use `npm-force-resolutions` package. Check if the parent dependency has a newer version that dropped the deprecated transitive dependency with `npm outdated`.
