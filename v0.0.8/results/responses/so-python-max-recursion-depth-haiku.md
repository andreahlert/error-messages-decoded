## Root Cause

Python has a default recursion limit (~1000 on most systems) to prevent stack overflow. When a function calls itself (directly or indirectly), it consumes stack memory. Without a limit, infinite recursion would crash the interpreter.

You hit this when:
- **Infinite recursion**: bug in your base case (missing or wrong condition)
- **Deep recursion**: legitimate deep call chain (100+ levels) that exceeds the limit

## How to Fix

### 1. Fix the Root Cause First (Recommended)

Look for bugs in your recursive function:

```python
# BAD - no base case
def count(n):
    return count(n - 1)  # RecursionError!

# GOOD - has proper base case
def count(n):
    if n <= 0:
        return 0
    return count(n - 1)
```

Or convert to iteration:
```python
# Better - no recursion at all
def count(n):
    result = 0
    for i in range(n):
        result += 1
    return result
```

### 2. Temporarily Increase the Limit

If your recursion is legitimate and deep, increase it:

```python
import sys
sys.setrecursionlimit(10000)  # increase from default ~1000
```

**Important caveats:**
- Setting it too high can still cause stack overflow and crash Python
- Check your actual depth needs first: `sys.getrecursionlimit()`
- This is a band-aid, not a solution

### 3. Check Your Current Limit

```python
import sys
print(sys.getrecursionlimit())  # usually 1000
```

### 4. Use Memoization (For Recursive Algorithms)

```python
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

This reduces redundant calls and depth needed.

## Best Practice

**Avoid recursion for deep operations.** Use iteration, generators, or libraries designed for it. Recursion in Python is slow and limited—it's not idiomatic for most problems.

What's your specific use case? I can suggest a better approach if needed.
