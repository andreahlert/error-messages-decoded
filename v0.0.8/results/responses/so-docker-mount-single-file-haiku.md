# Root Cause

When you try to mount a single file with `-v /host/path/file:/container/path/file`, Docker checks if `/host/path/file` exists on the host:

- **If it doesn't exist**: Docker assumes it's a directory and creates it as one
- **If it exists as a file**: Docker mounts it correctly

This behavior differs from directory mounts, where Docker will create missing directories automatically.

# The Fix

**Create the file on the host before mounting it:**

```bash
# Ensure the file and its parent directory exist
touch /host/path/file

# Then mount it
docker run -v /host/path/file:/container/path/file myimage
```

Or if using `docker-compose.yml`:

```yaml
volumes:
  - /host/path/file:/container/path/file
```

But first: `touch /host/path/file` on the host.

# Alternative: Mount the parent directory instead

If you need flexibility:

```bash
docker run -v /host/path:/container/path myimage
```

Then place the file at `/container/path/file`. This avoids the pre-creation requirement.

# Why this happens

Docker's bind-mount behavior mimics how the Linux kernel's `mount()` syscall works: if the mount point doesn't exist, it's created with the same type as what would be mounted. Since Docker can't know if a non-existent path should be a file or directory, it defaults to directory.
