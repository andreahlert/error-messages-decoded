# "Cannot find module" in Node.js — Root Causes & Fixes

## Root Causes

1. **Module not installed** — dependency missing from `node_modules/`
2. **Typo in require path** — wrong module name or file path
3. **Wrong path resolution** — relative path pointing to wrong location
4. **Missing file extension** — Node sometimes can't auto-resolve
5. **ES module/CommonJS mismatch** — importing ESM in CommonJS or vice versa
6. **Incorrect package.json main field** — points to non-existent file
7. **Relative path going outside project** — `../../../` reaching above node_modules

---

## Specific Fixes

### 1. **Install Missing Module**
```bash
npm install module-name
# or if it's a dev dependency
npm install --save-dev module-name
```
Check if it's listed in `package.json` after install.

### 2. **Fix Typo or Path**
```javascript
// Wrong
require('expresss');  // typo
require('./models');  // missing /index.js or missing .js extension

// Right
require('express');
require('./models/index.js');  // or just require('./models') if index.js exists
```

### 3. **Check Your Working Directory**
The `require()` path is relative to **where you run the script**, not where the file is. Use `__dirname` to make it absolute:
```javascript
// Wrong (breaks if script runs from different directory)
require('./config.js');

// Right
require(require('path').join(__dirname, 'config.js'));
// or
require('./config.js');  // only if you always run from same dir
```

### 4. **Add File Extension if Auto-Resolution Fails**
```javascript
require('./mymodule.js');  // explicit .js
// instead of:
require('./mymodule');  // Node can't find it
```

### 5. **ESM/CommonJS Mismatch**
```javascript
// If importing an ES module in CommonJS:
// ❌ Won't work
const stuff = require('esm-package');

// ✅ Use dynamic import or convert package to CommonJS
import('esm-package').then(stuff => { ... });
```

### 6. **Verify package.json main Field**
```json
{
  "main": "dist/index.js"  // ensure this file exists
}
```

### 7. **Reinstall node_modules**
Sometimes cache corruption causes issues:
```bash
rm -rf node_modules package-lock.json
npm install
```

---

## Quick Diagnosis

When you see the error, it usually shows the full path Node tried:
```
Error: Cannot find module './models'
```

**Use this checklist:**
- [ ] Does `node_modules/module-name/` exist?
- [ ] Is the path relative to `__dirname` or current working directory?
- [ ] Did you run `npm install` after modifying `package.json`?
- [ ] Does the file actually exist at that path?
- [ ] Are you mixing ES modules with CommonJS require?
