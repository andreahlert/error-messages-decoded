# Port already in use EADDRINUSE

> Error: listen EADDRINUSE: address already in use :::3000
>     at Server.setupListenHandle [as _listen2] (node:net:1372:16)
>     at listenInCluster (node:net:1420:12)
>     at Server.listen (node:net:1508:7)

## What happened

You tried to start a server on port 3000 (or any port) but something else is already listening there. Usually a previous instance of your own app that didn't shut down cleanly.

## Why it happens

A process is bound to that port. TCP ports are exclusive: only one process can listen on a given port at a time. Common causes: you hit Ctrl+C but the process didn't exit (nodemon sometimes does this), you have two terminal tabs running the same server, or a background process (Docker container, another app) is using that port.

## How to fix it

```bash
# Find what's using port 3000
lsof -i :3000

# Kill it by PID (replace 12345 with actual PID from above)
kill 12345

# If it won't die
kill -9 12345

# One-liner: find and kill whatever is on port 3000
lsof -ti :3000 | xargs kill -9
```

On Windows:

```powershell
netstat -ano | findstr :3000
taskkill /PID 12345 /F
```

## Don't do this

**Don't just change the port every time.** You'll end up with `PORT=3001`, then `3002`, with zombie processes on each port.

**Don't add `process.exit()` at the top of your server file.** That's not how any of this works.

## Still not working?

If you're running inside Docker and the port is mapped:

```bash
# Check Docker containers using the port
docker ps | grep 3000
docker stop <container_id>
```

Add graceful shutdown to prevent this from happening:

```javascript
const server = app.listen(3000);

process.on('SIGTERM', () => server.close());
process.on('SIGINT', () => server.close());
```

If the port is in TIME_WAIT state (recently freed), you can reuse it:

```javascript
const server = require('http').createServer(app);
server.listen(3000);
// SO_REUSEADDR is set by default in Node, so TIME_WAIT
// shouldn't be an issue. If you still see it, just wait 30-60 seconds.
```

Use port 0 to let the OS assign a free port (useful for tests):

```javascript
const server = app.listen(0, () => {
  console.log(`Listening on port ${server.address().port}`);
});
```
