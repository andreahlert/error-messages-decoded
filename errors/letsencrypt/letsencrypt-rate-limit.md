# Let's Encrypt rate limit on certificate issuance

> too many certificates already issued for exact set of domains

## What happened
Let's Encrypt refused to issue a new certificate because you have hit the rate limit for the exact set of domains in your certificate request.

## Why it happens
Let's Encrypt enforces a rate limit of 5 duplicate certificates per week for the exact same set of domain names. If you ran `certbot` multiple times (perhaps due to failed deployments, testing, or automation issues), you may have issued 5 certificates for the same domains within 7 days. This is a duplicate certificate limit, separate from the 50 certificates per registered domain per week limit.

## How to fix it

Check your existing certificates to see what was issued:
```bash
# Check certificates issued for your domain
# Visit: https://crt.sh/?q=yourdomain.com

# Check local certificates
sudo certbot certificates
```

Use the staging environment for testing to avoid hitting rate limits:
```bash
# Test with staging (not rate-limited, but certificates are not trusted)
sudo certbot certonly --staging -d yourdomain.com

# Once confirmed working, run without --staging for production
sudo certbot certonly -d yourdomain.com
```

If you already have a valid certificate, renew instead of requesting new:
```bash
# Renew existing certificate (does not count toward duplicate limit)
sudo certbot renew

# Force renewal of a specific certificate
sudo certbot renew --cert-name yourdomain.com --force-renewal
```

## Still not working?
- The duplicate certificate rate limit resets after 7 days. You can check exact reset times at https://crt.sh for your domain.
- Renewal of an existing certificate does not count as a new issuance. Use `certbot renew` instead of `certbot certonly`.
- If you need more certificates during development, always use `--staging` first.
- Consider using a wildcard certificate (`*.yourdomain.com`) to cover all subdomains with a single certificate.
- The 50 per week limit is per registered domain (e.g., `example.com`), not per subdomain. Adding different subdomains to each request counts toward this broader limit.
