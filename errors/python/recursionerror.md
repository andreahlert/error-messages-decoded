# RecursionError blows up the call stack

> RecursionError: maximum recursion depth exceeded

## What happened

A function called itself (directly or through a chain of other calls) roughly 1000 times without ever reaching a base case that stops the recursion. Python killed it before it ate all your memory.

## Why it happens

Either the base case in your recursive function is wrong and never triggers, or you have accidental infinite recursion. The sneaky version: `__repr__` or `__str__` methods that reference objects referencing each other, property setters that accidentally call themselves, or `__getattr__` that triggers itself.

```python
# Classic accident in __setattr__
class Foo:
    def __setattr__(self, name, value):
        self.data = value  # <- calls __setattr__ again. Boom.
```

## How to fix it

```python
# Fix the base case in recursive functions
def factorial(n):
    if n <= 1:        # base case must actually be reachable
        return 1
    return n * factorial(n - 1)

# For __setattr__, use the parent class directly
class Foo:
    def __setattr__(self, name, value):
        super().__setattr__(name, value)  # no recursion
```

If you genuinely need deep recursion (parsing deeply nested data):

```python
import sys
sys.setrecursionlimit(5000)  # default is 1000
```

But usually the right move is to rewrite it iteratively with a stack/queue.

## Don't do this

- Don't set the recursion limit to 999999. You'll get a segfault instead of a clean error when the OS stack overflows. That's worse, not better.
- Don't ignore it and "just increase the limit." Find out WHY it's recursing that deep.

## Still not working?

Use `traceback` to see the repeating call pattern:

```python
import traceback
try:
    your_function()
except RecursionError:
    traceback.print_exc()
```

Look for the repeating cycle of 2-3 function names. That tells you exactly where the loop is. For dataclass or Pydantic models with circular references, use `repr=False` on the field causing the cycle.
