# Git failed to push some refs

> To github.com:user/repo.git
>  ! [rejected]        main -> main (fetch first)
> error: failed to push some refs to 'git@github.com:user/repo.git'
> hint: Updates were rejected because the remote contains work that you do not
> hint: have locally. Integrate the remote changes (e.g., 'git pull ...') before pushing again.

## What happened

Someone (or you from another machine, or a GitHub merge) pushed commits to the remote branch since your last pull. Your local branch is behind.

## Why it happens

Git won't let you push if the remote has commits your local branch doesn't have. This prevents you from overwriting other people's work. Your local `main` diverged from `origin/main` because the remote moved forward while you were working.

## How to fix it

```bash
# Pull the remote changes, then push
git pull --rebase origin main
git push origin main
```

Using `--rebase` puts your commits on top of the remote's, keeping a clean linear history. Without it, you'll get a merge commit, which is also fine.

```bash
# If you prefer a merge commit instead of rebase
git pull origin main
git push origin main
```

## Don't do this

**Don't `git push --force`.** This overwrites remote history. If anyone else has pulled that branch, their repo is now in a broken state. Only use `--force-with-lease` and only on feature branches you own.

**Don't `git push --force` to `main` or `master`. Ever.** There is almost no scenario where this is the right call.

## Still not working?

If `git pull --rebase` gives you conflicts:

```bash
# Resolve conflicts in the listed files, then
git add <resolved-files>
git rebase --continue

# If the rebase gets messy and you want to start over
git rebase --abort
```

If you're the only person on the project and you genuinely want to overwrite:

```bash
# Safer than --force: fails if someone else pushed since your last fetch
git push --force-with-lease origin main
```

If this keeps happening on a team, your workflow might need a change. Work on feature branches, not directly on main:

```bash
git checkout -b feature/my-change
# ... make commits ...
git push -u origin feature/my-change
# Then open a PR
```
