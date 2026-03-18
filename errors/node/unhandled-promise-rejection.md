# UnhandledPromiseRejectionWarning

> (node:12345) UnhandledPromiseRejectionWarning: Error: connect ECONNREFUSED 127.0.0.1:5432
>     at TCPConnectWrap.afterConnect [as oncomplete] (node:net:1187:16)
> (node:12345) UnhandledPromiseRejectionWarning: Unhandled promise rejection. This error originated
> either by throwing inside of an async function without a catch block, or by rejecting a promise
> which was not handled with .catch().
> (node:12345) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the
> future, promise rejections that are not handled will terminate the Node.js process.

## What happened

An async operation failed and nothing in your code caught the error. Node is warning you now, but in Node 15+ this crashes the process with exit code 1.

## Why it happens

A Promise rejected and there was no `.catch()` handler or `try/catch` around an `await`. The actual bug is whatever caused the rejection (database down, API timeout, bad input). The "unhandled" part means your code doesn't account for failure in that code path.

## How to fix it

Find the actual failing promise (the stack trace tells you) and add error handling:

```javascript
// WRONG - no error handling on async call
app.get('/users', async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  res.json(users);
});

// RIGHT - catch the error
app.get('/users', async (req, res, next) => {
  try {
    const users = await db.query('SELECT * FROM users');
    res.json(users);
  } catch (err) {
    next(err);  // let Express error handler deal with it
  }
});

// WRONG - fire-and-forget promise
fetchData();

// RIGHT
fetchData().catch(err => console.error('fetchData failed:', err));
```

Add a global safety net (this is a backup, not a fix):

```javascript
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  // In production, log to your error tracker, then exit gracefully
});
```

## Don't do this

**Don't add a global `unhandledRejection` handler and call it done.** That's a smoke detector with the battery pulled out. Fix the actual promise chain.

**Don't add empty `.catch(() => {})` to silence the warning.** You're swallowing errors. When the database is down, your app will silently return wrong results instead of erroring.

## Still not working?

If you can't find which promise is rejecting, Node 16+ shows better stack traces:

```bash
# Run with async stack traces
node --async-stack-traces server.js
```

In Express, every async route handler needs error handling. Use a wrapper to avoid repetition:

```javascript
const asyncHandler = (fn) => (req, res, next) =>
  Promise.resolve(fn(req, res, next)).catch(next);

app.get('/users', asyncHandler(async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  res.json(users);
}));
```

Express 5 handles async errors natively. If you're on Express 4, the wrapper above is your best option.
