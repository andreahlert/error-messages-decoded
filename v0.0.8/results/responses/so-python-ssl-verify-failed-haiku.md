# Root Cause

Python's SSL module can't locate or verify your system's Certificate Authority (CA) certificates when validating the server's SSL certificate. The most common causes are:

1. **macOS (most common)**: Python from `python.org` doesn't include CA certificates by default
2. **Outdated `certifi` package**: Contains outdated CA certificate bundle
3. **Corporate proxy/firewall**: Intercepting and re-signing HTTPS traffic
4. **System clock skewed**: Invalid certificate dates if system time is wrong
5. **Missing `ca-certificates` package** (Linux): Not installed or not updated

---

# How to Fix (in order)

## 1. Update `certifi` package (quickest)

```bash
pip install --upgrade certifi
```

This refreshes the CA certificate bundle Python uses. Works for most cases.

## 2. macOS: Install CA certificates

If on macOS with Python from `python.org`, run the certificate installer:

```bash
/Applications/Python\ 3.x/Install\ Certificates.command
```

Replace `3.x` with your Python version. This is **required** on macOS after installing Python from `python.org`.

## 3. Verify system date/time

```bash
date
```

If your system clock is wrong, SSL verification fails. Sync it:

```bash
# macOS
sudo sntp -s time.apple.com

# Linux
sudo timedatectl set-ntp true
```

## 4. Check your CA bundle location

Python uses this path for CA certificates:

```bash
python -c "import certifi; print(certifi.where())"
```

Verify the file exists and is readable. If it's empty or missing, reinstall certifi.

## 5. For corporate networks with SSL inspection

If you're behind a corporate proxy, add your organization's root certificate:

```bash
# Export your org's CA certificate (ask your IT team)
# Then:
python -c "import certifi; import shutil; shutil.copy('/path/to/corp-ca.pem', certifi.where())"
```

Or set the environment variable before running:

```bash
export REQUESTS_CA_BUNDLE=/path/to/corp-ca.pem
python your_script.py
```

## 6. Last resort: disable verification (only for dev/testing)

```python
import urllib.request
urllib.request.urlopen(url, context=ssl._create_unverified_context())

# Or with requests:
import requests
requests.get(url, verify=False)
```

⚠️ **Never use this in production** — it defeats SSL security.

---

**Most likely fix for you**: Try steps 1-3 in order. 90% of the time, updating `certifi` or installing macOS certificates solves it.
