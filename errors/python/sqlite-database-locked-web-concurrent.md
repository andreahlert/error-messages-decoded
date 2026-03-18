# SQLite database is locked with concurrent web access

> sqlite3.OperationalError: database is locked

## What happened
Multiple threads or processes tried to write to the same SQLite database simultaneously and one was blocked for longer than the timeout period.

## Why it happens
SQLite uses file-level locking for writes. Only one writer can access the database at a time. In a web application with concurrent requests, multiple threads or processes competing for write access will cause "database is locked" errors, especially with the default journal mode.

## How to fix it

Enable WAL (Write-Ahead Logging) mode which allows concurrent readers with one writer:
```python
import sqlite3

conn = sqlite3.connect('mydb.sqlite')
conn.execute('PRAGMA journal_mode=WAL;')
conn.execute('PRAGMA busy_timeout=5000;')  # wait up to 5 seconds
```

Or set it once from the command line:
```bash
sqlite3 mydb.sqlite "PRAGMA journal_mode=WAL;"
```

Set a busy timeout so writes wait instead of failing immediately:
```python
conn = sqlite3.connect('mydb.sqlite', timeout=10)  # 10 second timeout
```

Ensure each thread uses its own connection (not shared across threads):
```python
import threading

local = threading.local()

def get_connection():
    if not hasattr(local, 'conn'):
        local.conn = sqlite3.connect('mydb.sqlite')
        local.conn.execute('PRAGMA journal_mode=WAL;')
        local.conn.execute('PRAGMA busy_timeout=5000;')
    return local.conn
```

## Still not working?
- For high-concurrency web applications, SQLite is not the right choice. Migrate to PostgreSQL which handles concurrent access natively.
- If you must use SQLite, serialize all writes through a single connection with a queue/lock.
- Check if another process (DB browser, backup script) has the database file open with an exclusive lock.
- Avoid long-running transactions: commit as quickly as possible to release the write lock.
