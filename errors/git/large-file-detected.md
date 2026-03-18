# GitHub large file size limit exceeded

> remote: error: Trace: abc123def456
> remote: error: See https://gh.io/lfs for more information.
> remote: error: File data/model.bin is 150.00 MB; this exceeds GitHub's file size limit of 100.00 MB
> remote: error: GH001: Large files detected. You may want to try Git Large File Storage.
> To github.com:user/repo.git
>  ! [remote rejected] main -> main (pre-receive hook declined)

## What happened

You committed a file larger than 100MB and tried to push to GitHub. GitHub rejected the push.

## Why it happens

GitHub has a hard 100MB per-file limit. The file is already in your commit history. Even if you delete the file and commit again, the old commit still contains it. Git stores the full history, so the large file is still in the pack that gets pushed.

## How to fix it

**If the large file is in your last commit:**

```bash
# Remove it from the last commit (keeps the file on disk)
git rm --cached data/model.bin
echo "data/model.bin" >> .gitignore
git commit --amend --no-edit

git push origin main
```

**If the large file is in an older commit:**

```bash
# Rewrite history to remove the file from ALL commits
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch data/model.bin' \
  --prune-empty --tag-name-filter cat -- --all

# Force push (required after rewriting history)
git push origin main --force-with-lease
```

Or use the faster `git-filter-repo` tool:

```bash
pip install git-filter-repo
git filter-repo --invert-paths --path data/model.bin
git remote add origin git@github.com:user/repo.git
git push origin main --force-with-lease
```

## Don't do this

**Don't just delete the file and make a new commit.** This is the #1 trap. The file is still in your git history, and git pushes the entire history. Deleting it and committing only adds a *new* commit that removes the file. The old commit with the 150MB file is still there. You MUST rewrite history with `git filter-branch`, `git filter-repo`, or `git rebase -i` + `git rm --cached` to actually remove it from the commit that introduced it.

**Don't increase the Git buffer size** (`http.postBuffer`). That's for upload chunking, not for GitHub's file size policy.

**Don't split the file into parts to reassemble later.** That's a hack. Use Git LFS if the file belongs in the repo.

## Still not working?

If you need large files in the repo, use Git LFS:

```bash
# Install Git LFS
git lfs install

# Track the file type
git lfs track "*.bin"
git lfs track "*.h5"
git lfs track "*.pkl"

# Make sure .gitattributes is committed
git add .gitattributes
git add data/model.bin
git commit -m "Add model with LFS tracking"
git push origin main
```

If the large file was pushed to multiple branches, clean all of them:

```bash
git filter-repo --invert-paths --path data/model.bin
# This cleans all branches and tags at once
```

Add large files to `.gitignore` before they get committed:

```bash
# .gitignore - prevent future accidents
*.bin
*.h5
*.pkl
*.tar.gz
data/models/
```

GitHub's limits: 100MB per file hard limit, 50MB warning. Total repo size soft limit is around 5GB. Git LFS has separate storage limits based on your plan.
