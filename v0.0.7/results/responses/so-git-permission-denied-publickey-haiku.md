## Root Cause

This error happens when Git tries to authenticate to GitHub via SSH but fails. Usually it's one of these:

1. **No SSH key exists** on your machine
2. **SSH key not in ssh-agent** (loaded in memory)
3. **SSH key not added to GitHub** account
4. **Wrong key permissions** (file permissions too open)
5. **Git not using SSH** (configured to use HTTPS instead)

## How to Fix

### 1. Check if you have an SSH key
```bash
ls -la ~/.ssh/id_rsa* ~/.ssh/id_ed25519*
```

If nothing shows up, generate one:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter for default location, set a passphrase if you want
```

### 2. Add the key to ssh-agent
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519  # or id_rsa if that's what you have
```

To make this persistent across terminal restarts, add to `~/.bashrc` or `~/.zshrc`:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### 3. Add public key to GitHub
Copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

Then go to [GitHub SSH keys settings](https://github.com/settings/keys) and add it.

### 4. Fix key permissions
```bash
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 700 ~/.ssh
```

### 5. Verify SSH connection
```bash
ssh -T git@github.com
```

Should output: `Hi {username}! You've successfully authenticated...`

### 6. Verify your repo uses SSH (not HTTPS)
```bash
git remote -v
```

If it shows `https://github.com/...`, switch to SSH:
```bash
git remote set-url origin git@github.com:username/repo.git
```

---

**If still failing:** Run `ssh -v git@github.com` to see detailed debug output of where the authentication is breaking.
