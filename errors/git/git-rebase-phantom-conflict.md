# Git rebase phantom merge conflict

> CONFLICT (content): Merge conflict in file.txt

## What happened
During a rebase, Git reports merge conflicts in files that do not seem to have actual conflicting changes. The conflicts appear "phantom" because the same file was renamed or moved on one branch but not the other.

## Why it happens
Git tracks content, not files. During a rebase, if a file was renamed on one branch but modified (under the old name) on another, Git may fail to detect the rename and report it as a content conflict on the old path. This is especially common when files are both renamed and modified in the same commit.

## How to fix it

Check if any files were renamed:
```bash
git diff --name-status main...HEAD
```

Use a merge strategy that handles renames better:
```bash
git rebase main --strategy-option=rename-threshold=30
```

Enable rerere (reuse recorded resolution) to automatically resolve recurring conflicts:
```bash
git config --global rerere.enabled true
```

If you want to accept one side entirely for specific files:
```bash
# Accept the version from the branch being rebased onto (main)
git checkout --theirs file.txt
git add file.txt
git rebase --continue

# Or accept your version
git checkout --ours file.txt
git add file.txt
git rebase --continue
```

## Still not working?
- Use `git log --follow --diff-filter=R -- file.txt` to trace renames across history.
- If conflicts keep recurring, consider using `git merge` instead of `git rebase` for branches with heavy file renames.
- Try `git rebase --merge` which uses a different merge backend that sometimes handles renames better.
- If the conflict is in a generated file (lock files, build artifacts), consider adding it to `.gitattributes` with a merge strategy: `package-lock.json merge=ours`.
