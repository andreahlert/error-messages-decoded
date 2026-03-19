## Root Cause

CORS (Cross-Origin Resource Sharing) is a browser security feature that **blocks requests from one origin to a different origin** unless the destination server explicitly allows it. When your React app at `localhost:3000` tries to fetch from a different origin (e.g., `localhost:5000`, `api.example.com`), the browser checks the response headers. If the server doesn't include CORS headers allowing `localhost:3000`, the browser blocks it.

## How to Fix

**Option 1: Add CORS headers to your backend** (recommended)

Your API server needs to respond with CORS headers. The solution depends on your backend:

**Node.js/Express:**
```javascript
const cors = require('cors');
app.use(cors({
  origin: 'http://localhost:3000',
  credentials: true
}));
```

**Python/Flask:**
```python
from flask_cors import CORS
CORS(app, resources={r"/api/*": {"origins": "http://localhost:3000"}})
```

**Python/FastAPI:**
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Option 2: Use a proxy in development** (React only)

In your `package.json`, add:
```json
"proxy": "http://localhost:5000"
```

Then change your fetch URLs to relative paths: `fetch('/api/data')` instead of `fetch('http://localhost:5000/api/data')`. This only works during development with `npm start`.

**Option 3: Configure the request manually**

If you can't modify the server, add `credentials` and check if the server supports it:
```javascript
fetch(url, {
  credentials: 'include',
  headers: { 'Content-Type': 'application/json' }
})
```

---

**Which approach:** If you control the backend (Option 1), that's the proper fix. If you're just testing locally, the proxy (Option 2) is quickest.
