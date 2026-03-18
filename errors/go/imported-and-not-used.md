# imported and not used

> ./main.go:4:2: "fmt" imported and not used
> ./main.go:5:2: "os" imported and not used

## What happened

You imported a package but didn't use anything from it. Go treats this as a compile error, not a warning. Your code won't compile until you either use the import or remove it.

## Why it happens

- You removed the code that used the package but forgot to remove the import
- You're in the middle of writing code and haven't used the import yet
- You imported a package for its side effects but didn't use the blank identifier

## How to fix it

**Remove the unused import (preferred):**

Just delete the import line. Most editors do this automatically on save.

**If you need it temporarily during development:**

```go
import "fmt"

var _ = fmt.Println // blank identifier trick
```

**If the import is for side effects (like database drivers):**

```go
import (
    "database/sql"
    _ "github.com/lib/pq"  // blank import for side effects
)
```

**Use `goimports` to manage imports automatically:**

```bash
# Install
go install golang.org/x/tools/cmd/goimports@latest

# Run on your file
goimports -w main.go

# Or configure your editor to run it on save
```

## Don't do this

- Don't keep unused imports with blank identifier tricks in production code. Clean them up.
- Don't disable this check. It's a feature, not a bug. It keeps your dependency graph clean.

## Still not working?

- If your editor keeps adding imports back, check the goimports/gopls configuration.
- In VS Code with the Go extension, imports are managed automatically on save. Make sure `"editor.formatOnSave": true` and `"go.formatTool": "goimports"` are set.
