# SSH remote host identification has changed

> WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED

## What happened
SSH refused to connect because the server's host key fingerprint does not match what was previously stored in your `~/.ssh/known_hosts` file.

## Why it happens
The server's SSH host key changed since the last time you connected. This happens legitimately when: a cloud instance was rebuilt with a new IP, a server was reinstalled, or the SSH server was reconfigured. It can also indicate a man-in-the-middle attack, which is why SSH blocks the connection by default.

## How to fix it

First, verify the key change is legitimate (server was rebuilt, IP reassigned, etc.). Then remove the old host key:
```bash
# Remove the old key for the specific host
ssh-keygen -R hostname_or_ip

# Example
ssh-keygen -R 192.168.1.100
ssh-keygen -R myserver.example.com
```

Then reconnect and accept the new fingerprint:
```bash
ssh user@hostname
# You'll be prompted to accept the new key - verify the fingerprint first
```

If the hostname maps to multiple IPs (cloud instances), remove by IP:
```bash
ssh-keygen -R 10.0.0.5
```

If you know the server was just rebuilt (common with cloud instances):
```bash
# Remove and reconnect in one shot
ssh-keygen -R myserver.example.com && ssh user@myserver.example.com
```

## Still not working?
- If the host key keeps changing (e.g., auto-scaling group behind a load balancer), disable strict host key checking for that host in `~/.ssh/config`:
  ```
  Host bastion.internal
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
  ```
- Verify the new fingerprint with your cloud provider's console (AWS EC2 System Log, GCP Serial Console) before accepting it.
- If the `known_hosts` file uses hashed hostnames, `ssh-keygen -R` still works with the plain hostname.
- For CI/CD pipelines, use `ssh-keyscan` to pre-populate `known_hosts`: `ssh-keyscan github.com >> ~/.ssh/known_hosts`.
