# No such file or directory

> bash: /path/to/file: No such file or directory
> cat: myfile.txt: No such file or directory
> /usr/bin/env: 'node\r': No such file or directory

## What happened

The system can't find the file or directory at the path you specified. Either it genuinely doesn't exist, or something invisible is wrong with the path.

## Why it happens

The obvious cause is a typo or wrong path. The non-obvious causes: Windows-style CRLF line endings in a shebang line (the `\r` gets treated as part of the filename), a broken symlink, a path with invisible Unicode characters, or you're looking in the wrong working directory.

## How to fix it

```bash
# Check if the file actually exists
ls -la /path/to/file

# Check your current directory (maybe the relative path is wrong)
pwd

# If the error mentions \r, fix line endings
sed -i 's/\r$//' script.sh
# or
dos2unix script.sh

# Check for broken symlinks
ls -la /path/to/file  # if it shows in red or with -> pointing to nothing
file /path/to/file
```

## Don't do this

- Don't create the file just to make the error go away unless you understand why the program expects it.
- Don't ignore the `\r` in the error message. That `\r` IS the problem.

## Still not working?

If the file exists but a script still says "No such file or directory," check if it's a 32-bit binary on a 64-bit system:

```bash
file /path/to/binary
# If it says "ELF 32-bit" and you're on 64-bit:
sudo apt install libc6-i386  # Debian/Ubuntu
sudo dnf install glibc.i686   # Fedora
```

For scripts with shebangs, the interpreter path might be wrong:

```bash
head -1 script.sh
# #!/usr/local/bin/python3  <-- does this path actually exist?
which python3               # check where it really is
```

If the path contains spaces and isn't quoted, the shell splits it into multiple arguments. Always quote paths: `cat "my file.txt"`, not `cat my file.txt`.
