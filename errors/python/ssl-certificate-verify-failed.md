# SSL certificate verification failed

> ssl.SSLCertVerificationError: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1007)

## What happened

Python tried to make an HTTPS request and couldn't verify the server's SSL certificate. The certificate chain is incomplete or your system's CA bundle is missing/outdated.

## Why it happens

On macOS with a fresh Python install from python.org, the certificates aren't installed by default. On Linux, a corporate proxy doing SSL interception (MITM) presents its own cert that isn't in Python's trust store. On older systems, the CA bundle is simply outdated.

## How to fix it

```bash
# macOS: run the certificate installer that ships with Python
/Applications/Python\ 3.x/Install\ Certificates.command
# or
pip install --upgrade certifi

# Linux: update the CA certificates
sudo apt update && sudo apt install ca-certificates  # Debian/Ubuntu
sudo update-ca-certificates

# Check what cert bundle Python is using
python -c "import certifi; print(certifi.where())"
```

**Trap: Corporate proxy CA certificates.** If you're behind a corporate proxy that does SSL inspection (MITM), the proxy re-signs all HTTPS traffic with its own CA certificate. Your OS may trust it (IT installed it system-wide), but Python's `certifi` bundle doesn't. This is why `curl` works but Python fails. You need to add the corporate CA to Python's trust store:

```bash
# Export the proxy's CA cert (get it from IT or your browser)
# Then add it to certifi's bundle
cat corporate-ca.pem >> $(python -c "import certifi; print(certifi.where())")

# Or set the env var to point to your system bundle (which includes the corporate CA)
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# pip also needs it
export PIP_CERT=/etc/ssl/certs/ca-certificates.crt
```

Note: `pip install --upgrade certifi` will overwrite your additions. Re-append the corporate CA after upgrading certifi, or use the env var approach instead.

## Don't do this

- `verify=False` in requests or `ssl._create_unverified_context()`. You're disabling security entirely, and it will end up in production. It always does.
- `PYTHONHTTPSVERIFY=0`. Same thing but worse because it affects ALL Python HTTPS calls.

## Still not working?

If it only fails for one specific domain:

```bash
# Check the certificate chain
openssl s_client -connect example.com:443 -showcerts </dev/null 2>/dev/null

# If the chain is incomplete, it's a server-side problem, not yours
# If you must work around it, download the intermediate cert and add it
```

In Docker containers, install `ca-certificates` in your Dockerfile. The minimal base images don't include them:

```dockerfile
RUN apt-get update && apt-get install -y ca-certificates
```
