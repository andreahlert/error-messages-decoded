# pattern xxx: directory prefix xxx does not contain main module

> pattern mypackage: directory prefix mypackage does not contain main module or its selected dependencies
> go: cannot find main module, but found .git/config in /path/to/project

## What happened

Go can't figure out which module your code belongs to. You're either outside a module (no `go.mod`) or you have a workspace/module configuration issue.

## Why it happens

- No `go.mod` file in the current directory or any parent
- You're inside a Go workspace (`go.work`) but the module isn't listed
- You ran a `go` command from the wrong directory
- The module path in `go.mod` doesn't match your directory structure

## How to fix it

**If you don't have a `go.mod`:**

```bash
go mod init myproject
# or with a full module path
go mod init github.com/username/myproject
```

**If you're using a workspace (`go.work`):**

```bash
# Add the module to the workspace
go work use ./my-module

# Or check the current workspace config
cat go.work
```

**If you're in the wrong directory:**

```bash
# Find where go.mod is
find . -name "go.mod" -type f

# cd to that directory
cd /path/to/module
go build ./...
```

**If the module path doesn't match imports:**

```go
// go.mod says:
// module github.com/user/project

// Your imports must match:
import "github.com/user/project/pkg/utils"
// Not:
import "project/pkg/utils"
```

## Don't do this

- Don't create a `go.mod` in every subdirectory. One module per project is the standard pattern. Multiple modules in one repo is an advanced pattern.
- Don't use `replace` directives as a permanent fix for path issues. They're for temporary local development.

## Still not working?

- Run `go env GOMOD` to see which `go.mod` Go is using (empty means none found).
- If using Go 1.18+ workspaces, check `go env GOWORK` to see if a `go.work` file is active.
- If your module is a v2+, the module path in `go.mod` must end with `/v2` and all imports must include it.
