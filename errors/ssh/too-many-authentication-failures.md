# Received disconnect: Too many authentication failures

> Received disconnect from 192.168.1.100 port 22:2: Too many authentication failures
> Connection closed by 192.168.1.100 port 22

## What happened

SSH tried too many keys from your agent before sending the right one, and the server disconnected you. Each key counts as a failed attempt, and most servers allow only 3-6 attempts before cutting you off.

## Why it happens

You have many SSH keys loaded in `ssh-agent`, and SSH tries each one in order. If you have 10 keys loaded and the right one is #7, the server disconnects you after attempt #6.

## How to fix it

**Specify the exact key to use:**

```bash
ssh -i ~/.ssh/my_specific_key user@host
```

**Or configure it permanently in `~/.ssh/config`:**

```
Host myserver
    HostName 192.168.1.100
    User myuser
    IdentityFile ~/.ssh/my_specific_key
    IdentitiesOnly yes
```

The `IdentitiesOnly yes` line tells SSH to ONLY try the specified key, ignoring all keys in the agent.

**If you have too many keys in the agent:**

```bash
# List loaded keys
ssh-add -l

# Remove all keys
ssh-add -D

# Add back only the ones you need
ssh-add ~/.ssh/github_key
ssh-add ~/.ssh/work_key
```

## Don't do this

- Don't increase `MaxAuthTries` on the server to 20. It makes brute-force attacks easier.
- Don't use `-o PreferredAuthentications=password` to skip key auth entirely, unless you know password auth is what you need and the server allows it.

## Still not working?

- Check if the server has `MaxAuthTries` set very low in `/etc/ssh/sshd_config` (default is 6).
- If using a jump host/bastion, the key count doubles because SSH also tries keys against the bastion.
- Run `ssh -v user@host` to see which keys SSH tries and in what order.
