# Git divergent branches reconciliation hint

> hint: You have divergent branches and need to specify how to reconcile them.
> hint: You can do so by running one of the following commands sometime before
> hint: your next pull:
> hint:
> hint:   git config pull.rebase false  # merge
> hint:   git config pull.rebase true   # rebase
> hint:   git config pull.ff only       # fast-forward only
> hint:
> fatal: Need to specify how to reconcile divergent branches.

## What happened

You ran `git pull` and Git doesn't know whether you want to merge or rebase the incoming changes. This message was added in Git 2.27 to force you to make a conscious decision.

## Why it happens

Before Git 2.27, `git pull` defaulted to merge. The Git maintainers decided that implicit merges create noisy histories and developers should explicitly choose their strategy. If you haven't configured `pull.rebase` or `pull.ff`, Git now refuses to proceed and asks you to pick.

## How to fix it

Pick a strategy. For most developers, rebase is the cleanest:

```bash
# Set rebase as default pull strategy (recommended for most workflows)
git config --global pull.rebase true

# Now this works
git pull origin main
```

Other options:

```bash
# Merge (creates merge commits, keeps exact branch history)
git config --global pull.rebase false

# Fast-forward only (fails if branches diverged, safest but strictest)
git config --global pull.ff only
```

For a one-time fix without changing config:

```bash
git pull --rebase origin main
# or
git pull --no-rebase origin main
```

## Don't do this

**Don't set `pull.ff only` if you work on a team** and don't rebase regularly. You'll get this error on every pull when the branch has diverged, and you'll have to manually rebase anyway.

**Don't overthink this.** If you're unsure, `pull.rebase true` is the most common choice. It keeps your history linear and avoids "Merge branch 'main' into main" noise.

## Still not working?

If you set rebase and now have conflicts on every pull:

```bash
# Your local commits conflict with remote changes
# Resolve each conflict, then:
git add <file>
git rebase --continue

# To abort and go back to before the pull
git rebase --abort
```

If you want different strategies per repo:

```bash
# Global default: rebase
git config --global pull.rebase true

# This one repo: merge (because the team prefers it)
cd /path/to/repo
git config pull.rebase false
```

For a team, agree on one strategy and document it. Add it to the project's contributing guide. Nothing wastes more time than merge vs rebase debates on every PR.
