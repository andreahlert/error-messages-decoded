# Python UnicodeDecodeError on CSV with BOM or non-UTF-8 encoding

> UnicodeDecodeError: 'utf-8' codec can't decode byte 0xff in position 0: invalid start byte

## What happened
Python tried to read a file as UTF-8 but the file uses a different encoding. The byte `0xff` at position 0 is a strong indicator the file is encoded as UTF-16 (with a BOM) or another non-UTF-8 encoding like Latin-1 or CP1252.

## Why it happens
Many tools (especially Excel on Windows) save CSV files with encodings like UTF-16, CP1252, or Latin-1 instead of UTF-8. The byte `0xff` at position 0 is the start of a UTF-16 BOM (Byte Order Mark: `0xff 0xfe`). Python defaults to UTF-8 and fails immediately when it encounters these bytes.

## How to fix it

Use the `chardet` library to detect the encoding automatically:
```python
import chardet

with open('data.csv', 'rb') as f:
    result = chardet.detect(f.read(10000))
    print(result['encoding'])

import pandas as pd
df = pd.read_csv('data.csv', encoding=result['encoding'])
```

If you know the file is from Excel/Windows, try common encodings:
```python
# For UTF-16 with BOM (byte 0xff at position 0)
df = pd.read_csv('data.csv', encoding='utf-16')

# For Western European Windows encoding
df = pd.read_csv('data.csv', encoding='cp1252')

# For Latin-1 (accepts any byte value, never fails)
df = pd.read_csv('data.csv', encoding='latin-1')
```

For UTF-8 files with BOM (byte `0xef 0xbb 0xbf`):
```python
df = pd.read_csv('data.csv', encoding='utf-8-sig')
```

## Still not working?
- Install chardet: `pip install chardet` for reliable detection.
- If the file has mixed encodings (corrupted), use `errors='ignore'` as a last resort: `open('data.csv', encoding='utf-8', errors='ignore')`.
- Check the first bytes of the file: `head -c 4 data.csv | xxd` to see the BOM signature.
