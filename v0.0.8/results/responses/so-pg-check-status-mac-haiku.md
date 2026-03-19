Looking at your question, "How to check status of PostgreSQL server Mac OS X" isn't actually an error message—it sounds like a Stack Overflow question title. But I'll help you diagnose if PostgreSQL is running and fix any issues.

## Root Cause
You likely need to verify PostgreSQL is running, or it's not running when you expect it to be.

## How to Check & Fix on macOS

**1. Using Homebrew (most common install method):**
```bash
brew services list
```
Look for `postgresql` in the output. Shows `started` or `stopped`.

**2. Start/stop PostgreSQL:**
```bash
brew services start postgresql@15  # or your version
brew services stop postgresql@15
brew services restart postgresql@15
```

**3. Check if PostgreSQL process is running:**
```bash
ps aux | grep postgres
```

**4. Use PostgreSQL's connection check utility:**
```bash
pg_isready
```
Returns `accepting connections` if running, `rejecting connections` if not.

**5. Try connecting directly:**
```bash
psql -U postgres
```
If it connects, PostgreSQL is running. If it fails, it's not.

## If PostgreSQL Isn't Installed
```bash
brew install postgresql@15
brew services start postgresql@15
```

## If It's Installed but Won't Start
- Check logs: `brew services log postgresql@15`
- Verify data directory exists: `~/Library/Application Support/Postgres/var-*`
- Reset: `rm -rf ~/Library/Application\ Support/Postgres/var-* && brew services restart postgresql@15`

Which specific issue are you hitting—PostgreSQL won't start, won't connect, or you just need to check the status?
