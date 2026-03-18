# PostgreSQL permission denied on a table

> ERROR: permission denied for table orders

## What happened

Your database user tried to SELECT, INSERT, UPDATE, or DELETE on a table it doesn't have privileges for. PostgreSQL's permission model is strict by default.

## Why it happens

The table was created by a different user (often `postgres` or a migration user), and your application user was never granted access. In PostgreSQL, creating a table doesn't automatically grant access to other users. Also, new tables created AFTER a `GRANT` don't inherit those permissions.

## How to fix it

```sql
-- Connect as the table owner or superuser, then grant access
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO myapp_user;

-- Grant on ALL existing tables in the schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myapp_user;

-- Also grant on sequences (needed for INSERT with serial/identity columns)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO myapp_user;

-- CRITICAL: set default privileges for FUTURE tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO myapp_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO myapp_user;
```

## Don't do this

- Don't make your app user a superuser. That's giving your app the keys to the kingdom.
- Don't `GRANT ALL PRIVILEGES ON DATABASE mydb TO myapp_user`. Database-level privileges don't include table access. They control things like creating schemas.

## Still not working?

Check who owns the table and what privileges exist:

```sql
-- See table owner and privileges
\dt+ orders
-- or
SELECT tableowner FROM pg_tables WHERE tablename = 'orders';

-- See all grants on the table
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'orders';
```

If you're using RDS or managed PostgreSQL, the `rds_superuser` role can grant ownership. Transfer table ownership if needed:

```sql
ALTER TABLE orders OWNER TO myapp_user;
```
