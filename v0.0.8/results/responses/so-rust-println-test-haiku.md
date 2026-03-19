## Root Cause

Rust's test runner **captures stdout by default**. When a test passes, all `println!` output is discarded. This is intentional—it keeps test output clean when running many tests.

## Fix

Run tests with the `--nocapture` flag to see `println!` output:

```bash
cargo test -- --nocapture
```

Or if running a specific test:

```bash
cargo test test_name -- --nocapture
```

The `--` separates Cargo arguments from test runner arguments, so `--nocapture` goes to the test binary, not Cargo.

## Alternative: Use `eprintln!`

If you want output that *always* appears regardless of the flag, use `eprintln!` instead of `println!`. It writes to stderr, which the test runner doesn't capture:

```rust
#[test]
fn my_test() {
    eprintln!("This always shows");
}
```

This is useful for debugging output you always want to see, but generally `println! + --nocapture` is the standard approach for test output.
