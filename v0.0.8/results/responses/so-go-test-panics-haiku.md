In Go, testing panics requires using `defer` and `recover()` to catch the panic. Here's the standard pattern:

```go
func TestFunctionPanics(t *testing.T) {
    defer func() {
        if r := recover(); r == nil {
            t.Error("expected a panic, but function completed normally")
        }
    }()
    
    // Call the function that should panic
    functionThatPanics()
}
```

**Key points:**

1. **Defer runs after panic**: The `defer` block executes even when a panic occurs, allowing `recover()` to catch it
2. **recover() returns nil if no panic**: So `r == nil` means no panic happened, which is a test failure
3. **recover() stops the panic**: Once called, it prevents the panic from crashing the test

**For checking the panic message:**

```go
func TestPanicMessage(t *testing.T) {
    defer func() {
        if r := recover(); r != nil {
            if msg, ok := r.(string); ok && msg == "expected error" {
                return // test passes
            }
            t.Errorf("unexpected panic: %v", r)
        } else {
            t.Error("expected a panic")
        }
    }()
    
    functionThatPanics()
}
```

**Alternative: Using testify (if available):**

```go
import "github.com/stretchr/testify/assert"

func TestWithTestify(t *testing.T) {
    assert.Panics(t, func() {
        functionThatPanics()
    })
}
```

The `defer/recover()` approach is the idiomatic Go way and has no external dependencies.
