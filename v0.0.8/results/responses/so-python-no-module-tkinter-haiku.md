# Root Cause

**Python 3 renamed the module from `Tkinter` to `tkinter`** (lowercase). If you're using Python 3 and importing with capital `T`, it fails.

Additionally, Tkinter is **not bundled by default** on Linux and some other systems, so it must be installed separately.

# How to Fix

**Check your Python version first:**
```bash
python --version
```

## If Python 3 (most common):

**Change your import:**
```python
# Wrong (Python 2 syntax):
import Tkinter

# Correct (Python 3):
import tkinter
```

If Tkinter still isn't found after fixing the import, **install it**:

**Linux (Debian/Ubuntu):**
```bash
sudo apt-get install python3-tk
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install python3-tkinter
```

**macOS:**
```bash
brew install python-tk
```

**Windows:** Tkinter should be included with Python. Reinstall Python and make sure to check "tcl/tk and IDLE" during setup.

## If Python 2:

Install with:
```bash
sudo apt-get install python-tk  # Debian/Ubuntu
sudo dnf install tkinter        # Fedora/RHEL
```

---

**Quick test** to verify it works:
```python
import tkinter
root = tkinter.Tk()
root.withdraw()
print("Tkinter works!")
```
