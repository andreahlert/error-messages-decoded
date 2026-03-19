# Root Cause

Composer's dependency resolver requires significant memory to:
- Parse all package metadata
- Resolve version conflicts across your dependency tree
- Build the final dependency graph

The error occurs when PHP's `memory_limit` (default often 128MB-256MB) is exhausted during this process.

---

# Fixes (in order)

## 1. **Increase PHP memory limit for Composer only** (Recommended)
```bash
php -d memory_limit=-1 composer.phar update
# or if Composer is in PATH:
COMPOSER_MEMORY_LIMIT=-1 composer update
```
This sets memory to unlimited just for that command without changing your global PHP config.

## 2. **Temporarily increase PHP memory limit globally**
```bash
# Edit your php.ini (find it with: php --ini)
memory_limit = 2048M  # or higher
```
Then run `composer update` normally.

## 3. **Clear Composer cache**
```bash
composer clearcache
composer update
```
Sometimes cached data is corrupt and takes extra memory to process.

## 4. **Update Composer itself**
```bash
composer self-update
```
Older versions had inefficient memory usage in the dependency resolver.

## 5. **For CI/deployment environments**
If this fails in Docker or a constrained environment, add to your Dockerfile:
```dockerfile
RUN php -d memory_limit=-1 composer install --no-interaction --no-dev
```

---

# Why Laravel 4 specifically?

Laravel 4 has outdated dependencies that may require more memory to resolve than modern versions. Consider upgrading if possible, but the memory limit increase will fix it regardless.
