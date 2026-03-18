# the trait 'xxx' is not implemented for 'yyy'

> error[E0277]: the trait bound `MyStruct: Display` is not satisfied
> error[E0277]: the trait `Send` is not implemented for `Rc<String>`

## What happened

You used a type in a context that requires a specific trait, but that type doesn't implement it. This is like a compile-time interface check.

## Why it happens

- You're trying to print a custom type that doesn't implement `Display` or `Debug`
- A function requires a trait bound that your type doesn't satisfy
- You're sending a non-`Send` type across threads
- A library expects `Serialize`/`Deserialize` from serde

## How to fix it

**For `Debug` and `Display`:**

```rust
// Derive Debug for debugging output
#[derive(Debug)]
struct MyStruct {
    name: String,
    value: i32,
}

// Implement Display for user-facing output
use std::fmt;
impl fmt::Display for MyStruct {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}: {}", self.name, self.value)
    }
}
```

**For serde traits:**

```rust
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
struct Config {
    name: String,
    port: u16,
}
```

Make sure `serde` is in your `Cargo.toml` with the `derive` feature:

```toml
[dependencies]
serde = { version = "1", features = ["derive"] }
```

**For `Send` / `Sync` (threading):**

```rust
// Rc is not Send. Use Arc instead for multi-threaded code.
use std::sync::Arc;
let shared = Arc::new(data);
```

## Don't do this

- Don't implement `Send` or `Sync` manually with `unsafe impl`. If the type isn't Send, there's a reason (usually interior pointers or non-thread-safe reference counting).
- Don't derive traits you don't need. Each derive adds compile time.

## Still not working?

- You can only implement a trait for a type if you own either the trait or the type (orphan rule). For foreign types, use the newtype pattern: `struct MyWrapper(ForeignType)`.
- Check if the trait needs to be implemented for a reference: `impl MyTrait for &MyType` vs `impl MyTrait for MyType`.
- For async runtimes (tokio), futures must be `Send`. If you hold a non-Send type across an `.await`, restructure to drop it before the await point.
