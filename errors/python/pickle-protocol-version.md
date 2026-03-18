# Unsupported pickle protocol version

> ValueError: unsupported pickle protocol: 5

## What happened

You're trying to load a pickled file that was created with a newer Python version than the one you're running. The pickle format used a protocol version your Python doesn't support.

## Why it happens

Each Python version supports pickle protocols up to a certain version:

| Python version | Max pickle protocol |
|---|---|
| 3.4-3.7 | 4 |
| 3.8+ | 5 |

Protocol 5 was introduced in Python 3.8 with PEP 574, adding efficient handling of large binary data (out-of-band buffers). If someone serialized data with Python 3.8+ using the default protocol (which auto-selects the highest available), and you try to load it on Python 3.7 or earlier, you get this error.

This commonly happens when:

- A model file (ML pipeline) was trained on a newer Python and deployed to an environment with an older one
- A cache file was written by a CI server with a different Python than development machines
- Sharing `.pkl` files between team members with different Python versions

## How to fix it

**Option 1: Upgrade Python to 3.8+ (recommended):**

```bash
# Check your current version
python3 --version

# Install Python 3.8+ (Ubuntu/Debian)
sudo apt update && sudo apt install python3.10

# Or use pyenv
pyenv install 3.10.12
pyenv local 3.10.12
```

**Option 2: Re-create the pickle with a compatible protocol:**

On the machine that created the pickle (Python 3.8+):

```python
import pickle

# Load the existing pickle
with open('model.pkl', 'rb') as f:
    obj = pickle.load(f)

# Save with protocol 4 (compatible with Python 3.4+)
with open('model_compat.pkl', 'wb') as f:
    pickle.dump(obj, f, protocol=4)
```

For numpy arrays or scikit-learn models:

```python
import joblib

# If the original was saved with joblib
model = joblib.load('model.pkl')

# Re-save with compatible protocol
joblib.dump(model, 'model_compat.pkl', protocol=4)
```

**Option 3: If you can't access the original Python 3.8+ environment, use `pickle5` backport on Python 3.6-3.7:**

```bash
pip install pickle5
```

```python
# Python 3.6 or 3.7 only
import pickle5 as pickle

with open('model.pkl', 'rb') as f:
    obj = pickle.load(f)
```

**Option 4: Set a default protocol in your codebase to prevent this in the future:**

```python
import pickle
import functools

# Force protocol 4 everywhere
pickle.dump = functools.partial(pickle.dump, protocol=4)

# Or use an environment-aware approach
PICKLE_PROTOCOL = min(pickle.HIGHEST_PROTOCOL, 4)

with open('data.pkl', 'wb') as f:
    pickle.dump(data, f, protocol=PICKLE_PROTOCOL)
```

## Don't do this

- Don't just try loading the file again. The protocol version is in the file header and won't change.
- Don't edit the pickle file's bytes to change the protocol version. Pickle formats are not interchangeable by changing a header byte.
- Don't rely on pickle for long-term storage or cross-version compatibility. Use JSON, Parquet, or format-specific serializers (ONNX for ML models, Arrow for DataFrames).

## Still not working?

If you're using pickle indirectly through another library, check where the pickle is being created:

```python
# Common libraries that use pickle internally:
# - scikit-learn: joblib.dump / joblib.load
# - pandas: DataFrame.to_pickle / pd.read_pickle
# - PyTorch: torch.save / torch.load
# - TensorFlow/Keras: model.save (HDF5 is safer)

# For pandas, use a version-safe format instead:
df.to_parquet('data.parquet')  # instead of df.to_pickle()

# For PyTorch, use the _use_new_zipfile_serialization parameter:
torch.save(model.state_dict(), 'model.pt')

# For scikit-learn, pin the protocol in joblib:
joblib.dump(model, 'model.pkl', protocol=4)
```

To check the protocol version of a pickle file without loading it:

```python
with open('data.pkl', 'rb') as f:
    # Read the first two bytes: opcode and protocol number
    header = f.read(2)
    print(f"Pickle protocol: {header[1]}")
```
