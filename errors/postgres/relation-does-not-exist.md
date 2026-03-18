# PostgreSQL says your table doesn't exist (but it does)

> ERROR: relation "users" does not exist
> LINE 1: SELECT * FROM users;

## What happened

PostgreSQL can't find the table, view, or sequence you referenced. It either truly doesn't exist, or it exists in a different schema than the one you're searching.

## Why it happens

The table is in a non-default schema (like `public` vs `myapp`), you connected to the wrong database, the table was created with quotes making the name case-sensitive (`"Users"` vs `users`), or migrations haven't been run yet.

## How to fix it

```sql
-- Check which database you're connected to
SELECT current_database();

-- List all tables across all schemas
SELECT schemaname, tablename FROM pg_tables WHERE tablename LIKE '%user%';

-- If it's in a different schema, qualify the name
SELECT * FROM myapp.users;

-- Or set the search path
SET search_path TO myapp, public;

-- If the table was created with quotes (case-sensitive)
SELECT * FROM "Users";  -- must match exact case
```

If the table genuinely doesn't exist, run your migrations:

```bash
# Django
python manage.py migrate

# Alembic/SQLAlchemy
alembic upgrade head

# Raw SQL
psql -U myuser -d mydb -f schema.sql
```

**Trap: schema-qualified names and `search_path`.** If your table lives in a non-`public` schema and you query it without qualification (`SELECT * FROM users` instead of `SELECT * FROM myapp.users`), Postgres only searches schemas listed in `search_path`. ORMs like Django or SQLAlchemy may create tables in `public` while your app connects with a `search_path` that doesn't include it, or vice versa. Always check and set `search_path` explicitly:

```sql
-- See what Postgres is actually searching
SHOW search_path;

-- Fix it for the session
SET search_path TO myapp, public;

-- Fix it permanently for a role
ALTER ROLE myuser SET search_path TO myapp, public;
```

## Don't do this

- Don't create tables with double-quoted names (`CREATE TABLE "MyTable"`). You'll be forced to quote them forever. Use lowercase with underscores.
- Don't run migrations against the wrong database. Double-check your DATABASE_URL.
- Don't assume `public` is always in `search_path`. Some managed Postgres setups or multi-tenant apps change this.

## Still not working?

If you're using connection pooling (PgBouncer), make sure you're connecting to the right database. PgBouncer's `*` database routing can send you somewhere unexpected.

```sql
-- Check your search_path
SHOW search_path;

-- See all schemas
SELECT schema_name FROM information_schema.schemata;
```
