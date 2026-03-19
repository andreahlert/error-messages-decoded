The error message "UserWarning: Matplotlib is currently using agg, which is a non-GUI backend, so cannot show the figure." indicates that you are trying to display a matplotlib plot but your system does not have a GUI (Graphical User Interface) installed.

Here's how you can fix it:

### 1. Install `matplotlib` with a GUI backend
If you want to see the plots in a window, you need to install a GUI backend for Matplotlib. The most common backends are `TkAgg`, `Qt5Agg`, and `WXAgg`.

```bash
pip install matplotlib==3.4.2 --upgrade
```

This command installs an older version of Matplotlib that includes the `TkAgg` backend, which is a GUI backend.

### 2. Check your current backend
You can check what backend Matplotlib is currently using with:

```python
import matplotlib.pyplot as plt

plt.gcf().canvas.get_supported_backends()
```

This will show you the backends that are available on your system.

### 3. Change the backend to a GUI backend
If `TkAgg` is not listed, you can change it by setting the backend:

```python
import matplotlib.pyplot as plt

plt.switch_backend('TkAgg')
```

Or if you want to use another backend like `Qt5Agg`, you would do:

```python
plt.switch_backend('Qt5Agg')
```

### 4. Run your script again
After changing the backend, run your script again and it should display the plot.

### Additional Notes:
- If you're using a Jupyter notebook or a similar environment where Matplotlib is typically not installed globally, you might need to install `matplotlib` in that specific environment.
  
```bash
pip install matplotlib --user
```

This installs Matplotlib for your user directory, which can be useful if you want to run scripts outside of the Python interpreter.

- If you're using a virtual environment and don't have `matplotlib` installed there, you'll need to activate it first:

```bash
source venv/bin/activate  # For Unix/Linux/MacOS
venv\Scripts\activate       # For Windows
```

Then install Matplotlib in the activated environment.

By following these steps, you should be able to display your matplotlib plots without encountering the "non-GUI backend" warning.
