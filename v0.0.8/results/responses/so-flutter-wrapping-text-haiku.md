# Flutter Text Overflow/Wrapping Issue

**Root cause:** The `Text` widget has no constrained width, so it expands infinitely and overflows instead of wrapping.

By default, Flutter's `Text` tries to occupy as much horizontal space as needed. Without a parent widget that constrains its width, the text doesn't know when to wrap.

## Fixes (pick one)

**1. Wrap in `SizedBox` with fixed width:**
```dart
SizedBox(
  width: 200,
  child: Text('Your long text here'),
)
```

**2. Wrap in `Container` with width:**
```dart
Container(
  width: 200,
  child: Text('Your long text here'),
)
```

**3. Use `Expanded` for flexible width:**
```dart
Row(
  children: [
    Expanded(
      child: Text('Your long text here'),
    ),
  ],
)
```

**4. Use `Flexible`:**
```dart
Flexible(
  child: Text('Your long text here'),
)
```

**Note on `softWrap`:** Setting `softWrap: true` on `Text` alone won't fix it — you still need width constraints. However, you can use it alongside `overflow: TextOverflow.ellipsis` if you want to truncate instead of wrap:

```dart
Text(
  'Your long text',
  softWrap: true,
  overflow: TextOverflow.ellipsis,
)
```

The most common scenario: if you're in a `Row` and text overflows, wrap it in `Expanded` or `Flexible`.
