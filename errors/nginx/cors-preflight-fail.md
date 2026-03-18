# CORS preflight OPTIONS request fails

> Access to XMLHttpRequest at 'https://api.example.com/data' from origin 'https://app.example.com' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: It does not have HTTP ok status.

## What happened

The browser sent a preflight OPTIONS request before your actual API call, and the server returned a non-2xx status (often 404, 405, or 301). The browser blocks the real request because CORS preflight failed.

## Why it happens

Browsers automatically send a preflight OPTIONS request for "non-simple" requests (those with custom headers like `Authorization`, `Content-Type: application/json`, or non-GET/POST methods). Your backend or reverse proxy needs to handle OPTIONS requests explicitly and return the right CORS headers with a 200/204 status. If nginx passes the OPTIONS request to your backend and the backend doesn't handle it, you get a 404 or 405 back, which fails the preflight.

## How to fix it

**Handle OPTIONS at the nginx level before it reaches your backend:**

```nginx
location /api/ {
    # Handle preflight
    if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' 'https://app.example.com';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type';
        add_header 'Access-Control-Max-Age' 86400;
        return 204;
    }

    # Actual requests
    add_header 'Access-Control-Allow-Origin' 'https://app.example.com' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;

    proxy_pass http://backend;
}
```

Key details:
- The `always` parameter on `add_header` ensures headers are sent even on error responses (4xx, 5xx). Without it, nginx strips CORS headers on non-2xx responses.
- Return `204 No Content` for OPTIONS, not `200`. Some clients are picky about this.
- `Access-Control-Max-Age` caches the preflight result so the browser doesn't repeat it on every request.

**If your backend handles CORS itself**, make sure nginx isn't stripping or duplicating the headers:

```nginx
location /api/ {
    proxy_pass http://backend;
    # Don't add CORS headers here if the backend already does
    # Duplicate headers cause CORS failures too
}
```

## Don't do this

- Don't set `Access-Control-Allow-Origin: *` with `Access-Control-Allow-Credentials: true`. Browsers reject this combination. You must specify the exact origin when using credentials.
- Don't forget the `always` keyword on `add_header`. Without it, nginx won't send CORS headers on 4xx/5xx responses, causing confusing intermittent CORS failures.
- Don't add CORS headers in both nginx AND your backend. Duplicate `Access-Control-Allow-Origin` headers cause browsers to reject the response.
- Don't use `if` blocks in nginx for anything other than `return` or `rewrite`. The `if` for OPTIONS shown above is one of the few safe uses.

## Still not working?

Check what the browser actually receives:

```bash
# Simulate a preflight request
curl -X OPTIONS https://api.example.com/data \
  -H "Origin: https://app.example.com" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Authorization, Content-Type" \
  -v 2>&1 | grep -i "access-control\|< HTTP"
```

If you see duplicate `Access-Control-Allow-Origin` headers, CORS fails. If the status is not 2xx, the preflight fails. If `Access-Control-Allow-Headers` doesn't include all the headers your request sends, the preflight fails.

For WebSocket connections (`wss://`), CORS doesn't apply. The browser doesn't send preflight for WebSocket upgrades. If you're seeing CORS errors on WebSocket, the issue is in the initial HTTP handshake, not the WebSocket itself.
