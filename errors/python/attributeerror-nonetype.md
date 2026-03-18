# AttributeError on NoneType, the silent killer

> AttributeError: 'NoneType' object has no attribute 'split'

## What happened

You called a method on a variable that's `None`. You expected a string, list, or object, but somewhere upstream the value became `None` without you noticing.

## Why it happens

Something returned `None` when you expected a real value. The usual suspects:

- A function with no explicit `return` statement (Python returns `None` by default)
- `.get()` on a dict where the key doesn't exist (returns `None`)
- A regex that didn't match (`re.search()` returns `None`)
- A SQLAlchemy/Django query that found no results (`.first()` returns `None`)

The error always shows up LATER than where the actual bug is. The `None` was born 5 lines ago, you're just tripping over it now.

## How to fix it

Track down WHERE the `None` came from. Add a check before the line that fails:

```python
result = db.query(User).filter_by(email=email).first()
if result is None:
    raise ValueError(f"No user found with email: {email}")
name = result.name

# For chained calls, break them apart to find the None
config = load_config()        # could this be None?
section = config.get('db')    # could this be None?
host = section.get('host')    # this is where it blows up
```

## Don't do this

- Don't add `if x is not None` before every single attribute access. That's a code smell. Fix the root cause.
- Don't use `getattr(obj, 'split', None)` to silence the error. You're hiding a bug.

## Still not working?

If you're chaining methods like `df.groupby('col').mean().reset_index()`, one of those steps returned `None` or an unexpected type. Break the chain into separate lines and print the type at each step. In pandas, this can happen when using inplace=True (which returns `None`):

```python
# BUG: inplace=True returns None
df = df.reset_index(inplace=True)  # df is now None

# FIX: either use inplace or assignment, not both
df.reset_index(inplace=True)
# or
df = df.reset_index()
```
