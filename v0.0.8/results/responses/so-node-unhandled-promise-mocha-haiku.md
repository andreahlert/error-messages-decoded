# Root Cause

The error occurs when a **promise rejects but nothing handles it**, and the test completes before Node.js can process the rejection. Mocha doesn't automatically catch unhandled rejections.

## Common Scenarios & Fixes

### 1. **Missing `return` in test (Most Common)**
```javascript
// ❌ WRONG - promise completes after test finishes
it('should do something', () => {
  myAsyncFunction().then(result => {
    expect(result).to.equal('value');
  });
});

// ✅ CORRECT
it('should do something', () => {
  return myAsyncFunction().then(result => {
    expect(result).to.equal('value');
  });
});
```

### 2. **Using `async/await` without proper error handling**
```javascript
// ❌ WRONG - rejection happens after test completes
it('should do something', async () => {
  myAsyncFunction(); // missing await
});

// ✅ CORRECT
it('should do something', async () => {
  await myAsyncFunction(); // await the promise
});
```

### 3. **Promise rejection in async test without try/catch**
```javascript
// ❌ WRONG - unhandled rejection
it('should handle rejection', async () => {
  await myAsyncFunction(); // throws but test doesn't catch
});

// ✅ CORRECT - expect the rejection
it('should handle rejection', async () => {
  try {
    await myAsyncFunction();
    expect.fail('Should have thrown');
  } catch (error) {
    expect(error.message).to.include('expected error');
  }
});

// ✅ OR use Chai expect with rejection
it('should handle rejection', () => {
  return expect(myAsyncFunction()).to.be.rejectedWith('expected error');
});
```

### 4. **Callback test not handling async rejection**
```javascript
// ❌ WRONG - promise rejection ignored
it('should do something', (done) => {
  myAsyncFunction().then(result => {
    expect(result).to.equal('value');
    done();
  });
  // Missing .catch() - rejection crashes test
});

// ✅ CORRECT
it('should do something', (done) => {
  myAsyncFunction()
    .then(result => {
      expect(result).to.equal('value');
      done();
    })
    .catch(done); // Pass rejection to done()
});
```

## Quick Checklist

- [ ] All promises in tests have `.catch()` or `try/catch`
- [ ] All `async` functions are `await`-ed
- [ ] All promise chains have `return` statement
- [ ] Callback tests pass errors to `done(error)`

The fix is almost always: **return your promises or await them properly**.
