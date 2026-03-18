# Pandas SettingWithCopyWarning

> SettingWithCopyWarning: A value is trying to be set on a copy of a slice from a DataFrame

## What happened
You tried to modify a DataFrame using chained indexing (e.g., `df[df['col'] > 5]['other'] = 10`), but Pandas cannot guarantee whether you are modifying the original DataFrame or a temporary copy.

## Why it happens
When you chain index operations like `df[condition][column] = value`, the first operation may return a view or a copy of the data. If it returns a copy, your assignment modifies the copy and the original DataFrame stays unchanged. This is called chained indexing and Pandas warns you because the behavior is ambiguous (view vs copy depends on the internal data layout).

## How to fix it

Use `.loc` for label-based indexing to ensure you modify the original DataFrame:
```python
# Instead of: df[df['status'] == 'active']['score'] = 100
df.loc[df['status'] == 'active', 'score'] = 100
```

If you intentionally want to work on a separate copy, make it explicit with `.copy()`:
```python
filtered = df[df['status'] == 'active'].copy()
filtered['score'] = 100  # no warning, modifying the copy intentionally
```

## Still not working?
- With multiple conditions, wrap them properly: `df.loc[(df['a'] > 1) & (df['b'] < 5), 'c'] = 0`
- In Pandas 3.0+, chained assignment will raise an error instead of a warning, so it is best to fix this now.
- If you are receiving a slice from a function, call `.copy()` on it before modifying: `subset = get_data().copy()`.
