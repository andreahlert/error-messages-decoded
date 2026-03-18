# Segmentation fault (core dumped)

> Segmentation fault (core dumped)
> Segmentation fault
> signal: segmentation fault (core dumped)

## What happened

A program tried to access memory it's not allowed to touch. The kernel killed it immediately with SIGSEGV (signal 11).

## Why it happens

The program dereferenced a null pointer, accessed freed memory, wrote past the end of a buffer, or had a stack overflow. If you're running a compiled binary (not your code), it's likely a bug in that software, a corrupt installation, or incompatible library versions. If it happens with your own C/C++/Rust code, it's a memory safety bug.

## How to fix it

```bash
# If it's an installed tool, try reinstalling
sudo apt install --reinstall <package>
# or
sudo dnf reinstall <package>

# Check if it's a library issue
ldd /path/to/binary  # look for "not found"

# Enable core dumps for debugging
ulimit -c unlimited
./myprogram
# Core file will be in current dir or /var/lib/systemd/coredump/
```

For debugging your own code:

```bash
# Compile with debug symbols
gcc -g -fsanitize=address -o myapp myapp.c

# Get a backtrace from the core dump
gdb ./myapp core
(gdb) bt
```

## Don't do this

- Don't ignore segfaults in production. They indicate memory corruption which can be a security vulnerability.
- Don't just restart the process in a loop. The segfault will keep happening and might corrupt data.

## Still not working?

Check if it's hardware-related:

```bash
# Run a memory test
sudo memtest86+
# or from userspace
sudo apt install memtester
sudo memtester 1G 1
```

If it segfaults only with specific input, you've found a bug. Report it with the input that triggers it and the backtrace.

If a Python/Node/Java process segfaults, the bug is in a native extension, not your scripting code. Update the extension or check its issue tracker:

```bash
# Python
pip install --upgrade numpy  # or whatever native module
```
