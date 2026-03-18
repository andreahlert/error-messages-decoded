# ValueError when unpacking the wrong number of values

> ValueError: too many values to unpack (expected 2)

## What happened

You tried to unpack an iterable into fewer variables than it has elements. Something like `a, b = [1, 2, 3]` where Python has 3 values but only 2 targets.

## Why it happens

The structure of the data doesn't match your unpacking pattern. Common cases: splitting a string that has more delimiters than expected, iterating over a dict and unpacking wrong, or a function returning more values than you thought.

```python
# This line works for "key=value" but breaks on "key=val=ue"
key, value = line.split('=')  # 3 parts, 2 variables
```

## How to fix it

```python
# Use maxsplit to limit the number of splits
key, value = line.split('=', maxsplit=1)

# Use * to capture the rest
first, *rest = my_list
head, *middle, tail = my_list

# For dict iteration, .items() gives tuples
for key, value in my_dict.items():  # not just: for key, value in my_dict
    print(key, value)
```

When the data is unpredictable, check the length first:

```python
parts = line.split(',')
if len(parts) == 3:
    name, age, city = parts
else:
    print(f"Unexpected format: {line!r}")
```

## Don't do this

- Don't just add more variables to match (`a, b, c, d = ...`). The real problem is that your data is inconsistent and you need to handle that.
- Don't silently slice to force it: `a, b = data[:2]` throws away data without you knowing.

## Still not working?

The reverse error, `not enough values to unpack (expected 3, got 2)`, means the iterable is shorter than expected. Same root cause: data inconsistency.

If this happens in a loop processing lines from a file, one line is formatted differently (empty lines, headers, trailing newlines). Print the repr of the failing line:

```python
for i, line in enumerate(lines):
    parts = line.strip().split(',')
    if len(parts) != 3:
        print(f"Line {i}: {line!r} -> {parts}")
        continue
    a, b, c = parts
```
