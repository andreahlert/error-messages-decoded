# The agent has no identities

> The agent has no identities.

## What happened

You ran `ssh-add -l` and the SSH agent has no keys loaded. Any SSH operation that relies on the agent (git push, ssh to servers) will fail with "permission denied" because no keys are available.

## Why it happens

- You rebooted and the agent didn't persist your keys
- You never added your key to the agent
- The SSH agent isn't running
- You generated a key but it's in a non-default location

## How to fix it

**Add your key to the agent:**

```bash
# Start the agent if it's not running
eval "$(ssh-agent -s)"

# Add your default key
ssh-add ~/.ssh/id_ed25519
# or
ssh-add ~/.ssh/id_rsa

# Verify it was added
ssh-add -l
```

**If you don't have a key yet:**

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-add ~/.ssh/id_ed25519
```

**To persist keys across reboots on macOS:**

```bash
# Add to Keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Add to `~/.ssh/config`:

```
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
```

**To persist on Linux, add to `~/.bashrc` or `~/.zshrc`:**

```bash
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
```

## Don't do this

- Don't generate a new key every time this happens. You probably already have one; just add it.
- Don't use `ssh-add *` to add every file in `~/.ssh/`. Some files aren't keys and will error.

## Still not working?

- Check if `SSH_AUTH_SOCK` is set: `echo $SSH_AUTH_SOCK`. If empty, the agent isn't running.
- If using tmux or screen, the `SSH_AUTH_SOCK` from your original session may be stale. Reconnect or update the variable.
- If your key has a passphrase and you're in a non-interactive shell (cron, CI), you need a passphrase-less key or `sshpass`.
