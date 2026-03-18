# Git permission denied (publickey)

> git@github.com: Permission denied (publickey).
> fatal: Could not read from remote repository.
>
> Please make sure you have the correct access rights
> and the repository exists.

## What happened

You tried to push, pull, or clone via SSH and GitHub (or GitLab/Bitbucket) rejected your SSH key. Authentication failed.

## Why it happens

Your SSH key isn't registered with the remote, the ssh-agent doesn't have your key loaded, you're using the wrong key, or you don't have one at all. This is purely an authentication problem. The repo exists and your permissions are fine, but the server can't verify who you are.

## How to fix it

```bash
# Step 1: Check if you have an SSH key
ls -la ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub 2>/dev/null

# Step 2: If no key exists, create one
ssh-keygen -t ed25519 -C "your@email.com"

# Step 3: Add the key to your SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Step 4: Copy the public key
cat ~/.ssh/id_ed25519.pub
# Copy the output and add it at: https://github.com/settings/ssh/new

# Step 5: Test the connection
ssh -T git@github.com
# Should say: "Hi username! You've successfully authenticated"
```

## Don't do this

**Don't switch to HTTPS just to avoid SSH setup.** You'll be typing passwords or tokens on every push. Set up SSH once and forget it.

**Don't copy your private key (`id_ed25519` without `.pub`) anywhere.** Only the `.pub` file goes to GitHub. The private key stays on your machine.

**Don't generate a new key every time this happens.** Check if your existing key is loaded first.

## Still not working?

If you have multiple SSH keys, tell SSH which one to use for GitHub:

```bash
# ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
```

If `ssh -T git@github.com` works but `git push` fails, the remote might be set to HTTPS:

```bash
# Check your remote URL
git remote -v
# If it shows https://github.com/... instead of git@github.com:...

# Switch to SSH
git remote set-url origin git@github.com:user/repo.git
```

On macOS, the keychain might not persist your key across reboots:

```bash
# Add to keychain permanently
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# In ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

If you're behind a corporate firewall that blocks SSH (port 22):

```bash
# Use SSH over HTTPS port (443) - add to ~/.ssh/config
Host github.com
  HostName ssh.github.com
  Port 443
  User git
```
