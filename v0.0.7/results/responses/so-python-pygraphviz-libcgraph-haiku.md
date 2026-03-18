**Root Cause:** pygraphviz is a Python wrapper around the Graphviz C library. When pip tries to compile it, it needs the Graphviz development headers. Your system has Graphviz installed but not the `libcgraph` development package that the C compiler needs.

**Fix (Fedora 43):** Install the Graphviz development headers:

```bash
sudo dnf install graphviz-devel
```

Then retry:
```bash
pip install pygraphviz
```

**Why this happens:** pygraphviz isn't a pure Python package—it's a C extension that wraps Graphviz's C API. The `libcgraph` library and its headers are part of `graphviz-devel`, not the base `graphviz` package. Your system has the runtime library but not the headers needed for compilation.
