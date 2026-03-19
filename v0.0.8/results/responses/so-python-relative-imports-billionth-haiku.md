# Root Cause

Python **can't resolve relative imports in the `__main__` module** (the script you run directly). When you do `python script.py`, that module doesn't have a package context, so statements like `from . import foo` fail with `ImportError: attempted relative import in non-package`.

# The Fix

**Use `python -m` to run as a package module instead of a direct script:**

```bash
# ❌ Wrong - runs as __main__, breaks relative imports
python script.py

# ✅ Right - runs within package context
python -m package.script
```

**Requirements for this to work:**
1. Your script must be in a package directory with `__init__.py`
2. Run from the parent directory of the package
3. Use absolute imports in your actual code: `from package.module import thing`

**Example structure:**
```
myproject/
├── __init__.py
├── main.py         (uses: from . import helper)
└── helper.py
```

Run as: `python -m myproject.main`

**Alternative: Use absolute imports throughout** (works both ways):
```python
# In main.py - works whether run as __main__ or imported
from myproject.helper import something
```

The `python -m` approach is preferred because it runs your module properly within the package namespace.
