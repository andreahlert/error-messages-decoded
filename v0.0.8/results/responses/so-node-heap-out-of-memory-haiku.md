The **"Node.js heap out of memory"** error occurs when the JavaScript process exhausts available memory. Here are the specific root causes and fixes:

## Root Causes

1. **Memory leak** - Objects referenced but never released (most common)
   - Unclosed event listeners, timers, or database connections
   - Circular references or objects retained in closures
   - Growing caches without eviction

2. **Large data structures** - Processing huge arrays/strings/objects in memory
   - Large file uploads/downloads
   - Unreasonable data fetches without pagination or streaming

3. **Default heap limit too low** - Node.js default is ~1.5GB on 64-bit systems

4. **Child processes** - Multiple spawned processes consuming cumulative memory

## Specific Fixes

### Quick diagnostic
```bash
# Find what's consuming memory (requires debugging setup)
node --inspect index.js
# Then use Chrome DevTools chrome://inspect to profile heap

# Or use clinic.js
npx clinic doctor -- node index.js
```

### Immediate solutions

**1. Increase heap size** (temporary, treats symptom not cause)
```bash
node --max-old-space-size=4096 index.js  # 4GB
```

**2. Use streaming for large data**
```javascript
// ❌ Bad - loads entire file in memory
const data = fs.readFileSync('huge-file.csv');

// ✅ Good - streams data in chunks
fs.createReadStream('huge-file.csv')
  .pipe(csvParser())
  .on('data', row => processRow(row));
```

**3. Fix memory leaks**
```javascript
// ❌ Bad - listener accumulates forever
emitter.on('event', handler);

// ✅ Good - clean up listeners
emitter.on('event', handler);
// Later:
emitter.off('event', handler);
```

**4. Implement pagination**
```javascript
// ❌ Bad - loads all records
const users = await db.find({});

// ✅ Good - fetch in batches
const users = await db.find({}).limit(100).skip(offset);
```

**5. Use worker threads or child processes** for CPU-heavy tasks to separate memory contexts

### For your specific case
If this is for the **error-messages-decoded** project documentation, mention that **the fix depends on the cause** - heap limits are a band-aid; the real issue is usually memory leaks or inefficient data handling. Developers should profile with Chrome DevTools or clinic.js to identify what's actually consuming memory.

What's your specific context - are you experiencing this in your code, or documenting it?
