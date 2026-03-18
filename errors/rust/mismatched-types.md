# mismatched types: expected xxx, found yyy

> error[E0308]: mismatched types
>   --> src/main.rs:5:20
>    |
> 5  |     let x: u32 = "hello";
>    |            ---   ^^^^^^^ expected `u32`, found `&str`
>    |            |
>    |            expected due to this

## What happened

You have a type mismatch. The compiler expected one type and got another. Rust has no implicit type conversions, so even `i32` to `i64` needs an explicit cast.

## Why it happens

- Returning the wrong type from a function or match arm
- Assigning a value of the wrong type
- Mixing integer types (i32 vs u32 vs usize)
- Forgetting to unwrap a `Result` or `Option`
- Missing a reference (`&`) or dereference (`*`)

## How to fix it

**For numeric type mismatches, cast explicitly:**

```rust
let x: i32 = 42;
let y: i64 = x as i64;
let z: usize = x as usize;
```

**For `Result` or `Option` wrapping:**

```rust
// Wrong: function returns Result but you return a plain value
fn get_value() -> Result<i32, Error> {
    42  // error: expected Result, found i32
}

// Right
fn get_value() -> Result<i32, Error> {
    Ok(42)
}
```

**For reference mismatches:**

```rust
// Wrong
fn process(s: &str) {}
let owned = String::from("hello");
process(owned);  // expected &str, found String

// Right
process(&owned);  // &String auto-derefs to &str
```

**For match arms returning different types:**

```rust
// Wrong: arms return different types
let val = match x {
    1 => "one",     // &str
    _ => String::from("other"), // String
};

// Right: make them consistent
let val = match x {
    1 => String::from("one"),
    _ => String::from("other"),
};
```

## Don't do this

- Don't use `as` casts for everything without thinking. `u32 as i32` can silently overflow. Use `.try_into()` for safe conversion.
- Don't use `transmute` to force type conversions. That's undefined behavior waiting to happen.

## Still not working?

- If the error mentions `()` (unit type), you probably forgot a return value or have a trailing semicolon on the last expression in a function.
- For closures, the compiler infers types from the first use. If there's a conflict, add explicit type annotations to the closure parameters.
- Use `.into()` for types that implement `From`/`Into` conversions: `let s: String = "hello".into()`.
