# SQLAlchemy QueuePool limit reached

> sqlalchemy.exc.TimeoutError: QueuePool limit of size 5 overflow 10 reached, connection timed out, timeout 30.00

## What happened
Your application requested a database connection but the SQLAlchemy connection pool has no available connections and has already reached its maximum overflow limit.

## Why it happens
By default, SQLAlchemy's `QueuePool` allows 5 persistent connections (`pool_size`) and up to 10 extra overflow connections (`max_overflow`). When all 15 connections are checked out and none are returned within the timeout (30s), this error is raised. Common causes include connection leaks (not closing sessions), long-running queries blocking the pool, or stale connections that the database has already closed.

## How to fix it

Configure `create_engine` with appropriate pool settings:
```python
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql://user:pass@host/db",
    pool_size=20,
    max_overflow=30,
    pool_recycle=1800,   # recycle connections every 30 min
    pool_pre_ping=True,  # test connections before use
    pool_timeout=30,
)
```

If you do not need connection pooling (e.g., in a script or serverless function), use `NullPool`:
```python
from sqlalchemy.pool import NullPool

engine = create_engine(
    "postgresql://user:pass@host/db",
    poolclass=NullPool,
)
```

Make sure sessions are always closed:
```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    result = session.execute(query)
    # session is automatically closed when the block exits
```

## Still not working?
- Check for connection leaks: search your code for `Session()` or `engine.connect()` calls that lack a corresponding `close()` or context manager.
- Enable pool event logging: `echo_pool=True` in `create_engine` to trace checkout/checkin.
- If you have multiple workers (gunicorn, celery), remember that each worker process has its own pool. 4 workers x `pool_size=20` = 80 database connections.
