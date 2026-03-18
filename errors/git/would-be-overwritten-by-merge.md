# Local changes would be overwritten by merge

> error: Your local changes to the following files would be overwritten by merge:
>         src/config.ts
>         src/utils/helpers.ts
> Please commit your changes or stash them before you merge.
> Aborting

## What happened

You ran `git pull`, `git merge`, or `git checkout` and you have uncommitted changes in files that the incoming operation needs to modify. Git won't overwrite your work.

## Why it happens

Git is protecting you. The files listed have local modifications that conflict with the incoming changes. If Git proceeded, your work would be lost. This is Git doing exactly the right thing.

## How to fix it

**Option 1: Stash your changes** (you want to keep your work and also pull)

```bash
git stash
git pull origin main
git stash pop

# If stash pop has conflicts, resolve them
git add <files>
```

**Option 2: Commit your changes first** (your work is ready to save)

```bash
git add src/config.ts src/utils/helpers.ts
git commit -m "WIP: save local changes before merge"
git pull origin main
```

**Option 3: Discard your local changes** (you don't need them)

```bash
# Discard changes in specific files
git checkout -- src/config.ts src/utils/helpers.ts

# Then pull
git pull origin main
```

## Don't do this

**Don't `git checkout .` or `git restore .` without checking what you're throwing away.** Review your changes first with `git diff`.

**Don't `git stash` and then forget about it.** Run `git stash list` periodically. Stashes pile up and become impossible to identify.

## Still not working?

If the error mentions untracked files (not modified files):

```bash
# The incoming branch has files that exist locally but aren't tracked
# Either delete them or add them to .gitignore
rm src/config.generated.ts
git pull origin main
```

If `git stash pop` gives you conflicts:

```bash
# Resolve the conflicts manually, then
git add <resolved-files>
git stash drop   # remove the stash entry since pop didn't clean it up
```

If you keep hitting this on generated files (build artifacts, lock files):

```bash
# Add them to .gitignore so this stops happening
echo "dist/" >> .gitignore
echo "*.generated.ts" >> .gitignore
git add .gitignore
git commit -m "Ignore generated files"
```
