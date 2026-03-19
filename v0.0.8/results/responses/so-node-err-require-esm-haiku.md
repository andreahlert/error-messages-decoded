## Root Cause

node-fetch v3 is **ESM-only** (no CommonJS export). When your CommonJS project tries to `require()` it, Node.js rejects it because `require()` can't load ES modules directly.

## How to Fix

Choose one approach:

### **Option 1: Downgrade (Quickest)**
```bash
npm install node-fetch@2
```
node-fetch v2 supports CommonJS. Use this if you can't change your module system.

---

### **Option 2: Switch to ESM (Best)**
Update `package.json`:
```json
{
  "type": "module"
}
```
Then change your import:
```javascript
import fetch from 'node-fetch';
```
This requires converting other `require()` statements to `import` throughout your project.

---

### **Option 3: Dynamic Import (Middle Ground)**
Keep CommonJS, use async import:
```javascript
const fetch = (await import('node-fetch')).default;
```
Wrap this in an async function. This avoids converting the whole project but keeps v3.

---

### **Option 4: Use a Different HTTP Client**
Switch to a CommonJS-compatible alternative:
```bash
npm install axios
# or
npm install got@12  # got@13+ is ESM-only
```

---

**Recommendation:** If this is a new/active project, go with **Option 2 (ESM)**. If legacy/constrained, use **Option 1 (downgrade)**.
