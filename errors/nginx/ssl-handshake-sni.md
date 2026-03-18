# SSL handshake failure with SNI mismatch

> SSL: error:14094410:SSL routines:ssl3_read_bytes:sslv3 alert handshake failure

## What happened

The SSL/TLS handshake between the client and Nginx failed. The client requested a hostname via SNI (Server Name Indication), but Nginx couldn't match it to a server block with a valid certificate for that domain.

## Why it happens

When multiple HTTPS server blocks share the same IP and port, Nginx uses SNI to determine which server block (and certificate) to use. The handshake fails when:

- The requested domain has no matching `server_name` directive in any HTTPS server block
- The `default_server` block doesn't have a valid catch-all certificate
- The correct server block exists but its certificate doesn't cover the requested domain (wrong cert, missing SAN)
- Nginx processes server blocks in a different order than expected, and the wrong block catches the request first

SNI happens before HTTP, so Nginx must pick the right certificate based solely on the hostname. If it picks the wrong one, the client rejects it immediately.

## How to fix it

Check which certificate Nginx is actually serving for the domain:

```bash
# Test SNI: see what cert Nginx returns for a specific hostname
openssl s_client -connect your-server:443 -servername example.com 2>/dev/null | \
  openssl x509 -noout -subject -issuer -dates

# Compare with another domain on the same IP
openssl s_client -connect your-server:443 -servername other-domain.com 2>/dev/null | \
  openssl x509 -noout -subject -issuer -dates
```

Make sure each domain has a server block with correct `server_name` and matching cert:

```nginx
# /etc/nginx/conf.d/example.com.conf
server {
    listen 443 ssl;
    server_name example.com www.example.com;

    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # ... your config
}
```

Add a `default_server` that catches unmatched SNI requests and rejects them cleanly:

```nginx
# /etc/nginx/conf.d/00-default-ssl.conf
server {
    listen 443 ssl default_server;
    server_name _;

    # Self-signed or catch-all cert (prevents leaking other domains' certs)
    ssl_certificate     /etc/nginx/ssl/default.crt;
    ssl_certificate_key /etc/nginx/ssl/default.key;

    return 444;  # Drop connection
}
```

Generate the default self-signed cert:

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/default.key \
  -out /etc/nginx/ssl/default.crt \
  -subj "/CN=_"
```

Test the config and reload:

```bash
nginx -t && nginx -s reload
```

Verify it works:

```bash
curl -vI https://example.com 2>&1 | grep "SSL connection"
```

## Don't do this

- Don't just renew the certificate. If the cert doesn't match the `server_name` or is on the wrong server block, renewing changes nothing.
- Don't use a single wildcard cert across all server blocks as a shortcut. It couples all domains to one cert lifecycle and won't work across different base domains.
- Don't remove `default_server`. Without it, Nginx uses the first server block in alphabetical file order as the default, which causes unpredictable cert selection.

## Still not working?

Check if all your server blocks are actually being loaded:

```bash
# List all server blocks Nginx knows about
nginx -T 2>/dev/null | grep -E "server_name|ssl_certificate|listen.*443"
```

Verify the certificate covers the right domains:

```bash
# Check all SANs (Subject Alternative Names) in the cert
openssl x509 -in /etc/letsencrypt/live/example.com/fullchain.pem -noout -text | \
  grep -A1 "Subject Alternative Name"
```

If you're behind a load balancer or CDN (CloudFlare, AWS ALB), the SSL termination may happen there, not at Nginx. Check whether the LB is forwarding HTTPS or terminating it.

For HTTP/2 with multiple certs, make sure your OpenSSL version supports ALPN:

```bash
openssl version  # Needs 1.0.2+ for ALPN
nginx -V 2>&1 | grep -o "built with.*"
```
