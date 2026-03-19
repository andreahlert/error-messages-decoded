**Root cause:** Matplotlib is using the `agg` backend, which is a non-interactive, file-only rendering backend. It can't display windows because there's no display server available (headless environment, SSH session, Docker container, etc.).

**Fixes (in order of preference):**

1. **Switch to an interactive backend** (before any plotting):
```python
import matplotlib
matplotlib.use('TkAgg')  # or 'Qt5Agg', 'Qt4Agg', 'wxAgg', etc.
import matplotlib.pyplot as plt
```

2. **Use inline plotting** (Jupyter notebooks):
```python
%matplotlib inline
# or for interactive notebooks:
%matplotlib widget
```

3. **Export to file instead** (if you're in a headless environment):
```python
plt.savefig('figure.png')
# don't call plt.show()
```

4. **Install a GUI backend** if missing:
```bash
# TkAgg (lightest, usually pre-installed)
pip install tk

# Or Qt5
pip install PyQt5
```

5. **Check available backends**:
```python
import matplotlib.pyplot as plt
print(matplotlib.rcsetup.all_backends)
print(matplotlib.get_backend())
```

**Why `agg` is the default:** It's set when matplotlib can't find a working display server. Common scenarios:
- Running in a container/remote server without X11 forwarding
- Headless Linux system
- CI/CD pipeline

**Best practice:** In production/automated scripts, use `savefig()` instead of `show()`. Use `show()` only for local interactive development.
