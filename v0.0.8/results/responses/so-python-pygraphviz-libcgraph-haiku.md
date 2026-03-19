**Root cause:** `pygraphviz` is a Python wrapper around the GraphViz C library. It needs the system library `libcgraph` (part of GraphViz) plus development headers. `pip` can't compile the Python bindings without them.

**Fix (Fedora — your OS based on kernel version):**

```bash
sudo dnf install graphviz graphviz-devel
pip install pygraphviz
```

**For other systems:**
- **Ubuntu/Debian**: `sudo apt-get install graphviz graphviz-dev`
- **macOS**: `brew install graphviz`

The `graphviz-devel` (or `-dev`) package provides the headers that the pip build needs to compile the C extension.
