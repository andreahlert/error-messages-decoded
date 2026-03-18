# GitHub Actions process completed with exit code 2

> Error: Process completed with exit code 2

## What happened
A step in your GitHub Actions workflow exited with code 2. This is a generic error code that typically indicates a usage error, misuse of a shell command, or a script failure.

## Why it happens
Exit code 2 often comes from: shell scripts running with `set -e` where a command fails, `grep` finding no matches (returns 2 for errors, 1 for no matches), or a shell syntax error. In GitHub Actions, the default shell is `bash` with `set -eo pipefail`, which means any command that returns a non-zero exit code will immediately fail the step.

## How to fix it

Check which command is actually failing by adding verbose output:
```yaml
- name: Debug step
  shell: bash
  run: |
    set -euxo pipefail
    # your commands here - the -x flag will print each command before execution
```

If using `grep` where no matches is acceptable:
```bash
# grep returns exit code 1 when no matches found
# Use || true to ignore it
grep "pattern" file.txt || true

# Or redirect stderr
grep "pattern" file.txt 2>&1 || echo "No matches found"
```

Handle expected failures explicitly:
```yaml
- name: Run script
  shell: bash
  run: |
    set -eo pipefail

    # If a command might fail and that's OK:
    some_command || exit_code=$?
    if [ "${exit_code:-0}" -ne 0 ]; then
      echo "Command failed with $exit_code, continuing..."
    fi
```

If the error comes from a piped command (due to `pipefail`):
```bash
# This fails if any command in the pipe fails
cat file.txt | grep "pattern" | wc -l

# Handle it:
cat file.txt | grep "pattern" || true | wc -l
```

## Still not working?
- Add `2>&1` to capture stderr in the logs: `command 2>&1`.
- Check if the step uses a custom shell. Some actions use `sh` or `pwsh` where exit code semantics differ.
- For scripts, test them locally with `bash -euxo pipefail script.sh` to see exactly which line fails.
- Exit code 2 from `diff` means "trouble" (not just "files differ" which is 1). Check the specific command.
