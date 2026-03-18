# Git refusing to merge unrelated histories

> fatal: refusing to merge unrelated histories

## What happened

You ran `git pull` or `git merge` and Git rejected it because the two branches share no common ancestor. They look like completely separate repositories to Git.

## Why it happens

The most common scenario: you created a repo on GitHub with a README/license, then initialized a separate local repo with `git init` and tried to pull the remote. These are two independent histories with no shared commit. Git won't merge them automatically because it doesn't know how to reconcile two trees that were never related. This also happens when you `git filter-branch` or `git rebase --root` a repo's history.

## How to fix it

```bash
# Allow the merge of unrelated histories
git pull origin main --allow-unrelated-histories

# If there are conflicts, resolve them normally
git add .
git commit -m "Merge remote history into local project"
```

The better approach for new projects is to avoid this entirely:

```bash
# DON'T create a README on GitHub if you already have local files
# Instead:
git init
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:user/repo.git
git push -u origin main
```

## Don't do this

**Don't force push your local to overwrite the remote.** `git push --force` will destroy the README/license commit and anyone else's work on the remote.

**Don't delete the remote repo and recreate it** just to avoid this merge. The `--allow-unrelated-histories` flag exists for exactly this case.

## Still not working?

If you get merge conflicts after `--allow-unrelated-histories`:

```bash
# Check what's conflicting
git status

# Usually it's README.md or LICENSE - pick the version you want
git checkout --theirs README.md   # keep remote version
# or
git checkout --ours README.md     # keep local version

git add README.md
git commit
```

If this is happening with submodules or subtree merges, the fix is different:

```bash
# For subtree merge
git merge --allow-unrelated-histories subtree-branch
git read-tree --prefix=lib/ -u subtree-branch
```
