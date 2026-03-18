# ssh: connect to host xxx port 22: Connection refused

> ssh: connect to host 192.168.1.100 port 22: Connection refused
> ssh: connect to host example.com port 22: Connection refused

## What happened

Your SSH client reached the server but nothing answered on port 22. The server actively refused the connection. This is different from a timeout (which means the server is unreachable).

## Why it happens

- SSH server (sshd) isn't running on the target machine
- SSH is running on a different port
- A firewall is rejecting (not dropping) connections on port 22
- The server's IP changed and you're hitting the wrong machine

## How to fix it

**Check if sshd is running (from the server itself or console):**

```bash
sudo systemctl status sshd
# If not running:
sudo systemctl start sshd
sudo systemctl enable sshd
```

**If SSH runs on a non-standard port:**

```bash
# Check what port sshd listens on
sudo grep -i port /etc/ssh/sshd_config

# Connect on the right port
ssh -p 2222 user@host
```

**Check the firewall:**

```bash
# UFW (Ubuntu)
sudo ufw status
sudo ufw allow ssh

# firewalld (RHEL/CentOS)
sudo firewall-cmd --list-all
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --reload

# iptables
sudo iptables -L -n | grep 22
```

**If it's a cloud VM, check the security group / network ACL:**

- AWS: Check the EC2 security group allows inbound TCP port 22
- GCP: Check VPC firewall rules
- Azure: Check NSG rules

## Don't do this

- Don't disable the firewall entirely to "test." Re-enable SSH specifically.
- Don't assume the server is down. Connection refused means something IS responding; it's just not SSH.

## Still not working?

- If this is a new server, SSH might not be installed: `sudo apt install openssh-server` (Debian/Ubuntu) or `sudo yum install openssh-server` (RHEL).
- Check if the server has a public IP and you're not trying to connect to a private IP from outside the network.
- On EC2, make sure the instance is running and passed status checks.
