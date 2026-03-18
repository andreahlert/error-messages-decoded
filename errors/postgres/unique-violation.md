# PostgreSQL unique constraint violation

> ERROR: duplicate key value violates unique constraint "users_email_key"
> DETAIL: Key (email)=(user@example.com) already exists.

## What happened

You tried to INSERT or UPDATE a row with a value that already exists in a column (or combination of columns) that has a UNIQUE constraint.

## Why it happens

Either the data genuinely has a duplicate, your application logic doesn't check for existing records before inserting, or concurrent requests created a race condition where two threads try to insert the same value simultaneously.

## How to fix it

```sql
-- Use INSERT ... ON CONFLICT to handle duplicates gracefully
INSERT INTO users (email, name) VALUES ('user@example.com', 'John')
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;

-- If you just want to skip the duplicate
INSERT INTO users (email, name) VALUES ('user@example.com', 'John')
ON CONFLICT (email) DO NOTHING;
```

In application code (Django):

```python
from django.db import IntegrityError

try:
    User.objects.create(email=email, name=name)
except IntegrityError:
    user = User.objects.get(email=email)
    user.name = name
    user.save()

# Or better, use update_or_create
user, created = User.objects.update_or_create(
    email=email,
    defaults={'name': name}
)
```

## Don't do this

- Don't drop the unique constraint to "fix" the error. The constraint exists for data integrity. Removing it means your app will silently create duplicate records.
- Don't check-then-insert without a constraint. Race conditions will still create duplicates.

## Still not working?

If the error mentions a sequence-based primary key (`_pkey`), the sequence is out of sync with the actual data. This happens after bulk imports:

```sql
-- Reset the sequence to match the current max id
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
```

For multi-column unique constraints, make sure you're handling all the columns in your ON CONFLICT clause:

```sql
-- If the constraint is on (email, org_id)
INSERT INTO users (email, org_id, name) VALUES ('a@b.com', 1, 'John')
ON CONFLICT (email, org_id) DO UPDATE SET name = EXCLUDED.name;
```
