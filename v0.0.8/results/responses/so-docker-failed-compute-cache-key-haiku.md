# Root Cause

**The most common cause**: Your `COPY` or `ADD` command in the Dockerfile references files that don't exist in the build context when running from CLI, even though VS succeeds.

This typically happens because:

1. **Different working directories** - VS builds from project root; CLI builds from a different directory
2. **Path case sensitivity** - Windows (VS) is case-insensitive; Linux is case-sensitive
3. **Missing files in context** - Files excluded by `.dockerignore` or not present in the CLI's working directory
4. **Relative paths** - The Dockerfile uses paths that work in VS but not from CLI

# How to Fix

## 1. Verify your build context
Check where you're running Docker from:

```bash
# Run from project root, not subdirectories
cd /path/to/project
docker build -t myapp .
```

VS likely builds from the solution/project root. If you're running `docker build` from a subdirectory, it won't find files.

## 2. Check your COPY/ADD commands

Look at your Dockerfile for problematic paths:

```dockerfile
# ❌ This fails if file isn't at build context root
COPY myfile.txt .

# ❌ This fails with case-sensitivity on Linux
COPY MyFile.txt .

# ✅ Use relative paths from context root
COPY ./src/config.json ./app/
```

Verify the files actually exist at the path you specified relative to where you're running `docker build`.

## 3. Check .dockerignore

If you have a `.dockerignore` file, it might be excluding files needed for the build:

```bash
# View what's being excluded
cat .dockerignore
```

## 4. Test with --progress=plain for details

```bash
docker build --progress=plain -t myapp .
```

This shows exactly which file is missing.

## 5. Verify case sensitivity

On Linux/CLI, check exact file names:

```bash
ls -la  # Look for case mismatches
```

Rename files if needed or use correct case in COPY commands.

**If you share your Dockerfile and the error output, I can pinpoint the exact issue.**
