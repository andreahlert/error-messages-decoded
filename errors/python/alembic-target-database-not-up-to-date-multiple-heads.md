# Alembic target database not up to date with multiple heads

> alembic.util.exc.CommandError: Target database is not up to date.

## What happened
Alembic cannot run a migration because the database's current revision does not match what Alembic expects. This often happens when there are multiple heads (branch points) in the migration history.

## Why it happens
When multiple developers create migrations independently from the same parent revision, Alembic ends up with multiple heads (branches). The `alembic upgrade head` command fails because there is no single "head" to target. It can also happen when someone manually changed the `alembic_version` table or skipped a migration.

## How to fix it

Check the current state:
```bash
# Show current revision in the database
alembic current

# Show all heads
alembic heads

# Show full history
alembic history --verbose
```

If there are multiple heads, merge them:
```bash
# Create a merge migration
alembic merge heads -m "merge branches"

# Then upgrade
alembic upgrade head
```

If the database revision is out of sync, stamp it to the correct revision:
```bash
# Check what revision the database thinks it's at
alembic current

# If it's wrong, stamp it to the actual state
alembic stamp <correct_revision_id>

# Then upgrade from there
alembic upgrade head
```

## Still not working?
- Check the `alembic_version` table directly: `SELECT * FROM alembic_version;`
- If the table has multiple rows, that indicates multiple active branches. Delete the stale ones and keep only the correct current revision.
- Use `alembic history --indicate-current` to see where your database sits in the migration graph.
- If the migration files were deleted but the database still references them, stamp to a known good revision: `alembic stamp <known_good_rev>`.
