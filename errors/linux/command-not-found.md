# command not found

> bash: node: command not found
> zsh: command not found: docker
> /usr/bin/env: 'python3': No such file or directory

## What happened

Your shell can't find the program you're trying to run. It's either not installed, not in your PATH, or installed for a different user.

## Why it happens

When you type a command, the shell searches every directory listed in `$PATH` for a matching executable. If the binary isn't in any of those directories, you get "command not found." This happens after fresh installs that modify PATH (nvm, pyenv, rustup) without reloading the shell, or when a package genuinely isn't installed.

## How to fix it

```bash
# Check if it's installed somewhere
which node || find /usr -name node 2>/dev/null
type -a python3

# Check your PATH
echo $PATH

# If it was just installed, reload your shell
source ~/.bashrc  # or ~/.zshrc

# Or start a new shell
exec bash
```

If the package isn't installed:

```bash
# Debian/Ubuntu
sudo apt update && sudo apt install nodejs

# Fedora
sudo dnf install nodejs

# macOS
brew install node
```

## Don't do this

- Don't add random directories to PATH without understanding what's in them.
- Don't create aliases as a fix for PATH problems. Fix the PATH.
- Don't install packages as root when you should use a version manager (nvm, pyenv, etc).

## Still not working?

If the command works with `sudo` but not without, the root PATH and your user PATH are different:

```bash
# Compare
echo $PATH
sudo env | grep PATH
```

If you installed via a version manager (nvm, pyenv, rbenv), make sure the init script is in your shell profile:

```bash
# Check if nvm is initialized
grep nvm ~/.bashrc ~/.zshrc
# Should contain something like:
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

For snaps, make sure `/snap/bin` is in your PATH.
