The "Permission denied (publickey)" error typically occurs when your SSH key authentication for a remote repository like GitHub doesn't work as expected. Here are some steps to troubleshoot and resolve this issue:

### 1. Verify Your SSH Key Configuration

Ensure that you have correctly configured your SSH keys on both the local machine and the remote server.

- **Local Machine:**
  - Make sure your `~/.ssh` directory exists.
  - Ensure that your private key (`id_rsa`) is in there, along with a public key file (e.g., `id_rsa.pub`).
  
  ```bash
  ls ~/.ssh/
  ```

- **Remote Server:**
  - The server should have the corresponding public key configured. This can be done through SSH or by manually copying the public key to the authorized keys directory on the remote server.

### 2. Check Your SSH Configuration

Ensure that your `~/.ssh/config` file is correctly set up for GitHub:

```bash
Host github.com
    HostName git@github.com
    IdentityFile ~/.ssh/id_rsa
```

This configuration tells Git to use the private key (`id_rsa`) when connecting to GitHub.

### 3. Verify Your SSH Key Permissions

Ensure that your SSH keys have the correct permissions:

- **Local Machine:**
  ```bash
  ls -l ~/.ssh/
  ```
  The output should look something like this:
  
  ```
  total 0
  ```

  If it's empty, you need to create a directory and add the key files inside.

  ```bash
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  cat id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/authorized_keys
  ```

- **Remote Server:**
  Ensure that the `~/.ssh` directory exists and has the correct permissions.

### 4. Check Your SSH Agent

Ensure your SSH agent is running:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

If you're using a passphrase, add it to the agent:

```bash
ssh-add -K ~/.ssh/id_rsa
```

### 5. Try Reconnecting with Git

After making these changes, try connecting again with `git push` or `git pull`.

- **Local Machine:**
  ```bash
  git remote set-url origin https://github.com/username/repo.git
  ```

- **Remote Server:**
  Ensure the public key is correctly copied to the authorized keys directory on the server.

### 6. Check for Firewall and Network Issues

Ensure that there are no firewall rules or network issues preventing SSH connections:

```bash
sudo ufw status
```
If `ufw` is enabled, check its logs:
```bash
sudo ufw logging on
sudo ufw log show
```

### 7. Reinstall SSH Key

If none of the above steps work, consider reinstalling your SSH key pair:

- **Local Machine:**
  ```bash
  rm -rf ~/.ssh/*
  ssh-keygen -t rsa -b 2048
  ```

- **Remote Server:**
  Ensure that the public key is correctly copied to the authorized keys directory on the server.

### 8. Check for GitHub Issues

If you're still facing issues, check if there are any known issues or updates available for your specific version of Git and SSH:

```bash
git --version
ssh -V
```

### Conclusion

By following these steps, you should be able to resolve the "Permission denied (publickey)" error when using Git with GitHub. If the problem persists, consider reaching out to the support team or checking for any specific issues related to your setup.
