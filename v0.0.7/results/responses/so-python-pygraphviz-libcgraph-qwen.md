The error message "pip install pygraphviz: No package 'libcgraph' found" indicates that the `pygraphviz` package, which depends on the `libcgraph` library, cannot be installed because the required system library is not available via pip.

### Root Cause:
1. **Missing System Library**: The `libcgraph` library is a part of the Graphite project and is typically used for graph visualization in Python. If this library is missing or not properly installed on your system, it will prevent you from installing `pygraphviz`.

2. **Dependency Issue**: The `pygraphviz` package depends on `libcgraph`, but pip cannot find where to install these dependencies.

### Steps to Fix:

#### 1. Install the Missing Library:
   - If you have access to a Linux system, you can manually download and install the `libcgraph` library.
     ```bash
     wget https://github.com/graphite-project/libcgraph/releases/download/v0.9.2/libcgraph-0.9.2.tar.gz
     tar xvf libcgraph-0.9.2.tar.gz
     cd libcgraph-0.9.2
     ./configure && make && sudo make install
     ```

   - If you are on a Windows system, you can download the pre-built binaries from the Graphite project's GitHub releases page.

#### 2. Install `pygraphviz` Using Conda:
   - If you prefer to use conda for managing your Python environment, you can create an isolated environment where you can install both `pygraphviz` and its dependencies.
     ```bash
     conda create --name py38 python=3.8
     conda activate py38
     pip install pygraphviz
     ```

#### 3. Install `pygraphviz` Using Pip:
   - If you want to try installing directly with pip, ensure that your system has the necessary dependencies installed.
     ```bash
     sudo apt-get update && sudo apt-get install libgraphite2-dev python3-pip
     pip install pygraphviz
     ```

#### 4. Check Your Python Environment:
   - Ensure you are using a compatible version of Python and pip on your system.

### Summary:
- The root cause is that the `libcgraph` library, which is required by `pygraphviz`, is missing or not properly installed.
- You can either manually install it if you have access to a Linux system, or use conda for an isolated environment where both packages will be available.
