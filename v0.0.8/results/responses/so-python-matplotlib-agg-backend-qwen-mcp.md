The error message "UserWarning: Matplotlib is currently using agg, which is a non-GUI backend, so cannot show the figure." indicates that you are trying to display a matplotlib plot but your system does not have a GUI (Graphical User Interface) installed.

Here's how you can fix it:

### 1. Install `matplotlib` with `--no-default-examples` Option
If you don't want to install additional packages, you can use the following command:
```bash
pip install matplotlib --no-default-examples
```
This will ensure that only the necessary components of Matplotlib are installed.

### 2. Use a GUI Backend
You can force Matplotlib to use a GUI backend by setting `matplotlib.use('TkAgg')` or any other backend you prefer (like `'Qt5Agg'`, `'GTK3Agg'`, etc.). Here's how:

```python
import matplotlib.pyplot as plt

# Force the use of a specific backend
plt.switch_backend('TkAgg')

# Now try to show your plot
plt.plot([1, 2, 3])
```

### 3. Install `matplotlib` with `--no-default-examples` Option and Use `matplotlib.use()`
If you want to install additional packages but still use a non-GUI backend, you can do:

```bash
pip install matplotlib --no-default-examples
plt.switch_backend('TkAgg')  # or any other backend you prefer
```

### 4. Install Additional Packages (Optional)
If you need more features of Matplotlib and don't want to use a GUI backend, you might consider installing additional packages:

```bash
pip install matplotlib pillow
```
This will allow you to use `matplotlib` with non-GUI backends like `'TkAgg'`, `'Qt5Agg'`, etc.

### 5. Check Your Environment
Ensure that your Python environment is set up correctly and that the necessary libraries are installed. You can check this by running:

```bash
pip list | grep matplotlib
```

If `matplotlib` is not listed, you might need to install it again or reinstall additional packages as needed.

### 6. Use a Virtual Environment (Optional)
If you're working in a virtual environment, make sure that the environment is activated and all necessary packages are installed there:

```bash
source venv/bin/activate  # On Unix-based systems
```

By following these steps, you should be able to display your Matplotlib plots without encountering the "non-GUI backend" warning.
