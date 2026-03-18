In Go, test panics using a **deferred recovery function** that catches the panic with `recover()`. Here's how:

```go
func TestPanic(t *testing.T) {
    defer func() {
        if r := recover(); r == nil {
            t.Errorf("expected panic, but got none")
        }
    }()
    
    // Call the function that should panic
    myFunctionThatPanics()
}
```

**If you need to verify the panic message:**

```go
func TestPanicWithMessage(t *testing.T) {
    defer func() {
        if r := recover(); r != "specific panic message" {
            t.Errorf("expected panic with 'specific panic message', got %v", r)
        }
    }()
    
    myFunctionThatPanics()
}
```

**Key points:**

- The deferred function runs *after* the panic, allowing `recover()` to catch it
- `recover()` returns `nil` if no panic occurred, or the panic value if one did
- If you don't call `recover()` in the deferred function, the panic will still crash the test
- The panic value is typically a string, but can be any type (check the function's documentation)

**For cleaner tests, create a helper:**

```go
func expectPanic(t *testing.T, fn func()) {
    defer func() {
        if r := recover(); r == nil {
            t.Error("expected panic")
        }
    }()
    fn()
}

// Usage:
func TestMyPanic(t *testing.T) {
    expectPanic(t, myFunctionThatPanics)
}
```

What specific panic are you testing?
