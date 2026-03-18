# GitHub Actions resource not accessible by integration

> Resource not accessible by integration

## What happened
A GitHub Actions workflow step tried to access a GitHub API resource (creating a comment, updating a PR, pushing to a branch) but the workflow token does not have sufficient permissions.

## Why it happens
Since February 2023, new repositories default to a read-only `GITHUB_TOKEN`. If your workflow needs to write to pull requests, create issues, push commits, or perform other write operations, you must explicitly grant those permissions in the workflow file.

## How to fix it

Add explicit permissions to your workflow file:
```yaml
# .github/workflows/ci.yml
name: CI

permissions:
  contents: write        # for pushing commits or tags
  pull-requests: write   # for commenting on PRs
  issues: write          # for creating/updating issues

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # ...
```

You can also set permissions at the job level:
```yaml
jobs:
  comment:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      - name: Comment on PR
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: 'Build passed!'
            })
```

Check your repository settings:
```
Settings → Actions → General → Workflow permissions
→ Select "Read and write permissions"
```

## Still not working?
- For workflows triggered by `pull_request` from forks, the token always has read-only access for security. Use `pull_request_target` if you need write access (but be careful with untrusted code).
- If using a reusable workflow, permissions must be declared in the calling workflow, not the reusable one.
- Check that the specific permission you need is listed: `packages: write` for GHCR, `deployments: write` for deployments, `id-token: write` for OIDC.
