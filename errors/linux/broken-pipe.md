# Broken pipe

> write error: Broken pipe
> BrokenPipeError: [Errno 32] Broken pipe
> echo: write error: broken pipe

## What happened

A process tried to write to a pipe or socket whose reading end has already been closed. The reader disconnected before the writer finished.

## Why it happens

This happens when you pipe output to a command that exits early. For example, `cat hugefile | head -5` causes a broken pipe because `head` closes after reading 5 lines while `cat` is still writing. It also happens with network connections when the remote side disconnects (SSH timeout, client navigating away from a web page, etc).

## How to fix it

For shell pipes, this is usually harmless. Suppress the error:

```bash
# This is normal behavior, head exits after 5 lines
cat hugefile | head -5 2>/dev/null

# Or trap SIGPIPE in scripts
trap '' PIPE
```

For application code:

```python
# Python: handle the error
import signal
signal.signal(signal.SIGPIPE, signal.SIG_DFL)

# Or catch the exception
try:
    sys.stdout.write(data)
except BrokenPipeError:
    sys.exit(0)
```

For SSH sessions that break mid-stream, configure keep-alives:

```bash
# In ~/.ssh/config
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

## Don't do this

- Don't treat every broken pipe as an error. With `head`, `tail -1`, or `grep -m1`, it's expected and intentional.
- Don't ignore broken pipes in server code. If a client disconnects, stop processing their request to avoid wasting resources.

## Still not working?

If broken pipe errors kill your long-running script:

```bash
# Run with nohup to survive terminal disconnects
nohup ./long-script.sh > output.log 2>&1 &

# Or use tmux/screen
tmux new -s mysession
./long-script.sh
# Ctrl+B, D to detach
```

For web servers showing broken pipe in logs, it's usually clients disconnecting mid-response. This is normal at scale. Adjust your logging level to stop it from flooding your logs rather than trying to "fix" it.
