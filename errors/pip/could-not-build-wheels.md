# pip fails to build wheels for a package

> ERROR: Could not build wheels for cryptography, which is required to install pyproject.toml-based projects

## What happened

pip tried to compile a C/C++/Rust extension from source and failed because your system is missing the build tools or development libraries the package needs.

## Why it happens

No prebuilt wheel exists for your Python version + OS + architecture combo, so pip falls back to building from source. This needs a C compiler, Python headers, and often package-specific system libraries (OpenSSL headers for cryptography, libpq for psycopg2, etc.).

## How to fix it

```bash
# Install the basic build toolchain
# Ubuntu/Debian
sudo apt install build-essential python3-dev

# Fedora
sudo dnf install gcc python3-devel

# macOS
xcode-select --install

# Then for specific packages, install their system dependencies:
# cryptography
sudo apt install libssl-dev libffi-dev    # Debian/Ubuntu
sudo dnf install openssl-devel libffi-devel  # Fedora

# psycopg2
sudo apt install libpq-dev                # Debian/Ubuntu

# Pillow
sudo apt install libjpeg-dev zlib1g-dev   # Debian/Ubuntu

# lxml
sudo apt install libxml2-dev libxslt1-dev # Debian/Ubuntu

# Then retry
pip install cryptography
```

## Don't do this

- Don't pin to an ancient version just because it had a prebuilt wheel. You'll inherit known vulnerabilities.
- Don't install from random GitHub forks that "fixed" the build. That's a supply chain attack waiting to happen.

## Still not working?

For Rust-based packages (cryptography, orjson), you also need Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
pip install cryptography
```

If you're on Alpine Linux (common in Docker), the musl libc breaks many packages. Either use a Debian-based image or install the right musl packages:

```dockerfile
# Better: use slim instead of alpine
FROM python:3.12-slim
# Instead of: FROM python:3.12-alpine
```

As a last resort for psycopg2, use the pure-Python version: `pip install psycopg2-binary`.
