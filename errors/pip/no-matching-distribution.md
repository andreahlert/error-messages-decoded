# pip can't find the package you want

> ERROR: No matching distribution found for tensorflow-gpu

## What happened

pip searched PyPI and found no package that matches your request for the current Python version, OS, and architecture.

## Why it happens

The package either doesn't exist with that exact name, doesn't support your Python version, or doesn't have wheels built for your platform. `tensorflow-gpu` was merged into `tensorflow` in version 2.x. `sklearn` is actually `scikit-learn`. Package names are easy to get wrong.

## How to fix it

```bash
# Check the exact package name on PyPI
pip index versions tensorflow
# or just search the web: "pypi tensorflow"

# Check if your Python version is supported
python --version
pip install tensorflow  # try the correct name

# If it requires Python < 3.12 and you're on 3.12
pyenv install 3.11.8
pyenv local 3.11.8
python -m venv venv && source venv/bin/activate
pip install tensorflow
```

Common name mismatches:
- `sklearn` -> `scikit-learn`
- `cv2` -> `opencv-python`
- `PIL` -> `Pillow`
- `yaml` -> `PyYAML`
- `dotenv` -> `python-dotenv`

## Don't do this

- Don't use `--pre` to install pre-release versions unless you know what you're doing. You'll get unstable builds.
- Don't download `.whl` files from random websites. Malicious packages exist.

## Still not working?

If the package is only available for specific platforms (like `pywin32` on Windows):

```bash
# Check available versions and platforms
pip install tensorflow== 2>/dev/null
# This intentionally errors but shows all available versions

# On Apple Silicon, some packages need Rosetta or special builds
# or install from conda-forge instead
conda install -c conda-forge tensorflow
```

If you're behind a corporate proxy that blocks PyPI, configure pip to use your company's mirror:

```bash
pip install --index-url https://your-company-pypi.com/simple/ tensorflow
```
