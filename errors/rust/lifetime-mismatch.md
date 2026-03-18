# lifetime mismatch / does not live long enough

> error[E0597]: `x` does not live long enough
> error[E0623]: lifetime mismatch
> error: lifetime may not live long enough

## What happened

A reference outlives the data it points to. Rust caught a dangling reference at compile time, which in C/C++ would be a use-after-free bug.

## Why it happens

You're returning or storing a reference to something that gets dropped (freed) before the reference is done being used. The most common case: returning a reference to a local variable.

## How to fix it

**Don't return references to local data, return owned values:**

```rust
// Wrong: data is dropped at end of function
fn make_string() -> &str {
    let s = String::from("hello");
    &s  // error: s doesn't live long enough
}

// Right: return the owned value
fn make_string() -> String {
    String::from("hello")
}
```

**When storing references in structs, add lifetime annotations:**

```rust
// This tells Rust: the struct can't outlive the data it references
struct Parser<'a> {
    input: &'a str,
}

impl<'a> Parser<'a> {
    fn new(input: &'a str) -> Self {
        Parser { input }
    }
}
```

**When two references need the same lifetime:**

```rust
// Wrong: Rust can't figure out which lifetime the return has
fn longest(a: &str, b: &str) -> &str { ... }

// Right: explicit lifetime ties input and output together
fn longest<'a>(a: &'a str, b: &'a str) -> &'a str {
    if a.len() > b.len() { a } else { b }
}
```

## Don't do this

- Don't add `'static` to everything. `'static` means the data lives forever, which is rarely true and forces you into leaked memory or global state.
- Don't `Box::leak()` values to get `'static` references. That's a real memory leak.

## Still not working?

- If lifetimes are getting complex, consider if you should own the data instead of borrowing it. `String` instead of `&str`, `Vec<T>` instead of `&[T]`.
- For self-referential structs (a struct that borrows from itself), look into the `pin` module or crates like `ouroboros` or `self_cell`.
- Async functions with references are particularly tricky. If a future borrows data, the data must live as long as the future. Consider `.to_owned()` or `Arc`.
