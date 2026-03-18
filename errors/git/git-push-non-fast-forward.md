# Git push rejected non-fast-forward

> ! [rejected] main -> main (non-fast-forward)

## What happened
Git refused to push because the remote branch has commits that your local branch does not have. Pushing would overwrite those commits.

## Why it happens
Someone else pushed commits to the remote branch after you last fetched. Your local branch has diverged from the remote, meaning there are commits on both sides that the other does not have. Git rejects the push to prevent you from accidentally overwriting the other person's work.

## How to fix it

Fetch and rebase your changes on top of the remote:
```bash
git fetch origin
git rebase origin/main
# Resolve any conflicts, then:
git push origin main
```

Or use pull with rebase in one command:
```bash
git pull --rebase origin main
git push origin main
```

If you want to preserve a merge commit instead:
```bash
git pull origin main
# This creates a merge commit
git push origin main
```

If you are certain you want to overwrite the remote (use with caution):
```bash
# Safe force push - only overwrites if no one else pushed since your last fetch
git push --force-with-lease origin main
```

## Still not working?
- If rebase produces conflicts, resolve them one commit at a time: fix the file, `git add`, then `git rebase --continue`.
- Check what the remote has that you do not: `git log HEAD..origin/main --oneline`.
- If working on a feature branch (not main), `git push --force-with-lease` is generally safe.
- Set up your default pull strategy: `git config --global pull.rebase true` to avoid accidental merge commits.
