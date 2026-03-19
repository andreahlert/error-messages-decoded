# UnhandledPromiseRejectionWarning: Root Cause & Fix

**Root cause**: A Promise is rejected (throws an error or calls `reject()`), but no error handler (`.catch()` or try/catch in async/await) is attached to it.

## How to Identify the Source

1. **Check the stack trace** — Node.js will print where the rejection occurred
2. **Add a global handler** to catch all unhandled rejections:

```javascript
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  console.error(reason.stack); // Shows the stack trace
});
```

3. **Look for patterns**:
   - Promises created but not awaited
   - `.then()` chains without `.catch()` at the end
   - Async functions called without `await`

## How to Fix It

**Option 1: Add `.catch()` handler**
```javascript
// Bad
somePromise.then(result => doSomething(result));

// Good
somePromise
  .then(result => doSomething(result))
  .catch(error => console.error('Error:', error));
```

**Option 2: Use try/catch with async/await** (preferred)
```javascript
async function myFunction() {
  try {
    const result = await somePromise;
    doSomething(result);
  } catch (error) {
    console.error('Error:', error);
  }
}
```

**Option 3: Await promises instead of fire-and-forget**
```javascript
// Bad
somePromise.then(...); // Unhandled if it rejects

// Good
await somePromise;
```

**Option 4: If you intentionally don't care about the result, explicitly ignore it**
```javascript
somePromise.catch(() => {}); // Intentionally swallow the error
```

The most common cause is forgetting a `.catch()` on a Promise chain or not awaiting an async function. Use the global handler above to pinpoint exactly which Promise is rejecting.
