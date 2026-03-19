## Root Cause

When a channel is closed, **reading from it never blocks** — it immediately returns the zero value and `false` for the ok flag. If you don't check that `ok` value, you're stuck in a busy loop where the `select` keeps firing the same case repeatedly with garbage data.

**Example of the problem:**

```go
for {
    select {
    case val := <-ch1:  // If ch1 is closed, this keeps returning (0, false)
        println(val)    // Prints 0 forever
    case val := <-ch2:
        println(val)
    }
}
```

## How to Fix It

Set closed channels to `nil` so they're never selected again:

```go
for {
    select {
    case val, ok := <-ch1:
        if !ok {
            ch1 = nil  // Prevent this case from being selected
            break      // Exit if both channels are nil
        }
        process(val)
    case val, ok := <-ch2:
        if !ok {
            ch2 = nil
            break
        }
        process(val)
    }
    
    if ch1 == nil && ch2 == nil {
        break
    }
}
```

Or use a cleaner approach with a WaitGroup if you're managing multiple goroutines — let them signal completion rather than managing channel states manually.

**Key point:** Always check the `ok` value when receiving from channels in a select loop. If `ok` is false, either set that channel to `nil` or exit entirely.
