**Root cause:** The files have Windows line endings (CRLF) instead of Unix line endings (LF). Docker's init process can't execute files with CRLF.

This is the most common cause of that specific error. It happens when files are created/edited on Windows or copied from a Windows system.

**Fix:**

Convert all line endings to LF:

```bash
# For the Dockerfile
dos2unix Dockerfile

# For all Python files
find . -name "*.py" -exec dos2unix {} +

# For any shell scripts
find . -name "*.sh" -exec dos2unix {} +
```

If `dos2unix` isn't installed, use this instead:

```bash
# Using sed (works everywhere)
sed -i 's/\r$//' Dockerfile
find . -name "*.py" -exec sed -i 's/\r$//' {} +
find . -name "*.sh" -exec sed -i 's/\r$//' {} +
```

Or in your editor: set line endings to LF (usually a button in the bottom-right of VS Code, or `set fileformat=unix` in vim).

**Additional issue:** Line 108 in `flyte/workflow.py` calls `anthropic.Anthropic()` but doesn't import `anthropic`. Add this at the top:

```python
import anthropic
```

After fixing both issues, rebuild: `docker build -t your-image .`
