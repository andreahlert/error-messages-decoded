# Unexpected token '<' when loading JavaScript

> Uncaught SyntaxError: Unexpected token '<'

## What happened
The browser tried to parse an HTML document as JavaScript. Instead of receiving a JS file, the server returned an HTML page (usually a 404 page or the SPA's `index.html`).

## Why it happens
A script tag references a JS file path that the server does not serve correctly. In SPAs with client-side routing, the server returns `index.html` for all routes. If the JS file path is relative and the route changes, the browser requests the wrong URL, gets HTML back, and tries to parse it as JS. This also happens with incorrect MIME types or 404 fallback configurations.

## How to fix it
```html
<!-- Use absolute paths for script tags -->
<script src="/static/js/bundle.js"></script>
<!-- NOT relative paths -->
<!-- <script src="static/js/bundle.js"></script> -->
```

```js
// For React/CRA, set homepage in package.json
// "homepage": "/"

// For Vite, set base in vite.config.js
// export default { base: '/' }

// nginx - serve SPA with proper fallback
// location / {
//   try_files $uri $uri/ /index.html;
// }
// location /static/ {
//   # Serve static files directly, no fallback to index.html
// }
```

## Still not working?
Check the Network tab in DevTools to see what the server actually returns for the JS file URL. Verify the Content-Type header is `application/javascript`, not `text/html`. If using a CDN, purge the cache. Check that your build output directory matches your server's static file configuration.
