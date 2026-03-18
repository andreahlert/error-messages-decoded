# Content Security Policy blocks inline script

> Refused to execute inline script because it violates the following Content Security Policy directive: script-src

## What happened
The browser blocked an inline `<script>` tag or inline event handler because the page's Content Security Policy (CSP) does not allow inline scripts.

## Why it happens
CSP's `script-src` directive controls which scripts can execute. By default, when `script-src` is set, inline scripts are blocked unless explicitly allowed. This is a security feature that prevents XSS attacks. The CSP header or meta tag on the page does not include a mechanism to allow your specific inline script.

## How to fix it

Use a nonce to allow specific inline scripts:
```html
<!-- Server generates a random nonce per request -->
<meta http-equiv="Content-Security-Policy"
  content="script-src 'nonce-abc123def456'">

<script nonce="abc123def456">
  console.log('This is allowed');
</script>
```

Server-side (e.g., Express):
```javascript
const crypto = require('crypto');

app.use((req, res, next) => {
    const nonce = crypto.randomBytes(16).toString('base64');
    res.locals.nonce = nonce;
    res.setHeader('Content-Security-Policy',
        `script-src 'nonce-${nonce}' 'strict-dynamic'`);
    next();
});
```

Or use a SHA-256 hash of the script content:
```bash
# Generate the hash
echo -n 'console.log("hello")' | openssl dgst -sha256 -binary | openssl base64
# Output: abc123...
```

```html
<meta http-equiv="Content-Security-Policy"
  content="script-src 'sha256-abc123...'">

<script>console.log("hello")</script>
```

Use `strict-dynamic` to allow scripts loaded by trusted scripts:
```
Content-Security-Policy: script-src 'nonce-abc123' 'strict-dynamic'
```

## Still not working?
- Inline event handlers (`onclick`, `onload`) are also blocked by CSP. Move them to `.addEventListener()` in an external or nonced script.
- `'strict-dynamic'` propagates trust: if a nonced script loads another script via `document.createElement('script')`, that script is also trusted.
- Never use `'unsafe-inline'` as a blanket fix as it defeats the purpose of CSP.
- Test your CSP with `Content-Security-Policy-Report-Only` header first to see what would be blocked without actually blocking it.
