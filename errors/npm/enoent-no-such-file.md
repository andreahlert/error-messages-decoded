# ENOENT no such file or directory package.json

> npm ERR! code ENOENT
> npm ERR! syscall open
> npm ERR! path /home/user/wrong-directory/package.json
> npm ERR! errno -2
> npm ERR! enoent ENOENT: no such file or directory, open '/home/user/wrong-directory/package.json'
> npm ERR! enoent This is related to npm not being able to find a file.

## What happened

You ran an npm command in a directory that doesn't have a `package.json`. You're either in the wrong folder or the project hasn't been initialized.

## Why it happens

npm commands like `install`, `run`, `test` need a `package.json` to know what to do. If you `cd` into the wrong directory, or you cloned a repo and are inside a subdirectory, npm can't find it. This also happens when your terminal opens in `~` and you forget to navigate to your project.

## How to fix it

```bash
# Check where you actually are
pwd
ls package.json

# Navigate to your project root
cd /path/to/your/project
npm install

# If the project doesn't have a package.json yet
npm init -y
```

If the error references a specific file other than `package.json`:

```bash
# A dependency's file is missing - likely a corrupted node_modules
rm -rf node_modules package-lock.json
npm install
```

## Don't do this

**Don't create an empty `package.json` by hand** with just `{}`. Use `npm init -y` so it has the required fields.

**Don't run `npm install` in a subfolder** (like `src/`) thinking it'll find the root `package.json`. It won't look upward.

## Still not working?

If npm is looking for a file inside `node_modules` that should exist:

```bash
# Verify the package is installed
ls node_modules/the-package/

# If it's there but files are missing, clean reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

If this happens in CI, your build step might be running in the wrong working directory:

```yaml
# GitHub Actions - make sure you set working-directory
- name: Install deps
  working-directory: ./frontend
  run: npm install
```

On Windows, paths with spaces or special characters can cause ENOENT. Move your project to a path without spaces (e.g., `C:\dev\my-project` instead of `C:\Users\My Name\Documents\My Project`).
