# Git submodule reference is not a tree

> fatal: reference is not a tree: abc123

## What happened
Git cannot checkout the submodule because the commit referenced by the superproject does not exist in the submodule's repository.

## Why it happens
The superproject records a specific commit hash for each submodule. If someone updated the submodule to point to a commit that was never pushed to the submodule's remote (e.g., committed locally, force-pushed away, or from a branch that was deleted), other developers will get this error when trying to update the submodule. The recorded commit simply does not exist in the remote repository.

## How to fix it

First, check which commit the superproject expects:
```bash
git ls-tree HEAD path/to/submodule
# Shows the recorded commit hash
```

If the commit was not pushed, the original developer needs to push it:
```bash
# In the submodule directory
cd path/to/submodule
git push origin HEAD
```

If you need to update the submodule to a commit that exists:
```bash
cd path/to/submodule
git fetch origin
git log --oneline origin/main -5  # find a valid commit

# Switch to a valid commit
git checkout origin/main

# Go back to the superproject and update the reference
cd ..
git add path/to/submodule
git commit -m "Update submodule to valid commit"
```

Update all submodules recursively:
```bash
git submodule update --init --recursive
```

## Still not working?
- If the submodule remote URL changed, update it: `git submodule set-url path/to/submodule https://new-url.git`.
- Check if the submodule was force-pushed and the commit was rewritten: `cd path/to/submodule && git fsck --unreachable`.
- If you do not need the submodule at a specific commit, reset it to the latest: `cd path/to/submodule && git checkout main && cd .. && git add path/to/submodule`.
- Run `git submodule sync` to update the submodule URLs from `.gitmodules` if they are out of sync.
