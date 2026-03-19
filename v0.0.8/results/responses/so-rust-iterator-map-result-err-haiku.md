# Root Cause

`Iterator::map` doesn't short-circuit on error — it transforms every element regardless. When your closure returns `Result::Err`, it just gets wrapped in the iterator as an `Err` variant and iteration continues.

# Solution

Use `.collect()` with a `Result` type annotation. The `FromIterator` implementation for `Result<Vec<T>, E>` automatically stops iteration at the first error:

```rust
let result: Result<Vec<i32>, String> = items.iter()
    .map(|x| {
        if x == 2 {
            Err("error".to_string())
        } else {
            Ok(x * 2)
        }
    })
    .collect();

match result {
    Ok(values) => println!("Success: {:?}", values),
    Err(e) => println!("Error: {}", e),
}
```

When the iterator encounters the first `Err`, `.collect()` immediately stops and returns that error without processing remaining elements.

**Alternative approaches** if you need more control:

- **`try_fold()`** for custom accumulation with early exit:
  ```rust
  items.iter().try_fold(vec![], |mut acc, x| {
      acc.push(process(x)?);  // ? stops on error
      Ok(acc)
  })
  ```

- **`find_map()`** if you only need the first error or matching value:
  ```rust
  items.iter().find_map(|x| process(x).err())
  ```

The `.collect()` pattern is idiomatic Rust and the most readable for this use case.
