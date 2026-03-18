# pip dependency resolver conflict

> ERROR: pip's dependency resolver does not currently consider all the packages that are installed. Behaviour is not guaranteed with the following requirements:
> requests 2.28.0 requires urllib3<2,>=1.21.1, but you have urllib3 2.1.0 which is incompatible.

## What happened

Two packages in your environment need different, incompatible versions of the same dependency. pip installed one version but it breaks the other package's requirements.

## Why it happens

Package A needs `urllib3<2` and package B needs `urllib3>=2`. pip can't satisfy both at once. This gets worse over time as you `pip install` things one by one into the same environment without a lockfile.

## How to fix it

```bash
# Start fresh with a clean virtual environment
python -m venv venv --clear
source venv/bin/activate

# Install everything at once so pip can resolve all constraints together
pip install requests boto3 flask  # all your deps in one command

# Or better, use a requirements file
pip install -r requirements.txt
```

If you need to find the conflict:

```bash
# See what depends on the conflicting package
pip show urllib3
# Check the "Required-by" field

# See all dependency conflicts at once
pip check
```

## Don't do this

- `pip install --force-reinstall urllib3==1.26.18`. You'll fix one package and break the other. It's whack-a-mole.
- Don't ignore the warning. Your code might work today but will fail unpredictably when it hits a removed API.

## Still not working?

Use a proper dependency resolver:

```bash
# pip-tools generates a lockfile with compatible versions
pip install pip-tools
pip-compile requirements.in  # generates requirements.txt with pinned, resolved versions
pip-sync requirements.txt

# Or use uv, which is much faster
pip install uv
uv pip compile requirements.in -o requirements.txt
uv pip sync requirements.txt
```

For truly irreconcilable conflicts (package A cannot coexist with package B), you need separate virtual environments. Use `pipx` for CLI tools and keep library dependencies in project-specific venvs.
