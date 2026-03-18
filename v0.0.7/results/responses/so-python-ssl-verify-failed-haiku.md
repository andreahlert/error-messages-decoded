# Root Cause

Python's `urllib` (and `requests`, `httpx`, etc.) validates HTTPS certificates against the system's trusted CA certificate bundle. The error occurs when:

1. **Missing/outdated CA bundle** - Python can't find the system's certificate authorities
2. **Self-signed certificates** - The server uses a cert not signed by a trusted CA
3. **Corporate proxy/firewall** - Intercepts HTTPS and presents its own cert
4. **Expired/invalid certificate chain** - The server's cert or intermediate certs are invalid

The most common cause on macOS/Windows is Python being installed without bundled certificates, or on Linux, the system CA bundle being missing.

# Specific Fixes

## Fix 1: Install/Update CA Certificates (macOS)

If you installed Python via official installer:

```bash
/Applications/Python\ 3.x/Install\ Certificates.command
```

This installs the bundled Mozilla CA certificate bundle that Python needs.

## Fix 2: Verify System CA Bundle Path

Check where your CA bundle actually is:

```bash
python3 -c "import ssl; print(ssl.get_default_verify_paths())"
```

Look at the `openssl_cafile` path. If it doesn't exist or is empty, that's your problem.

## Fix 3: Point to System Certificates (Linux/Unix)

```python
import urllib.request
import ssl

context = ssl.create_default_context()
context.load_verify_locations('/etc/ssl/certs/ca-certificates.crt')  # Debian/Ubuntu
# or on RHEL/CentOS:
# context.load_verify_locations('/etc/pki/tls/certs/ca-bundle.crt')

response = urllib.request.urlopen('https://example.com', context=context)
```

## Fix 4: Disable Certificate Verification (Development Only)

**Do NOT use in production.** Only for local testing:

```python
import urllib.request
import ssl

context = ssl._create_unverified_context()
response = urllib.request.urlopen('https://example.com', context=context)
```

Or with `requests`:

```python
import requests
requests.get('https://example.com', verify=False)
```

## Fix 5: Corporate Proxy with Self-Signed Cert

If your corporate proxy intercepts HTTPS, you need to add the proxy's CA cert to your trust store:

```python
import urllib.request
import ssl

context = ssl.create_default_context()
context.load_verify_locations('/path/to/corporate-ca.crt')  # Get from your IT
response = urllib.request.urlopen('https://example.com', context=context)
```

Or for `requests`:

```python
import requests
requests.get('https://example.com', verify='/path/to/corporate-ca.crt')
```

---

**What's your environment?** (macOS, Linux, Windows? Behind a corporate proxy?) That'll help me give you the exact command.
