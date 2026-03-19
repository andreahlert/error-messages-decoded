# Root Cause

Rust strings are **UTF-8 encoded**, not arrays of characters. Characters can be 1–4 bytes long. If Rust allowed `string[0]`, you might accidentally split a multi-byte character (e.g., emoji, accented letters), causing undefined behavior. So Rust deliberately **does not implement `Index<usize>` for `String` or `&str`**.

# Fixes

**Get the nth character:**
```rust
let s = "hello";
let c = s.chars().nth(0);  // Option<char>
```

**Get the nth byte (if you really need it):**
```rust
let s = "hello";
let b = s.as_bytes()[0];  // u8
```

**Slice a substring by byte range** (but know the UTF-8 boundaries):
```rust
let s = "hello";
let sub = &s[0..2];  // "he" — you must use valid UTF-8 boundaries
```

**Iterate instead of indexing** (preferred):
```rust
let s = "hello";
for c in s.chars() {
    println!("{}", c);
}
```

The key insight: use **`.chars()`** for characters, **`.as_bytes()`** for raw bytes, and **slicing `&s[a..b]`** only if you know the byte indices are valid UTF-8 boundaries.
