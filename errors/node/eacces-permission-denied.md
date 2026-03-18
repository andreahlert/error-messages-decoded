# npm global install fails with EACCES permission denied

> npm ERR! Error: EACCES: permission denied, access '/usr/local/lib/node_modules'
> npm ERR! { [Error: EACCES: permission denied, access '/usr/local/lib/node_modules']
> npm ERR!   errno: -13,
> npm ERR!   code: 'EACCES',
> npm ERR!   syscall: 'access',
> npm ERR!   path: '/usr/local/lib/node_modules' }

## What happened

You ran `npm install -g something` and npm tried to write to a directory owned by root.

## Why it happens

When Node was installed via the system package manager or the official `.pkg` installer, it places global modules in `/usr/local/lib/node_modules/`, which is owned by root. Your user doesn't have write access there. This is a filesystem ownership problem, not an npm bug.

## How to fix it

The real fix is to stop using the system Node. Use a version manager instead:

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc

# Install Node through nvm (installs to ~/.nvm, no root needed)
nvm install --lts
nvm use --lts

# Now global installs work without sudo
npm install -g typescript
```

If you can't switch to nvm right now, fix the prefix:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Don't do this

**Never `sudo npm install -g`**. It works once but creates root-owned files in your project later. You'll chase permission errors for weeks.

**Never `sudo chown -R $USER /usr/local/`**. You're giving yourself ownership of system directories. This breaks other tools and is a security risk.

**Never `chmod 777 /usr/local/lib/node_modules`**. Same problem but worse: now every user and process on the machine can write there.

## Still not working?

If you already ran `sudo npm install` before and have mixed ownership:

```bash
# Clean the npm cache (it might have root-owned files too)
sudo rm -rf ~/.npm
npm cache clean --force

# If using nvm and still getting errors, reinstall global packages
nvm reinstall-packages system
```

On macOS with Homebrew-installed Node, Homebrew should handle permissions. If not:

```bash
sudo chown -R $(whoami) $(brew --prefix)/lib/node_modules
```
