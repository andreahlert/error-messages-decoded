# UnicodeDecodeError when reading a file

> UnicodeDecodeError: 'utf-8' codec can't decode byte 0xff in position 0: invalid start byte

## What happened

You opened a file assuming it's UTF-8, but it's encoded in something else (Latin-1, Windows-1252, UTF-16) or it's a binary file and not text at all.

## Why it happens

`open('file.csv')` defaults to UTF-8 on most systems. If the file was exported from Excel, legacy Windows software, or a database with a different encoding, those bytes aren't valid UTF-8. The `0xff` or `0xe9` byte in the error is the clue.

## How to fix it

```bash
# Detect the encoding
file -bi data.csv
# Output like: text/plain; charset=iso-8859-1

# Or use Python
pip install chardet
python -c "
import chardet
with open('data.csv', 'rb') as f:
    result = chardet.detect(f.read(10000))
    print(result)
"
```

Then open with the correct encoding:

```python
# Use the detected encoding
with open('data.csv', encoding='latin-1') as f:
    content = f.read()

# If you just need it to work and can tolerate some data loss
with open('data.csv', encoding='utf-8', errors='replace') as f:
    content = f.read()
```

## Don't do this

- `errors='ignore'` silently drops characters. You'll get corrupted data and not know until much later.
- Don't convert the whole file to UTF-8 with `iconv` if you're not sure of the source encoding. Garbage in, garbage out.

## Still not working?

If `0xff 0xfe` are the first two bytes, the file is UTF-16 (common with PowerShell output):

```python
with open('file.txt', encoding='utf-16') as f:
    content = f.read()
```

If it's a `.csv` from Excel, try `encoding='cp1252'` first. If the file is actually binary (images, PDFs, pickle files), open it in binary mode with `'rb'` instead.
