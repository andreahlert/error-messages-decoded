# Python can't find your module

> ModuleNotFoundError: No module named 'requests'

## What happened

Python looked for a module in every directory on `sys.path` and came up empty. Either the package isn't installed, or it's installed in a different Python environment than the one running your script.

## Why it happens

The #1 cause is having multiple Python installations (system Python, pyenv, conda, venv) and installing the package in one while running the script with another. `pip install requests` went to Python 3.11 but you ran `python3.12 app.py`.

## How to fix it

```bash
# First, check which python you're actually using
which python
python --version

# Install the package with the SAME python that runs your script
python -m pip install requests

# If you're in a virtualenv, make sure it's activated
source venv/bin/activate
pip install requests
```

Using `python -m pip` instead of bare `pip` guarantees the package lands in the right place.

## Don't do this

- `sudo pip install requests` globally. You'll break system packages and create a mess that haunts you for months.
- Installing with pip3 when your script runs under a conda env. They're completely separate worlds.

## Still not working?

If the module is your own local file, check for circular imports or a file named the same as a stdlib module (e.g., naming your file `email.py` shadows the built-in `email` package).

```bash
# See exactly where Python is looking
python -c "import sys; print('\n'.join(sys.path))"

# Check if the package is installed but somewhere unexpected
pip show requests
```

If `pip show` says it's installed but Python still can't find it, the pip and python binaries point to different installations. Use `python -m pip show requests` to be sure.
