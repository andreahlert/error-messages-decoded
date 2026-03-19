## Root Cause

Python 3 removed **implicit relative imports** and requires **explicit relative imports**. In Python 2, `import module` inside a package would check for a relative module first. In Python 3, it only looks for absolute imports, causing `ImportError` if the module isn't in `sys.path`.

## Common Scenarios & Fixes

### **1. Implicit to Explicit Relative Imports**

**❌ Python 2 style (fails in Python 3):**
```python
# mypackage/submodule.py
import utils  # Looks for absolute 'utils', not relative
```

**✅ Python 3 fix:**
```python
# mypackage/submodule.py
from . import utils  # Explicit relative import
from .utils import some_function  # Relative from same package
from ..sibling import something  # Go up one level
```

### **2. Missing `__init__.py`**

Ensure all directories are valid packages:
```
mypackage/
├── __init__.py      # ← Must exist
├── module_a.py
└── subdir/
    ├── __init__.py  # ← Must exist for relative imports to work
    └── module_b.py
```

### **3. Module Name Conflicts**

If you have a local `utils.py` and try `from . import utils`, verify there's no file with the same name as a standard library module in your path.

### **4. Running as Script Instead of Module**

**❌ This fails:**
```bash
python mypackage/submodule.py
```

**✅ Do this instead:**
```bash
python -m mypackage.submodule
```

Or import it from a main script in the parent directory.

---

**What's your directory structure and the exact import statement that's failing?** I can give you the exact fix.
