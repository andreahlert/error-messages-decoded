## Root Cause

CORS (Cross-Origin Resource Sharing) blocks Axios requests when your frontend (running on one origin like `http://localhost:3000`) makes a request to an API on a different origin (different domain, port, or protocol). The browser enforces this security policy, not the server. The error occurs because the API server isn't explicitly allowing requests from your origin.

## How to Fix

### Option 1: Enable CORS on Your Backend (Recommended)

If you control the API server, add CORS headers:

**Express.js:**
```javascript
const cors = require('cors');
app.use(cors({
  origin: 'http://localhost:3000', // or your frontend URL
  credentials: true
}));
```

**Other Node frameworks:** Use the `cors` package similarly.

**Python (Flask):**
```python
from flask_cors import CORS
CORS(app, origins=['http://localhost:3000'])
```

### Option 2: Configure Axios with Credentials

If the API already allows CORS, ensure Axios sends credentials:

```javascript
axios.get('/api/endpoint', {
  withCredentials: true
})
```

### Option 3: Use a Proxy (Development Only)

In `package.json`:
```json
{
  "proxy": "http://localhost:5000"
}
```

Then call `/api/endpoint` instead of `http://localhost:5000/api/endpoint`. This only works in development with `create-react-app`.

### Option 4: Nginx Reverse Proxy

In production, put Nginx in front of both frontend and API:
```nginx
location /api/ {
  proxy_pass http://api-server:5000;
}
```

Now both serve from the same origin.

---

**Key point:** CORS failures mean your backend isn't configured to accept requests from your frontend's origin. Fix it at the source (backend), not by bypassing security.
