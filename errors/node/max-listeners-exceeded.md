# MaxListenersExceededWarning (EventEmitter memory leak)

> MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit

## What happened

An EventEmitter has more than 10 listeners registered for the same event. Node.js warns you because this almost always means listeners are being added repeatedly without being removed, which is a memory leak.

## Why it happens

The most common pattern is adding event listeners inside a function that runs multiple times, like an HTTP request handler or a loop:

```javascript
// This leaks: every request adds another listener
app.get('/data', (req, res) => {
  db.on('error', (err) => console.log(err));  // never removed
  // ...
});
```

Other causes:

- Registering listeners in a `setInterval` callback
- Adding listeners to a shared/global emitter inside a function called per-request
- Creating streams in a loop and attaching listeners without cleanup
- Hot module reloading in development re-registering listeners on each reload

After enough iterations, you have hundreds of identical listeners consuming memory and potentially firing duplicate callbacks.

## How to fix it

**Use `.once()` for listeners that should fire only once:**

```javascript
// Instead of .on(), use .once() - automatically removed after first call
db.once('error', (err) => console.log(err));
```

**Remove listeners in cleanup:**

```javascript
function handleRequest(req, res) {
  const onError = (err) => {
    res.status(500).send('DB error');
  };

  db.on('error', onError);

  // Clean up when the request ends
  res.on('finish', () => {
    db.removeListener('error', onError);
  });
}
```

**Use AbortController for streams and fetch (Node 16+):**

```javascript
const controller = new AbortController();

const stream = createReadStream(file, { signal: controller.signal });
stream.on('data', processChunk);

// Cleanup: abort removes all listeners automatically
setTimeout(() => controller.abort(), 5000);
```

**Move listener registration outside the repeated code path:**

```javascript
// Bad: inside the route handler
app.get('/data', (req, res) => {
  process.on('uncaughtException', handler);  // leak!
});

// Good: register once at startup
process.on('uncaughtException', handler);
app.get('/data', (req, res) => {
  // handle request
});
```

**Find the leak** by tracing where listeners are added:

```javascript
// Temporarily enable stack traces for the warning
process.on('warning', (warning) => {
  console.warn(warning.stack);
});
```

Or use the `--trace-warnings` flag:

```bash
node --trace-warnings app.js
```

## Don't do this

- Don't call `emitter.setMaxListeners(0)` or `setMaxListeners(Infinity)`. This silences the warning but the leak continues. Memory usage will grow unbounded and callbacks will fire multiple times.
- Don't call `emitter.removeAllListeners()` as a band-aid. Other parts of your code may have legitimate listeners that you're nuking.
- Don't ignore this warning in production. What starts as a warning becomes an out-of-memory crash under load.

## Still not working?

If you can't find where the listeners are being added, inspect them at runtime:

```javascript
// List all listeners for an event
console.log(emitter.listeners('error'));
console.log(emitter.listenerCount('error'));

// List all event names with listeners
console.log(emitter.eventNames());
```

For Express/Koa apps, the culprit is often middleware that attaches listeners to `req` or `res` objects from a shared emitter. Check middleware that wraps database connections, Redis clients, or WebSocket connections.

If this happens only in development with hot reload (webpack-dev-server, nodemon), it's often harmless but you can fix it:

```javascript
// Guard against re-registration during hot reload
if (!process.listeners('uncaughtException').find(fn => fn.name === 'myHandler')) {
  process.on('uncaughtException', function myHandler(err) { /* ... */ });
}
```
