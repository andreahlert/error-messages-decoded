The **root cause** is Node.js hitting its default heap memory limit (typically ~1-2GB depending on your system). When your application needs more memory than this, it crashes with "JavaScript heap out of memory".

**How to fix** - set NODE_OPTIONS before running your app. Choose based on your environment:

**Local development (one-off):**
```bash
NODE_OPTIONS="--max-old-space-size=2048" node your-app.js
# or npm
NODE_OPTIONS="--max-old-space-size=2048" npm start
```

**In your shell profile** (~/.bashrc, ~/.zshrc, etc.):
```bash
export NODE_OPTIONS="--max-old-space-size=2048"
```
Then reload: `source ~/.bashrc`

**In .env file** (if using dotenv):
```
NODE_OPTIONS=--max-old-space-size=2048
```
Then load it before starting: `source .env && npm start`

**In package.json scripts:**
```json
{
  "scripts": {
    "start": "NODE_OPTIONS='--max-old-space-size=2048' node index.js",
    "build": "NODE_OPTIONS='--max-old-space-size=4096' next build"
  }
}
```

**In Docker:**
```dockerfile
ENV NODE_OPTIONS="--max-old-space-size=2048"
```

**In CI/CD** (GitHub Actions, etc.):
```yaml
- name: Run app
  env:
    NODE_OPTIONS: "--max-old-space-size=2048"
  run: npm start
```

The value (2048) is in MB. Adjust based on your available memory. Check current heap usage with `node --max-old-space-size=2048 -e "console.log(require('v8').getHeapSpaceStatistics())"`.
