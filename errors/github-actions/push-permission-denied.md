# Permission denied to push from GitHub Actions

> Permission to org/repo.git denied to github-actions[bot]
> remote: Permission to org/repo.git denied to github-actions[bot].
> fatal: unable to access 'https://github.com/org/repo.git/': The requested URL returned error: 403

## What happened

Your GitHub Actions workflow tried to push to a repository but the `GITHUB_TOKEN` doesn't have the required permissions. The push was rejected.

## Why it happens

The automatic `GITHUB_TOKEN` has limitations:

- By default, it has **read-only** permissions in workflows triggered by pull requests from forks
- It only has access to the **current repository**, not other repos in the organization
- Its default permissions depend on the repository or organization settings (may be read-only by default)
- It **cannot** trigger other workflows when it pushes (to prevent infinite loops)
- Fine-grained permissions must be explicitly declared in the workflow file

## How to fix it

**For pushing to the same repository, set explicit permissions:**

```yaml
# .github/workflows/my-workflow.yml
name: Auto-commit
on: push

permissions:
  contents: write  # required for git push

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Make changes
        run: |
          echo "update" >> file.txt

      - name: Commit and push
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add .
          git commit -m "Auto-update"
          git push
```

**If the organization restricts the default GITHUB_TOKEN permissions:**

Go to **Organization Settings > Actions > General > Workflow permissions** and select "Read and write permissions". Or set it per-repo under **Repository Settings > Actions > General**.

**For pushing to a different repository, use a PAT or deploy key:**

```yaml
jobs:
  push-to-other-repo:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          repository: org/other-repo
          token: ${{ secrets.PAT_TOKEN }}  # PAT with repo access

      - name: Push changes
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          echo "change" >> file.txt
          git add .
          git commit -m "Cross-repo update"
          git push
```

Create the PAT: **GitHub > Settings > Developer settings > Personal access tokens > Fine-grained tokens**. Give it `contents: write` on the target repo. Store it as a repository secret.

**For pushing to the same repo but triggering other workflows:**

```yaml
steps:
  - uses: actions/checkout@v4
    with:
      token: ${{ secrets.PAT_TOKEN }}  # PAT instead of GITHUB_TOKEN
      # Pushes with a PAT DO trigger other workflows
```

**Using a deploy key (no personal account needed):**

```bash
# Generate a key pair
ssh-keygen -t ed25519 -C "deploy-key" -f deploy_key -N ""
```

Add the public key as a deploy key (with write access) on the target repo. Add the private key as a secret on the source repo.

```yaml
steps:
  - uses: actions/checkout@v4
    with:
      repository: org/other-repo
      ssh-key: ${{ secrets.DEPLOY_KEY }}
```

## Don't do this

- Don't assume `GITHUB_TOKEN` works across repositories. It is scoped to the repo running the workflow, always.
- Don't use a PAT from a personal account for org-critical workflows. Use a machine user account or GitHub App instead. If that person leaves, the token dies.
- Don't set `permissions: write-all` at the workflow level. Follow least privilege and declare only what you need.

## Still not working?

Check the exact permissions your token has:

```yaml
steps:
  - name: Debug token permissions
    run: |
      curl -s -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
        https://api.github.com/repos/${{ github.repository }} | \
        jq '.permissions'
```

If pushing to a branch protected by branch protection rules, `GITHUB_TOKEN` cannot bypass them. You need a PAT from an admin, or use a GitHub App token with bypass permissions.

For GitHub Apps (recommended for org-level automation):

```yaml
steps:
  - uses: actions/create-github-app-token@v1
    id: app-token
    with:
      app-id: ${{ secrets.APP_ID }}
      private-key: ${{ secrets.APP_PRIVATE_KEY }}

  - uses: actions/checkout@v4
    with:
      token: ${{ steps.app-token.outputs.token }}
```
