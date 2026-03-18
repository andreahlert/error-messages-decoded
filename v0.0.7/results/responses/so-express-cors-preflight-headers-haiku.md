## Root Cause

The server is sending `Access-Control-Allow-Headers` **with an invalid or empty value** in the preflight response. The browser is rejecting it because the header itself must have a proper comma-separated list of header names.

Common causes:
1. **Server echoing the request header instead of declaring allowed headers** - it's sending back the request's `Access-Control-Request-Headers` value rather than processing it
2. **Empty or malformed header value** - the value is blank, contains invalid syntax, or missing quotes
3. **Missing semicolons/commas** - values not properly separated

## How to Fix

**Server-side** (configure CORS middleware properly):

For a basic fix, ensure your server responds to `OPTIONS` requests with:

```
Access-Control-Allow-Origin: <origin>
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization, X-Custom-Header
```

**Common framework examples:**

- **Express.js** (use `cors` package):
```javascript
const cors = require('cors');
app.use(cors({
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Custom-Header']
}));
```

- **Node.js (manual)**:
```javascript
app.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', req.headers.origin);
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization,X-Custom-Header');
  res.sendStatus(200);
});
```

- **Python (Flask)**:
```python
from flask_cors import CORS
CORS(app, allow_headers=['Content-Type', 'Authorization', 'X-Custom-Header'])
```

**Client-side verification:**

Check what headers you're actually sending:
```javascript
fetch(url, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-Custom-Header': 'value'
  },
  body: JSON.stringify(data)
});
```

Then match those header names in your server's `Access-Control-Allow-Headers` response (all of them, comma-separated).
