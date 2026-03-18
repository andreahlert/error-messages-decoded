# IndentationError that makes no sense visually

> IndentationError: unexpected indent

## What happened

Python's parser hit whitespace that doesn't match what it expected. Your code might look perfectly aligned to your eyes, but the bytes tell a different story.

## Why it happens

Tabs and spaces are being mixed. Your editor shows both as the same width, but Python treats a tab as a different character than spaces. One line uses 4 spaces, the next uses a tab. They look identical in most editors but Python sees a mismatch.

This happens constantly when copying code from the web, Stack Overflow, or switching between editors.

## How to fix it

```bash
# Show the invisible characters in the file
cat -A script.py | head -30
# Tabs show as ^I, spaces show as regular spaces

# Convert all tabs to 4 spaces
expand -t 4 script.py > script_fixed.py
mv script_fixed.py script.py
```

In VS Code, click the "Spaces: 4" or "Tab Size: 4" in the bottom bar, select "Convert Indentation to Spaces", and add this to your settings:

```json
"editor.insertSpaces": true,
"editor.detectIndentation": false
```

## Don't do this

- Don't just re-indent the line the error points to. The error location is often one line AFTER the actual problem. Fix the whole file.
- Don't mix tabs and spaces "just this once." It will bite you again.

## Still not working?

If the error says `unexpected indent` on what looks like a normal line, check the line ABOVE it. A missing colon after `if`, `for`, `def`, or `class` causes Python to misinterpret the next line's indentation.

```python
# This causes IndentationError on the print line
if True  # <- missing colon
    print("hello")
```

Run `python -tt script.py` to get warnings about inconsistent tab usage.
