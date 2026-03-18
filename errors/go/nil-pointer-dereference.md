# runtime error: invalid memory address or nil pointer dereference

> goroutine 1 [running]:
> runtime error: invalid memory address or nil pointer dereference
> [signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x...]

## What happened

Your program tried to use a pointer that's `nil`. This is a runtime panic, meaning Go can't catch it at compile time. The stack trace tells you exactly where it happened.

## Why it happens

- Accessing a field or method on a nil struct pointer
- Using a map that was declared but not initialized (`var m map[string]int` is nil)
- A function returned `nil` and you didn't check before using it
- Accessing an interface value that's nil

## How to fix it

**Check the stack trace to find the exact line, then add a nil check:**

```go
// Wrong
user := getUser(id) // might return nil
fmt.Println(user.Name) // panic if nil

// Right
user := getUser(id)
if user == nil {
    return fmt.Errorf("user %d not found", id)
}
fmt.Println(user.Name)
```

**Initialize maps before using them:**

```go
// Wrong
var m map[string]int
m["key"] = 1 // panic: assignment to entry in nil map

// Right
m := make(map[string]int)
m["key"] = 1
```

**Initialize struct fields that are pointers or maps:**

```go
type Config struct {
    Options map[string]string
}

// Wrong
c := &Config{}
c.Options["key"] = "value" // panic

// Right
c := &Config{
    Options: make(map[string]string),
}
```

## Don't do this

- Don't use `recover()` to catch nil pointer panics as a normal error handling strategy. Fix the nil check.
- Don't initialize everything to empty structs just to avoid nil. Nil has meaning (absence of value), and hiding it causes different bugs.

## Still not working?

- Read the stack trace bottom to top. The last frame in YOUR code (not runtime) is where the nil dereference happened.
- If the panic is in a goroutine, the stack trace might be from a different goroutine than you expect. Check goroutine IDs.
- Use `go vet ./...` and `staticcheck ./...` to find potential nil dereferences before runtime.
- For interfaces, remember that an interface holding a nil pointer is NOT a nil interface. `var p *MyStruct = nil; var i MyInterface = p; i != nil // true!`
