# GitHub Actions OOM but works locally

> FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory

## What happened
A Node.js build or test step runs out of memory in GitHub Actions but succeeds on your local machine.

## Why it happens
GitHub Actions runners have limited memory (7GB for standard runners). The default Node.js heap limit (~1.7GB) may be enough locally but not in CI where other processes share the runner's memory. Large builds, test suites, or bundling steps can exceed this.

## How to fix it
```yaml
# .github/workflows/build.yml
- name: Build
  run: npm run build
  env:
    NODE_OPTIONS: "--max-old-space-size=6144"

# Or set it directly in the script
- name: Build
  run: NODE_OPTIONS="--max_old_space_size=6144" npm run build
```

## Still not working?
If 6GB is not enough, you may need a larger runner (`runs-on: ubuntu-latest-8-cores` on GitHub Teams/Enterprise). Split the build into smaller steps, use incremental builds, or enable swap: `sudo fallocate -l 4G /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile`. Check if parallel test runners are consuming too much memory and reduce concurrency with `--maxWorkers=2`.
