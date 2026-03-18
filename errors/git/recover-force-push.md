# Recover commits lost to force push

> Force pushed to main and lost commits from coworker

## What happened

Someone ran `git push --force` to a shared branch (usually `main`) and overwrote commits that other people had pushed. Those commits are gone from the remote. The branch now points to the force-pusher's version of history, and the missing commits are not in `git log`.

## Why it happens

`git push --force` replaces the remote branch entirely with your local branch. If your local branch was behind the remote (missing commits others pushed), those commits get erased from the remote. This is especially common when:

- Rebasing a branch and force-pushing without checking if others pushed in the meantime
- Resolving "rejected: non-fast-forward" by reaching for `--force` instead of pulling
- Running `git reset --hard` locally and then force-pushing the result

The commits aren't truly deleted from Git's object store immediately, but they become unreachable and will eventually be garbage-collected.

## How to fix it

**Option 1: Recover from any machine that had the old commits (most reliable)**

On any machine that pulled before the force push, the old commits are still in the reflog:

```bash
# On the coworker's machine (or any machine with the old commits)
git reflog

# Look for the last known good commit on main before the force push
# Output looks like:
# abc1234 HEAD@{2}: pull: Fast-forward    <-- this has the old commits
# def5678 HEAD@{3}: commit: their work

# Push that commit back to the remote
git push origin abc1234:main
```

**Option 2: If you have access to the remote server's reflog (self-hosted Git)**

```bash
# SSH into the Git server
cd /path/to/repo.git
git reflog refs/heads/main

# Find the SHA before the force push
# Then reset the branch
git update-ref refs/heads/main <old-sha>
```

**Option 3: GitHub/GitLab audit log**

On GitHub, check the branch protection audit log or use the Events API:

```bash
# GitHub: check the push events for the branch
gh api repos/OWNER/REPO/events --jq '.[] | select(.type=="PushEvent") | {actor: .actor.login, before: .payload.before, head: .payload.head}'
```

The `before` SHA is the commit the branch pointed to before the force push. If any machine still has it:

```bash
git fetch origin
git push origin <before-sha>:main
```

**Option 4: If the coworker still has their commits locally**

```bash
# On the coworker's machine
git log --oneline main  # their local main still has the commits

# Push their version back
git push --force origin main
```

**After recovery, merge any work from the force-pusher if needed:**

```bash
# Now main has the old commits back
# The force-pusher needs to rebase their work on top
git fetch origin
git rebase origin/main
git push origin main
```

## Don't do this

- Don't just re-create the commits manually. They'll have different SHAs, and anyone who based work on the originals will have merge conflicts. Restore the actual commits.
- Don't panic and run more force pushes. Each one makes recovery harder.
- Don't wait. Git garbage-collects unreachable objects after ~2 weeks (or sooner with `gc.auto`). Recover the commits as soon as possible.

## Still not working?

Prevent this from happening again:

```bash
# Use --force-with-lease instead of --force
# It fails if the remote has commits you haven't seen
git push --force-with-lease origin main

# On GitHub/GitLab, enable branch protection on main
# - Require pull request reviews
# - Disallow force pushes
# - Require linear history (optional)
```

Set up a Git alias to make `--force-with-lease` the default:

```bash
git config --global alias.pushf "push --force-with-lease"
```

If all local copies are gone and the remote has been garbage-collected, the commits are unrecoverable. GitHub retains unreachable objects for longer than self-hosted Git, so contact GitHub support quickly if needed.
