# Node 18 fetch fails with self-signed certificate

> TypeError: fetch failed
>   cause: Error: UNABLE_TO_VERIFY_LEAF_SIGNATURE

## What happened
Node 18+ native fetch rejected a TLS connection because the server uses a self-signed or corporate CA certificate that is not in Node's default trust store.

## Why it happens
Node's native fetch uses the built-in OpenSSL CA bundle and does not trust custom or corporate CA certificates by default. Behind a corporate proxy with TLS inspection, the proxy's CA cert is not recognized.

## How to fix it
```bash
# Point Node to your corporate/custom CA certificate bundle
export NODE_EXTRA_CA_CERTS=/path/to/corporate-ca-bundle.crt

# Run your app with the CA certs
NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem node app.js
```

## Still not working?
If you don't have the CA certificate file, export it from your browser or ask your IT department. On macOS, you can extract system certificates with `security find-certificate -a -p /Library/Keychains/System.keychain > ca-bundle.crt`. Make sure `NODE_EXTRA_CA_CERTS` points to a PEM file, not DER format.
