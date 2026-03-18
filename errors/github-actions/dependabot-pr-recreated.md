# Dependabot PR keeps getting recreated after merge

> Dependabot PR keeps getting recreated after merge

## What happened
After merging a Dependabot pull request, the same PR (or one for the same dependency update) gets recreated shortly after.

## Why it happens
This typically happens when the Dependabot PR targets a non-default branch, or when the merged PR gets rebased/squashed in a way that Dependabot does not recognize as merged. Dependabot checks the default branch for the dependency version. If the merge did not land on the default branch, or if automerge combined multiple updates and Dependabot's schedule triggers before the base branch is updated, it recreates the PR.

## How to fix it

Ensure Dependabot targets the correct base branch in `.github/dependabot.yml`:
```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    target-branch: "main"  # must be your default branch
```

Use grouping to reduce PR noise:
```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      dev-dependencies:
        dependency-type: "development"
      production:
        dependency-type: "production"
```

If you want to ignore a specific dependency update:
```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    ignore:
      - dependency-name: "some-package"
        versions: [">=2.0.0"]
```

Make sure your merge strategy preserves the version change:
```yaml
# If using rebase or squash merge, the dependency version must
# end up in the default branch's package.json/lock file
```

## Still not working?
- Check if the lock file was properly updated after merge: `git diff main -- package-lock.json`.
- If using automerge, ensure it waits for CI to pass before merging. Failed CI can leave the PR in a limbo state.
- Comment `@dependabot ignore this dependency` on the PR to permanently ignore that specific update.
- Check the Dependabot logs: Settings > Code security > Dependabot > View logs for recent jobs.
