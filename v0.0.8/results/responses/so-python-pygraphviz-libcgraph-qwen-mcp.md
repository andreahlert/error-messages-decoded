The error message "pip install pygraphviz: No package 'libcgraph' found" indicates that the `pygraphviz` package, which depends on the `libcgraph` library, cannot be installed because the required library was not found via pip.

### Root Cause:
1. **Missing Library**: The `libcgraph` library is a dependency of `pygraphviz`. If this library is missing or not properly installed, `pip` will fail to install `pygraphviz`.

2. **System Libraries**: `libcgraph` is typically part of the system libraries on Unix-based systems (Linux and macOS). It's important that these libraries are available in your system’s package manager.

### Steps to Fix:

#### 1. Check if `libcgraph` is Installed:
   - On Linux, you can check if `libcgraph` is installed by running:
     ```bash
     dpkg -l libcgraph | grep '^ii'
     ```
   - If it's not installed, you'll need to install it using your package manager (e.g., `apt-get`, `yum`, etc.).

#### 2. Install Required Libraries:
   - On Linux, you can usually install the required libraries by running:
     ```bash
     sudo apt-get update && sudo apt-get install libgraphviz-dev
     ```
   - For macOS, use Homebrew to install it:
     ```bash
     brew install graphviz
     ```

#### 3. Reinstall `pygraphviz`:
   - Once the required libraries are installed, you can reinstall `pygraphviz` using pip:
     ```bash
     pip uninstall pygraphviz
     pip install pygraphviz
     ```

### Additional Tips:

- **Virtual Environment**: If you're working in a virtual environment, ensure that it's activated before running these commands.
  ```bash
  source venv/bin/activate  # For Python 3.x
  or
  . venv/bin/activate       # For Python 2.x
  ```

- **Environment Variables**: Ensure your system’s `LD_LIBRARY_PATH` is set correctly. This can be done by adding the directory containing `libcgraph` to your environment variables.

### Example:
If you're using a Debian-based distribution (like Ubuntu), you might need to install it via:
```bash
sudo apt-get update && sudo apt-get install libgraphviz-dev
```

By following these steps, you should be able to resolve the issue and successfully install `pygraphviz` on your system.
