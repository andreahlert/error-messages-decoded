# PostgreSQL can't find your column

> ERROR: column "username" does not exist
> LINE 1: SELECT username FROM users;

## What happened

PostgreSQL doesn't recognize the column name in your query. But nine times out of ten, the column exists and the problem is something else entirely.

## Why it happens

The #1 cause: you used double quotes when you meant single quotes.

```sql
-- WRONG: PostgreSQL thinks "John" is a column name
SELECT * FROM users WHERE name = "John";

-- RIGHT: single quotes for string values
SELECT * FROM users WHERE name = 'John';
```

Other causes: the column was created with double quotes making it case-sensitive (`"Username"` vs `username`), you're querying the wrong table, or a migration hasn't run.

## How to fix it

```sql
-- Check what columns actually exist
\d users
-- or
SELECT column_name FROM information_schema.columns
WHERE table_name = 'users';

-- Use single quotes for string values, always
SELECT * FROM users WHERE name = 'John';

-- If the column is case-sensitive (created with quotes), match exactly
SELECT "Username" FROM users;
```

## Don't do this

- Don't create columns with double-quoted mixed-case names. `CREATE TABLE t ("firstName" text)` forces you to always quote it. Use `first_name` instead.
- Don't alias with column names that collide with PostgreSQL reserved words without quoting them.

## Still not working?

If you're using an ORM and the column exists in the database but the error fires:

```bash
# Django: make sure your model matches the actual schema
python manage.py inspectdb | grep -A 20 "class User"

# SQLAlchemy: check your model definition matches the table
```

If the column was just added in a migration that hasn't been applied to this database:

```bash
python manage.py migrate        # Django
alembic upgrade head             # Alembic
```

For computed queries, remember that column aliases from SELECT aren't available in WHERE:

```sql
-- WRONG: can't use alias in WHERE
SELECT first_name || ' ' || last_name AS full_name FROM users WHERE full_name = 'John Doe';

-- RIGHT: repeat the expression or use a subquery
SELECT * FROM (
    SELECT *, first_name || ' ' || last_name AS full_name FROM users
) t WHERE full_name = 'John Doe';
```
