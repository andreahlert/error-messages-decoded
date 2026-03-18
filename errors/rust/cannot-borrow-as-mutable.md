# cannot borrow as mutable

> error[E0596]: cannot borrow `x` as mutable, as it is not declared as mutable
> error[E0502]: cannot borrow `x` as mutable because it is also borrowed as immutable

## What happened

You tried to mutate something that Rust's borrow checker won't allow. Either the variable isn't declared `mut`, or there's already an immutable reference alive.

## Why it happens

Rust's core borrowing rule: you can have either ONE mutable reference OR any number of immutable references, but not both at the same time. This prevents data races at compile time.

## How to fix it

**If the variable isn't declared as mutable:**

```rust
// Wrong
let v = vec![1, 2, 3];
v.push(4); // error: cannot borrow as mutable

// Right
let mut v = vec![1, 2, 3];
v.push(4); // works
```

**If you have conflicting borrows, restructure the code:**

```rust
// Wrong: immutable and mutable borrow overlap
let mut v = vec![1, 2, 3];
let first = &v[0];    // immutable borrow
v.push(4);             // mutable borrow while immutable exists
println!("{}", first); // immutable borrow used here

// Right: finish using the immutable borrow first
let mut v = vec![1, 2, 3];
let first = v[0];     // copy the value (i32 is Copy)
v.push(4);            // no conflict
println!("{}", first);
```

**For methods that need `&mut self`:**

```rust
// Wrong
fn update(&self) {
    self.count += 1; // error: cannot borrow as mutable
}

// Right
fn update(&mut self) {
    self.count += 1;
}
```

**When you need interior mutability:**

```rust
use std::cell::RefCell;

let data = RefCell::new(vec![1, 2, 3]);
data.borrow_mut().push(4); // mutable access through shared reference
```

## Don't do this

- Don't reach for `RefCell` or `Mutex` immediately. Usually restructuring the code to avoid overlapping borrows is cleaner.
- Don't clone values just to avoid borrow conflicts. Fix the ordering of borrows first.

## Still not working?

- NLL (Non-Lexical Lifetimes) means borrows end at their last use, not at the end of the scope. If you're on a recent Rust edition, check if reordering lines fixes it.
- For struct methods that need to borrow different fields, split the borrow: `let (a, b) = (&mut self.field_a, &self.field_b)`.
- In async code, consider `Arc<Mutex<T>>` for shared mutable state across tasks.
