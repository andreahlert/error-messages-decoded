## Root Cause

Go slices are **not thread-safe**. When multiple goroutines append simultaneously, they can corrupt the slice's internal header (pointer, length, capacity) or write to overlapping memory locations. The append operation isn't atomic — it involves checking capacity, potentially reallocating, and writing the value.

## Fixes

**1. Mutex (simplest, if you need shared slice)**
```go
var mu sync.Mutex
var results []string

// In each goroutine:
mu.Lock()
results = append(results, value)
mu.Unlock()
```

**2. Channels (idiomatic Go)**
```go
resultsChan := make(chan string)
go func() {
    resultsChan <- value
}()

// Main goroutine collects:
var results []string
for value := range resultsChan {
    results = append(results, value)
}
```

**3. Pre-allocated slice + atomic index (best performance)**
```go
results := make([]string, numGoroutines)
var idx int64

// In each goroutine:
i := atomic.AddInt64(&idx, 1) - 1
results[i] = value
```

**Use #2 (channels) for most cases** — it's the Go way and avoids the shared-state problem entirely. Use #1 only if you specifically need to append variable amounts from many goroutines. Use #3 when you know goroutine count upfront and need maximum performance.
