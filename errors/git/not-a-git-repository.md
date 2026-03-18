# fatal: not a git repository

> fatal: not a git repository (or any of the parent directories): .git

## What happened

You ran a git command in a directory that isn't inside a git repository. There's no `.git` folder here or in any parent directory.

## Why it happens

You're in the wrong directory. Or you haven't initialized git yet. Or you extracted a zip download of a repo (GitHub's "Download ZIP" doesn't include the `.git` folder). Git walks up the directory tree looking for `.git/`. If it reaches `/` without finding one, you get this error.

## How to fix it

```bash
# Check where you are
pwd

# Navigate to your project
cd /path/to/your/project

# Verify it's a git repo
ls -la .git/

# If the project exists but wasn't initialized as a git repo
git init
git add .
git commit -m "Initial commit"
```

If you downloaded a ZIP from GitHub instead of cloning:

```bash
# Delete the extracted folder and clone properly
git clone https://github.com/user/repo.git
cd repo
```

## Don't do this

**Don't run `git init` in your home directory or `/`.** You'll create a massive repo that tracks everything. If you accidentally did this:

```bash
# Check if there's an accidental .git in your home
ls -la ~/.git

# Remove it if it shouldn't be there
rm -rf ~/.git
```

**Don't create nested git repos** by running `git init` inside an existing git project's subdirectory. That creates a submodule-like situation that's confusing to deal with.

## Still not working?

If `.git` exists but git still complains:

```bash
# The .git directory might be corrupted
ls -la .git/

# If HEAD is missing or broken
cat .git/HEAD
# Should show: ref: refs/heads/main

# If the repo is corrupted, re-clone
cd ..
mv broken-repo broken-repo-backup
git clone https://github.com/user/repo.git
```

If you're inside a git worktree, the `.git` is a file (not a directory) pointing elsewhere:

```bash
cat .git
# gitdir: /path/to/main-repo/.git/worktrees/branch-name
```

In CI/CD, make sure the checkout step ran before your git commands:

```yaml
# GitHub Actions - this step creates .git
- uses: actions/checkout@v4
```
