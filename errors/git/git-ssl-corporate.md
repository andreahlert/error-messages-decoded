# Git SSL certificate problem with corporate proxy

> SSL certificate problem: unable to get local issuer certificate

## What happened
Git cannot verify the SSL certificate of the remote server because the CA certificate chain is incomplete or uses a corporate proxy's self-signed certificate.

## Why it happens
Corporate environments often use TLS inspection proxies that intercept HTTPS traffic with their own CA certificate. Your system's certificate store does not include this corporate CA, so Git (and curl/OpenSSL underneath) cannot verify the certificate chain. This is also common when using self-hosted Git servers with internal CAs.

## How to fix it

Add the corporate CA certificate to Git's trusted certificates:
```bash
# Get the corporate CA certificate (ask your IT department or extract it)
# Then point Git to it:
git config --global http.sslCAInfo /path/to/corporate-ca.pem

# Or add it to the system certificate store:
# Ubuntu/Debian
sudo cp corporate-ca.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

# RHEL/CentOS/Fedora
sudo cp corporate-ca.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
```

Set the CA path for Git:
```bash
git config --global http.sslCAPath /etc/ssl/certs/
```

Extract the certificate from the proxy if you do not have it:
```bash
echo | openssl s_client -connect github.com:443 -showcerts 2>/dev/null | \
  openssl x509 -outform PEM > corporate-ca.pem
```

## Still not working?
- If behind multiple proxy layers, you may need the full certificate chain (intermediate + root CA).
- On macOS, export the certificate from Keychain Access and pass it via `GIT_SSL_CAINFO`.
- For a specific repository only: `git config http.sslCAInfo /path/to/ca.pem` (without `--global`).
- As an absolute last resort for testing only (never in production): `git config --global http.sslVerify false`.
