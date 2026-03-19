# Root Cause

Go **intentionally has no way to check if a channel is closed without reading from it**. This is by design because:

1. Any check is racy — the channel could close immediately after you check it
2. Only the **sender** should close a channel (receivers must never close)
3. Reading is the safe, synchronous way to detect closure

# How to Fix

Use one of these patterns instead:

## 1. Read with comma-ok (receiver detects closure)
```go
val, ok := <-ch
if !ok {
    // channel is closed
}
```

## 2. Use a separate "done" channel (sender signals completion)
```go
select {
case <-done:
    // sender closed the done channel
case val := <-ch:
    // got a value
}
```

## 3. Use context for cancellation
```go
select {
case <-ctx.Done():
    // context cancelled
case val := <-ch:
    // got a value
}
```

## 4. Refactor to avoid checking at all
The real fix is often **redesigning** so you don't need to check. Send a sentinel value, close the channel normally, or use the patterns above.

**Never do this:**
- ❌ Try to read just to check (consumes a value)
- ❌ Close from the receiver side (panics)
- ❌ Expect reliable status checks (they're racy by nature)

Which pattern fits your use case? That'll determine the best fix.
