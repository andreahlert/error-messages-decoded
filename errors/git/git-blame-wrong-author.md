# Git blame shows wrong author after bulk formatting

> git blame shows wrong author for all lines in a file

## What happened
`git blame` attributes every line in a file to the author of a bulk formatting commit (e.g., Prettier, Black, gofmt) instead of the original author who wrote the logic.

## Why it happens
When a code formatter reformats an entire file, `git blame` sees every line as changed in that commit. The original authors are hidden behind the formatting commit. This makes `git blame` useless for understanding who actually wrote the code.

## How to fix it

Create a `.git-blame-ignore-revs` file in the repository root:
```bash
# .git-blame-ignore-revs
# Prettier formatting migration
abc123def456789abc123def456789abc123def4
# Black formatter applied
789def456abc123def456789abc123def456789a
```

Tell Git to use it:
```bash
# Configure it globally for this repo
git config blame.ignoreRevsFile .git-blame-ignore-revs

# Or use it per-command
git blame --ignore-revs-file .git-blame-ignore-revs src/main.py
```

Ignore a specific revision inline:
```bash
git blame --ignore-rev abc123def456789abc123def456789abc123def4 src/main.py
```

Commit the ignore file to the repository so the whole team benefits:
```bash
git add .git-blame-ignore-revs
git commit -m "Add git-blame-ignore-revs for formatter commits"
```

## Still not working?
- GitHub automatically reads `.git-blame-ignore-revs` in the blame UI (since 2022).
- If using VS Code, the GitLens extension also respects `blame.ignoreRevsFile`.
- You can add multiple revisions to the file over time as you apply new bulk formatting changes.
- For already-committed formatting changes, find the commit hash with: `git log --all --oneline -- path/to/file`.
