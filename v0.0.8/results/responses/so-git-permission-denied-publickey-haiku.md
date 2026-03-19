# Root Cause

**Git is trying to authenticate via SSH but GitHub doesn't recognize your key.** This happens when:

1. **No SSH key exists** on your machine
2. **SSH key exists but isn't added to ssh-agent** (the key manager)
3. **SSH public key isn't registered on your GitHub account**
4. **Wrong key permissions** (SSH requires strict file permissions)
5. **SSH config is misconfigured**

# Fix (Step by Step)

## 1. Check if SSH key exists
```bash
ls -la ~/.ssh/id_ed25519
# or for RSA: ls -la ~/.ssh/id_rsa
```

**If it doesn't exist**, generate one:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter for default location, then set a passphrase (or press Enter for none)
```

## 2. Start ssh-agent and add your key
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# or for RSA: ssh-add ~/.ssh/id_rsa
```

Verify it was added:
```bash
ssh-add -l
```

## 3. Add your public key to GitHub

Get your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

Then:
- Go to [github.com/settings/keys](https://github.com/settings/keys)
- Click "New SSH key"
- Paste the output from the command above
- Name it (e.g., "My Laptop")
- Save

## 4. Verify connection works
```bash
ssh -T git@github.com
# Should output: Hi <username>! You've successfully authenticated...
```

## 5. Make sure your repo uses SSH, not HTTPS

```bash
git remote -v
```

If it shows `https://github.com/...`, change it:
```bash
git remote set-url origin git@github.com:username/repo.git
```

---

**Try these in order.** Most common fix is step 2 (ssh-add) + step 3 (key not on GitHub). If still stuck, run `ssh -vT git@github.com` to see detailed debug output.
