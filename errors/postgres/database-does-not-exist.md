# PostgreSQL can't find your database

> FATAL: database "myapp_development" does not exist

## What happened

You tried to connect to a database that doesn't exist on this PostgreSQL server. The server is running fine, it just doesn't have a database with that name.

## Why it happens

The database was never created, you have a typo in the name, or you're connecting to the wrong PostgreSQL instance (local vs Docker vs remote). Also common after a fresh PostgreSQL install or server migration.

## How to fix it

```bash
# List existing databases
psql -U postgres -l

# Create the missing database
createdb -U postgres myapp_development

# Or with specific owner
createdb -U postgres -O myapp_user myapp_development
```

Or in SQL:

```sql
CREATE DATABASE myapp_development OWNER myapp_user;
```

For Rails, Django, or similar frameworks:

```bash
# Rails
rails db:create

# Django (won't auto-create, use psql or this)
python manage.py migrate  # only works if the DB exists

# Create it first
sudo -u postgres createdb myapp_development
```

## Don't do this

- Don't connect as `postgres` superuser in your application to avoid this error. Create the database properly and use a dedicated app user.
- Don't use `template0` or `template1` as your application database.

## Still not working?

Check your connection string carefully:

```bash
# Common issues in DATABASE_URL
# Wrong: postgres://user:pass@localhost/MyApp  (case matters!)
# Right: postgres://user:pass@localhost/myapp

# Check if you're hitting the right PostgreSQL instance
psql -U postgres -c "SHOW data_directory;"
```

If you're using Docker, make sure the volume wasn't wiped:

```bash
docker volume ls
docker exec my-postgres psql -U postgres -l
```

For managed databases (RDS, Cloud SQL), you usually need to create the database through the cloud console or API, not just with `createdb`.
