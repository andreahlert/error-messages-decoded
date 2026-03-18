# CORS error only on POST requests with JSON

> Access to fetch at 'https://api.example.com/data' from origin 'http://localhost:3000' has been blocked by CORS policy

## What happened
GET requests work fine, but POST requests with `Content-Type: application/json` are blocked by CORS. The browser sends a preflight OPTIONS request that the server does not handle.

## Why it happens
When a request includes a non-simple header like `Content-Type: application/json`, the browser sends a preflight OPTIONS request first. If the server does not respond to OPTIONS with the correct `Access-Control-Allow-Headers` including `Content-Type`, the actual POST request is blocked.

## How to fix it
```js
// Express.js - handle OPTIONS preflight properly
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Respond to preflight
  if (req.method === 'OPTIONS') {
    return res.sendStatus(204);
  }
  next();
});

// Or use the cors middleware
const cors = require('cors');
app.use(cors({
  origin: 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
```

## Still not working?
Check if a reverse proxy (nginx, API gateway) strips the CORS headers or blocks OPTIONS requests. Verify the preflight response includes `Access-Control-Allow-Headers: Content-Type`. Use browser DevTools Network tab to inspect the OPTIONS request and its response headers.
