# pip refuses to install: externally-managed-environment

> error: externally-managed-environment
>
> x This environment is externally managed
> ...
> hint: If you wish to install a non-Debian-packaged Python package,
> create a virtual environment using, e.g.:
>     python3 -m venv path/to/venv

## What happened

Your system's Python is now protected by PEP 668. Running `pip install` in the system Python is blocked to prevent breaking OS packages that depend on specific Python library versions.

## Why it happens

Distros like Ubuntu 23.04+, Fedora 38+, Debian 12+, and Arch adopted PEP 668. The system Python belongs to the package manager (apt, dnf, pacman). If pip overwrites a system library, tools like `apt` or even your desktop environment can break in subtle, nasty ways.

## How to fix it

```bash
# The right fix: use a virtual environment
python3 -m venv ~/.venv
source ~/.venv/bin/activate
pip install requests  # works fine now

# Or use pipx for CLI tools
pip install --user pipx  # if pipx isn't installed yet
pipx install black
pipx install httpie
```

Add activation to your shell profile so you don't have to remember:

```bash
echo 'source ~/.venv/bin/activate' >> ~/.bashrc
```

## Don't do this

- `pip install --break-system-packages requests`. The flag exists but the name is the warning. You WILL break something eventually.
- Deleting the `EXTERNALLY-MANAGED` file. Same thing, you're just removing the guardrail.
- `sudo pip install`. This is the old habit that PEP 668 exists to kill.

## Still not working?

If you need a package available system-wide (not in a venv), use your OS package manager:

```bash
# Ubuntu/Debian
sudo apt install python3-requests

# Fedora
sudo dnf install python3-requests
```

For development, consider using `pyenv` or `uv` to manage Python versions entirely outside the system:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv
source .venv/bin/activate
uv pip install requests
```
