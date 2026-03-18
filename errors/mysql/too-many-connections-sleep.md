# Too many connections (connection pool leak)

> ERROR 1040 (HY000): Too many connections

## What happened

MySQL has reached its maximum number of allowed connections. New connections are being refused. When you check the process list, most connections are in `Sleep` state, meaning they're open but idle, not doing any work.

## Why it happens

This is almost always a connection pool leak in your application code. Connections are being opened (or borrowed from the pool) but never released back. Over time, the pool runs out and new requests open direct connections until MySQL's hard limit is hit.

Typical causes:

- ORM or query code that opens a connection but doesn't close it when an exception occurs
- Missing `.release()` or `.close()` calls on connections borrowed from a pool
- Connection pool size set too high across multiple app instances (5 instances x 30 pool size = 150 connections)
- Long `wait_timeout` keeping dead connections alive (default is 8 hours)
- A connection leak where connections are created outside the pool

148 out of 150 connections in `Sleep` state is the telltale sign. Healthy apps have most connections in `Sleep` but the count stays stable, not growing.

## How to fix it

**Step 1: Confirm the leak by checking connection states:**

```sql
-- See all connections and their state
SHOW PROCESSLIST;

-- Count connections per state
SELECT command, COUNT(*) as count
FROM information_schema.processlist
GROUP BY command
ORDER BY count DESC;

-- Count connections per user/host (find the leaky app)
SELECT user, host, db, COUNT(*) as count
FROM information_schema.processlist
WHERE command = 'Sleep'
GROUP BY user, host, db
ORDER BY count DESC;

-- Check how long sleeping connections have been idle
SELECT id, user, host, db, time AS seconds_idle
FROM information_schema.processlist
WHERE command = 'Sleep'
ORDER BY time DESC
LIMIT 20;
```

**Step 2: Kill the leaked connections to restore access immediately:**

```sql
-- Kill connections sleeping for more than 5 minutes
SELECT CONCAT('KILL ', id, ';')
FROM information_schema.processlist
WHERE command = 'Sleep' AND time > 300;

-- Run the output, or use a stored procedure
-- Quick one-liner from bash:
mysql -e "SELECT id FROM information_schema.processlist WHERE command='Sleep' AND time > 300" -sN | \
  while read id; do mysql -e "KILL $id"; done
```

**Step 3: Set a reasonable wait_timeout to auto-kill idle connections:**

```sql
-- Set to 5 minutes instead of the default 8 hours
SET GLOBAL wait_timeout = 300;
SET GLOBAL interactive_timeout = 300;

-- Make it permanent in my.cnf / mysqld.cnf
-- [mysqld]
-- wait_timeout = 300
-- interactive_timeout = 300
```

**Step 4: Fix the application-level leak:**

```python
# Python (SQLAlchemy): use context managers to ensure connections are returned
from sqlalchemy import create_engine

engine = create_engine(
    "mysql://user:pass@host/db",
    pool_size=10,          # max connections in pool
    max_overflow=5,        # extra connections allowed temporarily
    pool_recycle=300,      # recycle connections after 5 min
    pool_pre_ping=True     # test connections before using
)

# Always use context manager
with engine.connect() as conn:
    result = conn.execute(text("SELECT 1"))
    # connection returned to pool automatically, even on exception
```

```javascript
// Node.js (mysql2): always release connections
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  database: 'mydb',
  connectionLimit: 10,
  waitForConnections: true,
  queueLimit: 0
});

// Always release in a finally block
async function query(sql) {
  const conn = await pool.getConnection();
  try {
    return await conn.query(sql);
  } finally {
    conn.release();  // MUST happen even on error
  }
}
```

```java
// Java (HikariCP): set leak detection
HikariConfig config = new HikariConfig();
config.setMaximumPoolSize(10);
config.setLeakDetectionThreshold(30000);  // warn if connection not returned in 30s
config.setConnectionTimeout(5000);
config.setIdleTimeout(300000);
```

## Don't do this

- Don't increase `max_connections` as the first response. Each MySQL connection uses 10-20MB of RAM. Going from 150 to 500 means 5-7GB more memory, and you're just delaying the crash. The leak is still there.
- Don't set `wait_timeout = 10` or something very low. Connection pools rely on keeping idle connections ready. Too-low timeouts cause "MySQL server has gone away" errors.
- Don't create new connections per query without a pool. Use a connection pool and fix the release logic.

## Still not working?

Monitor connection count over time to confirm it's a leak (growing) vs. legitimate load (stable at high count):

```sql
-- Check current vs max
SHOW VARIABLES LIKE 'max_connections';
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Max_used_connections';
```

If `Max_used_connections` equals `max_connections`, you've been hitting the limit. If `Threads_connected` keeps growing over hours without dropping, it's a leak.

For multi-instance deployments, calculate total connections:

```
Total connections = (instances) x (pool_size + max_overflow)
Leave headroom for admin connections: max_connections = Total + 10
```

Reserve an admin connection that always works even when the limit is hit:

```bash
# Connect using the reserved super user connection
mysql -u root -p --protocol=tcp
# Then kill the leaked connections from here
```
