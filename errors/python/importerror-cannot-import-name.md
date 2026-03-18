# ImportError on a name that definitely exists

> ImportError: cannot import name 'Celery' from 'celery'

## What happened

Python found the module but couldn't find the specific name you tried to import from it. The module loaded, the name just wasn't there.

## Why it happens

Three common causes, in order of likelihood:

1. **You have a local file shadowing the real package.** A file named `celery.py` in your project directory gets imported instead of the installed `celery` library.
2. **Circular import.** Module A imports from module B, which imports from module A. At import time, module A isn't fully initialized yet, so the name doesn't exist.
3. **Version mismatch.** The name was added in a newer version, renamed, or removed in the version you have installed.

## How to fix it

```bash
# Check if you have a local file shadowing the package
python -c "import celery; print(celery.__file__)"

# If it prints YOUR file path instead of site-packages, rename your file
mv celery.py my_celery.py

# If it's a version issue, check what you have
pip show celery

# Then upgrade
pip install --upgrade celery
```

**Trap: Circular imports.** This is the hardest case to diagnose because the traceback points to a valid import from a real module. Module A imports from B, B imports from A. When Python is still executing A's top-level code, A's namespace is incomplete, so B can't find the name. The fix is lazy imports (move the import inside the function that uses it):

```python
# Bad: top-level circular import
from myapp.models import User  # fails if models.py imports from this module

# Good: lazy import inside the function
def get_user():
    from myapp.models import User
    return User.objects.get(...)
```

Alternatively, extract the shared code into a third module that both A and B import from.

## Don't do this

- Don't blindly `pip install --force-reinstall`. If the problem is a local file shadow, reinstalling changes nothing.
- Don't add `sys.path` hacks. That's duct tape over a real problem.

## Still not working?

```bash
# Check what names are actually available in the module
python -c "import celery; print(dir(celery))"
```

If the output is suspiciously short, you're almost certainly importing a shadow file or hitting a circular import. Check for `__pycache__` folders with stale `.pyc` files from a renamed shadow file and delete them.
