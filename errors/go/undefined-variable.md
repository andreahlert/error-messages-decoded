# undefined: xxx

> ./main.go:15:2: undefined: myFunc
> ./main.go:10:5: undefined: MyStruct

## What happened

The Go compiler can't find the variable, function, or type you're referencing. It's not declared in the current scope.

## Why it happens

- The function/type is in a different file but you're running `go run main.go` instead of `go run .`
- You forgot to export it (lowercase first letter means unexported)
- Typo in the name
- The declaration is in a different package and you didn't import it

## How to fix it

**If you have multiple files in the same package:**

```bash
# WRONG: only compiles main.go
go run main.go

# RIGHT: compiles all .go files in the directory
go run .
```

**If it's in another package, import it:**

```go
import "mymodule/mypackage"

func main() {
    mypackage.MyFunc() // exported (uppercase)
}
```

**If you're accessing an unexported identifier:**

```go
// In package "utils"
func helper() {} // unexported, can't be used outside utils
func Helper() {} // exported, accessible from other packages
```

**If using go build/test:**

```bash
# Make sure all files are included
go build ./...
go test ./...
```

## Don't do this

- Don't put all code in `main.go` to avoid this. Use packages properly.
- Don't copy-paste the function into the same file. Fix the build command or import.

## Still not working?

- Check your `go.mod` file. If the module path is wrong, imports won't resolve.
- If using `_test.go` files, remember that `xxx_test` package can't access unexported identifiers from `xxx` package. Use `xxx` as the package name in test files for internal testing.
- Run `go vet ./...` for more detailed diagnostics.
