# 413 Request Entity Too Large

> 413 Request Entity Too Large
> nginx/1.x.x

## What happened

The client sent a request body (usually a file upload) that exceeds nginx's maximum allowed size. Nginx rejected it before it even reached your backend.

## Why it happens

Nginx defaults `client_max_body_size` to 1MB. Any upload or POST body larger than that gets a 413 before your application code ever sees it.

## How to fix it

**Increase `client_max_body_size` in your nginx config:**

```nginx
# In the http block (applies globally)
http {
    client_max_body_size 50M;
}

# Or in a specific server block
server {
    client_max_body_size 50M;
}

# Or only for upload endpoints
location /upload {
    client_max_body_size 100M;
    proxy_pass http://backend;
}
```

**Then reload nginx:**

```bash
sudo nginx -t && sudo nginx -s reload
```

Set it to `0` to disable the limit entirely (not recommended for production).

## Don't do this

- Don't set it to `0` (unlimited) in production. You're opening yourself up to abuse. Someone can send a 10GB request and eat your disk/memory.
- Don't only change it in your app config (like Express's `bodyParser.limit`). If nginx sits in front, it rejects the request before your app sees it.
- Don't forget to also update your backend's body size limit. If nginx allows 50MB but Express only accepts 1MB, you'll get a different error.

## Still not working?

- Make sure you edited the right nginx config file. Run `nginx -T` to see the full effective configuration.
- If behind a load balancer or CDN (CloudFlare, AWS ALB), they might have their own body size limits. CloudFlare free tier limits to 100MB.
- Check if `proxy_request_buffering` is off. When off, nginx streams the body, which can behave differently.
