# KeyError on a key you're sure exists

> KeyError: 'username'

## What happened

You accessed a dictionary with `d['username']` and the key wasn't there. Python doesn't guess or return a default with bracket syntax.

## Why it happens

The key genuinely doesn't exist. Common reasons: a typo (`'user_name'` vs `'username'`), the data came from an API/JSON and the field is sometimes missing, or the dictionary was modified between when you checked and when you accessed it.

Sneaky cause: the key has invisible whitespace. `'username '` (with a trailing space) is a different key than `'username'`.

## How to fix it

```python
# Use .get() with a default value
name = data.get('username', 'anonymous')

# Or check first
if 'username' in data:
    name = data['username']

# Debug: see what keys actually exist
print(data.keys())

# Check for whitespace issues
print(repr(list(data.keys())))  # repr() shows hidden chars
```

For nested dicts (like JSON API responses):

```python
# Instead of data['user']['profile']['name'] which can fail at any level
name = data.get('user', {}).get('profile', {}).get('name', 'default')
```

## Don't do this

- Don't wrap every dict access in `try/except KeyError`. It makes the code unreadable and hides bugs where a key is missing due to real problems upstream.
- Don't use `defaultdict` everywhere as a band-aid. It creates keys on access, which can mask bugs.

## Still not working?

If you're getting a KeyError in pandas (`KeyError: 'column_name'`), it's a different situation. Check your column names:

```python
print(df.columns.tolist())
# Common issue: extra spaces from CSV headers
df.columns = df.columns.str.strip()
```

If the error is in a loop, print the problematic key and the dict contents right before the failing line to see exactly what's going on.
