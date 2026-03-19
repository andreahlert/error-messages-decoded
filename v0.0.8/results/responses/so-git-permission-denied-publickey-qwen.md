The "Permission denied (publickey)" error typically occurs when your SSH key authentication for a remote repository like GitHub doesn't work as expected. Here are some steps to troubleshoot and resolve this issue:

### 1. Verify Your SSH Key Configuration

Ensure that you have correctly configured your SSH keys on both the local machine and the remote server.

- **Local Machine:**
  - Make sure your `~/.ssh` directory exists.
  - Ensure there is a `id_rsa.pub` file (or `id_ed25519.pub`, depending on your key type).
  - The public key should be added to GitHub by following the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-server).

- **Remote Server (GitHub):**
  - Ensure that you have installed `openssh` on your server.
  - Verify that SSH keys are correctly configured and accessible.

### 2. Check Your SSH Key Permissions

Ensure that the permissions of your `.ssh` directory and files are set correctly:

```bash
chmod 700 ~/.ssh
```

And for the `id_rsa.pub` file (or `id_ed25519.pub`):

```bash
chmod 644 ~/.ssh/id_rsa.pub
```

### 3. Verify SSH Agent Configuration

Ensure that your SSH agent is running and configured correctly:

- Start the SSH agent:
  ```bash
  eval "$(ssh-agent -s)"
  ```

- Add your public key to the SSH agent:
  ```bash
  ssh-add ~/.ssh/id_rsa
  # or for Ed25519 keys
  ssh-add ~/.ssh/id_ed25519
  ```

### 4. Check Your Remote Repository Settings

Ensure that your GitHub repository settings allow push access:

- Go to the repository on GitHub.
- Navigate to `Settings` > `SSH and GPG Keys`.
- Ensure that you have added a new SSH key or that an existing one is correctly configured.

### 5. Test Your Connection

Try connecting to the remote server using SSH manually to ensure everything is set up correctly:

```bash
ssh -T git@github.com
```

If this command fails with "Permission denied (publickey)", it indicates a problem with your key configuration or access permissions.

### 6. Check for Firewall and Network Issues

Ensure that there are no firewall rules blocking SSH connections from the local machine to the remote server:

- On the remote server, check if `sshd` is running:
  ```bash
  sudo systemctl status sshd
  ```

- Ensure that your network configuration allows traffic through port 22.

### 7. Reinstall or Generate New Keys

If none of the above steps work, consider reinstalling SSH keys:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

After generating new keys, add them to your GitHub account and try pushing/pulling again.

### 8. Check for Duplicate Keys

Ensure that there are no duplicate public keys in the `~/.ssh/known_hosts` file:

```bash
cat ~/.ssh/known_hosts | grep -v "github.com" | sort > ~/.ssh/known_hosts.new && mv ~/.ssh/known_hosts.new ~/.ssh/known_hosts
```

### 9. Check for DNS Issues

Ensure that your domain name is correctly configured in the `hosts` file on the remote server:

```bash
echo '127.0.0.1 github.com' >> /etc/hosts
```

### Conclusion

By following these steps, you should be able to resolve the "Permission denied (publickey)" error and successfully push/pull from your GitHub repository using SSH keys. If issues persist, consider reaching out to GitHub support or checking their documentation for additional troubleshooting tips.
