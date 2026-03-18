# borrow of moved value

> error[E0382]: borrow of moved value: `x`
>   --> src/main.rs:5:20
>    |
> 3  |     let x = String::from("hello");
>    |         - move occurs because `x` has type `String`, which does not implement the `Copy` trait
> 4  |     let y = x;
>    |             - value moved here
> 5  |     println!("{}", x);
>    |                    ^ value borrowed here after move

## What happened

You used a value after it was moved to another variable or function. In Rust, when you assign a non-Copy type to another binding, the original binding becomes invalid. This is ownership in action.

## Why it happens

Types that don't implement `Copy` (like `String`, `Vec`, `Box`, and most structs) are moved on assignment. After the move, the original variable is gone. Rust prevents you from using it because the memory it pointed to is now owned by someone else.

## How to fix it

**Clone the value if you need two copies:**

```rust
let x = String::from("hello");
let y = x.clone();
println!("{}", x); // works, x wasn't moved
```

**Use a reference instead of moving:**

```rust
let x = String::from("hello");
let y = &x;          // borrow, don't move
println!("{}", x);   // works
println!("{}", y);   // also works
```

**For function arguments, pass a reference:**

```rust
fn print_it(s: &str) {
    println!("{}", s);
}

let x = String::from("hello");
print_it(&x);       // borrow
println!("{}", x);   // still valid
```

**If your struct should be copyable:**

```rust
#[derive(Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}
// Now Point is copied, not moved, on assignment
```

Note: `Copy` only works for types whose fields are all `Copy` (no `String`, `Vec`, etc.).

## Don't do this

- Don't `.clone()` everything to make the compiler happy. It works but can be wasteful. Use references where possible.
- Don't wrap everything in `Rc<RefCell<T>>` as a first resort. That's the escape hatch, not the default.

## Still not working?

- If you need to move a value out of a struct, consider using `Option<T>` and `.take()`.
- For iterators, use `.iter()` (borrows) instead of `.into_iter()` (moves) if you need the collection afterward.
- If fighting the borrow checker in a loop, sometimes restructuring the code to avoid holding references across iterations helps more than any trick.
