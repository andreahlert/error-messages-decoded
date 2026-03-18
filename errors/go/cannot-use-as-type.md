# cannot use xxx as type yyy in argument

> cannot use myVar (variable of type int) as type string in argument to fmt.Println
> cannot use &MyStruct{} (value of type *MyStruct) as type MyInterface in argument to process

## What happened

You passed a value of the wrong type to a function. Go's type system is strict: no implicit conversions, no type coercion.

## Why it happens

- Passing the wrong type to a function (int where string is expected)
- A struct doesn't implement an interface (missing methods)
- Passing a pointer where a value is expected, or vice versa
- Using a type alias that's not interchangeable with the original

## How to fix it

**For basic type conversions:**

```go
// Wrong
var n int = 42
fmt.Fprintf(w, n) // expects string

// Right: convert explicitly
fmt.Fprintf(w, strconv.Itoa(n))
// Or use the right function
fmt.Fprintf(w, "%d", n)
```

**For interface compliance:**

```go
// The error tells you which method is missing
// Example: "MyStruct does not implement io.Reader (missing Read method)"
type MyStruct struct{}

// Add the missing method with the exact signature
func (m *MyStruct) Read(p []byte) (n int, err error) {
    // implementation
    return 0, nil
}
```

**For pointer vs value receivers:**

```go
// If the interface method has a pointer receiver
func (m *MyStruct) DoSomething() {}

// You must pass a pointer, not a value
var s MyStruct
process(&s) // not process(s)
```

## Don't do this

- Don't use `interface{}` (or `any`) to bypass type checking. Fix the types.
- Don't use `unsafe.Pointer` for type conversions. That's for interop with C, not for convenience.

## Still not working?

- Run `go vet ./...` for more detailed type-checking errors.
- If a struct "should" implement an interface but doesn't, add a compile-time check: `var _ MyInterface = (*MyStruct)(nil)`.
- For generics (Go 1.18+), check your type constraints. The constraint might not include the type you're passing.
