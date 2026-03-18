# SSL certificate error in nginx

> nginx: [emerg] SSL_CTX_use_certificate_chain: error:0B080074:x509 certificate routines:X509_check_private_key:key values mismatch
> nginx: [emerg] cannot load certificate "/etc/ssl/certs/server.crt": BIO_new_file() failed (SSL: error:02001002:system library:fopen:No such file or directory)

## What happened

Nginx can't start because the SSL certificate is misconfigured. Either the cert file is missing, the private key doesn't match the certificate, or the cert chain is incomplete.

## Why it happens

- Certificate and private key don't match (most common after cert renewal)
- Certificate file path is wrong
- The cert chain is in the wrong order
- File permissions prevent nginx from reading the cert

## How to fix it

**Verify the cert and key match:**

```bash
# These two commands should output the same hash
openssl x509 -noout -modulus -in /etc/ssl/certs/server.crt | openssl md5
openssl rsa -noout -modulus -in /etc/ssl/private/server.key | openssl md5
```

If they don't match, you have the wrong key for that certificate. Re-download or regenerate.

**Check the certificate chain order:**

```bash
# The cert file should contain: your cert first, then intermediates
# NOT the root CA
cat server.crt intermediate.crt > fullchain.crt
```

```nginx
ssl_certificate /etc/ssl/certs/fullchain.crt;
ssl_certificate_key /etc/ssl/private/server.key;
```

**Fix file permissions:**

```bash
sudo chmod 644 /etc/ssl/certs/server.crt
sudo chmod 600 /etc/ssl/private/server.key
sudo chown root:root /etc/ssl/private/server.key
```

**If using Let's Encrypt:**

```nginx
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```

## Don't do this

- Don't `chmod 777` your private key. Anyone on the system can read it.
- Don't concatenate the root CA into the cert chain. Browsers already have it; including it can cause validation issues.

## Still not working?

- Test your full SSL config: `openssl s_client -connect yourdomain.com:443 -servername yourdomain.com`
- Check if the cert has expired: `openssl x509 -enddate -noout -in /etc/ssl/certs/server.crt`
- If using certbot, run `certbot renew --dry-run` to check renewal works.
- Validate the chain at [SSL Labs](https://www.ssllabs.com/ssltest/).
