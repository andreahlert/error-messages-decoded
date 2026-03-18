# Git detached HEAD state

> You are in 'detached HEAD' state. You can look around, make experimental
> changes and commit them, and you can discard any commits you make in this
> state without impacting any branches by switching back to a branch.
>
> If you want to create a new branch to retain commits you create, you may
> do so (now or later) by using -c with the switch command. Example:
>
>   git switch -c <new-branch-name>
>
> HEAD is now at a1b2c3d Some commit message

## What happened

You checked out a specific commit, tag, or remote branch directly instead of a local branch. Git is warning you that you're not "on" any branch.

## Why it happens

This happens when you run `git checkout <commit-hash>`, `git checkout v1.2.3`, or `git checkout origin/main` (instead of `git checkout main`). HEAD normally points to a branch name, which moves forward when you commit. In detached HEAD, HEAD points directly to a commit. If you make new commits here and switch branches, those commits become orphaned and eventually garbage collected.

## How to fix it

If you just want to go back to a branch (no changes made):

```bash
git checkout main
# or
git switch main
```

If you made commits in detached HEAD and want to keep them:

```bash
# Create a branch from where you are right now
git switch -c my-new-branch

# Your commits are now safe on this branch
git log --oneline -5  # verify your commits are here
```

If you already switched away and lost commits:

```bash
# Find the orphaned commits
git reflog

# Look for your commits, note the hash, then
git checkout <commit-hash>
git switch -c recovered-work
```

## Don't do this

**Don't switch branches without creating a branch first if you've made commits.** This is the trap. If you commit work in detached HEAD and then run `git checkout main`, your commits become orphaned. Git will garbage-collect them (default: 30 days via reflog, then gone). You won't get a warning when switching. The commits just silently become unreachable. Always run `git switch -c my-branch` before switching away.

**Don't panic and force-checkout a branch.** If you have uncommitted changes in detached HEAD, `git checkout main` might refuse (which is good) or might discard them.

**Don't ignore the warning and keep working.** Make a branch first. Commits in detached HEAD are real commits, but they'll be garbage collected if nothing references them.

## Still not working?

If you entered detached HEAD from a `git rebase` or `git bisect`:

```bash
# If you're in a rebase
git rebase --abort

# If you're in a bisect
git bisect reset
```

If you keep accidentally detaching HEAD when checking out remote branches:

```bash
# WRONG - detaches HEAD
git checkout origin/feature

# RIGHT - creates/switches to local tracking branch
git checkout feature
# or
git switch feature
```

In CI/CD, detached HEAD is normal and expected. GitHub Actions checks out a specific commit, not a branch. If your script needs the branch name:

```bash
# In GitHub Actions
echo $GITHUB_REF_NAME

# In generic CI
git branch --show-current  # empty in detached HEAD
git rev-parse HEAD          # use the commit hash instead
```
