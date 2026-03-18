# TypeError when using brackets on the wrong type

> TypeError: 'NoneType' object is not subscriptable

## What happened

You used square brackets `[0]` or `['key']` on something that doesn't support indexing. Usually it's `None` because a function returned nothing and you tried to access an element of the result.

## Why it happens

A function you expected to return a list or dict actually returned `None`. This is extremely common with functions that modify in place and return nothing:

```python
my_list = [3, 1, 2]
sorted_list = my_list.sort()  # .sort() returns None, sorts in place
print(sorted_list[0])         # TypeError: 'NoneType' is not subscriptable
```

Same thing with `.append()`, `.update()`, `.extend()`, and many other in-place methods.

## How to fix it

```python
# Use sorted() which returns a new list
sorted_list = sorted(my_list)
print(sorted_list[0])

# Or sort in place and use the original
my_list.sort()
print(my_list[0])
```

For the general case, check what the function actually returns:

```python
result = some_function()
print(type(result), result)  # Debug: see what you're working with
if result is not None:
    print(result[0])
```

## Don't do this

- Don't wrap everything in `try/except TypeError`. That hides the real bug, which is that your function returned an unexpected value.
- Don't add `or []` everywhere (`result = func() or []`). It masks the problem and makes debugging harder later.

## Still not working?

The error also triggers with `int`, `float`, or `bool` objects. If you see `'int' object is not subscriptable`, you probably reassigned a variable that was a list to a number somewhere above. Search for places where the variable gets assigned and trace the flow.

For type hint issues in Python < 3.9 (`list[int]` instead of `List[int]`), add `from __future__ import annotations` at the top of the file.
