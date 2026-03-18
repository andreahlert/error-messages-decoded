# Host key verification failed

> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> Host key verification failed.

## What happened

The server's SSH fingerprint changed since the last time you connected. SSH is protecting you from a potential man-in-the-middle attack by refusing to connect.

## Why it happens

- The server was reinstalled or rebuilt (new OS, new SSH keys)
- You're connecting to a different server that now has the same IP (common with cloud VMs and elastic IPs)
- The server's SSH keys were regenerated
- (Rare but real) An actual MITM attack

## How to fix it

**If you know the server was rebuilt/changed (most common):**

```bash
# Remove the old key for that specific host
ssh-keygen -R hostname_or_ip

# Then connect normally, it will ask to accept the new key
ssh user@hostname_or_ip
```

**If the IP changed and you have multiple entries:**

```bash
# Remove by IP
ssh-keygen -R 192.168.1.100

# Remove by hostname
ssh-keygen -R myserver.example.com
```

**If you want to see the current server fingerprint to verify:**

```bash
# On the server itself
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
```

## Don't do this

- Don't add `StrictHostKeyChecking no` to your SSH config permanently. It disables this security check for all connections.
- Don't delete your entire `~/.ssh/known_hosts` file. You'll lose verification for every server you've connected to.
- Don't ignore this warning on production servers without verifying the key changed legitimately.

## Still not working?

- If you have `HashKnownHosts yes` in your SSH config, `ssh-keygen -R` still works. It hashes the hostname before removing.
- In CI/CD, use `ssh-keyscan` to pre-populate known_hosts: `ssh-keyscan github.com >> ~/.ssh/known_hosts`.
- If you keep getting this for the same server, someone might be cycling host keys. Check the server config.
