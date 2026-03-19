## Root Cause

PostgreSQL server isn't running or isn't listening on the expected connection endpoint (host/port/socket). After a crash or reboot, the server often doesn't auto-start, or the database is in recovery mode.

## How to Fix

**1. Check if PostgreSQL is running:**
```bash
# Linux/Mac
ps aux | grep postgres

# Or use systemctl (if installed as service)
sudo systemctl status postgresql
```

**2. Start PostgreSQL:**
```bash
# Linux (systemd)
sudo systemctl start postgresql

# Mac (Homebrew)
brew services start postgresql

# Docker
docker start <container-name>

# Manual (if running from source)
pg_ctl -D /path/to/data/directory start
```

**3. Verify connection works:**
```bash
psql -U postgres -h localhost -p 5432
```

**4. If it won't start, check for:**
- **Corrupted data directory** after crash: Check log file at `/var/log/postgresql/` or `$PGDATA/postgresql.log`
- **Postmaster lock file stale**: Remove `/var/lib/postgresql/postmaster.pid` (if you're sure no process is running)
- **Port already in use**: `lsof -i :5432` to find what's using port 5432
- **Missing/corrupted WAL files**: May need recovery or data directory reset

**5. Connection string check:**
Ensure your app is connecting to the right host/port. Check:
```ruby
# Rails
ENV['DATABASE_URL']  # or config/database.yml

# General
hostname: localhost (or 127.0.0.1)
port: 5432 (default)
```

For Rails specifically, after fixing the server, run `rails db:create` if needed.
