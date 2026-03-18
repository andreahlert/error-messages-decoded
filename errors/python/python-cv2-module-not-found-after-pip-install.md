# OpenCV cv2 module not found after pip install

> ModuleNotFoundError: No module named 'cv2'

## What happened
Python cannot find the cv2 module even though you installed it with pip. This usually happens because the system dependency `libGL` (and related libraries) is missing, especially in Docker containers or minimal Linux installs.

## Why it happens
The `opencv-python` package requires system-level shared libraries like `libGL.so` and `libglib-2.0.so` to function. On headless servers or Docker images based on slim/alpine, these libraries are not installed by default. The pip install succeeds but the module fails to import at runtime.

## How to fix it

For Debian/Ubuntu-based systems (including Docker):
```bash
apt-get update && apt-get install -y libgl1-mesa-glx libglib2.0-0
pip install opencv-python-headless
```

For Alpine:
```bash
apk add --no-cache libgl glib
pip install opencv-python-headless
```

If you do not need GUI features (highgui, imshow), use the headless variant which has fewer system dependencies:
```bash
pip uninstall opencv-python
pip install opencv-python-headless
```

## Still not working?
- If you are in a virtual environment, make sure you installed into the correct one: `which python` and `which pip` should point to the same venv.
- On Docker, make sure the `apt-get install` runs before the `pip install` in your Dockerfile.
- If you see `libSM.so` or `libXext.so` errors, install the full set: `apt-get install -y libsm6 libxext6 libxrender-dev`.
